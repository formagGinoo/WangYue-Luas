SphereCollision = BaseClass("SphereCollision",BaseCollision)

function SphereCollision:__init()
	self.collisionType = FightEnum.CollisionType.Sphere
end

function SphereCollision:Init(fight,transformComponent,radius,offsetX,offsetY,offsetZ)
	self.fight = fight
	self.radius = radius
	self.transformComponent = transformComponent
	self.primitiveType = PrimitiveType.Sphere
	self.square = self:GetSquare()
	if offsetX then
		self.offset = Vec3.New(offsetX,offsetY,offsetZ)
	else
		self.offset = Vec3.New(0,0,0)
	end
end

function SphereCollision:Draw(transInfo)
	if not self.fight then
		return
	end

	if not self.sphereGameObject then
		self.sphereGameObject = GameObject.CreatePrimitive(PrimitiveType.Sphere)
		self.sphereGameObject.transform:SetParent(self.fight.clientFight.colliderRoot.transform)
		self.color = self.color or Color(0.5,0.5,0.5,0.5)
		local collider = self.sphereGameObject:GetComponent(Collider)
		collider.enabled = false
	end

	self.sphereGameObject:SetActive(true)
	local transform = transInfo and transInfo or self.transformComponent
	self.sphereGameObject.transform.position = self:GetPosition(transform)
	local scale = self.radius*2
	UnityUtils.SetLocalScale(self.sphereGameObject.transform, scale, scale, scale)
	CustomUnityUtils.SetPrimitiveMaterialColor(self.sphereGameObject, self.color)

	--if self.colliderObj then
		--self.sphereGameObject.transform.position = self.colliderTransform.position
		--self.sphereGameObject.transform.rotation = self.colliderTransform.rotation
		--self.sphereGameObject.transform.localScale = self.colliderTransform.lossyScale 
	--end
end

function SphereCollision:UpdateColliderSize()
	local scale = self.radius*2
	UnityUtils.SetLocalScale(self.colliderTransform,scale,scale,scale)
end

function SphereCollision:GetSquare()
	return self.radius * self.radius
end

function SphereCollision:Support(direction,transInfo)
	local transform = transInfo and transInfo or self.transformComponent
	return self:GetPosition(transform) + direction:Normalize() * self.radius
end

function SphereCollision:GetPosition(transform)
	transform = transform or self.transformComponent
	--if self.createColliderObj and self.colliderObj then
		--return transform.position	
	--end

	transform = transform or self.transformComponent
	local pos = transform.position + transform.rotation * self.offset
	if self.transformComponent and self.transformComponent.GetRealPositionY then
		pos.y = self.transformComponent:GetRealPositionY() + self.offset.y
	end

	return pos
end

function SphereCollision:OverlapCollider(layer)
	layer = layer or -1
	local count = 0
	local position, rotation = self:GetPosRotation()
	return CustomUnityUtils.OverlapSphereCollider(position, self.radius, layer, count)
end

function SphereCollision:OverlapColliderEntity()
	local position, rotation = self:GetPosRotation()
	return CustomUnityUtils.OverlapSphereEntity(position, self.radius, FightEnum.LayerBit.Entity)
end


function SphereCollision:OverlapColliderNearPos(layer)
	layer = layer or -1
	local position, rotation = self:GetPosRotation()
	local isHit, hitPointX, hitPointY, hitPointZ = CustomUnityUtils.OverlapSphereNonAllocNearPos(position, self.radius, layer)
	return isHit, hitPointX, hitPointY, hitPointZ
end
	

function SphereCollision:OnCache()
	if self.sphereGameObject then
		self.sphereGameObject:SetActive(false)
	end

	if self.colliderObj then
		local entityTrigger = self.colliderObj:GetComponent(EntityTrigger)
		if entityTrigger then
			entityTrigger.enabled = false
		end
		self.colliderObj:SetActive(false)
	end

	self.fight.objectPool:Cache(SphereCollision,self)
end

function SphereCollision:__cache()
	self.position = nil
end

function SphereCollision:__delete()
	if self.sphereGameObject then
		GameObject.DestroyImmediate(self.sphereGameObject)
		self.sphereGameObject = nil
	end

	if self.colliderObj then
		GameObject.DestroyImmediate(self.colliderObj)
		self.colliderObj = nil
	end
end