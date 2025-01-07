Behavior60016001 = BaseClass("Behavior60016001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60016001.GetGenerates()
end

function Behavior60016001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60016001:Init()
	self.Me = self.instanceId
end

function Behavior60016001:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
end

--获取计算公式参数前
function Behavior60016001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	--每远离敌方目标a米，就会增加b%伤害。(距离敌方目标越远，伤害越高)
	if ownerInstanceId == self.Me or ownerInstanceId == self.partner then
		local distance = BF.GetDistanceFromTarget(self.Me,hitInstanceId,false)
		local val = math.floor(distance / self.customParam[1])
		if self.customParam[2] * val <= self.customParam[3] then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[2] * val)
		else
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[3])
		end
	end
end

