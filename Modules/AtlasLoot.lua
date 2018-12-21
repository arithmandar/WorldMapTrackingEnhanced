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

local MODNAME = "AtlasLoot"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local AL = addon:NewModule(MODNAME)

local AT, profile

local iAtlasLoot = select(4, GetAddOnInfo(MODNAME))
local enabled = GetAddOnEnableState(UnitName("player"), MODNAME)

function AL:OnEnable()
	if (enabled > 0 and iAtlasLoot) then 
	else
		return false
	end
end

function AL:DropDownMenus()
	if (enabled > 0 and iAtlasLoot) then
		local menu = {}
		local i = 1
		local mode_name = select(2, GetAddOnInfo("AtlasLoot")) or "AtlasLoot"
		
		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		--menu[i].keepShownOnClick = true
		menu[i].hasArrow = nil
		menu[i].value = MODNAME
		menu[i].colorCode = "|cFFFFC90E"
		menu[i].text = mode_name
		menu[i].tooltipTitle = mode_name
		menu[i].tooltipText = select(3, GetAddOnInfo("AtlasLoot")) or nil
		menu[i].tooltipOnButton = true
		menu[i].func = AtlasLoot.WorldMap.Button_OnClick
		menu[i].checked = nil
		menu[i].icon = "Interface\\AddOns\\AtlasLoot\\Images\\AtlasLootButton-Up"

		return menu
	else
		return nil
	end
end
