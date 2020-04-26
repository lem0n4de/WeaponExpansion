Ext.Require("WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f", "Server/LLWEAPONEX__Main.lua")
Ext.Require("WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f", "Server/LLWEAPONEX_TimerListener.lua")
Ext.Require("WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f", "Server/LLWEAPONEX_GameMechanics.lua")
Ext.Require("WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f", "Server/LLWEAPONEX_PistolMechanics.lua")
Ext.Require("WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f", "Server/LLWEAPONEX_SkillDamage.lua")
Ext.Require("WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f", "Server/Skills/MasteryBonuses.lua")
Ext.Require("WeaponExpansion_c60718c3-ba22-4702-9c5d-5ad92b41ba5f", "Server/LLWEAPONEX_Debug.lua")

--Export local functions to global for now
-- for name,func in pairs(WeaponExpansion.Export) do
--     local func_name = "LLWEAPONEX_Ext_" .. name
--     _G[func_name] = func
--     Ext.Print("[WeaponExpansion:Bootstrap.lua] Registered function ("..func_name..").")
-- end

local boltTemplates = {
    "baf9826a-abe8-4bc8-8c56-b68b5611c223",
    "72a7d3aa-02d7-4c9b-a565-d94c8a5664b0",
    "598b8cb5-7f76-4c50-a609-2a3cd0aa0415",
}

local bulletTemplates = {
    "6c14edba-cc11-4e9f-be04-685f09c0aadd",
    "58638ac8-d0d2-4a60-a6a6-76e0be07d58a",
    "056a48f4-2b5f-4882-aefa-05162ad4c427",
    "009eecab-d9bc-454d-afca-5c512f10b182",
    "2e6c0fd4-3d9e-4492-aa21-6047eca15b1a",
    "0377162e-51fa-499a-ab58-4cad5104d888",
    "fc05e69b-bb8b-4d0d-a94c-e1ecafa1c9a9",
    "fc05e69b-bb8b-4d0d-a94c-e1ecafa1c9a9",
    "071b6f55-64a5-4efe-af02-1910d400e6b5",
}

local function DebugInit()
    --Ext.BroadcastMessage("LLWEAPONEX_OnClientMessage", "HookUI", nil)
    local host = CharacterGetHostCharacter()
    if ItemTemplateIsInPartyInventory(host, "ad15f666-285d-4634-a832-ea643fa0a9d2", 0) <= 0 then
        ItemTemplateAddTo("ad15f666-285d-4634-a832-ea643fa0a9d2", host, 1, 0)
        for i,template in pairs(boltTemplates) do
            ItemTemplateAddTo(template, host, 1, 0)
        end
    end
    for i,template in pairs(bulletTemplates) do
        if ItemTemplateIsInPartyInventory(host, template, 0) <= 0 then
            ItemTemplateAddTo(template, host, 1, 0)
        end
    end
    if ItemTemplateIsInPartyInventory(host, "94838d55-d5e6-4115-b736-b8b26f321003", 0) <= 0 then
        ItemTemplateAddTo("94838d55-d5e6-4115-b736-b8b26f321003", host, 1, 0)
    end
    if ItemTemplateIsInPartyInventory(host, "LOOT_LeaderLib_Ring_Shapeshifter_1892531e-4eeb-42ff-907e-4a7ce2278b3d", 0) <= 0 then
        ItemTemplateAddTo("LOOT_LeaderLib_Ring_Shapeshifter_1892531e-4eeb-42ff-907e-4a7ce2278b3d", host, 1, 0)
    end
    --CharacterAddSkill(host, "Projectile_LLWEAPONEX_HandCrossbow_Shoot", 0)
   -- CharacterAddSkill(host, "Projectile_EnemyFireball", 0)
    CharacterAddSkill(host, "Projectile_ThrowingKnife", 0)
    NRD_SkillBarSetSkill(host, 2, "Target_LLWEAPONEX_Pistol_Shoot")
    Osi.LLWEAPONEX_WeaponMastery_Debug_CheatMastery(host, 0)
end

local function SessionLoading()
    if Ext.IsModLoaded("046aafd8-ba66-4b37-adfb-519c1a5d04d7") then
        EnemyUpgradeOverhaul.IgnoredSkills["Projectile_LLWEAPONEX_HandCrossbow_Shoot_Enemy"] = true
        EnemyUpgradeOverhaul.IgnoredSkills["Target_LLWEAPONEX_Pistol_Shoot_Enemy"] = true
    end
    Ext.Print("[WeaponExpansion:BootstrapServer.lua] Session is loading.")
    Mods.LeaderLib.AddDebugInitCall(DebugInit)
end
Ext.RegisterListener("SessionLoading", SessionLoading)

Ext.Print("[WeaponExpansion:BootstrapServer.lua] Finished running.")