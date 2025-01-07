Behavior40035001 = BaseClass("Behavior40035001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40035001.GetGenerates()
end

function Behavior40035001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40035001:Init()
	self.Me = self.instanceId
end

function Behavior40035001:LateInit()
	BF.SetEntityValue(self.Me,"rushCd",self.customParam[1])
end