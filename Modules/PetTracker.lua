-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - PetTracker module
-- Supports: PetTracker (https://www.curseforge.com/wow/addons/pettracker)
-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
local _G = getfenv(0)
local ipairs, type, rawget = _G.ipairs, _G.type, _G.rawget

-- WoW API
local C_AddOns = _G.C_AddOns
local LoadAddOn = C_AddOns and C_AddOns.LoadAddOn or _G.LoadAddOn

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local _, private = ...
local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)

local MODNAME = "PetTracker"
local module = addon:NewTrackingModule(MODNAME, {
	title = "PetTracker",
	order = 30,
	addons = { "PetTracker" },
})

-- Use PetTracker's own translations (falling back to the given English text)
local function PTL(key, fallback)
	local L = LibStub("AceLocale-3.0"):GetLocale("PetTracker", true)
	return L and rawget(L, key) or fallback
end

local function GetPetTracker()
	local PT = _G.PetTracker
	if type(PT) == "table" and PT.sets and PT.GetOption and PT.ToggleOption then
		return PT
	end
end

-- PetTracker's map options; their values are stored in PetTracker.sets
local OPTIONS = {
	{ key = "showSpecies", locale = "Species", fallback = "Species" },
	{ key = "showStables", text = _G.STABLES or "Stables" },
	{ key = "specieIcons", locale = "SpecieIcons", fallback = "Species Icons", tip = "SpecieIconsTip" },
	{ key = "rivalPortraits", locale = "RivalPortraits", fallback = "Rival Portraits", tip = "RivalPortraitsTip" },
}

function module:IsAvailable()
	return GetPetTracker() and true or false
end

function module:BuildMenu(description)
	local PT = GetPetTracker()

	local function IsChecked(key)
		return PT.GetOption(key)
	end
	local function Toggle(key)
		-- PetTracker.ToggleOption() sends PetTracker's OPTIONS_CHANGED signal,
		-- which redraws its world map pins
		PT.ToggleOption(key)
		return _G.MenuResponse.Refresh
	end

	for _, option in ipairs(OPTIONS) do
		if PT.sets[option.key] ~= nil then
			local text = option.text or PTL(option.locale, option.fallback)
			local checkbox = description:CreateCheckbox(text, IsChecked, Toggle, option.key)
			local tip = option.tip and PTL(option.tip)
			if tip then
				checkbox:SetTooltip(function(tooltip)
					_G.GameTooltip_SetTitle(tooltip, text)
					_G.GameTooltip_AddNormalLine(tooltip, tip)
				end)
			end
		end
	end
end

function module:OpenConfig()
	addon:CloseWorldMap()
	local PT = GetPetTracker()
	if not PT then
		return
	end
	if not PT.Options then
		LoadAddOn("PetTracker_Config")
	end
	if PT.Options and PT.Options.Open then
		PT.Options:Open()
	else
		addon:OpenSettingsCategory("PetTracker")
	end
end
