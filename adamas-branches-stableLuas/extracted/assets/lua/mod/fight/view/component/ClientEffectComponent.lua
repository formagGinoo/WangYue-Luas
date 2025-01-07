---@class ClientEffectComponent
ClientEffectComponent = BaseClass("ClientEffectComponent",PoolBaseClass)
local Vec3 = Vec3
local Quat = Quat

function ClientEffectComponent:__init()

end

-- 只需计算关注坐标，同步信息
function ClientEffectComponent:Init(clientFight, clientEntity)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	self.entity = clientEntity.entity
	self.config = self.entity:GetComponentConfig(FightEnum.ComponentType.Effect)
	self.time = 0
end

function ClientEffectComponent:LateInit()
	self.clientTransformComponent = self.clientEntity.clientTransformComponent
	self:SetBindTransform()
	self.clientTransformComponent:InitEffectUtil()

	self.mpap = self.clientTransformComponent.gameObject:GetComponent(MaterialPropertyAgentParticle)
end

function ClientEffectComponent:SetBindTransform(hitTransform)
	local bindName = hitTransform or self.config.BindTransformName
	
	local bindPositionTime = self.config.BindPositionTime or -1
	local bindRotationTime = self.config.BindRotationTime or -1

	self.clientTransformComponent:SetBindTransform(bindName, self.config.IsBind, self.config.IsHang, self.config.BindOffset,
	self.config.ScaleOffset, bindPositionTime, bindRotationTime, nil, self.config.IsBindWeapon, self.config.WeaponBindTransformName)
end

function ClientEffectComponent:ResetBindTransform(targetEntity,bindName)
	local bindPositionTime = self.config.BindPositionTime or -1
	local bindRotationTime = self.config.BindRotationTime or -1
	
	self.clientTransformComponent:SetBindTransform(bindName, self.config.IsBind, self.config.IsHang, self.config.BindOffset,
		self.config.ScaleOffset, bindPositionTime, bindRotationTime,targetEntity)
end

function ClientEffectComponent:CalculateHitOffsetY(targetPosY)
	local offsetY
	local partHeight
	local partPos
	local CenterY
	if self.config.IsHeightLimit then
		if self.entity.parent.tagComponent.partTag == FightEnum.PartTag.Single then
			partPos = self.entity.parent.transformComponent.position
			partHeight = self.part.entity.collistionComponent.height
			CenterY = partPos.y + partHeight / 2
		elseif self.entity.parent.tagComponent.partTag == FightEnum.PartTag.Plural then
			partPos = self.collisionAttacked.transformComponent.position
			partHeight = self.collisionAttacked.radius
			CenterY = partPos.y
		end
		offsetY = targetPosY - CenterY
		if math.abs(offsetY) > partHeight / 2 then
			offsetY = (partHeight / 2) * (offsetY < 0 and -1 or 1)
		end
		targetPosY = CenterY + offsetY
	end

	return targetPosY
end

function ClientEffectComponent:SetHitPart(part, collisionAttacked, position, lookEntity)
	self.part = part
	self.collisionAttacked = collisionAttacked
	if self.config.HitEffectBornType == FightEnum.HitEffectBornType.Bone then
		self:SetBindTransform(self.part.hitTransformName)
		return
	elseif self.config.HitEffectBornType == FightEnum.HitEffectBornType.HitPos then
		local offsetY = self:CalculateHitOffsetY(position.y)
		self.clientEntity.clientTransformComponent:SetForceLocation(position.x, offsetY, position.z)
	elseif self.config.HitEffectBornType == FightEnum.HitEffectBornType.HitOffset then
		local offsetY = self:CalculateHitOffsetY(position.y + self.config.HitEffectOffsetY)
		local partPos
		if self.entity.parent.tagComponent.partTag == FightEnum.PartTag.Single then
			partPos = self.entity.parent.transformComponent.position
		elseif self.entity.parent.tagComponent.partTag == FightEnum.PartTag.Plural then
			partPos = self.collisionAttacked.transformComponent.position
		end

		self.clientEntity.clientTransformComponent:SetForceLocation(partPos.x, offsetY, partPos.z)
		--设置朝向
	end

	if lookEntity then
		local pos1 = lookEntity.transformComponent.position
		local pos2 = position
		local x = pos1.x - pos2.x
		local z = pos1.z - pos2.z
		local rotate = Quat.LookRotationA(x,0,z)
		rotate = rotate * Quat.AngleAxis(90, Quat.Euler(0, 1, 0))
		self.clientEntity.entity.rotateComponent:SetRotation(rotate:Normalize())
	end
end

-- MPAP = MaterialPropertyAgentParticle
function ClientEffectComponent:SetMPAPValue(name, value1, value2, value3, value4)
	if UtilsBase.IsNull(self.mpap) or not name then
		return
	end

	value1 = value1 or -99999
	value2 = value2 or -99999
	value3 = value3 or -99999
	value4 = value4 or -99999

	self.mpap:SetPropertyValue(name, value1, value2, value3, value4)
end

function ClientEffectComponent:OnCache()
	self.entity = nil
	self.part  = nil
	self.collisionAttacked  = nil
	self.mpap = nil
	self.clientFight.fight.objectPool:Cache(ClientEffectComponent, self)
end

function ClientEffectComponent:__cache()
end

function ClientEffectComponent:__delete()
end