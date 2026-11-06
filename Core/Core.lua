-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - Core
--
-- Since v5.0 the addon no longer replaces or copies the World Map's built-in
-- tracking / filter menu. Instead it adds its own independent World Map button
-- (positioned by Krowi_WorldMapButtons) which opens a menu built with the
-- Blizzard Menu API (Blizzard_Menu / MenuUtil). Each supported map addon is a
-- module that adds its own entries to that menu.
-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
local _G = getfenv(0)
local ipairs, type, select, unpack = _G.ipairs, _G.type, _G.select, _G.unpack
local tinsert, sort = _G.table.insert, _G.table.sort
local format = _G.string.format
local xpcall, geterrorhandler = _G.xpcall, _G.geterrorhandler

-- WoW API
local C_AddOns = _G.C_AddOns
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local GetAddOnInfo = C_AddOns and C_AddOns.GetAddOnInfo or _G.GetAddOnInfo
local InCombatLockdown = _G.InCombatLockdown
local HideUIPanel = _G.HideUIPanel

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local AceDB = LibStub("AceDB-3.0")
local Client = private.Client

local addon = LibStub("AceAddon-3.0"):NewAddon(private.addon_name, "AceEvent-3.0", "AceConsole-3.0")
addon.constants = private.constants
addon.constants.addon_name = private.addon_name
addon.Client = Client
addon.Name = FOLDER_NAME
addon.LocName = select(2, GetAddOnInfo(addon.Name)) or "World Map Tracking Enhanced"
addon.Notes = select(3, GetAddOnInfo(addon.Name)) or ""
_G.WorldMapTrackingEnhanced = addon

-- ToC Metadata
addon.Version = GetAddOnMetadata(addon.Name, "Version") or ""
addon.UpdateDate = GetAddOnMetadata(addon.Name, "X-Date") or ""
addon.Author = GetAddOnMetadata(addon.Name, "Author") or ""

-- The tracking modules are AceAddon modules with a few extra fields, see
-- addon:NewTrackingModule() below. They are kept in this list for ordering.
addon.trackingModules = {}

local profile

-- ----------------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------------

-- Returns true when any of the given addons is loaded
function addon:IsAnyAddOnLoaded(...)
	for i = 1, select("#", ...) do
		local name = select(i, ...)
		if name and IsAddOnLoaded(name) then
			return true
		end
	end
	return false
end

-- Close the World Map if it is shown; used before opening another addon's UI
function addon:CloseWorldMap()
	local WorldMapFrame = _G.WorldMapFrame
	if WorldMapFrame and WorldMapFrame:IsShown() then
		HideUIPanel(WorldMapFrame)
	end
end

-- Refresh the World Map pins after changing another addon's settings
function addon:RefreshWorldMap()
	local WorldMapFrame = _G.WorldMapFrame
	if WorldMapFrame and WorldMapFrame.RefreshAllDataProviders and WorldMapFrame:IsShown() then
		WorldMapFrame:RefreshAllDataProviders()
	end
end

-- Open a category of the game's Settings panel.
-- categoryNameOrID: the category ID, or the top level category name which was
--   used with AceConfigDialog:AddToBlizOptions()
-- fallback: optional function called if the category can not be opened
function addon:OpenSettingsCategory(categoryNameOrID, fallback)
	if InCombatLockdown() then
		self:Print(L["Cannot open the settings panel while in combat."])
		return false
	end
	self:CloseWorldMap()

	local categoryID = categoryNameOrID
	local AceConfigDialog = LibStub("AceConfigDialog-3.0", true)
	if type(categoryNameOrID) == "string" and AceConfigDialog and AceConfigDialog.BlizOptionsIDMap then
		categoryID = AceConfigDialog.BlizOptionsIDMap[categoryNameOrID] or categoryNameOrID
	end

	local Settings = _G.Settings
	if categoryID and Settings and Settings.OpenToCategory and (not Settings.GetCategory or Settings.GetCategory(categoryID)) then
		Settings.OpenToCategory(categoryID)
		return true
	end
	if fallback then
		fallback()
		return true
	end
	return false
end

-- ----------------------------------------------------------------------------
-- Tracking modules
-- ----------------------------------------------------------------------------
local ModulePrototype = {}

-- Display name of the module, used for sub menu and config link texts
function ModulePrototype:GetTitle()
	local title = self.title
	if type(title) == "function" then
		title = title(self)
	end
	return title or self.moduleName or self:GetName()
end

-- Whether the supported addon is loaded. Modules can override this.
function ModulePrototype:IsAvailable()
	if self.addons then
		return addon:IsAnyAddOnLoaded(unpack(self.addons))
	end
	return true
end

-- Must be implemented by modules: add the module's entries into the given menu
-- description (either the root menu or a sub menu, depending on user settings).
function ModulePrototype:BuildMenu(description, mapID)
end

-- Optional: modules may implement :OpenConfig() to have a config link added.

addon:SetDefaultModulePrototype(ModulePrototype)
addon:SetDefaultModuleState(true)

-- Create a tracking module.
--   name    : unique module name, also used as key of the enable/disable option
--   info    : { title = string|function, order = number, addons = { "AddOnName", ... } }
function addon:NewTrackingModule(name, info, ...)
	local module = self:NewModule(name, ...)
	info = info or {}
	module.title = info.title or name
	module.order = info.order or 100
	module.addons = info.addons
	tinsert(self.trackingModules, module)
	sort(self.trackingModules, function(a, b)
		if a.order == b.order then
			return a:GetName() < b:GetName()
		end
		return a.order < b.order
	end)
	return module
end

function addon:IsTrackingModuleEnabled(module)
	return profile and profile.enableModules[module:GetName()] and true or false
end

-- ----------------------------------------------------------------------------
-- Menu generator
-- ----------------------------------------------------------------------------
local function AddConfigLink(description, module, title)
	local button = description:CreateButton(format(L["%s Config"], title), function()
		module:OpenConfig()
	end)
	button:SetTooltip(function(tooltip)
		_G.GameTooltip_SetTitle(tooltip, title)
		_G.GameTooltip_AddNormalLine(tooltip, format(L["Click to open %s's config panel"], title))
	end)
end

local function BuildModuleMenu(module, description, mapID)
	module:BuildMenu(description, mapID)
end

local function GenerateMenu(owner, rootDescription)
	rootDescription:SetTag("MENU_WORLD_MAP_TRACKING_ENHANCED")
	rootDescription:CreateTitle(addon.LocName)

	local WorldMapFrame = _G.WorldMapFrame
	local mapID = WorldMapFrame and WorldMapFrame:GetMapID()
	local count = 0

	for _, module in ipairs(addon.trackingModules) do
		if addon:IsTrackingModuleEnabled(module) and module:IsAvailable() then
			local title = module:GetTitle()
			local description
			if profile.useSubmenus then
				description = rootDescription:CreateButton(title)
			else
				if profile.useSeparator then
					rootDescription:CreateDivider()
				end
				rootDescription:CreateTitle(title)
				description = rootDescription
			end

			-- A broken module should not break the whole menu
			xpcall(BuildModuleMenu, geterrorhandler(), module, description, mapID)

			if profile.showConfigLinks and module.OpenConfig then
				if profile.useSubmenus then
					description:CreateDivider()
				end
				AddConfigLink(description, module, title)
			end
			count = count + 1
		end
	end

	if count == 0 then
		rootDescription:CreateTitle(_G.GRAY_FONT_COLOR:WrapTextInColorCode(L["No supported addons are loaded."]))
	end

	rootDescription:CreateDivider()
	local config = rootDescription:CreateButton(_G.GREEN_FONT_COLOR:WrapTextInColorCode(L["World Map Tracking Enhanced Config"]), function()
		addon:OpenOptions()
	end)
	config:SetTooltip(function(tooltip)
		_G.GameTooltip_SetTitle(tooltip, addon.LocName)
		_G.GameTooltip_AddNormalLine(tooltip, L["Click to open World Map Tracking Enhanced's config panel"])
	end)
end
addon.GenerateMenu = GenerateMenu

-- ----------------------------------------------------------------------------
-- World Map button (DropdownButton, see Core\Templates.xml)
-- ----------------------------------------------------------------------------
WorldMapTrackingEnhancedButtonMixin = {}

function WorldMapTrackingEnhancedButtonMixin:OnLoad()
	-- Krowi_WorldMapButtons anchors buttons on the right side of the map on
	-- Retail / Forever / Mists Classic and on the left side on Classic Era and
	-- Anniversary realms; open the menu towards the inside of the map.
	local KButtons = LibStub("Krowi_WorldMapButtons-1.4", true)
	if KButtons and KButtons.AnchorPoint == "TOPRIGHT" then
		self:SetMenuAnchor(_G.AnchorUtil.CreateAnchor("TOPRIGHT", self, "BOTTOMRIGHT", 0, 0))
	else
		self:SetMenuAnchor(_G.AnchorUtil.CreateAnchor("TOPLEFT", self, "BOTTOMLEFT", 0, 0))
	end
	self:SetupMenu(GenerateMenu)
end

function WorldMapTrackingEnhancedButtonMixin:OnEnter()
	local GameTooltip = _G.GameTooltip
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	_G.GameTooltip_SetTitle(GameTooltip, addon.LocName)
	_G.GameTooltip_AddNormalLine(GameTooltip, L["Click to show the menu of supported map addons."])
	GameTooltip:Show()
end

function WorldMapTrackingEnhancedButtonMixin:OnLeave()
	_G.GameTooltip:Hide()
end

function WorldMapTrackingEnhancedButtonMixin:OnMouseDown()
	_G.GameTooltip:Hide()
	self.Icon:SetPoint("TOPLEFT", 8, -8)
	self.IconOverlay:Show()
end

function WorldMapTrackingEnhancedButtonMixin:OnMouseUp()
	self.Icon:SetPoint("TOPLEFT", 6, -6)
	self.IconOverlay:Hide()
end

-- Called by Krowi_WorldMapButtons whenever the World Map changes map
function WorldMapTrackingEnhancedButtonMixin:Refresh()
	self:SetShown(profile and profile.showButton)
end

local function CreateWorldMapButton()
	if addon.button then
		return addon.button
	end
	local KButtons = LibStub("Krowi_WorldMapButtons-1.4")
	addon.button = KButtons:Add("WorldMapTrackingEnhancedButtonTemplate", "DropdownButton")
	addon.button:Refresh()
	KButtons.SetPoints()
	return addon.button
end

function addon:UpdateButton()
	if not self.button then
		return
	end
	self.button:Refresh()
	local KButtons = LibStub("Krowi_WorldMapButtons-1.4", true)
	if KButtons then
		KButtons.SetPoints()
	end
end

-- ----------------------------------------------------------------------------
-- AddOn life cycle
-- ----------------------------------------------------------------------------
function addon:Refresh()
	profile = self.db.profile
	self:UpdateButton()
end

function addon:OnProfileChanged()
	self:Refresh()
end

function addon:OnInitialize()
	self.db = AceDB:New("WorldMapTrackingEnhancedDB", self.constants.defaults, true)
	profile = self.db.profile

	-- Drop settings which are no longer used since v5.0
	profile.independantButton = nil
	profile.showOnLeft = nil
	-- (per-module namespaces of v4.x are simply no longer read)

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	self:SetupOptions()

	self:RegisterChatCommand("wmte", "ChatCommand")
	self:RegisterChatCommand("worldmaptrackingenhanced", "ChatCommand")
end

function addon:OnEnable()
	if _G.WorldMapFrame then
		CreateWorldMapButton()
	else
		-- Blizzard_WorldMap should already be loaded at this point; just in case
		self:RegisterEvent("ADDON_LOADED", function(_, name)
			if name == "Blizzard_WorldMap" then
				self:UnregisterEvent("ADDON_LOADED")
				CreateWorldMapButton()
			end
		end)
	end
end

function addon:ChatCommand(input)
	input = input and input:trim():lower() or ""
	if input == "show" then
		profile.showButton = true
		self:UpdateButton()
	elseif input == "hide" then
		profile.showButton = false
		self:UpdateButton()
	else
		self:OpenOptions()
	end
end
