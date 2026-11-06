## About World Map Tracking Enhanced

**World Map Tracking Enhanced** is a World of Warcraft addon that adds a tracking button to the World Map. Use the button to control the map icons and options of popular map addons, such as HandyNotes, GatherMate2, PetTracker and RareScanner, without opening each addon's settings panel.

From v5.0.0 the addon no longer replaces or copies the World Map's built-in tracking / filter menu. Blizzard's own filters are left untouched. World Map Tracking Enhanced adds its own independent button next to the other World Map buttons.

## Supported Game Clients

One package supports all of these clients through a single TOC file:

| Client | Interface |
| --- | --- |
| Retail | 12.1.5, 12.1.7 (PTR) |
| Mists of Pandaria Classic | 5.5.4 |
| Burning Crusade Classic Anniversary | 2.5.6 |
| Classic Era | 1.15.9 |
| WoW Forever | 1.60.1 |

A module is available only when its addon is installed and loaded on your client.

## Supported Addons

| Addon | Menu items |
| --- | --- |
| HandyNotes | Enable / disable HandyNotes, toggle each HandyNotes plugin, Select All / Select None |
| GatherMate2 | Toggle World Map icons, and set the display mode of each node type (Always / With Profession / Active / Never) |
| PetTracker | Species, Stable Masters, Species Icons, Rival Portraits |
| RareScanner | Rare NPC, container and event icons, plus their "not discovered" icons |
| Atlas | Open Atlas on the map that matches the World Map, toggle Atlas' own World Map button |
| AtlasLoot / AtlasLootClassic | Open AtlasLoot |

Each module can also show a link to the addon's own config panel.

## Features

* An independent World Map button. Its position is handled by [Krowi_WorldMapButtons](https://github.com/TheKrowi/Krowi_WorldMapButtons), so it lines up with Blizzard's buttons and other addons' buttons.
* A menu built with Blizzard's Menu API, matching the look of the built-in World Map menus.
* Changes take effect on the World Map right away.
* Each supported addon can be shown in its own submenu, or as a flat list with separators.
* Each module can be turned on or off.
* Translations are included for enUS, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN and zhTW.

## Slash Commands

| Command | Description |
| --- | --- |
| `/wmte` or `/worldmaptrackingenhanced` | Open the options panel |
| `/wmte show` | Show the World Map button |
| `/wmte hide` | Hide the World Map button |

## Options

* **Show World Map button**: show or hide the button on the World Map.
* **Second Level Menu**: show each supported addon's menu items in a submenu.
* **Use Separator**: separate the entries of each supported addon. Applies only when second level menus are turned off.
* **Show Config Links**: show links to each supported addon's config panel.
* **Modules**: choose which supported addons are included in the menu.
* **Profiles**: AceDB profile management.

## For Addon Developers

Each supported addon is a module. To add a new module, create a Lua file under `Modules/` and add it to `Modules.xml`:

```lua
local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)

local module = addon:NewTrackingModule("MyAddon", {
	title = "My Addon",      -- shown in the menu and options
	order = 100,             -- menu position
	addons = { "MyAddon" },  -- the module is available if any of these is loaded
})

-- Required: add menu items to the Blizzard Menu description
function module:BuildMenu(description, mapID)
	description:CreateCheckbox("Show icons", IsSelected, SetSelected)
end

-- Optional
function module:OpenConfig() end   -- adds a config link to the menu
function module:IsAvailable() end  -- overrides the default loaded-addon check
```

## Libraries

* Ace3: AceAddon, AceEvent, AceDB, AceDBOptions, AceGUI, AceConfig, AceLocale
* LibStub, CallbackHandler-1.0
* Krowi_WorldMapButtons

The libraries are added during packaging through `.pkgmeta` externals.

## Links

* [CurseForge](https://www.curseforge.com/wow/addons/world-map-tracking-enhanced)
* [GitHub](https://github.com/arithmandar/WorldMapTrackingEnhanced)
* [Revision History](Docs/Revisions.md)

## Support and Feedback

If you find a problem or have a suggestion, please use the CurseForge comments or the project's [issue tracker](https://github.com/arithmandar/WorldMapTrackingEnhanced/issues).

When you report a problem, please include:

* Your WoW client version and game branch.
* Your game client's locale.
* The supported addons you use, and their versions.
* What happened, and the steps to reproduce it if possible.
* A screenshot or the error message, if available.

## License

GPLv2
