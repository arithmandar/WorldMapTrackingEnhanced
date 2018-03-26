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

local MODNAME = "PetTracker"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local PT = addon:NewModule(MODNAME)

local iPetTracker = select(4, GetAddOnInfo("PetTracker"))
local enabled = GetAddOnEnableState(UnitName("player"), "PetTracker")

function PT:OnEnable()
	if (enabled > 0 and iPetTracker) then 
	else
		return false
	end
end

local function CheckActiveSpecies()
	return not PetTracker.Sets["HideSpecies"]
end
	
local function ToggleSpecies()
	PetTracker.Sets["HideSpecies"] = not PetTracker.Sets["HideSpecies"]
	PetTracker.WorldMap:UpdateBlips()
end

local function CheckActiveStables()
	return not PetTracker.Sets["HideStables"]
end
	
local function ToggleStables()
	PetTracker.Sets["HideStables"] = not PetTracker.Sets["HideStables"]
	PetTracker.WorldMap:UpdateBlips()
end

function PT:DropDownMenus()
	if (enabled > 0 and iPetTracker) then
		local menu = {}
		local i = 1
		local mode_name = select(2, GetAddOnInfo("PetTracker")) or MODNAME
		local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
		
		menu[i] = {}
		menu[i].notCheckable = true
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].hasArrow = true
		menu[i].value = MODNAME
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].text = mode_name or MODNAME or PETS
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = PetTracker.Locals.Species or L["Species"]
		menu[i].func = ToggleSpecies
		menu[i].checked = CheckActiveSpecies
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = MINIMAP_TRACKING_STABLEMASTER
		menu[i].func = ToggleStables
		menu[i].checked = CheckActiveStables
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		menu[i].text = L["PetTracker Config"]
		menu[i].colorCode = "|cFFFFC90E"
		menu[i].tooltipTitle = mode_name
		menu[i].tooltipText = L["Click to open PetTracker's config panel"]
		menu[i].tooltipOnButton = true
		menu[i].func = (function(self)
			ToggleFrame(WorldMapFrame)
			InterfaceOptionsFrame_OpenToCategory("PetTracker")
			InterfaceOptionsFrame_OpenToCategory("PetTracker")
		end)
		
		return menu
	else
		return nil
	end
end