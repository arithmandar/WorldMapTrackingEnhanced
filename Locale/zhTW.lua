-- $Id$

local L = LibStub("AceLocale-3.0"):NewLocale("WorldMapTrackingEnhanced", "zhTW", false)

if not L then return end

if L then
--@do-not-package@
-- //////////////////////////
-- Addon
-- //////////////////////////

-- //////////////////////////
-- Configs
-- //////////////////////////
L["Options"] = "選項"
L["Support"] = "支援"
L["Toggle which map enhancement addon to be included in the enhanced tracking option menu."] = "選擇要將哪些地圖增強的插件加入強化的地圖追蹤選項清單裡。"
L["Profile Options"] = "設定檔選項"

-- //////////////////////////
-- Common
-- //////////////////////////
L["Second Level Menu"] = "第二層選單"

-- //////////////////////////
-- HandyNotes
-- //////////////////////////
L[" (Core)"] = " (核心主程式)"
L["Show HandyNotes plugins in second level menu."] = "將 HandyNotes 的套件清單顯示在第二層選單。"
L["HandyNotes Config"] = "HandyNotes 設定"
L["Click to open HandyNotes' config panel"] = "點擊以開啟 HandyNotes 的選項設定視窗"

-- //////////////////////////
-- GatherMate2
-- //////////////////////////
L["GatherMate2 Config"] = "GatherMate2 設定"
L["Click to open GatherMate2's config panel"] = "點擊以開啟 GatherMate2 的選項設定視窗"

-- //////////////////////////
-- PetTracker
-- //////////////////////////
L["PetTracker Config"] = "PetTracker 設定"
L["Click to open PetTracker's config panel"] = "點擊以開啟 PetTracker 的選項設定視窗"

-- //////////////////////////
-- WorldQuestTracker
-- //////////////////////////
L["Show WorldQuestTracker's filter selections in second level menu."] = "將 World Quest Tracker 的過濾清單顯示在第二層選單。"
L["Disable Icons on World Map"] = "在世界地圖上不顯示圖示" -- from World Quest Tracker

-- //////////////////////////
-- Others
-- //////////////////////////
L["Others"] = "其他"

--@end-do-not-package@
--@localization(locale="zhTW", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore", namespace="")@
end