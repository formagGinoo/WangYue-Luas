Behavior60023001 = BaseClass("Behavior60023001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60023001.GetGenerates()
end

function Behavior60023001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60023001:Init()
	self.Me = self.instanceId
end


function Behavior60023001:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
end

--获取计算公式参数前
function Behavior60023001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	if ownerInstanceId == self.Me or ownerInstanceId == self.partner then
		if BF.GetEntityAttrValueRatio(hitInstanceId,1001) == 10000 then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		end
	end
end
