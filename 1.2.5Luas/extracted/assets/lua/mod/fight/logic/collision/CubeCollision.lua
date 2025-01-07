CubeCollision = BaseClass("CubeCollision",BaseCollision)

local Vec3 = Vec3
function CubeCollision:__init()
	self.collisionType = FightEnum.CollisionType.Cube
	self.vertices = {}
end

function CubeCollision:Init(fight,transformComponent,x,y,z,offsetX,offsetY,offsetZ)
	self.fight = fight
	self.transformComponent = transformComponent
	self.primitiveType = PrimitiveType.Cube
	self.x = x
	self.y = y
	self.z = z
	self:SetRadius()
	self.square = self:GetSquare()--球形包围半径的平方，用于初步比较碰撞
	self:InitVertices()
	if offsetX then
		self.offset = Vec3.New(offsetX,offsetY,offsetZ)
	else
		self.offset = Vec3.New(0,0,0)
	end
end

function CubeCollision:GetSquare()
	local min = self.x
	local max1 = self.y
	local max2 = self.z
	if min < self.y then
		min = self.y
		max1 = self.x
		max2 = self.z
	end
	if min < self.z then
		min = self.z
		max1 = self.x
		max2 = self.y
	end
	
	return max1 * max1 + max2 * max2
end

function CubeCollision:SetRadius()
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
end

function CubeCollision:InitVertices()
	self.vertices[1] = Vec3.New(self.x*0.5,self.y*0.5,self.z*0.5)
	self.vertices[2] = Vec3.New(self.x*0.5,self.y*0.5,self.z*-0.5)
	self.vertices[3] = Vec3.New(self.x*0.5,self.y*-0.5,self.z*0.5)
	self.vertices[4] = Vec3.New(self.x*0.5,self.y*-0.5,self.z*-0.5)
	self.vertices[5] = Vec3.New(self.x*-0.5,self.y*0.5,self.z*0.5)
	self.vertices[6] = Vec3.New(self.x*-0.5,self.y*0.5,self.z*-0.5)
	self.vertices[7] = Vec3.New(self.x*-0.5,self.y*-0.5,self.z*0.5)
	self.vertices[8] = Vec3.New(self.x*-0.5,self.y*-0.5,self.z*-0.5)
end

function CubeCollision:Draw(transInfo)
	if not self.cubeGameObject then
		self.cubeGameObject = GameObject.CreatePrimitive(PrimitiveType.Cube)
		self.cubeGameObject.transform:SetParent(self.fight.clientFight.colliderRoot.transform)
		self.color = self.color or Color(0.5,0.5,0.5,0.5)
		local collider = self.cubeGameObject:GetComponent(BoxCollider)
		collider.enabled = false
	end

	self.cubeGameObject:SetActive(true)
	local transform = transInfo or self.transformComponent
	self.cubeGameObject.transform.position = self:GetPosition(transform)
	self.cubeGameObject.transform.rotation = transform.rotation
	UnityUtils.SetLocalScale(self.cubeGameObject.transform, self.x, self.y, self.z)
	CustomUnityUtils.SetPrimitiveMaterialColor(self.cubeGameObject, self.color)

	--if self.colliderObj then
		--self.cubeGameObject.transform.position = self.colliderTransform.position
		--self.cubeGameObject.transform.rotation = self.colliderTransform.rotation
		--self.cubeGameObject.transform.localScale = self.colliderTransform.lossyScale
	--end
	-- if self.colliderObj then
	-- 	self.cubeGameObject.transform.position = self.colliderTransform.position
	-- 	self.cubeGameObject.transform.rotation = self.colliderTransform.rotation
	-- end
end

function CubeCollision:UpdateColliderSize()
	UnityUtils.SetLocalScale(self.colliderTransform,self.x, self.y, self.z)
end

function CubeCollision:Support(direction,transInfo)
	local transform = transInfo and transInfo or self.transformComponent
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

function CubeCollision:GetPosition(transform)
	transform = transform or self.transformComponent
	--if self.createColliderObj and self.colliderObj then
		--return transform.position	
	--end

	local pos = transform.position + transform.rotation * self.offset
	if self.transformComponent and self.transformComponent.GetRealPositionY then
		pos.y = self.transformComponent:GetRealPositionY() + self.offset.y
	end

	return pos
end

function CubeCollision:OverlapCollider(layer)
	layer = layer or -1
	local count = 0
	local position, rotation = self:GetPosRotation()
	return CustomUnityUtils.OverlapBoxCollider(position, rotation, self.x, self.y, self.z, layer, count)
end

function CubeCollision:OverlapColliderEntity()
	local position, rotation = self:GetPosRotation()
	return CustomUnityUtils.OverlapBoxEntity(position, rotation, self.x, self.y, self.z, FightEnum.LayerBit.Entity)
end

function CubeCollision:OverlapColliderNearPos(layer)
	layer = layer or -1
	local position, rotation = self:GetPosRotation()
	local isHit, hitPointX, hitPointY, hitPointZ = CustomUnityUtils.OverlapBoxNonAllocNearPos(position, rotation, self.x, self.y, self.z, layer)
	return isHit, hitPointX, hitPointY, hitPointZ
end
	
function CubeCollision:OnCache()
	if self.cubeGameObject then
		self.cubeGameObject:SetActive(false)
	end

	if self.colliderObj then
		local entityTrigger = self.colliderObj:GetComponent(EntityTrigger)
		if entityTrigger then
			entityTrigger.enabled = false
		end
		self.colliderObj:SetActive(false)
	end

	self.fight.objectPool:Cache(CubeCollision,self)
end

function CubeCollision:__cache()
	self.vertices = {}
end


function CubeCollision:__delete()
	if self.cubeGameObject then
		GameObject.DestroyImmediate(self.cubeGameObject)
		self.cubeGameObject = nil
	end

	if self.colliderObj then
		GameObject.DestroyImmediate(self.colliderObj)
		self.colliderObj = nil
	end
end