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

local MODNAME = "PT"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local PT = addon:NewModule(MODNAME)

local iPetTracker = select(4, GetAddOnInfo("PetTracker"));
function PT:OnEnable()
	if (not iPetTracker) then 
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
	if (iPetTracker) then
		local menu = {}
		
		menu[1] = {}
		menu[1].isNotRadio = true
		menu[1].keepShownOnClick = true
		menu[1].text = PETS
		menu[1].func = ToggleSpecies
		menu[1].checked = CheckActiveSpecies

		menu[2] = {}
		menu[2].isNotRadio = true
		menu[2].keepShownOnClick = true
		menu[2].text = MINIMAP_TRACKING_STABLEMASTER
		menu[2].func = ToggleStables
		menu[2].checked = CheckActiveStables
		
		return menu
	else
		return nil
	end
end