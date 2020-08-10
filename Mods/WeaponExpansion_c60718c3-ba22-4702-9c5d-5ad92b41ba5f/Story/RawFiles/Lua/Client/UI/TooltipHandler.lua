TooltipHandler = {}

local function sortTagParams(a,b)
	return a:upper() < b:upper()
end

---@param character EsvCharacter
---@param data table
function TooltipHandler.GetDescriptionText(character, data)
	local descriptionText = ""
	local namePrefix = ""
	if data.Tags ~= nil then
		local tagKeys = {}
		for tagName,tagData in pairs(data.Tags) do
			table.insert(tagKeys, tagName)
		end
		local count = #tagKeys
		table.sort(tagKeys, sortTagParams)
		for i,tagName in ipairs(tagKeys) do
			local tagData = data.Tags[tagName]
			if CLIENT_UI.IsInCharacterCreation or Mastery.HasMasteryRequirement(character, tagName) then
				if tagData.NamePrefix ~= nil then
					if namePrefix ~= "" then
						namePrefix = namePrefix .. " "
					end
					namePrefix = namePrefix .. tagData.NamePrefix
				end
				local paramText = ""
				--local tagLocalizedName = Text.MasteryRankTagText[tagName]
				local tagLocalizedName = Ext.GetTranslatedStringFromKey(tagName)
				if tagLocalizedName == nil then 
					tagLocalizedName = ""
				else
					tagLocalizedName = tagLocalizedName .. "<br>"
				end
				if tagData.Param ~= nil then
					if tagLocalizedName ~= "" then
						paramText = tagLocalizedName..tagData.Param.Value
					else
						paramText = tagData.Param.Value
					end
				end
				paramText = Tooltip.ReplacePlaceholders(paramText)
				if tagData.GetParam ~= nil then
					local status,result = xpcall(tagData.GetParam, debug.traceback, character.Stats, tagName, tagLocalizedName, paramText)
					if status and result ~= nil then
						paramText = result
					elseif not status then
						Ext.PrintError("Error calling GetParam function for "..tagName..":\n", result)
					end
				end
				if descriptionText ~= "" then descriptionText = descriptionText .. "<br>" end
				descriptionText = descriptionText .. paramText
			end
		end
	end
	return descriptionText
end

local OnItemTooltip = Ext.Require("Client/UI/Tooltips/ItemTooltip.lua")
local OnSkillTooltip = Ext.Require("Client/UI/Tooltips/SkillTooltip.lua")
local OnStatusTooltip = Ext.Require("Client/UI/Tooltips/StatusTooltip.lua")

local statTooltips = Ext.Require("Client/UI/Tooltips/StatTooltips.lua")
local OnDamageStatTooltip = statTooltips.Damage

local function Init()
	Game.Tooltip.RegisterListener("Stat", "Damage", OnDamageStatTooltip)
	Game.Tooltip.RegisterListener("Skill", nil, OnSkillTooltip)
	Game.Tooltip.RegisterListener("Status", nil, OnStatusTooltip)
	Game.Tooltip.RegisterListener("Item", nil, OnItemTooltip)
end
return {
	Init = Init
}