-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - HandyNotes module
-- Supports: HandyNotes (https://www.curseforge.com/wow/addons/handynotes)
-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
local _G = getfenv(0)
local pairs, ipairs, type, tinsert, sort = _G.pairs, _G.ipairs, _G.type, _G.table.insert, _G.table.sort

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
---@class WMTENamespace
local private = select(2, ...)
local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name) --[[@as WMTEAddon]]
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)

local MODNAME = "HandyNotes"
---@class WMTE.HandyNotesModule : WMTETrackingModule
local module = addon:NewTrackingModule(MODNAME, {
	title = "HandyNotes",
	order = 10,
	addons = { "HandyNotes" },
})

---@return WMTE.HandyNotes?
local function GetHandyNotes()
	return LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true) --[[@as WMTE.HandyNotes?]]
end

-- HandyNotes keeps the display names of its plugins in its options table.
-- AceConfigRegistry validates the whole table (including every plugin's
-- options) the first time it is fetched; an invalid plugin table raises an
-- error, so the caller wraps this in pcall() and falls back to plugin keys.
local function GetPluginDisplayNames()
	local AceConfigRegistry = LibStub("AceConfigRegistry-3.0", true)
	local options = AceConfigRegistry and AceConfigRegistry:GetOptionsTable("HandyNotes", "dialog", private.addon_name.."-1.0")
	local plugins = type(options) == "table" and type(options.args) == "table" and options.args.plugins
	local showPlugins = type(plugins) == "table" and type(plugins.args) == "table" and plugins.args.show_plugins
	local values = type(showPlugins) == "table" and showPlugins.values
	return type(values) == "table" and values or nil
end

local function GetSortedPlugins(HN)
	local ok, names = pcall(GetPluginDisplayNames)
	if not ok then
		names = nil
	end
	local list = {}
	for pluginName in pairs(HN.plugins) do
		local text = names and names[pluginName]
		if type(text) ~= "string" or text == "" then
			text = pluginName
		end
		tinsert(list, { key = pluginName, text = text, sortText = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):lower() })
	end
	sort(list, function(a, b) return a.sortText < b.sortText end)
	return list
end

local function SetAllPlugins(HN, value)
	local db = HN.db.profile
	for pluginName in pairs(HN.plugins) do
		db.enabledPlugins[pluginName] = value
		HN:UpdatePluginMap(nil, pluginName)
	end
end

function module:IsAvailable()
	local HN = GetHandyNotes()
	return HN and HN.db and HN.plugins and true or false
end

function module:BuildMenu(description)
	local HN = GetHandyNotes()
	if not HN then
		return
	end
	local db = HN.db.profile

	description:CreateCheckbox(L["Enable HandyNotes"], function()
		return db.enabled
	end, function()
		db.enabled = not db.enabled
		if db.enabled then
			HN:Enable()
		else
			HN:Disable()
		end
		return _G.MenuResponse.Refresh
	end)

	local plugins = GetSortedPlugins(HN)
	if #plugins == 0 then
		return
	end

	description:CreateDivider()
	description:CreateTitle(L["Plugins"])

	local function IsPluginEnabled(pluginName)
		return db.enabledPlugins[pluginName]
	end
	local function TogglePlugin(pluginName)
		db.enabledPlugins[pluginName] = not db.enabledPlugins[pluginName]
		HN:UpdatePluginMap(nil, pluginName)
		return _G.MenuResponse.Refresh
	end

	for _, plugin in ipairs(plugins) do
		local checkbox = description:CreateCheckbox(plugin.text, IsPluginEnabled, TogglePlugin, plugin.key)
		checkbox:SetEnabled(function() return db.enabled end)
	end

	if #plugins > 1 then
		description:CreateDivider()
		local all = description:CreateButton(L["Select All"], function()
			SetAllPlugins(HN, true)
			return _G.MenuResponse.Refresh
		end)
		all:SetEnabled(function() return db.enabled end)
		local none = description:CreateButton(L["Select None"], function()
			SetAllPlugins(HN, false)
			return _G.MenuResponse.Refresh
		end)
		none:SetEnabled(function() return db.enabled end)
	end
end

function module:OpenConfig()
	addon:OpenSettingsCategory("HandyNotes", function()
		LibStub("AceConfigDialog-3.0"):Open("HandyNotes")
	end)
end
