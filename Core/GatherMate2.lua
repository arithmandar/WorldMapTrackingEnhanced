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

local GatherMate2 = {}
private.GatherMate2 = GatherMate2

local GM
local iGatherMate2 = select(4, GetAddOnInfo("GatherMate2"));

do
	if (iGatherMate2) then 
		GM = LibStub("AceAddon-3.0"):GetAddon("GatherMate2") 
	else
		return false
	end
end
	
function GatherMate2.ToggleGatherMate2()
	GM.db.profile.showWorldMap = not GM.db.profile.showWorldMap
	GM:OnProfileChanged()
end

function GatherMate2.CheckWorldMapStatus()
	return GM.db.profile.showWorldMap or nil
end
