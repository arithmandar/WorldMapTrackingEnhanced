-- $Id$
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local pairs = _G.pairs
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local LibStub = _G.LibStub;
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name);

local AceConfigReg = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

local optGetter, optSetter
do
	function optGetter(info)
		local key = info[#info]
		return addon.db.profile[key]
	end

	function optSetter(info, value)
		local key = info[#info]
		addon.db.profile[key] = value
		addon:Refresh()
	end
end

local pluginsOptionsText = {}
local options, moduleOptions = nil, {}
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = addon.LocName,
			args = {
				general = {
					order = 1,
					type = "group",
					name = L["Options"],
					get = optGetter,
					set = optSetter,
					args = {
						description = {
							order = 1,
							type = "description",
							name = addon.Notes,
						},
						--[[ //////// Header 1 //////// --]]
						header1 = {
							order = 10,
							type = "header",
							name = L["Config"],
						},
						desc1 = {
							order = 10.1,
							type = "description",
							name = L["Addon Configuration"],
						},
						useSeparator = {
							order = 11,
							type = "toggle",
							name = L["Use Separator"],
							desc = L["Use separator in menu to separate different type of menu items"],
						},
					},
				},
				plugins = {
					order = 2,
					type = "group",
					name = L["Support"],
					args = {
						--[[ //////// Header 2 //////// --]]
						header2 = {
							order = 10,
							type = "header",
							name = L["Support"],
						},
						desc2 = {
							order = 20,
							type = "description",
							name = L["Toggle which map enhancement addon to be included in the enhanced tracking option menu."],
						},
						show_plugins = {
							name = L["Modules"], 
							type = "multiselect",
							order = 21,
							values = pluginsOptionsText,
							get = function(info, k)
								return addon.db.profile.enableModules[k]
							end,
							set = function(info, k, v)
								addon.db.profile.enableModules[k] = v
								addon:SetModuleEnabled(k, v)
								addon:Refresh()
							end,
						},
					},
				},
			},
		}
		for k,v in pairs(moduleOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end
	end

	return options
end


local function openOptions()
	-- open the profiles tab before, so the menu expands
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.Profiles) -- yes, run twice to force the tre get expanded
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.General)
	InterfaceOptionsFrame:Raise()
end

function addon:OpenOptions() 
	openOptions()
end

local function giveProfiles()
	return AceDBOptions:GetOptionsTable(addon.db)
end

function addon:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	AceConfigReg:RegisterOptionsTable(addon.LocName, getOptions)
	self.optionsFrames.General = AceConfigDialog:AddToBlizOptions(addon.LocName)

	self:RegisterModuleOptions("Profiles", giveProfiles, L["Profile Options"])
end

-- Description: Function which extends our options table in a modular way
-- Expected result: add a new modular options table to the modularOptions upvalue as well as the Blizzard config
-- Input:
--		name		: index of the options table in our main options table
--		optionsTable	: the sub-table to insert
--		displayName	: the name to display in the config interface for this set of options
-- Output: None.
function addon:RegisterModuleOptions(name, optionsTable, displayName)
	if (name == "Profiles") then
		moduleOptions[name] = optionsTable
		--self.optionsFrames[name] = AceConfigDialog:AddToBlizOptions(addon.LocName, displayName, addon.LocName, name)
	else
		if self.plugins[name] ~= nil then
			error(name.." is already registered by another plugin.")
		else
			self.plugins[name] = true
		end
		if not options then options = getOptions() end
		options.args.plugins.args[name] = optionsTable
		pluginsOptionsText[name] = optionsTable and optionsTable.name or displayName or name
	end
end
