Behavior40002002 = BaseClass("Behavior40002002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40002002.GetGenerates()
end

function Behavior40002002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40002002:Init()
	self.Me = self.instanceId
end

--获取计算公式参数前
function Behavior40002002:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--全队五行绝技伤害+10%
	if BF.CheckEntityInFormation(ownerInstanceId) then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Unique) then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		end
	end
end