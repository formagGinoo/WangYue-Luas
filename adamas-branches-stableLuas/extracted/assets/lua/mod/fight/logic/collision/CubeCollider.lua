CubeCollider = BaseClass("CubeCollider",BaseCollider)

local Vec3 = Vec3
function CubeCollider:__init()
	self.collisionType = FightEnum.CollisionType.Cube
	self.primitiveType = PrimitiveType.Cube
	self.path = "Prefabs/Collider/Cube.prefab"
	self.vertices = {}
end

function CubeCollider:Init(transformComponent, x,y,z,offsetX,offsetY,offsetZ)
	self.offset = Vec3.New(offsetX or 0,offsetY or 0,offsetZ or 0)
	self.transformComponent = transformComponent
	
	self.x = x
	self.y = y
	self.z = z
	--self:InitVertices()
	self:InitRadius()
end

function CubeCollider:UpdateColliderTransform(x, y, z)
	self.x = x or self.x
	self.y = y or self.y
	self.z = z or self.z
	
	self.colliderTransform:ResetAttr()
	UnityUtils.SetLocalScale(self.colliderTransform,self.x, self.y, self.z)
	--CustomUnityUtils.SetBoxColliderSize(self.colliderTransform, self.x, self.y, self.z)
	UnityUtils.SetLocalPosition(self.colliderTransform,self.offset.x,self.offset.y,self.offset.z)
end

function CubeCollider:InitVertices()
	self.vertices[1] = Vec3.New(self.x*0.5,self.y*0.5,self.z*0.5)
	self.vertices[2] = Vec3.New(self.x*0.5,self.y*0.5,self.z*-0.5)
	self.vertices[3] = Vec3.New(self.x*0.5,self.y*-0.5,self.z*0.5)
	self.vertices[4] = Vec3.New(self.x*0.5,self.y*-0.5,self.z*-0.5)
	self.vertices[5] = Vec3.New(self.x*-0.5,self.y*0.5,self.z*0.5)
	self.vertices[6] = Vec3.New(self.x*-0.5,self.y*0.5,self.z*-0.5)
	self.vertices[7] = Vec3.New(self.x*-0.5,self.y*-0.5,self.z*0.5)
	self.vertices[8] = Vec3.New(self.x*-0.5,self.y*-0.5,self.z*-0.5)
end

function CubeCollider:InitRadius()
	local max = self.x
	local max1 = self.y
	local max2 = self.z
	if max > self.y then
		max = self.y
	end
	if max > self.z then
		max = self.z
	end

	self.radius = max * 0.5
	self.height = max
end

function CubeCollider:OverlapCollider(layer, useLogicTransform)
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
		position, rotation = self:GetPosition(), self:GetRotation()
	end
	
	return CustomUnityUtils.OverlapBoxCollider(position, rotation, self.x, self.y, self.z, layer, count)
end

function CubeCollider:OnCache()
	self:BaseFunc("OnCache")
	Fight.Instance.objectPool:Cache(CubeCollider,self)
end

function CubeCollider:__cache()
end