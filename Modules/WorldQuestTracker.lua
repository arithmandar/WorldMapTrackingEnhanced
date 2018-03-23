-- $Id$
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local MODNAME = "WorldQuestTracker"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local WorldQuestTracker = addon:NewModule(MODNAME)

local WQT, profile, LW
local iWorldQuestTracker = select(4, GetAddOnInfo(MODNAME))
local enabled = GetAddOnEnableState(UnitName("player"), MODNAME)

function WorldQuestTracker:OnEnable()
	if (enabled > 0 and iWorldQuestTracker) then 
		WQT = LibStub("AceAddon-3.0"):GetAddon("WorldQuestTrackerAddon") 
		profile = WQT.db.profile
		LW = LibStub("AceLocale-3.0"):GetLocale("WorldQuestTrackerAddon")
	else
		return false
	end
end

local function CheckWorldMapWidget()
	return profile.disable_world_map_widgets
end
	
local function ToggleWorldMapWidget()
	profile.disable_world_map_widgets = not profile.disable_world_map_widgets
	if (WQT.GetCurrentZoneType() == "world") then
		WQT.UpdateWorldQuestsOnWorldMap()
	end
end

function WorldQuestTracker:DropDownMenus()
	if (enabled > 0 and iWorldQuestTracker) then
		local menu = {}
		local i = 1

		menu[i] = {}
		menu[i].notCheckable = true
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].hasArrow = true
		menu[i].value = MODNAME
		menu[i].text = select(2, GetAddOnInfo("WorldQuestTracker"))
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].num = i
		i = i + 1
		
		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = L["Disable Icons on World Map"]
		menu[i].func = ToggleWorldMapWidget
		menu[i].checked = CheckWorldMapWidget
		menu[i].num = i
		i = i + 1

		return menu
	else
		return nil
	end
end