BindMoveComponent = BaseClass("BindMoveComponent",PoolBaseClass)

local Vector3 = Vector3

function BindMoveComponent:__init()
end

function BindMoveComponent:Init(moveComponent, moveConfig)
	self.entity = moveComponent.entity
	self.bindRotate = moveConfig.BindRotation
	self.moveComponent = moveComponent
	self.transformComponent = self.moveComponent.transformComponent
	self.bindOffset = Vec3.New(moveConfig.BindOffsetX or 0, moveConfig.BindOffsetY or 0, moveConfig.BindOffsetZ or 0)
	self.moveConfig = moveConfig
	if moveComponent.entity.owner then
		self:SetBindTarget(moveComponent.entity.owner, moveConfig.BindChild)
	end
end

function BindMoveComponent:SetBindTarget(target, bindName)
	self.targetTrans = target.clientEntity.clientTransformComponent:GetTransform(bindName)
	if UtilsBase.IsNull(self.targetTrans) then
		return
	end

	local offset = self.targetTrans.rotation * self.bindOffset
	local position = self.targetTrans.position
	self.transformComponent:SetPosition(position.x + offset.x, position.y + offset.y, position.z + offset.z)
end

function BindMoveComponent:Update()
	if UtilsBase.IsNull(self.targetTrans) then
		if ctx.Editor then
			LogError("BindMoveComponent.targetTrans == Null , entityId = ", self.entity.entityId)
		end
		return
	end

	local targetPosition = self.targetTrans.position
	local targetRotation = self.targetTrans.rotation

	local offset = targetRotation * self.bindOffset
	self.transformComponent.lastPosition:SetA(self.transformComponent.position)
	self.transformComponent.position:Set(targetPosition.x + offset.x , targetPosition.y + offset.y, targetPosition.z + offset.z)

	if self.bindRotate then
		self.transformComponent:SetRotation(targetRotation)
	end
end

function BindMoveComponent:OnCache()
	self.bindPositionOffset = nil
	self.targetTrans = nil
	self.moveComponent.fight.objectPool:Cache(BindMoveComponent,self)
end

function BindMoveComponent:__cache()
end

function BindMoveComponent:__delete()
end