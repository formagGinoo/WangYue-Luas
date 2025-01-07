Behavior600140001 = BaseClass("Behavior600140001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior600140001.GetGenerates()
end

function Behavior600140001.GetMagics()
	local generates = {}
	return generates
end

function Behavior600140001:Init()
	self.Me = self.instanceId
end


--获取计算公式参数前
function Behavior600140001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	--if BehaviorFunctions.HasEntitySign(self.Me,60014001) then
		if ownerInstanceId == self.Me then
			local hiter = BehaviorFunctions.GetEntityTemplateId(hitInstanceId)
			if hiter == 900090 then
				BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,-self.customParam[2])
			end
			
			if hiter == 900140 then
				BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
			end
		end
	--end
end