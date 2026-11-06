-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - RareScanner module
-- Supports: RareScanner (https://www.curseforge.com/wow/addons/rarescanner)
--
-- RareScanner has its own (much more detailed) World Map button; this module
-- only offers the main show / hide toggles so they can be changed together
-- with the other supported addons.
-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
local _G = getfenv(0)
local ipairs, rawget = _G.ipairs, _G.rawget

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local _, private = ...
local LibStub = _G.LibStub
---@type WMTEAddon
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)

local MODNAME = "RareScanner"
local module = addon:NewTrackingModule(MODNAME, {
	title = "RareScanner",
	order = 40,
	addons = { "RareScanner" },
})

-- Use RareScanner's own translations (falling back to the given English text)
local function RSL(key, fallback)
	local L = LibStub("AceLocale-3.0"):GetLocale("RareScanner", true)
	return L and rawget(L, key) or fallback
end

local function GetRareScanner()
	return LibStub("AceAddon-3.0"):GetAddon("RareScanner", true)
end

-- Keys in RareScanner.db.profile.map, see RSConfigDB.lua in RareScanner
local GROUPS = {
	{
		title = { "MAP_MENU_RARE_NPCS", "Rare NPC icons" },
		{ key = "displayNpcIcons", text = { "MAP_MENU_SHOW_RARE_NPCS", "Show rare NPC icons on map" } },
		{ key = "displayNotDiscoveredNpcIcons", text = { "MAP_MENU_SHOW_NOT_DISCOVERED_RARE_NPCS", "Show not discovered rare NPC icons on map" }, parent = "displayNpcIcons" },
	},
	{
		title = { "MAP_MENU_CONTAINERS", "Container icons" },
		{ key = "displayContainerIcons", text = { "MAP_MENU_SHOW_CONTAINERS", "Show container icons on map" } },
		{ key = "displayNotDiscoveredContainerIcons", text = { "MAP_MENU_SHOW_NOT_DISCOVERED_CONTAINERS", "Show not discovered container icons on map" }, parent = "displayContainerIcons" },
	},
	{
		title = { "MAP_MENU_EVENTS", "Event icons" },
		{ key = "displayEventIcons", text = { "MAP_MENU_SHOW_EVENTS", "Show event icons on map" } },
		{ key = "displayNotDiscoveredEventIcons", text = { "MAP_MENU_SHOW_NOT_DISCOVERED_EVENTS", "Show not discovered event icons on map" }, parent = "displayEventIcons" },
	},
}

function module:IsAvailable()
	local RS = GetRareScanner()
	return RS and RS.db and RS.db.profile and RS.db.profile.map and true or false
end

function module:BuildMenu(description)
	local RS = GetRareScanner()
	local db = RS.db.profile.map

	local function IsChecked(key)
		return db[key]
	end
	local function Toggle(key)
		db[key] = not db[key]
		addon:RefreshWorldMap()
		return _G.MenuResponse.Refresh
	end

	for i, group in ipairs(GROUPS) do
		if i > 1 then
			description:CreateDivider()
		end
		description:CreateTitle(RSL(group.title[1], group.title[2]))
		for _, option in ipairs(group) do
			if db[option.key] ~= nil then
				local checkbox = description:CreateCheckbox(RSL(option.text[1], option.text[2]), IsChecked, Toggle, option.key)
				if option.parent then
					checkbox:SetEnabled(function() return db[option.parent] end)
				end
			end
		end
	end
end

function module:OpenConfig()
	addon:OpenSettingsCategory("RareScanner")
end
