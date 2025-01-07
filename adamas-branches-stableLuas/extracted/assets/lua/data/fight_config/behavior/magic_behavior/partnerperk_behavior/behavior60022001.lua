Behavior60022001 = BaseClass("Behavior60022001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60022001.GetGenerates()
end

function Behavior60022001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60022001:Init()
	self.Me = self.instanceId
end


function Behavior60022001:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
end

function Behavior60022001:Damage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt,camp)
	if hitInstanceId == self.Me and camp ~= 1 then
		local shield = BehaviorFunctions.GetTotalShild(self.Me)--获取有效护盾值
		--如果当前有护盾,对敌人造成受到伤害的10%
		if shield > 0 then
			BF.DoDamageByMagicId(self.Me, attackInstanceId, 60022002, 0,damageVal * self.customParam[1]/10000)
		end
	end
end