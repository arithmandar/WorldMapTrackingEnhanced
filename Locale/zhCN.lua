-- $Id$

local L = LibStub("AceLocale-3.0"):NewLocale("WorldMapTrackingEnhanced", "zhCN", false)

if not L then return end

if L then
--@do-not-package@
-- //////////////////////////
-- Addon
-- //////////////////////////

-- //////////////////////////
-- Configs
-- //////////////////////////
L["Options"] = "选项"
L["Support"] = "支持"
L["Toggle which map enhancement addon to be included in the enhanced tracking option menu."] = "选择要将哪些地图增强的插件加入强化的地图追踪选项列表里。"
L["Profile Options"] = "配置文件选项"

-- //////////////////////////
-- Common
-- //////////////////////////
L["Second Level Menu"] = "第二层菜单"

-- //////////////////////////
-- HandyNotes
-- //////////////////////////
L[" (Core)"] = " (核心主程序)"
L["Show HandyNotes plugins in second level menu."] = "将 HandyNotes 的套件列表显示在第二层菜单。"
L["HandyNotes Config"] = "HandyNotes 配置"
L["Click to open HandyNotes' config panel"] = "点击以开启 HandyNotes 的选项配置窗口"

-- //////////////////////////
-- GatherMate2
-- //////////////////////////
L["GatherMate2 Config"] = "GatherMate2 配置"
L["Click to open GatherMate2's config panel"] = "点击以开启 GatherMate2 的选项配置视窗"

-- //////////////////////////
-- PetTracker
-- //////////////////////////
L["PetTracker Config"] = "PetTracker 配置"
L["Click to open PetTracker's config panel"] = "点击以开启 PetTracker 的选项配置视窗"

-- //////////////////////////
-- WorldQuestTracker
-- //////////////////////////
L["Show WorldQuestTracker's filter selections in second level menu."] = "将 World Quest Tracker 的过滤清单显示在第二层菜单。"
L["Disable Icons on World Map"] = "在世界地图上不显示图标" -- from World Quest Tracker

-- //////////////////////////
-- Others
-- //////////////////////////
L["Others"] = "其他"

--@end-do-not-package@
--@localization(locale="zhCN", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore", namespace="")@
end
