--- @param character StatCharacter
--- @param skill StatEntrySkillData
--- @param mainWeapon table
--- @param offHandWeapon table
--- @return number[]
function GetSkillDamageRangeWithFakeWeapon(character, skill, mainWeapon, offHandWeapon, ability)
    local damageMultiplier = skill['Damage Multiplier'] * 0.01

    if skill.UseWeaponDamage == "Yes" then
        local mainDamageRange = Skills.CalculateWeaponAbilityDamageRange(character, mainWeapon, ability)
        if offHandWeapon ~= nil and Game.Math.IsRangedWeapon(mainWeapon) == Game.Math.IsRangedWeapon(offHandWeapon) then
            local offHandDamageRange = Skills.CalculateWeaponAbilityDamageRange(character, offHandWeapon)

            local dualWieldPenalty = Ext.ExtraData.DualWieldingDamagePenalty
            for damageType, range in pairs(offHandDamageRange) do
                local min = range[1] * dualWieldPenalty
                local max = range[2] * dualWieldPenalty
                if mainDamageRange[damageType] ~= nil then
                    mainDamageRange[damageType][1] = mainDamageRange[damageType][1] + min
                    mainDamageRange[damageType][2] = mainDamageRange[damageType][2] + max
                else
                    mainDamageRange[damageType] = {min, max}
                end
            end
        end

        for damageType, range in pairs(mainDamageRange) do
            local min = Ext.Round(range[1] * damageMultiplier)
            local max = Ext.Round(range[2] * damageMultiplier)
            range[1] = min + math.ceil(min * Game.Math.GetDamageBoostByType(character, damageType))
            range[2] = max + math.ceil(max * Game.Math.GetDamageBoostByType(character, damageType))
        end

        local damageType = skill.DamageType
        if damageType ~= "None" and damageType ~= "Sentinel" then
            local min, max = 0, 0
            for _, range in pairs(mainDamageRange) do
                min = min + range[1]
                max = max + range[2]
            end
    
            mainDamageRange = {}
            mainDamageRange[damageType] = {min, max}
        end

        return mainDamageRange
    else
        local damageType = skill.DamageType
        if damageMultiplier <= 0 then
            return {}
        end

        local level = character.Level
        if (level < 0 or skill.OverrideSkillLevel == "Yes") and skill.Level > 0 then
            level = skill.Level
        end

        local skillDamageType = skill.Damage
        local attrDamageScale
        if skillDamageType == "BaseLevelDamage" or skillDamageType == "AverageLevelDamge" then
            attrDamageScale = Skills.GetSkillAbilityDamageScale(skill, character, ability)
        else
            attrDamageScale = 1.0
        end

        local baseDamage = Game.Math.CalculateBaseDamage(skill.Damage, character, 0, level) * attrDamageScale * damageMultiplier
        local damageRange = skill['Damage Range'] * baseDamage * 0.005

        local damageType = skill.DamageType
        local damageTypeBoost = 1.0 + Game.Math.GetDamageBoostByType(character, damageType)
        local damageBoost = 1.0 + (character.DamageBoost / 100.0)
        local damageRanges = {}
        damageRanges[damageType] = {
            math.ceil(math.ceil(Ext.Round(baseDamage - damageRange) * damageBoost) * damageTypeBoost),
            math.ceil(math.ceil(Ext.Round(baseDamage + damageRange) * damageBoost) * damageTypeBoost)
        }
        return damageRanges
    end
end

local attributes = {
	"Strength",
	"Finesse",
	"Intelligence",
	"Constitution",
	"Memory",
	"Wits",
}

---@param character StatCharacter
---@param validAttributes string[]
local function GetHighestAttribute(character, validAttributes)
	if validAttributes == nil then validAttributes = attributes end
	local attribute = "Strength"
	local last = 0
	for i,att in pairs(validAttributes) do
		local val = character[att]
		if val ~= nil and val > last then
			attribute = att
			last = val
		end
	end
	--Ext.Print("Scaling damage by ("..attribute..")")
	return attribute
end

local skillAttributes = {
	"Ability",
	--"ActionPoints",
	--"Cooldown",
	"Damage Multiplier",
	"Damage Range",
	"Damage",
	"DamageType",
	"DeathType",
	"Distance Damage Multiplier",
	--"IsEnemySkill",
	--"IsMelee",
	"Level",
	--"Magic Cost",
	--"Memory Cost",
	--"OverrideMinAP",
	"OverrideSkillLevel",
	--"Range",
	--"SkillType",
	"Stealth Damage Multiplier",
	--"Tier",
	"UseCharacterStats",
	"UseWeaponDamage",
	"UseWeaponProperties",
}

---@param skillName string
---@return StatEntrySkillData
local function PrepareSkillProperties(skillName, useWeaponDamage)
	if skillName ~= nil and skillName ~= "" then
		local skill = {Name = skillName}
		for i,v in pairs(skillAttributes) do
			skill[v] = Ext.StatGetAttribute(skillName, v)
		end
		if useWeaponDamage == true then skill["UseWeaponDamage"] = "Yes" end
		--Ext.Print(Ext.JsonStringify(skill))
		return skill
	end
	return nil
end

local weaponAttributes = {
	"ModifierType",
	"IsTwoHanded",
	"WeaponType",
}

local weaponStatAttributes = {
	"ModifierType",
	"Damage",
	"DamageFromBase",
	"Damage Range",
	"Damage Type",
	"DamageBoost",
	"CriticalDamage",
	"CriticalChance",
	"IsTwoHanded",
	"WeaponType",
}

---@param stat string
---@param level integer
---@param attribute string
---@param weaponType string
---@return StatItem
local function PrepareWeaponStat(stat,level,attribute,weaponType)
	local weapon = {}
	for i,v in pairs(weaponAttributes) do
		weapon[v] = Ext.StatGetAttribute(stat, v)
	end
	weapon.ItemType = "Weapon"
	weapon.WeaponType = weaponType
	weapon.Name = stat
	weapon.Requirements = {
		{
			Requirement = attribute,
			Param = 0,
			Not = false
		}
	}
	local weaponStat = {}
	for i,v in pairs(weaponStatAttributes) do
		weaponStat[v] = Ext.StatGetAttribute(stat, v)
	end
	local damage = Game.Math.GetLevelScaledWeaponDamage(level)
	local baseDamage = damage * (weaponStat.DamageFromBase * 0.01)
	local range = baseDamage * (weaponStat["Damage Range"] * 0.01)
	--Ext.Print("damage:",damage,"baseDamage:",baseDamage,"range:",range)
	weaponStat.MinDamage = Ext.Round(baseDamage - (range/2))
	weaponStat.MaxDamage = Ext.Round(baseDamage + (range/2))
	weaponStat.DamageType = weaponStat["Damage Type"]
	weaponStat.StatsType = "Weapon"
	weaponStat.WeaponType = weaponType
	weaponStat.Requirements = weapon.Requirements
	weapon.DynamicStats = {weaponStat}
	return weapon
end

-- from CDivinityStats_Character::CalculateWeaponDamageInner and CDivinityStats_Item::ComputeScaledDamage
--- @param character StatCharacter
--- @param weapon StatItem
--- @param damageList DamageList
--- @param noRandomization boolean
local function CalculateWeaponScaledDamage(character, weapon, damageList, noRandomization, attribute)
    local damages, damageBoost = Game.Math.ComputeBaseWeaponDamage(weapon)

    local abilityBoosts = character.DamageBoost 
        + Game.Math.ComputeWeaponCombatAbilityBoost(character, weapon)
        + (Game.Math.ScaledDamageFromPrimaryAttribute(character[attribute]) * 100.0)
    abilityBoosts = math.max(abilityBoosts + 100.0, 0.0) / 100.0

    local boost = 1.0 + damageBoost * 0.01
    if not character.Sneaking then
        boost = boost + Ext.ExtraData['Sneak Damage Multiplier']
    end

    for damageType, damage in pairs(damages) do
        local min = math.ceil(damage.Min * boost * abilityBoosts)
        local max = math.ceil(damage.Max * boost * abilityBoosts)

        local randRange = 1
        if max - min >= 1 then
            randRange = max - min
        end

        local finalAmount
        if noRandomization then
            finalAmount = min + math.floor(randRange / 2)
        else
            finalAmount = min + Ext.Random(0, randRange)
        end

        damageList:Add(damageType, finalAmount)
    end
end

--- @param attacker StatCharacter
--- @param weapon StatItem
--- @param noRandomization boolean
--- @param highestAttribute string
--- @return DamageList
local function CalculateWeaponDamage(attacker, weapon, noRandomization, highestAttribute)
    local damageList = Ext.NewDamageList()
    CalculateWeaponScaledDamage(attacker, weapon, damageList, noRandomization, highestAttribute)
    Game.Math.ApplyDamageBoosts(attacker, damageList)
    return damageList
end

--- @param character StatCharacter
--- @param weapon StatItem
--- @param highestAttribute string
--- @return number[]
local function CalculateWeaponDamageRange(character, weapon, highestAttribute)
    local damages, damageBoost = Game.Math.ComputeBaseWeaponDamage(weapon)

    local abilityBoosts = character.DamageBoost 
        + Game.Math.ComputeWeaponCombatAbilityBoost(character, weapon)
        + (Game.Math.ScaledDamageFromPrimaryAttribute(character[highestAttribute]) * 100.0)
    abilityBoosts = math.max(abilityBoosts + 100.0, 0.0) / 100.0

    local boost = 1.0 + damageBoost * 0.01
    if not character.Sneaking then
        boost = boost + Ext.ExtraData['Sneak Damage Multiplier']
    end

    local ranges = {}
    for damageType, damage in pairs(damages) do
        local min = math.ceil(damage.Min * boost * abilityBoosts)
        local max = math.ceil(damage.Max * boost * abilityBoosts)

        if min > max then
            max = min
        end

        ranges[damageType] = {min, max}
    end

    return ranges
end

---Recursively see if a stat has a parent stat.
---@param stat string
---@param statToFind string
---@return boolean
local function HasParent(stat, statToFind)
	if stat == statToFind then
		return true
	end
	local parent = Ext.StatGetAttribute(stat, "Using")
	if parent == nil or parent == "" then
		return false
	elseif parent == statToFind then
		return true
	else
		return HasParent(parent, statToFind)
	end
end

---@param character EsvCharacter
---@param parentStatName string
---@param slots string[]
---@return StatItem
local function GetItem(character, parentStatName, slots)
	---@type StatItem
	local item = nil
	if type(slots) == "string" then
		item = character:GetItemBySlot(slots)
		if item ~= nil and HasParent(item.Name, parentStatName) then
			return item
		end
	else
		for i,slot in pairs(slots) do
			item = character:GetItemBySlot(slot)
			if item ~= nil and HasParent(item.Name, parentStatName) then
				return item
			end
		end
	end
	return nil
end

---@param character EsvCharacter
---@param runeParentStat string
---@param itemParentStat string
---@param slots string[]
---@return StatItemDynamic,string
local function GetRuneBoost(character, runeParentStat, itemParentStat, slots)
	local item = GetItem(character, itemParentStat, slots)
	if item ~= nil then
		for i=3,5,1 do
			local boost = item.DynamicStats[i]
			if boost ~= nil and boost.BoostName ~= "" then
				if HasParent(boost.BoostName, runeParentStat) then
					local boostStat = Ext.StatGetAttribute(boost.BoostName, "RuneEffectWeapon")
					if boostStat ~= nil then
						return boost,boostStat
					end
				end
			end
		end
	end
	return nil
end

--- @param baseSkill StatEntrySkillData
--- @param attacker StatCharacter
--- @param isFromItem boolean
--- @param stealthed boolean
--- @param attackerPos number[]
--- @param targetPos number[]
--- @param level integer
--- @param noRandomization boolean
local function GetHandCrossbowDamage(baseSkill, attacker, isFromItem, stealthed, attackerPos, targetPos, level, noRandomization, isTooltip)
    if attacker ~= nil and level < 0 then
        level = attacker.Level
	end
    if level == 0 then
        level = baseSkill.OverrideSkillLevel
        if level == 0 then
            level = baseSkill.Level
        end
	end
	
	local highestAttribute = GetHighestAttribute(attacker)

	local weapon = nil
	local skill = PrepareSkillProperties(baseSkill.Name, true)
	if skill == nil then skill = baseSkill end

	local rune,weaponBoostStat = GetRuneBoost(attacker, "_LLWEAPONEX_HandCrossbow_Bolts", "_LLWEAPONEX_HandCrossbows", {"Ring", "Ring2"})
	if weaponBoostStat == nil then weaponBoostStat = "_Boost_LLWEAPONEX_HandCrossbow_Bolts_Normal" end
	if weaponBoostStat ~= nil then
		weapon = PrepareWeaponStat(weaponBoostStat, attacker.Level, highestAttribute, "Crossbow")
		--Ext.Print("Applied Hand Crossbow Bolt Stats ("..weaponBoostStat..")")
		--Ext.Print(LeaderLib.Common.Dump(weapon))
		skill["DamageType"] = weapon.DynamicStats[1]["Damage Type"]
		--skill["Damage Multiplier"] = weapon.DynamicStats[1]["DamageFromBase"]
		--skill["Damage Range"] = weapon.DynamicStats[1]["Damage Range"]
	end

    local damageMultiplier = skill['Damage Multiplier'] * 0.01
    local damageMultipliers = Game.Math.GetDamageMultipliers(skill, stealthed, attackerPos, targetPos)
	local skillDamageType = skill["DamageType"]

	if isTooltip ~= true then
		local damageList = Ext.NewDamageList()
		local mainDmgs = Math.AbilityScaling.CalculateWeaponDamage(attacker, weapon, noRandomization, "RogueLore")
		mainDmgs:Multiply(damageMultipliers)
		if skillDamageType ~= nil then
			mainDmgs:ConvertDamageType(skillDamageType)
		end
		damageList:Merge(mainDmgs)
		damageList:AggregateSameTypeDamages()
		--Ext.Print("damageList:",Ext.JsonStringify(damageList:ToTable()))
		return damageList,Game.Math.DamageTypeToDeathType(skillDamageType)
	else
		local mainDamageRange = Math.AbilityScaling.GetSkillDamageRange(attacker, skill, weapon, "RogueLore")
		--Ext.Print("mainDamageRange final:",Ext.JsonStringify(mainDamageRange))
        return mainDamageRange
	end
end

--- @param baseSkill StatEntrySkillData
--- @param attacker StatCharacter
--- @param isFromItem boolean
--- @param stealthed boolean
--- @param attackerPos number[]
--- @param targetPos number[]
--- @param level integer
--- @param noRandomization boolean
local function GetPistolDamage(baseSkill, attacker, isFromItem, stealthed, attackerPos, targetPos, level, noRandomization, isTooltip)
    if attacker ~= nil and level < 0 then
        level = attacker.Level
	end
    if level == 0 then
        level = baseSkill.OverrideSkillLevel
        if level == 0 then
            level = baseSkill.Level
        end
	end

	local highestAttribute = GetHighestAttribute(attacker)

	local weapon = nil
	local skill = PrepareSkillProperties("Projectile_LLWEAPONEX_Pistol_Shoot_Base", true)

	if skill == nil then
		Ext.PrintError("Failed to prepare skill data for Projectile_LLWEAPONEX_Pistol_Shoot_Base?")
		skill = baseSkill
		skill["UseWeaponDamage"] = "Yes"
	end

	local rune,weaponBoostStat = GetRuneBoost(attacker, "_LLWEAPONEX_Pistol_Bullets", "_LLWEAPONEX_Pistols", "Belt")
	if weaponBoostStat == nil then weaponBoostStat = "_Boost_LLWEAPONEX_Pistol_Bullets_Normal" end
	if weaponBoostStat ~= nil then
		weapon = PrepareWeaponStat(weaponBoostStat, attacker.Level, highestAttribute, "Rifle")
		--Ext.Print("Bullet Stats ("..weaponBoostStat..")")
		--Ext.Print(LeaderLib.Common.Dump(weapon))
		skill["DamageType"] = weapon.DynamicStats[1]["Damage Type"]
		--skill["Damage Multiplier"] = weapon.DynamicStats[1]["DamageFromBase"]
		--skill["Damage Range"] = weapon.DynamicStats[1]["Damage Range"]
	end

    local damageMultiplier = skill["Damage Multiplier"] * 0.01
    local damageMultipliers = Game.Math.GetDamageMultipliers(skill, stealthed, attackerPos, targetPos)
	local skillDamageType = skill["DamageType"]

	-- Ext.Print("Skill Stats:")
	-- Ext.Print("================================")
	-- Ext.Print(LeaderLib.Common.Dump(skill))
	-- Ext.Print("================================")
	-- Ext.Print("Fake Weapon Stats:")
	-- Ext.Print("================================")
	-- Ext.Print(LeaderLib.Common.Dump(weapon))
	-- Ext.Print("================================")
	-- Ext.Print("Real Weapon Stats:")
	-- Ext.Print("================================")
	-- for k,v in pairs(weapon) do
	-- 	Ext.Print(k..":"..tostring(attacker.MainWeapon[k]))
	-- end
	-- PrintDynamicStats(attacker.MainWeapon.DynamicStats)
	-- Ext.Print("================================")

	if isTooltip ~= true then
		local damageList = Ext.NewDamageList()
		local mainDmgs = Math.AbilityScaling.CalculateWeaponDamage(attacker, weapon, nil, noRandomization, "RogueLore")
		mainDmgs:Multiply(damageMultipliers)
		if skillDamageType ~= nil then
			mainDmgs:ConvertDamageType(skillDamageType)
		end
		damageList:Merge(mainDmgs)
		damageList:AggregateSameTypeDamages()
		--Ext.Print("damageList:",Ext.JsonStringify(damageList:ToTable()))
		return damageList,Game.Math.DamageTypeToDeathType(skillDamageType)
	else
		local mainDamageRange = Math.AbilityScaling.GetSkillDamageRange(attacker, skill, weapon, nil, "RogueLore")
		--Ext.Print("mainDamageRange final:",Ext.JsonStringify(mainDamageRange))
        return mainDamageRange
	end
end

Skills = {
	GetHighestAttribute = GetHighestAttribute,
	GetItem = GetItem,
	GetRuneBoost = GetRuneBoost,
	PrepareSkillProperties = PrepareSkillProperties,
	PrepareWeaponStat = PrepareWeaponStat,
	Params = {},
	Damage = {
		Params = {
			LLWEAPONEX_PistolDamage = GetPistolDamage,
			LLWEAPONEX_HandCrossbow_ShootDamage = GetHandCrossbowDamage
		},
		Skills = {
			Projectile_LLWEAPONEX_Pistol_Shoot_Base = GetPistolDamage,
			Projectile_LLWEAPONEX_Pistol_Shoot_LeftHand = GetPistolDamage,
			Projectile_LLWEAPONEX_Pistol_Shoot_RightHand = GetPistolDamage,
			Projectile_LLWEAPONEX_HandCrossbow_Shoot = GetHandCrossbowDamage,
		}
	}
}
