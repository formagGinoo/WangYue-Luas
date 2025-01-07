---@class HandleMoveInputComponent
HandleMoveInputComponent = BaseClass("HandleMoveInputComponent",PoolBaseClass)

function HandleMoveInputComponent:__init()
end

function HandleMoveInputComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.stateComponent = self.entity.stateComponent
	self.rotateComponent = self.entity.rotateComponent

	self.enabled = false
end

function HandleMoveInputComponent:Update()
	if self.entity.stateComponent.backstage == FightEnum.Backstage.Background then
		return
	end
	if not self.enabled then
		return
	end
	
	local moveEvent = self.fight.operationManager:GetMoveEvent()
	if moveEvent then
		if self.stateComponent:CanMove() then
			if self.stateComponent:IsState(FightEnum.EntityState.Swim) then
				self.rotateComponent:SetVector(moveEvent.x,moveEvent.y)
				self.stateComponent:StartSwim()
			elseif self.stateComponent:IsState(FightEnum.EntityState.Climb) then
				self.stateComponent:StartClimb()
			else
				self.rotateComponent:SetVector(moveEvent.x,moveEvent.y)
				self.stateComponent:StartMove()
			end
		else
			self.rotateComponent.rotateTo = nil
		end
	else
		if self.lastMoveEvent then
			if self.stateComponent:IsState(FightEnum.EntityState.Swim) then
				self.stateComponent:StopSwim()
			elseif self.stateComponent:IsState(FightEnum.EntityState.Climb) then
				self.stateComponent:StopClimb()
			else
				self.stateComponent:StopMove()
				BehaviorFunctions.ResetTimeAutoFixTime(false)
			end
		end
	end
	self.lastMoveEvent = moveEvent
end

function HandleMoveInputComponent:UpdateEnable(isEnabled, priority, stopControl)
	priority = priority or 1
	
	local cPriority = priority
	local cEnable = isEnabled
	
	self.priorityEnable = self.priorityEnable or {}
	if stopControl then
		self.priorityEnable[priority] = nil
		cPriority = -9999
		if cEnable == nil then cEnable = true end
	else
		self.priorityEnable[priority] = isEnabled
	end

	for p, v in pairs(self.priorityEnable) do
		if cPriority < p then
			cPriority = p
			cEnable = v
		end
	end
	
	return cEnable
end

function HandleMoveInputComponent:SetEnabled(isEnabled, priority, stopControl)
	local oldEnable = self.enabled
	self.enabled = self:UpdateEnable(isEnabled, priority, stopControl)
	
	if oldEnable and not self.enabled then
		if self.stateComponent:IsState(FightEnum.EntityState.Swim) then
			self.stateComponent:StopSwim()
		elseif self.stateComponent:IsState(FightEnum.EntityState.Climb) then
			self.stateComponent:StopClimb()
		else
			self.stateComponent:StopMove()

			BehaviorFunctions.ResetTimeAutoFixTime(false)
		end
	end
end

function HandleMoveInputComponent:OnCache()
	self.fight.objectPool:Cache(HandleMoveInputComponent,self)
end

function HandleMoveInputComponent:__cache()
	self.fight = nil
	self.entity = nil
end

function HandleMoveInputComponent:__delete()
end
