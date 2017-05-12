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
L["Second Level Menu"] = "第二層選單"
L["Show HandyNotes plugins in second level menu."] = "將 HandyNotes 的套件清單顯示在第二層選單。"
L["Profile Options"] = "設定檔選項"
L["HandyNotes Config"] = "HandyNotes 設定"
L["Click to open HandyNotes' config panel"] = "點擊以開啟 HandyNotes 的選項設定視窗"

-- //////////////////////////
-- Common
-- //////////////////////////

-- //////////////////////////
-- Others
-- //////////////////////////
L[" (Core}"] = " (核心主程式}"
L["Others"] = "其他"

--@end-do-not-package@
--@localization(locale="zhTW", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore", namespace="")@
end