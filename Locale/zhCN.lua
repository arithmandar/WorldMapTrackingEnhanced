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
L["Config"] = "设定"
L["Addon Configuration"] = "插件设定"
L["Use Separator"] = "使用分隔线"
L["Use separator in menu to separate different type of menu items"] = "使用分隔线来分隔不同的菜单项目"
L["Support"] = "支持"
L["Toggle which map enhancement addon to be included in the enhanced tracking option menu."] = "选择要将哪些地图增强的插件加入强化的地图追踪选项列表里。"
L["Profile Options"] = "配置文件选项"
L["World Map Tracking Enhanced Config"] = "强化的世界地图追踪设定"
L["Click to open World Map Tracking Enhanced's config panel"] = "点击以开启强化的世界地图追踪的选项设定视窗"
L["Modules"] = "模组"
L["Show %s module's config link in menu."] = "在菜单中显示 %s 模组的设定连结"
L["Show %s module's menu items in second level of menu."] = "将模组的菜单选项显示在第二层的菜单"

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
L["Second level menu will be forced to be created when there are more than 20 of HandyNotes plugins."] = "当有超过20个以上的 HandyNotes 插件时，将会强制显示在第二层目录"

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
-- RareScanner
-- //////////////////////////
L["RareScanner Config"] = "RareScanner 设定"
L["Click to open RareScanner's config panel"] = "点击以开启 RareScanner 的配置视窗"
L["Show RareScanner plugins in second level menu."] = "将 RareScanner 的套件清单显示在第二层菜单。"

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
