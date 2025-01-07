Behavior60020001 = BaseClass("Behavior60020001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60020001.GetGenerates()
end

function Behavior60020001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60020001:Init()
	self.Me = self.instanceId
end


function Behavior60020001:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
end

function Behavior60020001:AddBuff(entityInstanceId, buffInstanceId,buffId)
	local buffType = BehaviorFunctions.GetBuffEffectType(entityInstanceId, buffInstanceId)
	
	if buffType == FightEnum.BuffEffectType.ValueBuff or buffType == FightEnum.BuffEffectType.EffectBuff then
		
	end
end