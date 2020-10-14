Equipment = {}

local function OnWeaponTypeEquipped(uuid, item, weapontype, stat, statType)
	if weapontype == "Rapier" or weapontype == "Katana" then
		local twohanded = Ext.StatGetAttribute(stat, "IsTwoHanded") == "Yes"
		if (twohanded and weapontype == "Katana") or (not twohanded and weapontype == "Rapier") then
			Osi.LLWEAPONEX_AnimationSetOverride_Set(uuid, "LLWEAPONEX_Override1", weapontype)
		end
	end
end

local rangedWeaponTypes = {
	None = false,
	Sword = false,
	Club = false,
	Axe = false,
	Staff = false,
	Bow = true,
	Crossbow = true,
	Spear = false,
	Knife = false,
	Wand = true,
	Arrow = true,
	--Custom = false,
}

---@param uuid string
---@param item EsvItem
local function UpdatedUnarmedTagsFromWeapon(uuid, item)
	SetTag(uuid, "LLWEAPONEX_AnyWeaponEquipped")
	if rangedWeaponTypes[item.Stats.WeaponType] ~= true then
		ClearTag(uuid, "LLWEAPONEX_NoMeleeWeaponEquipped")
	else
		SetTag(uuid, "LLWEAPONEX_NoMeleeWeaponEquipped")
	end
	if IsPlayer(uuid) then
		if item.Stats.AnimType ~= "Unarmed" or not UnarmedHelpers.HasUnarmedWeaponStats(uuid) then
			Osi.LLWEAPONEX_WeaponMastery_Internal_CheckRemovedMasteries(uuid, "LLWEAPONEX_Unarmed")
		end
	end
end

local function AxeScoundrelEnabled(uuid, item)
	return Mastery.HasMasteryRequirement(uuid, "LLWEAPONEX_Axe_Mastery4")
	and (item.Stats.WeaponType == "Axe" or item:HasTag("LLWEAPONEX_Axe"))
end

---@param uuid string
---@param item StatItem
local function CheckScoundrelTags(uuid, itemUUID)
	if itemUUID ~= nil and ObjectExists(itemUUID) == 1 then
		local item = Ext.GetItem(itemUUID)
		if item.Stats.WeaponType == "Knife" 
		or item:HasTag("LLWEAPONEX_Katana") 
		or AxeScoundrelEnabled(uuid, item)
		then
			return true
		end
	end
	return false
end

---@param uuid string
function Equipment.CheckWeaponRequirementTags(uuid)
	local character = Ext.GetCharacter(uuid)
	local mainhand = CharacterGetEquippedItem(uuid, "Weapon")
	local offhand = CharacterGetEquippedItem(uuid, "Shield")
	local weapon = mainhand or offhand
	if StringHelpers.IsNullOrEmpty(weapon) and StringHelpers.IsNullOrEmpty(offhand) then
		Osi.LLWEAPONEX_Equipment_TrackUnarmed(uuid)
	end
	if weapon ~= nil and ObjectExists(weapon) == 1 then
		local item = Ext.GetItem(weapon)
		SetTag(uuid, "LLWEAPONEX_AnyWeaponEquipped")
		if rangedWeaponTypes[item.Stats.WeaponType] ~= true then
			ClearTag(uuid, "LLWEAPONEX_NoMeleeWeaponEquipped")
			if CheckScoundrelTags(uuid, mainhand) or CheckScoundrelTags(uuid, offhand) then
				if character:HasTag("LLWEAPONEX_CannotUseScoundrelSkills") then
					ClearTag(uuid, "LLWEAPONEX_CannotUseScoundrelSkills")
					printd("ClearTag LLWEAPONEX_CannotUseScoundrelSkills", uuid)
				end
			else
				if not character:HasTag("LLWEAPONEX_CannotUseScoundrelSkills") then
					SetTag(uuid, "LLWEAPONEX_CannotUseScoundrelSkills")
					printd("SetTag LLWEAPONEX_CannotUseScoundrelSkills", uuid)
				end
			end
		else
			SetTag(uuid, "LLWEAPONEX_NoMeleeWeaponEquipped")
		end
		LeaderLib.RefreshSkillBar(uuid)
	elseif Mastery.HasMasteryRequirement(character, "LLWEAPONEX_Unarmed_Mastery1") then
		ClearTag(uuid, "LLWEAPONEX_AnyWeaponEquipped")
		ClearTag(uuid, "LLWEAPONEX_NoMeleeWeaponEquipped")
		SetTag(uuid, "LLWEAPONEX_CannotUseScoundrelSkills")
		LeaderLib.RefreshSkillBar(uuid)
	else
		ClearTag(uuid, "LLWEAPONEX_AnyWeaponEquipped")
		SetTag(uuid, "LLWEAPONEX_NoMeleeWeaponEquipped")
		SetTag(uuid, "LLWEAPONEX_CannotUseScoundrelSkills")
		LeaderLib.RefreshSkillBar(uuid)
	end

	--[[ if IsPlayer(uuid) then
		local hasWarfareTag = character:HasTag("LLWEAPONEX_NoMeleeWeaponEquipped")
		local hasScoundrelTag = character:HasTag("LLWEAPONEX_CannotUseScoundrelSkills")
		for skill,b in pairs(Skills.WarfareMeleeSkills) do
			GameHelpers.UI.SetSkillEnabled(uuid, skill, not hasWarfareTag)
		end
		for skill,b in pairs(Skills.ScoundrelMeleeSkills) do
			GameHelpers.UI.SetSkillEnabled(uuid, skill, not hasScoundrelTag)
		end
	end ]]
end

local function CheckForUnarmed(uuid, isPlayer)
	local hasEmptyHands = HasEmptyHand(uuid, false)
	if not hasEmptyHands and CharacterHasSkill(uuid, "Target_LLWEAPONEX_SinglehandedAttack") == 1 then
		CharacterRemoveSkill(uuid, "Target_LLWEAPONEX_SinglehandedAttack")
	elseif hasEmptyHands and CharacterHasSkill(uuid, "Target_LLWEAPONEX_SinglehandedAttack") == 0 then
		CharacterAddSkill(uuid, "Target_LLWEAPONEX_SinglehandedAttack", isPlayer and 1 or 0)
	end
end

--- @param uuid string
--- @param item string
function OnItemEquipped(uuid,itemUUID)
	--local mainhand = CharacterGetEquippedItem(uuid, "Weapon")
	--local offhand = CharacterGetEquippedItem(uuid, "Shield")
	if not StringHelpers.IsNullOrEmpty(itemUUID) and ObjectExists(itemUUID) == 1 then
		local item = Ext.GetItem(itemUUID)
		if item == nil then
			Ext.PrintError("[WeaponExpansion:OnItemEquipped] Failed to get item from:", itemUUID)
			return false
		end

		local character = Ext.GetCharacter(uuid)

		local stat = item.StatsId
		local statType = item.Stats.ItemType

		-- LLWEAPONEX_Blunt was an old tag name that became LLWEAPONEX_Bludgeon
		if item:HasTag("LLWEAPONEX_Blunt") or (not item:HasTag("LLWEAPONEX_TaggedWeaponType") and (statType == "Weapon" or statType == "Shield")) then
			TagWeapon(itemUUID, statType, stat)
		end
		
		local isPlayer = character.IsPlayer or character.IsGameMaster

		CheckForUnarmed(uuid, isPlayer)
		
		if isPlayer and statType == "Weapon" then
			Equipment.CheckWeaponRequirementTags(uuid)
		end

		local template = GetTemplate(itemUUID)
		Osi.LLWEAPONEX_OnItemTemplateEquipped(uuid,itemUUID,template)

		if not item:HasTag("LLWEAPONEX_NoTracking") then
			for tag,data in pairs(Masteries) do
				--LeaderLib.PrintDebug("[WeaponExpansion] Checking item for tag ["..tag.."] on ["..uuid.."]")
				if item:HasTag(tag) then
					if isPlayer then
						local equippedTag = Tags.WeaponTypes[tag]
						if equippedTag ~= nil then
							if Ext.IsDeveloperMode() then
								if IsTagged(uuid, equippedTag) == 0 then
									LeaderLib.PrintDebug("[WeaponExpansion:OnItemEquipped] Setting equipped tag ["..equippedTag.."] on ["..uuid.."]")
								end
							end
							Osi.LLWEAPONEX_Equipment_TrackItem(uuid,itemUUID,tag,equippedTag,isPlayer and 1 or 0)
						end
						Osi.LLWEAPONEX_WeaponMastery_TrackMastery(uuid, itemUUID, tag)
						if IsTagged(uuid, tag) == 0 then
							SetTag(uuid, tag)
							LeaderLib.PrintDebug("[WeaponExpansion:OnItemEquipped] Setting mastery tag ["..tag.."] on ["..uuid.."]")
						end
					end
					Osi.LLWEAPONEX_Equipment_OnTaggedItemEquipped(uuid,itemUUID,tag,isPlayer and 1 or 0)
					OnWeaponTypeEquipped(uuid, itemUUID, tag, stat, statType)
				end
			end
		end

		if isPlayer then
			UniqueManager.LevelUpUnique(character, item)
			local unique = AllUniques[itemUUID]
			if unique ~= nil and not unique:IsReleasedFromOwner() then
				unique:ReleaseFromOwner()
				unique.Owner = uuid
			end

			CheckFirearmRunes(character, item)
		end

		template = StringHelpers.GetUUID(template)
		local callbacks = Listeners.EquipmentChanged.Template[template]
		if callbacks ~= nil then
			if Vars.DebugEnabled then
				Ext.Print(string.format("[WeaponExpansion:EquipmentChanged.Template] Template(%s) Stat(%s) Character(%s) Equipped(true)", template, item.StatsId, character.MyGuid))
			end
			for i,callback in pairs(callbacks) do
				local b,err = xpcall(callback, debug.traceback, character, item, template, true)
				if not b then
					Ext.PrintError(err)
				end
			end
		end
		for tag,callbacks in pairs(Listeners.EquipmentChanged.Tag) do
			if item:HasTag(tag) then
				if Vars.DebugEnabled then
					Ext.Print(string.format("[WeaponExpansion:EquipmentChanged.Tag] Tag(%s) Stat(%s) Character(%s) Equipped(true)", tag, item.StatsId, character.MyGuid))
				end
				for i,callback in pairs(callbacks) do
					local b,err = xpcall(callback, debug.traceback, character, item, tag, true)
					if not b then
						Ext.PrintError(err)
					end
				end
			end
		end
	end
end

function OnItemTemplateUnEquipped(uuid, itemUUID, template)
	local isPlayer = IsPlayer(uuid)
	CheckForUnarmed(uuid, isPlayer)

	if isPlayer then
		Equipment.CheckWeaponRequirementTags(uuid)
	end
	
	local character = Ext.GetCharacter(uuid)
	local item = Ext.GetItem(itemUUID)
	template = StringHelpers.GetUUID(template)
	local callbacks = Listeners.EquipmentChanged.Template[template]
	if callbacks ~= nil then
		if Vars.DebugEnabled then
			Ext.Print(string.format("[WeaponExpansion:EquipmentChanged.Template] Template(%s) Stat(%s) Character(%s) Equipped(false)", template, item.StatsId, character.MyGuid))
		end
		for i,callback in pairs(callbacks) do
			local b,err = xpcall(callback, debug.traceback, character, item, template, false)
			if not b then
				Ext.PrintError(err)
			end
		end
	end
	for tag,callbacks in pairs(Listeners.EquipmentChanged.Tag) do
		if item:HasTag(tag) then
			if Vars.DebugEnabled then
				Ext.Print(string.format("[WeaponExpansion:EquipmentChanged.Tag] Tag(%s) Stat(%s) Character(%s) Equipped(false)", tag, item.StatsId, character.MyGuid))
			end
			for i,callback in pairs(callbacks) do
				local b,err = xpcall(callback, debug.traceback, character, item, tag, false)
				if not b then
					Ext.PrintError(err)
				end
			end
		end
	end
end

local rodSkills = {
	Air = {"Projectile_LLWEAPONEX_ShootRod_Air", "Projectile_LLWEAPONEX_ShootRod_Air_Offhand"},
	Chaos = {"Projectile_LLWEAPONEX_ShootRod_Chaos", "Projectile_LLWEAPONEX_ShootRod_Chaos_Offhand"},
	Earth = {"Projectile_LLWEAPONEX_ShootRod_Earth", "Projectile_LLWEAPONEX_ShootRod_Earth_Offhand"},
	Fire = {"Projectile_LLWEAPONEX_ShootRod_Fire", "Projectile_LLWEAPONEX_ShootRod_Fire_Offhand"},
	Poison = {"Projectile_LLWEAPONEX_ShootRod_Poison", "Projectile_LLWEAPONEX_ShootRod_Poison_Offhand"},
	Water = {"Projectile_LLWEAPONEX_ShootRod_Water", "Projectile_LLWEAPONEX_ShootRod_Water_Offhand"},
	Magic = {"Projectile_LLWEAPONEX_ShootRod_MagicMissile", "Projectile_LLWEAPONEX_ShootRod_MagicMissile_Offhand"},
}

local uniqueRodSkills = {
	WPN_UNIQUE_LLWEAPONEX_Rod_1H_MagicMissile_A = { "Projectile_LLWEAPONEX_ShootRod_MagicMissile", "Projectile_LLWEAPONEX_ShootRod_MagicMissile_Offhand" },
}

function AddRodSkill(char, item)
	local stat = NRD_ItemGetStatsId(item)
	if Ext.StatGetAttribute(stat, "WeaponType") ~= "Wand" then
		local mainhandSkill, offhandSkill = nil, nil
		local skills = uniqueRodSkills[stat]
		if skills == nil then
			local damageType = Ext.StatGetAttribute(stat, "Damage Type")
			skills = rodSkills[damageType]
			if skills ~= nil then
				mainhandSkill,offhandSkill = table.unpack(skills)
			end
		else
			mainhandSkill,offhandSkill = table.unpack(skills)
		end

		if mainhandSkill ~= nil and offhandSkill ~= nil then
			local slot = GameHelpers.Item.GetEquippedSlot(char,item)
			if slot == "Weapon" then
				CharacterAddSkill(char, mainhandSkill, 0)
				SetVarFixedString(item, "LLWEAPONEX_Rod_ShootSkill", mainhandSkill)
			elseif slot == "Shield" then
				CharacterAddSkill(char, offhandSkill, 0)
				SetVarFixedString(item, "LLWEAPONEX_Rod_ShootSkill", offhandSkill)
			else
				CharacterRemoveSkill(char, mainhandSkill)
				CharacterRemoveSkill(char, offhandSkill)
			end
		end
	end
end

local function WeaponHasRodSkill(weapon, skill)
	if weapon ~= nil and GetVarFixedString(weapon, "LLWEAPONEX_Rod_ShootSkill") == skill then
		return true
	end
	return false
end

function RemoveRodSkill(char, item)
	local skill = GetVarFixedString(item, "LLWEAPONEX_Rod_ShootSkill")
	if not LeaderLib.StringHelpers.IsNullOrEmpty(skill) then
		local mainhand = CharacterGetEquippedItem(char, "Weapon")
		local offhand = CharacterGetEquippedItem(char, "Shield")
		if not WeaponHasRodSkill(mainhand, skill) and not WeaponHasRodSkill(offhand, skill) then
			CharacterRemoveSkill(char, skill)
		end
	end
end

local function GetRodTypeQRY(item)
	local stat = NRD_ItemGetStatsId(item)
	local skills = uniqueRodSkills[stat]
	if skills == nil then
		local damageType = Ext.StatGetAttribute(stat, "Damage Type")
		skills = rodSkills[damageType]
		if skills ~= nil then
			return skills[1], skills[2]
		end
	else
		return skills[1], skills[2]
	end
end

Ext.NewQuery(GetRodTypeQRY, "LLWEAPONEX_Ext_QRY_GetRodSkills", "[in](ITEMGUID)_Rod, [out](STRING)_MainhandSkill, [out](STRING)_OffhandSkill")

function MagicMissileWeapon_Swap(char, wand, rod)
	local equippedItem = nil
	local targetItem = nil
	local slot = GameHelpers.Item.GetEquippedSlot(char,wand)
	if slot == nil then
		slot = GameHelpers.Item.GetEquippedSlot(char,rod)
		equippedItem = rod
		targetItem = wand
	else
		equippedItem = wand
		targetItem = rod
	end
	if equippedItem ~= nil and targetItem ~= nil then
		CharacterUnequipItem(char, equippedItem)
		--ItemToInventory(equippedItem, targetItem, 1, 0, 0)
		NRD_CharacterEquipItem(char, targetItem, slot, 0, 0, 1, 1)
		Osi.LeaderLib_Timers_StartObjectObjectTimer(equippedItem, targetItem, 50, "Timers_LLWEAPONEX_MoveMagicMissileWeapon", "LeaderLib_Commands_ItemToInventory")
	end
end

function HasEmptyHand(uuid, ignoreShields)
	local mainhand = CharacterGetEquippedItem(uuid, "Weapon")
	local offhand = CharacterGetEquippedItem(uuid, "Shield")
	if not StringHelpers.IsNullOrEmpty(mainhand) then
		local item = Ext.GetItem(mainhand)
		if item ~= nil and item.Stats.IsTwoHanded then
			return false
		end
		if not StringHelpers.IsNullOrEmpty(offhand) then
			if ignoreShields ~= nil then
				item = Ext.GetItem(offhand)
				if item ~= nil and item.ItemType == "Shield" then
					return true
				end
			end
			return false
		end
	end
	return true
end

RegisterProtectedOsirisListener("ItemAddedToCharacter", 2, "after", function(item, char)
	if IsPlayer(char) then
		local unique = AllUniques[StringHelpers.GetUUID(item)]
		if unique ~= nil and not unique:IsReleasedFromOwner() then
			unique:ReleaseFromOwner()
		end
	end
end)

Ext.RegisterOsirisListener("CharacterItemEvent", 3, "after", function(char, item, event)
	if event == "LeaderLib_Events_ItemLeveledUp" then
		char = StringHelpers.GetUUID(char)
		item = StringHelpers.GetUUID(item)
		local unique = AllUniques[item]
		if unique ~= nil then
			unique:OnItemLeveledUp(char)
		end
	end
end)

local blockTagCombinations = {
	ARROWS = {
		LLWEAPONEX_Firearm_Equipped = "LLWEAPONEX_StatusText_BlockedArrowOnGun"
	}
}

---@param item EsvItem
---@param char EsvCharacter
local function ShouldBlockItem(item, char)
	for itemTag,characterTags in pairs(blockTagCombinations) do
		if item:HasTag(itemTag) then
			for tag,blockText in pairs(characterTags) do
				if char:HasTag(tag) then
					if blockText ~= "" and CharacterIsControlled(charUUID) == 1 then
						CharacterStatusText(char.MyGuid, blockText)
					end
					return true
				end
			end
		end
	end
	return false
end

RegisterProtectedOsirisListener("CanUseItem", 3, "before", function(charUUID, itemUUID, request)
	local item = Ext.GetItem(itemUUID)
	local char = Ext.GetCharacter(charUUID)

	if item ~= nil and char ~= nil then
		local db = Osi.DB_CurrentGameMode:Get("GameMaster")
		local isGameMaster = db ~= nil and #db > 0
		if ShouldBlockItem(item, char) then
			if not isGameMaster then
				Osi.DB_CustomUseItemResponse(charUUID, itemUUID, 0)
			else
				RequestProcessed(charUUID, request, 0)
			end
		end
	end
end)

local bulletTemplates = {
	["0f0dea4a-4e3b-48b0-92c7-6f33bdc3f2df"] = true,
	["0a1fa669-d8fb-4767-a129-e14fbd91b195"] = true,
	["d1b28a79-ccd2-481b-b035-13e15346cefb"] = true,
	["bc37a903-547a-4010-a845-7ef244e6b2cb"] = true,
	["92862716-b0db-46b4-9356-9858f9e743f0"] = true,
	["932fb7ba-2634-4b8a-b40a-936077a08008"] = true,
	["6e569546-bd74-4856-819b-d40b08b026ba"] = true,
	["e1125176-cd00-4f7a-8298-ac862d12cf15"] = true,
	["6572eec4-eeb3-4b9d-9cdd-15952a9a8ca6"] = true,
	["6e597ce1-d8b8-4720-89b9-75f6a71d64ba"] = true,
	["b059c11d-458a-4f89-8f18-15b48a402008"] = true,
	["a38aa4e6-ee75-4bb4-8c98-b9f358a23c25"] = true,
	["7ce736c8-1e02-462d-bee2-36bd86bd8979"] = true,
	["7c31f878-1f04-47bb-b8b1-05e605dc0b60"] = true,
	["deb24a84-006f-4a3a-b4bb-b40fa52a447d"] = true,
	["d4eebf4d-4f0c-4409-8fe8-32efeca06453"] = true,
	["8814954c-b0d1-4cdf-b075-3313ac71cf20"] = true,
	["22cae5a3-8427-4526-aa7f-4f277d0ff67e"] = true,
	["e44859b2-d55f-47e2-b509-fd32d7d3c745"] = true,
	["fbf17754-e604-4772-813a-3593b4e7bec8"] = true,
}

function CheckFirearmRunes(char, item)
	if item:HasTag("LLWEAPONEX_Firearm") then
		local changedProjectile = false
		for i,v in pairs(item.Stats.DynamicStats) do
			if not StringHelpers.IsNullOrEmpty(v.BoostName) 
			and not StringHelpers.IsNullOrEmpty(v.Projectile) 
			and v.Projectile ~= item.Stats.Projectile
			and bulletTemplates[v.Projectile] ~= true then
				print(i, v.BoostName, v.Projectile)
				v.Projectile = item.Stats.Projectile
				changedProjectile = true
			end
		end
		if changedProjectile then
			item.Stats.ShouldSyncStats = true
		end
	end
end

RegisterProtectedOsirisListener("RuneInserted", 4, "after", function(charUUID, itemUUID, runeTemplate, slot)
	local char = Ext.GetCharacter(charUUID)
	local item = Ext.GetItem(itemUUID)
	CheckFirearmRunes(char, item)
end)