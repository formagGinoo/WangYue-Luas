CylinderCollider = BaseClass("CylinderCollider",BaseCollider)

local Vec3 = Vec3
function CylinderCollider:__init()
	self.collisionType = FightEnum.CollisionType.Cylinder
	self.primitiveType = PrimitiveType.Cylinder
	self.path = "Prefabs/Collider/Cylinder.prefab"
	self.tmpHeightVec = Vec3.New()
end

function CylinderCollider:Init(radius,height,temp,offsetX,offsetY,offsetZ)
	self.radius = radius
	self.height = height * 0.5
	self.offset = Vec3.New(offsetX or 0,offsetY or 0,offsetZ or 0)

	self.tmpHeightVec:Set(0, self.height * 0.5, 0)
end

function CylinderCollider:UpdateColliderTransform()
	self.colliderTransform:ResetAttr()
	UnityUtils.SetLocalScale(self.colliderTransform, self.radius * 2, self.height, self.radius * 2)
	UnityUtils.SetLocalPosition(self.colliderTransform,self.offset.x,self.offset.y,self.offset.z)
end

function CylinderCollider:Support(direction,transInfo)
	local transform = transInfo and transInfo or self.colliderTransform
	direction = direction:Normalize()

	local up = transform.rotation * Vec3.up
	local position = transform.position

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

function CylinderCollider:OnCache()
	self:BaseFunc("OnCache")
	Fight.Instance.objectPool:Cache(CylinderCollider,self)
end

function CylinderCollider:__cache()
	self.position = nil
end