
BaseCollision = BaseClass("BaseCollision",PoolBaseClass)

function BaseCollision:__init()
	self.primitiveType = nil
	self.collisionType = nil
	self.colliderObj = nil
	self.colliderTransform = nil
	self.colliderCmp = nil
	self.radius = 0
end

function BaseCollision:SetDrawColor(r, g, b, a)
	self.color = Color(r, g, b, a)
end

function BaseCollision:GetPosRotation()
	return self:GetPosition(self.transformComponent), self.transformComponent.rotation 
end

function BaseCollision:OverlapCollider(layer)
	Log("error OverlapCollider")
end

function BaseCollision:OverlapColliderEntity(layer)
	Log("error OverlapColliderEntity")
end

function BaseCollision:OverlapColliderNearPos(layer)
	Log("error OverlapColliderNearPos")
end

function BaseCollision:CreateColliderObject(instanceId, layer)
	if UtilsBase.IsNull(self.colliderObj)  then
		self.colliderObj = GameObject.CreatePrimitive(self.primitiveType)
		self.colliderTransform = self.colliderObj.transform
		self.colliderCmp = self.colliderObj:GetComponent(Collider)
		local meshRender = self.colliderObj:GetComponent(MeshRenderer)
		GameObject.Destroy(meshRender)
	else
		self.colliderObj:SetActive(true)
	end

	self:UpdateColliderSize()

	self.colliderObj.name = instanceId
	self.colliderObj.layer = layer
	self.colliderObjInsId = self.colliderObj:GetInstanceID()
	self.createColliderObj = true

	return self.colliderObjInsId
end

function BaseCollision:SetColliderLayer(layer)
	if not UtilsBase.IsNull(self.colliderObj)  then
		self.colliderObj.layer = layer
	end
end

function BaseCollision:AddTriggerCompment()
	local entityTrigger = self.colliderObj:GetComponent(EntityTrigger)
	if entityTrigger then
		entityTrigger.enabled = true
	else
		self.colliderObj:AddComponent(EntityTrigger)
	end
end

function BaseCollision:SetColliderEnable(enable)
	if not UtilsBase.IsNull(self.colliderCmp)  then
		self.colliderCmp.enabled = enable
	end
end