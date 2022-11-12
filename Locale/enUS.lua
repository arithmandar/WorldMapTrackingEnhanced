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
L["Config"] = "Config"
L["Addon Info"] = "Addon Info"
L["Author"] = "Author"
L["Addon Configuration"] = "Addon Configuration"
L["Use Separator"] = "Use Separator"
L["Use separator in menu to separate different type of menu items"] = "Use separator in menu to separate different type of menu items"
L["Support"] = "Support"
L["Toggle which map enhancement addon to be included in the enhanced tracking option menu."] = "Toggle which map enhancement addon to be included in the enhanced tracking option menu."
L["Profile Options"] = "Profile Options"
L["World Map Tracking Enhanced Config"] = "World Map Tracking Enhanced Config"
L["Click to open World Map Tracking Enhanced's config panel"] = "Click to open World Map Tracking Enhanced's config panel"
L["Modules"] = "Modules"
L["Show %s module's config link in menu."] = "Show %s module's config link in menu."
L["Show %s module's menu items in second level of menu."] = "Show %s module's menu items in second level of menu."
L["Icon on left"] = "Icon on left"
L["Move filter icon on map frame's left side.\nRequires to reload addon to take effect."] = "Move filter icon on map frame's left side.\nRequires to reload addon to take effect."
L["Independent Button"] = "Independent Button"
L["Use an independent filter button and place closed to WorldMap frame's buttons on the top-right corner.\nRequires to reload addon to take effect."] = "Use an independent filter button and place closed to WorldMap frame's buttons on the top-right corner.\nRequires to reload addon to take effect."
-- //////////////////////////
-- Common
-- //////////////////////////
L["Second Level Menu"] = "Second Level Menu"

-- //////////////////////////
-- HandyNotes
-- //////////////////////////
L[" (Core)"] = " (Core)" -- HandyNotes (Core)
L["Show HandyNotes plugins in second level menu."] = "Show HandyNotes plugins in second level menu."
L["HandyNotes Config"] = "HandyNotes Config"
L["Click to open HandyNotes' config panel"] = "Click to open HandyNotes' config panel"
L["Second level menu will be forced to be created when there are more than 20 of HandyNotes plugins."] = "Second level menu will be forced to be created when there are more than 20 of HandyNotes plugins."

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
-- RareScanner
-- //////////////////////////
L["RareScanner Config"] = "RareScanner Config"
L["Click to open RareScanner's config panel"] = "Click to open RareScanner's config panel"
L["Show RareScanner plugins in second level menu."] = "Show RareScanner plugins in second level menu."

-- //////////////////////////
-- WorldQuestTracker
-- //////////////////////////
L["Show WorldQuestTracker's filter selections in second level menu."] = "Show WorldQuestTracker's filter selections in second level menu."
L["Disable Icons on World Map"] = "Disable Icons on World Map" -- from World Quest Tracker

-- //////////////////////////
-- Others
-- //////////////////////////
L["Others"] = "Others"

--@end-do-not-package@
--@localization(locale="enUS", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore", namespace="")@
end
