Behavior60021001 = BaseClass("Behavior60021001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60021001.GetGenerates()
end

function Behavior60021001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60021001:Init()
	self.Me = self.instanceId
end


function Behavior60021001:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
	
end


function Behavior60021001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	if ownerInstanceId == self.Me then
		
		local shield = BF.GetTotalShild(self.Me)--获取有效护盾值
		local hp = BF.GetEntityAttrVal(self.Me,1001)--获取当前生命值
		local val = shield/hp
		
		if shield > 0 then
			if self.customParam[1] * val <= self.customParam[2] then
				BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1] * val)
			else
				BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[2])
			end
		end
	end
end
