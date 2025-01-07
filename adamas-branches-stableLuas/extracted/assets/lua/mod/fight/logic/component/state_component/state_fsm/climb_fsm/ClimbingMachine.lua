ClimbingMachine = BaseClass("ClimbingMachine",MachineBase)

function ClimbingMachine:__init()

end

function ClimbingMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM

	self.tempVec = Vec3.New()

	self.isClimb = false
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
end

function ClimbingMachine:LateInit()
	if self.entity.clientEntity and self.entity.clientEntity.clientAnimatorComponent then
		self.animator = self.entity.clientEntity.clientAnimatorComponent.animator
	end

	self.climbComponent = self.entity.climbComponent
end

function ClimbingMachine:OnEnter()
	-- 初始值置0，防止朝向旧方向
	local moveVector = self.fight.operationManager:GetMoveEvent()
	if not moveVector then
		self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
		return
	end

	self.isClimb = true
	self:CalcSpeed()

	moveVector = moveVector.normalized
	self.moveVectorX = moveVector.x or 0
	self.moveVectorY = moveVector.y or 0

	self.entity.climbComponent:SetForceCheckDirection(self.moveVectorX, self.moveVectorY, 0)

	if self.animator then
		self.animator:SetFloat("moveVectorX", self.moveVectorX)
		self.animator:SetFloat("moveVectorY", self.moveVectorY)
	end

	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Climbing)
	end
end

function ClimbingMachine:Update()
	--LogError("ClimbingMachine:Update()"..self.fight.fightFrame)
	local moveVector = self.fight.operationManager:GetMoveEvent()
	if not moveVector then 
		return
	end

	moveVector = moveVector.normalized
	if self.animator then
		self.animator:SetFloat("moveVectorX", moveVector.x)
		self.animator:SetFloat("moveVectorY", moveVector.y)
	
		self.climbComponent:SetForceCheckDirection(moveVector.x, moveVector.y, 0)
	end

	if moveVector.x ~= 0 then
		self.currSpeedX = self.currSpeedX >= self.finalSpeedX and self.finalSpeedX or self.currSpeedX + self.accelerationX
		self.climbComponent:DoMoveRight(moveVector.x * self.currSpeedX * FightUtil.deltaTimeSecond)
	end
	if moveVector.y ~= 0 then
		self.currSpeedY = self.currSpeedY >= self.finalSpeedY and self.finalSpeedY or self.currSpeedY + self.accelerationY
		self.climbComponent:DoMoveUp(moveVector.y * self.currSpeedY * FightUtil.deltaTimeSecond)
	end
end

function ClimbingMachine:EntityAttrChange(attrType, entity, oldValue, newValue)
	if not self.isClimb or self.entity.instanceId ~= entity.instanceId or attrType ~= EntityAttrsConfig.AttrType.ClimbSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function ClimbingMachine:PlayerPropertyChange(attrType, resultValue, oldValue)
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	if not self.isClimb or self.entity.instanceId ~= ctrlId or attrType ~= FightEnum.PlayerAttr.ClimbSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function ClimbingMachine:CalcSpeed()
	-- 速度加成
	local eSpeedYPercent = self.entity.attrComponent and self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.ClimbSpeedPercent) or 0
	self.speedYPercent = eSpeedYPercent + 1
	-- 加速度
	self.accelerationX = 0.1 * self.speedYPercent
	self.accelerationY = 0.2 * self.speedYPercent
	-- 最大速度
	self.finalSpeedX = 0.5 * self.speedYPercent
	self.finalSpeedY = 1 * self.speedYPercent
	-- 初始速度
	self.currSpeedX = self.accelerationX
	self.currSpeedY = self.accelerationY

	self.entity.animatorComponent:SetAnimatorSpeed(self.speedYPercent)
end

function ClimbingMachine:OnLeave()
	self.isClimb = false
	self.entity.animatorComponent:SetAnimatorSpeed(1)
end

function ClimbingMachine:CanChangeRole()
	return true
end

function ClimbingMachine:OnCache()
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
	self.fight.objectPool:Cache(ClimbingMachine,self)
end

function ClimbingMachine:__cache()

end

function ClimbingMachine:__delete()

end