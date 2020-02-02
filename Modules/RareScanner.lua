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

local MODNAME = "RareScanner"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local RareScanner = addon:NewModule(MODNAME)

local RS, profile, LRS

local iRareScanner = select(4, GetAddOnInfo(MODNAME))
local enabled = GetAddOnEnableState(UnitName("player"), MODNAME)

function RareScanner:OnEnable()
	if (enabled > 0 and iRareScanner) then 
		RS = LibStub("AceAddon-3.0"):GetAddon(MODNAME) 
		profile = RS.db.profile
		LRS = LibStub("AceLocale-3.0"):GetLocale("RareScanner", false)
	else
		return false
	end
end
	
local function toggleRareScanner(key)
	profile.map[key] = not profile.map[key]
	WorldMapFrame:RefreshAllDataProviders()
end

function RareScanner:DropDownMenus()
	if (enabled > 0 and iRareScanner) then
		local menu = {}
		local i = 1
		local mode_name = select(2, GetAddOnInfo("RareScanner")) or MODNAME
		
		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		--menu[i].keepShownOnClick = true
		if (addon.db.profile.rarescanner_contextMenu) then
			menu[i].hasArrow = true
		else
			menu[i].hasArrow = nil
		end
		menu[i].value = MODNAME
		menu[i].colorCode = "|cFFFFC90E"
		menu[i].text = mode_name
		menu[i].tooltipTitle = mode_name
		menu[i].tooltipText = select(3, GetAddOnInfo("RareScanner")) or nil
		menu[i].tooltipOnButton = true
		--menu[i].func = toggleRareScanner
		menu[i].checked = nil
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = LRS["MAP_MENU_SHOW_ALL"]
		menu[i].value = "displayMapIcons"
		menu[i].func = (function(self)
			toggleRareScanner(self.value)
		end)
		menu[i].checked = profile.map.displayMapIcons
		i = i + 1
		
		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = LRS["MAP_MENU_DISABLE_LAST_SEEN_FILTER"]
		menu[i].value = "disableLastSeenFilter"
		menu[i].func = (function(self)
			toggleRareScanner(self.value)
		end)
		menu[i].checked = profile.map.disableLastSeenFilter
		i = i + 1
		
		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = LRS["MAP_MENU_SHOW_NOT_DISCOVERED"]
		menu[i].value = "displayNotDiscoveredMapIcons"
		menu[i].func = (function(self)
			toggleRareScanner(self.value)
		end)
		menu[i].checked = profile.map.displayNotDiscoveredMapIcons
		i = i + 1
		
		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = LRS["MAP_MENU_SHOW_NOT_DISCOVERED_OLD"]
		menu[i].value = "displayOldNotDiscoveredMapIcons"
		menu[i].func = (function(self)
			toggleRareScanner(self.value)
		end)
		menu[i].checked = profile.map.displayOldNotDiscoveredMapIcons
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		menu[i].text = L["RareScanner Config"]
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].tooltipTitle = mode_name
		menu[i].tooltipText = L["Click to open RareScanner's config panel"]
		menu[i].tooltipOnButton = true
		menu[i].func = (function(self)
			ToggleFrame(WorldMapFrame)
			InterfaceOptionsFrame_OpenToCategory("RareScanner")
			InterfaceOptionsFrame_OpenToCategory("RareScanner")
			InterfaceOptionsFrame_OpenToCategory(LRS["MAP_OPTIONS"])
		end)
		
		return menu
	else
		return nil
	end
end
