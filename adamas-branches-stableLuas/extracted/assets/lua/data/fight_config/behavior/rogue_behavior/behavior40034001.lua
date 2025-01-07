Behavior40034001 = BaseClass("Behavior40034001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40034001.GetGenerates()
end

function Behavior40034001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40034001:Init()
	self.Me = self.instanceId
end

function Behavior40034001:LateInit()
	
end

function Behavior40034001:Update()
	BF.SetEntityValue(self.Me,"assVal",self.customParam[1])
end

