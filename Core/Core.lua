-- $Id$
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local select = _G.select
local pairs = _G.pairs
-- Libraries
local GameTooltip, GetAddOnInfo, GetAddOnEnableState, UnitName, PlaySound, GetCVarBool = _G.GameTooltip, _G.GetAddOnInfo, _G.GetAddOnEnableState, _G.UnitName, _G.PlaySound, _G.GetCVarBool
local WorldMapTrackingOptionsDropDown_OnClick = _G.WorldMapTrackingOptionsDropDown_OnClick
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local AceDB = LibStub("AceDB-3.0")

local addon = LibStub("AceAddon-3.0"):NewAddon(private.addon_name, "AceEvent-3.0")
addon.constants = private.constants
addon.constants.addon_name = private.addon_name
addon.Name = FOLDER_NAME
addon.LocName = select(2, GetAddOnInfo(addon.Name))
addon.Notes = select(3, GetAddOnInfo(addon.Name))
_G.WorldMapTrackingEnhanced = addon
local profile
local FilterButton -- WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button

local function checkAddonStatus(addonName)
	if not addonName then return nil end
	local loadable = select(4, GetAddOnInfo(addonName))
	local enabled = GetAddOnEnableState(UnitName("player"), addonName)
	if (enabled > 0 and loadable) then
		return true
	else
		return false
	end
end

local function onSelection(value, checked)
	if (checked) then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end

	if (value == "quests") then
		SetCVar("questPOI", checked and "1" or "0", "QUEST_POI")
	elseif (value == "digsites") then
		print("digSites")
		SetCVar("digSites", checked and "1" or "0", "SHOW_DIG_SITES")
	elseif (value == "tamers") then
		SetCVar("showTamers", checked and "1" or "0", "SHOW_TAMERS")
	elseif (value == "primaryProfessionsFilter" or value == "secondaryProfessionsFilter") then
		SetCVar(value, checked and "1" or "0")
	elseif (value == "worldQuestFilterResources" or value == "worldQuestFilterArtifactPower" or
			value == "worldQuestFilterProfessionMaterials" or value == "worldQuestFilterGold" or
			value == "worldQuestFilterEquipment") then
		-- World quest reward filter cvars
		SetCVar(value, checked and "1" or "0")
	end
	FilterButton:GetParent():RefreshAllDataProviders()
end

-- //////////////////////////////////////////////////////////////////////////
-- Main function to replace World Map Tracking Option's dropdown menu
-- //////////////////////////////////////////////////////////////////////////
local function dropDown_Initialize(self, level)
	local function OnSelection(button)
		onSelection(button.value, button.checked)
	end

	if not level then level = 1 end
	local info = L_UIDropDownMenu_CreateInfo()

	if (level == 1) then
		info.isTitle = true
		info.notCheckable = true
		info.text = WORLD_MAP_FILTER_TITLE -- which is "Show:"
		L_UIDropDownMenu_AddButton(info)

		info.isTitle = nil
		info.disabled = nil
		info.notCheckable = nil
		info.isNotRadio = true
		info.keepShownOnClick = true
		info.func = OnSelection

		info.text = SHOW_QUEST_OBJECTIVES_ON_MAP_TEXT
		info.value = "quests"
		info.checked = GetCVarBool("questPOI")
		L_UIDropDownMenu_AddButton(info)

		local prof1, prof2, arch, fish, cook, firstAid = GetProfessions()
		if arch then
			info.text = ARCHAEOLOGY_SHOW_DIG_SITES -- "Show Digsites"
			info.value = "digsites"
			info.checked = GetCVarBool("digSites")
			L_UIDropDownMenu_AddButton(info)
		end

		-- Pet Battle
		if CanTrackBattlePets() then
			info.text = SHOW_PET_BATTLES_ON_MAP_TEXT
			info.value = "tamers"
			info.checked = GetCVarBool("showTamers")
			L_UIDropDownMenu_AddButton(info)
		end
		-- Adding PetTracker menus
		if (checkAddonStatus("PetTracker") and profile.enable_PetTracker) then
			local PT = addon:GetModule("PetTracker", true)
			local menu = PT:DropDownMenus()

			L_UIDropDownMenu_AddButton(menu[1])
		end
		-- If we aren't on a map with world quests don't show the world quest reward filter options.
		local mapID = WorldMapFrame:GetMapID()
		if mapID and MapUtil.MapHasUnlockedBounties(mapID) then
			-- Adding World Quest Tracker menus;
			if (checkAddonStatus("WorldQuestTracker") and profile.enable_WorldQuestTracker) then
				L_UIDropDownMenu_AddSeparator(1)
				local WQT = addon:GetModule("WorldQuestTracker", true)
				local menu = WQT:DropDownMenus()

				if (profile.worldQuestTracker_contextMenu) then
					L_UIDropDownMenu_AddButton(menu[1])
				else
					for i = 1, #menu do
						L_UIDropDownMenu_AddButton(menu[i])
					end
				end
			-- With World Quest Tracker enabled, actually the WoW built-in World Quest menu filters will not working. 
			else
				-- Clear out the info from the separator wholesale.
				info = L_UIDropDownMenu_CreateInfo()

				info.isTitle = nil
				info.disabled = nil
				info.notCheckable = nil
				info.isNotRadio = true
				info.keepShownOnClick = true
				info.func = WorldMapTrackingOptionsDropDown_OnClick

				if prof1 or prof2 then
					info.text = SHOW_PRIMARY_PROFESSION_ON_MAP_TEXT
					info.value = "primaryProfessionsFilter"
					info.checked = GetCVarBool("primaryProfessionsFilter")
					L_UIDropDownMenu_AddButton(info)
				end

				if fish or cook or firstAid then
					info.text = SHOW_SECONDARY_PROFESSION_ON_MAP_TEXT
					info.value = "secondaryProfessionsFilter"
					info.checked = GetCVarBool("secondaryProfessionsFilter")
					L_UIDropDownMenu_AddButton(info)
				end
				
				L_UIDropDownMenu_AddSeparator(1)

				-- Clear out the info from the separator wholesale.
				info = L_UIDropDownMenu_CreateInfo()

				info.isTitle = true
				info.notCheckable = true
				info.text = WORLD_QUEST_REWARD_FILTERS_TITLE
				L_UIDropDownMenu_AddButton(info)
				info.text = nil

				info.isTitle = nil
				info.disabled = nil
				info.notCheckable = nil
				info.isNotRadio = true
				info.keepShownOnClick = true
				info.func = OnSelection

				info.text = WORLD_QUEST_REWARD_FILTERS_RESOURCES
				info.value = "worldQuestFilterResources"
				info.checked = GetCVarBool("worldQuestFilterResources")
				L_UIDropDownMenu_AddButton(info)

				info.text = WORLD_QUEST_REWARD_FILTERS_ARTIFACT_POWER
				info.value = "worldQuestFilterArtifactPower"
				info.checked = GetCVarBool("worldQuestFilterArtifactPower")
				L_UIDropDownMenu_AddButton(info)

				info.text = WORLD_QUEST_REWARD_FILTERS_PROFESSION_MATERIALS
				info.value = "worldQuestFilterProfessionMaterials"
				info.checked = GetCVarBool("worldQuestFilterProfessionMaterials")
				L_UIDropDownMenu_AddButton(info)

				info.text = WORLD_QUEST_REWARD_FILTERS_GOLD
				info.value = "worldQuestFilterGold"
				info.checked = GetCVarBool("worldQuestFilterGold")
				L_UIDropDownMenu_AddButton(info)
				
				info.text = WORLD_QUEST_REWARD_FILTERS_EQUIPMENT
				info.value = "worldQuestFilterEquipment"
				info.checked = GetCVarBool("worldQuestFilterEquipment")
				L_UIDropDownMenu_AddButton(info)
			end
		end
		-- Adding HandyNotes menus
		if (checkAddonStatus("HandyNotes") and profile.enable_HandyNotes) then
			local HandyNotes = addon:GetModule("HandyNotes", true)
			local menu = HandyNotes:DropDownMenus()

			L_UIDropDownMenu_AddSeparator(1)
			if (profile.handynotes_contextMenu) then
				L_UIDropDownMenu_AddButton(menu[1])
			else
				for i = 1, #menu do
					L_UIDropDownMenu_AddButton(menu[i])
				end
			end

		end
		-- Adding GatherMate2 menus
		if (checkAddonStatus("GatherMate2") and profile.enable_GatherMate2) then
			local GatherMate2 = addon:GetModule("GatherMate2", true)
			local menu = GatherMate2:DropDownMenus()

			L_UIDropDownMenu_AddSeparator(1)
			L_UIDropDownMenu_AddButton(menu[1])
		end
		-- Adding WorldMapTrackingEnhanced's Config link
		L_UIDropDownMenu_AddSeparator(1)
		info = L_UIDropDownMenu_CreateInfo()
		info.isNotRadio = true
		info.notCheckable = true
		info.text = L["World Map Tracking Enhanced Config"]
		info.colorCode = "|cFFB5E61D"
		info.tooltipTitle = addon.LocName
		info.tooltipText = L["Click to open World Map Tracking Enhanced's config panel"]
		info.tooltipOnButton = true
		info.func = (function(self)
			ToggleFrame(WorldMapFrame)
			InterfaceOptionsFrame_OpenToCategory(addon.LocName)
			InterfaceOptionsFrame_OpenToCategory(addon.LocName)
		end)
		L_UIDropDownMenu_AddButton(info)
	-- Handling level 2 menus
	elseif (level == 2) then
		-- handling PetTracker's level 2 menus
		if (checkAddonStatus("PetTracker") and profile.enable_PetTracker and L_UIDROPDOWNMENU_MENU_VALUE == "PetTracker") then
			local PetTracker = addon:GetModule("PetTracker", true)
			local menu = PetTracker:DropDownMenus()

			for i = 2, #menu do
				L_UIDropDownMenu_AddButton(menu[i], 2)
			end
		end
		-- handling GatherMate2's level 2 menus
		if (checkAddonStatus("GatherMate2") and profile.enable_GatherMate2 and L_UIDROPDOWNMENU_MENU_VALUE == "GatherMate2") then
			local GatherMate2 = addon:GetModule("GatherMate2", true)
			local menu = GatherMate2:DropDownMenus()

			for i = 2, #menu do
				L_UIDropDownMenu_AddButton(menu[i], 2)
			end
		end
		-- handling World Quest Tracker's level 2 menus
		if (checkAddonStatus("WorldQuestTracker") and profile.enable_WorldQuestTracker and profile.worldQuestTracker_contextMenu and L_UIDROPDOWNMENU_MENU_VALUE == "WorldQuestTracker") then
			local WQT = addon:GetModule("WorldQuestTracker", true)
			local menu = WQT:DropDownMenus()

			for i = 2, #menu do
				L_UIDropDownMenu_AddButton(menu[i], 2)
			end
		end
		-- handling HandyNotes' level 2 menus
		if (checkAddonStatus("HandyNotes") and profile.enable_HandyNotes and profile.handynotes_contextMenu and L_UIDROPDOWNMENU_MENU_VALUE == "HandyNotes") then
			local HandyNotes = addon:GetModule("HandyNotes", true)
			local menu = HandyNotes:DropDownMenus()

			for i = 2, #menu do
				L_UIDropDownMenu_AddButton(menu[i], 2)
			end
		end
	elseif (level == 3) then
		-- handling GatherMate2's level 3 menus
		if (checkAddonStatus("GatherMate2") and profile.enable_GatherMate2) then
--		and L_UIDROPDOWNMENU_MENU_VALUE == "GatherMate2") then
			local GatherMate2 = addon:GetModule("GatherMate2", true)
			local _, menu2 = GatherMate2:DropDownMenus()
			for k, v in pairs(menu2) do
				if (L_UIDROPDOWNMENU_MENU_VALUE == "GatherMate2".."."..k) then
					for ka, va in pairs(menu2[k]) do
						L_UIDropDownMenu_AddButton(menu2[k][ka], 3)
					end
				end
			end

		end
	end
end

local function createTrackingButton()
	
	local button = CreateFrame("Button", addon.Name.."Button", WorldMapFrame.ScrollContainer)
	addon.button = button
	button:SetWidth(32)
	button:SetHeight(32)
	button:SetPoint("TOPRIGHT", WorldMapFrame, -4, -68, "TOPRIGHT")

	addon.dropDown = CreateFrame("Frame", addon.Name.."DropDown", button, "L_UIDropDownMenuTemplate");
	addon.dropDown:SetScript("OnShow", function(self) 
		L_UIDropDownMenu_Initialize(self, dropDown_Initialize, "MENU") 
	end)
	
	button.Border = button:CreateTexture(addon.Name.."ButtonBorder","BORDER")
	button.Border:SetPoint("TOPLEFT", button, "TOPLEFT")
	button.Border:SetWidth(54)
	button.Border:SetHeight(54)
	button.Border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

	button.Background = button:CreateTexture(addon.Name.."ButtonBackground","BACKGROUND")
	button.Background:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -4)
	button.Background:SetWidth(25)
	button.Background:SetHeight(25)
	button.Background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	--button.Background:SetColorTexture(1, 1, 1, 1)

	button.Icon = button:CreateTexture(addon.Name.."ButtonIcon", "ARTWORK")
	button.Icon:SetPoint("TOPLEFT", button, "TOPLEFT", 6, -6)
	button.Icon:SetHeight(20)
	button.Icon:SetWidth(20)
	button.Icon:SetTexture("Interface\\Minimap\\Tracking\\None")
	
	button.IconOverlay = button:CreateTexture(addon.Name.."ButtonOverlay","OVERLAY")
	button.IconOverlay:SetWidth(27)
	button.IconOverlay:SetHeight(27)
	button.IconOverlay:SetPoint("TOPLEFT", button.Icon, "TOPLEFT", 2, -2)
	button.IconOverlay:SetColorTexture(0, 0, 0, 0.5)
	button.IconOverlay:Hide()
	
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
	
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(TRACKING, 1, 1, 1)
		GameTooltip:AddLine(MINIMAP_TRACKING_TOOLTIP_NONE, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	button:SetScript("OnClick", function(self)
		local parent = self:GetParent()
		local mapID = WorldMapFrame:GetMapID()
		if not mapID then
			return
		end
		addon.dropDown.mapID = mapID
		L_ToggleDropDownMenu(1, nil, addon.dropDown, button, 0, -5)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end)
	button:SetScript("OnMouseDown", function(self)
		--local parent = self:GetParent()
		button.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 8, -8)
		button.IconOverlay:Show()
	end)
	button:SetScript("OnMouseUp", function(self)
		--local parent = self:GetParent()
		button.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
		button.IconOverlay:Hide()
	end)
end

function addon:OnInitialize()
	self.db = AceDB:New(addon.Name.."DB", addon.constants.defaults, true)
	profile = self.db.profile;

	self:SetupOptions();
	--FilterButton = WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button
	FilterButton = WorldMapFrame.overlayFrames[2]
end

function addon:OnEnable()
	for key, value in pairs( addon.constants.events ) do
		self:RegisterEvent( value );
	end
	createTrackingButton()
	FilterButton:Hide()
end

function addon:Refresh()
end
--[[
function addon:CLOSE_WORLD_MAP()
	L_CloseDropDownMenus()
end
]]
