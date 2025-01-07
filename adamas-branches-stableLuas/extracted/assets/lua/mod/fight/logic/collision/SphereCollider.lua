SphereCollider = BaseClass("SphereCollider",BaseCollider)

function SphereCollider:__init()
	self.collisionType = FightEnum.CollisionType.Sphere
	self.primitiveType = PrimitiveType.Sphere
	self.path = "Prefabs/Collider/Sphere.prefab"
end

function SphereCollider:Init(transformComponent, radius,temp1,temp2,offsetX,offsetY,offsetZ)
	self.radius = radius
	self.offset = Vec3.New(offsetX or 0,offsetY or 0,offsetZ or 0)
	self.transformComponent = transformComponent
end

function SphereCollider:UpdateColliderTransform(x, y, z)
	self.radius = x or self.radius
	
	local scale = self.radius * 2
	self.colliderTransform:ResetAttr()
	UnityUtils.SetLocalScale(self.colliderTransform,scale,scale,scale)
	UnityUtils.SetLocalPosition(self.colliderTransform,self.offset.x,self.offset.y,self.offset.z)
end

function SphereCollider:OverlapCollider(layer, useLogicTransform)
	layer = layer or -1
	local count = 0
	local position, rotation
	if useLogicTransform and self.transformComponent then
		position, rotation = self.transformComponent:GetPosition(), self.transformComponent:GetRotation()
		local offset = self.offset * rotation
		position.x = position.x + offset.x
		position.y = position.y + offset.y
		position.z = position.z + offset.z
	else
		position = self:GetPosition()
	end

	return CustomUnityUtils.OverlapSphereCollider(position, self.radius, layer, count)
end

function SphereCollider:OnCache()
	self:BaseFunc("OnCache")
	self.transformComponent = nil
	Fight.Instance.objectPool:Cache(SphereCollider,self)
end

function SphereCollider:__cache()
end