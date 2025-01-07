ClimbMachine = BaseClass("ClimbMachine",MachineBase)

function ClimbMachine:__init()

end

function ClimbMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.climbFSM = self.fight.objectPool:Get(ClimbFSM)
	self.climbFSM:Init(fight,entity)
    self.climbFSM.parentFSM = self.parentFSM
    self.climbFSM.stateId = self.stateId
end

function ClimbMachine:LateInit()
	self.climbFSM:LateInit()
end

function ClimbMachine:OnEnter()
	self.climbFSM:StartClimb()
end

function ClimbMachine:OnLeave()
	self.climbFSM:Reset()
end

function ClimbMachine:Update()
	self.climbFSM:Update()
end

function ClimbMachine:StopClimb()
	self.climbFSM:StopClimb()
end

function ClimbMachine:IsState(state)
	return self.climbFSM:IsState(state)
end

function ClimbMachine:CanMove()
	return self.climbFSM:CanMove()
end

function ClimbMachine:CanJump()
	return false
end

function ClimbMachine:GetSubState()
	return self.climbFSM:GetState()
end

function ClimbMachine:CanCastSkill()
	return false
end

function ClimbMachine:CanChangeRole()
	return self.climbFSM:CanChangeRole()
end

function ClimbMachine:OnCache()
	if self.climbFSM then
		self.climbFSM:OnCache()
		self.climbFSM = nil
	end
	self.fight.objectPool:Cache(ClimbMachine,self)
end

function ClimbMachine:__cache()

end

function ClimbMachine:__delete()
	if self.climbFSM then
		self.climbFSM:DeleteMe()
		self.climbFSM = nil
	end
end