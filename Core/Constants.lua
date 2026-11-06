-- ----------------------------------------------------------------------------
-- World Map Tracking Enhanced - Constants
-- ----------------------------------------------------------------------------
local _G = getfenv(0)

local _, private = ...
private.addon_name = "WorldMapTrackingEnhanced"

local constants = {}
private.constants = constants

-- ----------------------------------------------------------------------------
-- Game client detection
-- One single TOC supports all clients; client specific handling is done in Lua
-- through the flags below.
-- ----------------------------------------------------------------------------
local projectID = _G.WOW_PROJECT_ID

local function IsProject(id)
	return id ~= nil and projectID == id
end

local Client = {
	projectID = projectID,
	interface = select(4, _G.GetBuildInfo()),

	isRetail = IsProject(_G.WOW_PROJECT_MAINLINE),
	isClassicEra = IsProject(_G.WOW_PROJECT_CLASSIC),
	isTBCClassic = IsProject(_G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC),
	isWrathClassic = IsProject(_G.WOW_PROJECT_WRATH_CLASSIC),
	isCataclysmClassic = IsProject(_G.WOW_PROJECT_CATACLYSM_CLASSIC),
	isMistsClassic = IsProject(_G.WOW_PROJECT_MISTS_CLASSIC),
	isForever = IsProject(_G.WOW_PROJECT_CAMELOT),
}

Client.isProgressionClassic = Client.isWrathClassic or Client.isCataclysmClassic or Client.isMistsClassic
Client.isAnyClassic = Client.isClassicEra or Client.isTBCClassic or Client.isProgressionClassic
Client.isKnownProject = Client.isRetail or Client.isAnyClassic or Client.isForever
private.Client = Client

-- ----------------------------------------------------------------------------
-- Saved variables defaults
-- ----------------------------------------------------------------------------
constants.defaults = {
	profile = {
		-- Show our own button on the World Map
		showButton = true,
		-- Put each supported addon's entries in its own sub menu
		useSubmenus = true,
		-- Separate each supported addon's entries with a divider (flat menu only)
		useSeparator = true,
		-- Show links to each supported addon's config panel in the menu
		showConfigLinks = true,
		-- Which supported addon modules are enabled; all are enabled by default
		enableModules = {
			["*"] = true,
		},
	},
}

-- Texture used for the World Map button and menu title
constants.ICON = "Interface\\Minimap\\Tracking\\None"
