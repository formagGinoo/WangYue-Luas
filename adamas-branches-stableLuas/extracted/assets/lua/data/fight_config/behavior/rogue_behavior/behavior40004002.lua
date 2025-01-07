Behavior40004002 = BaseClass("Behavior40004002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40004002.GetGenerates()
end

function Behavior40004002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40004002:Init()
	self.Me = self.instanceId
end

--获取计算公式参数前
function Behavior40004002:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--金系角色提升10%的普攻伤害
	if BF.CheckEntityInFormation(ownerInstanceId) and BF.GetEntityElement(ownerInstanceId) == FE.ElementType.Gold then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.NormalAttack) then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		end
	end
end