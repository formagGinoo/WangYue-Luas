Behavior60004001 = BaseClass("Behavior60004001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60004001.GetGenerates()
end

function Behavior60004001.GetMagics()
	local generates = {60004002}
	return generates
end

function Behavior60004001:Init()
	self.Me = self.instanceId
end

function Behavior60004001:Die(attackInstanceId,dieInstanceId)
	
	if attackInstanceId == self.Me then
		BF.AddBuff(self.Me,self.Me,60004002)
	end
end