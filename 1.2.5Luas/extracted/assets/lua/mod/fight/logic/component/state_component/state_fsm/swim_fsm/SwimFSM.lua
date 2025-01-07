SwimFSM = BaseClass("SwimFSM", FSM)
local SwimState = FightEnum.EntitySwimState

function SwimFSM:__init()

end

function SwimFSM:Init(fight, entity)
	self.fight = fight
	self.entity = entity
	self.swimComponent = self.entity.swimComponent

	self.speed = 0
	self.acc = 0
	self.fastSwimming = false
	self.climbInterval = 0.1

	self:InitStates()
end

function SwimFSM:InitStates()
	local objectPool = self.fight.objectPool
	self:AddState(SwimState.None, objectPool:Get(SwimNoneMachine))
	self:AddState(SwimState.Idle, objectPool:Get(SwimIdleMachine))
	self:AddState(SwimState.Swimming, objectPool:Get(SwimmingMachine))
	self:AddState(SwimState.FastSwimming, objectPool:Get(FastSwimmingMachine))
	for k, v in pairs(self.states) do
		v:Init(self.fight, self.entity, self)
	end

	self:SwitchState(SwimState.None)
end

function SwimFSM:LateInit()
	for k, v in pairs(self.states) do
		if v.LateInit then
			v:LateInit()
		end
	end

	self.swimmingSpeed = Config.EntityCommonConfig.SwimParam.SwimmingSpeed
	self.stopSwimmingAcc = Config.EntityCommonConfig.SwimParam.StopSwimmingAcc

	self.fastSwimmingSpeed = Config.EntityCommonConfig.SwimParam.FastSwimmingSpeed
	self.stopFastSwimmingAcc = Config.EntityCommonConfig.SwimParam.StopFastSwimmingAcc
end

function SwimFSM:GetSwimmingSpeed()
	local speed = self.speed
	local acc = self.acc
	if self:IsState(SwimState.Swimming) then
		speed = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.SwimSpeed)
		acc = self.stopSwimmingAcc
	elseif self:IsState(SwimState.FastSwimming) then
		speed = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.FastSwimSpeed)
		acc = self.stopFastSwimmingAcc
	end

	return speed, acc
end

function SwimFSM:Update()
	if not self.statesMachine or self.curState == SwimState.None then
		return
	end

	-- 特效生成位置更新
	self.climbInterval = self.climbInterval - FightUtil.deltaTimeSecond
	self.statesMachine:Update()

	-- 更新位置
	if self.speed <= 0 then return end
	if self.speed > 0 and self:IsState(SwimState.Idle) then
		self.speed = self.speed - self.acc
	end
	self.entity.swimComponent:DoMoveForward(self.speed * FightUtil.deltaTimeSecond)
end

function SwimFSM:StartSwim()
	if self:IsState(SwimState.Swimming) or self:IsState(SwimState.FastSwimming) or self.entity.stateComponent:IsState(FightEnum.EntityState.Death) then
		return
	end

	if not self.swimComponent:CanStartSwim() then
		if not self:IsState(SwimState.Idle) then
			self:SwitchState(SwimState.Idle)
		end
		return
	end

	self.entity.logicMove = true
	self:SetFastSwimming(false)
	if self.fight.operationManager:CheckMove() then
		self:SwitchState(SwimState.Swimming)
		self.speed, self.acc = self:GetSwimmingSpeed()
	else
		self:SwitchState(SwimState.Idle)
	end
end

function SwimFSM:StopSwim()
	if self:IsState(SwimState.Idle) or self:IsState(SwimState.Drowning) then
		return
	end

	self:SetFastSwimming(false)
	self:SwitchState(SwimState.Idle)
end

function SwimFSM:SetFastSwimming(state)
	if self.fastSwimming == state then return end

	self.fastSwimming = state
	self.swimComponent:UpdateRotateSpeed(state)

	if not self.fight.operationManager:CheckMove() then
		self:SwitchState(SwimState.Idle)
		return
	end

	if self:IsState(SwimState.Swimming) and self.fastSwimming then
		self:SwitchState(SwimState.FastSwimming)
		self.speed, self.acc = self:GetSwimmingSpeed()
	elseif self:IsState(SwimState.FastSwimming) and not self.fastSwimming then
		self:SwitchState(SwimState.Swimming)
		self.speed, self.acc = self:GetSwimmingSpeed()
	end
end

function SwimFSM:CanClimb()
	return self.climbInterval < 0
end

function SwimFSM:CanChangeRole()
	return self.statesMachine:CanChangeRole()
end

function SwimFSM:Reset()
	self.acc = 0
	self.speed = 0
	self.climbInterval = 0.1
	self:SwitchState(SwimState.None)
	self.entity.logicMove = false
end

function SwimFSM:OnLeave()
	self:Reset()
end

function SwimFSM:OnCache()
	self:CacheStates()
	self.fight.objectPool:Cache(SwimFSM, self)
end

function SwimFSM:__delete()

end