-- $Id$

local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("WorldMapTrackingEnhanced", "enUS", true, true);

if L then
--@do-not-package@
-- //////////////////////////
-- Addon
-- //////////////////////////

-- //////////////////////////
-- Configs
-- //////////////////////////
L["Options"] = "Options"
L["Support"] = "Support"
L["Toggle which map enhancement addon to be included in the enhanced tracking option menu."] = "Toggle which map enhancement addon to be included in the enhanced tracking option menu."
L["Profile Options"] = "Profile Options"

-- //////////////////////////
-- Common
-- //////////////////////////

-- //////////////////////////
-- HandyNotes
-- //////////////////////////
L[" (Core)"] = " (Core)" -- HandyNotes (Core)
L["Second Level Menu"] = "Second Level Menu"
L["Show HandyNotes plugins in second level menu."] = "Show HandyNotes plugins in second level menu."
L["HandyNotes Config"] = "HandyNotes Config"
L["Click to open HandyNotes' config panel"] = "Click to open HandyNotes' config panel"

-- //////////////////////////
-- GatherMate2
-- //////////////////////////
L["GatherMate2 Config"] = "GatherMate2 Config"
L["Click to open GatherMate2's config panel"] = "Click to open GatherMate2's config panel"

-- //////////////////////////
-- PetTracker
-- //////////////////////////
L["PetTracker Config"] = "PetTracker Config"
L["Click to open PetTracker's config panel"] = "Click to open PetTracker's config panel"

-- //////////////////////////
-- Others
-- //////////////////////////
L["Others"] = "Others"
L["Disable Icons on World Map"] = "Disable Icons on World Map" -- from World Quest Tracker

--@end-do-not-package@
--@localization(locale="enUS", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore", namespace="")@
end
