ClimbingMachine = BaseClass("ClimbingMachine",MachineBase)

function ClimbingMachine:__init()

end

function ClimbingMachine:Init(fight,entity,climbFSM)
	self.fight = fight
	self.entity = entity
	self.climbFSM = climbFSM
	
	self.tempVec = Vec3.New()
end

function ClimbingMachine:LateInit()
	if self.entity.clientEntity and self.entity.clientEntity.clientAnimatorComponent then
		self.animator = self.entity.clientEntity.clientAnimatorComponent.animator
	end
	
	--if self.entity.clientEntity and self.entity.clientEntity.clientTransformComponent then
		--self.animatorMove = self.entity.clientEntity.clientTransformComponent.animatorMove
	--end
	
	self.climbComponent = self.entity.climbComponent
end

function ClimbingMachine:OnEnter()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Climbing)
	end
	
	if self.animator then
		--self.animatorMove:GetOffset() --获取一遍清空数据
		self.animator:SetFloat("moveVectorX", 0)
		self.animator:SetFloat("moveVectorY", 1)
	end
end

function ClimbingMachine:Update()
	local moveVector = self.fight.operationManager:GetMoveEvent()
	if not moveVector then 
		return
	end
	
	moveVector = moveVector.normalized
	if self.animator then
		self.animator:SetFloat("moveVectorX", moveVector.x)
		self.animator:SetFloat("moveVectorY", moveVector.y)
		
		--local next = self.animatorMove:GetPosition()
		--self.tempVec:Set(next.x, next.y, next.z)
		--local offset = self.tempVec - self.entity.transformComponent.position
		self.climbComponent:SetForceCheckDirection(moveVector.x, moveVector.y, 0)
		--self.climbComponent:DoMove3(offset)
		--self.entity.transformComponent:SetPositionOffset(offset.x, offset.y, offset.z)
	end
	
	if moveVector.x ~= 0 then
		self.climbComponent:DoMoveRight(moveVector.x * 0.5 * FightUtil.deltaTimeSecond)
	end
	if moveVector.y ~= 0 then
		self.climbComponent:DoMoveUp(moveVector.y * 1 * FightUtil.deltaTimeSecond)
	end
end

function ClimbingMachine:OnLeave()

end

function ClimbingMachine:CanChangeRole()
	return true
end

function ClimbingMachine:OnCache()
	self.fight.objectPool:Cache(ClimbingMachine,self)
end

function ClimbingMachine:__cache()

end

function ClimbingMachine:__delete()

end