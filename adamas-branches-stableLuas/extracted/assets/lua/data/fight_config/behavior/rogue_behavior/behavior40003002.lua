Behavior40003002 = BaseClass("Behavior40003002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40003002.GetGenerates()
end

function Behavior40003002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40003002:Init()
	self.Me = self.instanceId
end

--释放技能判断
function Behavior40003002:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	--跳反后会获得16%的伤害加成，持续8秒。
	if BF.CheckEntity(instanceId) and BF.CheckEntityInFormation(instanceId)
		and BF.AnalyseSkillType(skillType,FE.SkillType.JumpCounterAttack) then
		local c = BF.GetCtrlEntity()
		if BF.CheckEntity(c) then
			BF.AddBuff(c,c,40003004)
		end
	end
end