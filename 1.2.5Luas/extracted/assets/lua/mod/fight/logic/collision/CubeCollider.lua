CubeCollider = BaseClass("CubeCollider",BaseCollider)

local Vec3 = Vec3
function CubeCollider:__init()
	self.collisionType = FightEnum.CollisionType.Cube
	self.primitiveType = PrimitiveType.Cube
	self.path = "Prefabs/Collider/Cube.prefab"
	self.vertices = {}
end

function CubeCollider:Init(x,y,z,offsetX,offsetY,offsetZ)
	self.offset = Vec3.New(offsetX or 0,offsetY or 0,offsetZ or 0)
	
	self.x = x
	self.y = y
	self.z = z
	self:InitVertices()
	self:InitRadius()
end

function CubeCollider:UpdateColliderTransform()
	self.colliderTransform:ResetAttr()
	UnityUtils.SetLocalScale(self.colliderTransform,self.x, self.y, self.z)
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

function CubeCollider:Support(direction,transInfo)
	local transform = transInfo and transInfo or self.colliderTransform
	local pos = self:GetPosition(transform)
	local world_verts = {}
	local count = #self.vertices
	for i = 1, count do
		local vert = self.vertices[i]
		local world_vert = transform.rotation * vert
		world_vert = world_vert + pos
		table.insert(world_verts,world_vert)
	end
	local best_verts = {}
	local best_dot = math.mininteger

	for i = 1, #world_verts do
		local vert = world_verts[i]
		local dot = Vec3.Dot(vert, direction);
		if dot == best_dot then
			table.insert(best_verts,vert)
		elseif dot > best_dot then
			best_verts = {}
			table.insert(best_verts,vert)
			best_dot = dot;
		end
	end
	return best_verts[1]
end

function CubeCollider:OnCache()
	self:BaseFunc("OnCache")
	Fight.Instance.objectPool:Cache(CubeCollider,self)
end

function CubeCollider:__cache()
end