Behavior40031001 = BaseClass("Behavior40031001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40031001.GetGenerates()
end

function Behavior40031001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40031001:Init()
	self.Me = self.instanceId
end

function Behavior40031001:LateInit()

	self.roleList = BehaviorFunctions.GetCurFormationEntities()
	for i,v in pairs(self.roleList) do
		BF.SetAllowDoubleJump(self.roleList[i], true)
	end
end


function Behavior40031001:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if buffId == 40031001 then
		for i,v in pairs(self.roleList) do
			BF.SetAllowDoubleJump(self.roleList[i], false)
		end
	end
end