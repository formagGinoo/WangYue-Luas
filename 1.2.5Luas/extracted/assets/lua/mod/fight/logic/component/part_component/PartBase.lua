PartBase = BaseClass("PartBase",PoolBaseClass)

local AttrType = EntityAttrsConfig.AttrType
local WeakEntityEffectId = 1000000005

function PartBase:__init()
	self.colliderList = {}
end

function PartBase:Init(fight, entity, config)
	self.fight = fight
	self.entity = entity
	self.config = config
	self.clientTransformComponent = self.entity.clientEntity.clientTransformComponent
	-- 暂定部位名称就是影响的节点名称
	self.partName = config.Name
	
	self.layer = FightEnum.Layer.Entity
	self.isTrigger = false
	
	self.enable = true
	self:SetPartEnable(config.DefaultEnable == nil and true or config.DefaultEnable)
	
	self:InitCollider()
end

function PartBase:InitCollider()
	for k, v in pairs(self.config.BoneColliders) do
		self:CreateCollider(v)
	end
end

function PartBase:CreateCollider(config, noBindParent)
	local shapeType = config.ShapeType
	local size = config.LocalScale
	local x, y, z = size[1], size[2], size[3]
	if shapeType == FightEnum.CollisionType.Sphere then
		x = x / 2
	elseif shapeType == FightEnum.CollisionType.Cylinder then
		x = x / 2
		y = y * 2
	end

	local localPosition = config.LocalPosition
	local localOffsetX, localOffsetY, localOffsetZ = localPosition[1], localPosition[2], localPosition[3]
	--这里如果是科学计数形式的数值，如-7.4673e-08，会导致导出的数据变为x,y,z形式，兼容下
	if not localOffsetX then
		localOffsetX, localOffsetY, localOffsetZ = localPosition.x, localPosition.y, localPosition.z
	end

	local parent = not noBindParent and self.clientTransformComponent:GetTransform(config.ParentName)
	local collider = BaseCollider.Create(config.ShapeType, x, y, z, localOffsetX, localOffsetY, localOffsetZ, self.layer, parent, self.entity)
	
	if collider then
		local localEuler = config.LocalEuler
		UnityUtils.SetLocalEulerAngles(collider.colliderTransform, localEuler[1], localEuler[2], localEuler[3])
		
		if self.isTrigger then
			collider:AddTriggerComponent(self.triggerType, self.checkLayer)
		end
	
		table.insert(self.colliderList, collider)
	end
end

function PartBase:SetPartEnable(enable)
	if self.enable == enable then
		return
	end

	self.enable = enable
	for _, collider in ipairs(self.colliderList) do
		collider:SetColliderEnable(enable)
	end
end

function PartBase:Draw(color, enable)
	for k, v in pairs(self.colliderList) do
		v:Draw(color, enable)
	end
end

function PartBase:Update()
	-- UnityUtils.BeginSample("PartBase:UpdateColliderListTransfrom")
	--self:UpdateColliderListTransfrom()
	-- UnityUtils.EndSample()
end

function PartBase:UpdateColliderListTransfrom()
	for _, collider in pairs(self.colliderList) do
		self:UpdateColliderTransform(collider)
	end
end

function PartBase:GetColliderList()
	return self.colliderList
end

function PartBase:UpdateColliderTransform(collider)
	local x, y, z, rx, ry, rz, rw = CustomUnityUtils.GetTransformPosRotation(collider.colliderTransform)
	collider.transformComponent.position:Set(x, y, z)
	collider.transformComponent.rotation:Set(rx, ry, rz, rw)
end

function PartBase:SetCollisionLayer(layer)
	for _, collider in ipairs(self.colliderList) do
		collider:SetColliderLayer(layer)
	end
end

function PartBase:CheckAttachLayer(layer)
	for i = 1, #self.colliderList do
		local id = self.colliderList[i].colliderObjInsId
		if self.entity:CheckTriggerLayer(self.triggerType, layer, id) then
			return true
		end
	end

	return false
end

function PartBase:OnCache()
	for k, v in pairs(self.colliderList) do
		v:OnCache()
	end
	self.colliderList = {}

	self.fight.objectPool:Cache(PartBase, self)
end

function PartBase:DestroyCollider()
	if self.colliderList then
		local entityManager = self.fight.entityManager
		for k, v in pairs(self.colliderList) do
			entityManager:RemoveColliderEntity(v.colliderObjInsId, true)
			v:OnCache()
		end
		TableUtils.ClearTable(self.colliderList)
	end
end

function PartBase:__cache()
	self:DestroyCollider()

	self.fight = nil
	self.entity = nil
end

function PartBase:__delete()

end