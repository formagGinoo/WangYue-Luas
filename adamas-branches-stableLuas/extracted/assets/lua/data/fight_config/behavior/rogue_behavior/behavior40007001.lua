Behavior40007001 = BaseClass("Behavior40007001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40007001.GetGenerates()
end

function Behavior40007001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40007001:Init()
	self.Me = self.instanceId
end

--获取计算公式参数前
function Behavior40007001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--火系角色提升5%的普攻伤害
	if BF.CheckEntityInFormation(ownerInstanceId) and BF.GetEntityElement(ownerInstanceId) == FE.ElementType.Fire then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.NormalAttack) then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		end
	end
end