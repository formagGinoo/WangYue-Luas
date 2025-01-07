BaseCollider = BaseClass("BaseCollider", PoolBaseClass)

--TODO:先确认用到的地方多不多
BaseCollider.ID_2_CLASS = {}

function BaseCollider.GetClass(shape)
	if shape == FightEnum.CollisionType.Sphere then
		return Fight.Instance.objectPool:Get(SphereCollider)
	elseif shape == FightEnum.CollisionType.Cube then
		return Fight.Instance.objectPool:Get(CubeCollider)
	elseif shape == FightEnum.CollisionType.Cylinder then
		return Fight.Instance.objectPool:Get(CylinderCollider)
	end
end

function BaseCollider.Create(shape, x, y, z, offsetX, offsetY, offsetZ, layer, parent, entity)
	local collider = BaseCollider.GetClass(shape)
	if collider then
		collider:Init(x, y, z, offsetX, offsetY, offsetZ)
		local name = entity and tostring(entity.instanceId)
		local id = collider:CreateColliderObject(name, layer)
		if parent and entity then
			entity.clientEntity.clientTransformComponent:SetTransformChild(collider.colliderTransform, parent.name, collider.colliderObj.name)
			Fight.Instance.entityManager:SetColliderEntity(id, entity.instanceId)
			collider:UpdateColliderTransform()
		elseif parent then
			collider.colliderTransform:SetParent(parent)
			collider:UpdateColliderTransform()
		elseif entity then
			local entityRoot = Fight.Instance.clientFight.clientEntityManager.entityRoot.transform
			collider.colliderTransform:SetParent(entityRoot)
			collider:UpdateColliderTransform()
			Fight.Instance.entityManager:SetColliderEntity(id, entity.instanceId)
			local position = entity.clientEntity.clientTransformComponent:GetTransform().position
			UnityUtils.SetPosition(collider.colliderTransform, position.x + offsetX, position.y + offsetY, position.z + offsetZ)
		end
		
		BaseCollider.ID_2_CLASS[id] = collider
		return collider
	end
end

function BaseCollider:__init()
	self.colliderObj = nil
	self.colliderTransform = nil
	self.colliderCmp = nil
	self.colliderObjInsId = nil
	self.triggerCmp = nil
	
	self.clonePosition = Vec3.New()
	self.cloneRotation = Quat.New()
end

function BaseCollider:CreateColliderObject(name, layer)
	if UtilsBase.IsNull(self.colliderObj)  then
		self.colliderObj = Fight.Instance.clientFight.assetsPool:Get(self.path)
		self.colliderTransform = self.colliderObj.transform
		self.colliderCmp = self.colliderObj:GetComponent(Collider)
		local meshRender = self.colliderObj:GetComponent(MeshRenderer)
		if not UtilsBase.IsNull(meshRender) then
			meshRender.enabled = false
		end
	else
		self.colliderObj:SetActive(true)
	end
	
	self.colliderObjInsId = self.colliderObj:GetInstanceID()
	self.colliderObj.name = name or tostring(self.colliderObjInsId)
	--self.colliderObj.name = string.format("%s_%d[%s]", name, layer, tostring(self.colliderObjInsId))
	self.colliderObj.layer = layer or 0
	
	self.colliderCmp.isTrigger = false
	
	self.triggerCmp = self.colliderObj:GetComponent(EntityTrigger)
	if not self.triggerCmp then
		self.triggerCmp = self.colliderObj:AddComponent(EntityTrigger)
	else
		self.triggerCmp.enabled = true
	end
	self.triggerCmp.TriggerType = 0

	return self.colliderObjInsId
end

function BaseCollider:SetColliderLayer(layer)
	if not UtilsBase.IsNull(self.colliderObj)  then
		self.colliderObj.layer = layer
	end
end

function BaseCollider:AddTriggerComponent(type, checkLayer, fast)
	self.triggerType = type
	self.triggerCmp:SetAsTrigger(type, checkLayer, fast or false)
end

function BaseCollider:ExtraAddCheckTriggerLayer(checkLayer)
	self.triggerCmp:AddCheckLayer(checkLayer)
end

function BaseCollider:SetColliderEnable(enable)
	if not UtilsBase.IsNull(self.colliderCmp)  then
		self.colliderCmp.enabled = enable
	end
end

function BaseCollider:UpdateColliderTransform()
end

function BaseCollider:GetPosition()
	self.clonePosition:SetA(self.colliderTransform.position)
	return self.clonePosition
end

function BaseCollider:GetRotation()
	self.cloneRotation:CopyValue(self.colliderTransform.rotation)
	return self.cloneRotation
end

local DrawColor = Color(0.5, 0.5, 0.5, 0.5)
function BaseCollider:Draw(color, enable)
	if enable then
		color = color or DrawColor
		local meshRender = self.colliderObj:GetComponent(MeshRenderer)
		if UtilsBase.IsNull(meshRender) then
			meshRender = self.colliderObj:AddComponent(MeshRenderer)
		end
		meshRender.enabled = true
		CustomUnityUtils.SetPrimitiveMaterialColor(self.colliderObj, color)
	else
		local meshRender = self.colliderObj:GetComponent(MeshRenderer)
		meshRender.enabled = false
	end
end

function BaseCollider:OnCache()
	BaseCollider.ID_2_CLASS[self.colliderObjInsId] = nil

	if self.colliderObj then
		Fight.Instance.clientFight.assetsPool:Cache(self.path, self.colliderObj)
	end

	self.colliderObj = nil
	self.colliderTransform = nil
	self.colliderCmp = nil
	self.colliderObjInsId = nil
	
	if self.triggerCmp then
		self.triggerCmp.enabled = false
	end
	
	self.triggerCmp = nil
end

function BaseCollider:__delete()
	if self.colliderObjInsId then
		BaseCollider.ID_2_CLASS[self.colliderObjInsId] = nil
	end

	if self.colliderObj then
		GameObject.DestroyImmediate(self.colliderObj)
		self.colliderObj = nil
	end
end