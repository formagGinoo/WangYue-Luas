BindMoveComponent = BaseClass("BindMoveComponent",PoolBaseClass)

local Vector3 = Vector3

function BindMoveComponent:__init()
end

function BindMoveComponent:Init(moveComponent, moveConfig)
	self.entity = moveComponent.entity
	self.bindRotate = moveConfig.BindRotation
	self.moveComponent = moveComponent
	self.transformComponent = self.moveComponent.transformComponent
	self.bindOffset = Vector3(moveConfig.BindOffsetX or 0, moveConfig.BindOffsetY or 0, moveConfig.BindOffsetZ or 0)
	self.moveConfig = moveConfig
	if moveComponent.entity.parent then
		self:SetBindTarget(moveComponent.entity.parent, moveConfig)
	end
end

function BindMoveComponent:SetBindTarget(target, moveConfig)
	local bindName = moveConfig.BindChild
	local boneName = moveConfig.BindWeaponBoneName
	if moveConfig.IsBindWeapon and boneName ~= "" and self:SetBindWeapon(boneName) then
		return
	end

	self.target = target
	self.targetTrans = target.clientTransformComponent:GetTransform(bindName)
	if UtilsBase.IsNull(self.targetTrans) then
		return
	end

	local tOffset = self.targetTrans.position - self.target.clientTransformComponent.transform.position
	local offset = self.targetTrans.rotation * self.bindOffset
	local tPos = self.target.transformComponent:GetPosition()
	self.transformComponent:SetPosition(tPos.x + tOffset.x + offset.x, tPos.y + tOffset.y + offset.y, tPos.z + tOffset.z + offset.z)
end

function BindMoveComponent:SetBindWeapon(boneName)
	if not self.entity.parent then
		return
	end

	local weaponComponent = self.entity.parent.clientEntity.weaponComponent
	local weapon = weaponComponent:GetWeaponByBindName(boneName)
	self.target = self.entity.parent
	self.targetTrans = weapon.transform
	if UtilsBase.IsNull(self.targetTrans) then return end

	local tOffset = self.targetTrans.position - self.target.clientTransformComponent.transform.position
	local offset = weapon.transform.rotation * self.bindOffset
	local tPos = self.target.transformComponent:GetPosition()
	self.transformComponent:SetPosition(tPos.x + tOffset.x + offset.x, tPos.y + tOffset.y + offset.y, tPos.z + tOffset.z + offset.z)

	return true
end

function BindMoveComponent:Update()

end

function BindMoveComponent:AfterUpdate()
	if UtilsBase.IsNull(self.targetTrans) then
		if ctx.Editor then
			LogError("BindMoveComponent.targetTrans == Null , entityId = ", self.entity.entityId)
		end
		return
	end

	local tOffset = self.targetTrans.position - self.target.clientTransformComponent.transform.position
	local tPos = self.target.transformComponent:GetPosition()
	local targetRotation = self.targetTrans.rotation
	local offset = self.targetTrans.rotation * self.bindOffset


	self.transformComponent.lastPosition:SetA(self.transformComponent.position)
	self.transformComponent.position:Set(tPos.x + tOffset.x + offset.x, tPos.y + tOffset.y + offset.y, tPos.z + tOffset.z + offset.z)

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