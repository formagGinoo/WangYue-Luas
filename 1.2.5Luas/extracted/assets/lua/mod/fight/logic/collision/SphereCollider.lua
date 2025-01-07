SphereCollider = BaseClass("SphereCollider",BaseCollider)

function SphereCollider:__init()
	self.collisionType = FightEnum.CollisionType.Sphere
	self.primitiveType = PrimitiveType.Sphere
	self.path = "Prefabs/Collider/Sphere.prefab"
end

function SphereCollider:Init(radius,temp1,temp2,offsetX,offsetY,offsetZ)
	self.radius = radius
	self.offset = Vec3.New(offsetX or 0,offsetY or 0,offsetZ or 0)
end

function SphereCollider:UpdateColliderTransform()
	local scale = self.radius * 2
	self.colliderTransform:ResetAttr()
	UnityUtils.SetLocalScale(self.colliderTransform,scale,scale,scale)
	UnityUtils.SetLocalPosition(self.colliderTransform,self.offset.x,self.offset.y,self.offset.z)
end

function SphereCollider:Support(direction,transInfo)
	local transform = transInfo and transInfo or self.colliderTransform
	return transform.position + direction:Normalize() * self.radius
end

function SphereCollider:OnCache()
	self:BaseFunc("OnCache")
	Fight.Instance.objectPool:Cache(SphereCollider,self)
end

function SphereCollider:__cache()
end