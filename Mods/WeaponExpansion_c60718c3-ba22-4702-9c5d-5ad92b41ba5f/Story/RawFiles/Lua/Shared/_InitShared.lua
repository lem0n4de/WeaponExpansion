LeaderLib = Mods.LeaderLib

---@type GameHelpers
GameHelpers = LeaderLib.GameHelpers
Common = LeaderLib.Common
StringHelpers = LeaderLib.StringHelpers
LocalizedText = LeaderLib.LocalizedText
printd = LeaderLib.PrintDebug

SKILL_STATE = LeaderLib.SKILL_STATE

Main = {}
Debug = {
	MasteryTests = false
}
Math = { AbilityScaling = {}}
Text = {}
Mastery = {
	Params = {},
	Variables = {},
	PermanentMasteries = {
		LLWEAPONEX_ThrowingAbility = true
	},
	AdditionalRankText = {}
}
LeaveActionData = {}
Temp = {
	StatusSource = {},
	OriginalUniqueStats = {}
}
Vars = {
	GAME_STARTED = false,
	SEND_USER_ID = false,
	isInCharacterCreation = false,
	DebugEnabled = Ext.IsDeveloperMode() == true
}

Skills = {
	Params = {},
	DamageParam = {},
	Damage = {},
	DamageFunctions = {},
	WarfareMeleeSkills = {},
	ScoundrelMeleeSkills = {},
}

AttributeScaleTables = {
	NoMemory = {"Strength", "Finesse", "Intelligence", "Wits", "Constitution"},
	Default = {"Strength", "Finesse", "Intelligence"},
}

--- @type table<string,string>
Tags = {}

UI = {}

Origin = {
	-- S_Player_LLWEAPONEX_Harken_e446752a-13cc-4a88-a32e-5df244c90d8b
	Harken = "e446752a-13cc-4a88-a32e-5df244c90d8b",
	-- S_Player_LLWEAPONEX_Korvash_3f20ae14-5339-4913-98f1-24476861ebd6
	Korvash = "3f20ae14-5339-4913-98f1-24476861ebd6",
}

NPC = {
	VendingMachine = "680d2702-721c-412d-b083-4f5e816b945a",
	BishopAlexander = "03e6345f-1bd3-403c-80e2-a443a74f6349",
	Dallis = "69b951dc-55a4-44b8-a2d5-5efedbd7d572",
	Slane = "c099caa6-1938-4b4f-9365-d0881c611e71",
	UniqueHoldingChest = "80976258-a7a5-4430-b102-ba91a604c23f"
}

MODID = {
	DivinityUnleashed = "e844229e-b744-4294-9102-a7362a926f71",
	ArmorMitigation = "edf1898c-d375-47e7-919a-11d5d44d1cca",
	EE2Core = "63bb9b65-2964-4c10-be5b-55a63ec02fa0",
}

Ext.Require("Shared/MasteryHelpers.lua")
Ext.Require("Shared/MasteryRegistration.lua")
Ext.Require("Shared/Damage/GameMathAlternatives.lua")
Ext.Require("Shared/StatOverrides.lua")
Ext.Require("Shared/Data/LocalizedText.lua")
Ext.Require("Shared/Data/MasteryData_Classes.lua")
Ext.Require("Shared/Data/MasteryData_Masteries.lua")
Ext.Require("Shared/Data/MasteryData_RankBonuses.lua")
Ext.Require("Shared/Data/WeaponTypesTags.lua")
Ext.Require("Shared/Data/UnarmedWeaponStats.lua")
Ext.Require("Shared/Data/PresetEntries.lua")
Ext.Require("Shared/Damage/AbilityBasedScaling.lua")
Ext.Require("Shared/SkillAPListener.lua")
Ext.Require("Shared/Damage/SkillDamageFunctions.lua")
Ext.Require("Shared/Helpers/UnarmedHelpers.lua")
Ext.Require("Shared/Damage/UnarmedScalingMath.lua")
Ext.Require("Shared/Damage/UnarmedDamageScaling.lua")
Ext.Require("Shared/ExtenderHelpers.lua")
Ext.Require("Shared/SharedDataHooks.lua")
Ext.Require("Shared/Items/RunicCannon.lua")
local initSettings = Ext.Require("Shared/Settings.lua")

---@type ModSettings
Settings = nil

if Vars.DebugEnabled then
	--Ext.Require("Shared/Debug/GameMathTracing.lua")
end

local defaultExperienceAmounts = {
	[0] = {Amount = 45, Required = 0},
	[1] = {Amount = 30, Required = 1000},
	[2] = {Amount = 20, Required = 3000},
	[3] = {Amount = 12, Required = 6000},
	[4] = {Amount = 0, Required = 12000},
	--[5] = {Amount = 0, Required = 36000},
}

LeaderLib.RegisterLeaveActionPrefix("LLWEAPONEX")

local function SetupFemaleKorvash()
	Ext.AddPathOverride("Mods/WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f/CharacterCreation/OriginPresets/LLWEAPONEX_Korvash.lsx", "Mods/WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f/Overrides/LLWEAPONEX_Korvash_Female.lsx")
	Ext.AddPathOverride("Mods/WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f/Globals/TestLevel_LL_WeaponExpansion/Characters/S_Player_LLWEAPONEX_Korvash_3f20ae14-5339-4913-98f1-24476861ebd6.lsf", "Mods/WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f/Overrides/S_Player_LLWEAPONEX_Korvash_Female_3f20ae14-5339-4913-98f1-24476861ebd6.lsf")
	GameHelpers.VoiceMetaData.Register.ScholarFemale(Origin.Korvash)
end

Ext.RegisterListener("ModuleLoading", function()
	local femaleKorvash = false--Ext.ExtraData.LLWEAPONEX_Origins_FemaleKorvashEnabled == 1
	if femaleKorvash then
		SetupFemaleKorvash()
	else
		GameHelpers.VoiceMetaData.Register.ScholarMale(Origin.Korvash)
	end
	--Harken
	GameHelpers.VoiceMetaData.Register.WarriorMale(Origin.Harken)
end)

local function LoadExperienceVariables()	
	local RankVariables = {}
	local maxRank = math.tointeger(Ext.ExtraData["LLWEAPONEX_Mastery_MaxRank"] or 4.0)
	local lastRankExpGain = 45
	local lastRequiredNextLevelExperience = 1000
	for i=0,maxRank+1,1 do
		local rankGain = Ext.ExtraData["LLWEAPONEX_Mastery_ExperienceGain"..tostring(i)] or nil
		if rankGain == nil then
			local defaultRankGain = defaultExperienceAmounts[i]
			if defaultRankGain ~= nil then
				rankGain = defaultRankGain.Amount
			else
				rankGain = lastRankExpGain / 2
			end
		end
		local requiredNextLevelExperience = Ext.ExtraData["LLWEAPONEX_Mastery_RequiredExperience"..tostring(i)] or nil
		if requiredNextLevelExperience == nil then
			local defaultRequiredNextLevelExperience = defaultExperienceAmounts[i]
			if defaultRequiredNextLevelExperience ~= nil then
				requiredNextLevelExperience = defaultRequiredNextLevelExperience.Required
			else
				lastRequiredNextLevelExperience = lastRequiredNextLevelExperience * 1.5
			end
		end
		RankVariables[i] = {
			Amount = rankGain,
			Required = requiredNextLevelExperience
		}
		lastRankExpGain = rankGain
		lastRequiredNextLevelExperience = requiredNextLevelExperience
	end
	--printd("[WeaponExpansion] Loaded mastery experience variables:")
	--printd("==========================")
	--printd(LeaderLib.Common.Dump(RankVariables))
	--printd("==========================")

	Mastery.Variables.MaxRank = math.floor(maxRank)
	Mastery.Variables.RankVariables = RankVariables

	for i,skill in pairs(Ext.GetStatEntries("SkillData")) do
		---@type StatRequirement[]
		local requirements = Ext.StatGetAttribute(skill, "Requirements")
		if requirements ~= nil then
			for i,v in pairs(requirements) do
				if v.Param == "LLWEAPONEX_NoMeleeWeaponEquipped" then
					Skills.WarfareMeleeSkills[skill] = true
					break
				elseif v.Param == "LLWEAPONEX_CannotUseScoundrelSkills" then
					Skills.ScoundrelMeleeSkills[skill] = true
					break
				end
			end
		end
	end
end

Ext.RegisterListener("SessionLoaded", function()
	Settings = initSettings()

	LoadExperienceVariables()
	LeaderLib.EnableFeature("ApplyBonusWeaponStatuses")
	LeaderLib.EnableFeature("FixChaosDamageDisplay")
	LeaderLib.EnableFeature("FixCorrosiveMagicDamageDisplay")
	LeaderLib.EnableFeature("FixRifleWeaponRequirement")
	LeaderLib.EnableFeature("StatusParamSkillDamage")
	LeaderLib.EnableFeature("TooltipGrammarHelper")
    LeaderLib.EnableFeature("ReplaceTooltipPlaceholders")
    LeaderLib.EnableFeature("FixFarOutManSkillRangeTooltip")
	LeaderLib.EnableFeature("FormatTagElementTooltips")
end)

Ext.AddPathOverride("Mods/Helaene_Class_Marauder_53ed8826-71d6-452a-b9e5-faef35da8628/CharacterCreation/ClassPresets/Class_Marauder.lsx", "Mods/WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f/Overrides/LLWEAPONEX_Helaene_Marauder.lsx")

SharedData = LeaderLib.SharedData
LEVELTYPE = LeaderLib.LEVELTYPE
if Ext.IsClient() then
	---@type ClientData
	Client = LeaderLib.Client
end