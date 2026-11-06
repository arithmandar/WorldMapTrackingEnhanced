-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - AtlasLoot module
-- Supports: AtlasLoot (Retail) and AtlasLootClassic (Classic clients)
-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
local _G = getfenv(0)
local type, format, unpack = _G.type, _G.string.format, _G.unpack

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local _, private = ...
local LibStub = _G.LibStub
---@type WMTEAddon
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)

local MODNAME = "AtlasLoot"
local module = addon:NewTrackingModule(MODNAME, {
	title = "AtlasLoot",
	order = 60,
	addons = { "AtlasLoot", "AtlasLootClassic" },
})

local function GetAtlasLoot()
	local AtlasLoot = _G.AtlasLoot
	if type(AtlasLoot) == "table" then
		return AtlasLoot
	end
end

local function ToggleAtlasLoot()
	local AtlasLoot = GetAtlasLoot()
	if not AtlasLoot then
		return
	end
	addon:CloseWorldMap()
	if AtlasLoot.GUI and AtlasLoot.GUI.Toggle then
		AtlasLoot.GUI:Toggle()
	elseif AtlasLoot.WorldMap and AtlasLoot.WorldMap.Button_OnClick then
		AtlasLoot.WorldMap.Button_OnClick()
	elseif _G.SlashCmdList and _G.SlashCmdList.ATLASLOOT then
		_G.SlashCmdList.ATLASLOOT("")
	end
end

function module:IsAvailable()
	return addon:IsAnyAddOnLoaded(unpack(self.addons)) and GetAtlasLoot() and true or false
end

function module:BuildMenu(description)
	local open = description:CreateButton(format(L["Open %s"], "AtlasLoot"), ToggleAtlasLoot)
	open:SetTooltip(function(tooltip)
		_G.GameTooltip_SetTitle(tooltip, "AtlasLoot")
		_G.GameTooltip_AddNormalLine(tooltip, format(L["Click to open %s's main window"], "AtlasLoot"))
	end)
end
