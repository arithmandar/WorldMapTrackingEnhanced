-- $Id$
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local select = _G.select
-- Libraries
local GetAddOnInfo, GetAddOnEnableState, UnitName, ToggleFrame, InterfaceOptionsFrame_OpenToCategory = _G.GetAddOnInfo, _G.GetAddOnEnableState, _G.UnitName, _G.ToggleFrame, _G.InterfaceOptionsFrame_OpenToCategory
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
local filters = {}
local iWorldQuestTracker = select(4, GetAddOnInfo(MODNAME))
local enabled = GetAddOnEnableState(UnitName("player"), MODNAME)

function WorldQuestTracker:OnEnable()
	if (enabled > 0 and iWorldQuestTracker) then 
		WQT = LibStub("AceAddon-3.0"):GetAddon("WorldQuestTrackerAddon") 
		profile = WQT.db.profile
		LW = LibStub("AceLocale-3.0"):GetLocale("WorldQuestTrackerAddon")
		filters = {
			{ "artifact_power",			LW["S_QUESTTYPE_ARTIFACTPOWER"] },
			{ "dungeon",				LW["S_QUESTTYPE_DUNGEON"] },
			{ "equipment",				LW["S_QUESTTYPE_EQUIPMENT"] },
			{ "gold",					LW["S_QUESTTYPE_GOLD"] },
			{ "pet_battles",			LW["S_QUESTTYPE_PETBATTLE"] },
			{ "profession",				LW["S_QUESTTYPE_PROFESSION"] },
			{ "pvp",					LW["S_QUESTTYPE_PVP"] },
			{ "garrison_resource",		LW["S_QUESTTYPE_RESOURCE"] },
			{ "trade_skill",			LW["S_QUESTTYPE_TRADESKILL"] },
		}
	else
		return false
	end
end

local function checkWorldMapWidget()
	return profile.disable_world_map_widgets
end
	
local function toggleWorldMapWidget()
	profile.disable_world_map_widgets = not profile.disable_world_map_widgets
	if (WQT.GetCurrentZoneType() == "world") then
		WQT.UpdateWorldQuestsOnWorldMap()
	end
end

local function checkFilterStatus(filterType)
	return profile.filters[filterType]
end
	
local function toggleFilterStatus(filterType)
	profile.filters[filterType] = not profile.filters[filterType]
	WQT.UpdateZoneWidgets()
end

function WorldQuestTracker:DropDownMenus()
	if (enabled > 0 and iWorldQuestTracker) then
		local menu = {}
		local i = 1

		menu[i] = {}
		menu[i].isTitle = true
		menu[i].notCheckable = true
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		if addon.db.profile.worldQuestTracker_contextMenu then
			menu[i].hasArrow = true
		else
			menu[i].hasArrow = nil
		end
		menu[i].value = MODNAME
		menu[i].text = select(2, GetAddOnInfo("WorldQuestTracker"))
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].num = i
		i = i + 1
		
		for j = 1, #filters do
			menu[i] = {}
			menu[i].isNotRadio = true
			menu[i].keepShownOnClick = true
			menu[i].text = filters[j][2]
			menu[i].checked = checkFilterStatus(filters[j][1])
			menu[i].func = (function(self)
				toggleFilterStatus(filters[j][1])
			end)
			menu[i].num = i
			i = i + 1
		end
		
		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = L["Disable Icons on World Map"]
		menu[i].func = toggleWorldMapWidget
		menu[i].checked = checkWorldMapWidget
		menu[i].num = i
		i = i + 1

		return menu
	else
		return nil
	end
end