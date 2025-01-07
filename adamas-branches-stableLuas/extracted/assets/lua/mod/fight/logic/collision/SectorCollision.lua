SectorCollision = BaseClass("SectorCollision", BaseCollision)

function SectorCollision:__init()
	self.collisionType = FightEnum.CollisionType.Sector
end

function SectorCollision:Init(fight, transformComponent, radius, height, angle, offsetX, offsetY, offsetZ)
	self.fight = fight
	self.radius = radius
    self.height = height
    self.angle = angle

	self.transformComponent = transformComponent
	self.primitiveType = PrimitiveType.Cube
	self.square = self:GetSquare()
	if offsetX then
		self.offset = Vec3.New(offsetX, offsetY, offsetZ)
	else
		self.offset = Vec3.New(0, 0, 0)
	end
end

function SectorCollision:Draw(transInfo)
    -- 暂时不知道怎么画扇形
    if not self.sectorGameObject then
		self.sectorGameObject = self.transformComponent
	end
	--
	--self.cubeGameObject:SetActive(true)
	--local transform = transInfo or self.transformComponent
	--self.cubeGameObject.transform.position = self:GetPosition(transform)
	--self.cubeGameObject.transform.rotation = transform.rotation
	--UnityUtils.SetLocalScale(self.cubeGameObject.transform, self.radius * 2, self.height, self.radius * 2)
	--CustomUnityUtils.SetPrimitiveMaterialColor(self.cubeGameObject, self.color)
end

function SectorCollision:UpdateColliderSize()
	UnityUtils.SetLocalScale(self.colliderTransform, self.radius * 2, self.height, self.radius * 2)
	--CustomUnityUtils.SetBoxColliderSize(self.colliderTransform, self.radius * 2, self.height, self.radius * 2)
end

function SectorCollision:GetSquare()
	return self.radius * self.radius * (self.angle / 360) * math.pi
end

function SectorCollision:Support(direction,transInfo)
	local transform = transInfo and transInfo or self.transformComponent
	return self:GetPosition(transform) + direction:Normalize() * self.radius
end

function SectorCollision:GetPosition(transform)
	transform = transform or self.transformComponent
	local pos = transform.position + transform.rotation * self.offset
	if self.transformComponent and self.transformComponent.GetRealPositionY then
		pos.y = self.transformComponent:GetRealPositionY() + self.offset.y
	end

	return pos
end

function SectorCollision:OverlapCollider(layer)
	layer = layer or -1
	local count = 0
	local position, rotation = self:GetPosRotation()
	return CustomUnityUtils.OverlapBoxCollider(position, rotation, self.radius * 2, self.height, self.radius * 2, layer, count)
end

function SectorCollision:OverlapColliderEntity()
	local position, rotation = self:GetPosRotation()
	return CustomUnityUtils.OverlapBoxEntity(position, rotation, self.radius * 2, self.height, self.radius * 2, FightEnum.LayerBit.Entity)
end

function SectorCollision:OverlapColliderNearPos(layer)
	layer = layer or -1
	local position, rotation = self:GetPosRotation()
	local isHit, hitPointX, hitPointY, hitPointZ = CustomUnityUtils.OverlapBoxNonAllocNearPos(position, rotation, self.radius * 2, self.height, self.radius * 2, layer)
	return isHit, hitPointX, hitPointY, hitPointZ
end

function SectorCollision:OnCache()
    if self.cubeGameObject then
		self.cubeGameObject:SetActive(false)
	end

	if self.colliderObj then
		local entityTrigger = self.colliderObj:GetComponent(EntityTrigger)
		if entityTrigger then
			entityTrigger.enabled = false
		end
		self.colliderObj:SetActive(false)
	end

	self.fight.objectPool:Cache(SectorCollision,self)
end

function SectorCollision:__cache()
	self.position = nil
end

function SectorCollision:__delete()
    if self.cubeGameObject then
		GameObject.DestroyImmediate(self.cubeGameObject)
		self.cubeGameObject = nil
	end

	if self.colliderObj then
		GameObject.DestroyImmediate(self.colliderObj)
		self.colliderObj = nil
	end
end