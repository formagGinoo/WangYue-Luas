CylinderCollider = BaseClass("CylinderCollider",BaseCollider)

local Vec3 = Vec3
function CylinderCollider:__init()
	self.collisionType = FightEnum.CollisionType.Cylinder
	self.primitiveType = PrimitiveType.Cylinder
	self.path = "Prefabs/Collider/CylinderMesh.prefab"
	self.tmpHeightVec = Vec3.New()
end

function CylinderCollider:Init(transformComponent, radius,height,temp,offsetX,offsetY,offsetZ)
	self.radius = radius
	self.height = height * 0.5
	self.offset = Vec3.New(offsetX or 0, offsetY or 0, offsetZ or 0)
	self.transformComponent = transformComponent

	self.tmpHeightVec:Set(0, self.height, 0)
end

function CylinderCollider:UpdateColliderTransform(x, y, z)
	self.radius = x or self.radius
	self.height = y or self.height
	
	self.colliderTransform:ResetAttr()
	UnityUtils.SetLocalScale(self.colliderTransform, self.radius * 2, self.height, self.radius * 2)
	--CustomUnityUtils.SetCylinderColliderSize(self.colliderTransform, self.radius, self.height)
	UnityUtils.SetLocalPosition(self.colliderTransform,self.offset.x,self.offset.y,self.offset.z)
end

function CylinderCollider:OverlapCollider(layer, useLogicTransform)
	layer = layer or -1
	local count = 0
	
	local position, rotation
	if useLogicTransform and self.transformComponent then
		position, rotation = self.transformComponent:GetPosition(), self.transformComponent:GetRotation()
		local offset = self.offset * rotation
		position.x = position.x + self.offset.x
		position.y = position.y + self.offset.y
		position.z = position.z + self.offset.z
	else
		position = self:GetPosition()
	end
	
	local point0 = position - self.tmpHeightVec
	local point1 = position + self.tmpHeightVec
	
	return CustomUnityUtils.OverlapCylinderCollider(point0, point1, self.radius, layer, count)
end

function CylinderCollider:OnCache()
	self:BaseFunc("OnCache")
	self.transformComponent = nil
	Fight.Instance.objectPool:Cache(CylinderCollider,self)
end

function CylinderCollider:__cache()
	self.position = nil
end