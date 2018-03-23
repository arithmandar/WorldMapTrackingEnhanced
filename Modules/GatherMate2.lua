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

local MODNAME = "GatherMate2"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local GatherMate2 = addon:NewModule(MODNAME)

local GM
local iGatherMate2 = select(4, GetAddOnInfo("GatherMate2"))
local enabled = GetAddOnEnableState(UnitName("player"), "GatherMate2")

function GatherMate2:OnEnable()
	if (enabled > 0 and iGatherMate2) then 
		GM = LibStub("AceAddon-3.0"):GetAddon("GatherMate2") 
	end
end
	
local function ToggleGatherMate2()
	GM.db.profile.showWorldMap = not GM.db.profile.showWorldMap
	GM:OnProfileChanged()
end

local function CheckWorldMapStatus()
	return GM.db.profile.showWorldMap or nil
end

function GatherMate2:DropDownMenus()
	if (enabled > 0 and iGatherMate2) then
		local menu = {}
		local i = 1
		local mode_name = select(2, GetAddOnInfo("GatherMate2")) or MODNAME
		local LGM = LibStub("AceLocale-3.0"):GetLocale("GatherMate2", false)
		local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
		
		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].hasArrow = true
		menu[i].value = "GatherMate2"
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].text = mode_name
		menu[i].tooltipTitle = LGM["Show World Map Icons"]
		menu[i].tooltipText = LGM["Toggle showing World Map icons."]
		menu[i].tooltipOnButton = true
		menu[i].func = ToggleGatherMate2
		menu[i].checked = CheckWorldMapStatus
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		menu[i].text = L["GatherMate2 Config"]
		menu[i].colorCode = "|cFFFFC90E"
		menu[i].tooltipTitle = mode_name
		menu[i].tooltipText = L["Click to open GatherMate2' config panel"]
		menu[i].tooltipOnButton = true
		menu[i].func = (function(self)
			ToggleFrame(WorldMapFrame)
			InterfaceOptionsFrame_OpenToCategory("GatherMate 2")
			InterfaceOptionsFrame_OpenToCategory("GatherMate 2")
		end)
		
		return menu
	else
		return nil
	end
end