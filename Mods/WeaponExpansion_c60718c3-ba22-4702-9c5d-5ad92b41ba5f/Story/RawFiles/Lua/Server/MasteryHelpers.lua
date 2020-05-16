

local function HasMinimumMasteryLevel(uuid,mastery,minLevel)
	--DB_LLWEAPONEX_WeaponMastery_PlayerData_Experience(_Player, _WeaponType, _Level, _Experience)
	local dbEntry = Osi.DB_LLWEAPONEX_WeaponMastery_PlayerData_Experience:Get(uuid, mastery, nil, nil)
	if dbEntry ~= nil then
		local masteryLevel = dbEntry[1][3]
		if masteryLevel ~= nil and masteryLevel >= minLevel then
			return masteryLevel
		end
	end
end

Ext.NewQuery(HasMinimumMasteryLevel, "LLWEAPONEX_Ext_QRY_HasMinimumMasteryLevel", "[in](CHARACTERGUID)_Character, [in](STRING)_Mastery, [in](INTEGER)_MinLevel, [out](INTEGER)_Level")

function TagMasteryRanks(uuid,mastery,level)
	if level > 0 then
		for i=1,level,1 do
			local tag = mastery.."_Mastery"..tostring(i)
			SetTag(uuid, tag)
			--LeaderLib.PrintDebug("[WeaponExpansion:TagMasteryRanks] Setting tag ["..tag.."] on ["..uuid.."]")
		end
	end
end

--- Callback for when a character's mastery levels up.
--- @param uuid string
--- @param mastery string
--- @param last integer
--- @param next integer
local function MasteryLeveledUp(uuid,mastery,last,next)
	local masteryData = Masteries[mastery]
	local masteryName = string.format("<font color='%s'>%s %s</font>", masteryData.Color, masteryData.Name.Value, Text.Mastery.Value)
	local text = string.gsub(Text.MasteryLeveledUp.Value, "%[1%]", masteryName):gsub("%[2%]", next)
	if CharacterIsPlayer(uuid) == 1 and CharacterIsControlled(uuid) then
		ShowNotification(uuid, text)
	else
		CharacterStatusText(uuid, text)
	end
	TagMasteryRanks(uuid,mastery,next)

	LeaderLib.PrintDebug("[WeaponExpansion] Mastery ["..mastery.."] leveled up ("..tostring(last).." => "..tostring(last)..") on ["..uuid.."]")
end

--- Adds mastery experience a specific masteries.
--- @param uuid string
--- @param mastery string
--- @param expGain number
--- @param skipFlagCheck boolean
function AddMasteryExperience(uuid,mastery,expGain)
	if skipFlagCheck == true or ObjectGetFlag(uuid, "LLWEAPONEX_DisableWeaponMasteryExperience") == 0 then
		local currentLevel = 0
		local currentExp = 0
		--DB_LLWEAPONEX_WeaponMastery_PlayerData_Experience(_Player, _WeaponType, _Level, _Experience)
		local dbEntry = Osi.DB_LLWEAPONEX_WeaponMastery_PlayerData_Experience:Get(uuid, mastery, nil, nil)
		if dbEntry ~= nil then
			local playerEntry = dbEntry[1]
			if playerEntry ~= nil then
				currentLevel = playerEntry[3]
				currentExp = playerEntry[4]

				if currentExp == nil then currentExp = 0 end
			end
		end

		if currentLevel < 4 then
			local expAmountData = Mastery.Variables.RankVariables[currentLevel]
			local maxAddExp = expAmountData.Amount
			local nextLevelExp = Mastery.Variables.RankVariables[currentLevel+1].Required
			local nextLevel = currentLevel

			local nextExp = currentExp + (maxAddExp * expGain)
			if nextExp >= nextLevelExp then
				nextLevel = currentLevel + 1
				if nextLevel >= Mastery.Variables.MaxRank then
					nextExp = nextLevelExp
				end
			end

			if Ext.IsDeveloperMode() then
				if currentExp == nil then currentExp = 0 end
				if nextExp == nil then nextExp = 0 end
				PrintDebug("Mastery XP:",uuid, mastery, currentExp, "=>", nextExp)
			end

			Osi.LLWEAPONEX_WeaponMastery_Internal_StoreExperience(uuid, mastery, nextLevel, nextExp)

			if nextLevel > currentLevel then
				MasteryLeveledUp(uuid, mastery, currentLevel, nextLevel)
			end
		end
	end
end

Ext.NewCall(AddMasteryExperience, "LLWEAPONEX_Ext_AddMasteryExperience", "(CHARACTERGUID)_Character, (STRING)_Mastery, (REAL)_ExperienceGain")

local function ItemIsTagged(item, tag)
	if item == nil then
		return false
	end
	return IsTagged(item, tag) == 1
end

--- Adds mastery experience for all active masteries on equipped weapons.
--- @param uuid string
--- @param expGain number
function AddMasteryExperienceForAllActive(uuid,expGain)
	if ObjectGetFlag(uuid, "LLWEAPONEX_DisableWeaponMasteryExperience") == 0 then
		--local mainhand = CharacterGetEquippedItem(uuid, "Weapon")
		--local offhand = CharacterGetEquippedItem(uuid, "Shield")
		for mastery,masterData in pairs(Masteries) do
			-- if ItemIsTagged(mainhand) or ItemIsTagged(offhand) then
			-- 	AddMasteryExperience(uuid,mastery,expGain)
			-- end
			if IsTagged(uuid,mastery) == 1 then
				AddMasteryExperience(uuid,mastery,expGain,true)
			end
		end
	end
end

Ext.NewCall(AddMasteryExperienceForAllActive, "LLWEAPONEX_Ext_AddMasteryExperienceForAllActive", "(CHARACTERGUID)_Character, (REAL)_ExperienceGain")

local function HasRequirement(val)
	return val ~= nil and val ~= "None" and val ~= ""
end

function IsWeaponSkill(skill)
	return Ext.StatGetAttribute(skill, "UseWeaponDamage") == "Yes" or 
		Ext.StatGetAttribute(skill, "UseWeaponProperties") == "Yes" or 
			HasRequirement(Ext.StatGetAttribute(skill, "Requirement"))
end

--- @param character string
--- @param skill string
function OnSkillCast(character,skill)
	if IsPlayer(character) and IsWeaponSkill(skill) then
		AddMasteryExperienceForAllActive(character, 0.5)
	end
end

--- @param uuid string
--- @param mastery string
function OnMasteryDeactivated(uuid,mastery)
	ClearTag(uuid,mastery)
	LeaderLib.PrintDebug("[WeaponExpansion] Cleared mastery tag ["..mastery.."] on ["..uuid.."].")
end

--- @param uuid string
--- @param mastery string
--- @param minLevel integer
function HasMasteryLevel(uuid,mastery,minLevel)
	local dbEntry = Osi.DB_LLWEAPONEX_WeaponMastery_PlayerData_Experience:Get(uuid, mastery, nil, nil)
	if dbEntry ~= nil then
		local playerEntry = dbEntry[1]
		if playerEntry ~= nil then
			local currentLevel = playerEntry[3]
			--currentExp = playerEntry[4]
			return currentLevel >= minLevel
		end
	end
	return false
end

function HasMasteryRequirement_QRY(call, uuid, tag)
	return Mastery.HasMasteryRequirement(Ext.GetCharacter(uuid), tag)
end