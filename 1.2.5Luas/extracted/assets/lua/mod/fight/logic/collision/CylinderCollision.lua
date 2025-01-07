CylinderCollision = BaseClass("CylinderCollision",BaseCollision)

local Vec3 = Vec3
function CylinderCollision:__init()
	self.collisionType = FightEnum.CollisionType.Sphere
	self.tmpHeightVec = Vec3.New()
end

function CylinderCollision:Init(fight,transformComponent,radius,height,offsetX,offsetY,offsetZ)
	self.fight = fight
	self.radius = radius
	self.height = height / 2
	self.transformComponent = transformComponent
	self.primitiveType = PrimitiveType.Cylinder
	self.square = self:GetSquare()
	if offsetX then
		self.offset = Vec3.New(offsetX,offsetY,offsetZ)
	else
		self.offset = Vec3.New(0,0,0)
	end
	
	self.tmpHeightVec:Set(0, self.height, 0)
end

function CylinderCollision:GetSquare()
	return self.height * self.height + self.radius * self.radius
end

function CylinderCollision:Draw(transInfo)
	if not self.fight then
		return
	end

	if not self.cylinderGameObject then
		self.cylinderGameObject = GameObject.CreatePrimitive(PrimitiveType.Cylinder)
		self.cylinderGameObject.transform:SetParent(self.fight.clientFight.colliderRoot.transform)
		self.color = self.color or Color(0.5,0.5,0.5,0.5)
		local collider = self.cylinderGameObject:GetComponent(CapsuleCollider)
		collider.enabled = false
	end

	self.cylinderGameObject:SetActive(true)
	local transform = transInfo and transInfo or self.transformComponent
	local pos = self:GetPosition(transform)
	self.cylinderGameObject.transform.position = pos
	UnityUtils.SetLocalScale(self.cylinderGameObject.transform, self.radius * 2, self.height * 2, self.radius * 2)
	CustomUnityUtils.SetPrimitiveMaterialColor(self.cylinderGameObject, self.color)

	--if self.colliderObj then
		--self.cylinderGameObject.transform.position = self.colliderTransform.position
		--self.cylinderGameObject.transform.rotation = self.colliderTransform.rotation
		--self.cylinderGameObject.transform.localScale = self.colliderTransform.lossyScale 
	--end
end

function CylinderCollision:UpdateColliderSize()
	UnityUtils.SetLocalScale(self.colliderTransform,self.radius * 2, self.height, self.radius * 2)
end

function CylinderCollision:Support(direction,transInfo)
	local transform = transInfo and transInfo or self.transformComponent
	direction = direction:Normalize()
	
	local up = transform.rotation * Vec3.up
	local position = self:GetPosition(transform)
	
	local w = direction - up * Vec3.Dot(up, direction)

	local sign = math.sin(Vec3.Dot(up, direction)) > 0 and 1 or -1
	
	local height = sign * self.height
	local temp = position + up * height;

	if w ~= Vec3.zero then
		return temp + w:Normalize() * self.radius
	else
		return temp
	end
end

function CylinderCollision:GetPosition(transform)
	transform = transform or self.transformComponent
	--if self.createColliderObj and self.colliderObj then
		--return transform.position	
	--end

	local pos = transform.position + transform.rotation * self.offset
	if self.transformComponent and self.transformComponent.GetRealPositionY then
		pos.y = self.transformComponent:GetRealPositionY() + self.offset.y
	end

	return pos
end

function CylinderCollision:GetColliderPoint()
	local position = self:GetPosition()
	local point0 = position - self.tmpHeightVec
	local point1 = position + self.tmpHeightVec
	return point0, point1
end

function CylinderCollision:OverlapCollider(layer)
	layer = layer or -1
	local count = 0
	local point0, point1 = self:GetColliderPoint()
	-- return CustomUnityUtils.OverlapCapsuleCollider(point0, point1, self.radius, layer, count)
	return CustomUnityUtils.OverlapCylinderCollider(point0, point1, self.radius, layer, count)
end

function CylinderCollision:OverlapColliderEntity()
	local point0, point1 = self:GetColliderPoint()
	return CustomUnityUtils.OverlapCapsuleEntity(point0, point1, self.radius, FightEnum.LayerBit.Entity)
end

function CylinderCollision:OverlapColliderNearPos(layer)
	layer = layer or -1
	local point0, point1 = self:GetColliderPoint()
	-- local isHit, hitPointX, hitPointY, hitPointZ = CustomUnityUtils.OverlapCapsuleNonAllocNearPos(point0, point1, self.radius, layer)
	local isHit, hitPointX, hitPointY, hitPointZ = CustomUnityUtils.OverlapCylinderNonAllocNearPos(point0, point1, self.radius, layer)
	return isHit, hitPointX, hitPointY, hitPointZ
end

function CylinderCollision:ChangeRadius(radius)
	self.radius = radius
end

function CylinderCollision:OnCache()
	if self.cylinderGameObject then
		self.cylinderGameObject:SetActive(false)
	end

	if self.colliderObj then
		local entityTrigger = self.colliderObj:GetComponent(EntityTrigger)
		if entityTrigger then
			entityTrigger.enabled = false
		end
		self.colliderObj:SetActive(false)
	end

	self.fight.objectPool:Cache(CylinderCollision,self)
end

function CylinderCollision:__cache()
	self.position = nil
end

function CylinderCollision:__delete()
	if self.cylinderGameObject then
		GameObject.DestroyImmediate(self.cylinderGameObject)
		self.cylinderGameObject = nil
	end

	if self.colliderObj then
		GameObject.DestroyImmediate(self.colliderObj)
		self.colliderObj = nil
	end
end