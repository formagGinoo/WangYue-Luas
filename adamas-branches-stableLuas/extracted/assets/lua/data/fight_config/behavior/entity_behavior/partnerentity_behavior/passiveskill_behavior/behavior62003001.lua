Behavior62003001 = BaseClass("Behavior62003001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior62003001.GetGenerates()
end

function Behavior62003001.GetMagics()
	local generates = {}
	return generates
end

function Behavior62003001:Init()
	self.Me = self.instanceId
end

function Behavior62003001:Update()
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.Me)
end

--获取计算公式参数前
function Behavior62003001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	if BehaviorFunctions.HasEntitySign(self.partner,6200302) then
		if self.partner and BehaviorFunctions.GetSkill(self.partner) == 62003621 then
			if ownerInstanceId == self.Me or ownerInstanceId == self.partner then
				BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
			end
		end
	end
end