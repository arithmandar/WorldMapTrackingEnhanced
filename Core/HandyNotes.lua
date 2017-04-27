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

local HandyNotes = {}
private.HandyNotes = HandyNotes

local HN
local iHandyNotes = select(4, GetAddOnInfo("HandyNotes"));

do
	if (iHandyNotes) then 
		HN = LibStub("AceAddon-3.0"):GetAddon("HandyNotes") 
	else
		return false
	end
end
	
function HandyNotes.ToggleHandyNotes()
	HN.db.profile.enabled = not HN.db.profile.enabled
	if (HN.db.profile.enabled) then
		HN:Enable()
	else
		HN:Disable()
	end
end

function HandyNotes.CheckHandyNotesStatus()
	return HN.db.profile.enabled or nil
end

function HandyNotes.GetPlugins()
	return HN.plugins
end

function HandyNotes.CheckPluginStatus(pluginName)
	return HN.db.profile.enabledPlugins[pluginName] and true or false
end

function HandyNotes.TogglePlugin(pluginName)
	HN.db.profile.enabledPlugins[pluginName] = not HN.db.profile.enabledPlugins[pluginName]
	HN:UpdatePluginMap(nil, pluginName)
end