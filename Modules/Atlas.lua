-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - Atlas module
-- Supports: Atlas (https://www.curseforge.com/wow/addons/atlas)
-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
local _G = getfenv(0)
local type, rawget, format = _G.type, _G.rawget, _G.string.format

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local _, private = ...
local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)

local MODNAME = "Atlas"
local module = addon:NewTrackingModule(MODNAME, {
	title = "Atlas",
	order = 50,
	addons = { "Atlas" },
})

-- Use Atlas' own translations (falling back to the given English text)
local function AL(key, fallback)
	local ALocale = LibStub("AceLocale-3.0"):GetLocale("Atlas", true)
	return ALocale and rawget(ALocale, key) or fallback
end

local function GetAtlas()
	local Atlas = _G.Atlas
	if type(Atlas) == "table" and Atlas.db and Atlas.Toggle then
		return Atlas
	end
end

function module:IsAvailable()
	return GetAtlas() and true or false
end

function module:BuildMenu(description)
	local Atlas = GetAtlas()

	local open = description:CreateButton(format(L["Open %s"], "Atlas"), function()
		-- Select the Atlas map which matches the current World Map, if any
		if Atlas.WorldMapButtonSelectMap then
			Atlas:WorldMapButtonSelectMap()
		end
		addon:CloseWorldMap()
		Atlas:Toggle()
	end)
	open:SetTooltip(function(tooltip)
		_G.GameTooltip_SetTitle(tooltip, "Atlas")
		_G.GameTooltip_AddNormalLine(tooltip, AL("ATLAS_CLICK_TO_OPEN", "Click to open Atlas map window."))
	end)

	local options = Atlas.db.profile and Atlas.db.profile.options
	if options and options.worldMapButton ~= nil and Atlas.ToggleWorldMapButton then
		description:CreateCheckbox(AL("ATLAS_OPTIONS_SHOWWMBUT", "Show Button on World Map window."), function()
			return options.worldMapButton
		end, function()
			options.worldMapButton = not options.worldMapButton
			Atlas:ToggleWorldMapButton()
			local KButtons = LibStub("Krowi_WorldMapButtons-1.4", true)
			if KButtons then
				KButtons.SetPoints()
			end
			return _G.MenuResponse.Refresh
		end)
	end
end

function module:OpenConfig()
	local Atlas = GetAtlas()
	addon:CloseWorldMap()
	if Atlas and Atlas.OpenOptions then
		Atlas:OpenOptions()
	else
		addon:OpenSettingsCategory("Atlas")
	end
end
