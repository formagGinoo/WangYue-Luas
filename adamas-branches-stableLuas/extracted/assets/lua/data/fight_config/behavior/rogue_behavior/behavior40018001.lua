Behavior40018001 = BaseClass("Behavior40018001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40018001.GetGenerates()
end

function Behavior40018001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40018001:Init()
	self.Me = self.instanceId
end

function Behavior40018001:Update()
	self.Role1 = BF.GetQTEEntity(1)
	self.Role2 = BF.GetQTEEntity(2)
	self.Role3 = BF.GetQTEEntity(3)
	self.partner1 = BF.GetPartnerInstanceId(1)
	self.partner2 = BF.GetPartnerInstanceId(2)
	self.partner3 = BF.GetPartnerInstanceId(3)
end

--获取计算公式参数前
function Behavior40018001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	if self.partner1 and attackInstanceId == self.partner1 then
		BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
	end
	if self.partner2 and attackInstanceId == self.partner2 then
		BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
	end
	if self.partner3 and attackInstanceId == self.partner3 then
		BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
	end
end