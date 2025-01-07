Behavior62001031 = BaseClass("Behavior62001031",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior62001031.GetGenerates()
end

function Behavior62001031.GetMagics()
	local generates = {}
	return generates
end

function Behavior62001031:Init()
	self.Me = self.instanceId
end

--获取计算公式参数前
function Behavior62001031:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	if ownerInstanceId == self.Me then
		local angle = BehaviorFunctions.GetEntityAngle(hitInstanceId,ownerInstanceId)
		if angle > 90 and angle < 270 then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		end
	end
	
	if hitInstanceId == self.Me then
		local angle = BehaviorFunctions.GetEntityAngle(hitInstanceId,ownerInstanceId)
		if angle > 90 and angle < 270 then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,-self.customParam[2])
		end
	end
end