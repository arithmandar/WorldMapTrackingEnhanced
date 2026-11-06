---@meta _
-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - type declarations
--
-- Annotations for lua-language-server and Ketho's WoW API extension for
-- VS Code (https://github.com/Ketho/vscode-wow-api). This file is NOT loaded
-- by the game (it is not listed in the TOC) and is excluded from packaging.
--
-- Classes which have methods (WMTEAddon, WMTETrackingModule, the button mixin)
-- are declared where they are defined, in Core\Core.lua. This file only holds
-- data shapes and the parts of the supported addons that our modules use.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- AddOn namespace (the private table passed to every file as `...`)
-- Every file declares `---@class WMTENamespace` on its own local, see
-- https://github.com/Ketho/vscode-wow-api/wiki
-- ----------------------------------------------------------------------------

---@class WMTENamespace
---@field addon_name string
---@field constants WMTEConstants
---@field Client WMTEClient

---@class WMTEConstants
---@field addon_name string
---@field defaults { profile: WMTEProfile }
---@field ICON string

-- Game client flags, see Core\Constants.lua
---@class WMTEClient
---@field projectID number?
---@field interface number
---@field isRetail boolean
---@field isClassicEra boolean
---@field isTBCClassic boolean
---@field isWrathClassic boolean
---@field isCataclysmClassic boolean
---@field isMistsClassic boolean
---@field isForever boolean
---@field isProgressionClassic boolean
---@field isAnyClassic boolean
---@field isKnownProject boolean

-- ----------------------------------------------------------------------------
-- Saved variables
-- ----------------------------------------------------------------------------

---@class WMTEProfile
---@field showButton boolean
---@field useSubmenus boolean
---@field useSeparator boolean
---@field showConfigLinks boolean
---@field enableModules table<string, boolean>

---@class WMTEDatabase : AceDBObject-3.0
---@field profile WMTEProfile

-- ----------------------------------------------------------------------------
-- Tracking modules
-- ----------------------------------------------------------------------------

-- The menu description a module adds its entries to: the root menu (flat
-- layout) or the module's own sub menu button.
---@alias WMTEMenuDescription RootMenuDescriptionProxy|ElementMenuDescriptionProxy

---@class WMTETrackingModuleInfo
---@field title? string|fun(module: WMTETrackingModule): string Display name, defaults to the module name
---@field order? number Menu position, defaults to 100
---@field addons? string[] The module is available when any of these addons is loaded

-- ----------------------------------------------------------------------------
-- Supported addons. Only the parts used by our modules are declared.
-- ----------------------------------------------------------------------------

---@class WMTE.HandyNotes : AceAddon
---@field db { profile: { enabled: boolean, enabledPlugins: table<string, boolean> } }
---@field plugins table<string, table>
---@field UpdatePluginMap fun(self: WMTE.HandyNotes, message: string?, pluginName: string)

---@class WMTE.GatherMate2 : AceAddon
---@field db { profile: { showWorldMap: boolean, show: table<string, string> } }
---@field OnProfileChanged? fun(self: WMTE.GatherMate2)

---@class WMTE.PetTracker
---@field sets table<string, any>
---@field GetOption fun(key: string): any
---@field ToggleOption fun(key: string)
---@field Options? { Open: fun(self: table) }

---@class WMTE.RareScanner : AceAddon
---@field db { profile: { map: table<string, boolean> } }

---@class WMTE.Routes.Route
---@field route number[]
---@field hidden boolean
---@field visible boolean
---@field editing? boolean

---@class WMTE.Routes.Defaults
---@field draw_worldmap boolean
---@field draw_minimap boolean
---@field draw_battlemap boolean
---@field draw_indoors boolean
---@field show_hidden boolean

---@class WMTE.Routes : AceAddon
---@field db { global: { defaults: WMTE.Routes.Defaults, routes: table<number, table<string, WMTE.Routes.Route>> } }
---@field options AceConfig.OptionsTable
---@field DataProvider? table
---@field DrawWorldmapLines fun(self: WMTE.Routes)
---@field DrawMinimapLines fun(self: WMTE.Routes, forceUpdate: boolean?)

---@class WMTE.AtlasLoot
---@field GUI? { Toggle: fun(self: table) }
---@field WorldMap? { Button_OnClick: fun() }

-- ----------------------------------------------------------------------------
-- Blizzard API which is not (yet) covered by vscode-wow-api
-- ----------------------------------------------------------------------------

---@class DropdownButtonMixin
local DropdownButtonMixin = {}

---@param generator fun(owner: Frame, rootDescription: RootMenuDescriptionProxy)
function DropdownButtonMixin:SetupMenu(generator) end

---@param anchor table AnchorMixin, e.g. from AnchorUtil.CreateAnchor()
function DropdownButtonMixin:SetMenuAnchor(anchor) end
