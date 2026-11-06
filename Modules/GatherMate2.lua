-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - GatherMate2 module
-- Supports: GatherMate2 (https://www.curseforge.com/wow/addons/gathermate2)
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
local Client = private.Client

local MODNAME = "GatherMate2"
local module = addon:NewTrackingModule(MODNAME, {
	title = "GatherMate2",
	order = 20,
	addons = { "GatherMate2" },
})

-- Use GatherMate2's own translations. rawget() avoids AceLocale's
-- "Missing entry" errors if a string is not available in GatherMate2.
local function GML(key)
	local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate2", true)
	return L and rawget(L, key) or key
end

-- Display options per node type, same as in GatherMate2's own config (Config.lua)
local SHOW_ALWAYS = { "always", "Always show" }
local SHOW_PROFESSION = { "with_profession", "Only with profession" }
local SHOW_TRACKING = { "active", "Only while tracking" }
local SHOW_DIGSITE = { "active", "Only with digsite" }
local SHOW_NEVER = { "never", "Never show" }

local NODE_TYPES = {
	{ key = "Mining", text = "Show Mining Nodes", values = { SHOW_ALWAYS, SHOW_PROFESSION, SHOW_TRACKING, SHOW_NEVER } },
	{ key = "Herb Gathering", text = "Show Herbalism Nodes", values = { SHOW_ALWAYS, SHOW_PROFESSION, SHOW_TRACKING, SHOW_NEVER } },
	{ key = "Fishing", text = "Show Fishing Nodes", values = { SHOW_ALWAYS, SHOW_PROFESSION, SHOW_TRACKING, SHOW_NEVER } },
	{ key = "Extract Gas", text = "Show Gas Clouds", values = { SHOW_ALWAYS, SHOW_PROFESSION, SHOW_NEVER }, notOnForever = true },
	{ key = "Treasure", text = "Show Treasure Nodes", values = { SHOW_ALWAYS, SHOW_TRACKING, SHOW_NEVER } },
	{ key = "Archaeology", text = "Show Archaeology Nodes", values = { SHOW_ALWAYS, SHOW_DIGSITE, SHOW_PROFESSION, SHOW_NEVER }, notOnForever = true },
	{ key = "Logging", text = "Show Timber Nodes", values = { SHOW_ALWAYS, SHOW_TRACKING, SHOW_NEVER }, notOnForever = true },
}

local function GetGatherMate()
	return LibStub("AceAddon-3.0"):GetAddon("GatherMate2", true)
end

local function UpdateGatherMate(GM)
	local Config = GM:GetModule("Config", true)
	if Config and Config.UpdateConfig then
		Config:UpdateConfig()
	elseif GM.OnProfileChanged then
		GM:OnProfileChanged()
	end
end

function module:IsAvailable()
	local GM = GetGatherMate()
	return GM and GM.db and GM.db.profile and true or false
end

function module:BuildMenu(description)
	local GM = GetGatherMate()
	local db = GM.db.profile

	description:CreateCheckbox(GML("Show World Map Icons"), function()
		return db.showWorldMap
	end, function()
		db.showWorldMap = not db.showWorldMap
		UpdateGatherMate(GM)
		return _G.MenuResponse.Refresh
	end)

	description:CreateDivider()

	local function IsSelected(data)
		return db.show[data.key] == data.value
	end
	local function SetSelected(data)
		db.show[data.key] = data.value
		UpdateGatherMate(GM)
		return _G.MenuResponse.Refresh
	end
	local function IsWorldMapShown()
		return db.showWorldMap
	end

	for _, nodeType in ipairs(NODE_TYPES) do
		-- Skip node types which do not exist in the loaded GatherMate2 version
		-- or on the current game client
		if db.show[nodeType.key] ~= nil and not (nodeType.notOnForever and Client.isForever) then
			local submenu = description:CreateButton(GML(nodeType.text))
			submenu:SetEnabled(IsWorldMapShown)
			for _, value in ipairs(nodeType.values) do
				submenu:CreateRadio(GML(value[2]), IsSelected, SetSelected, { key = nodeType.key, value = value[1] })
			end
		end
	end
end

function module:OpenConfig()
	addon:OpenSettingsCategory("GatherMate 2", function()
		local open = _G.SlashCmdList and _G.SlashCmdList.GatherMate2
		if open then
			open("")
		end
	end)
end
