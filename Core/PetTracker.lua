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

local LibStub = _G.LibStub

local PT = {}
private.PT = PT

local iPetTracker = select(4, GetAddOnInfo("PetTracker"));

do
	if (not iPetTracker) then 
		return false
	end
end

function PT.CheckActiveSpecies()
	return not PetTracker.Sets["HideSpecies"]
end
	
function PT.ToggleSpecies()
	PetTracker.Sets["HideSpecies"] = not PetTracker.Sets["HideSpecies"]
	PetTracker.WorldMap:UpdateBlips()
end

function PT.CheckActiveStables()
	return not PetTracker.Sets["HideStables"]
end
	
function PT.ToggleStables()
	PetTracker.Sets["HideStables"] = not PetTracker.Sets["HideStables"]
	PetTracker.WorldMap:UpdateBlips()
end
