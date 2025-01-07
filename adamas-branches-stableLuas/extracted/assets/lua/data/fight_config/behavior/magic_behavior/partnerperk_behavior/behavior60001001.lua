Behavior60001001 = BaseClass("Behavior60001001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60001001.GetGenerates()
end

function Behavior60001001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60001001:Init()
	self.Me = self.instanceId
end

--获取计算公式参数前
function Behavior60001001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--角色增加a%属性伤害加成。
	if BF.CheckEntityInFormation(ownerInstanceId) and BF.GetEntityElement(ownerInstanceId) == self.customParam[2] then
		BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
	end
end