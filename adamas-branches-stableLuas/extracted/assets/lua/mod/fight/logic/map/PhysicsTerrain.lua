---@class PhysicsTerrain
PhysicsTerrain = BaseClass("PhysicsTerrain")

PhysicsTerrain.TerrainCheckLayer = ~(FightEnum.LayerBit.IgnoreRayCastLayer | FightEnum.LayerBit.Water |
									 FightEnum.LayerBit.Area | FightEnum.LayerBit.Entity |
									 FightEnum.LayerBit.Marsh | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.InRoom)

local RayCastLayer = CS.PhysicsTerrain.RayCastLayer
local MovePlatformLayer = FightEnum.LayerBit.AirWall | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Entity

function PhysicsTerrain:__init(fight)
	self.tmpColliderOffset = Vec3.New()
	self.tmpColliderVector = Vec3.New()
	self.tmpTargetPos = Vec3.New()
	self.fight = fight

	self.tmpVec = Vec3.New()
	self.tmpDir = Vec3.New()

	self.climbEnable = true
end

-- region 攀爬

function PhysicsTerrain:SetClimbEnable(enable)
	self.climbEnable = enable
end

function PhysicsTerrain:ClimbEnable(entity)
	if not self.climbEnable then
		return false
	end

	if not entity.climbComponent then
		return false
	end

	--摇杆方向与前向移动方向检测
	local moveEvent = self.fight.operationManager:GetMoveEvent()
	if not moveEvent then
		return false
	end

	local forward = entity.transformComponent.rotation * Vec3.forward
	if math.abs(forward.x - moveEvent.x) > 0.5 or math.abs(forward.z - moveEvent.y) > 0.5 then
		return false
	end

	return true
end

function PhysicsTerrain:Climb(entity, offset)
	local entityLayer = entity.collistionComponent.layer
	local height = entity.climbComponent:GetClimbCharacterHeight()
	local radius = entity.climbComponent:GetClimbCapsuleRadius()
	local origin = entity.transformComponent:GetPosition()
	local rotation = entity.transformComponent:GetRotation()
	local forward = rotation * Vec3.forward;
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)

	local resultType, offsetX, offsetY, offsetZ, dirX, dirY, dirZ = CS.PhysicsTerrain.PhysClimbing(origin, rotation, radius, height, offset.x, offset.y, offset.z,
			forward.x, forward.y, forward.z)

	self.tmpVec:Set(offsetX, offsetY, offsetZ)
	self.tmpDir:Set(dirX, dirY, dirZ)

	entity.collistionComponent:SetCollisionLayer(entityLayer)

	return resultType, self.tmpVec:Clone(), self.tmpDir:Clone()
end

function PhysicsTerrain:TryClimbToLedge(entity, animationYOffset, offset)
	local origin = entity.transformComponent:GetPosition()
	local rotation = entity.transformComponent:GetRotation()
	local height = entity.climbComponent:GetClimbCharacterHeight()
	local radius = entity.climbComponent:GetClimbCapsuleRadius()
	
	local result, offsetX, offsetY, offsetZ = CS.PhysicsTerrain.TryClimbToLedge(origin, rotation, radius, height, animationYOffset, offset.x, offset.y, offset.z)
	self.tmpVec:Set(offsetX, offsetY, offsetZ)
	
	return result, self.tmpVec:Clone()
end

-- 攀越
function PhysicsTerrain:StrideOver(entity, heightOffset)
	local canStrideOver, toPos, strideOverY, strideOverZ = false, Vector3.zero, 0, 0
	local height = entity.climbComponent:GetClimbCharacterHeight()
	local radius = entity.climbComponent:GetClimbCapsuleRadius()
	local isAloft = entity.moveComponent.isAloft
	local heightCheck = heightOffset or (isAloft and height * 0.8 or height * 0.5)
	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)

	local origin = entity.transformComponent:GetPosition()
	local rotation = entity.transformComponent:GetRotation()
	canStrideOver, toPos, strideOverY, strideOverZ = CS.PhysicsTerrain.StrideOverCheck(origin, rotation, toPos, height, radius, heightCheck, strideOverY, strideOverZ)

	entity.collistionComponent:SetCollisionLayer(entityLayer)

	return canStrideOver, toPos, strideOverY, strideOverZ
end

-- 废弃
function PhysicsTerrain:UpdateClimbRotAndPos(entity, heightCheck)
	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)
	local height = entity.climbComponent:GetClimbCharacterHeight()
	local radius = entity.climbComponent:GetClimbCapsuleRadius()
	heightCheck = heightCheck or 0
	local origin = entity.transformComponent:GetPosition()
	local rotation = entity.transformComponent:GetRotation()

	local dir, offsetPos, targetDir = Vector3.zero, Vector3.zero, Vector3.zero
	dir, offsetPos = CS.PhysicsTerrain.UpdateClimbRotAndPos(origin,rotation,radius,height,heightCheck,offsetPos,targetDir)
	entity.collistionComponent:SetCollisionLayer(entityLayer)
	
	return Vec3.New(dir.x, dir.y, dir.z), Vec3.New(offsetPos.x, offsetPos.y, offsetPos.z), Vec3.New(targetDir.x, targetDir.y, targetDir.z)
end

function PhysicsTerrain:GetClimbingSurfaceNormal(entity, offset)
	local origin = entity.transformComponent:GetPosition()
	local rotation = entity.transformComponent:GetRotation()
	local height = entity.climbComponent:GetClimbCharacterHeight()
	local radius = entity.climbComponent:GetClimbCapsuleRadius()
	
	self.tmpVec:Set(offset.x, offset.y, 0)
	
	local surfaceNormal = CS.PhysicsTerrain.GetClimbingSurfaceNormal(origin, rotation, self.tmpVec, height, 4 * radius)
	
	return Vec3.New(surfaceNormal.x, surfaceNormal.y, surfaceNormal.z)
end

-- endRegion

function PhysicsTerrain:Move(position, x, y, z, entity, haveCollistion, checkGroundRadius, stickWithTerrain, isLerpY)
	local toPosX = position.x + x
	local toPosY = position.y + y
	local toPosZ = position.z + z

	local radius = entity.collistionComponent.worldRadius
	local height = entity.collistionComponent.height
	
	if entity.clientTransformComponent.kCCCharacterProxy then
		radius = entity.clientTransformComponent.kccProxyRadius or radius
		height = entity.clientTransformComponent.kccProxyHeight or height
	end
	
	local isAloft = entity.moveComponent.isAloft
	if entity.tagComponent.npcTag ~= FightEnum.EntityNpcTag.Player and entity.stateComponent and
		entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
		isAloft = false
	end

	local heightCheck = height * 0.5
	if entity.moveComponent then
		heightCheck = heightCheck + entity.moveComponent:GetOffsetHeight()
	end

	local checkClimb = self:ClimbEnable(entity)
	local detechGround = true
	local unnormalDeath = entity.deathComponent and entity.deathComponent.isDeath
	local canFall = haveCollistion or (entity.stateComponent and entity.stateComponent:CanFall())

	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)

	local toStartClimb, toX, toY, toZ
	if not stickWithTerrain then
		UnityUtils.BeginSample("PhysicsTerrain:Move")
		toStartClimb, toX, toY, toZ = CS.PhysicsTerrain.MoveCheck(position,toPosX,toPosY,toPosZ,height,heightCheck,
			radius,isAloft,checkClimb, canFall, checkGroundRadius, entity.transformComponent.rotation, isLerpY)
		UnityUtils.EndSample()
		self.tmpTargetPos:Set(toX, toY, toZ)
	else
		toStartClimb = false
		heightCheck = height
		local rot = entity.transformComponent.rotation
		local rotX, rotY, rotZ, rotW
		toX, toY, toZ = CS.PhysicsTerrain.MoveCheck2(position, toPosX, toPosY, toPosZ,
			rot.x, rot.y, rot.z, rot.w, radius, height, heightCheck, 3, 1, checkGroundRadius, isLerpY)
		self.tmpTargetPos:Set(toX, toY, toZ)

		rotX, rotY, rotZ, rotW = CS.PhysicsTerrain.RotateOnGround(position, toX, toY, toZ,
			rot.x, rot.y, rot.z, rot.w, radius, height, heightCheck)
		entity.transformComponent:SetRotation(Quat.New(rotX, rotY, rotZ, rotW))
	end

	--if stickWithTerrain then
		--local rotX, rotY, rotZ, rotW
		--rotX, rotY, rotZ, rotW = CS.PhysicsTerrain.GetSlpoe(position, entity.transformComponent.rotation, rotX, rotY, rotZ, rotW)
		--entity.transformComponent:SetRotation(Quat.New(rotX, rotY, rotZ, rotW))
	--end

	if entity.moveComponent.isAloft or unnormalDeath then
		--self.tmpTargetPos.y = entity.transformComponent.position.y
		self.tmpTargetPos.y = toPosY--处理精准位移Y轴速度修改无效的bug
	elseif self.tmpTargetPos.y < -999 then
		detechGround = false
		if entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
			return false, Vec3.zero, detechGround
		else
			
			self.tmpTargetPos.y = toPosY
			local levitation = entity.buffComponent:CheckState(FightEnum.EntityBuffState.Levitation)
			local terrainDeath = entity.deathComponent and entity.deathComponent:IsInJudge(FightEnum.DeathCondition.Terrain)
			if not levitation and not terrainDeath then
				local canJump = entity.stateComponent and entity.stateComponent:CanJump()
				-- if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Climb) then
				-- 	canJump = false
				-- end
				-- if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Swim) then
				-- 	canJump = false
				-- end
				if canJump then
					entity.moveComponent:SetAloft(true)
					entity.stateComponent:SetState(FightEnum.EntityState.Jump)
				end
			end
		end
	end

	if toStartClimb and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		return false, Vec3.zero, detechGround
	end

	entity.collistionComponent:SetCollisionLayer(entityLayer)
	return toStartClimb, self.tmpTargetPos:Sub(position), detechGround
	--return toPostion - postion
end

function PhysicsTerrain:SwimMove(position, x, y, z, entity)
	local toPosX = position.x + x
	local toPosY = position.y + y
	local toPosZ = position.z + z

	local radius = entity.collistionComponent.worldRadius
	local height = entity.collistionComponent.height

	local heightCheck = height * 0.5
	local checkClimb = self:ClimbEnable(entity)

	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)
	local toStartClimb, toX, toY, toZ = CS.PhysicsTerrain.SwimMoveCheck(position,toPosX,toPosY,toPosZ,height,heightCheck,radius,checkClimb)

	local bottoming = false
	-- Y轴头顶检测的特殊处理，脚底检测正常跑
	if toY ~= position.y then
		local offsetY = toY - position.y
		local endY = offsetY > 0 and position.y + offsetY + height or toY
		local newToX, newToY, newToZ
		bottoming, newToX, newToY, newToZ = CS.PhysicsTerrain.SimpleCheckBySphere(toX, position.y + height * 0.5, toZ, toX, endY, toZ, radius * 0.2, PhysicsTerrain.TerrainCheckLayer)
		toY = offsetY > 0 and newToY - height or newToY
	end

	self.tmpTargetPos:Set(toX, toY, toZ)
	entity.collistionComponent:SetCollisionLayer(entityLayer)
	return toStartClimb, bottoming, self.tmpTargetPos:Sub(position)
	--return toPostion - postion
end

local SlideInterval = 3
function PhysicsTerrain:Slide(position, toPosition, entity)
	local isAloft = entity.moveComponent.isAloft

	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)

	if not isAloft then
		local radius = entity.collistionComponent.worldRadius
		local checkRadius = radius / 5

		local entityTransform = entity.clientTransformComponent:GetTransform()
		local heightCheck = isAloft and 0 or 0.5

		local slide = entity.slide or 0
		local canSlide = slide >= SlideInterval - 1

		slide, toPosition.x, toPosition.y, toPosition.z = CS.PhysicsTerrain.SlideCheck(entityTransform,toPosition.x,toPosition.y,toPosition.z, checkRadius, heightCheck, slide, canSlide)
		entity.slide = slide

		if slide >= SlideInterval and not entity.stateComponent:IsState(FightEnum.EntityState.Slide) then
			entity.stateComponent:SetState(FightEnum.EntityState.Slide)
		elseif entity.stateComponent:IsState(FightEnum.EntityState.Slide) and slide == 0 then
			entity.stateComponent:SetState(FightEnum.EntityState.Idle)
		end
	end

	entity.collistionComponent:SetCollisionLayer(entityLayer)
	return toPosition - position
end

function PhysicsTerrain:GetSurfaceOfWater(entity)
	if not entity.transformComponent then
		-- LogError("entity not transformComponent id = "..entity.entityId.." instance = "..entity.instanceId)
		return
	end

	local origin = entity.transformComponent:GetPosition()
	if not entity.collistionComponent then
		-- LogError("entity not collistionComponent id = "..entity.entityId.." instance = "..entity.instanceId)
		return
	end
	local height = entity.collistionComponent.height

	local surfaceOfWater = -9999
	return CS.PhysicsTerrain.LayerCheck(FightEnum.Layer.Water, origin, surfaceOfWater, height, 30)
end

function PhysicsTerrain:CheckObstacleBetweenPos(startPos1, targetPos1, penetrable)
	return UnityUtils.GetDistance(startPos1.x, startPos1.y, startPos1.z, targetPos1.x, targetPos1.y, targetPos1.z)
end

function PhysicsTerrain:SetWallEnable(wall,enable)
end

function PhysicsTerrain:GetInArea(area,position)
	return true
end

function PhysicsTerrain:GetPosition(name)
	return Vector3.zero
end

function PhysicsTerrain:CheckTerrainY(x, y, z, offsetY)
	return UnityUtils.GetDistance(x, y, z, x, y + offsetY, z)
end

function PhysicsTerrain:CheckTerrainHeight(position, offsetY, layer)
	local x = position.x
	local y = position.y
	local z = position.z

	offsetY = offsetY or 0
	layer = layer or PhysicsTerrain.TerrainCheckLayer

	local height, haveGround, checkLayer = UnityUtils.GetTerrainHeight(x, y + offsetY, z, layer)
	if not haveGround then
		height = -99999
	end

	return height, haveGround, checkLayer
end

function PhysicsTerrain:CheckBySphere(position, toPosition, radius, layer)
	local x = position.x
	local y = position.y
	local z = position.z

	local toX = toPosition.x
	local toY = toPosition.y
	local toZ = toPosition.z

	local checkLayer = layer or PhysicsTerrain.TerrainCheckLayer
	local check = false
	check, toX, toY, toZ, checkLayer = CS.PhysicsTerrain.SimpleCheckBySphere(x, y, z, toX, toY, toZ, radius, checkLayer)
	return check, toX, toY, toZ, checkLayer
end

function PhysicsTerrain:CheckYBySphere(position, offsetY, radius)
	offsetY = offsetY or 0
	local toPosition = position:Clone()
	toPosition.y = toPosition.y + offsetY

	local check, toX, toY, toZ = self:CheckBySphere(position, toPosition, radius, PhysicsTerrain.TerrainCheckLayer)
	return toY - position.y, check
end

function PhysicsTerrain:CheckGround(origin, entity, isLerpY)
	local unnormalDeath = entity.deathComponent and entity.deathComponent.isDeath
	local ingoreGround = entity.moveComponent.isAloft or (entity.stateComponent and not entity.stateComponent:CanFall())
	if ingoreGround or unnormalDeath then
		return 0
	end

	local endX, endY, endZ = CS.PhysicsTerrain.CheckGround(origin, origin, entity.collistionComponent.worldRadius, entity.collistionComponent.height,
			entity.collistionComponent.height * 0.5, 0, 0, 0, RayCastLayer, isLerpY)
	if endY - origin.y > 1 then
		return 0
	end
	if endY < -999 then
		local levitation = entity.buffComponent and entity.buffComponent:CheckState(FightEnum.EntityBuffState.Levitation)
		local terrainDeath = entity.deathComponent and entity.deathComponent:IsInJudge(FightEnum.DeathCondition.Terrain)
		if not levitation and not terrainDeath and entity.stateComponent then
			local canJump = entity.stateComponent and entity.stateComponent:CanJump()
			-- if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Climb) then
			-- 	canJump = false
			-- end
			-- if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Swim) then
			-- 	canJump = false
			-- end

			entity.moveComponent:SetAloft(canJump or entity.stateComponent:IsState(FightEnum.EntityState.Hit))
			if canJump then
				entity.stateComponent:SetState(FightEnum.EntityState.Jump)
			end
		end
		return 0
	end
	return endY - origin.y
end

---检查脚下的实体
function PhysicsTerrain:CheckUnderfootMovePlatform(origin, entity)
	local checkHeight = 0.5
	local entityIds = {}
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Jump) then
		checkHeight = 4
	end
	---兼容攀爬
	local checkDir = Vec3.New(0,-1,0)
    if entity.stateComponent and (entity.stateComponent:IsState(FightEnum.EntityState.Climb) or entity.stateComponent:IsState(FightEnum.EntityState.Slide)) then
		checkDir = entity.transformComponent.rotation:ToEulerAngles()
		checkHeight = 1
    end

	local idList, count = CS.PhysicsTerrain.CheckUnderfootEntity(origin, entity.collistionComponent.worldRadius, entity.collistionComponent.height,
			checkHeight, checkDir, MovePlatformLayer)
	if idList then
		for i = 0, count - 1 do
			local Id = idList[i]
			table.insert(entityIds, Id)
		end
	end
	return entityIds
end

function PhysicsTerrain:__delete()

end