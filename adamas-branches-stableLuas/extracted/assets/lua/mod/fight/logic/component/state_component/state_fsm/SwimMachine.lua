SwimMachine = BaseClass("SwimMachine",MachineBase)

function SwimMachine:__init()

end

function SwimMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.swimFSM = self.fight.objectPool:Get(SwimFSM)
	self.swimFSM:Init(fight,entity)
    self.swimFSM.parentFSM = self.parentFSM
    self.swimFSM.stateId = self.stateId
end

function SwimMachine:LateInit()
	self.swimFSM:LateInit()
end

function SwimMachine:OnEnter()
	self.swimFSM:StartSwim()
end

function SwimMachine:OnLeave()
	EventMgr.Instance:Fire(EventName.ExitDeath, self.entity.instanceId, FightEnum.DeathCondition.Drown)
	self.swimFSM:Reset()
end

function SwimMachine:Update()
	self.swimFSM:Update()
end

function SwimMachine:StopSwim()
	self.swimFSM:StopSwim()
end

function SwimMachine:IsState(state)
	return self.swimFSM:IsState(state)
end

function SwimMachine:CanMove()
	return true
end

function SwimMachine:CanJump()
	return false
end

function SwimMachine:GetSubState()
	return self.swimFSM:GetState()
end

function SwimMachine:CanCastSkill()
	return false
end

function SwimMachine:CanClimb()
	return self.swimFSM:CanClimb()
end

function SwimMachine:CanChangeRole()
	return self.swimFSM:CanChangeRole()
end

function SwimMachine:OnCache()
	if self.swimFSM then
		self.swimFSM:OnCache()
		self.swimFSM = nil
	end
	self.fight.objectPool:Cache(SwimMachine,self)
end

function SwimMachine:__cache()

end

function SwimMachine:__delete()
	if self.swimFSM then
		self.swimFSM:DeleteMe()
		self.swimFSM = nil
	end
end