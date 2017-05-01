-- $Id$
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
-- Libraries
local GameTooltip = GameTooltip
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)

local addon = LibStub("AceAddon-3.0"):NewAddon(private.addon_name)
addon.constants = private.constants
addon.HandyNotes = private.HandyNotes
addon.GatherMate2 = private.GatherMate2
addon.constants.addon_name = private.addon_name
addon.Name = FOLDER_NAME
_G.WorldMapTrackingEnhanced = addon
local db

local iHandyNotes = select(4, GetAddOnInfo("HandyNotes"));
local iGatherMate2 = select(4, GetAddOnInfo("GatherMate2"));

-- //////////////////////////////////////////////////////////////////////////
function addon:OnInitialize()
	FilterButton = WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button
end

function addon:OnEnable()
	for key, value in pairs( addon.constants.events ) do
		self:RegisterEvent( value );
	end
	self:CreateTrackingButton()
	FilterButton:Hide()
end

function addon:Refresh()
end

function addon:CreateTrackingButton()
	addon.dropDown = CreateFrame("Frame", private.addon_name.."DropDown", WorldMapFrame.UIElementsFrame.TrackingOptionsButton, "Lib_UIDropDownMenuTemplate");
	addon.dropDown:SetScript("OnShow", function(self) 
		Lib_UIDropDownMenu_Initialize(self, addon.WorldMapTrackingOptionsDropDown_Initialize, "MENU") 
	end);
	
	addon.button = CreateFrame("Button", private.addon_name.."Button", WorldMapFrame.UIElementsFrame.TrackingOptionsButton)
	addon.button:SetWidth(32)
	addon.button:SetHeight(32)
		
	addon.button:SetPoint("TOPLEFT", WorldMapFrame.UIElementsFrame.TrackingOptionsButton, 0, 0, "TOPLEFT");
		
	addon.button.border = addon.button:CreateTexture(private.addon_name.."ButtonBorder","BORDER")
	addon.button.border:SetPoint("TOPLEFT", addon.button, "TOPLEFT")
	addon.button.border:SetWidth(54)
	addon.button.border:SetHeight(54)
	addon.button.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	--[[
	addon.button.overlay = addon.button:CreateTexture(private.addon_name.."ButtonOverlay","OVERLAY")
	addon.button.overlay:SetWidth(27)
	addon.button.overlay:SetHeight(27)
	addon.button.overlay:SetPoint("TOPLEFT", addon.button, "TOPLEFT", 2, -2)
	addon.button.overlay:SetTexture("Interface\\ComboFrame\\ComboPoint")
	addon.button.overlay:SetTexCoord(0.5625, 1, 0, 1)
	]]
	addon.button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

	addon.button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(TRACKING, 1, 1, 1)
		GameTooltip:AddLine(MINIMAP_TRACKING_TOOLTIP_NONE, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	addon.button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	addon.button:SetScript("OnClick", function(self)
		local parent = self:GetParent()
		Lib_ToggleDropDownMenu(1, nil, addon.dropDown, parent, 0, -5)
		PlaySound("igMainMenuOptionCheckBoxOn")
	end)
	addon.button:SetScript("OnMouseDown", function(self)
		local parent = self:GetParent();
		parent.Icon:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, -8);
		parent.IconOverlay:Show();
	end)
	addon.button:SetScript("OnMouseUp", function(self)
		local parent = self:GetParent();
		parent.Icon:SetPoint("TOPLEFT", parent, "TOPLEFT", 6, -6);
		parent.IconOverlay:Hide();
	end)
end

function addon.WorldMapTrackingOptionsDropDown_Initialize()
	local info = Lib_UIDropDownMenu_CreateInfo()

	info.isTitle = true
	info.notCheckable = true
	info.text = WORLD_MAP_FILTER_TITLE
	Lib_UIDropDownMenu_AddButton(info)

	info.isTitle = nil
	info.disabled = nil
	info.notCheckable = nil
	info.isNotRadio = true
	info.keepShownOnClick = true
	info.func = WorldMapTrackingOptionsDropDown_OnClick

	info.text = SHOW_QUEST_OBJECTIVES_ON_MAP_TEXT
	info.value = "quests"
	info.checked = GetCVarBool("questPOI")
	Lib_UIDropDownMenu_AddButton(info)

	local prof1, prof2, arch, fish, cook, firstAid = GetProfessions()
	if arch then
		info.text = ARCHAEOLOGY_SHOW_DIG_SITES
		info.value = "digsites"
		info.checked = GetCVarBool("digSites")
		Lib_UIDropDownMenu_AddButton(info)
	end

	if CanTrackBattlePets() then
		info.text = SHOW_PET_BATTLES_ON_MAP_TEXT
		info.value = "tamers"
		info.checked = GetCVarBool("showTamers")
		Lib_UIDropDownMenu_AddButton(info)
	end

	-- If we aren't on a map with world quests don't show the world quest reward filter options.
	if (WorldMapFrame.UIElementsFrame.BountyBoard and WorldMapFrame.UIElementsFrame.BountyBoard:AreBountiesAvailable()) then

		if prof1 or prof2 then
			info.text = SHOW_PRIMARY_PROFESSION_ON_MAP_TEXT
			info.value = "primaryProfessionsFilter"
			info.checked = GetCVarBool("primaryProfessionsFilter")
			Lib_UIDropDownMenu_AddButton(info)
		end

		if fish or cook or firstAid then
			info.text = SHOW_SECONDARY_PROFESSION_ON_MAP_TEXT
			info.value = "secondaryProfessionsFilter"
			info.checked = GetCVarBool("secondaryProfessionsFilter")
			Lib_UIDropDownMenu_AddButton(info)
		end

		Lib_UIDropDownMenu_AddSeparator(info)
		-- Clear out the info from the separator wholesale.
		info = Lib_UIDropDownMenu_CreateInfo()

		info.isTitle = true
		info.notCheckable = true
		info.text = WORLD_QUEST_REWARD_FILTERS_TITLE
		Lib_UIDropDownMenu_AddButton(info)
		info.text = nil

		info.isTitle = nil
		info.disabled = nil
		info.notCheckable = nil
		info.isNotRadio = true
		info.keepShownOnClick = true
		info.func = WorldMapTrackingOptionsDropDown_OnClick

		info.text = WORLD_QUEST_REWARD_FILTERS_ORDER_RESOURCES
		info.value = "worldQuestFilterOrderResources"
		info.checked = GetCVarBool("worldQuestFilterOrderResources")
		Lib_UIDropDownMenu_AddButton(info)

		info.text = WORLD_QUEST_REWARD_FILTERS_ARTIFACT_POWER
		info.value = "worldQuestFilterArtifactPower"
		info.checked = GetCVarBool("worldQuestFilterArtifactPower")
		Lib_UIDropDownMenu_AddButton(info)

		info.text = WORLD_QUEST_REWARD_FILTERS_PROFESSION_MATERIALS
		info.value = "worldQuestFilterProfessionMaterials"
		info.checked = GetCVarBool("worldQuestFilterProfessionMaterials")
		Lib_UIDropDownMenu_AddButton(info)

		info.text = WORLD_QUEST_REWARD_FILTERS_GOLD
		info.value = "worldQuestFilterGold"
		info.checked = GetCVarBool("worldQuestFilterGold")
		Lib_UIDropDownMenu_AddButton(info)
		
		info.text = WORLD_QUEST_REWARD_FILTERS_EQUIPMENT
		info.value = "worldQuestFilterEquipment"
		info.checked = GetCVarBool("worldQuestFilterEquipment")
		Lib_UIDropDownMenu_AddButton(info)
	end
	
	-- ////////////////////////
	if (iHandyNotes) then
		local LH = LibStub("AceLocale-3.0"):GetLocale("HandyNotes", false)
		Lib_UIDropDownMenu_AddSeparator(info)
		-- Clear out the info from the separator wholesale.
		info = Lib_UIDropDownMenu_CreateInfo()

		info.isTitle = true
		info.notCheckable = true
		info.text = LH["HandyNotes"]
		Lib_UIDropDownMenu_AddButton(info)

		info = Lib_UIDropDownMenu_CreateInfo()
		info.isNotRadio = true
		info.keepShownOnClick = true

		info.text = LH["HandyNotes"]..L[" (Core}"]
		info.colorCode = "|cFFB5E61D"
		info.tooltipTitle = LH["HandyNotes"]
		info.tooltipText = LH["Enable or disable HandyNotes"]
		info.tooltipOnButton = true
		info.checked = addon.HandyNotes.CheckHandyNotesStatus
		info.func = addon.HandyNotes.ToggleHandyNotes
		Lib_UIDropDownMenu_AddButton(info)
		
		-- Now create HandyNotes' plugins dropdown
		info = Lib_UIDropDownMenu_CreateInfo()
		info.isNotRadio = true
		info.keepShownOnClick = true
--[[	-- better to find a way to refresh dropdown and then set the disabled status
		if (addon.HandyNotes.CheckHandyNotesStatus()) then
			info.disabled = nil
		else
			info.disabled = true
		end]]
		local plugins = addon.HandyNotes.GetPlugins()
		for k, v in pairs(plugins) do
			info.text = k
			info.checked = addon.HandyNotes.CheckPluginStatus(k)
			info.func = (function(self)
				addon.HandyNotes.TogglePlugin(k)
			end)
			Lib_UIDropDownMenu_AddButton(info)
		end
	end
	if (iGatherMate2) then
		Lib_UIDropDownMenu_AddSeparator(info)
		-- Clear out the info from the separator wholesale.
		info = Lib_UIDropDownMenu_CreateInfo()

		info.isTitle = true
		info.notCheckable = true
		info.text = L["Others"]
		Lib_UIDropDownMenu_AddButton(info)

		info = Lib_UIDropDownMenu_CreateInfo()
		if (iGatherMate2) then
			local LGM = LibStub("AceLocale-3.0"):GetLocale("GatherMate2", false)
			info.isNotRadio = true
			info.keepShownOnClick = true
			info.text = select(2, GetAddOnInfo("GatherMate2"))
			info.tooltipTitle = LGM["Show World Map Icons"]
			info.tooltipText = LGM["Toggle showing World Map icons."]
			info.tooltipOnButton = true
			info.func = addon.GatherMate2.ToggleGatherMate2
			info.checked = addon.GatherMate2.CheckWorldMapStatus
			Lib_UIDropDownMenu_AddButton(info)
		end
	end
end

