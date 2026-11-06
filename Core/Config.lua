-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - Config
-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
local _G = getfenv(0)
local ipairs = _G.ipairs
local format = _G.string.format

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local _, private = ...
local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

local options

local function GetOptions()
	if options then
		return options
	end

	local db = addon.db

	options = {
		type = "group",
		name = addon.LocName,
		get = function(info) return db.profile[info[#info]] end,
		set = function(info, value)
			db.profile[info[#info]] = value
			addon:Refresh()
		end,
		args = {
			info = {
				order = 1,
				type = "group",
				name = L["Addon Info"],
				inline = true,
				args = {
					notes = {
						order = 1,
						type = "description",
						name = addon.Notes.."\n",
						fontSize = "medium",
					},
					version = {
						order = 2,
						type = "description",
						name = "|cffffd200"..L["Version"]..": |r"..addon.Version,
					},
					date = {
						order = 3,
						type = "description",
						name = "|cffffd200"..L["Date"]..": |r"..addon.UpdateDate,
					},
					author = {
						order = 4,
						type = "description",
						name = "|cffffd200"..L["Author"]..": |r"..addon.Author.."\n",
					},
				},
			},
			general = {
				order = 10,
				type = "group",
				name = L["Options"],
				inline = true,
				args = {
					showButton = {
						order = 1,
						type = "toggle",
						name = L["Show World Map button"],
						desc = L["Show the World Map Tracking Enhanced button on the World Map."],
						width = "full",
					},
					useSubmenus = {
						order = 2,
						type = "toggle",
						name = L["Second Level Menu"],
						desc = L["Show each supported addon's menu items in a second level menu."],
						width = "full",
					},
					useSeparator = {
						order = 3,
						type = "toggle",
						name = L["Use Separator"],
						desc = L["Use separators to separate the entries of each supported addon. Only applies when second level menus are disabled."],
						width = "full",
						disabled = function() return db.profile.useSubmenus end,
					},
					showConfigLinks = {
						order = 4,
						type = "toggle",
						name = L["Show Config Links"],
						desc = L["Show links to each supported addon's config panel in the menu."],
						width = "full",
					},
				},
			},
			modules = {
				order = 20,
				type = "group",
				name = L["Modules"],
				inline = true,
				get = function(info) return db.profile.enableModules[info[#info]] end,
				set = function(info, value) db.profile.enableModules[info[#info]] = value end,
				args = {
					desc = {
						order = 0,
						type = "description",
						name = L["Toggle which map enhancement addon to be included in the enhanced tracking option menu."].."\n",
					},
				},
			},
		},
	}

	for i, module in ipairs(addon.trackingModules) do
		local name = module:GetName()
		options.args.modules.args[name] = {
			order = i,
			type = "toggle",
			name = function()
				local title = module:GetTitle()
				if module:IsAvailable() then
					return title
				end
				return _G.GRAY_FONT_COLOR:WrapTextInColorCode(title)
			end,
			desc = function()
				if module:IsAvailable() then
					return format(L["Include %s in the menu."], module:GetTitle())
				end
				return format(L["%s is not loaded."], module:GetTitle())
			end,
		}
	end

	return options
end

function addon:SetupOptions()
	AceConfig:RegisterOptionsTable(self.Name, GetOptions)
	local _, categoryID = AceConfigDialog:AddToBlizOptions(self.Name, self.LocName)
	self.optionsCategoryID = categoryID

	local profiles = AceDBOptions:GetOptionsTable(self.db)
	AceConfig:RegisterOptionsTable(self.Name.."Profiles", profiles)
	AceConfigDialog:AddToBlizOptions(self.Name.."Profiles", L["Profile Options"], self.LocName)
end

function addon:OpenOptions()
	self:OpenSettingsCategory(self.optionsCategoryID or self.LocName, function()
		AceConfigDialog:Open(self.Name)
	end)
end
