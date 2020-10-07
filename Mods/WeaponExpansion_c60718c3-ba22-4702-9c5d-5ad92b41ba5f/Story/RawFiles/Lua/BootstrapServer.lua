RegisterProtectedOsirisListener = Mods.LeaderLib.RegisterProtectedOsirisListener
StartOneshotTimer = Mods.LeaderLib.StartOneshotTimer

---@class WeaponExpansionVars
PersistentVars = {
    SkillData = {
        DarkFireballCount = {},
        RunicCannonCharges = {},
        GnakSpells = {}
    },
    MasteryMechanics = {},
    Timers = {},
    OnDeath = {}
}
LoadPersistentVars = {}
BonusSkills = {}
Listeners = {
    Status = {},
    StatusAttempt = {},
}

Ext.Require("Shared/_InitShared.lua")
Ext.Require("Server/ServerMain.lua")
Ext.Require("Server/HitHandler.lua")
Ext.Require("Server/StatusHandler.lua")
Ext.Require("Server/BasicAttackListeners.lua")
Ext.Require("Server/TimerListeners.lua")
Ext.Require("Server/EquipmentEvents.lua")
Ext.Require("Server/UnarmedDamageScaling.lua")
Ext.Require("Server/OsirisListeners.lua")
Ext.Require("Server/DeathMechanics.lua")
Ext.Require("Server/UI/MasteryMenuCommands.lua")
Ext.Require("Server/UI/UIHelpers.lua")
Ext.Require("Server/Skills/DamageHandler.lua")
Ext.Require("Server/Skills/ElementalFirearms.lua")
Ext.Require("Server/Skills/PrepareEffects.lua")
Ext.Require("Server/Skills/SkillHelpers.lua")
Ext.Require("Server/Skills/SkillListeners.lua")
Ext.Require("Server/Skills/GnakSpellScroll.lua")
Ext.Require("Server/MasteryExperience.lua")
Ext.Require("Server/MasteryHelpers.lua")
Ext.Require("Server/PistolMechanics.lua")
Ext.Require("Server/Mastery/SkillBonuses.lua")
Ext.Require("Server/Mastery/HitBonuses.lua")
Ext.Require("Server/Mastery/StatusBonuses.lua")
Ext.Require("Server/TagHelpers.lua")
Ext.Require("Server/Origins/OriginsMain.lua")
Ext.Require("Server/Items/ItemHandler.lua")
Ext.Require("Server/Items/UniqueItems.lua")
Ext.Require("Server/Items/CraftingMechanics.lua")
Ext.Require("Server/Items/DeltaModSwapper.lua")
Ext.Require("Server/Items/LootBonuses.lua")
Ext.Require("Server/Items/TreasureTableMerging.lua")
local itemBonusSkills = Ext.Require("Server/Items/ItemBonusSkills.lua")
local debugInit = Ext.Require("Server/Debug/DebugMain.lua")
Ext.Require("Server/Debug/ConsoleCommands.lua")
Ext.Require("Server/Updates.lua")

local function dumpRanks(...)
    --DB_LLWEAPONEX_WeaponMastery_RankNames("LLWEAPONEX_DualShields", 0, "<font color='#FDFFEA'>Beginner</font>")
    local rankNamesDB = Osi.DB_LLWEAPONEX_WeaponMastery_RankNames:Get(nil, nil, nil)
    local output = ""
    for i,entry in pairs(rankNamesDB) do
        --AddRank(masteryID, level, color, name)
        local masteryID = entry[1]
        local level = entry[2]
        local text = entry[3]
        local _,_,color = string.find(text, "color='(.+)'")
        local _,_,rankName = string.find(text, ">(.+)<")
        output = output .. string.format("AddRank(\"%s\", %s, \"%s\", \"%s\")\n", masteryID, level, color, rankName)
    end
    print(output)
end
Ext.RegisterConsoleCommand("dumpRanks", dumpRanks);

local DIVINITY_UNLEASHED = "e844229e-b744-4294-9102-a7362a926f71"
local ARMOR_MITIGATION = "edf1898c-d375-47e7-919a-11d5d44d1cca"

---@param target EsvCharacter
---@param attacker StatCharacter|StatItem
---@param hit HitRequest
---@param causeType string
---@param impactDirection number[]
---@param context any
local function BeforeCharacterApplyDamage(target, attacker, hit, causeType, impactDirection, context)
	if hit.DamageType == "Magic" then
        hit.DamageList:ConvertDamageType("Water")
    elseif hit.DamageType == "Corrosive" then
        hit.DamageList:ConvertDamageType("Earth")
    end
end

local function SessionSetup()
    -- Divinity Unleashed or Armor Mitigation
    if not Ext.IsModLoaded(DIVINITY_UNLEASHED) and not Ext.IsModLoaded(ARMOR_MITIGATION) then
        Ext.Print("[WeaponExpansion:BootstrapServer.lua] Enabled Magic/Corrosive damage type conversions.")
        Ext.RegisterListener("BeforeCharacterApplyDamage", BeforeCharacterApplyDamage)
    end

    -- Enemy Upgrade Overhaul
    if Ext.IsModLoaded("046aafd8-ba66-4b37-adfb-519c1a5d04d7") then
        Mods["EnemyUpgradeOverhaul"].IgnoredSkills["Projectile_LLWEAPONEX_HandCrossbow_Shoot_Enemy"] = true
        Mods["EnemyUpgradeOverhaul"].IgnoredSkills["Target_LLWEAPONEX_Pistol_Shoot_Enemy"] = true
    end
    Ext.Print("[WeaponExpansion:BootstrapServer.lua] Session is loading.")
    if Ext.IsDeveloperMode() then
        Mods.LeaderLib.AddDebugInitCall(debugInit)
    end
    
    for i,callback in pairs(LoadPersistentVars) do
        local status,err = xpcall(callback, debug.traceback)
        if not status then
            Ext.PrintError("[WeaponExpansion:SessionLoaded] Error invoking LoadPersistentVars callback:",err)
        end
    end

    itemBonusSkills.Init()
end
Ext.RegisterListener("SessionLoaded", SessionSetup)

Ext.Print("[WeaponExpansion:BootstrapServer.lua] Finished running.")

Ext.AddPathOverride("Mods/Kalavinkas_Combat_Enhanced_e844229e-b744-4294-9102-a7362a926f71/Story/RawFiles/Goals/KCE_CoreRules_Story.txt", "Mods/WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f/Overrides/KCE_CoreRules_Story.txt")