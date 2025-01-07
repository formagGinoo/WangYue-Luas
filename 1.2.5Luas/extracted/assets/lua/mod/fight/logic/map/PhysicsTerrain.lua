---@class PhysicsTerrain
PhysicsTerrain = BaseClass("PhysicsTerrain")

PhysicsTerrain.TerrainCheckLayer = ~(FightEnum.LayerBit.IgonreRayCastLayer | FightEnum.LayerBit.Water | 
									 FightEnum.LayerBit.Area | FightEnum.LayerBit.Entity |
									 FightEnum.LayerBit.Marsh | FightEnum.LayerBit.Lava |
									 FightEnum.LayerBit.Driftsand | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.InRoom)
local RayCastLayer = CS.PhysicsTerrain.RayCastLayer

function PhysicsTerrain:__init(fight)
	self.tmpColliderOffset = Vec3.New()
	self.tmpColliderVector = Vec3.New()
	self.tmpTargetPos = Vec3.New()
	self.fight = fight
	
	self.tmpVec = Vec3.New()
	
	self.climbEnable = true
end

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
	if math.abs(forward.x - moveEvent.x) > 0.1 or math.abs(forward.z - moveEvent.y) > 0.1 then
		return false
	end
	
	return true
end

function PhysicsTerrain:Move(position, x, y, z, entity, haveCollistion, checkGroundRadius, stickWithTerrain)
	local toPosX = position.x + x 
	local toPosY = position.y + y
	local toPosZ = position.z + z
	
	local radius = entity.collistionComponent.radius
	local height = entity.collistionComponent.height
	 
	local isAloft = entity.moveComponent.isAloft
	if entity.tagComponent.npcTag ~= FightEnum.EntityNpcTag.Player and 
		entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
		isAloft = false
	end
	
	local heightCheck = height * 0.5
	local checkClimb = self:ClimbEnable(entity)
	local detechGround = true
	local unnormalDeath = entity.deathComponent and entity.deathComponent.isDeath
	local canFall = false
	if haveCollistion or (entity.tagComponent and entity.tagComponent.tag ~= FightEnum.EntityTag.Npc) then
		canFall = true
	elseif entity.tagComponent.tag == FightEnum.EntityNpcTag.Player then
		canFall = (not entity.stateComponent:IsState(FightEnum.EntityState.Skill) and not entity.stateComponent:IsState(FightEnum.EntityState.Aim)) or entity.moveComponent.isAloft
	else
		canFall = entity.stateComponent:IsState(FightEnum.EntityState.Skill) and entity.moveComponent.isAloft
	end

	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
	
	local toStartClimb, toX, toY, toZ
	if not stickWithTerrain then
		UnityUtils.BeginSample("PhysicsTerrain:Move")
		toStartClimb, toX, toY, toZ = CS.PhysicsTerrain.MoveCheck(position,toPosX,toPosY,toPosZ,height,heightCheck,
			radius,isAloft,checkClimb, canFall, checkGroundRadius, entity.transformComponent.rotation)
		UnityUtils.EndSample()
		self.tmpTargetPos:Set(toX, toY, toZ)
	else
		toStartClimb = false
		heightCheck = height
		local rot = entity.transformComponent.rotation
		local rotX, rotY, rotZ, rotW
		toX, toY, toZ = CS.PhysicsTerrain.MoveCheck2(position, toPosX, toPosY, toPosZ, 
			rot.x, rot.y, rot.z, rot.w, radius, height, heightCheck, 3, 1, checkGroundRadius)
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
			entity.moveComponent.isAloft = true
			self.tmpTargetPos.y = toPosY
			local levitation = entity.buffComponent:CheckState(FightEnum.EntityBuffState.Levitation)
			local terrainDeath = entity.deathComponent and entity.deathComponent:IsInJudge(FightEnum.DeathCondition.Terrain)
			if not levitation and not terrainDeath then
				entity.stateComponent:SetState(FightEnum.EntityState.Jump)
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

	local radius = entity.collistionComponent.radius
	local height = entity.collistionComponent.height

	local heightCheck = height * 0.5
	local checkClimb = self:ClimbEnable(entity)
	
	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
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
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
	
	if not isAloft then
		local radius = entity.collistionComponent.config.Radius
		local checkRadius = radius / 5
		
		local entityTransform = entity.clientEntity.clientTransformComponent:GetTransform()
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

function PhysicsTerrain:StrideOver(entity, heightOffset)
	local canStrideOver, toPos, strideOverY, strideOverZ = false, Vector3.zero, 0, 0
	
	local radius = entity.collistionComponent.radius
	local height = entity.collistionComponent.height
	local isAloft = entity.moveComponent.isAloft
	local heightCheck = heightOffset or (isAloft and height * 0.8 or height * 0.5)
	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
	
	local origin = entity.transformComponent:GetPosition()
	local rotation = entity.transformComponent:GetRotation()
	canStrideOver, toPos, strideOverY, strideOverZ = CS.PhysicsTerrain.StrideOverCheck(origin, rotation, toPos, height, radius, heightCheck, strideOverY, strideOverZ)
	
	entity.collistionComponent:SetCollisionLayer(entityLayer)
	
	return canStrideOver, toPos, strideOverY, strideOverZ
end

function PhysicsTerrain:UpdateClimbRotAndPos(entity, heightCheck)
	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
	local radius = entity.collistionComponent.radius
	local height = entity.collistionComponent.height
	heightCheck = heightCheck or 0
	local origin = entity.transformComponent:GetPosition()
	local rotation = entity.transformComponent:GetRotation()

	local dir, offsetPos = Vector3.zero, Vector3.zero
	dir, offsetPos = CS.PhysicsTerrain.UpdateClimbRotAndPos(origin,rotation,radius,height,heightCheck,offsetPos)
	entity.collistionComponent:SetCollisionLayer(entityLayer)
	return Vec3.New(dir.x, dir.y, dir.z), Vec3.New(offsetPos.x, offsetPos.y, offsetPos.z)
end

function PhysicsTerrain:Climb(entity, offset, forceCheckDir, forceMove)
	local entityLayer = entity.collistionComponent.layer
	entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
	
	local radius = entity.collistionComponent.radius
	local height = entity.collistionComponent.height
	
	local origin = entity.transformComponent:GetPosition()
	local rotation = entity.transformComponent:GetRotation()

	local canMove, x, y, z = CS.PhysicsTerrain.ClimbCheck(origin, rotation, offset.x, offset.y, offset.z, radius, height, forceCheckDir, forceMove)
	self.tmpVec:Set(x, y, z)
	
	--print(offset.y, forceCheckDir.y)
	--print(offset.x, offset.y, offset.z, Vec3.Dot(forceCheckDir, Vec3.up))
	
	-- y轴不移动的处理
	if forceCheckDir ~= Vec3.zero and not canMove then
		self.tmpVec:Set(0, 0, 0)
		-- 有y向的输入
		if forceCheckDir.y < -1e-8 then
			entity.stateComponent:SetState(FightEnum.EntityState.Idle)
		elseif forceCheckDir.y > 1e-8 then
			entity.climbComponent:TryStrideOver(nil, true)
		end
	end
	
	entity.collistionComponent:SetCollisionLayer(entityLayer)
	return self.tmpVec:Clone()
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

function PhysicsTerrain:CheckGround(origin, entity)
	local unnormalDeath = entity.deathComponent and entity.deathComponent.isDeath
	if entity.moveComponent.isAloft or unnormalDeath then
		return 0
	end
	
	local endX, endY, endZ = CS.PhysicsTerrain.CheckGround(origin, origin, entity.collistionComponent.config.Radius, entity.collistionComponent.height,
			entity.collistionComponent.height * 0.5, 0, 0, 0, RayCastLayer)
	if endY - origin.y > 1 then
		return 0
	end
	if endY < -999 then
		entity.moveComponent.isAloft = true

		local levitation = entity.buffComponent:CheckState(FightEnum.EntityBuffState.Levitation)
		local terrainDeath = entity.deathComponent and entity.deathComponent:IsInJudge(FightEnum.DeathCondition.Terrain)
		if not levitation and not terrainDeath then
			entity.stateComponent:SetState(FightEnum.EntityState.Jump)
		end
		return 0
	end
	return endY - origin.y
end

function PhysicsTerrain:__delete()

end