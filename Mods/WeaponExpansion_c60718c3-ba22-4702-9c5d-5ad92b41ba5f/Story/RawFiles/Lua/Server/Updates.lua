---@param last integer
---@param next integer
LeaderLib.RegisterModListener("Loaded", "c60718c3-ba22-4702-9c5d-5ad92b41ba5f", function(last, next)
	print("[LLWEAPONEX:Loaded]", last, "=>", next)
	if last < 152764417 then
		ItemLockUnEquip("40039552-3aae-4beb-8cca-981809f82988", 0)
		ItemToInventory("40039552-3aae-4beb-8cca-981809f82988", "80976258-a7a5-4430-b102-ba91a604c23f")
		ItemLockUnEquip("927669c3-b885-4b88-a0c2-6825fbf11af2", 0)
		ItemToInventory("927669c3-b885-4b88-a0c2-6825fbf11af2", "80976258-a7a5-4430-b102-ba91a604c23f")
	end

	if last < 153092096 then
		if not Ext.IsDeveloperMode() then
			if not IsPlayer(Origin.Harken) then
				if not IsPlayer(Uniques.AnvilMace.Owner) then
					Uniques.AnvilMace:Transfer(NPC.VendingMachine)
				end
				--Uniques.HarkenPowerGloves:Transfer(NPC.VendingMachine)
			end
			if not IsPlayer(Origin.Korvash) then
				if not IsPlayer(Uniques.DeathEdge.Owner) then
					Uniques.DeathEdge:Transfer(NPC.VendingMachine)
				end
				if not IsPlayer(Uniques.DemonGauntlet.Owner) then
					Uniques.DemonGauntlet:Transfer(NPC.VendingMachine)
				end
			end
		end
	end

	-- Tag updating
	for _,db in pairs(Osi.DB_IsPlayer:Get(nil)) do
		local uuid = db[1]
		EquipmentManager.CheckWeaponRequirementTags(StringHelpers.GetUUID(db[1]))
		if HasActiveStatus(uuid, "LLWEAPONEX_UNARMED_LIZARD_DEBUFF") == 1 then
			RemoveStatus(uuid, "LLWEAPONEX_UNARMED_LIZARD_DEBUFF")
		end

		if IsTagged(uuid, "LLWEAPONEX_Quiver_Equipped") == 1 and last < 153026560 then
			local quiver = Ext.GetCharacter(uuid).Stats:GetItemBySlot("Belt")
			if quiver ~= nil then
				ItemResetChargesToMax(quiver.MyGuid)
			end
			if CharacterIsInCombat(uuid) == 0 then
				Quiver_RemoveTempArrows(uuid)
			end
		end

		local hasBluntTag = not StringHelpers.IsNullOrEmpty(CharacterFindTaggedItem(uuid, "LLWEAPONEX_Blunt"))
		if hasBluntTag then
			for i,v in pairs(Ext.GetCharacter(uuid):GetInventoryItems()) do
				if IsTagged(v, "LLWEAPONEX_Blunt") == 1 then
					ClearTag(v, "LLWEAPONEX_Blunt")
					SetTag(v, "LLWEAPONEX_Bludgeon")
				end
			end
		end

		if HasActiveStatus(uuid, "Shout_LLWEAPONEX_Prepare_BalrinsAxe") == 1 then
			CharacterRemoveSkill(uuid, "Shout_LLWEAPONEX_Prepare_BalrinsAxe")
		end
	end
end)