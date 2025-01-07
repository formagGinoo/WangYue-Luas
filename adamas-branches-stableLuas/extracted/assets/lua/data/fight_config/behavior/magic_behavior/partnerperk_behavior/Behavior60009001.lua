Behavior60009001 = BaseClass("Behavior60009001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60009001.GetGenerates()
end

function Behavior60009001.GetMagics()
	local generates = {60009002}
	return generates
end

function Behavior60009001:Init()
	self.Me = self.instanceId
end


--角色上场
function Behavior60009001:ChangeForeground(instanceId)
	if instanceId == self.Me then
		BF.AddBuff(self.Me,self.Me,60009002,self._level)
	end
end