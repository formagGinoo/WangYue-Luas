Behavior60008001 = BaseClass("Behavior60008001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60008001.GetGenerates()
end

function Behavior60008001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60008001:Init()
	self.Me = self.instanceId
end


--对有负面buff的敌人造成的伤害+a%。
function Behavior60008001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	if BF.CheckEntityInFormation(ownerInstanceId) and ownerInstanceId == self.Me then
		if BehaviorFunctions.HasBuffEffectKind(hitInstanceId, FE.BuffEffectType.EffectDebuff) then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		end
	end
end