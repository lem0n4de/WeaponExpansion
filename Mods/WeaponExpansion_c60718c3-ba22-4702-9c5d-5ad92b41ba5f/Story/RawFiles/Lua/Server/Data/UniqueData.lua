---@class UniqueData
local UniqueData = {
	UUID = "",
	LevelData = {},
	Owner = nil,
	DefaultOwner = nil,
	CurrentLevel = nil,
	AutoEquipOnOwner = false,
	Initialized = false,
	OnEquipped = nil,
	OnGotOwner = nil,
	LastProgressionLevel = 0
}
UniqueData.__index = UniqueData

---@param uuid string
---@param leveldata table<string,number[]>
---@param defaultNPCOwner string An NPC that should have the unique until a player takes it.
---@param autoEquip boolean Whether to automatically equip the unique on the default owner.
---@return UniqueData
function UniqueData:Create(uuid, leveldata, defaultNPCOwner, autoEquip, params)
	if leveldata == nil then
		leveldata = {}
	end
    local this =
    {
		UUID = uuid,
		LevelData = leveldata,
		Owner = nil,
		DefaultOwner = defaultNPCOwner,
		AutoEquipOnOwner = false,
		Initialized = false,
		OnEquipped = nil,
		OnGotOwner = nil,
		LastProgressionLevel = 0
	}
	setmetatable(this, self)
	if autoEquip ~= nil then
		this.AutoEquipOnOwner = autoEquip
	end
	if params ~= nil then
		for prop,value in pairs(params) do
			this[prop] = value
		end
	end
    return this
end

function UniqueData:CanMoveToOwner()
	if self.DefaultOwner ~= nil 
	and (ObjectExists(self.DefaultOwner) == 1
	and CharacterIsDead(self.DefaultOwner) == 0
	and GetInventoryOwner(self.UUID) ~= self.DefaultOwner)
	then
		return true
	end
	return false
end

function UniqueData:OnLevelChange(region)
	if ObjectExists(self.UUID) == 1 then
		self.Initialized = ObjectGetFlag(self.UUID, "LLWEAPONEX_UniqueData_Initialized") == 1
		if not self.Initialized then
			if self:CanMoveToOwner() then
				ItemToInventory(self.UUID, self.DefaultOwner, 1, 0, 1)
				if self.AutoEquipOnOwner then
					local targetSlot = Ext.GetItem(self.UUID).Stats.Slot
					local currentItem = CharacterGetEquippedItem(self.DefaultOwner, targetSlot)
					if currentItem == nil then
						CharacterEquipItem(self.DefaultOwner, self.UUID)
						if self.OnEquipped ~= nil then
							pcall(self.OnEquipped, self, self.DefaultOwner)
						end
					else
						ItemToInventory(self.UUID, self.DefaultOwner, 1, 0, 1)
					end
				end
			else
				local targetPosition = self.LevelData[region]
				if targetPosition ~= nil then
					local x,y,z,pitch,yaw,roll = table.unpack(targetPosition)
					local host = CharacterGetHostCharacter()
					TeleportTo(self.UUID, host, "", 0, 1, 0)
					ItemToTransform(self.UUID, x,y,z,pitch,yaw,roll,1,nil)
				end
			end
			self.Initialized = true
			ObjectSetFlag(self.UUID, "LLWEAPONEX_UniqueData_Initialized", 0)
		else
			if GetRegion(self.UUID) ~= region and self.Owner == nil then
				if self:CanMoveToOwner() and GetRegion(self.DefaultOwner) == region then
					ItemToInventory(self.UUID, self.DefaultOwner, 1, 0, 1)
					if self.AutoEquipOnOwner then
						local targetSlot = Ext.GetItem(self.UUID).Stats.Slot
						local currentItem = CharacterGetEquippedItem(self.DefaultOwner, targetSlot)
						if currentItem == nil then
							CharacterEquipItem(self.DefaultOwner, self.UUID)
							if self.OnEquipped ~= nil then
								pcall(self.OnEquipped, self, self.DefaultOwner)
							end
						else
							ItemToInventory(self.UUID, self.DefaultOwner, 1, 0, 1)
						end
					end
				else
					local targetPosition = self.LevelData[region]
					if targetPosition ~= nil then
						local x,y,z,pitch,yaw,roll = table.unpack(targetPosition)
						local host = CharacterGetHostCharacter()
						TeleportTo(self.UUID, host, "", 0, 1, 0)
						ItemToTransform(self.UUID, x,y,z,pitch,yaw,roll,1,nil)
					end
				end
			end
		end
	end
end

function UniqueData:AddPosition(region,x,y,z,rx,ry,rz)
	self.LevelData[region] = {
		x,y,z,
		0.0174533 * rx,
		0.0174533 * ry,
		0.0174533 * rz
	}
end

function UniqueData:Transfer(target, equip)
	if ObjectExists(self.UUID) == 0 then
		print("[UniqueData:Transfer] Item", self.UUID, "does not exist!")
		return
	end
	self.Initialized = true
	self.Owner = target
	ItemToInventory(self.UUID, target, 1, 1, 1)
	if equip == true then
		CharacterEquipItem(target, self.UUID)
		if self.OnEquipped ~= nil then
			pcall(self.OnEquipped, self, target)
		end
	end
end

---@param entry UniqueProgressionEntry
---@param stat StatEntryWeapon
local function ApplyProgressionEntry(entry, stat)
	if entry.Attribute == "ExtraProperties" then
		if entry.Append == true then
			local props = stat.ExtraProperties or {}
			table.insert(props, entry.Value)
		else
			stat.ExtraProperties = {entry.Value}
		end
	else
		if entry.Append == true then
			local current = stat[entry.Attribute]
			if entry.Attribute == "Boosts" or entry.Attribute == "Skills" then
				stat[entry.Attribute] = current .. ";" .. entry.Value
			else
				stat[entry.Attribute] = current + entry.Value
			end
		else
			stat[entry.Attribute] = entry.Value
		end
	end
end

---@param progressionTable table<integer,UniqueProgressionEntry|UniqueProgressionEntry[]>
function UniqueData:ApplyProgression(progressionTable)
	local item = Ext.GetItem(self)
	local level = item.Stats.Level
	if progressionTable ~= nil and #progressionTable > 0 then
		local stat = Ext.GetStat(item.StatsId, level)
		for i=self.LastProgressionLevel,level do
			local entries = progressionTable[i]
			if entries ~= nil then
				if entries.Type == "UniqueProgressionEntry" then
					ApplyProgressionEntry(entries, stat)
				elseif #entries > 0 then
					for i,v in pairs(entries) do
						ApplyProgressionEntry(v, stat)
					end
				end
			end
		end
	end
end

return UniqueData