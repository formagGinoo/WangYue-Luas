SectorCollider = BaseClass("SectorCollider", BaseCollider)

local Vec3 = Vec3
function SectorCollider:__init()
	self.collisionType = FightEnum.CollisionType.Sector
	-- self.primitiveType = PrimitiveType.Cube
	self.path = "Prefabs/Collider/Sector.prefab"
	self.tmpHeightVec = Vec3.New()
end

function SectorCollider:Init(transformComponent, radius, height, angle, offsetX, offsetY, offsetZ)
	self.radius = radius
	self.height = height
	self.angle = angle
	self.offset = Vec3.New(offsetX or 0, offsetY or 0, offsetZ or 0)
	self.transformComponent = transformComponent

	self.tmpHeightVec:Set(0, self.height, 0)
	self.hadDrawMesh = false
end

function SectorCollider:UpdateColliderTransform()
	self.colliderTransform:ResetAttr()

	UnityUtils.SetLocalScale(self.colliderTransform, self.radius * 2, self.height * 0.5, self.radius * 2)
	UnityUtils.SetLocalPosition(self.colliderTransform, self.offset.x, self.offset.y, self.offset.z)
end

function SectorCollider:Support(direction,transInfo)
	local transform = transInfo and transInfo or self.transformComponent
	return self:GetPosition(transform) + direction:Normalize() * self.radius
end

local DrawColor = Color(0.5, 0.5, 0.5, 0.5)
function SectorCollider:Draw(color, enable)
	if enable then
		self.sectorChild = self.sectorChild or self.colliderObj.transform:GetChild(0).gameObject
		color = color or DrawColor

		local meshRender = self.sectorChild:GetComponent(MeshRenderer)
		if UtilsBase.IsNull(meshRender) then
			meshRender = self.sectorChild:AddComponent(MeshRenderer)
		end
		CustomUnityUtils.SetPrimitiveMaterialColor(self.sectorChild, color)
		meshRender.enabled = true
		if not self.hadDrawMesh then
			local sectorMeshCreateUtils = self.sectorChild:GetComponent(SectorMeshCreateUtils)
			sectorMeshCreateUtils:SetSectorMeshParam(0.5, self.height, -self.angle/2, self.angle/2)
			self.hadDrawMesh = true
		end
	else
		if self.sectorChild then
			local meshRender = self.sectorChild:GetComponent(MeshRenderer)
			if meshRender then
				meshRender.enabled = false
			end
			self.sectorChild = nil
		end
	end
end

function SectorCollider:OverlapCollider(layer, useLogicTransform)
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

	local startEuler = self.transformComponent.rotation:ToEulerAngles()
	local point2 = point0 + Vec3.New(0, 0, self.radius) * Quat.Euler(0,startEuler.y - self.angle/2, 0)
	local point3 = point0 + Vec3.New(0, 0, self.radius) * Quat.Euler(0,startEuler.y + self.angle/2, 0)

	return CustomUnityUtils.OverlapSectorCollider(point0, point1, point2, point3, self.radius, layer, count)
end

function SectorCollider:OnCache()
	self:BaseFunc("OnCache")
	Fight.Instance.objectPool:Cache(SectorCollider, self)
end

function SectorCollider:__cache()
end