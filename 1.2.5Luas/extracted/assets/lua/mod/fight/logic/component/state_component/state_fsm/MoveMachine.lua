MoveMachine = BaseClass("MoveMachine",MachineBase)

function MoveMachine:__init()

end

function MoveMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.moveFSM = self.fight.objectPool:Get(MoveFSM)
	self.moveFSM:Init(fight,entity)
end

function MoveMachine:LateInit()
	self.moveFSM:LateInit()
end

function MoveMachine:OnEnter()
	self.moveFSM:StartMove()
end

function MoveMachine:OnLeave()
	self.moveFSM:Reset()
end

function MoveMachine:Update()
	self.moveFSM:Update()
end

function MoveMachine:StopMove()
	self.moveFSM:StopMove()
end

function MoveMachine:IsState(state)
	return self.moveFSM:IsState(state)
end

function MoveMachine:CanMove()
	return self.moveFSM:CanMove()
end

function MoveMachine:CanCastSkill()
	return self.moveFSM:CanCastSkill()
end

function MoveMachine:CanClimb()
	return self.moveFSM:CanClimb()
end

function MoveMachine:CanJump()
	return self.moveFSM:CanJump()
end

function MoveMachine:CanChangeRole()
	return self.moveFSM:CanChangeRole()
end

function MoveMachine:OnCache()
	if self.moveFSM then
		self.moveFSM:OnCache()
		self.moveFSM = nil
	end
	self.fight.objectPool:Cache(MoveMachine,self)
end

function MoveMachine:__cache()

end

function MoveMachine:__delete()
	if self.moveFSM then
		self.moveFSM:DeleteMe()
		self.moveFSM = nil
	end
end