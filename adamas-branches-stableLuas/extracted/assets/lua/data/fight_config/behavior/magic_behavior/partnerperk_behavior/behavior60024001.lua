Behavior60024001 = BaseClass("Behavior60024001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60024001.GetGenerates()
end

function Behavior60024001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60024001:Init()
	self.Me = self.instanceId
end

function Behavior60024001:LateInit()
	BehaviorFunctions.DoMagic(self.Me,self.Me,60024002)
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.Me)
	if self.partner then
		BehaviorFunctions.DoMagic(self.Me,self.partner,60024002,self._level)
	end
end