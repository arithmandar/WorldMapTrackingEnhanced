-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - Routes module
-- Supports: Routes (https://www.curseforge.com/wow/addons/routes)
--
-- Offers Routes' map drawing toggles (World Map, Minimap, Zone Map, Minimap
-- when indoors, show hidden routes), and show / hide toggles for each route
-- on the map currently displayed on the World Map.
-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
local _G = getfenv(0)
local ipairs, pairs, rawget, type = _G.ipairs, _G.pairs, _G.rawget, _G.type
local sort, tinsert = _G.table.sort, _G.table.insert

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
---@class WMTENamespace
local private = select(2, ...)
local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name) --[[@as WMTEAddon]]
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)

local MODNAME = "Routes"
---@class WMTE.RoutesModule : WMTETrackingModule
local module = addon:NewTrackingModule(MODNAME, {
	title = "Routes",
	order = 25,
	addons = { "Routes" },
})

-- Use Routes' own translations (falling back to the given English text)
local function RL(key, fallback)
	local RoutesL = LibStub("AceLocale-3.0"):GetLocale("Routes", true)
	local text = RoutesL and rawget(RoutesL, key)
	return type(text) == "string" and text or fallback or key
end

---@return WMTE.Routes?
local function GetRoutes()
	local Routes = LibStub("AceAddon-3.0"):GetAddon("Routes", true) --[[@as WMTE.Routes?]]
	if Routes and Routes.db and Routes.db.global and Routes.db.global.defaults then
		return Routes
	end
end

-- Map drawing options in Routes.db.global.defaults, see Routes.lua
local DRAW_OPTIONS = {
	{ key = "draw_worldmap", text = "Worldmap", desc = "Worldmap drawing" },
	{ key = "draw_minimap", text = "Minimap", desc = "Minimap drawing", option = "minimap_toggle" },
	{ key = "draw_battlemap", text = "Zone Map", desc = "Zone Map drawing" },
	{ key = "draw_indoors", text = "Minimap when indoors", desc = "Draw on minimap when indoors", parent = "draw_minimap" },
}

local function Redraw(Routes)
	if Routes.DataProvider and Routes.DrawWorldmapLines then
		Routes:DrawWorldmapLines()
	end
	if Routes.DrawMinimapLines then
		Routes:DrawMinimapLines(true)
	end
end

-- Some options (Minimap drawing) register or unregister events in Routes;
-- use Routes' own option setter for them when it is available.
local function GetOptionSetter(Routes, optionKey)
	local options = Routes.options
	local group = type(options) == "table" and options.args and options.args.options_group
	local drawing = group and group.args and group.args.drawing
	local linedisplay = drawing and drawing.args and drawing.args.linedisplay_group
	local option = linedisplay and linedisplay.args and linedisplay.args[optionKey]
	return type(option) == "table" and type(option.set) == "function" and option.set or nil
end

local function GetMapName(mapID)
	local info = mapID and _G.C_Map.GetMapInfo(mapID)
	return info and info.name
end

-- Returns the sorted route names of the given map
local function GetRouteNames(db, mapID)
	local names = {}
	local zone = mapID and rawget(db.routes, mapID)
	if type(zone) == "table" then
		for name, data in pairs(zone) do
			if type(data) == "table" and type(data.route) == "table" then
				tinsert(names, name)
			end
		end
		sort(names)
	end
	return names
end

function module:IsAvailable()
	return GetRoutes() and true or false
end

function module:BuildMenu(description, mapID)
	local Routes = GetRoutes()
	if not Routes then
		return
	end
	local db = Routes.db.global
	local defaults = db.defaults

	-- Map drawing
	description:CreateTitle(RL("Map Drawing", "Map Drawing"))

	local function IsDrawChecked(option)
		return defaults[option.key]
	end
	local function ToggleDraw(option)
		local value = not defaults[option.key]
		local setter = option.option and GetOptionSetter(Routes, option.option)
		if setter then
			setter({ arg = option.key }, value)
		else
			defaults[option.key] = value
		end
		Redraw(Routes)
		return _G.MenuResponse.Refresh
	end

	for _, option in ipairs(DRAW_OPTIONS) do
		if defaults[option.key] ~= nil then
			local checkbox = description:CreateCheckbox(RL(option.text), IsDrawChecked, ToggleDraw, option)
			checkbox:SetTooltip(function(tooltip)
				_G.GameTooltip_SetTitle(tooltip, RL(option.text))
				_G.GameTooltip_AddNormalLine(tooltip, RL(option.desc))
			end)
			if option.parent then
				checkbox:SetEnabled(function() return defaults[option.parent] end)
			end
		end
	end

	description:CreateCheckbox(RL("Show hidden routes", "Show hidden routes"), function()
		return defaults.show_hidden
	end, function()
		defaults.show_hidden = not defaults.show_hidden
		Redraw(Routes)
		return _G.MenuResponse.Refresh
	end)

	-- Routes on the map shown on the World Map
	description:CreateDivider()
	local mapName = GetMapName(mapID)
	if mapName then
		description:CreateTitle(RL("Routes in %s", "Routes in %s"):format(mapName))
	else
		description:CreateTitle(RL("Routes", "Routes"))
	end

	local names = GetRouteNames(db, mapID)
	if #names == 0 then
		description:CreateTitle("|cff999999"..L["No routes on this map."].."|r")
		return
	end

	local zone = db.routes[mapID]
	local function IsRouteShown(name)
		return not zone[name].hidden
	end
	local function ToggleRoute(name)
		zone[name].hidden = not zone[name].hidden
		Redraw(Routes)
		return _G.MenuResponse.Refresh
	end
	for _, name in ipairs(names) do
		description:CreateCheckbox(name, IsRouteShown, ToggleRoute, name)
	end
end

function module:OpenConfig()
	addon:CloseWorldMap()
	local AceConfigDialog = LibStub("AceConfigDialog-3.0", true)
	if AceConfigDialog then
		AceConfigDialog:Open("Routes")
	end
end
