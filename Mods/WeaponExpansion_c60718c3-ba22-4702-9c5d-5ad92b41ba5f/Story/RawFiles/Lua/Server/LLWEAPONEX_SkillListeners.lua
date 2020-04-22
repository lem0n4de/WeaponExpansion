local SKILL_STATE = {
	PREPARE = "PREPARE",
	USED = "USED",
	CAST = "CAST",
	HIT = "HIT",
}

WeaponExpansion.Skills.SKILL_STATE = SKILL_STATE

local function GetRealSkill(id)
	if string.find(id, "Enemy") then
		local skill = Ext.StatGetAttribute(id, "Using")
		return GetRealSkill(skill)
	end
	return id
end

function OnSkillPreparing(char, skillprototype)
	local skill = GetRealSkill(string.gsub(skillprototype, "_%-?%d+$", ""))
	LeaderLib.Print("[LLWEAPONEX_SkillListeners.lua:OnSkillPreparing] char(",char,") skillprototype(",skillprototype,") skill(",skill,")")
	local listener = WeaponExpansion.Skills.Listeners[skill]
	if listener ~= nil then
		local status,err = xpcall(listener, debug.traceback, GetUUID(char), SKILL_STATE.PREPARE)
		if not status then
			Ext.PrintError("[LLWEAPONEX_SkillListeners] Error invoking function:\n", err)
		end
	end
end

function OnSkillUsed(char, skillUsed, ...)
	local skill = GetRealSkill(skillUsed)
	LeaderLib.Print("[LLWEAPONEX_SkillListeners.lua:OnSkillUsed] char(",char,") skillUsed(",skillUsed,") skill(",skill,") params(",Ext.JsonStringify({...}),")")
	local listener = WeaponExpansion.Skills.Listeners[skill]
	if listener ~= nil then
		local status,err = xpcall(listener, debug.traceback, GetUUID(char), SKILL_STATE.USED, {...})
		if not status then
			Ext.PrintError("[LLWEAPONEX_SkillListeners] Error invoking function:\n", err)
		end
	end
end

function OnSkillCast(char, skillUsed, ...)
	local skill = GetRealSkill(skillUsed)
	LeaderLib.Print("[LLWEAPONEX_SkillListeners.lua:OnSkillCast] char(",char,") skillUsed(",skillUsed,") skill(",skill,") params(",Ext.JsonStringify({...}),")")
	local listener = WeaponExpansion.Skills.Listeners[skill]
	if listener ~= nil then
		local status,err = xpcall(listener, debug.traceback, GetUUID(char), SKILL_STATE.CAST, {...})
		if not status then
			Ext.PrintError("[LLWEAPONEX_SkillListeners] Error invoking function:\n", err)
		end
	end
end

function OnSkillHit(char, skillprototype, ...)
	local skill = GetRealSkill(string.gsub(skillprototype, "_%-?%d+$", ""))
	LeaderLib.Print("[LLWEAPONEX_SkillListeners.lua:OnSkillHit] char(",char,") skillprototype(",skillprototype,") skill(",skill,") params(",Ext.JsonStringify({...}),")")
	local listener = WeaponExpansion.Skills.Listeners[skill]
	if listener ~= nil then
		local status,err = xpcall(listener, debug.traceback, GetUUID(char), SKILL_STATE.HIT, {...})
		if not status then
			Ext.PrintError("[LLWEAPONEX_SkillListeners] Error invoking function:\n", err)
		end
	end
end