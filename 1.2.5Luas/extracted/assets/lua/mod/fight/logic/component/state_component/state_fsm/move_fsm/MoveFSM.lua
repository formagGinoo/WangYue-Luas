MoveFSM = BaseClass("MoveFSM",FSM)
local EntityMoveMode = FightEnum.EntityMoveMode
local EntityMoveSubState = FightEnum.EntityMoveSubState

function MoveFSM:__init()
end

function MoveFSM:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.moveMode = EntityMoveMode.Run
	self.isSprint = false
	self:InitStates()
end

function MoveFSM:InitStates()
	local objectPool = self.fight.objectPool
	self:AddState(EntityMoveSubState.None, objectPool:Get(MoveNoneMachine))
	self:AddState(EntityMoveSubState.WalkStart, objectPool:Get(WalkStartMachine))
	self:AddState(EntityMoveSubState.Walk, objectPool:Get(WalkMachine))
	self:AddState(EntityMoveSubState.WalkEnd, objectPool:Get(WalkEndMachine))
	self:AddState(EntityMoveSubState.WalkBack, objectPool:Get(WalkBackMachine))
	self:AddState(EntityMoveSubState.WalkLeft, objectPool:Get(WalkLeftMachine))
	self:AddState(EntityMoveSubState.WalkRight, objectPool:Get(WalkRightMachine))
	self:AddState(EntityMoveSubState.RunStart, objectPool:Get(RunStartMachine))
	self:AddState(EntityMoveSubState.RunStartEnd, objectPool:Get(RunStartEndMachine))
	self:AddState(EntityMoveSubState.Run, objectPool:Get(RunMachine))
	self:AddState(EntityMoveSubState.RunEnd, objectPool:Get(RunEndMachine))
	self:AddState(EntityMoveSubState.Sprint, objectPool:Get(SprintMachine))
	self:AddState(EntityMoveSubState.SprintEnd, objectPool:Get(SprintEndMachine))
	self:AddState(EntityMoveSubState.InjuredWalk, objectPool:Get(InjuredWalkMachine))
	self:AddState(EntityMoveSubState.InjuredWalkEnd, objectPool:Get(InjuredWalkEndMachine))
	for k, v in pairs(self.states) do
		v:Init(self.fight,self.entity,self)
	end
	self:SwitchState(EntityMoveSubState.None)
end

function MoveFSM:LateInit()
	for k, v in pairs(self.states) do
		if v.LateInit then
			v:LateInit()
		end
	end
end

function MoveFSM:StartMove()
	if self.isSprint then
		if self:IsState(EntityMoveSubState.Sprint) then return end
		self:SwitchState(EntityMoveSubState.Sprint)
	elseif self.moveMode == EntityMoveMode.Walk then
		if self:IsState(EntityMoveSubState.Walk) then return end
		self:SwitchState(EntityMoveSubState.Walk)
	elseif self.moveMode == EntityMoveMode.Run then
		if self:IsState(EntityMoveSubState.Run) then return end
		self:SwitchState(EntityMoveSubState.Run)
	elseif self.moveMode == EntityMoveMode.InjuredWalk then
		if self:IsState(EntityMoveSubState.InjuredWalk) then return end
		self:SwitchState(EntityMoveSubState.InjuredWalk)
	end
end

function MoveFSM:StopMove()
	if self.isSprint then
		if self:IsState(EntityMoveSubState.SprintEnd) then return end
		self:SwitchState(EntityMoveSubState.SprintEnd)
	elseif self.moveMode == EntityMoveMode.Walk then
		if self:IsState(EntityMoveSubState.WalkEnd) then return end
		self:SwitchState(EntityMoveSubState.WalkEnd)
	elseif self.moveMode == EntityMoveMode.Run then
		if self:IsState(EntityMoveSubState.RunEnd) then return end
		self:SwitchState(EntityMoveSubState.RunEnd)
	elseif self.moveMode == EntityMoveMode.InjuredWalk then
		if self:IsState(EntityMoveSubState.InjuredWalkEnd) then return end
		self:SwitchState(EntityMoveSubState.InjuredWalkEnd)
	end
end

function MoveFSM:SetMoveType(type)
	self:SwitchState(type)
end

function MoveFSM:SetMoveMode(mode)
	if self.moveMode == mode then return end
	self.moveMode = mode
	
	if self.moveMode == EntityMoveMode.Walk then
		if self:IsState(EntityMoveSubState.RunStart) or self:IsState(EntityMoveSubState.Run) then
			self:SwitchState(EntityMoveSubState.Walk)
		end
	elseif self.moveMode == EntityMoveMode.Run then
		if self:IsState(EntityMoveSubState.Walk) then
			self:SwitchState(EntityMoveSubState.Run)
		end
	elseif self.moveMode == EntityMoveMode.InjuredWalk then
		self.isSprint = false
		if Fight.Instance.operationManager:CheckMove() then
			self:SwitchState(EntityMoveSubState.InjuredWalk)
		end
	end
end

function MoveFSM:SetSprintState(state)
	if self.moveMode == EntityMoveMode.InjuredWalk then return end
	if self.isSprint == state then return end
	self.isSprint = state

	if self.isSprint then
		if self:IsState(EntityMoveSubState.Walk) or self:IsState(EntityMoveSubState.RunStart) 
			or self:IsState(EntityMoveSubState.Run) then
			self:SwitchState(EntityMoveSubState.Sprint)
		end
	elseif self:IsState(EntityMoveSubState.Sprint) then
		if self.moveMode == EntityMoveMode.Walk then
			self:SwitchState(EntityMoveSubState.Walk)
		elseif self.moveMode == EntityMoveMode.Run then
			self:SwitchState(EntityMoveSubState.Run)
		end
	end
end

function MoveFSM:CanMove()
	return true
end

function MoveFSM:CanCastSkill()
	return self.statesMachine:CanCastSkill()
end

function MoveFSM:CanClimb()
	return self.moveMode ~= EntityMoveMode.InjuredWalk
end

function MoveFSM:CanJump()
	return self.statesMachine:CanJump()
end

function MoveFSM:CanChangeRole()
	return true
end

function MoveFSM:Reset()
	self:SwitchState(EntityMoveSubState.None)
end

function MoveFSM:OnCache()
	self:CacheStates()
	self.fight.objectPool:Cache(MoveFSM,self)
end

function MoveFSM:__delete()
end
