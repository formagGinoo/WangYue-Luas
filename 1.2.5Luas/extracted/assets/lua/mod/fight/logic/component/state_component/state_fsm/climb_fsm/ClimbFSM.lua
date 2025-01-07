ClimbFSM = BaseClass("ClimbFSM", FSM)
local ClimbState = FightEnum.EntityClimbState

function ClimbFSM:__init()

end

function ClimbFSM:Init(fight, entity)
	self.fight = fight
	self.entity = entity

	self.climbingRun = false

	self:InitStates()
end

function ClimbFSM:InitStates()
	local objectPool = self.fight.objectPool
	self:AddState(ClimbState.None, objectPool:Get(ClimbNoneMachine))
	self:AddState(ClimbState.StartClimb, objectPool:Get(StartClimbMachine))
	self:AddState(ClimbState.Idle, objectPool:Get(ClimbIdleMachine))
	self:AddState(ClimbState.Climbing, objectPool:Get(ClimbingMachine))
	self:AddState(ClimbState.ClimbingJump, objectPool:Get(ClimbingJumpMachine))
	self:AddState(ClimbState.ClimbingRunStart, objectPool:Get(ClimbingRunStartMachine))
	self:AddState(ClimbState.ClimbingRun, objectPool:Get(ClimbingRunMachine))
	self:AddState(ClimbState.ClimbingRunEnd, objectPool:Get(ClimbingRunEndMachine))
	for k, v in pairs(self.states) do
		v:Init(self.fight, self.entity, self)
	end

	self:SwitchState(ClimbState.None)
end

function ClimbFSM:LateInit()
	for k, v in pairs(self.states) do
		if v.LateInit then
			v:LateInit()
		end
	end
end

function ClimbFSM:Update()
	if not self.statesMachine or self.curState == ClimbState.None then
		return
	end
	
	if self:IsState(ClimbState.Idle) or self:IsState(ClimbState.Climbing) then
		if self.fight.operationManager:CheckJump() then
			local moveVector = self.fight.operationManager:GetMoveEvent()
			if not moveVector or moveVector.y > 0 then
				self:StartJump()
			elseif moveVector and moveVector.y < 0 then
				self.entity.rotateComponent:DoRotate(0, 180, 0) --原地转身
				self.entity.stateComponent:SetState(FightEnum.EntityState.Jump)
				return
			end
		end
		
		if self.fight.operationManager:CheckKeyDown(FightEnum.KeyEvent.LeaveClimb) then
			self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
			return
		end
	end

	self.statesMachine:Update()
end

function ClimbFSM:StartClimb()
	if not (self:IsState(ClimbState.None) or self:IsState(ClimbState.Idle)) then
		return 
	end
	
	self.climbingRun = false
	
	if self.entity.moveComponent.isAloft then
		self.entity.moveComponent.yMoveComponent:OnLand()
		self:SwitchState(ClimbState.Idle)
		return
	end
	
	if self:IsState(ClimbState.Idle) then
		if self.climbingRun then
			self:SwitchState(ClimbState.ClimbingRunStart)
		else
			self:SwitchState(ClimbState.Climbing)
		end
	else
		self:SwitchState(ClimbState.StartClimb)
	end
end

function ClimbFSM:StopClimb()
	if self:IsState(ClimbState.Idle) or self:IsState(ClimbState.StartClimb) or
		self:IsState(ClimbState.ClimbingRunStart) or self:IsState(ClimbState.ClimbingRunEnd) or
		self:IsState(ClimbState.ClimbingJump) then
		return
	end
	
	if self:IsState(ClimbState.ClimbingRun) then
		self:SwitchState(ClimbState.ClimbingRunEnd)
	else
		self:SwitchState(ClimbState.Idle)
	end
	self.climbingRun = false
end

function ClimbFSM:StartJump()
	if not self:IsState(ClimbState.Idle) and not self:IsState(ClimbState.Climbing) then
		return 
	end
	
	self:SwitchState(FightEnum.EntityClimbState.ClimbingJump)
	return true
end

function ClimbFSM:ForceLeaveClimb()
	--if not self:IsState(ClimbState.Idle) and not self:IsState(ClimbState.Climbing) then
		--return 
	--end
	
	self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
end

function ClimbFSM:SetClimbingRun(state)
	if self.climbingRun == state then return end

	self.climbingRun = state

	--if not self.fight.operationManager:CheckMove() then
		--self:SwitchState(SwimState.Idle)
		--return
	--end

	if self:IsState(ClimbState.Climbing) and self.climbingRun then
		self:SwitchState(ClimbState.ClimbingRunStart)
	elseif self:IsState(ClimbState.ClimbingRun) and not self.climbingRun then
		self:SwitchState(ClimbState.ClimbingRunEnd)
	end
end

function ClimbFSM:SetClimbState(state)
	self:SwitchState(state)
end

function ClimbFSM:CanMove()
	return not self:IsState(ClimbState.StartClimb)
end

function ClimbFSM:CanChangeRole()
	if self.statesMachine.CanChangeRole then
		return self.statesMachine:CanChangeRole()
	end

	return false
end

function ClimbFSM:Reset()
	self:SwitchState(ClimbState.None)
	self.entity.logicMove = false
	
	if not self.entity.climbComponent.climbToStrideOver then
		local euler = self.entity.transformComponent:GetRotation():ToEulerAngles()
		local rotation = Quat.Euler(0, euler.y, 0)
		self.entity.transformComponent:SetRotation(rotation)
	end
end

function ClimbFSM:OnLeave()
	self:Reset()
end

function ClimbFSM:OnCache()
	self:CacheStates()
	self.fight.objectPool:Cache(ClimbFSM, self)
end

function ClimbFSM:__delete()

end