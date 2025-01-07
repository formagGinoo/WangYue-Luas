Behavior60006001 = BaseClass("Behavior60006001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60006001.GetGenerates()
end

function Behavior60006001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60006001:Init()
	self.Me = self.instanceId
end

function Behavior60006001:CastSkill(instanceId,skillId,skillType)
	
	if BF.CheckEntityForeground(instanceId) and skillType == 10 then
		BF.AddBuff(self.Me,instanceId,60006002,self._level)
	end
	
	
end