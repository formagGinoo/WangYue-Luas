---@class BehaviorFunctions
BehaviorFunctions = {}
--BehaviorFunctions = {}

local Vec3 = Vec3
local Quat = Quat
function BehaviorFunctions.SetFight(fight)
	BehaviorFunctions.fight = fight
end

function BehaviorFunctions.CreateEntityByEntity(bindEntity, entityId ,x,y,z,lockatX, lockatY, lockatZ, entityLev)
	local instanceId = BehaviorFunctions.CreateEntity(entityId,nil,x,y,z,lockatX, lockatY, lockatZ, nil, entityLev)
	local entity = BehaviorFunctions.GetEntity(bindEntity)
	entity:LifeBindEntity(instanceId)
	return instanceId
end

function BehaviorFunctions.CreateEntity(entityId,parentId,x,y,z,lockatX, lockatY, lockatZ, levelId, entityLev)
	local masterId
	local createId = entityId
	local monsterCfg = Config.DataMonster.Find[entityId]
	if monsterCfg then
		createId = monsterCfg.entity_id
		masterId = monsterCfg.id
	end

	local parent
	if parentId then
		parent = BehaviorFunctions.GetEntity(parentId)
	end
	local params
	if entityLev then
		params = {}
		params.level = entityLev
	end

	local entity = BehaviorFunctions.fight.entityManager:CreateEntity(createId, parent, masterId, nil, levelId, params)
	if x then
		if entity.moveComponent and entity.moveComponent.isFlyEntity then
			y = y + (entity.moveComponent.bornFlyHeight or 0)
		end
		entity.transformComponent:SetPosition(x,y,z)
		EntityLODManager.Instance:Async(entity.instanceId)
	end

	if lockatX then
		entity.rotateComponent:LookAtPositionWithY(lockatX,lockatY,lockatZ)
	end

	return entity.instanceId
end

function BehaviorFunctions.CreateEntityByPosition(entityId, parentId, positionName, belongId, positionLevelId, levelId, entityLv)
	local positionId
	if not positionLevelId then
		local mapId = BehaviorFunctions.fight:GetFightMap()
		local mapCfg = mod.WorldMapCtrl:GetMapConfig(mapId)
		if not mapCfg then
			return
		end

		if mapCfg.position_id and mapCfg.position_id ~= 0 then
			positionId = mapCfg.position_id
		else
			positionLevelId = levelId
		end
	end

	local position
	if positionId then
		position = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(positionId, positionName, belongId)
	else
		position = mod.WorldMapCtrl:GetMapPositionConfig(positionLevelId, positionName, belongId)
	end
	
	if not position then
		LogError(string.format("create entity by position fail. position is nil. positionName = %s, belongId = %s, levelId = %s", tostring(positionName), tostring(belongId), tostring(levelId)))
		return
	end

	local rot = Quat.New(position.rotX, position.rotY, position.rotZ, position.rotW):ToEulerAngles()
	local instanceId = BehaviorFunctions.CreateEntity(entityId, parentId, position.x, position.y, position.z, nil, nil, nil, levelId, entityLv)
	BehaviorFunctions.SetEntityEuler(instanceId, rot.x, rot.y, rot.z)

	return instanceId
end

function BehaviorFunctions.CreateNoPreLoadEntity(entityId,parentId,x,y,z,lockatX, lockatY, lockatZ, levelId, entityLev)
	local monsterCfg = Config.DataMonster.Find[entityId]
	local realEntityId = entityId
	if monsterCfg then
		realEntityId = monsterCfg.entity_id
	end
	local cb = function ()
		BehaviorFunctions.CreateEntity(entityId,parentId,x,y,z,lockatX, lockatY, lockatZ, levelId, entityLev)
    end
    BehaviorFunctions.fight.clientFight.assetsNodeManager:LoadEntity(realEntityId, cb)
end

function BehaviorFunctions.RemoveEntity(instanceId)
	BehaviorFunctions.fight.entityManager:RemoveEntity(instanceId)
end

function BehaviorFunctions.CheckEntity(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if entity then
		if entity.stateComponent then
			return not entity.stateComponent:IsState(FightEnum.EntityState.Death)
		else
			if entity.attrComponent then
				return entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life) > 0
			end
		end

		return true
	else
		return false
	end
end

---@return Entity
-- TODO 不给策划用了 修改一下策划处的接口
function BehaviorFunctions.GetEntity(instanceId, ingoreError)
	if not instanceId then
		return
	end

	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity and not ingoreError then
		LogError("找不到实体! "..instanceId)
	end

	return entity
end

function BehaviorFunctions.GetEntityOwner(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity or not entity.parent then
		return
	end

	return entity.parent.instanceId
end

function BehaviorFunctions.FindTarget()

end

function BehaviorFunctions.FindTargets()

end

function BehaviorFunctions.GetFightFrame()
	return BehaviorFunctions.fight.fightFrame
end
function BehaviorFunctions.GetDeltaTime()
	return FightUtil.deltaTime
end

function BehaviorFunctions.GetEntityFrame(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.timeComponent.frame
end

function BehaviorFunctions.CheckMove()
	return BehaviorFunctions.fight.operationManager:GetMoveEvent()
end

function BehaviorFunctions.CheckKeyDown(key, instanceId)
	local operationManager = BehaviorFunctions.fight.operationManager
	return operationManager:CheckKeyDown(key, instanceId)
end

function BehaviorFunctions.CheckKeyUp(key, instanceId)
	local operationManager = BehaviorFunctions.fight.operationManager
	return operationManager:CheckKeyUp(key, instanceId)
end

function BehaviorFunctions.SetInputEnableInstanceIdMap(map)
	local operationManager = BehaviorFunctions.fight.operationManager
	operationManager:SetEnableInstanceMap(map)
end

function BehaviorFunctions.GetMove()
	local moveEvent = BehaviorFunctions.fight.operationManager:GetMoveEvent()
	if not moveEvent then
		return 0,0
	end

	return moveEvent.x, moveEvent.y
end

function BehaviorFunctions.GetMoveDistance(instanceId,dis)
	local x,y,z = BehaviorFunctions.GetPosition(instanceId)
	local moveEvent = BehaviorFunctions.fight.operationManager.moveEvent
	return moveEvent.x * dis + x, moveEvent.y * dis + z
end

function BehaviorFunctions.DoSetPosition(instanceId,x,y,z)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.transformComponent:SetPosition(x,y,z)
end


function BehaviorFunctions.DoSetCameraPosition(x,y,z)
	if ctx then
		BehaviorFunctions.fight.clientFight.cameraManager:SetPosition(x,y,z)
	end
end

function BehaviorFunctions.CameraLockAtPosition(x,y,z,time)
	if ctx then
		BehaviorFunctions.fight.clientFight.cameraManager:LookAtPosition(x,y,z,time)
	end
end

function BehaviorFunctions.DoSetCameraPositionP(position)
	if ctx then
		BehaviorFunctions.fight.clientFight.cameraManager:SetPositionP(position)
	end
end

function BehaviorFunctions.CameraLockAtPositionP(position,time)
	if ctx then
		BehaviorFunctions.fight.clientFight.cameraManager:LookAtPositionP(position,time)
	end
end

function BehaviorFunctions.CancelCameraLookAt()
	if ctx then
		BehaviorFunctions.fight.clientFight.cameraManager:CancelLookAt()
	end
end

function BehaviorFunctions.DoSetPositionP(instanceId,position)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.transformComponent:SetPosition(position.x,position.y,position.z)
end

function BehaviorFunctions.DoSetPositionOffset(instanceId,x,y,z)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.transformComponent:SetPositionOffset(x,y,z)
end

function BehaviorFunctions.DoSetPositionOffsetP(instanceId,position)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.transformComponent:SetPositionOffset(position.x,position.y,position.z)
end

function BehaviorFunctions.GetEntityPositionOffset(instanceId, x, y, z)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.transformComponent then
		return
	end

	local pos = entity.transformComponent:GetPosition()
	local rot = entity.transformComponent:GetRotation()
	local offset = Vec3.New(x, y, z)
	return BehaviorFunctions.GetPositionOffsetWithRot(pos, rot, offset, 0)
end

function BehaviorFunctions.GetPositionOffsetP(pos,targetPos,offset,angle)
	local dir = (targetPos - pos):SetNormalize()
	local newVec = Quat.Euler(0, angle, 0) * dir
	local newPos = pos + newVec * offset


	--newPos = newPos + newVec * offset.x;
	--newPos = newPos + Vector3.up * offset.y;
	return newPos
end

function BehaviorFunctions.GetPositionOffsetWithRot(pos, rot, offset, angle)
	local newVec = Quat.Euler(0, angle, 0) * rot
	local newPos = pos + newVec * offset

	return newPos
end

function BehaviorFunctions.GetPositionOffsetBySelf(instanceId,offset,angle)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	-- if not entity or not entity.clientEntity or not entity.clientTransformComponent then
	-- 	return
	-- end

	-- local transform = entity.clientTransformComponent:GetTransform()
	-- if UtilsBase.IsNull(transform) then
	-- 	return
	-- end
	-- local x, y, z
	-- x, y, z = CustomUnityUtils.GetTransformForwardOffset(transform, offset, angle, x, y, z)
	-- return Vec3.New(x, y, z)

	if not entity then
		return
	end

	local rot = entity.transformComponent:GetRotation()
	local offsetR = rot * Quat.Euler(0, angle, 0)

	local pos = entity.transformComponent:GetPosition()
	return pos + offsetR * Vec3.forward * offset
end

function BehaviorFunctions.GetPosition(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	local position = entity.transformComponent.position
	return position.x,position.y,position.z
end

function BehaviorFunctions.GetPositionP(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	local position = entity.transformComponent.position
	return position
end

function BehaviorFunctions.GetRotation(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	local rotation = entity.transformComponent.rotation
	return rotation
end


function BehaviorFunctions.GetEcoEntityBornPosition(ecoId)
	local ecoCfg = BehaviorFunctions.fight.entityManager:GetEntityConfigByID(ecoId)
	if not ecoCfg then
		return
	end

	local pos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(ecoCfg.position_id, ecoCfg.position[2], ecoCfg.position[1])
	return pos
end

-- 返回生态的实时位置 包括被占用的位置
function BehaviorFunctions.GetEcoEntityPosition(ecoId)
	return BehaviorFunctions.fight.entityManager.ecosystemCtrlManager:GetEcoBornPos(ecoId)
end

function BehaviorFunctions.DoMove(instanceId,x,z)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.moveComponent:DoMove(x,z)
end

function BehaviorFunctions.DoMoveForward(instanceId,speed)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.moveComponent then
		entity.moveComponent:DoMoveForward(speed)
	else
		local x, y, z = Quat.MulVec3A(entity.transformComponent.rotation, Vec3.forward * speed)
		local pos = entity.transformComponent.position
		entity.transformComponent:SetPosition(pos.x + x,pos.y + y,pos.z + z)
	end
	
end

function BehaviorFunctions.DoMoveY(instanceId,y)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.moveComponent:SetPositionOffset(0,y,0)
end

function BehaviorFunctions.DoLookAtTargetImmediately(instanceId,targetInstanceId,transformName, includeX) 
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	entity.rotateComponent:LookAtTarget(targetEntity, transformName, includeX)
end

function BehaviorFunctions.DoLookAtPositionImmediately(instanceId,x,y,z,ignoreX)
	if ignoreX then y = nil end --策划说y传nil不太好理解，所以加了个参数
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.rotateComponent:LookAtPositionWithY(x,y,z)
end

function BehaviorFunctions.DoLookAtTargetByLerp(instanceId,targetInstanceId,useBase,extraSpeed,accelSpeed,lastTime, includeX)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if entity and entity.rotateComponent then
		entity.rotateComponent:LookAtTargetByLerp(targetEntity,useBase,extraSpeed,accelSpeed,lastTime, includeX)
	end
end

function BehaviorFunctions.DoLookAtPositionByLerp(instanceId,x,y,z,useBase,extraSpeed,accelSpeed,ignoreX)
	if ignoreX then y = nil end
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.rotateComponent:LookAtPositionByLerpWithY(x,y,z,useBase,extraSpeed,accelSpeed)
end

function BehaviorFunctions.SetEntityEuler(instanceId,x,y,z)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.rotateComponent:SetEuler(x,y,z)
end

function BehaviorFunctions.AddEntityEuler(instanceId,x,y,z)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local euler = entity.transformComponent.rotation:ToEulerAngles()
	entity.rotateComponent:SetEuler(euler.x+x,euler.y+y,euler.z+z)
end

function BehaviorFunctions.GetEntityEuler(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local euler = entity.transformComponent.rotation:ToEulerAngles()
	return euler
end

function BehaviorFunctions.CancelLookAt(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.rotateComponent:CancelLookAt()
end

function BehaviorFunctions.DoLookAtTaget(instanceId,targetEntity)

end

function BehaviorFunctions.DoLookAtPosition(entity,x,y)

end

function BehaviorFunctions.GetDistanceFromTarget(instanceId,targetInstanceId,checkRadius)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not entity or not targetEntity then
		return
	end

	return entity.transformComponent:GetDistanceFromTarget(targetEntity,checkRadius)
end

function BehaviorFunctions.GetDistanceFromTargetWithY(instanceId, targetInstanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not entity or not targetEntity then
		return
	end

	return Vec3.Distance(entity.transformComponent:GetPosition(), targetEntity.transformComponent:GetPosition())
end

function BehaviorFunctions.GetDistanceFromPos(pos1, pos2)
	return math.sqrt((pos1.x - pos2.x) * (pos1.x - pos2.x) + (pos1.z - pos2.z) * (pos1.z - pos2.z))
end

function BehaviorFunctions.CheckObstaclesBetweenEntity(instanceId, targetInstanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	
	local from = entity.transformComponent:GetPosition()
	if entity.collistionComponent then
		local offset = Vec3.up * (0.5 * entity.collistionComponent.config.Height)
		from:Add(offset)
	end
	
	local to = targetEntity.transformComponent:GetPosition()
	if targetEntity.collistionComponent then
		local offset = Vec3.up * (0.5 * targetEntity.collistionComponent.config.Height)
		to:Add(offset)
	end
	
	local penetrable = entity.buffComponent and entity.buffComponent:CheckState(FightEnum.EntityBuffState.Penetrable)
	local check, toX, toY, toZ = BehaviorFunctions.CheckObstaclesBetweenPos(from, to, penetrable)
	to:Set(toX, toY, toZ)
	return check, check and Vec3.Distance(from, to) or 0
end

function BehaviorFunctions.CheckObstaclesBetweenPos(pos, targetPos, penetrable)
	return UnityUtils.LineCast(pos.x, pos.y, pos.z, targetPos.x, targetPos.y, targetPos.z)
end

function BehaviorFunctions.GetDistanceBetweenObstaclesAndEntity(instanceId, targetInstanceId)
	local isBlock, distance = BehaviorFunctions.CheckObstaclesBetweenEntity(instanceId, targetInstanceId)
	return isBlock and distance or 0
end

function BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(pos, targetPos, penetrable)
	local isBlock, toX, toY, toZ = BehaviorFunctions.CheckObstaclesBetweenPos(pos, targetPos, penetrable)
	local to = Vec3.New(toX, toY, toZ)
	local distance = Vec3.Distance(pos, to)
	return isBlock and distance or 0
end

function BehaviorFunctions.CastSkillByTarget(instanceId,skillId,targetInstanceId,targetPart, targetTransform)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not BehaviorFunctions.CheckEntity(instanceId) then
		return
	end

	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	return entity.skillComponent:CastSkillByTarget(skillId,targetEntity,targetPart,targetTransform)
end

function BehaviorFunctions.CastSkillByPosition(instanceId,skillId,x,y,z)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not BehaviorFunctions.CheckEntity(instanceId) then
		return
	end

	return entity.skillComponent:CastSkillByPosition(skillId,x,y,z)
end

function BehaviorFunctions.CastSkillByPositionP(instanceId,skillId,position)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not BehaviorFunctions.CheckEntity(instanceId) then
		return
	end

	return entity.skillComponent:CastSkillByPosition(skillId,position.x,position.y,position.z)
end

function BehaviorFunctions.CastSkillBySelfPosition(instanceId,skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not BehaviorFunctions.CheckEntity(instanceId) then
		return
	end

	local x,y,z = BehaviorFunctions.GetPosition(instanceId)
	--local x, y, z = Quat.MulVec3A(entity.transformComponent.rotation, Vec3.forward * 0.001)--往前一点点，不然会有小数点误差
	return entity.skillComponent:CastSkillByPosition(skillId,x,y,z)
end

function BehaviorFunctions.CanCastSkill(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not BehaviorFunctions.CheckEntity(instanceId) then
		return false
	end

	return entity.stateComponent:CanCastSkill()
end

function BehaviorFunctions.GetSkillConfig(instanceId, skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return
	end

	return entity.skillComponent:GetSkillConfig(skillId)
end

-- TODO 临时
function BehaviorFunctions.SetCtrlState(instanceId, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	entity.values["ctrlState"] = state
end

-- TODO 临时
function BehaviorFunctions.CanCtrl(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	if entity.values["ctrlState"] == false then
		return false
	end

	if entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
		return entity.skillComponent:CanFinish()
	else
		return entity.stateComponent:CanCastSkill()
	end
end

function BehaviorFunctions.SetMainTarget(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.clientTransformComponent:SetMainRole(true)
	BehaviorFunctions.fight.clientFight.cameraManager:SetMainTarget(
		entity.clientTransformComponent.transform)
end

function BehaviorFunctions.SetLockTarget(targetInstanceId, transformName, uiLockBindName)
	if ctx then
		if targetInstanceId then
			local target = BehaviorFunctions.GetEntity(targetInstanceId)
			if not target then
				BehaviorFunctions.fight.clientFight.cameraManager:ClearTarget()
				return
			end
	
			BehaviorFunctions.fight.clientFight.cameraManager:SetTarget(target,
				target.clientTransformComponent, transformName, uiLockBindName)
		else
			BehaviorFunctions.fight.clientFight.cameraManager:ClearTarget()
		end
	end
end

function BehaviorFunctions.CheckLockTarget()
	return BehaviorFunctions.fight.clientFight.cameraManager:IsLockingTarget()
end
--BehaviorFunctions.SetIdleType(3,FightEnum.EntityIdleType.FightIdle)
function BehaviorFunctions.SetIdleType(instanceId,type)
	local target = BehaviorFunctions.GetEntity(instanceId)
	local state = BehaviorFunctions.GetEntityState(instanceId)
	target.defaultIdleType = type
	if state == FightEnum.EntityState.Idle then
		target.stateComponent.stateFSM.statesMachine.idleFSM:SetIdleType(type)
	end
end

function BehaviorFunctions.CheckIdleState(instanceId,idleState)
	local target = BehaviorFunctions.GetEntity(instanceId)
	if target and target.stateComponent then
		local state = BehaviorFunctions.GetEntityState(instanceId)
		if state == FightEnum.EntityState.Idle then
			return target.stateComponent.stateFSM.statesMachine.idleFSM:IsState(idleState)
		end
	end

	return false
end

function BehaviorFunctions.SetCameraState(state)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraState(state)
end

function BehaviorFunctions.SetIgnoreStopBlendState(isIgnoreStopBlend)
	BehaviorFunctions.fight.clientFight.cameraManager:SetIgnoreStopBlendState(isIgnoreStopBlend)
end

function BehaviorFunctions.ChangeFightCamera(targetInstanceId, transformName)
	BehaviorFunctions.fight.clientFight.cameraManager:ChangeFightCamera(targetInstanceId, transformName)
end

function BehaviorFunctions.SetCameraStateForce(state,force)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraStateForce(state,force)
end

function BehaviorFunctions.SetCameraParams(state,id,coverDefult)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraParams(state,id,coverDefult)
end

function BehaviorFunctions.SetGlideCameraParams(state,id)
	BehaviorFunctions.fight.clientFight.cameraManager:SetGlideCameraParams(state,id)
end

function BehaviorFunctions.CorrectCameraParams(state)
	BehaviorFunctions.fight.clientFight.cameraManager:CorrectCameraParams(state)
end

function BehaviorFunctions.SetCamerIgnoreData(state, isIgnore, ignoreRatio)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCamerIgnoreData(state, isIgnore, ignoreRatio)
end

function BehaviorFunctions.DoSetMoveType(instanceId,type)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent:SetMoveType(type)
end

function BehaviorFunctions.GetEntityState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent then
		return entity.stateComponent:GetState()
	end
	return 0
end

function BehaviorFunctions.CheckEntityState(instanceId,state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity.stateComponent then
		return
	end

	return state == entity.stateComponent:GetState()
end

function BehaviorFunctions.DoSetEntityState(instanceId,state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent:SetState(state)
end

function BehaviorFunctions.StopMove(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent:IsState(FightEnum.EntityState.Move) then
		entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move]:StopMove()
	end
end

function BehaviorFunctions.GetSkillSign(instanceId,type)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return
	end

	return entity.skillComponent:GetSkillSign(type)
end

function BehaviorFunctions.GetSkillSignWithId(instanceId, skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return
	end

	return entity.skillComponent:GetSkillSignWithId(skillId)
end

function BehaviorFunctions.BreakSkill(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return
	end

	return entity.skillComponent:BreakBySelf()
end

function BehaviorFunctions.GetSkill(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return
	end

	return entity.skillComponent.skillId
end

function BehaviorFunctions.GetSkillConfigSign(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return
	end

	return entity.skillComponent.skillSign
end

function BehaviorFunctions.GetSkillType(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return
	end

	return entity.skillComponent.skillType
end

function BehaviorFunctions.GetSkillTarget(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return
	end

	return entity.skillComponent:GetSkillTarget()
end

function BehaviorFunctions.CheckSkillType(instanceId, checkType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillComponent then
		return false
	end

	local skillType = entity.skillComponent.skillType
	return skillType & checkType > 0
end

function BehaviorFunctions.AnalyseSkillType(skillType, checkType)
	return skillType & checkType > 0
end

function BehaviorFunctions.RemoveBehavior(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity:RemoveBehaviorComponent()
end

function BehaviorFunctions.GetBehavior(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.behaviorComponent
end

function BehaviorFunctions.SearchNpc()
	return BehaviorFunctions.fight.entityManager.entitySearch:SearchEntityByNpcTag()
end

function BehaviorFunctions.SearchEntity(instanceId, dist, minDegree, maxDegree, camp, tag, 
	buffKind, nBuffKind, distWeight, degreeWeight, npcTag, checkLogicLock, checkRay, heighWeight, viewWeight, lockWeight, searchWeight, cameraRt)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local entitySearch = BehaviorFunctions.fight.entityManager.entitySearch
	return entitySearch:SearchEntity(entity, dist, minDegree, maxDegree, camp, tag, 
	buffKind, nBuffKind, distWeight, degreeWeight, npcTag, nil, checkLogicLock, checkRay, heighWeight, viewWeight, lockWeight, searchWeight, cameraRt)
end

function BehaviorFunctions.SearchEntities(instanceId, dist, minDegree, maxDegree, camp, tag, 
	buffKind, nBuffKind, distWeight, degreeWeight, npcTag, checkLogicLock, checkRay, heighWeight, viewWeight, lockWeight, searchWeight, cameraRt)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local entitySearch = BehaviorFunctions.fight.entityManager.entitySearch
	return entitySearch:SearchEntity(entity, dist, minDegree, maxDegree, camp, tag, 
	buffKind, nBuffKind, distWeight, degreeWeight, npcTag, true, checkLogicLock, checkRay, heighWeight, viewWeight, lockWeight, searchWeight, cameraRt)
end

function BehaviorFunctions.SearchEntityPart(instanceId, instanceId2, dist, minDegree, maxDegree, distWeight, degreeWeight, 
	checkLogicLock, heighWeight, viewWeight, lockWeight, searchWeight, cameraRt)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local entitySearch = BehaviorFunctions.fight.entityManager.entitySearch
	return entitySearch:SearchEntityPart(entity, instanceId2, dist, minDegree, maxDegree, distWeight, degreeWeight, checkLogicLock, heighWeight, viewWeight, lockWeight, searchWeight, cameraRt)
end


function BehaviorFunctions.SearchNpcList(instanceId, dist, camp, npcTag, buffKind, nBuffKind, checkRay)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local entitySearch = BehaviorFunctions.fight.entityManager.entitySearch
	return entitySearch:SearchNpcList(entity, dist, camp, npcTag, buffKind, nBuffKind, checkRay)
end

function BehaviorFunctions.SearchNpcCount(instanceId, dist, camp, npcTag, buffKind, nBuffKind, checkRay)
	return #BehaviorFunctions.SearchNpcList(instanceId, dist, camp, npcTag, buffKind, nBuffKind, checkRay)
end

function BehaviorFunctions.GetEnityOnScreenLeft(instanceId)
	local pos = BehaviorFunctions.GetPositionP(instanceId)
	local targetPoint = BehaviorFunctions.fight.clientFight.cameraManager.mainCameraComponent:WorldToViewportPoint(pos)
	return targetPoint.x < 0.5
end

function BehaviorFunctions.Log(info)
	Log(info)
end

function BehaviorFunctions.ShowTip(tipId, ...)
	--Log("ShowTip是弃用的，请使用AddLevelTips")
	if ctx then
		EventMgr.Instance:Fire(EventName.MainPanelShowTip, tipId, ...)
	end
end

function BehaviorFunctions.ChangeTitleTipsDesc(tipId, ...)
	--Log("ChangeTitleTipsDesc是弃用的，请使用ChangeLevelTitleTips")
	if ctx then
		EventMgr.Instance:Fire(EventName.ChangeTitleTips, tipId, ...)
	end
end

function BehaviorFunctions.ChangeSubTipsDesc(index, tipId, ...)
	--Log("ChangeSubTipsDesc是弃用的，请使用ChangeLevelSubTips")
	if ctx then
		EventMgr.Instance:Fire(EventName.ChangeSubTips, index, tipId, ...)
	end
end

function BehaviorFunctions.HideTip(tipId)
	--Log("HideTip是弃用的，请使用RemoveLevelTips")
	if ctx then
		EventMgr.Instance:Fire(EventName.MainPanelHideTip, tipId)
	end
end

function BehaviorFunctions.SetTipsGuideState(state)
	if ctx then
		EventMgr.Instance:Fire(EventName.MainPanelSetTipsGuide, state)
	end
end

function BehaviorFunctions.ShowGuidTip(tipId)
	if ctx then
		EventMgr.Instance:Fire(EventName.ShowGuideTips, tipId)
	end
end

function BehaviorFunctions.SetWallEnable(wall,enable)
	BehaviorFunctions.fight.terrain:SetWallEnable(wall,enable)
end

function BehaviorFunctions.GetInAreaById(area,instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return BehaviorFunctions.fight.terrain:GetInArea(area,
		entity.transformComponent.position)
end

function BehaviorFunctions.GetInAreaByPos(area,pos)
	return BehaviorFunctions.fight.terrain:GetInArea(area,pos)
end

function BehaviorFunctions.CheckEntityInArea(instanceId, areaName, logicName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return false
	end

	return entity:CheckIsInArea(areaName, logicName)
end

function BehaviorFunctions.AddSkillEventActiveSign(instanceId,sign)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillComponent:AddEventActiveSign(sign)
end

function BehaviorFunctions.RemoveSkillEventActiveSign(instanceId,sign)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillComponent:RemoveEventActiveSign(sign)
end

function BehaviorFunctions.CheckSkillEventActiveSign(instanceId,sign)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillComponent:CheckEventActiveSign(sign)
end

function BehaviorFunctions.ActiveSceneObj(objName,flag,levelId)
	if ctx then
		BehaviorFunctions.fight.clientFight.clientMap:ActiveObj(objName,flag,levelId)
	end
end

function BehaviorFunctions.ActiveSceneObjByPath(path,active)
	if ctx then
		BehaviorFunctions.fight.clientFight.clientMap:ActiveSceneObjByPath(path,active)
	end
end

function BehaviorFunctions.PlaySceneTimeline(objName, levelId)
	if ctx then
		BehaviorFunctions.fight.clientFight.clientMap:PlayTimeline(objName, levelId)
	end
end

function BehaviorFunctions.StopSceneTimeline()
	if ctx then
		BehaviorFunctions.fight.clientFight.clientMap:StopTimeline()
		return SoundManager.Instance.channelStop
	end
end

function BehaviorFunctions.SceneObjPlayAnim(objName,animName,levelId)
	if ctx then
		BehaviorFunctions.fight.clientFight.clientMap:PlayAnim(objName,animName,levelId)
	end
end

function BehaviorFunctions.OpenChannelSound(channelType)
	SoundManager.Instance:OpenChannelSound(channelType)
end

function BehaviorFunctions.ChangeRoleInheritState(exitEntity, enterEntity)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		return
	end

	local exit = BehaviorFunctions.GetEntity(exitEntity)
	local enter = BehaviorFunctions.GetEntity(enterEntity)
	if not exit or not enter then
		return
	end

	player:ChangeCtrlEntity(exit, enter)
end

function BehaviorFunctions.GetSubMoveState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent.stateFSM:GetSubMoveState()
end

function BehaviorFunctions.GetSubSwimState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent.stateFSM:GetSubSwimState()
end

function BehaviorFunctions.GetSubClimbState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent.stateFSM:GetSubClimbState()
end

function BehaviorFunctions.SetEntityMoveMode(instanceId, mode)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:SetMoveMode(mode)
end

function BehaviorFunctions.SetEntitySprintState(instanceId, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:SetSprintState(state)
end

function BehaviorFunctions.CheckEntitySprint(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent:IsSprint()
end

function BehaviorFunctions.SetEntityFastSwimming(instanceId, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:SetFastSwimming(state)
end

function BehaviorFunctions.CheckEntityFastSwimming(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent:IsFastSwimming()
end

function BehaviorFunctions.SetEntityClimbingRun(instanceId, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:SetClimbingRun(state)
end

function BehaviorFunctions.SetEntityForceLeaveClimb(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:SetForceLeaveClimb()
end

function BehaviorFunctions.CheckEntityClimbingRun(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent:IsClimbingRun()
end

function BehaviorFunctions.GetEntityMoveMode(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent:GetMoveMode()
end

function BehaviorFunctions.GetKeyPressFrame(key, instanceId)
	return BehaviorFunctions.fight.operationManager:GetKeyPressFrame(key, instanceId)
end

function BehaviorFunctions.CheckKeyPress(key, instanceId)
	return BehaviorFunctions.fight.operationManager:GetKeyPressFrame(key, instanceId) > 0
end

function BehaviorFunctions.RemoveKeyPress(key)
	BehaviorFunctions.fight.operationManager:RemoveKeyPress(key)
	BehaviorFunctions.fight.clientFight.inputManager:KeyUp(key)
end

function BehaviorFunctions.ClearAllInput()
	BehaviorFunctions.fight.clientFight.inputManager:ClearAllInput()
	for k, v in pairs(FightEnum.KeyEvent) do
		BehaviorFunctions.fight.operationManager:RemoveKeyPress(v)
		BehaviorFunctions.fight.clientFight.inputManager:KeyUp(v)
	end
end

function BehaviorFunctions.CastPasv(instanceId,pasvId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.pasvComponent:CastPasv(pasvId)
end

function BehaviorFunctions.CancelPasv(instanceId,pasvId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.pasvComponent:CancelPasv(pasvId)
end

function BehaviorFunctions.ExistPasv(instanceId,pasvId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.pasvComponent:ExistPasv(pasvId)
end

function BehaviorFunctions.GetPlayerAttrVal(attrType)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player.fightPlayer:GetAttrValue(attrType)
end

function BehaviorFunctions.GetPlayerBaseAttrVal(attrType)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player.fightPlayer:GetBaseAttrValue(attrType)
end

function BehaviorFunctions.GetPlayerAttrRatio(attrType)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player.fightPlayer:GetAttrValueRatio(attrType) * 10000
end

function BehaviorFunctions.GetPlayerAttrValueAndMaxValue(attrType)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player.fightPlayer:GetValueAndMaxValue(attrType)
end

function BehaviorFunctions.ChangePlayerAttr(attrType, value)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player.fightPlayer:AddAttrValue(attrType, value)
end

function BehaviorFunctions.SetPlayerAttr(attrType, value)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player.fightPlayer:SetAttrValue(attrType, value)
end

function BehaviorFunctions.CheckCamp(instanceId,camp)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.tagComponent then
		return entity.tagComponent.camp == camp
	end
	return false
end

function BehaviorFunctions.CheckCampBetweenTarget(instanceId, targetInstanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local target = BehaviorFunctions.GetEntity(targetInstanceId)
	if not entity or not target or not entity.tagComponent or not target.tagComponent then
		return false
	end

	return entity.tagComponent.camp == target.tagComponent.camp
end

function BehaviorFunctions.GetCampType(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.tagComponent then
		return entity.tagComponent.camp
	end

	return
end

function BehaviorFunctions.GetNpcType(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.tagComponent then
		return entity.tagComponent.npcTag
	end
	return 0
end

function BehaviorFunctions.GetEntityTag(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.tagComponent then
		return entity.tagComponent.tag
	end
	return 0
end

function BehaviorFunctions.Random(min,max)
	local minI = math.floor(min * 10000)
	local maxI = math.floor(max * 10000)
	return math.random(minI,maxI) / 10000--只能整数
end

function BehaviorFunctions.CheckHitType(instanceId,hitType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Hit) then
		return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM:GetState() == hitType
	end
	return false
end

function BehaviorFunctions.GetHitType(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Hit) then
		return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM:GetState()
	end
	return 0
end

function BehaviorFunctions.SetHitType(instanceId,hitType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Hit) then
		entity.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM:SetHitType(hitType)
	end
end

function BehaviorFunctions.EndHitState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Hit) then
		entity.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM:HitStateEnd()
	end
end

function BehaviorFunctions.HasBuffKind(instanceId,kind)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.buffComponent then
		return false
	end
	return entity.buffComponent:HasBuffKind(kind)
end

function BehaviorFunctions.CheckBuffKind(entityInstanceId,buffInstanceId,kind)
	local entity = BehaviorFunctions.GetEntity(entityInstanceId)
	if not entity or not entity.buffComponent then
		return false
	end
	return entity.buffComponent:CheckBuffKind(buffInstanceId,kind)
end

function BehaviorFunctions.ChangeBuffAccumulateValue(instanceId, targetInstanceId, buffValueType, value)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not targetEntity.buffComponent then
		return
	end

	EventMgr.Instance:Fire(EventName.BuffValueChange, targetEntity, buffValueType, value)
end

function BehaviorFunctions.DoMagic(instanceId, targetInstanceId, magicId, magicLv, kind, partName, attackEntityInstance, customParams)
	if not targetInstanceId and not kind then
		return
	end

	local fromInstanceId = instanceId
	if kind then
		fromInstanceId = targetInstanceId
	end

	local entity = BehaviorFunctions.GetEntity(fromInstanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	local parentInstanceId = entity.parent and entity.parent.instanceId or nil
	local magicConfig = MagicConfig.GetMagic(magicId, entity.entityId, kind, parentInstanceId)
	local buffConfig = MagicConfig.GetBuff(magicId, entity.entityId, kind, parentInstanceId)
	local part
	if partName then
		part = targetEntity.partComponent:GetPart(partName)
	end

	local attackEntity
	if attackEntityInstance then
		attackEntity = BehaviorFunctions.GetEntity(attackEntityInstance)
	end

	if magicConfig then
		BehaviorFunctions.fight.magicManager:DoMagic(magicConfig, magicLv, entity, targetEntity, false, nil, kind, part, attackEntity, customParams)
	elseif buffConfig then
		BehaviorFunctions.AddBuff(fromInstanceId, targetInstanceId, magicId, magicLv, kind, part)
	end
end


function BehaviorFunctions.DoDamageByMagicId(instanceId, targetInstanceId, magicId, SkillParam, SkillBaseDmg)
	local customParams = 
	{
		SkillParam = SkillParam or 0,
		SkillBaseDmg = SkillBaseDmg or 0,
	}
	BehaviorFunctions.DoMagic(instanceId, targetInstanceId, magicId, nil, nil, nil, instanceId, customParams)
end

function BehaviorFunctions.DoCureByMagicId(instanceId, targetInstanceId, magicId, SkillParam, SkillAdditionParam)
	local customParams = 
	{
		SkillParam = SkillParam or 0,
		SkillAdditionParam = SkillAdditionParam or 0,
	}
	BehaviorFunctions.DoMagic(instanceId, targetInstanceId, magicId, nil, nil, nil, nil, customParams)
end

function BehaviorFunctions.GetTerrainPositionP(name, levelId, belongId)
	return BehaviorFunctions.fight.clientFight.clientMap:GetObjectPosition(name, levelId, belongId) --BehaviorFunctions.fight.terrain:GetPosition(name)
end

function BehaviorFunctions.GetTerrainRotationP(name, levelId, belongId)
	local pos = mod.WorldMapCtrl:GetMapPositionConfig(levelId, name, belongId)
	local rot = Quat.New(pos.rotX, pos.rotY, pos.rotZ, pos.rotW):ToEulerAngles()

	return rot
end

function BehaviorFunctions.GetPosAngle(rotation, pos, targetPos)
	--local result = Vec3.AngleSigned(rotation * Vec3.forward, targetPos - pos) % 360


	return CustomUnityUtils.AngleSigned(rotation * Vec3.forward, targetPos - pos) % 360
end

function BehaviorFunctions.GetEntityAngleBetweenPos(instanceId, targetPos)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local pos = entity.transformComponent.position
	
	return BehaviorFunctions.GetPosAngle(entity.transformComponent.rotation, pos, targetPos)
end

function BehaviorFunctions.GetEntityAngle(instanceId, targetInstanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)

	local pos = entity.transformComponent.position
	local targetPos = targetEntity.transformComponent.position

	return BehaviorFunctions.GetPosAngle(entity.transformComponent.rotation, pos, targetPos)
end

function BehaviorFunctions.GetPosAngleWithCamera(x, y, z)
	local camera = BehaviorFunctions.fight.clientFight.cameraManager:GetMainCameraTransform()
	local targetPos = Vec3.New(x, y, z)

	local r = Quat.New(camera.rotation.x, camera.rotation.y, camera.rotation.z, camera.rotation.w)
	local p = Vec3.New(camera.position.x, camera.position.y, camera.position.z)
	local angle = BehaviorFunctions.GetPosAngle(r, p, targetPos)

	return angle <= 180 and angle or angle - 360
end

function BehaviorFunctions.CheckContainPosByInsId(instanceId)
	local isContain = BehaviorFunctions.fight.clientFight.cameraManager:CheckContainPosByInsId(instanceId)
	return isContain
end

function BehaviorFunctions.GetEntityAngleWithCamera(instanceId)
	local position = BehaviorFunctions.GetPositionP(instanceId)
	if not position then
		return
	end

	return BehaviorFunctions.GetPosAngleWithCamera(position.x, position.y, position.z)
end

-- LogError("angle = "..BehaviorFunctions.GetEntityBonesAngle(2, "HitCase", 5, "HitCase"))
function BehaviorFunctions.GetEntityBonesAngle(instanceId, boneName, targetInstanceId, targetBoneName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not entity or not targetEntity then
		return
	end

	local bone = entity.clientTransformComponent:GetTransform(boneName)
	local targetBone = targetEntity.clientTransformComponent:GetTransform(targetBoneName)
	if not bone or not targetBone then
		return
	end

	local pos = Vec3.New(bone.position.x, 0, bone.position.z)
	local targetPos = Vec3.New(targetBone.position.x, 0, targetBone.position.z)
	local rot = Quat.New(bone.rotation.x, bone.rotation.y, bone.rotation.z, bone.rotation.w)

	return BehaviorFunctions.GetPosAngle(rot, pos, targetPos)
end

function BehaviorFunctions.GetEntityWorldAngle(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.clientTransformComponent.eulerAngles.y
end

function BehaviorFunctions.SetEntityWorldAngle(instanceId, angle)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	
	local rotation = entity.transformComponent:GetRotation()
	rotation:SetEuler(0, angle, 0)
	entity.transformComponent:SetRotation(rotation)
end

function BehaviorFunctions.CopyEntityRotate(instanceId, targetId , offsetX , offsetY, offsetZ)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetId)
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	offsetZ = offsetZ or 0
	local rotation = nil
	if entity then
		local eulerAngles = entity.clientTransformComponent.transform.rotation.eulerAngles
		rotation = Quat.Euler(offsetX + eulerAngles.x, offsetY + eulerAngles.y, offsetZ + eulerAngles.z)
	else
		rotation = Quat.Euler(offsetX , offsetY , offsetZ )
	end
	 
	targetEntity.rotateComponent:SetRotation(rotation)

	targetEntity.rotateComponent:Async()
end

function BehaviorFunctions.CompEntityLessAngle(instanceId,targetInstanceId,checkAngle)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)

	local pos = entity.transformComponent.position
	local targetPos = targetEntity.transformComponent.position
	local x = targetPos.x - pos.x
	local z = targetPos.z - pos.z
	local targetRotate = Quat.LookRotationA(x, 0, z)
	local angle = Quat.Angle(entity.transformComponent.rotation, targetRotate)
	
	return angle < checkAngle
end

function BehaviorFunctions.CheckEntityAngleRange(instanceId,targetInstanceId,beginAngle,endAngle)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)

	local entityForward = entity.transformComponent.rotation * Vec3.forward
	local pos1 = entity.transformComponent.position
	local pos2 = targetEntity.transformComponent.position
	local x = pos2.x - pos1.x
	local z = pos2.z - pos1.z
	local targetEntityForward = Quat.LookRotationA(x,0,z) * Vec3.forward

	local angle = Vec3.Angle(entityForward, targetEntityForward)
    local normal = Vec3.Cross(entityForward, targetEntityForward)
	if normal.y <= 0 then
		angle = 360 - angle
	end

	return angle >= beginAngle and angle <= endAngle
end

function BehaviorFunctions.AddEntitySign(instanceId,sign,lastFrame,ignoreTimeScale)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	lastFrame = lastFrame or -1
	if entity then
		entity:AddSignState(sign,lastFrame,ignoreTimeScale)
	end
end

function BehaviorFunctions.AddEntitySignRecord(fromType, instanceId,sign,lastFrame,ignoreTimeScale)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	lastFrame = lastFrame or -1
	if entity then
		entity:AddEntitySignRecord(fromType, sign, lastFrame, ignoreTimeScale)
	end
end

function BehaviorFunctions.AddEntityMagicRecord(fromType, instanceId, magicId, lev)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity:AddEntityMagicRecord(fromType, magicId, lev)
	end
end

function BehaviorFunctions.RemoveEntitySignRecord(fromType, instanceId, sign)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity:RemoveEntitySignRecord(fromType, sign)
	end
end

function BehaviorFunctions.RemoveEntityMagicRecord(fromType, instanceId, magicId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity:RemoveEntityMagicRecord(fromType, magicId)
	end
end

function BehaviorFunctions.RemoveEntitySign(instanceId,sign)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity:RemoveSignState(sign)
	end
end

function BehaviorFunctions.HasEntitySign(instanceId,sign)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		return entity:HasSignState(sign)
	end
	return false
end

function BehaviorFunctions.CopyEntitySign(formInstanceId,toInstanceId,sign)
	local formEntity = BehaviorFunctions.GetEntity(formInstanceId)
	local toEntity = BehaviorFunctions.GetEntity(toInstanceId)
	if formEntity and toEntity then
		local signInfo = formEntity:GetSignInfo(sign)
		if not signInfo then
			LogError(" sign is nil, formInstanceId = "..formInstanceId.." sign = "..sign)
		end
		toEntity:AddSignState(sign,signInfo.lastFrame,signInfo.ignoreTimeScale)
	end
end

--#region 指引
function BehaviorFunctions.SetGuideShowState(type, state)
	EventMgr.Instance:Fire(EventName.SetForceGuideState, type, state)
end

function BehaviorFunctions.SetGuideTask(taskId)
	mod.TaskCtrl:SetGuideTaskId(taskId)
end

function BehaviorFunctions.GetGuideTaskPosition()
	return mod.TaskCtrl:GetGuideTaskPosition()
end

function BehaviorFunctions.GetGuideTaskId()
	return mod.TaskCtrl:GetGuideTaskId()
end

function BehaviorFunctions.SetTaskGuideEntity(taskId, instanceId, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
	BehaviorFunctions.fight.taskManager:GuideTaskEntity(taskId, instanceId, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
end

function BehaviorFunctions.SetTaskGuideEco(taskId, ecoId, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
	BehaviorFunctions.fight.taskManager:GuideTaskEco(taskId, ecoId, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
end

function BehaviorFunctions.SetTaskGuidePosition(taskId, position, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
	--临时修改
	local callback = function()
		BehaviorFunctions.fight.taskManager:GuideTaskPosition(taskId, position, desc, radius, bindTaskPathTrace, isPathTrace, pathUnloadDis)
	end
	LuaTimerManager.Instance:AddTimer(1, 0.4, callback)
end

function BehaviorFunctions.AddEntityGuidePointer(instanceId, guideType, offsetY, hideOnSee,radius)
	local guideIndex
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		local setting = { offsetY = offsetY, hideOnSee = hideOnSee ,radius = radius}
		guideIndex = Fight.Instance.clientFight.fightGuidePointerManager:AddGuideEntity(entity, setting, guideType)
	end

	return guideIndex
end

function BehaviorFunctions.RemoveEntityGuidePointer(guideIndex)
	if ctx then
		Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(guideIndex)
	end
end

function BehaviorFunctions.AddNavGuidePointer(targetPos, checkPoints, diff, guideType, offsetY, hideOnSee, radius)
	local setting = { offsetY = offsetY, hideOnSee = hideOnSee ,radius = radius }
	local extraSetting = { guideType = guideType }
	BehaviorFunctions.fight.clientFight.fightGuidePointerManager:AddGuidePositionWithNav(targetPos, setting, extraSetting, checkPoints, diff)
end

function BehaviorFunctions.RemoveNavGuidePointer()
	BehaviorFunctions.fight.clientFight.fightGuidePointerManager:RemoveNavGuide()
end

function BehaviorFunctions.GetNavGuidePointerIndex()
	return BehaviorFunctions.fight.clientFight.fightGuidePointerManager:GetNavGuideIndex()
end

-- 设置左侧任务指引距离显示
function BehaviorFunctions.SetTaskGuideDisState(state)
	if ctx then
		EventMgr.Instance:Fire(EventName.SetTaskGuideDisState, state)
	end
end

--#endregion

function BehaviorFunctions.Probability(num)
	return num > math.random(1,10000)
end

function BehaviorFunctions.GetDodgeLimitState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.dodgeComponent:GetLimitState()
end

function BehaviorFunctions.SetDodgeLimitState(instanceId,limitState)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.dodgeComponent:SetLimitState(limitState)
end

function BehaviorFunctions.SetDodgeCoolingTime(instanceId,nowCoolingTime,maxCoolingTime)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.dodgeComponent:SetLimitCoolingTime(nowCoolingTime,maxCoolingTime)
end

function BehaviorFunctions.GetQTEEntity(index)
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetQTEEntity(index)
end

function BehaviorFunctions.SetQTEEntity(index,instanceId)
	return BehaviorFunctions.fight.playerManager:GetPlayer():SetQTEEntity(index,instanceId)
end

function BehaviorFunctions.GetEntityQTEIndex(instanceId)
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetEntityQTEIndex(instanceId)
end

function BehaviorFunctions.GetQTEState(index,type)
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetState(index,type)
end

function BehaviorFunctions.CheckQTEState(index,type,state)
	return BehaviorFunctions.fight.playerManager:GetPlayer():CheckState(index,type,state)
end

function BehaviorFunctions.SetQTEState(index,type,state)
	return BehaviorFunctions.fight.playerManager:GetPlayer():SetQTEState(index,type,state)
end

function BehaviorFunctions.SetQTETime(index,type,time)
	return BehaviorFunctions.fight.playerManager:GetPlayer():SetTime(index,type,time)
end

function BehaviorFunctions.AddQTETime(index,type,time)
	return BehaviorFunctions.fight.playerManager:GetPlayer():AddTime(index,type,time)
end

function BehaviorFunctions.GetQTETime(index, type)
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetTime(index, type)
end

function BehaviorFunctions.SetEntityBackState(instanceId,state)
	BehaviorFunctions.fight.playerManager:GetPlayer():SetBackState(instanceId,state)
end

function BehaviorFunctions:GetInstanceIdByHeroId(heroId)
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetInstanceIdByHeroId(heroId)
end

function BehaviorFunctions:GetHeroIdByInstanceId(instanceId)
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetHeroIdByInstanceId(instanceId)
end

function BehaviorFunctions.CheckEntityForeground(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent.backstage == FightEnum.Backstage.Foreground
end

function BehaviorFunctions.SetCtrlEntity(instanceId)
	local curInstanceId = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(curInstanceId)
	entity.clientTransformComponent:SetMainRole(false)
	BehaviorFunctions.fight.playerManager:GetPlayer():SetCtrlEntity(instanceId)
	entity = BehaviorFunctions.GetEntity(instanceId)
	entity.clientTransformComponent:SetMainRole(true)
	BehaviorFunctions.SetJoyMoveEnable(instanceId, true)
end

function BehaviorFunctions.GetCtrlEntity()
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
end

function BehaviorFunctions.ExitLevel(result)
	Fight.Instance:SetFightState(FightEnum.FightState.Exit)
end

function BehaviorFunctions.SetDuplicateResult(result, isQuit)
	if not BehaviorFunctions.CheckIsInDup() then 
		return 
	end
	BehaviorFunctions.fight.duplicateManager:FinishedDuplicate(result, isQuit)
end

--该接口已弃用，可改成SetDuplicateResult
function BehaviorFunctions.ResDuplicateResult(result)
	--这里加个保底措施，防止出现在同一个副本中set为false 又set为true的情况
	local lastResult = mod.DuplicateCtrl:GetDupResult()
	if lastResult ~= FightEnum.FightResult.None then
		return
	end

	local fightResult = result and FightEnum.FightResult.Win or FightEnum.FightResult.Lose
	mod.DuplicateCtrl:SetDupResult(fightResult)
	if ctx then
		if result then
			mod.ResDuplicateCtrl:ResDuplicateFinish()
		else
			WindowManager.Instance:OpenWindow(WorldFailWindow, {true})
		end
	end
end

function BehaviorFunctions.UseRenderHeight(instanceId,flag)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		entity.clientTransformComponent:UseRenderHeight(flag)
	end
end

function BehaviorFunctions.CheckBuffState(instanceId,state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.buffComponent:CheckState(state)
end

function BehaviorFunctions.CheckBuffStates(instanceId,...)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.buffComponent:CheckStates(...)
end

function BehaviorFunctions.CheckIsDebuff(entityInstanceId, buffInstanceId)
	local entity = BehaviorFunctions.GetEntity(entityInstanceId)
	if not entity and buffInstanceId then
		return false
	end

	local buff = entity.buffComponent:GetBuff(buffInstanceId)
	if not buff or not buff.config.EffectType then
		return false
	end

	return buff.config.EffectType == FightEnum.BuffEffectType.ValueDebuff or buff.config.EffectType == FightEnum.BuffEffectType.EffectDebuff
end

function BehaviorFunctions.CheckIsDebuffByID(entityId, buffId, kind)
	local buffConfig = MagicConfig.GetBuff(buffId, entityId, kind)
	if not buffConfig or not buffConfig.EffectType then
		return false
	end

	return buffConfig.EffectType == FightEnum.BuffEffectType.ValueDebuff or buffConfig.EffectType == FightEnum.BuffEffectType.EffectDebuff
end

function BehaviorFunctions.CheckIsBuffByID(entityId, buffId, kind)
	local buffConfig = MagicConfig.GetBuff(buffId, entityId, kind)
	if not buffConfig or not buffConfig.EffectType then
		return false
	end

	return buffConfig.EffectType == FightEnum.BuffEffectType.ValueBuff or buffConfig.EffectType == FightEnum.BuffEffectType.EffectBuff
end

function BehaviorFunctions.HasBuffEffectKind(instanceId, effectKind)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.buffComponent then
		return false
	end

	return entity.buffComponent:CheckBuffEffectKind(effectKind)
end

function BehaviorFunctions.GetBuffEffectType(entityInstanceId, buffInstanceId)
	local entity = BehaviorFunctions.GetEntity(entityInstanceId)
	if not entity and buffInstanceId then
		return
	end

	local buff = entity.buffComponent:GetBuff(buffInstanceId)
	if not buff or not buff.config.EffectType then
		return
	end

	return buff.config.EffectType
end

function BehaviorFunctions.GetBuffEffectTypeByID(entityId, buffId, kind)
	local buffConfig = MagicConfig.GetBuff(buffId, entityId, kind)
	if not buffConfig or not buffConfig.EffectType then
		return
	end

	return buffConfig.EffectType
end

function BehaviorFunctions.ActiveUI(activeType,flag)
	if ctx then
		EventMgr.Instance:Fire(EventName.ActiveView, activeType, flag)
	end
end

function BehaviorFunctions.OpenRemoteDialog(dialogId, isHideMain)
	if ctx then
		--EventMgr.Instance:Fire(EventName.OpenRemoteDialog, dialogId, isHideMain)
	end
end

function BehaviorFunctions.OpenTalkDialog(dialogId)
	if ctx then
		EventMgr.Instance:Fire(EventName.OpenTalkDialog, dialogId)
	end
end

function BehaviorFunctions.CancelJoystick()
	if ctx then
		EventMgr.Instance:Fire(EventName.CancelJoystick)
	end
end

function BehaviorFunctions.InteractTrigger(flag,icon,x,y,scale,cdTime)
	if ctx then
		EventMgr.Instance:Fire(EventName.ActiveInteract, flag, icon, x, y, scale, cdTime)
	end
end

-- BehaviorFunctions.AddBuff(1,4,1000004)
-- BehaviorFunctions.RemoveBuff(2,1000015)
function BehaviorFunctions.AddBuff(instanceId,targetInstanceId,buffId,buffLev,kind, ignoreTimeScale)
	local relEntity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not targetEntity or not targetEntity.buffComponent then
		return
	end

	local buff = targetEntity.buffComponent:AddBuff(relEntity,buffId,buffLev, nil, kind, nil, ignoreTimeScale)
	if buff then
		return buff.instanceId
	else
		return
	end
end

function BehaviorFunctions.AddPlayerBuff(instanceId, buffId, buffLev)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	player.fightPlayer:AddBuff(instanceId, buffId, buffLev)
end

function BehaviorFunctions.RemovePlayerBuff(buffId)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	player.fightPlayer:RemoveBuff(buffId)
end

function BehaviorFunctions.GetBuffTime(targetInstanceId, buffInstanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	return targetEntity.buffComponent:GetBuffTime(buffInstanceId)
end

function BehaviorFunctions.GetBuffCount(instanceId, buffId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.buffComponent then
		return 0
	end

	return entity.buffComponent:GetBuffCount(buffId)
end

function BehaviorFunctions.ResetBuff(targetInstanceId, buffId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	return targetEntity.buffComponent:ResetBuff(buffId)
end

function BehaviorFunctions.ResetBuffByGroup(targetInstanceId, groupId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	return targetEntity.buffComponent:ResetBuffByGroup(groupId)
end

function BehaviorFunctions.ResetBuffByKind(targetInstanceId, kind)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	return targetEntity.buffComponent:ResetBuffByKind(kind)
end

function BehaviorFunctions.SetBuffTimeByGroup(targetInstanceId, groupId,frame)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	return targetEntity.buffComponent:SetBuffTimeByGroup(groupId,frame)
end

function BehaviorFunctions.SetBuffTimeByKind(targetInstanceId, kind,frame)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	return targetEntity.buffComponent:SetBuffTimeByKind(kind,frame)
end

function BehaviorFunctions.RemoveBuff(instanceId,buffId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.buffComponent then
		return
	end
	entity.buffComponent:RemoveBuffByBuffId(buffId)
end

function BehaviorFunctions.RemoveBuffByGroup(instanceId,groupId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	entity.buffComponent:RemoveBuffByGroup(groupId)
end

function BehaviorFunctions.RemoveBuffByKind(instanceId,kind)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	entity.buffComponent:RemoveBuffByKind(kind)
end

--BehaviorFunctions.SetBuffEffectIgnoreTimeScale(4, 1002016, true, 1)
function BehaviorFunctions.SetBuffEffectIgnoreTimeScale(instanceId, buffId, ignoreTimeScale, timeScale)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local buffs = entity.buffComponent:GetBuffByBuffId(buffId) or {}
	for key, buff in pairs(buffs) do
		entity.clientEntity.clientBuffComponent:SetIgnoreTimeScale(buff, ignoreTimeScale, timeScale)
	end
end

function BehaviorFunctions.SetEntityValue(instanceId,key,value)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.values[key] = value
	
	--EventMgr.Instance:Fire(EventName.EntityValueChange, instanceId, key, value)
end

function BehaviorFunctions.GetEntityValue(instanceId,key)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	
	return entity.values[key]
end

function BehaviorFunctions.SetFightUITarget(instanceId)
	if ctx then
		EventMgr.Instance:Fire(EventName.TargetUpdate, instanceId)
	end
end

function BehaviorFunctions.SetFightMainNodeVisible(opType, node, visible, priority)
	if ctx then
		EventMgr.Instance:Fire(EventName.SetNodeVisible, opType, node, visible, priority)
	end
end

function BehaviorFunctions.StopSetFightMainNodeVisible(node, priority)
	if ctx then
		EventMgr.Instance:Fire(EventName.SetNodeVisible, FightEnum.BehaviorUIOpType.level, node, false, priority, true)
	end
end

function BehaviorFunctions.SetPlayerCoreVisible(instanceId, visible)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		EventMgr.Instance:Fire(EventName.SetCoreVisible, entity.entityId, visible)
	end
end


function BehaviorFunctions.SetPlayerCoreEffectVisible(name, visible)
	if ctx then
		EventMgr.Instance:Fire(EventName.SetCoreEffectVisible, name, visible)
	end
end

function BehaviorFunctions.GetFightUISkillBtnId(instanceId, keyEvent)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local skillId = entity.skillSetComponent:GetSkillIdByKeyEvent(keyEvent)
	return skillId
end

function BehaviorFunctions.CheckSkillBehaviorConfig(instanceId, skillId, behaviorType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:CheckSkillBehaviorConfig(skillId, behaviorType)
end

function BehaviorFunctions.SetSkillBehaviorConfig(instanceId, skillId, behaviorType, value)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.skillSetComponent then
		local isExist, oldValue = entity.skillSetComponent:CheckSkillBehaviorConfig(skillId, behaviorType)
		if isExist and oldValue == value then
			return
		elseif not isExist and value == nil then
			return
		end
		entity.skillSetComponent:SetSkillBehaviorConfig(skillId, behaviorType, value)
	end
end

function BehaviorFunctions.SetFightUISkillBtnId(instanceId, keyEvent, skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:SetSkillBtnId(keyEvent, skillId)
end

--key可以是skillId或者keyEvent
function BehaviorFunctions.SetFightUISkillBtnIcon(instanceId, key, skillIcon)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity.skillSetComponent:SetSkillBtnIcon(key, skillIcon)
	end
end

function BehaviorFunctions.ChangeSkillTemplate(instanceId ,skillId, index)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:ChangeSkillTemplate(skillId, index)
end

--BehaviorFunctions.RelevanceEntitySkill(2, 3, FightEnum.KeyEvent.NormalSkill, FightEnum.KeyEvent.NormalSkill)
function BehaviorFunctions.RelevanceEntitySkill(instanceId, targetInstanceId, keyEvent, key)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.skillSetComponent then
		entity.skillSetComponent:RelevanceSkill(targetInstanceId, keyEvent, key)
	end
end

--BehaviorFunctions.CancelRelevanceEntitySkill(2, FightEnum.KeyEvent.NormalSkill)
function BehaviorFunctions.CancelRelevanceEntitySkill(instanceId, keyEvent, targetInstanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.skillSetComponent then
		entity.skillSetComponent:CancelRelevanceSkill(targetInstanceId, keyEvent)
	end
end

function BehaviorFunctions.SetSkillBaseInfo(instanceId, skillId, useCostType, useCostValue, maxChargeTimes, maxCDtime)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:SetSkillBaseInfo(skillId, useCostType, useCostValue, maxChargeTimes, maxCDtime)
end

function BehaviorFunctions.DisableSkillButton(instanceId, key, disable)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:DisableButton(key, disable)
end

function BehaviorFunctions.DisableAllSkillButton(instanceId, disable)
	local entity = BehaviorFunctions.GetEntity(instanceId)

	entity.skillSetComponent:DisableAllButton(disable)
end

function BehaviorFunctions.CheckBtnUseSkill(instanceId, key, isIgnoreCostCheck)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:CheckUseSkill(key, true, isIgnoreCostCheck)
end

function BehaviorFunctions.GetBtnSkillCostType(instanceId, skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:GetSkillCostType(skillId)
end

--isIgnoreCost 是否忽略扣除资源 只计算CD
function BehaviorFunctions.CastSkillCost(instanceId, key, isIgnoreCost)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:CastSkillCost(key, isIgnoreCost)
end

-- 限时触发CD
function BehaviorFunctions.SetSkillTriggerLimitTime(instanceId, keyEvent, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	entity.skillSetComponent:SetSkillTriggerLimitTime(keyEvent, time)
end

function BehaviorFunctions.SetSkillCoolTime(instanceId, keyEvent, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	entity.skillSetComponent:SetSkillCoolTime(keyEvent, time)
end

function BehaviorFunctions.SetBtnSkillCDTime(instanceId, keyEvent, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity.skillSetComponent:SetBtnSkillCDTime(keyEvent, time)
	end
end

function BehaviorFunctions.ChangeBtnSkillCDTime(instanceId, keyEvent, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:ChangeBtnSkillCDTime(keyEvent, time)
end

function BehaviorFunctions.GetBtnSkillCD(instanceId, keyEvent)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:GetBtnSkillCD(keyEvent)
end

function BehaviorFunctions.ChangeChargeCdTime(instanceId, keyEvent, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:ChangeChargeCD(keyEvent, time)
end

function BehaviorFunctions.SetChargeCd(instanceId, keyEvent, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:SetChargeCD(keyEvent, time)
end

function BehaviorFunctions.SetChargePoint(instanceId, keyEvent, addValue)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:SetChargePoint(keyEvent, addValue)
end

function BehaviorFunctions.ChangeChargePoint(instanceId, keyEvent, value)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:ChangeChargePoint(keyEvent, value)
end

function BehaviorFunctions.CancelChargeChange(instanceId, keyEvent)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:CancelChargeChange(keyEvent)
end

function BehaviorFunctions.CreateBehavior(name,parentBehavior)
	return Fight.Instance.entityManager:CreateBehavior(name,parentBehavior)
	-- return BehaviorFunctions.fight.behaviorMgr:CreateBehavior(name,parentBehavior)
end

function BehaviorFunctions.ChangeEntityAttr(instanceId, attrType, attrValue)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.attrComponent:AddValue(attrType, attrValue)
end

function BehaviorFunctions.SetEntityAttr(instanceId, attrType, attrValue, attrGroupType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.attrComponent:SetValue(attrType, attrValue, attrGroupType)
end

function BehaviorFunctions.GetEntityAttrVal(instanceId,attrType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.attrComponent:GetValue(attrType)
end

function BehaviorFunctions.GetEntityAttrValueRatio(instanceId,attrType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local attrVal = entity.attrComponent:GetValueRatio(attrType)
	return attrVal
end

function BehaviorFunctions.RandomSelect(...)
	local args = {...}
	local r = math.random(1,#args)
	return args[r]
end

function BehaviorFunctions.RandomFunction(...)
	local args = {...}
	local r = math.random(1,#args)
	return args[r]()
end

function BehaviorFunctions.RandomFunctionWithParms(...)
	local args = {...}
	local r = math.random(1,#args)
	local parms = args[r][3]
	if args[r][2] == BehaviorFunctions then
		return args[r][1](table.unpack(parms))
	end
	return args[r][1](args[r][2],table.unpack(parms))
end


function BehaviorFunctions.GetEntityTemplateId(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.entityId
end

function BehaviorFunctions.PlayFightUIEffect(effectName, parentName, uiContainName, followEntityId)
	if DebugClientInvoke.Cache.closeUI == true then
		return
	end
	if ctx then
		EventMgr.Instance:Fire(EventName.MainPanelPlayEffect, effectName, parentName, nil, nil, nil, uiContainName, 1, followEntityId)
	end
end

function BehaviorFunctions.StopFightUIEffect(effectName, parentName, uiContainName)
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		return
	end
	if ctx then
		EventMgr.Instance:Fire(EventName.MainPanelStopEffect, effectName, parentName, uiContainName)
	end
end

function BehaviorFunctions.PlaySkillUIEffect(effectName, btnName, isLoop)
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		return
	end
	if ctx then
		EventMgr.Instance:Fire(EventName.PlaySkillUIEffect, effectName, btnName, isLoop)
	end
end

function BehaviorFunctions.StopSkillUIEffect(effectName, btnName)
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		return
	end
	if ctx then
		EventMgr.Instance:Fire(EventName.StopSkillUIEffect, effectName, btnName)
	end
end

function BehaviorFunctions.GetMoveSignedAngle()
	if not BehaviorFunctions.CheckMove() then
		return 0
	end
	local x, y = BehaviorFunctions.GetMove()
	local forward1 = Vec3.New(x,0,y)
	local entity = BehaviorFunctions.GetEntity(BehaviorFunctions.GetCtrlEntity())
	local forward2 = entity.transformComponent.rotation * Vec3.forward
	local angle = Vector3.SignedAngle(forward2,forward1,Vector3.up)

	if angle<0 then
		angle = angle + 360
	end
	return angle
end

function BehaviorFunctions.GetAngleBetweenEntityRot(instanceId, targetInstanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local target = BehaviorFunctions.GetEntity(targetInstanceId)
	if not entity or not target then
		return
	end

	local sForward = entity.transformComponent:GetRotation() * Vec3.forward
	local tForward = target.transformComponent:GetRotation() * Vec3.forward
	local angle = Vector3.Angle(tForward, sForward, Vec3.up)
	if angle < 0 then
		angle = angle + 360
	end
	return angle
end

function BehaviorFunctions.SetSceneCameraLock(cvcName, instanceId)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		BehaviorFunctions.fight.clientFight.clientMap:SetCameraLockAt(cvcName,entity)
	end
end

function BehaviorFunctions.ClientEffectRelation(instanceId, instanceId1, selfTransformName, instanceId2, targetTransformName, radius)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		local entity1 = BehaviorFunctions.GetEntity(instanceId1)
		local entity2 = BehaviorFunctions.GetEntity(instanceId2)
		entity.clientTransformComponent:RelationEntity(entity1, selfTransformName, entity2, targetTransformName, radius)
	end
end

function BehaviorFunctions.ClientEffectRemoveRelation(instanceId)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		entity.clientTransformComponent:RemoveRelationEntity()
	end
end

function BehaviorFunctions.SetPlayerBorn(posX, posY, posZ)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	player:SetPlayerBorn(posX, posY, posZ)
end

function BehaviorFunctions.SyncCameraPosByPlayerPos()
	local player = Fight.Instance.playerManager:GetPlayer()
	local entity = player:GetCtrlEntityObject()
	local position = entity.transformComponent.position

	local cameraManager = BehaviorFunctions.fight.clientFight.cameraManager
	cameraManager:SetCameraPosition(position.x,position.y,position.z)
end

-- TODO 无用预设，策划修改后删除
function BehaviorFunctions.ShowCoopDisplayPanel(main, sub, blurRadius)
	LogError("接口BehaviorFunctions.ShowCoopDisplayPanel已弃用")
	-- if ctx then
	-- 	local mainEntity = BehaviorFunctions.GetEntity(main)
	-- 	local subEntity = BehaviorFunctions.GetEntity(sub)
	-- 	EventMgr.Instance:Fire(EventName.ShowCoopDisplay, mainEntity.entityId, subEntity.entityId, blurRadius)
	-- end
end

function BehaviorFunctions.AddDelayCallByTime(time,obj,callback,...)
	return BehaviorFunctions.fight.behaviorDelayCallback:AddDelayCallByTime(time,obj,callback,...)
end

function BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	return BehaviorFunctions.fight.behaviorDelayCallback:AddDelayCallByFrame(frame,obj,callback,...)
end

function BehaviorFunctions.RemoveDelayCall(instanceId)
	BehaviorFunctions.fight.behaviorDelayCallback:RemoveDelayCall(instanceId)
end

function BehaviorFunctions.ResetDelayCallByTime(instanceId,time)
	BehaviorFunctions.fight.behaviorDelayCallback:ResetDelayCallByTime(instanceId,time)
end

function BehaviorFunctions.ResetDelayCallByFrame(instanceId,frame)
	BehaviorFunctions.fight.behaviorDelayCallback:ResetDelayCallByFrame(instanceId,frame)
end

function BehaviorFunctions.SetCameraNoise(cvcName, levelId)
	if ctx then
		local camera = BehaviorFunctions.fight.levelManager:GetSceneObject(cvcName)
		if camera then
			BehaviorFunctions.fight.clientFight.cameraManager:SetCameraNoise(camera)
		end
	end
end

function BehaviorFunctions.CheckLevelIsCreate(levelId)
	return BehaviorFunctions.fight.levelManager:CheckLevelIsCreateOrCreating(levelId)
end

function BehaviorFunctions.ConvertToP(x,y,z)
	return Vec3.New(x,y,z)
end

-- instanceId1父节点 instanceId2子节点
function BehaviorFunctions.EntityCombination(instanceId1, instanceId2, dmgParent)
	local entity1 = BehaviorFunctions.GetEntity(instanceId1)
	local entity2 = BehaviorFunctions.GetEntity(instanceId2)
	entity1.combinationComponent:SetCombinationChild(entity2, dmgParent)
	entity2.combinationComponent:SetCombinationParent(entity1, dmgParent)
end

-- instanceId1父节点 instanceId2子节点
function BehaviorFunctions.ClearEntityCombination(instanceId1, instanceId2)
	local entity1 = BehaviorFunctions.GetEntity(instanceId1)
	local entity2 = BehaviorFunctions.GetEntity(instanceId2)
	entity1.combinationComponent:RemoveCombination()
	entity2.combinationComponent:RemoveCombination()
end

function BehaviorFunctions.EntityCombinationIngParent(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.combinationComponent:CombinationIngParent()
end

function BehaviorFunctions.KeyAutoUp(key)
	if ctx then
		EventMgr.Instance:Fire(EventName.KeyAutoUp, key)
	end
end

function BehaviorFunctions.DeepCopyPosition(pos)
	return pos:Clone()
end

--#region 技能教学轴
function BehaviorFunctions.ShowSkillGuide(groupId, groupStep)
	if ctx then
		local skillGuideManager = BehaviorFunctions.fight.clientFight.skillGuideManager
		skillGuideManager:ShowGuide(groupId, groupStep)
	end
end

function BehaviorFunctions.StopSkillGuide()
	if ctx then
		local skillGuideManager = BehaviorFunctions.fight.clientFight.skillGuideManager
		skillGuideManager:StopGuide()
	end
end

function BehaviorFunctions.GetSkillGuideState()
	if ctx then
		local skillGuideManager = BehaviorFunctions.fight.clientFight.skillGuideManager
		return skillGuideManager:GetTotalState()
	end
end

function BehaviorFunctions.ResetSkillGuide()
	if ctx then
		local skillGuideManager = BehaviorFunctions.fight.clientFight.skillGuideManager
		skillGuideManager:ResetWindow()
	end
end

function BehaviorFunctions.GetSkillGuideCurStep()
	if ctx then
		local skillGuideManager = BehaviorFunctions.fight.clientFight.skillGuideManager
		skillGuideManager:GetCurStep()
	end
end

function BehaviorFunctions.ChangeStepState(state, index)
	if ctx then
		local skillGuideManager = BehaviorFunctions.fight.clientFight.skillGuideManager
		skillGuideManager:ChangeStepState(state, index)
	end
end
--#endregion

function BehaviorFunctions.ShowGuideImageTips(id, closeCallback)
	if ctx then
		BehaviorFunctions.fight.teachManager:BehaviorTriggerTeach(id, closeCallback)
	end
end

function BehaviorFunctions.CheckTeachIsFinish(teachId)
	return mod.TeachCtrl:CheckTeachIsFinish(teachId)
end

function BehaviorFunctions.InteractEntityHit(instanceId, ingoreRemove)
	EventMgr.Instance:Fire(EventName.EntityHit, instanceId, ingoreRemove)
end

function BehaviorFunctions.GetEntityEcoId(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end

	return entity.sInstanceId
end

function BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
	local entity = BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetEcoEntity(ecoId)
	if entity then
		return entity.instanceId
	end

	return
end

function BehaviorFunctions.GetTotalEntity()
	return BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetTotalEcoEntity()
end

function BehaviorFunctions.GetEcoEntityGroup(groupId, ecoId, instanceId)
	local entityManager = BehaviorFunctions.fight.entityManager.ecosystemEntityManager
	local instanceGroup = {}
	if groupId then
		instanceGroup = entityManager:GetEcoEntityGroup(groupId)
	elseif ecoId then
		instanceGroup = entityManager:GetEcoEntityGroupByEcoId(ecoId)
	elseif instanceId then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity and entity.sInstanceId then
			instanceGroup = entityManager:GetEcoEntityGroupByEcoId(entity.sInstanceId)
		end
	end

	return instanceGroup
end

-- LogTable("t", BehaviorFunctions.GetEcoEntityGroupMember(3002, 3))
-- LogTable("t", BehaviorFunctions.GetEcoEntityGroupMember(nil, nil, 400101001))
-- LogTable("t", BehaviorFunctions.GetEcoEntityGroupMember(3002, 3))
function BehaviorFunctions.GetEcoEntityGroupMember(groupId, type, ecoId, instanceId)
	local entityManager = BehaviorFunctions.fight.entityManager.ecosystemEntityManager
	local instanceGroup = {}
	if groupId and type then
		instanceGroup = entityManager:GetEcoEntityGroupMember(groupId, type)
	elseif ecoId then
		local ecoCfg, ecoType = entityManager:GetEcoEntityConfig(ecoId)
		instanceGroup = entityManager:GetEcoEntityGroupMember(ecoCfg.group[1], ecoType)
	elseif instanceId then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity and entity.sInstanceId then
			local ecoCfg, ecoType = entityManager:GetEcoEntityConfig(entity.sInstanceId)
			instanceGroup = entityManager:GetEcoEntityGroupByEcoId(ecoCfg.group[1], ecoType)
		end
	end

	return instanceGroup
end

function BehaviorFunctions.CheckEcoEntityGroup(ecoId)
	return BehaviorFunctions.fight.entityManager.ecosystemEntityManager:CheckEntityHasGroup(ecoId)
end

-- 用于查询生态实体的刷新状态
function BehaviorFunctions.CheckEntityEcoState(instanceId, ecoId)
	return BehaviorFunctions.fight.entityManager.ecosystemEntityManager:CheckEntityEcoState(instanceId, ecoId)
end

-- 查询生态实体的状态
function BehaviorFunctions.CheckEcoEntityState(ecoId, checkState)
	local state = BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetSysEntityState(ecoId)
	return state == checkState
end

-- 获得生态实体状态
function BehaviorFunctions.GetEcoEntityState(ecoId)
	return BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetSysEntityState(ecoId)
end

-- 设置生态实体状态
function BehaviorFunctions.SetEcoEntityState(ecoId, state)
	BehaviorFunctions.fight.entityManager.ecosystemEntityManager:SendSysEntityStateChange(ecoId, state)
end

-- 获取生态实体额外参数
function BehaviorFunctions.GetEcoEntityExtraParam(ecoId)
	local config = BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
	if not config then
		return
	end

	return config.param
end


function BehaviorFunctions.GetEcoEntityConfigByKey(ecoId, key)
	local config = BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
	if not config then
		return
	end

	return config[key]
end


function BehaviorFunctions.GetEcoEntityMovePathPoint(ecoId)
	local config = BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
	if not config then
		return
	end

	return config.move_path_points
end

function BehaviorFunctions.GetEcoEntityPatrolType(ecoId)
	local config = BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
	if not config then
		return
	end

	return config.patrol_type
end

function BehaviorFunctions.GetEcoEntityBindLevel(ecoId)
	local config = BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetEcoEntityConfig(ecoId)
	if not config then
		return
	end

	return config.level_id
end

-- 设置生态实体生成状态
function BehaviorFunctions.ChangeEcoEntityCreateState(ecoId, state, isNotCreateCtrl)
	BehaviorFunctions.fight.entityManager.ecosystemEntityManager:SetEcoEntitySvrCreateState(ecoId, state, isNotCreateCtrl)
end

function BehaviorFunctions.GetEntityItemInfo(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	return entity.itemInfo
end

function BehaviorFunctions.GetNpcId(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if BehaviorFunctions.fight.entityManager.npcEntityManager:CheckEntityIsNpc(instanceId) then
		return entity.sInstanceId
	end
end

-- LogTable("npc = ", BehaviorFunctions.GetNpcEntity(npcId))
-- 修改接口 不要直接使用entity TODO
function BehaviorFunctions.GetNpcEntity(npcId)
	return BehaviorFunctions.fight.entityManager.npcEntityManager:GetNpcEntity(npcId)
end

-- LogTable("Npc Extra Param = ", BehaviorFunctions.GetNpcExtraParam(npcId))
function BehaviorFunctions.GetNpcExtraParam(npcId)
	local config = BehaviorFunctions.fight.entityManager.npcEntityManager:GetNpcConfig(npcId)
	return config.param
end

function BehaviorFunctions.GetNpcDialogId(npcId)
	return BehaviorFunctions.fight.entityManager.npcEntityManager:GetNpcDialogId(npcId)
end

function BehaviorFunctions.GetNpcPlayingBubbleId(npcId)
	return BehaviorFunctions.fight.entityManager.npcEntityManager:GetNpcPlayingBubbleId(npcId)
end

function BehaviorFunctions.GetNpcBubbleId(npcId)
	return BehaviorFunctions.fight.entityManager.npcEntityManager:GetNpcBubbleId(npcId)
end

function BehaviorFunctions.ChangeNpcBubbleId(npcId, bubbleId)
	BehaviorFunctions.fight.entityManager.npcEntityManager:SetNpcBubbleId(npcId, bubbleId)
end

function BehaviorFunctions.ChangeNpcBubbleContent(instanceId, content, duration)
	BehaviorFunctions.fight.clientFight.headInfoManager:SetBubbleContent(instanceId, content, duration)
end

function BehaviorFunctions.ChangeHeadTipScale(instanceId, scale)
	BehaviorFunctions.fight.clientFight.headInfoManager:SetHeadTipScale(instanceId, scale)
end

function BehaviorFunctions.ChangeNpcHeadIcon(instanceId, icon)
	BehaviorFunctions.fight.clientFight.headInfoManager:SetHeadIcon(instanceId, icon)
end

function BehaviorFunctions.ChangeNpcDistanceThreshold(instanceId,arg0,arg1,arg2,arg3)
	BehaviorFunctions.fight.clientFight.headInfoManager:SetChangeDistanceThreshold(instanceId,arg0,arg1,arg2,arg3)
end

function BehaviorFunctions.ChangeNpcName(instanceId, name)
	BehaviorFunctions.fight.clientFight.headInfoManager:SetChangeName(instanceId, name)
end


function BehaviorFunctions.SetNonNpcBubbleVisible(instanceId, visible)
	BehaviorFunctions.fight.clientFight.headInfoManager:SetBubbleVisible(instanceId, visible)
end

function BehaviorFunctions.SetNpcBubbleVisible(npcId, visible)
	BehaviorFunctions.fight.entityManager.npcEntityManager:SetNpcBubbleVisible(npcId, visible)
end

function BehaviorFunctions.SetNpcHeadInfoVisible(npcId, visible)
	BehaviorFunctions.fight.entityManager.npcEntityManager:SetNpcHeadInfoVisible(npcId, visible)
end

function BehaviorFunctions.CheckNpcIsInTask(npcId)
	return BehaviorFunctions.fight.entityManager.npcEntityManager:CheckNpcIsInTask(npcId)
end

function BehaviorFunctions.GetNpcName(npcId)
	local npcConfig = BehaviorFunctions.fight.entityManager.npcEntityManager:GetNpcConfig(npcId)
	return npcConfig.name
end

function BehaviorFunctions.GetNpcConfigByKey(npcId, key)
	local npcConfig = BehaviorFunctions.fight.entityManager.npcEntityManager:GetNpcConfig(npcId)
	if not npcConfig then
		LogError("获取Npc配置失败！"..npcId)
		return
	end
	return npcConfig[key]
end

function BehaviorFunctions.WorldInteractActive(instanceId, type, icon, text, quality, count)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	return entity:AddInteractItem(type, icon, text, quality, count, instanceId)
end

-- 给不同的道具提供不同的icon 后续可能扩展name和quality
function BehaviorFunctions.WorldItemInteractActive(instanceId, itemId)
	local icon = ItemConfig.GetItemIcon(itemId)
	local itemCfg = ItemConfig.GetItemConfig(itemId)
	return BehaviorFunctions.WorldInteractActive(instanceId, WorldEnum.InteractType.Item, icon, itemCfg.name, itemCfg.quality, nil)
end

function BehaviorFunctions.WorldNPCInteractActive(instanceId, text)
	return BehaviorFunctions.WorldInteractActive(instanceId, WorldEnum.InteractType.Talk, nil, text, 1, nil)
end

function BehaviorFunctions.WorldInteractRemove(instanceId, uniqueId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	entity:RemoveInteractItem(uniqueId)
end

function BehaviorFunctions.ChangeWorldInteractInfo(instanceId, icon, desc)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.triggerComponent then
		return
	end

	entity.triggerComponent:ChangeDefaultInfo(icon, desc)
end

function BehaviorFunctions.SetEntityWorldInteractState(instanceId, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	entity:SetWorldInteractState(state)
end

-- params：新加参数列表，避免后期扩展参数过长
function BehaviorFunctions.AddLevel(levelId, taskId, preload, params)
	BehaviorFunctions.fight.levelManager:CreateLevel(levelId, taskId, preload, params)
end

function BehaviorFunctions.FinishLevel(levelId)
	BehaviorFunctions.fight.levelManager:FinishLevel(levelId)
end

function BehaviorFunctions.RemoveLevel(levelId)
	BehaviorFunctions.fight.levelManager:RemoveLevel(levelId)
end

function BehaviorFunctions.CreateDuplicate(systemDuplicateId)
	local dupCfg = Config.DataSystemDuplicateMain.Find[systemDuplicateId]
	if not dupCfg then
		LogError("缺少副本配置，系统副本id = "..systemDuplicateId)
		return
	end
	
	BehaviorFunctions.fight.duplicateManager:CreateDuplicate(systemDuplicateId)
end

function BehaviorFunctions.MoveTrackTarget(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject() 
	entity.moveComponent.moveComponent:SetTarget(player)
end

function BehaviorFunctions.SetEntityTrackTarget(instanceId, targetInstanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.fight.entityManager:GetEntity(targetInstanceId)
	if entity.moveComponent and entity.moveComponent.config.MoveType == FightEnum.MoveType.Track then
		entity.moveComponent.moveComponent:SetTarget(targetEntity)
	end
end

function BehaviorFunctions.SetEntityTrackPosition(instanceId, x, y, z)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if entity.moveComponent and entity.moveComponent.config.MoveType == FightEnum.MoveType.Track then
		entity.moveComponent.moveComponent:SetTrackPosition(x, y, z)
	end
end

-- 设置投掷自转角度
function BehaviorFunctions.SetEntitySelfRotateThrow(instanceId, x,y,z,originX,originY,originZ)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if entity.moveComponent then
		if  entity.moveComponent.config.MoveType ~= FightEnum.MoveType.Throw  then
			entity.moveComponent:ChangeMoveComponent(FightEnum.MoveType.Throw, {})
		end
		entity.moveComponent.moveComponent:SetSelfRotateSpeed(x,y,z,originX,originY,originZ)
	end
end

-- 矫正自转速度让目标在经过frame后到达给定角度
function BehaviorFunctions.SetEntitySelfRotateTargetThrow(instanceId,frame,targetX,targetY,targetZ)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if entity.moveComponent then
		if  entity.moveComponent.config.MoveType ~= FightEnum.MoveType.Throw  then
			entity.moveComponent:ChangeMoveComponent(FightEnum.MoveType.Throw, {})
		end
		entity.moveComponent.moveComponent:SetSelfRotateSpeedTarget(frame,targetX,targetY,targetZ)
	end
end

-- 连续追踪运动
function BehaviorFunctions.SetEntityContinuousTrackMove(targetId,pointList,startIndex,isloop,reachDis,cbEach)
	if next(pointList) then
			local targetPos = pointList[startIndex]
			if not targetPos then
					return
			end
			BehaviorFunctions.SetEntityMoveTrackThrow(targetId,targetPos,reachDis,function()
					local nextIndex = startIndex + 1
					if isloop then
							nextIndex = startIndex + 1 > TableUtils.GetTabelLen(pointList) and 1 or startIndex + 1
					end
					BehaviorFunctions.SetEntityContinuousTrackMove(targetId,pointList,nextIndex,isloop,reachDis,cbEach)

					if cbEach then
						cbEach(nextIndex)
					end
			end)
	end
end

-- 双点曲线运动
function BehaviorFunctions.SetEntityMoveCurveThrow(instanceId,startPos,ctrlPos,arg1,speed,frame,callback)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if entity.moveComponent then
		if  entity.moveComponent.config.MoveType ~= FightEnum.MoveType.Throw  then
			entity.moveComponent:ChangeMoveComponent(FightEnum.MoveType.Throw, {})
		end
		entity.moveComponent.moveComponent:SetMoveCurve(arg1,ctrlPos,startPos,speed,frame,callback)
	end
end

-- 单点追踪运动
function BehaviorFunctions.SetEntityMoveTrackThrow(instanceId,arg1,reachDistance,callback,enabltBounce,bounceLockTime,maxAngleY)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if entity.moveComponent then
		if  entity.moveComponent.config.MoveType ~= FightEnum.MoveType.Throw  then
			entity.moveComponent:ChangeMoveComponent(FightEnum.MoveType.Throw, {})
		end
		entity.moveComponent.moveComponent:SetMoveTrackTarget(arg1,reachDistance,callback,enabltBounce,bounceLockTime,maxAngleY)
	end
end

-- 单点追踪运动速度
function BehaviorFunctions.SetEntityMoveTrackThrowSpeed(instanceId,speed,rotateSpeed,SpeedCurveId,RotateSpeedCurveId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if entity.moveComponent then
		if  entity.moveComponent.config.MoveType ~= FightEnum.MoveType.Throw  then
			entity.moveComponent:ChangeMoveComponent(FightEnum.MoveType.Throw, {})
		end

		if SpeedCurveId or RotateSpeedCurveId then
			entity.moveComponent.moveComponent:SetTrackSpeedCurve(SpeedCurveId, RotateSpeedCurveId) 
		else
			entity.moveComponent.moveComponent:SetTrackSpeed(speed,rotateSpeed)
		end
	end
end

-- 单点圆形运动
function BehaviorFunctions.SetEntityMoveRoundThrow(instanceId,arg1,radius,speed,qut)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if entity.moveComponent then
		if  entity.moveComponent.config.MoveType ~= FightEnum.MoveType.Throw  then
			entity.moveComponent:ChangeMoveComponent(FightEnum.MoveType.Throw, {})
		end
		entity.moveComponent.moveComponent:SetMoveRound(arg1,radius,speed,qut)
	end
end


function BehaviorFunctions.ChangeToTrackMoveComponent(instanceId, speedCurveId, rotateSpeedCurveId, alwaysUpdateTargetPos, rotationLockInterval, rotationLockDelay)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	local config = {
		MoveType = FightEnum.MoveType.Track,
		SpeedCurveId = speedCurveId,
		RotateSpeedCurveId = rotateSpeedCurveId,
		AlwaysUpdateTargetPos = alwaysUpdateTargetPos,
		RotationLockInterval = rotationLockInterval,
		RotationLockDelay = rotationLockDelay
	}
	entity.moveComponent:ChangeMoveComponent(FightEnum.MoveType.Track, config)
end

function BehaviorFunctions.ResetMoveComponent(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	entity.moveComponent:ResetDefaultMoveComponent()
end

function BehaviorFunctions.SendGmExec(name, args)
	if ctx then
		mod.GmCtrl:ExecGmCommand(name, args)
	end
end

function BehaviorFunctions.Transport(mapId, x, y, z, rx, ry, rz, callback) --重载
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject() 
	local pos = player.transformComponent.position
	if (pos.x - x)^2 + (pos.y - y)^2 + (pos.z - z)^2 > 10000 then
		mod.WorldMapFacade:SendMsg("map_enter", mapId, x, y, z, rx, ry, rz)
		--暂停旁白
		BehaviorFunctions.StoryPauseDialog()
	else
		player.transformComponent:SetPosition(x, y, z)
		local rotX, rotY, rotZ, rotW = mod.WorldMapCtrl:GetCacheTpRotation()
		if rotX then
			player.rotateComponent:SetRotation(Quat.New(rotX, rotY, rotZ, rotW))
			CameraManager.Instance:SetCameraRotation(player.transformComponent.rotation)
		end
		
		mod.WorldMapCtrl:DoCacheEnterMapCallback()
	end
end

function BehaviorFunctions.InMapTransport(x, y, z, isReloadUI)
	mod.WorldCtrl:InMapTransport(nil, x, y, z, isReloadUI)
end

function BehaviorFunctions.IsEntityBackCombination(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	return entity.stateComponent.backstage == FightEnum.Backstage.Combination
end

-- 给一个实体创建头顶信息
function BehaviorFunctions.ShowCharacterHeadTips(instanceId, show)
	if ctx then
		if show then
			BehaviorFunctions.fight.clientFight.headInfoManager:ShowCharacterHeadTips(instanceId)
		else
			BehaviorFunctions.fight.clientFight.headInfoManager:HideCharacterHeadTips(instanceId)
		end
	end
end
-- 给一个实体创建头顶工作信息
function BehaviorFunctions.ShowWorkHeadTips(instanceId, show)
	if ctx then
		if show then
			return BehaviorFunctions.fight.clientFight.headInfoManager:ShowWorkHeadTips(instanceId)
		else
			BehaviorFunctions.fight.clientFight.headInfoManager:HideWorkHeadTips(instanceId)
		end
	end
end



-- 例子：(instacneId, 1, true, {"UITarget", "Textures/Icon/Single/Unlock/Unlock52.png"})
function BehaviorFunctions.ShowBindChildObj(instanceId, type, show, params)
	if ctx then
		if show then
			BehaviorFunctions.fight.clientFight.bindChildObjManage:ShowTypeObj(instanceId, type, params)
		else
			BehaviorFunctions.fight.clientFight.bindChildObjManage:HideTypeObj(instanceId, type)
		end
	end
end

function BehaviorFunctions.ShowAllHeadTips(show)
	if ctx then
		if show then
			BehaviorFunctions.fight.clientFight.headInfoManager:ShowAllHeadInfoObj()
		else
			BehaviorFunctions.fight.clientFight.headInfoManager:HideAllHeadInfoObj()
		end
	end
end

function BehaviorFunctions.HasAnimState(instanceId,stateName,layer)
	if ctx then
		local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
		if not entity then
			return false 
		end
		return entity.clientAnimatorComponent:IsLayerHasState(stateName, layer)
	end
end

function BehaviorFunctions.CheckAnimTime(instanceId,stateName,layer)
	if ctx then
		local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
		if not entity then
			return 
		end
		return entity.clientAnimatorComponent:GetAnimTime(stateName,layer)	
	end
end

function BehaviorFunctions.CheckAnimatorAnimFrame(instanceId, animName, frame)
	if ctx then
		local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
		local animationName = entity.animatorComponent:GetAnimationName()
		if animationName ~= animName then
			return false
		end

		local animator = entity.clientAnimatorComponent.animator
		return CustomUnityUtils.GetAnimatorCurFrame(animator) == frame
	end
end

function BehaviorFunctions.PlayAnimation(instanceId,name,layer,time)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		-- LogError("cant find instance = "..instanceId.." name = "..name)
		return
	end

	if layer then
		layer = entity.clientAnimatorComponent:GetLayerIndex(layer)
	else
		layer = 0
	end

	if entity.animatorComponent then
		entity.animatorComponent:PlayAnimation(name, time or 0, layer)
	end
end

function BehaviorFunctions.EnterAssetScene(assetId)
	mod.AssetPurchaseCtrl:GotoAsset(assetId)
end

function BehaviorFunctions.ExitAssetScene(assetId)
	mod.AssetPurchaseCtrl:LeaveAsset(assetId)
end

function BehaviorFunctions.GetPartnerAssetId()
	return mod.AssetPurchaseCtrl:GetCurAssetId()
end



function BehaviorFunctions.IsPause()
	if BehaviorFunctions.fight  then
		BehaviorFunctions.fight.pauseCount = BehaviorFunctions.fight.pauseCount or 0
		return BehaviorFunctions.fight.pauseCount > 0
	end
end

function BehaviorFunctions.Pause()
	if BehaviorFunctions.fight then
		local success =  BehaviorFunctions.fight:Pause()
		if not success then return false end
		BehaviorFunctions.StopGameTime(true)
		BehaviorFunctions.fight.clientFight.cameraManager:ResetNoiseVal()
		local clientEntites = BehaviorFunctions.fight.clientFight.clientEntityManager.clientEntites
		for k, v in pairs(clientEntites) do
			if v.clientAnimatorComponent then
				v.clientAnimatorComponent:SaveTimeScale()
				v.clientAnimatorComponent:SetTimeScale(0)
			end
			if v.clientBuffComponent then
				v.clientBuffComponent:SaveTimeScale()
				v.clientBuffComponent:SetTimeScale(0)
			end
			if v.clientTransformComponent then
				v.clientTransformComponent:SetTimeScale(0)
			end
		end

		-- TODO 临时处理 后续把透明度组件整合一下
		local instanceId = BehaviorFunctions.GetCtrlEntity()
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity then
			entity.clientTransformComponent:SetTranslucentPause(true)
			entity.values["tempPause"] = true
		end
		return true
	else
		return false
	end
end

function BehaviorFunctions.Resume()
	if BehaviorFunctions.fight then
		local success =  BehaviorFunctions.fight:Resume()
		if not success then return false end
		BehaviorFunctions.StopGameTime(false)
		local clientEntites = BehaviorFunctions.fight.clientFight.clientEntityManager.clientEntites
		for k, v in pairs(clientEntites) do
			if v.clientAnimatorComponent then
				v.clientAnimatorComponent:ResetTimeScale()
			end
			if v.clientBuffComponent then
				v.clientBuffComponent:ResetTimeScale()
			end
			if v.clientTransformComponent then
				v.clientTransformComponent:ResetTimeScale()
			end
		end
		local instanceId = BehaviorFunctions.GetCtrlEntity()
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity and entity.values["tempPause"] then
			entity.clientTransformComponent:SetTranslucentPause(false)
		end
	else
		return false
	end
end

function BehaviorFunctions.CheckTaskId(taskId)
	return mod.TaskCtrl.taskMap[taskId] ~= nil
end

function BehaviorFunctions.SetAimState(instanceId, aimState)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:SetAimState(aimState)
end

function BehaviorFunctions.GetAimState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM:GetState()
	end
	return 0
end

function BehaviorFunctions.AimStateEnd(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM:AimStateEnd()
	end
end

function BehaviorFunctions.CameraAimStart(instanceId, ctX, ctY, ctZ)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM:CameraAimStart(ctX, ctY, ctZ)
	end
end

function BehaviorFunctions.CameraAimEnd(instanceId, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM:CameraAimEnd(time)
end

function BehaviorFunctions.SetAimLockTargetEnable(instanceId, enable)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM:SetLockTargetEnable(enable)
end

function BehaviorFunctions.SetAimPartDecSpeed(instanceId, isDecSpeed)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM:SetAimPartDecSpeed(isDecSpeed)
end

function BehaviorFunctions.StartNPCDialog(dialogId, instanceId)
	Story.Instance:AddStoryCommand(dialogId, false, instanceId)
end

function BehaviorFunctions.StartStoryDialog(dialogId, bindingList, timeIn, timeOut, position, rotation, instanceId)
	Story.Instance:AddStoryCommand(dialogId, false, instanceId, bindingList, timeIn, timeOut, position, rotation)
end

function BehaviorFunctions.StoryPauseDialog()
	Story.Instance:Pause()
end

function BehaviorFunctions.StoryResumeDialog()
	Story.Instance:Resume()
end

function BehaviorFunctions.ForceExitStory()
	Story.StoryLog("强制退出剧情")
	if Story.Instance:GetStoryPlayState() then
		Story.Instance:ExitStory(true)
	else
		Story.Instance:ExitViewState()
	end
end

--开始短信
function BehaviorFunctions.StartMessage(messageId)
	mod.InformationCtrl:StartMessage(messageId)
end

function BehaviorFunctions.CheckEntityHeight(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.moveComponent.isAloft and entity.transformComponent.position then
		return Fight.Instance.physicsTerrain:CheckTerrainHeight(entity.transformComponent.position)
	end

	return 0
end

function BehaviorFunctions.SetAimIKAnimateDirection(instanceId, x, y, z)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local transform = entity.clientTransformComponent:GetTransform()
	CustomUnityUtils.SetAimAnimateDirection(transform, x,y,z)  
end


function BehaviorFunctions.CheckPosHeight(pos, layer)
	layer = layer or ~(FightEnum.LayerBit.IgnoreRayCastLayer | FightEnum.LayerBit.Entity |
		FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Area)
	local height, haveGround, checkLayer = Fight.Instance.physicsTerrain:CheckTerrainHeight(pos, nil, layer)
	if haveGround then
		return height, checkLayer
	end

	return nil, nil
end

function BehaviorFunctions.AddFightTarget(instanceId, targetInstanceId)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if player:IsMyEntity(targetInstanceId) then
		player.fightPlayer:AddFightTarget(instanceId)
	end
end

function BehaviorFunctions.RemoveFightTarget(instanceId, targetInstanceId)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if player:IsMyEntity(targetInstanceId) then
		player.fightPlayer:RemoveFightTarget(instanceId)
	end
end

function BehaviorFunctions.LeaveFighting()
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	player.fightPlayer:RemoveAllFightTarget()
end

function BehaviorFunctions.CheckPlayerInFight()
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player.fightPlayer:InFight()
end

function BehaviorFunctions.OpenWorldFailWindow(isDup)
	if ctx then
		WindowManager.Instance:OpenWindow(WorldFailWindow, {isDup})
	end
end

function BehaviorFunctions.GetStoryPlayState()
	return Story.Instance:GetStoryPlayState()
end

function BehaviorFunctions.GetNowPlayingId()
	return Story.Instance:GetNowPlayingId()
end

function BehaviorFunctions.SendTaskProgress(taskId, stepId, progressNum)
	if ctx then
		-- 做一个临时处理 写死序章的东西
		if taskId == 1010100 and stepId == 2 then
			CurtainManager.Instance:FadeIn(true, 0)
			LuaTimerManager.Instance:AddTimer(1, 2, function() CurtainManager.Instance:FadeOut(0.5) end)
		end
		Fight.Instance.taskManager.taskConditionManager:RemoveTimeAera(taskId)
		mod.TaskFacade:SendMsg("task_client_add_progress", taskId, stepId, progressNum)
	end
end

function BehaviorFunctions.ResetTaskProgress(taskId)
	if ctx then
		mod.TaskFacade:SendMsg("task_reset_progress", taskId)
	end
end

function BehaviorFunctions.CheckTaskIsFinish(taskId)
	return mod.TaskCtrl:CheckTaskIsFinish(taskId)
end

function BehaviorFunctions.CheckTaskStepIsFinish(taskId, stepId)
	return mod.TaskCtrl:CheckTaskStepIsFinish(taskId, stepId)
end

-- 检测任务是否在进行中
function BehaviorFunctions.CheckTaskIsInProgress(taskId)
	return mod.TaskCtrl:CheckTaskIsInProgress(taskId)
end

function BehaviorFunctions.CheckAreaIsInTask(areaId)
	local taskId = mod.TaskCtrl:GetAreaTask(areaId)
	return taskId ~= nil, taskId
end

function BehaviorFunctions.SetAnimationTranslate(instanceId, animNameFrom, animNameTo, layer)
	layer = layer or 0
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	entity.animatorComponent:SetAnimationTranslate(animNameFrom, animNameTo, layer)
end

function BehaviorFunctions.DoJump(instanceId)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity.moveComponent then
			return entity.moveComponent:StartJump(true)
		end
	end

	return false
end

function BehaviorFunctions.GetEntityJumpState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.stateComponent then
		return FightEnum.EntityJumpState.None
	end

	return entity.stateComponent:GetJumpState()
end

-- 发射移动子弹 AimShoot
function BehaviorFunctions.CreateAimEntity(entityId, instanceId, transformName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		local aimFSM = entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM
		return aimFSM:ShootMissile(entityId, transformName)
	end
end

function BehaviorFunctions.SkillCanFinish(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillComponent:CanFinish()
end

-- TODO 无用预设，策划修改后删除
function BehaviorFunctions.ShowWeakGuide(index, isHide)
	LogError("接口BehaviorFunctions.ShowWeakGuide已弃用")
	--EventMgr.Instance:Fire(EventName.ShowWeakGuide, index, isHide)
end

function BehaviorFunctions.ShowCommonTitle(type, title, default, icon)
	EventMgr.Instance:Fire(EventName.ShowCommonTitle, type, title, default, icon)
end

-- 显示倒计时UI，期间人物不能移动
function BehaviorFunctions.ShowCountDownPanel(second, id)
	EventMgr.Instance:Fire(EventName.AddSystemContent, FightCountDownPanel, {args = {second = second, id = id}})
end
function BehaviorFunctions.SetAimCameraLockTarget(instanceId)
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()

	local position = player.transformComponent.position
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local target
	if entity.partComponent then
		target = entity.partComponent:GetAimSearchTransform(position)
	else
		target = transform:Find("CameraTarget")
	end
	CameraManager.Instance:SetLockTarget(target)
end

function BehaviorFunctions.SetVCCameraBlend(name1, name2, time)
	CustomUnityUtils.SetVCCameraBlend(CameraManager.Instance.cinemachineBrain, name1, name2, time)
end

function BehaviorFunctions.CheckRoleExist(roleId)
	local roleData = mod.RoleCtrl:GetRoleData(roleId)
	if roleData and next(roleData) then
		return true
	end

	return false
end

function BehaviorFunctions.CheckRoleInCurFormation(roleId)
	local curFormation = mod.FormationCtrl:GetCurFormationInfo()
	for i = 1, #curFormation.roleList do
		local formationRole = type(curFormation.roleList[i]) == "number" and curFormation.roleList[i] or curFormation.roleList[i].id
		if formationRole == roleId then
			return true
		end
	end

	return false
end

-- LogTable("1", BehaviorFunctions.GetCurFormationEntities())
function BehaviorFunctions.GetCurFormationEntities()
	local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
	local instanceIdList = {}
	for k, v in pairs(entityList) do
		table.insert(instanceIdList, v.instanceId)
	end

	return instanceIdList
end

--#region TODO 临时
function BehaviorFunctions.UpdateCurFomration(roleList)
	mod.FormationCtrl:ReqFormationUpdate(0, roleList)
end

function BehaviorFunctions.GetCurFormationRoleList()
	return mod.FormationCtrl:GetCurFormationInfo()
end
--#endregion

-- 瞄准设置可移动
function BehaviorFunctions.AimSetCanMove(instanceId, canMove)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local aimFSM = entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM
	aimFSM:SetCanMove(canMove)
end

function BehaviorFunctions.GetCombinationTargetId(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.combinationComponent.combinationInsid
end

function BehaviorFunctions.SetAnimatorLayerWeight(instanceId, layer, from, to, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.clientEntity.clientAnimatorComponent:SetLayerWeight(layer, from, to, time)
end

function BehaviorFunctions.SetAimUIVisble(visible)
	EventMgr.Instance:Fire(EventName.SetNodeVisible, 0, "Aim", visible)
end

function BehaviorFunctions.ShowBlackCurtain(isShow, time, isWhite)
	if isShow then
		CurtainManager.Instance:FadeIn(not isWhite, time)
	else
		CurtainManager.Instance:FadeOut(time)
	end
end

function BehaviorFunctions.ChangeCurtainAlpha(value)
	CurtainManager.Instance:SetAlpha(value)
end

function BehaviorFunctions.OpenSceneMsgWindow(type, id)
	if type == SceneMsgConfig.MsgType.System then
		if not WindowManager.Instance:GetWindow("SceneMsgWindow") then
			WindowManager.Instance:OpenWindow(SceneMsgWindow, id)
		end
	end
end

function BehaviorFunctions.GetAttachLayer(instanceId, layer)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		return entity:CheckTriggerLayer(FightEnum.TriggerType.Terrain, layer) 
	end

	return false
end

function BehaviorFunctions.SetDodgeLimitTime(time)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	player.fightPlayer:SetDodgeLimitTime(time)
end

function BehaviorFunctions.CheckDodgeLimit()
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player.fightPlayer:InDodgeLimit()
end

function BehaviorFunctions.SetEntityShowState(instanceId, state)
	if not ctx then
		return
	end

	local entity = BehaviorFunctions.GetEntity(instanceId, state)
	if entity.clientTransformComponent then
		entity.clientTransformComponent:SetActive(state)
	end
end

function BehaviorFunctions.SetEntityLifeBarVisibleType(instanceId, visibleType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if ctx then
		if entity and entity.clientLifeBarComponent then
			entity.clientEntity.clientLifeBarComponent:SetLifeBarForceVisibleType(visibleType)
		end
	end
end

function BehaviorFunctions.SetAllEntityLifeBarVisibleType(visibleType)
	local entityInstances = BehaviorFunctions.fight.entityManager.entityInstances
	for i = 1, #entityInstances do
		if BehaviorFunctions.CheckEntity(entityInstances[i]) then
			BehaviorFunctions.SetEntityLifeBarVisibleType(entityInstances[i], visibleType)
		end
	end
end

function BehaviorFunctions.ShowEntityLifeBarElementBar(instanceId, show)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if ctx then
		if entity.clientLifeBarComponent then
			entity.clientEntity.clientLifeBarComponent:UpdateLifeBar(show)
		end
	end
end

function BehaviorFunctions.SetEntityLifeBarDelayDeathHide(instanceId, delay)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if ctx then
		if entity.clientLifeBarComponent then
			entity.clientEntity.clientLifeBarComponent:DelayDeathHide(delay)
		end
	end
end

function BehaviorFunctions.EnterEntityElementCoolingState(atkInstanceId, instanceId, coolingTime, element)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		entity.elementStateComponent:EnterCooling(coolingTime, element)
	end
end

function BehaviorFunctions.AllEntityEnterElementCoolingState(atkInstanceId, ignoreList, coolingTime, element)
	ignoreList = ignoreList or {}
	local num = #ignoreList
	local entityInstances = BehaviorFunctions.fight.entityManager.entityInstances
	for _, v in pairs(entityInstances) do
		for i = 1, num do
			if v == ignoreList[i] then 
				goto continue
			end
		end
		
		if BehaviorFunctions.CheckEntity(v) then
			local entity = BehaviorFunctions.GetEntity(v)
			if entity.elementStateComponent then
				entity.elementStateComponent:EnterCooling(coolingTime, element)
			end
		end
		::continue::
	end
end

function BehaviorFunctions.AddEntityElementCoolingTime(instanceId, time, element)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		entity.elementStateComponent:AddCoolingTime(time, element)
	end
end

function BehaviorFunctions.SetEntityElementReadyTime(instanceId, time, element)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		entity.elementStateComponent:SetReadyDurationTime(time, element)
	end
end

function BehaviorFunctions.AddEntityElementReadyTime(instanceId, time, element)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		entity.elementStateComponent:AddReadyDurationTime(time, element)
	end
end

function BehaviorFunctions.EnableEntityElementStateRuning(instanceId, state, enable, element)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		entity.elementStateComponent:EnableElementStateRuning(state, enable, element)
	end
end

function BehaviorFunctions.CheckEntityElementState(instanceId, state, element)
	if not state then
		return false
	end
	
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		return entity.elementStateComponent:CheckElementState(state, element)
	end
	
	return false
end

function BehaviorFunctions.GetEntityElementStateAccumulation(instanceId, element)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		return entity.elementStateComponent:GetAccumulationCount(element)
	end

	return 0, 0
end

function BehaviorFunctions.GetEntityElementStateAccumulationRatio(instanceId, element)
	local val, maxVal = BehaviorFunctions.GetEntityElementStateAccumulation(instanceId, element)
	if maxVal == 0 then
		return 0
	end
	return (val / maxVal) * 10000
end

function BehaviorFunctions.AddEntityElementStateAccumulation(atkInstanceId, instanceId, element, accumulation)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		entity.elementStateComponent:UpdateElementState(atkInstanceId, element, accumulation)
	end
end

function BehaviorFunctions.SetEntityElementStateAccumulation(atkInstanceId, instanceId, element, accumulation)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.elementStateComponent then
		local curCount = entity.elementStateComponent:GetAccumulationCount(element)
		entity.elementStateComponent:UpdateElementState(atkInstanceId, element, accumulation - curCount)
	end
end

function BehaviorFunctions.SetEntityElementStateIgnoreTimeScale(instanceId, ignore)
	if instanceId then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity.elementStateComponent then
			entity.elementStateComponent:SetIgnoreTimeScale(ignore)
		end
	else
		local entityInstances = BehaviorFunctions.fight.entityManager.entityInstances
		for _, v in pairs(entityInstances) do
			if BehaviorFunctions.CheckEntity(v) then
				local entity = BehaviorFunctions.GetEntity(v)
				if entity and entity.elementStateComponent then
					entity.elementStateComponent:SetIgnoreTimeScale(ignore)
				end
			end
		end
	end
end

function BehaviorFunctions.CallBehaviorFuncByEntity(instanceId, name,...)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.behaviorComponent:CallFunc(name, ...)
end

function BehaviorFunctions.CallBehaviorFuncByEntityEx(obj, name,...)
	obj[name](obj,...)
end

function BehaviorFunctions.CameraEntityLockTarget(instanceId, targetInstanceId,name)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if targetInstanceId then
		local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
		local targerTransform = targetEntity.clientTransformComponent
		entity.clientEntity.clientCameraComponent:SetLockTarget(targerTransform,name)
	else
		entity.clientEntity.clientCameraComponent:SetLockTarget(nil)
	end
	
end

function BehaviorFunctions.CameraEntityFollowTarget(instanceId, targetInstanceId, name)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if targetInstanceId then
		local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
		local targerTransform = targetEntity.clientTransformComponent
		entity.clientEntity.clientCameraComponent:SetFollowTarget(targerTransform,name)
	else
		entity.clientEntity.clientCameraComponent:SetFollowTarget(nil)
	end
	
end

function BehaviorFunctions.SetSceneObjectLoadPause(pause)
	-- SceneUnitManager.Instance:SetPause(pause)
end

function BehaviorFunctions.SetEcosystemEntityLoadPause(pause)
	if pause then
		BehaviorFunctions.fight.entityManager.ecosystemCtrlManager:Pause()
	else
		BehaviorFunctions.fight.entityManager.ecosystemCtrlManager:Resume()
	end

end

function BehaviorFunctions.PlaySound(soundName)
	SoundManager.Instance:PlaySound(soundName)
end

function BehaviorFunctions.PlayAmbSound(soundName)
	SoundManager.Instance:PlaySound(soundName,-1)
end

function BehaviorFunctions.StopAmbSound(soundName)
	SoundManager.Instance:UnLoadBankByEvent(soundName)
end


function BehaviorFunctions.GetStateSoundEventKey(mainStateID,subStateID)
	mainStateID = mainStateID or 0
	subStateID = subStateID or 0
	return (mainStateID * 10000) + subStateID
end

function BehaviorFunctions.DoEntityAudioPlay(instanceId, soundEvent, lifeBindEntity, soundSignType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	if entity.clientSoundComponent then	
		entity.clientEntity.clientSoundComponent:PlaySound(soundEvent, lifeBindEntity, soundSignType)
	end
end

function BehaviorFunctions.DoEntityAudioEvent(instanceId, eventType, soundSignType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	if entity.clientSoundComponent then		
		entity.clientEntity.clientSoundComponent:OnEvent(eventType, soundSignType)
	end
end



function BehaviorFunctions.DoEntityAudioStop(instanceId, soundEvent, delayTime, fadeOutTime)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	if entity.clientSoundComponent then		
		entity.clientEntity.clientSoundComponent:StopSound(soundEvent, delayTime, fadeOutTime)
	end
end

function BehaviorFunctions.PlayBgmSound(soundEvent)
	SoundManager.Instance:PlayBgmSound(soundEvent)
end

function BehaviorFunctions.StopBgmSound()
	SoundManager.Instance:StopBgmSound()
end

function BehaviorFunctions.PauseBgmSound()
	SoundManager.Instance:PauseBgmSound()
end

function BehaviorFunctions.ResumeBgmSound()
	SoundManager.Instance:ResumeBgmSound()
end

function BehaviorFunctions.FixVerticalAxisByTime(value,time)
	BehaviorFunctions.fight.clientFight.cameraManager:FixVerticalAxisByTime(value,time)
end


function BehaviorFunctions.ResetTimeAutoFixTime(isPause)
	BehaviorFunctions.fight.clientFight.cameraManager:ResetTimeAutoFixTime(isPause)
end

function BehaviorFunctions.PlayFightTargetArrowEffect(instanceId, play)
	if ctx then
		EventMgr.Instance:Fire(EventName.OnCastSkill, instanceId, play)
	end
end

function BehaviorFunctions.CheckFightTargetArrowEffect(instanceId)
	if ctx then
		local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
		if mainUI and mainUI.guidePanel.CheckFightTargetArrowEffect then
			return mainUI.guidePanel:CheckFightTargetArrowEffect(instanceId)
		end
	end
end

function BehaviorFunctions.SetWindowVisible(windowName, visible, args, isCache, ignorePause)
	if ctx then
		WindowManager.Instance:SetWindowVisible(windowName, visible, args, isCache, ignorePause)
	end
end

function BehaviorFunctions.GetCameraTransform()
	if ctx then
		local camera = BehaviorFunctions.fight.clientFight.cameraManager.mainCamera
		return camera.transform
	end
end

function BehaviorFunctions.GetEntityAnimationFrame(instanceId, animationName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.animatorComponent then
		return entity.animatorComponent:GetAnimationFrame(animationName)
	end
	
	return -1
end

function BehaviorFunctions.SetHeadIkVisible(instanceId, visible)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end

	entity.clientEntity.clientIkComponent:SetHeadIkVisible(visible)
end

function BehaviorFunctions.SetPathFollowPos(instanceId, pos,startOnGround)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity.findPathComponent then
		return
	end

	return entity.findPathComponent:SetPathFollowPos(pos,startOnGround)
end

function BehaviorFunctions.SetPathFollowEntity(instanceId, instanceId2)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.findPathComponent:SetPathFollowEntity(instanceId2)
end

function BehaviorFunctions.ClearPathFinding(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.findPathComponent then
		entity.findPathComponent:ClearPathFinding()
	end
end

function BehaviorFunctions.ForbidKey(keyCode, isFobid)
	BehaviorFunctions.fight.clientFight.inputManager:ForbidKey(keyCode, isFobid)
end

function BehaviorFunctions.SetCanCameraInput(canCameraInput)
	BehaviorFunctions.fight.clientFight.inputManager:SetCanCameraInput(canCameraInput)
end

function BehaviorFunctions.DoShowClickQTE(instanceId, prefab, icon, isShowCountDown, isShowProgress, anchorType,posX, posY, duration, times)
	return BehaviorFunctions.fight.clientFight.qteManager:ShowNewQTE(FightEnum.NewQTEType.Click, { instanceId = instanceId, prefab = prefab, icon = icon, isShowCountDown = isShowCountDown, isShowProgress = isShowProgress,
															anchorType = anchorType, posX = posX, posY = posY, duration = duration, times = times})
end

function BehaviorFunctions.DoShowResistQTE(instanceId, prefab, icon, anchorType, posX, posY, addSpeed, subSpeed, duration, addCurveId, subCurveId)
	return BehaviorFunctions.fight.clientFight.qteManager:ShowNewQTE(FightEnum.NewQTEType.Resist, { instanceId = instanceId, prefab = prefab, icon = icon, anchorType = anchorType, posX = posX, posY = posY,
				addSpeed = addSpeed, subSpeed = subSpeed, duration = duration, addCurveId = addCurveId, subCurveId = subCurveId})
end

function BehaviorFunctions.DoShowSectionQTE(instanceId, prefab, icon,anchorType , posX, posY, section, duration, addSpeed, targetProgress)
	return BehaviorFunctions.fight.clientFight.qteManager:ShowNewQTE(FightEnum.NewQTEType.Section, { instanceId = instanceId, prefab = prefab, icon = icon, anchorType = anchorType, posX = posX, posY = posY,
																			   section = section, duration = duration, addSpeed = addSpeed, targetProgress = targetProgress})
end

function BehaviorFunctions.DoShowHoldQTE(instanceId, prefab, icon, isShowProgress, anchorType, posX, posY, duration, holdTime)
	return BehaviorFunctions.fight.clientFight.qteManager:ShowNewQTE(FightEnum.NewQTEType.Hold, { instanceId = instanceId, prefab = prefab, icon = icon, isShowProgress= isShowProgress,
																			 anchorType = anchorType, posX = posX, posY = posY, duration = duration, holdTime = holdTime})
end

function BehaviorFunctions.DoShowScratchQTE(instanceId, prefab, icon, duration, anchorType, initX, initY, targetX, targetY, scratchType)
	return BehaviorFunctions.fight.clientFight.qteManager:ShowNewQTE(FightEnum.NewQTEType.Scratch, { instanceId = instanceId, prefab = prefab, icon = icon, duration= duration, anchorType = anchorType,
																				initX = initX, initY = initY, targetX = targetX, targetY = targetY, scratchType = scratchType})
end

function BehaviorFunctions.DoShowSwitchQTE(instanceId, duration)
	return BehaviorFunctions.fight.clientFight.qteManager:ShowNewQTE(FightEnum.NewQTEType.Switch, { instanceId = instanceId, duration = duration})
end

function BehaviorFunctions.DoShowDebuffQTE(instanceId, duration, buffType)
	return BehaviorFunctions.fight.clientFight.qteManager:ShowNewQTE(FightEnum.NewQTEType.Debuff, { instanceId = instanceId, duration = duration, buffType = buffType})
end

function BehaviorFunctions.DoShowAssassinQTE(instanceId, duration, minTime, maxTime)
	return BehaviorFunctions.fight.clientFight.qteManager:ShowNewQTE(FightEnum.NewQTEType.Assassin, { instanceId = instanceId, duration = duration, minTime = minTime, maxTime = maxTime})
end

function BehaviorFunctions.ChangeDebuffQTETime(instanceId, qteId, deltaTime)
	return BehaviorFunctions.fight.clientFight.qteManager:ChangeQTETime(instanceId, qteId, deltaTime)
end

function BehaviorFunctions.PlayQTEUIEffect(qteId, effectName, parentName, position)
	return BehaviorFunctions.fight.clientFight.qteManager:PlayQTEUIEffect(qteId, effectName, parentName, position)
end

function BehaviorFunctions.StopQTEUIEffect(qteId, effectName, parentName)
	return BehaviorFunctions.fight.clientFight.qteManager:StopQTEUIEffect(qteId, effectName, parentName)
end

function BehaviorFunctions.StopQTE(qteId)
	BehaviorFunctions.fight.clientFight.qteManager:StopQTE(qteId)
end

function BehaviorFunctions.PauseQTE(isPause)
	BehaviorFunctions.fight.clientFight.qteManager:PauseQTE(isPause)
end

-- 更改成获取实体身上储存的区域信息
function BehaviorFunctions.GetAreaInfo(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	return entity.values["areaId"]
end

function BehaviorFunctions.AddPostProcess(instanceId, type, params)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		local postProcessManager = BehaviorFunctions.fight.clientFight.postProcessManager
		postProcessManager:AddPostProcess(type, params, entity)
	end
end

function BehaviorFunctions.EndPostProcess(type)
	local postProcessManager = BehaviorFunctions.fight.clientFight.postProcessManager
	postProcessManager:EndPostProcess(type)
end

function BehaviorFunctions.DoShowPosVague(instanceId, strength, duration, alphaCurveId, radius, alpha, count, centerX, centerY, dir, id)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		local params = {
			Duration = duration,
			Strength = strength,
			Dir = dir,
			Radius = radius,
			Alpha = alpha,
			AlphaCurveId = alphaCurveId,
			Direction = 0,
			Count = count,
			Center = { centerX, centerY },
			PostProcessType = 2,
			ID = id or 0,
		}
		
		local postProcessManager = BehaviorFunctions.fight.clientFight.postProcessManager
		postProcessManager:AddPostProcess(params.PostProcessType, params, entity)
	end
end

function BehaviorFunctions.EndPosVague(instanceId, frame)
	if ctx then
		local params = {
			instanceId = instanceId,
			frame = frame,
		}

		local postProcessManager = BehaviorFunctions.fight.clientFight.postProcessManager
		postProcessManager:UpdatePostProcess(2, params)
	end
end

function BehaviorFunctions.AddPostProcessByTemplateId(instanceId, id, type)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		local postProcessManager = BehaviorFunctions.fight.clientFight.postProcessManager
		postProcessManager:AddPostProcessByTemplateId(id, type, entity)
	end
end

function BehaviorFunctions.FinishGuide(guideId, stage)
	local guideManager = BehaviorFunctions.fight.clientFight.guideManager
	guideManager:OnFinishGuideStage(guideId, stage)
end

function BehaviorFunctions.PlayGuide(guideId, stage, showTips)
	local guideManager = BehaviorFunctions.fight.clientFight.guideManager
	guideManager:PlayGuideGroup(guideId, stage, true, showTips)
end

function BehaviorFunctions.CheckGuideFinish(guideId)
	return mod.GuideCtrl:CheckGuideFinish(guideId)
end

function BehaviorFunctions.SetCameraLookAt(entityInstanceId,boneName)
	local entity = BehaviorFunctions.GetEntity(entityInstanceId)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraLookAt(entity,boneName)
end

function BehaviorFunctions.SetCameraFollow(entityInstanceId,boneName)
	local entity = BehaviorFunctions.GetEntity(entityInstanceId)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraFollow(entity,boneName)
end

function BehaviorFunctions.SetDamageFontVisible(visible)
	if ctx then
		BehaviorFunctions.fight.clientFight.fontAnimManager:SetVisible(visible)
	end
end

function BehaviorFunctions.SetLockPointVisible(visible)
	if ctx then
		EventMgr.Instance:Fire(EventName.SetLockPointVisible, visible)
	end
end

function BehaviorFunctions.SetClimbEnable(enable)
	BehaviorFunctions.fight.physicsTerrain:SetClimbEnable(enable)
end

function BehaviorFunctions.ResetBindTransform(entityInstanceId,targetInstanceId,boneName)
	local entity = BehaviorFunctions.GetEntity(entityInstanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if entity and entity.clientEffectComponent then
		entity.clientEntity.clientEffectComponent:ResetBindTransform(targetEntity,boneName)
	end
end

function BehaviorFunctions.GetCurAlivePlayerEntityCount()
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		return 0
	end

	return player:GetAliveEntityCount()
end

function BehaviorFunctions.SetHitModified(instanceId,type,param1,param2,param3)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hitComponent then
		entity.hitComponent:SetHitModified(type,param1,param2,param3)
	end
end

function BehaviorFunctions.ReSetHitModified(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hitComponent then
		entity.hitComponent:ReSetHitModified()
	end
end

function BehaviorFunctions.PlayBoneShake(instanceId, shakeId, boneGroupShake)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.hitComponent:SetEntityBoneShakeB(shakeId, boneGroupShake)
end

function BehaviorFunctions.SetEntityPartLock(instanceId, partName, lock)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	part:SetLogicLock(lock)
end

function BehaviorFunctions.PlayIKShake(instanceId, shakeId, strength)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.clientIkComponent then
		entity.clientEntity.clientIkComponent:PlayShake(shakeId, strength, 0)
	end
end

function BehaviorFunctions.CheckEntityPartLock(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part:IsPartLogicLock()
end

function BehaviorFunctions.SetEntityPartSearch(instanceId, partName, search)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	part:SetLogicSearch(search)
end

function BehaviorFunctions.GetPartLockTransform(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part.lockTransformName
end

function BehaviorFunctions.GetPartAttackTransform(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part.attackTransformName
end

function BehaviorFunctions.CheckEntityPartSearch(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part:IsPartLogicSearch()
end

function BehaviorFunctions.IsPartDestroy(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part:IsDestroy()
end

function BehaviorFunctions.SetEntityComponentEnable(instanceId, cmpType, enable, includeChildren)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		local entityTransform = entity.clientTransformComponent.gameObject.transform
		local cmp = entityTransform:GetComponent(cmpType)
		if cmp then
			cmp.enabled = enable
		end
		
		if includeChildren then
			local cmpList = entityTransform:GetComponentsInChildren(cmpType)
			for i = 0, cmpList.Length - 1 do
				cmpList[i].enabled = enable
			end
		end
	end
end

function BehaviorFunctions.ChangeAnimationData(instanceId, animDataId)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity.animatorComponent then
			entity.animatorComponent:ResetAnimData(animDataId)
		end
	end
end

function BehaviorFunctions.ChangeController(instanceId, controller)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local animatorController = BehaviorFunctions.fight.clientFight.assetsPool:Get(controller)
	entity.clientEntity.clientAnimatorComponent:SetController(animatorController)
end

function BehaviorFunctions.SetBodyDamping(x,y,z)
	BehaviorFunctions.fight.clientFight.cameraManager:SetBodyDamping(x,y,z)
end

function BehaviorFunctions.ForceFix(curveId,time)
	BehaviorFunctions.fight.clientFight.cameraManager:ForceFix(curveId,time)
end

function BehaviorFunctions.SetSoftZone(unlimited)
	BehaviorFunctions.fight.clientFight.cameraManager:SetSoftZone(unlimited)
end

function BehaviorFunctions.StopAllCameraOffset()
	BehaviorFunctions.fight.clientFight.cameraManager:StopAllCameraOffset()
end

function BehaviorFunctions.SetCorrectCameraState(state, isCorrect)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCorrectCameraState(state, isCorrect)
end

function BehaviorFunctions.StopBlend()
	BehaviorFunctions.fight.clientFight.cameraManager:StopBlend()
end

function BehaviorFunctions.SetCameraRotatePause(pause)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraRotatePause(pause)
end

function BehaviorFunctions.RemoveAllShake()
	BehaviorFunctions.fight.clientFight.cameraManager.cameraShakeManager:RemoveAllShake()
end

function BehaviorFunctions.EnableShake(enable)
	BehaviorFunctions.fight.clientFight.cameraManager.cameraShakeManager:EnableShake(enable)
end

function BehaviorFunctions.SetEntityTranslucent(instanceId,type,time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.clientTransformComponent:SetEntityTranslucent(type,time)
end


function BehaviorFunctions.SetEntityTranslucentV2(instanceId,value,time,fadeInTime)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.clientTransformComponent:SetEntityTranslucentV2(value,time,fadeInTime)
end


function BehaviorFunctions.SetAnimatorLayer(instanceId, layer)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.animatorComponent then
		entity.animatorComponent:SetAnimatorLayer(layer)
	end
end

function BehaviorFunctions.PlayAddAnimation(instanceId, name, layerName, weight, CurveId, isLoop)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.clientEntity.clientAnimatorComponent:PlayAdditiveAnimation(name, layerName, weight, CurveId, isLoop)
end

function BehaviorFunctions.GetSkillCostValue(instanceId, skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:GetSkillCostValue(skillId)
end

function BehaviorFunctions.GetSkillNeedCostValue(instanceId, skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:GetSkillNeedCostValue(skillId)
end

function BehaviorFunctions.GetSkillPointCost(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:GetSkillPointCost()
end

function BehaviorFunctions.AddSkillPoint(instanceId, type, addValue, source)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.skillSetComponent then
		return
	end

	return entity.skillSetComponent:AddSkillPoint(type, addValue, source)
end

function BehaviorFunctions.SetSkillPoint(instanceId, type, value)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:SetSkillPoint(type, value)
end

function BehaviorFunctions.ShowTopTarget(configId)
	EventMgr.Instance:Fire(EventName.ShowTopTarget, configId)
end

function BehaviorFunctions.ChangeTopTargetDesc(index, desc)
	EventMgr.Instance:Fire(EventName.ChangeTopTargetDesc, index, desc)
end

function BehaviorFunctions.TopTargetFinish(index, forceClose)
	EventMgr.Instance:Fire(EventName.TopTargetFinish, index, forceClose)
end

function BehaviorFunctions.HideFightMainWindowPanel(panelName)
	EventMgr.Instance:Fire(EventName.HideFightMainWindowPanel, panelName)
end

function BehaviorFunctions.SetMemberWeight(instanceId,targetGroupName,index,weight)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity.clientTransformComponent.targetGroups then
		entity.clientTransformComponent.targetGroups = {}
	end
	if not entity.clientTransformComponent.targetGroups[targetGroupName] then
		local cinemachineTargetGroup = entity.clientTransformComponent:GetTransform(targetGroupName):GetComponent(CinemachineTargetGroup)
		entity.clientTransformComponent.targetGroups[targetGroupName] = cinemachineTargetGroup
	end
	local cinemachineTargetGroup = entity.clientTransformComponent.targetGroups[targetGroupName]
	local target = cinemachineTargetGroup.m_Targets[index-1]
	target.weight = weight
	cinemachineTargetGroup.m_Targets[index-1] = target
end

function BehaviorFunctions.SetGroupPositionMode(mode, state)
	CameraManager.Instance:SetGroupPositionMode(mode, state)
end

function BehaviorFunctions.SetFollowTargetWeight(instanceId, boneName, weight, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local target
	if boneName then
		target = entity.clientTransformComponent:GetTransform(boneName)
	else
		target = entity.clientTransformComponent.gameObject
	end
	
	CameraManager.Instance:SetFollowTargetWeight(target,weight, state)
end

function BehaviorFunctions.AddFollowTarget(instanceId, boneName, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local target
	if boneName then
		target = entity.clientTransformComponent:GetTransform(boneName)
	else
		target = entity.clientTransformComponent.gameObject
	end
	CameraManager.Instance:AddFollowTarget(target, state)
end

function BehaviorFunctions.RemoveAllFollowTarget()
	CameraManager.Instance:RemoveAllFollowTarget()
end

function BehaviorFunctions.RemoveFollowTarget(instanceId, boneName, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local target
	if boneName then
		target = entity.clientTransformComponent:GetTransform(boneName)
	else
		target = entity.clientTransformComponent.gameObject
	end
	CameraManager.Instance:RemoveFollowTarget(target, state)
end

function BehaviorFunctions.GetTransformScreenX(instanceId,boneName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local clientTransformComponent = entity.clientTransformComponent
	local bone = clientTransformComponent:GetTransform(boneName) or nil
	if not bone then
		bone = clientTransformComponent.transform
	end

	local point = CameraManager.Instance.mainCameraComponent:WorldToViewportPoint(bone.position)
	local x = point.x - 0.5
	if point.z < 0 then
		x = x * -1
	end
	return x
end

function BehaviorFunctions.GetTransformDistance(instanceId1,boneName1,instanceId2,boneName2)
	local entity1 = BehaviorFunctions.GetEntity(instanceId1)
	local clientTransformComponent1 = entity1.clientTransformComponent
	local bone1 = clientTransformComponent1:GetTransform(boneName1) or nil
	if not bone1 then
		bone1 = clientTransformComponent1.transform
	end
	
	local entity2 = BehaviorFunctions.GetEntity(instanceId2)
	local clientTransformComponent2 = entity2.clientTransformComponent
	local bone2 = clientTransformComponent2:GetTransform(boneName2) or nil
	if not bone2 then
		bone2 = clientTransformComponent2.transform
	end
	return Vector3.Distance(bone1.position,bone2.position)
end

function BehaviorFunctions.SetTargetInfoUIVisible(showBaseInfo, showRestainInfo)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if mainUI then
		return mainUI.targetInfoPanel:UpdateInfoVisible(showBaseInfo, showRestainInfo)
	end
end

function BehaviorFunctions.SetCanGlideState(instanceId, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	entity.moveComponent.yMoveComponent:SetCanGlideState(state)
end

function BehaviorFunctions.GetPartner(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.masterId then
		return mod.RoleCtrl:GetRolePartner(entity.masterId)
	end
end

function BehaviorFunctions:GetRolePartner(instanceId)
	local info = Fight.Instance.playerManager:GetPlayer():GetEntityInfo(instanceId)
	return info and info.Partner
end

function BehaviorFunctions.GetPartnerInfoList()
	local partnerList = mod.BagCtrl:GetBagByType(BagEnum.BagType.Partner)
	local infoList = {}
	for i = 1, #partnerList do
		local entityId = RoleConfig.GetPartnerEntityId(partnerList[i].template_id)
		local quality = RoleConfig.GetPartnerQualityConfig(partnerList[i].template_id).quality
		table.insert(infoList, { level = partnerList[i].lev, entityId = entityId, quality = quality })
	end

	return infoList
end

function BehaviorFunctions.GetPartnerEntityId(instanceId)
	-- local entity = BehaviorFunctions.GetEntity(instanceId)
	-- if entity.masterId then
	-- 	local roleData = mod.RoleCtrl:GetRoleData(entity.masterId)
	-- 	if roleData then
	-- 		if roleData.partner_entity_id then
	-- 			return roleData.partner_entity_id
	-- 		elseif roleData.partner_id then
	-- 			local itemData = mod.BagCtrl:GetItemByUniqueId(roleData.partner_id, BagEnum.BagType.Partner)
	-- 			if itemData then
	-- 				return RoleConfig.GetPartnerEntityId(itemData.template_id)
	-- 			end
	-- 		end
	-- 	end
	-- end
end

function BehaviorFunctions.RemoveFightConditionListener(instanceId, eventId)
	local fightConditionManager =  BehaviorFunctions.fight.fightConditionManager
	if fightConditionManager then
		fightConditionManager:RemoveListener(instanceId, eventId)
	end
end

function BehaviorFunctions.GetEffectPath(effectName)
	local path = string.format("Effect/UI/%s.prefab",effectName)
	return path
end

function BehaviorFunctions.GetUIEffectPath(effectName)
	local path = string.format("UIEffect/Prefab/%s.prefab",effectName)
	return path
end


function BehaviorFunctions.CheckPartHurtDamage(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part:CheckPartHurtDamage()
end

function BehaviorFunctions.SetHurtPartDamageEnable(instanceId, partName, enable)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end
	part.dmgPartHurt = enable
end


function BehaviorFunctions.SetPartDamageParam(instanceId, partName, param)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	part.damageParam = param * 0.0001
end

function BehaviorFunctions.SetPartDamageShield(instanceId, partName, shield)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	part.damageShield = shield
end

function BehaviorFunctions.GetPartDamageShield(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part.damageShield
end

function BehaviorFunctions.GetPartDamageShieldPercent(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part.damageShield / part.damageShieldMax * 10000
end

function BehaviorFunctions.SetPartEnableHit(instanceId, partName, enable)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	part:SetPartEnable(enable)
end

function BehaviorFunctions.GetPartEnableHit(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.partComponent:GetPart(partName)
	if not part then
		return 
	end

	return part.enable
end

function BehaviorFunctions.SetPartEnableCollision(instanceId, partName, enable)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.collistionComponent:GetPart(partName)
	if not part then
		return 
	end

	part:SetPartEnable(enable)
end

function BehaviorFunctions.GetPartEnableCollision(instanceId, partName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local part = entity.collistionComponent:GetPart(partName)
	if not part then
		return 
	end

	return part.enable
end

local FightPanel = {
	All = 1 << 10,
	FightGrowNotice = 1 << 9,
	FightGuidePanel = 1 << 8,
	FightSystemPanel = 1 << 7,
	FightGatherPanel = 1 << 6,
	FightInteractPanel = 1 << 5,
	FightJoyStickPanel = 1 << 4,
	FightFormationPanel = 1 << 3,
	FightInfoPanel = 1 << 2,
	FightNewSkillPanel = 1 << 1,
	FightTargetInfoPanel = 1 << 0,
}

function BehaviorFunctions.SetFightPanelVisible(binaryStr)
	local toggle
	if binaryStr == "-1" then
		toggle = FightPanel.All - 1
	else
		toggle = tonumber(binaryStr, 2)
	end
	
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	local parent = mainUI.panelList
	UtilsUI.SetActiveByPosition(parent["FightSystemPanel"].gameObject, (toggle & FightPanel.FightSystemPanel) ~= 0)
	UtilsUI.SetActiveByPosition(parent["FightGatherPanel"].gameObject, (toggle & FightPanel.FightGatherPanel) ~= 0)
	UtilsUI.SetActiveByPosition(parent["FightInteractPanel"].gameObject, (toggle & FightPanel.FightInteractPanel) ~= 0)
	UtilsUI.SetActive(parent["FightJoyStickPanel"].gameObject, (toggle & FightPanel.FightJoyStickPanel) ~= 0)
	UtilsUI.SetActiveByPosition(parent["FightFormationPanel"].gameObject, (toggle & FightPanel.FightFormationPanel) ~= 0)
	UtilsUI.SetActiveByPosition(parent["FightInfoPanel"].gameObject, (toggle & FightPanel.FightInfoPanel) ~= 0)
	UtilsUI.SetActive(parent["FightNewSkillPanel"].gameObject, (toggle & FightPanel.FightNewSkillPanel) ~= 0)
	UtilsUI.SetActiveByPosition(parent["FightTargetInfoPanel"].gameObject, (toggle & FightPanel.FightTargetInfoPanel) ~= 0)
	UtilsUI.SetActiveByPosition(parent["FightGuidePanel"].gameObject, (toggle & FightPanel.FightGuidePanel) ~= 0)
	UtilsUI.SetActiveByPosition(parent["FightGrowNotice"].gameObject, (toggle & FightPanel.FightGrowNotice) ~= 0)
end

function BehaviorFunctions.SetJoyStickVisibleByAlpha(priority, visible, stopControl)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if not mainUI then
		return 
	end
	
	mainUI.panelList["FightJoyStickPanel"]:SetVisibleByAlpha(priority, visible, stopControl)
end

function BehaviorFunctions.CheckAimTarget(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM.aimTarget and true or false
	end
	return false
end

function BehaviorFunctions.GetAimTargetInstanceId(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		local aimTarget = entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM.aimTarget
		if aimTarget then
			return aimTarget.instanceId
		end
	end
end

function BehaviorFunctions.SetAimAnimEndMouseInput(instanceId, input)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		local aimFSM = entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM
		aimFSM.aimAnimEndMouseInput = input
	end
end


function BehaviorFunctions.HeadRaySearch(instanceId, instanceId2)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local headTransform = entity.clientTransformComponent:GetHeadTransform()
	local entityTarget = BehaviorFunctions.GetEntity(instanceId2)
	if headTransform then
		return entityTarget.clientTransformComponent:TransformRayCastGroup(headTransform, "SearchRay")
	end

	return false
end

function BehaviorFunctions.ShowPartner(instanceId, isShow)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		return 0
	end

	return player:ShowPartner(instanceId, isShow)
end

function BehaviorFunctions.ChangePartnerSkill(instanceId, newSkillId)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		return 0
	end

	player:ChangePartnerSkill(instanceId, newSkillId)
end

function BehaviorFunctions.ChangeFightBtn(curInstanceId, targetInstanceId)
	local entity = BehaviorFunctions.GetEntity(curInstanceId)
	if curInstanceId == targetInstanceId then
		entity.skillSetComponent:CancelRelevanceAllSkill()
		return
	end
	for key, keyEvent in pairs(FightEnum.SkillBtn2Event) do
		entity.skillSetComponent:RelevanceSkill(targetInstanceId, keyEvent, keyEvent)
	end
end

function BehaviorFunctions.GetPartnerInstanceId(instanceId)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		return 0
	end
	return player:GetHeroPartnerInstanceId(instanceId)
end

function BehaviorFunctions.CheckSystemOpenFinish(system_id)
	return mod.SystemCtrl:IsShowSystemOpenPnl(system_id)
end

function BehaviorFunctions.SetAllEffectKeyWordControl(curveId, excludedIds, isRefresh)
	BehaviorFunctions.fight.clientFight.effectKeyWordController:SetAllEffectKeyWordControl(curveId, excludedIds, isRefresh)
end

function BehaviorFunctions.SetEffectKeyWordControlByIds(curveId, Ids)
	BehaviorFunctions.fight.clientFight.effectKeyWordController:SetEffectKeyWordControlByIds(curveId, Ids)
end

function BehaviorFunctions.SetEffectKeyWordControlByRadius(curveId, excludedIds, pos, radius, isRefresh)
	BehaviorFunctions.fight.clientFight.effectKeyWordController:SetEffectKeyWordControlByRadius(curveId, excludedIds, pos, radius, isRefresh)
end

function BehaviorFunctions.SetEffectKeyWordControlByCylinder(curveId, excludedIds, pos, radius, height, isRefresh)
	BehaviorFunctions.fight.clientFight.effectKeyWordController:SetEffectKeyWordControlByCylinder(curveId, excludedIds, pos, radius, height, isRefresh)
end
function BehaviorFunctions.CancelEffectKeyWordControl()
	BehaviorFunctions.fight.clientFight.effectKeyWordController:CancelEffectKeyWordControl()
end

function BehaviorFunctions.CheckPartnerShow(instanceId)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		return nil
	end
	return player:CheckPartnerShow(instanceId)
end

function BehaviorFunctions.keyOpenStartByEco(ecoId)
	local isOpen = BehaviorFunctions.fight.unlockManager:OpenUnlockPreparePnl(ecoId)
	return isOpen
end

function BehaviorFunctions.CheckUnlockConditionByEco(ecoId)
	local isConditionSuc = BehaviorFunctions.fight.unlockManager:CheckUnlockCondition(ecoId, true)
	return isConditionSuc
end

function BehaviorFunctions.GetUnlockPartnerEntityId()
	local selectPartner = BehaviorFunctions.fight.unlockManager:GetSelectPartner()
	local partnerCfg = ItemConfig.GetItemConfig(selectPartner.partnerId)
	return partnerCfg.entity_id
end

function BehaviorFunctions.CheckEntityInBoxArea(instanceId ,center, boxX, boxY, boxZ, rotate)
	local x,y,z = BehaviorFunctions.GetPosition(instanceId)
	x = x - center.x
	y = y - center.y
	z = z - center.z
	local O = math.rad(rotate)
	--(x cosθ - y sinθ, x sinθ + y cosθ)
	local rotateX = x * math.cos(O) - z * math.sin(O)
	local rotateZ = x * math.sin(O) + z * math.cos(O)
	if rotateX < - boxX / 2 or rotateX > boxX / 2 then
		return false
	end
	if y < - boxY / 2 or y > boxY / 2 then
		return false
	end
	if rotateZ < - boxZ / 2 or rotateZ > boxZ / 2 then
		return false
	end
	return true
end

function BehaviorFunctions.SetFontOffsetPos(fontRangeType, offsetX, offsetY)
	local fontInfo = Config.FightConfig.FontOffsetPos[fontRangeType]
	fontInfo.x = offsetX
	fontInfo.y = offsetY
end

function BehaviorFunctions.SetFontRangePos(fontRangeType, minX, maxX, minY, maxY)
	local fontInfo = Config.FightConfig.FontRangePos[fontRangeType]
	fontInfo.rangeMinX = minX * 100
	fontInfo.rangeMaxX = maxX * 100
	fontInfo.rangeMinY = minY * 100
	fontInfo.rangeMaxY = maxY * 100
end


function BehaviorFunctions.CreateHeadAlertnessUI(instanceId, curAlertnessValue, maxAlertnessValue)
	LogError("CreateHeadAlertnessUI弃用接口")
	-- BehaviorFunctions.fight.clientFight.headAlertnessManager:CreateHeadAlertnessUI(instanceId, curAlertnessValue, maxAlertnessValue)
end

function BehaviorFunctions.ShowHeadAlertnessUI(instanceId, isShow)
	LogError("ShowHeadAlertnessUI弃用接口")
	-- BehaviorFunctions.fight.clientFight.headAlertnessManager:ShowHeadAlertnessUI(instanceId, isShow)
end

function BehaviorFunctions.SetHeadAlertnessValue(instanceId, curAlertnessValue)
	LogError("SetHeadAlertnessValue弃用接口")
	-- BehaviorFunctions.fight.clientFight.headAlertnessManager:SetHeadAlertnessValue(instanceId, curAlertnessValue)
end

function BehaviorFunctions.CreateQuestionAlertnessUI(instanceId, curAlertnessValue, maxAlertnessValue, offset, attachPoint)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:CreateMonsterHeadAlertnessUI(instanceId, curAlertnessValue, maxAlertnessValue, offset, attachPoint)
end

function BehaviorFunctions.ShowQuestionAlertnessUI(instanceId, isShow)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:ShowMonsterHeadAlertnessUI(instanceId, isShow)
end

function BehaviorFunctions.SetQuestionAlertnessValue(instanceId, curAlertnessValue)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:SetMonsterHeadAlertnessValue(instanceId, curAlertnessValue)
end

function BehaviorFunctions.CreateWarnAlertnessUI(instanceId, offset, attachPoint)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:CreateMonsterWarnHeadAlertnessUI(instanceId, 0, 0, offset, attachPoint)
end

function BehaviorFunctions.ShowWarnAlertnessUI(instanceId, isShow)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:ShowMonsterWarnHeadAlertnessUI(instanceId, isShow)
end

function BehaviorFunctions.CreateNPCSelectUI(instanceId, offset, attachPoint)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:CreateNPCSelectUI(instanceId, offset, attachPoint)
end

function BehaviorFunctions.ShowNPCSelectUI(instanceId, isShow)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:ShowNPCSelectUI(instanceId, isShow)
end

function BehaviorFunctions.CheckNPCSelectUI(instanceId)
	return BehaviorFunctions.fight.clientFight.headAlertnessManager:CheckNPCSelectUI(instanceId)
end

function BehaviorFunctions.CreateSummonCarUI(instanceId, offset, attachPoint)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:CreateSummonCarUI(instanceId, offset, attachPoint)
end

function BehaviorFunctions.ShowSummonCarUI(instanceId, isShow)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:ShowSummonCarUI(instanceId, isShow)
end
function BehaviorFunctions.CreateHeadViewUI(instanceId, curViewValue, maxViewValue)
	LogError("CreateHeadViewUI弃用接口")
	-- BehaviorFunctions.fight.clientFight.headAlertnessManager:CreateHeadViewUI(instanceId, curViewValue, maxViewValue)
end

function BehaviorFunctions.ShowHeadViewUI(instanceId, isShow)
	LogError("ShowHeadViewUI弃用接口")
	-- BehaviorFunctions.fight.clientFight.headAlertnessManager:ShowHeadViewUI(instanceId, isShow)
end

function BehaviorFunctions.SetHeadViewValue(instanceId, curViewValue)
	LogError("SetHeadViewValue弃用接口")
	-- BehaviorFunctions.fight.clientFight.headAlertnessManager:SetHeadViewValue(instanceId, curViewValue)
end

function BehaviorFunctions.SwitchSetCorUIPercentDivide(instanceId, ...)
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if panel and panel.coreUI[ctrlEntity.masterId] then
		panel.coreUI[ctrlEntity.masterId]:SetCorUIPercentDivide(...)
	end
end

function BehaviorFunctions.SwitchCoreUIType(instanceId, type)
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if panel and panel.coreUI[ctrlEntity.masterId] then
		panel.coreUI[ctrlEntity.masterId]:SwitchCoreUIType(type)
	end
end

function BehaviorFunctions.SetCoreUIVisible(instanceId, visible, time)
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if panel and panel.coreUI[ctrlEntity.masterId] then
		panel.coreUI[ctrlEntity.masterId]:UpdateVisible(visible, time)
	end
end

function BehaviorFunctions.SetCoreUIPosition(instanceId, x, y, lock)
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if panel and panel.coreUI[ctrlEntity.masterId] then
		panel.coreUI[ctrlEntity.masterId]:UpdateCyclePosition(x, y, lock)
	end
end

function BehaviorFunctions.SetCoreUIScale(instanceId, scale)
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if panel and panel.coreUI[ctrlEntity.masterId] then
		panel.coreUI[ctrlEntity.masterId]:UpdateScale(scale)
	end
end

function BehaviorFunctions.SetCoreEffectVisible(instanceId, id, visible)
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if panel and panel.coreUI[ctrlEntity.masterId] then
		panel.coreUI[ctrlEntity.masterId]:UpdateEffect(id, visible)
	end
end

function BehaviorFunctions.SetCoreUIEnable(instanceId, enable)
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if panel and panel.coreUI[ctrlEntity.masterId] then
		panel.coreUI[ctrlEntity.masterId]:SetCoreUIEnable(enable)
	end
end

function BehaviorFunctions.SetCoreUIPanelActive(active)
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	if panel then
		panel:SetPanelActive(active)
	end
	
end

function BehaviorFunctions.SetJoyMoveEnable(instanceId, enable, priority, stopControl)
	if instanceId == FightEnum.Formation.All then
		local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
		for _, v in pairs(entityList) do
			local entity = BehaviorFunctions.GetEntity(v.instanceId)
			if entity and entity.handleMoveInputComponent then
				entity.handleMoveInputComponent:SetEnabled(enable, priority, stopControl)
			end
		end
	else
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity and entity.handleMoveInputComponent then
			entity.handleMoveInputComponent:SetEnabled(enable, priority, stopControl)
		end
	end
end

local tempEntitys = {}
function BehaviorFunctions.RaycastSector(instanceId, yOffset, angle, radius)
	TableUtils.ClearTable(tempEntitys)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local transform = entity.clientTransformComponent.transform
	local es = CustomUnityUtils.RaycastSector(transform,yOffset,angle,radius)
	local check
	if es then
		check = true
		for i = 0, es.Count - 1 do
			table.insert(tempEntitys,es[i])
		end
	end
	return check, tempEntitys
end

function BehaviorFunctions.CallCommonBehaviorFunc(instanceId, funName, ...)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.commonBehaviorComponent then
		entity.commonBehaviorComponent:CallFunc(funName, ...)
	end
end

function BehaviorFunctions.SetUseParentTimeScale(instanceId, isUse)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.timeComponent then
		entity.timeComponent:SetIsUseParentTimeScale(isUse)
	end
end

function BehaviorFunctions.ShowAssassinLifeBarTip(instanceId, hitId, skillId, magicId, perfectMagicId)
	local entity = BehaviorFunctions.GetEntity(hitId)
	if entity and entity.clientLifeBarComponent then
		entity.clientEntity.clientLifeBarComponent:UpdateAssassinTip(instanceId, hitId, skillId, magicId, perfectMagicId)
	end

	EventMgr.Instance:Fire(EventName.UpdateAssassinTip, instanceId, hitId, skillId, magicId, perfectMagicId)
end
function BehaviorFunctions.HideAssassinLifeBarTip(instanceId, hitId)
	local entity = BehaviorFunctions.GetEntity(hitId)
	if entity and entity.clientLifeBarComponent then
		entity.clientEntity.clientLifeBarComponent:HideAssassinTip(instanceId, hitId)
	end

	EventMgr.Instance:Fire(EventName.HideAssassinTip, instanceId, hitId)
end

function BehaviorFunctions.GetPlayingAnimationName(instanceId, layer)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.animatorComponent then
		return entity.animatorComponent:GetPlayingAnimationName(layer)
	end
	
	return nil, nil
end

function BehaviorFunctions.GetEntitySpeedY(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	return entity.moveComponent.yMoveComponent:GetSpeed()
end

function BehaviorFunctions.GetEntitySpeed(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.transformComponent then
		return 0
	end

	return entity.transformComponent:GetSpeed()
end

function BehaviorFunctions.ActiveMailing(npcId)
	mod.MailingCtrl:ActiveMailing(npcId)
end

function BehaviorFunctions.CheckMailingState(npcId, state)
	local mailingId = StoryConfig.GetMailingId(npcId)
	if mailingId then
		return mod.MailingCtrl:CheckMailingState(mailingId, state)
	end
end

function BehaviorFunctions.SetMailingCamera(npcId, rotY, screenX, screenY, distance)
	local npcEntity = BehaviorFunctions.GetNpcEntity(npcId)
	if npcEntity then
		mod.MailingCtrl:SetCamera(npcEntity, rotY, screenX, screenY, distance)
	end
end

function BehaviorFunctions.CheckEntityCollideAtPosition(entityId, x, y, z, ignoreList, instanceId, isRayCast, layerMask ,multiple)
	--为了让进行地面碰撞检测时更容易通过，使用实际碰撞大小 * 0.9
	local size = 0.9
	if multiple then
		size = multiple
	end
	local entityConfig = EntityConfig.GetEntity(entityId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity or not entity.transformComponent then
		return false
	end
	local PartList = entityConfig.Components[FightEnum.ComponentConfigName[FightEnum.ComponentType.Collision]].PartList
	local position = Vec3.New(x, y, z)
	local count = 0
	local layer = FightEnum.LayerBit.Default | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
	if layerMask then
		layer = layerMask
	end
	local tmpHeightVec = Vec3.New()
	local offset = Vec3.New()
	local basePosition = entity.clientTransformComponent.transform.position
	local result
	if isRayCast then
		local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
		local from = player.clientTransformComponent:GetTransform("HitCase").position
		local targetOffset = entity.clientTransformComponent:GetTransform("HitCase").position - basePosition
		position:Add(targetOffset)
		if DebugConfig.ShowCheckEntityCollide then
			Debug.DrawLine(from, position, Color.green)
		end
		if CustomUnityUtils.LineCast(from.x, from.y, from.z, position.x, position.y, position.z) then
			return false
		end
	end
	local drawObjectCache
	if DebugConfig.ShowCheckEntityCollide then
		drawObjectCache = {}
		LuaTimerManager.Instance:AddTimer(1, 1, function ()
			for _, v in pairs(drawObjectCache) do
				GameObject.DestroyImmediate(v)
			end
		end)
	end

	local rotation = Quat.New()
	for _, PartConfig in pairs(PartList) do
		for _, v in pairs(PartConfig.BoneColliders) do
			local part = entity.clientTransformComponent:GetTransform(v.ParentName or "")
			position:Set(x, y, z)
			position:Add(part.position - basePosition)
			rotation:CopyValue(part.rotation)
			local rotation2 = Quat.Euler(v.LocalEuler[1], v.LocalEuler[2], v.LocalEuler[3])
			local newRotation = (rotation * rotation2):Normalize()
			offset:Set(v.LocalPosition[1], v.LocalPosition[2], v.LocalPosition[3])
			position:AddXYZ(rotation:MulVec3A(offset))

			if v.ShapeType == FightEnum.CollisionType.Sphere then
				result, count = CustomUnityUtils.OverlapSphereCollider(position, v.LocalScale[1]/2 * size, layer, count)
			elseif v.ShapeType == FightEnum.CollisionType.Cube then
				result, count = CustomUnityUtils.OverlapBoxCollider(position, newRotation, v.LocalScale[1] * size, v.LocalScale[2] * size, v.LocalScale[3] * size, layer, count)
			elseif v.ShapeType == FightEnum.CollisionType.Cylinder then
				tmpHeightVec:Set(0, v.LocalScale[2] * 0.5 , 0)
				tmpHeightVec.y = tmpHeightVec.y >= 0 and tmpHeightVec.y or 0
				result, count = CustomUnityUtils.OverlapCapsuleCollider(position - tmpHeightVec, position + tmpHeightVec, v.LocalScale[1] * 0.5  * size, layer, count)
			end

			if DebugConfig.ShowCheckEntityCollide then
				local colliderObj
				if v.ShapeType ==  FightEnum.CollisionType.Sphere then
					colliderObj = GameObject.CreatePrimitive(PrimitiveType.Sphere)
					UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[1], v.LocalScale[1])
				elseif v.ShapeType == FightEnum.CollisionType.Cube then
					colliderObj = GameObject.CreatePrimitive(PrimitiveType.Cube)
					UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[2], v.LocalScale[3])
				elseif v.ShapeType == FightEnum.CollisionType.Cylinder then
					colliderObj = GameObject.CreatePrimitive(PrimitiveType.Cylinder)
					UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[2], v.LocalScale[1])
				end
				CustomUnityUtils.SetPosition(colliderObj.transform, position.x, position.y, position.z)
				CustomUnityUtils.SetRotation(colliderObj.transform, newRotation.x, newRotation.y, newRotation.z, newRotation.w)

				local collider = colliderObj:GetComponent(Collider)
				collider.enabled = false

				local meshRender = colliderObj:GetComponent(MeshRenderer)
				if UtilsBase.IsNull(meshRender) then
					meshRender = colliderObj:AddComponent(MeshRenderer)
				end
				meshRender.enabled = true
				CustomUnityUtils.SetPrimitiveMaterialColor(colliderObj, Color(0.5, 0.5, 0.5, 0.5))
				table.insert(drawObjectCache, colliderObj)
			end

			for i = 0, count - 1 do
				local colliderEntity = BehaviorFunctions.fight.entityManager:GetColliderEntity(result[i])
				if colliderEntity then
					for _, ignore_InstanceId in pairs(ignoreList) do
						if colliderEntity.instanceId == ignore_InstanceId then
							count = count - 1
							break
						end
					end
				end
			end
			if count > 0 then
				return false 
			end
		end
	end

	return true
end

function BehaviorFunctions.CheckEntityCollideAtPositionAndRotation(entityId, x, y, z, eulerX, eulerY, eulerZ, ignoreList, instanceId, isRayCast)
	local entityConfig = EntityConfig.GetEntity(entityId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity or not entity.transformComponent then
		return false
	end
	local PartList = entityConfig.Components[FightEnum.ComponentConfigName[FightEnum.ComponentType.Part]].PartList
	local position = Vec3.New(x, y, z)
	local count = 0
	local layer = FightEnum.LayerBit.Default | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water | FightEnum.LayerBit.AirWall | FightEnum.LayerBit.NoClimbing
	local tmpHeightVec = Vec3.New()
	local offset = Vec3.New()
	local basePosition = entity.clientTransformComponent.transform.position
	local result
	if isRayCast then
		local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
		local from = player.clientTransformComponent:GetTransform("HitCase").position
		local targetOffset = entity.clientTransformComponent:GetTransform("HitCase").position - basePosition
		position:Add(targetOffset)
		if DebugConfig.ShowCheckEntityCollide then
			Debug.DrawLine(from, position, Color.green)
		end
		if CustomUnityUtils.LineCast(from.x, from.y, from.z, position.x, position.y, position.z) then
			return false
		end
	end
	local drawObjectCache
	if DebugConfig.ShowCheckEntityCollide then
		drawObjectCache = {}
		LuaTimerManager.Instance:AddTimer(1, 0.05, function ()
			for _, v in pairs(drawObjectCache) do
				GameObject.DestroyImmediate(v)
			end
		end)
	end

	local rotation = Quat.New()
	for _, PartConfig in pairs(PartList) do
		for _, v in pairs(PartConfig.BoneColliders) do
			local part = entity.clientTransformComponent:GetTransform(v.ParentName or "")
			if part then
				position:Set(x, y, z)
				position:Add(part.position - basePosition)
				rotation:CopyValue(part.rotation)
				local euler = rotation:ToEulerAngles()
				local newEuler = euler:AddXYZ(eulerX, eulerY, eulerZ)
				rotation:SetEuler(newEuler.x, newEuler.y, newEuler.z)
				local rotation2 = Quat.Euler(v.LocalEuler[1], v.LocalEuler[2], v.LocalEuler[3])
				local newRotation = (rotation * rotation2):Normalize()
				offset:Set(v.LocalPosition[1], v.LocalPosition[2], v.LocalPosition[3])
				position:AddXYZ(rotation:MulVec3A(offset))

				if v.ShapeType == FightEnum.CollisionType.Sphere then
					result, count = CustomUnityUtils.OverlapSphereCollider(position, v.LocalScale[1]/2, layer, count)
				elseif v.ShapeType == FightEnum.CollisionType.Cube then
					result, count = CustomUnityUtils.OverlapBoxCollider(position, newRotation, v.LocalScale[1], v.LocalScale[2], v.LocalScale[3], layer, count)
				elseif v.ShapeType == FightEnum.CollisionType.Cylinder then
					tmpHeightVec:Set(0, v.LocalScale[2] * 0.5 , 0)
					tmpHeightVec.y = tmpHeightVec.y >= 0 and tmpHeightVec.y or 0
					result, count = CustomUnityUtils.OverlapCapsuleCollider(position - tmpHeightVec, position + tmpHeightVec, v.LocalScale[1] * 0.5, layer, count)
				end

				if DebugConfig.ShowCheckEntityCollide then
					local colliderObj
					if v.ShapeType ==  FightEnum.CollisionType.Sphere then
						colliderObj = GameObject.CreatePrimitive(PrimitiveType.Sphere)
						UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[1], v.LocalScale[1])
					elseif v.ShapeType == FightEnum.CollisionType.Cube then
						colliderObj = GameObject.CreatePrimitive(PrimitiveType.Cube)
						UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[2], v.LocalScale[3])
					elseif v.ShapeType == FightEnum.CollisionType.Cylinder then
						colliderObj = GameObject.CreatePrimitive(PrimitiveType.Cylinder)
						UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[2], v.LocalScale[1])
					end
					CustomUnityUtils.SetPosition(colliderObj.transform, position.x, position.y, position.z)
					CustomUnityUtils.SetRotation(colliderObj.transform, newRotation.x, newRotation.y, newRotation.z, newRotation.w)

					local collider = colliderObj:GetComponent(Collider)
					collider.enabled = false

					local meshRender = colliderObj:GetComponent(MeshRenderer)
					if UtilsBase.IsNull(meshRender) then
						meshRender = colliderObj:AddComponent(MeshRenderer)
					end
					meshRender.enabled = true
					CustomUnityUtils.SetPrimitiveMaterialColor(colliderObj, Color(0.5, 0.5, 0.5, 0.5))
					table.insert(drawObjectCache, colliderObj)
				end

				for i = 0, count - 1 do
					local colliderEntity = BehaviorFunctions.fight.entityManager:GetColliderEntity(result[i])
					if colliderEntity then
						for _, ignore_InstanceId in pairs(ignoreList) do
							if colliderEntity.instanceId == ignore_InstanceId then
								count = count - 1
								break
							end
						end
					end
				end
				if count > 0 then
					return false
				end
			end
		end
	end

	return true
end

function BehaviorFunctions.GetOppositePosCollideAtPosition(entityId,x, y, z, ignoreList, instanceId, isRayCast,layerMask,multiple)
	--为了让进行地面碰撞检测时更容易通过，使用实际碰撞大小 * 0.9
	local size = 0.9
	if multiple then
		size = multiple
	end
	local entityConfig = EntityConfig.GetEntity(entityId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity or not entity.transformComponent then
		return false
	end
	local PartList = entityConfig.Components[FightEnum.ComponentConfigName[FightEnum.ComponentType.Collision]].PartList
	local position = Vec3.New(x, y, z)
	local count = 0
	local layer = FightEnum.LayerBit.Default | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
	if layerMask then
		layer = layerMask
	end
	local tmpHeightVec = Vec3.New()
	local offset = Vec3.New()
	local basePosition = entity.clientTransformComponent.transform.position
	local result
	if isRayCast then
		local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
		local from = player.clientTransformComponent:GetTransform("HitCase").position
		local targetOffset = entity.clientTransformComponent:GetTransform("HitCase").position - basePosition
		position:Add(targetOffset)
		if DebugConfig.ShowCheckEntityCollide then
			Debug.DrawLine(from, position, Color.green)
		end
		if CustomUnityUtils.LineCast(from.x, from.y, from.z, position.x, position.y, position.z) then
			return false
		end
	end
	local drawObjectCache
	if DebugConfig.ShowCheckEntityCollide then
		drawObjectCache = {}
		LuaTimerManager.Instance:AddTimer(1, 1, function ()
			for _, v in pairs(drawObjectCache) do
				GameObject.DestroyImmediate(v)
			end
		end)
	end

	local rotation = Quat.New()
	for _, PartConfig in pairs(PartList) do
		for _, v in pairs(PartConfig.BoneColliders) do
			local part = entity.clientTransformComponent:GetTransform(v.ParentName or "")
			position:Set(x, y, z)
			position:Add(part.position - basePosition)
			rotation:CopyValue(part.rotation)
			local rotation2 = Quat.Euler(v.LocalEuler[1], v.LocalEuler[2], v.LocalEuler[3])
			local newRotation = (rotation * rotation2):Normalize()
			offset:Set(v.LocalPosition[1], v.LocalPosition[2], v.LocalPosition[3])
			position:AddXYZ(rotation:MulVec3A(offset))

			if v.ShapeType == FightEnum.CollisionType.Sphere then
				pos = CustomUnityUtils.GetOppositePosOverlapSphereCollider(position, v.LocalScale[1]/2 * size, layer, count)
			elseif v.ShapeType == FightEnum.CollisionType.Cube then
				pos = CustomUnityUtils.GetOppositePosOverlapBoxCollider(position, newRotation, v.LocalScale[1] * size, v.LocalScale[2] * size, v.LocalScale[3] * size, layer, count)
			elseif v.ShapeType == FightEnum.CollisionType.Cylinder then
				tmpHeightVec:Set(0, v.LocalScale[2] * 0.5 , 0)
				tmpHeightVec.y = tmpHeightVec.y >= 0 and tmpHeightVec.y or 0
				pos = CustomUnityUtils.GetOppositePosOverlapCapsuleCollider(position - tmpHeightVec, position + tmpHeightVec, v.LocalScale[1] * 0.5  * size, layer, count)
			end
			return pos
			-- if DebugConfig.ShowCheckEntityCollide then
			-- 	local colliderObj
			-- 	if v.ShapeType ==  FightEnum.CollisionType.Sphere then
			-- 		colliderObj = GameObject.CreatePrimitive(PrimitiveType.Sphere)
			-- 		UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[1], v.LocalScale[1])
			-- 	elseif v.ShapeType == FightEnum.CollisionType.Cube then
			-- 		colliderObj = GameObject.CreatePrimitive(PrimitiveType.Cube)
			-- 		UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[2], v.LocalScale[3])
			-- 	elseif v.ShapeType == FightEnum.CollisionType.Cylinder then
			-- 		colliderObj = GameObject.CreatePrimitive(PrimitiveType.Cylinder)
			-- 		UnityUtils.SetLocalScale(colliderObj.transform, v.LocalScale[1], v.LocalScale[2], v.LocalScale[1])
			-- 	end
			-- 	CustomUnityUtils.SetPosition(colliderObj.transform, position.x, position.y, position.z)
			-- 	CustomUnityUtils.SetRotation(colliderObj.transform, newRotation.x, newRotation.y, newRotation.z, newRotation.w)

			-- 	local collider = colliderObj:GetComponent(Collider)
			-- 	collider.enabled = false

			-- 	local meshRender = colliderObj:GetComponent(MeshRenderer)
			-- 	if UtilsBase.IsNull(meshRender) then
			-- 		meshRender = colliderObj:AddComponent(MeshRenderer)
			-- 	end
			-- 	meshRender.enabled = true
			-- 	CustomUnityUtils.SetPrimitiveMaterialColor(colliderObj, Color(0.5, 0.5, 0.5, 0.5))
			-- 	table.insert(drawObjectCache, colliderObj)
			-- end

			-- for i = 0, count - 1 do
			-- 	local colliderEntity = BehaviorFunctions.fight.entityManager:GetColliderEntity(result[i])
			-- 	if colliderEntity then
			-- 		for _, ignore_InstanceId in pairs(ignoreList) do
			-- 			if colliderEntity.instanceId == ignore_InstanceId then
			-- 				count = count - 1
			-- 				break
			-- 			end
			-- 		end
			-- 	end
			-- end
			-- if count > 0 then
			-- 	return false 
			-- end
		end
	end

	return true
end

local CollideCheckLayer = FightEnum.LayerBit.Default | FightEnum.LayerBit.Entity | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
function BehaviorFunctions.DoCollideCheckAtPosition(x, y, z, sizeX, sizeY, sizeZ, ignoreList)
	local position = Vec3.New(x, y, z)
	local count = 0
	local result
	result, count = CustomUnityUtils.OverlapBoxCollider(position, Vec3.zero, sizeX, sizeY, sizeZ, CollideCheckLayer, count)

	for i = 0, count - 1 do
		local colliderEntity = BehaviorFunctions.fight.entityManager:GetColliderEntity(result[i])
		if colliderEntity then
			if colliderEntity.tagComponent and colliderEntity.tagComponent.tag == FightEnum.EntityTag.Npc then
				count = count - 1
			else
				for _, ignore_InstanceId in pairs(ignoreList) do
					if colliderEntity.instanceId == ignore_InstanceId then
						count = count - 1
						break
					end
				end
			end
		end
	end

	return count > 0
end

function BehaviorFunctions.IsMercenaryChase(instanceId)
	local ecoId = BehaviorFunctions.GetEntityEcoId(instanceId)
    local mercenaryMgr = Fight.Instance.mercenaryHuntManager
	local mercenaryCtrl = mercenaryMgr:GetMercenaryCtrl(ecoId)
	if not mercenaryCtrl then return end
	return mercenaryCtrl:CheckMercenaryChasePos()
end

function BehaviorFunctions.SetLockTargetUI(active)
	EventMgr.Instance:Fire(EventName.SetLockTargetUI, active)
end

function BehaviorFunctions.ChangeCollideHeight(instanceId, height)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then return end
	if entity.clientEntity.clientTransformComponent then
		entity.clientEntity.clientTransformComponent:SetKCCProxyHeight(height)
	end
end

function BehaviorFunctions.ChangeCollideRadius(instanceId, radius)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then return end
	if entity.clientEntity.clientTransformComponent then
		entity.clientEntity.clientTransformComponent:SetKCCProxyRadius(radius)
	end
end

function BehaviorFunctions.GetCollideRadius(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then return end
	if entity.clientEntity.clientTransformComponent then
		return entity.clientEntity.clientTransformComponent.kccProxyRadius
	else
		if entity.clientEntity.collisionComponent then
			return entity.clientEntity.collisionComponent.config.radius
		end
	end
	return 0.5
end


function BehaviorFunctions.PlayEffectFont(instanceId, fontType, attachPoint)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	Fight.Instance.clientFight.fontAnimManager:PlayEffectAnimation(entity, fontType, attachPoint)
end

function BehaviorFunctions.PlayTipsFont(instanceId, fontType, attachPoint)
	-- 玩家设置驱动开关
	if mod.GameSetCtrl:GetFight(GameSetConfig.Fight[1].SaveKey) == 0 then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		Fight.Instance.clientFight.fontAnimManager:PlayTipsAnimation(entity, fontType, attachPoint)
	end
end

function BehaviorFunctions.ChangeCamp(instanceId, campId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.tagComponent then return end
	entity.tagComponent:SetCamp(campId)
end

function BehaviorFunctions.ChangeBehavior(instanceId, behaviorInstancesId, newBehaviorName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.behaviorComponent then return end
	entity.behaviorComponent:RemoveBehavior(behaviorInstancesId)
	entity.behaviorComponent:AddBehavior(newBehaviorName)
end

function BehaviorFunctions.PlayBackGroundText(id)
	Fight.Instance.clientFight.levelTipManager:PlayBackGroundText(id)
end

function BehaviorFunctions.GetRandomNavRationalPoint(instanceId, minRadius, maxRadius, startGround)
	local rolePos = BehaviorFunctions.GetPositionP(instanceId)
	return BehaviorFunctions.GetRandomNavRationalPointPos(rolePos, minRadius, maxRadius, startGround)
end
function BehaviorFunctions.GetRandomNavRationalPointPos(rolePos, minRadius, maxRadius, startGround)
	local val = math.random(minRadius, maxRadius)
	local circlePos = Random.insideUnitCircle * val

	local Vec3Pos = Vec3.New(circlePos.x, circlePos.y, 0)
	local len = Vec3.Magnitude(Vec3Pos)
	
	if startGround then
		
		
		local h,layer=BehaviorFunctions.CheckPosHeight(rolePos)
		if h then
			rolePos = Vec3.New(rolePos.x,rolePos.y-h,rolePos.z)
		end
		
		Vec3Pos.z = Vec3Pos.y
		Vec3Pos.y = 0
	end

	-- 取到的点
	local randomPos = Vec3Pos:Normalize() * (val + len)
	local newPos = randomPos + rolePos

	local x, y, z, isOk = CustomUnityUtils.GetNavmeshRandomPos(newPos.x, newPos.y, newPos.z, val)
	if not isOk then return end
	Vec3Pos.x = x
	Vec3Pos.y = y
	Vec3Pos.z = z
	
	local posArray, count = CustomUnityUtils.NavCalculatePath(Vec3Pos, rolePos, 1)
	if count <= 0 then
		return
	end

	local lastPos = posArray[count - 1]
	if Vec3.SquareDistance(lastPos, rolePos) > 1 then
		return
	end
	return Vec3Pos
end

function BehaviorFunctions.ActiveMapIcon(ecoId)
	mod.WorldMapCtrl:SendMapMarkActive({ecoId})
end

function BehaviorFunctions.CheckPointInArea(point, areaId, areaType, mapId)
	if not areaId or not areaType then
		return
	end
	
	local bounds = MapPositionConfig.GetAreaEdgeInfo(areaType, areaId, mapId)
	local areaPointList = MapPositionConfig.GetAreaBoundsInfo(areaType, areaId, mapId)

	if not bounds or not areaPointList then
		return
	end

	if point.x > bounds.maxX or point.x < bounds.minX or point.z > bounds.maxY or point.z < bounds.minY then
		return false
	end

	local isInArea = false
	for i = 1, #areaPointList do
		if i == 1 and
			not (areaPointList[#areaPointList].y > point.z and areaPointList[1].y > point.z) and
			not (areaPointList[#areaPointList].y < point.z and areaPointList[1].y < point.z) and
			point.x < (areaPointList[#areaPointList].x - areaPointList[1].x) * (point.z - areaPointList[1].y) / (areaPointList[#areaPointList].y - areaPointList[1].y) + areaPointList[1].x then
			isInArea = not isInArea
		elseif i > 1 and
				not (areaPointList[i - 1].y > point.z and areaPointList[i].y > point.z) and
				not (areaPointList[i - 1].y < point.z and areaPointList[i].y < point.z) and
				point.x < (areaPointList[i - 1].x - areaPointList[i].x) * (point.z - areaPointList[i].y) / (areaPointList[i - 1].y - areaPointList[i].y) + areaPointList[i].x then
			isInArea = not isInArea
		end
	end

	return isInArea
end

function BehaviorFunctions.IsPointInsidePolygon(point, polygon)
	local count = 0
	local n = #polygon

	for i = 1, n do
		local j = i % n + 1
		if ((polygon[i].y > point.z) ~= (polygon[j].y > point.z)) and
				(point.x < (polygon[j].x - polygon[i].x) * (point.z - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x) then
			count = count + 1
		end
	end

	return count % 2 == 1
end

function BehaviorFunctions.SetLookIKTarget(instanceId, targetInstanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end

	entity.clientEntity.clientIkComponent:SetLookIKTarget(targetInstanceId)
end

function BehaviorFunctions.SetLookIKTargetPos(instanceId, targetPos)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end

	entity.clientEntity.clientIkComponent:SetLookIKTargetPos(targetPos)
end

function BehaviorFunctions.RemoveLookIKTarget(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end

	entity.clientEntity.clientIkComponent:RemoveLookIKTarget()
end

function BehaviorFunctions.SetLookIKEnable(instanceId, enabled)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end

	entity.clientEntity.clientIkComponent:SetLookEnable(enabled)
end


function BehaviorFunctions.SetLookedIkEnable(instanceId, enabled)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end

	entity.clientEntity.clientIkComponent:SetLookedEnable(enabled)
end

function BehaviorFunctions.SetLookIKTargetEnter(instanceId, targetInstanceId, isEnter, weight)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end

	entity.clientEntity.clientIkComponent:SetLookTargetEnter(targetInstanceId, isEnter, weight)
end

function BehaviorFunctions.GetAimTargetPositionP()
	return Fight.Instance.clientFight:GetAimTargetTrans().position
end

function BehaviorFunctions.BindEntityToTargetEntityBone(instanceId, targetInstanceId,BindName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not entity or not entity.moveComponent or not targetEntity or not targetEntity.moveComponent then return end
	local moveComponent = entity.moveComponent
	local moveType = moveComponent.moveType
	if moveType ~= FightEnum.MoveType.Bind then
		LogErrorf("目标移动类型错误")
	end
	moveComponent.moveComponent:SetBindTarget(targetEntity, BindName)
end

function BehaviorFunctions.BindTransform(instanceId, bindName, bindOffset, targetInstanceId)
	local curEntity = BehaviorFunctions.GetEntity(instanceId)
	local bindEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not curEntity or not bindEntity then
		LogError("设置实体缺失")
		return
	end

	local offset = {bindOffset.x, bindOffset.y, bindOffset.z}
	curEntity.clientTransformComponent:SetBindTransform(bindName, true, true, offset, nil, nil, nil, bindEntity)
end

function BehaviorFunctions.RemoveBindTransform(instanceId)
	local curEntity = BehaviorFunctions.GetEntity(instanceId)
	curEntity.clientTransformComponent:RemoveBindTrans()
end

function BehaviorFunctions.ResetEntityMoveComponent(instanceId)
	--local entity = BehaviorFunctions.GetEntity(instanceId)
	--if not entity or not entity.moveComponent then return end
	--entity.moveComponent:ResetMoveComponent()
end

function BehaviorFunctions.GetEcoEntityLevel(type)
	return mod.WorldLevelCtrl:GetEcoEntityLevel(type)
end

-- BehaviorFunctions.SetExtraMoveCheckDistance(2, 1)
function BehaviorFunctions.SetExtraMoveCheckDistance(instanceId, radius)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	entity.moveComponent:SetExtraMoveCheckDistance(radius)
end

function BehaviorFunctions.SetBgmState(stateGroup, state)
	BgmManager.Instance:SetBgmState(stateGroup, state)
end

function BehaviorFunctions.GetBgmState(stateGroup)
	return BgmManager.Instance:GetBgmState(stateGroup)
end

function BehaviorFunctions.SetActiveBGM(state)
	if state == "TRUE" then
		SoundManager.Instance:PlayBgmSound("Bgm_Logic")
	end
	BgmManager.Instance:SetActiveBGM(state)
end

function BehaviorFunctions.PrintBgmState()
	BgmManager.Instance:PrintBgmState()
end

function BehaviorFunctions.ShowPartnerGetWindow(partnerId, instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	WindowManager.Instance:OpenWindow(CatchPartnerWindow, {partnerId = partnerId, entity = entity})
end

function BehaviorFunctions.GetItemQuality(itemId)
	local itemCfg = ItemConfig.GetItemConfig(itemId)
	if not itemCfg then return 0 end
	return itemCfg.quality
end

function BehaviorFunctions.SetInputActionEnable(opType, keyEvent, enable)
	InputManager.Instance:SetActionEnable(opType, keyEvent, enable)
end

function BehaviorFunctions.GetTransportWorldPos(instanceId, distance, isScreenPos, isOperation)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local entityPos = entity.clientTransformComponent.transform:Find("CameraTarget").position
	local position
	local LineCheckLayer = FightEnum.LayerBit.Default | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
	-- 屏幕坐标
	if isScreenPos then
		local ScreenW = Screen.width * 0.5
		local ScreenH = Screen.height * 0.5
		-- 这里需要加上相机和角色的位置差值
		local cameraPos = CameraManager.Instance.cameraTransform.position
		local calcDis = Vec3.Distance(entityPos, cameraPos)
		distance = distance + calcDis
		position = CustomUnityUtils.GetScreenRayWorldPos(CameraManager.Instance.mainCameraComponent, ScreenW, ScreenH, distance, 0, LineCheckLayer)
	else
		local moveEvent = BehaviorFunctions.fight.operationManager:GetMoveEvent()
		local x, y, z
		if isOperation and moveEvent then
			local rotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
			x, y, z = Quat.MulVec3A(rotate, Vec3.forward * distance)
		else
			x, y, z = Quat.MulVec3A(entity.transformComponent.rotation, Vec3.forward * distance)
		end

		local newPos = Vec3.New(entityPos.x + x, entityPos.y + y, entityPos.z + z)
		position = newPos

		local newx, newy, newz = CustomUnityUtils.RaycastRefPosVal(entityPos.x, entityPos.y, entityPos.z, newPos.x, newPos.y, newPos.z, LineCheckLayer)
		position.x = newx
		position.y = newy
		position.z = newz

		local dir = position - entityPos
		local normDir = Vec3.Normalize(dir)
		position = position - normDir
	end

	return position
	-- BehaviorFunctions.TransportByInstanceId(instanceId, position)
end

function BehaviorFunctions.CheckEntityIsInCameraView(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local viewPos = UtilsBase.WorldToViewportPoint(entity.transformComponent.position.x, entity.transformComponent.position.y, entity.transformComponent.position.z)
	if viewPos.z < 0 then 
		return false
	end
	if viewPos.x < 0 or viewPos.y < 0 or viewPos.x > 1 or viewPos.y > 1 then
		return false
	end

	return true
end

function BehaviorFunctions.TransportByInstanceId(instanceId, posX, posY, posZ, delayTime)
	delayTime = delayTime or 0
	local entity = BehaviorFunctions.GetEntity(instanceId)
	LuaTimerManager.Instance:AddTimer(1, delayTime, function()
		-- local entityPos = entity.transformComponent.position
		-- if entityPos.y ~= posY then
		-- 	entity.moveComponent:SetAloft(true)	
		-- end
		entity.transformComponent:SetPosition(posX, posY, posZ)
    end)
end

function BehaviorFunctions.SetCameraColliderDamping(damping)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraColliderDamping(damping)
end

function BehaviorFunctions.SetCameraVerticalRange(min,max)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraVerticalRange(min,max)
end

function BehaviorFunctions.SetCameraHorizontalRange(min,max)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraHorizontalRange(min,max)
end

function BehaviorFunctions.EnterHackingMode(args)
	local hackManager = BehaviorFunctions.fight.hackManager
	if hackManager then
		hackManager:EnterHackingMode(args)
	end
end

function BehaviorFunctions.ExitHackingMode(isBreak)
	local hackManager = BehaviorFunctions.fight.hackManager
	if hackManager then
		hackManager:ExitHackingMode(isBreak)
	end
end

function BehaviorFunctions.OpenBluePrintWindow()
	local buildManager = Fight.Instance.clientFight.buildManager
	if buildManager then
		buildManager:OpenBluePrintWindow()
	end
end

function BehaviorFunctions.OpenBuildControlPanel()
	local buildManager = Fight.Instance.clientFight.buildManager
	if buildManager then
		buildManager:OpenBuildControlPanel()
	end
end

function BehaviorFunctions.GetHackMode()
	local hackManager = BehaviorFunctions.fight.hackManager
	if hackManager then
		return hackManager:GetHackMode()
	end
end
-- 设置车辆损坏
function BehaviorFunctions.SetCarBroken(car,bool)
    Fight.Instance.entityManager:CallBehaviorFun("OnSetCarBroken", car,bool)
end
-- 设置车辆禁止下车
function BehaviorFunctions.SetDisableGetOffCar(car,bool)
    Fight.Instance.entityManager:CallBehaviorFun("DisableGetOffCar", car,bool)
end
-- 强制刹停
function BehaviorFunctions.CarBrake(car,bool)
    Fight.Instance.entityManager:CallBehaviorFun("OnCarBrake", car,bool)
end

-- 设置下车
function BehaviorFunctions.GetOffCar(skipDuration)
	
	local instanceId = BehaviorFunctions.GetCtrlEntity()
	local car = Fight.Instance.entityManager:GetTrafficCtrlEntity(instanceId)
	if car then
		Fight.Instance.entityManager:CallBehaviorFun("OnStopDrive", car,skipDuration)
	end
end
-- 直接设置驾驶状态
function BehaviorFunctions.SetPlayerDrive(car,role,bool)
	if bool then
		Fight.Instance.entityManager:CallBehaviorFun("onDroneDrive", car,role,true)
	else
		Fight.Instance.entityManager:CallBehaviorFun("OnStopDrive", car,true)
	end
end

--获取当前是否处于驾驶状态
function BehaviorFunctions.CheckCtrlDrive()
	local instanceId = BehaviorFunctions.GetCtrlEntity()
	local ctrlIstanceId = Fight.Instance.entityManager:GetTrafficCtrlEntity(instanceId)
	return ctrlIstanceId ~= nil
end
--获取能否进入驾驶
function BehaviorFunctions.CheckCanPlayDrive()
	local instanceId = BehaviorFunctions.GetCtrlEntity()
	local ctrlIstanceId = Fight.Instance.entityManager:GetTrafficCtrlEntity(instanceId)
	local inHenshin = BehaviorFunctions.GetPartnerHenshinState(instanceId)
	local hideRoleKey = BehaviorFunctions.HasEntitySign(instanceId,10000009)
	
	local partnerAlive = BehaviorFunctions.HasEntitySign(instanceId,600000)
	local canWheel = mod.AbilityWheelCtrl.canOpenFightAbilityWheel
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local checkState = entity.stateComponent:IsState(FightEnum.EntityState.Idle) or entity.stateComponent:IsState(FightEnum.EntityState.Move)
	

	return canWheel and not partnerAlive and not ctrlIstanceId and not hideRoleKey and (not inHenshin or inHenshin == FightEnum.PartnerHenshinState.None) and BehaviorFunctions.CanCtrl(instanceId)
end

--获取角色是否处于驾驶状态
function BehaviorFunctions.CheckEntityDrive(roleInstanceId)
	local ctrlIstanceId = Fight.Instance.entityManager:GetTrafficCtrlEntity(roleInstanceId)
	return ctrlIstanceId ~= nil
end

--获取玩家驾驶的车辆实体id
function BehaviorFunctions.GetDrivingEntity(roleInstanceId)
	local ctrlIstanceId = Fight.Instance.entityManager:GetTrafficCtrlEntity(roleInstanceId)
	return ctrlIstanceId
end

-- 画道路指引线, 固定点静态连线
function BehaviorFunctions.DrawRoadPath1(targetPosList,color)

	color = color or FightEnum.NavDrawColor.Default
	return Fight.Instance.mapNavPathManager:_DrawGuideEffect(1,targetPosList,color)
end
-- 画道路指引线，当前角色到静态点
function BehaviorFunctions.DrawRoadPath2(targetPos,unloadDis,color)
	
	color = color or FightEnum.NavDrawColor.Default
	return Fight.Instance.mapNavPathManager:_DrawGuideEffect(2,targetPos,unloadDis,color)
end
-- 画道路指引线，当前角色到实体
function BehaviorFunctions.DrawRoadPath3(instanceid,unloadDis,color)
	
	color = color or FightEnum.NavDrawColor.Default
	return Fight.Instance.mapNavPathManager:_DrawGuideEffect(3,instanceid,unloadDis,color)
end
-- 卸载指定道路指引线
function BehaviorFunctions.UnloadRoadPath(instanceid)
	
	Fight.Instance.mapNavPathManager:_RemoveGuideEffect(instanceid)
	
end
-- 卸载所有道路指引线
function BehaviorFunctions.UnloadRoadPathAll()
	
	Fight.Instance.mapNavPathManager:_RemoveGuideEffectAll()
end



-- 召唤载具
function BehaviorFunctions.SummonCar(entityId)
	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return 
	end
	return trafficManager:SummonCar(entityId)
end


-- 取消召唤载具
function BehaviorFunctions.FreeSummonCar(summonInstanceId)
	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return 
	end
	trafficManager:FreeSummonCar(summonInstanceId)
end

---设置车辆按位置前进
---@param instanceId any
---@param loop 是否循环
---@param args any
---@param ignoreCross 是否无视红绿灯
---@param motorValue 马达值
function BehaviorFunctions.StartCarFollowPath(instanceId,loop,args,ignoreCross,motorValue)
	if not args or #args == 0 then
		return 
	end

	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return 
	end
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return 
	end
	local cachePath = {}
	local startPos = args[1]
	local startTrackPoint = trafficManager:CreateTrackPoint(startPos,1)
	table.insert(cachePath,startTrackPoint)

	local findStreetFail = false
	if #args > 1 then
		for i = 2, #args, 1 do
			local v = args[i]
			if not trafficManager:GetTrackPathTarget(startPos,v,cachePath,false,nil,nil,ignoreCross) then
				findStreetFail = true
			end
			startPos = v
		end

		if loop then
			trafficManager:GetTrackPathTarget(args[#args],args[1],cachePath,false,nil,nil,ignoreCross)
		else
			local endTrackPoint = trafficManager:CreateTrackPoint(args[#args],1)
			table.insert(cachePath,endTrackPoint)
		end
	else
		findStreetFail = true
	end


	
	--trafficManager:DrawPoints(cachePath,"entityId")
	if not findStreetFail then
		if entity.moveComponent.config.MoveType == FightEnum.MoveType.TrackPoint then
			entity.moveComponent.moveComponent:SetEnable(true)
			--entity.moveComponent.moveComponent:SetRoadPointCheckBlock(false)
			entity.moveComponent.moveComponent:SetTrackPath(cachePath, trafficManager.trafficParams,nil,loop,motorValue,true)
		end
	else
		entity.transformComponent:SetPosition(args[1].x, args[1].y, args[1].z)
	end
end


-- 设置车辆按步数前进
function BehaviorFunctions.StartCarRoute(instanceId,step,ignoreCross,motorValue)

	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return 
	end
	
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return 
	end

	local pos = entity.transformComponent:GetPosition()
	local streetId= trafficManager:GetClosestStreet(pos)

	
	local nextPointIndex,roadLine = trafficManager:GetClosestStartPointIndex(pos,streetId)

	if streetId then
		local street = trafficManager:GetStreetCenterData(streetId)
		local temp = {}
		
		local trackPoint = trafficManager:CreateTrackPoint(pos,1)

		table.insert(temp, trackPoint)

		local startData = {pointIndex = nextPointIndex,roadLine = roadLine}
		local trackPath = trafficManager:GetTrackPath(street,startData,temp,step,nil,nil,nil,ignoreCross)
		--trafficManager:DrawPoints(trackPath,"entityId")

		if entity.moveComponent.config.MoveType == FightEnum.MoveType.TrackPoint then
			entity.moveComponent.moveComponent:SetEnable(true)
			--entity.moveComponent.moveComponent:SetRoadPointCheckBlock(false)
			entity.moveComponent.moveComponent:SetTrackPath(trackPath, trafficManager.trafficParams,nil,nil,motorValue,true)
		end
	end
end

function BehaviorFunctions.SetCarEffectEnable(instanceId)

	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return 
	end
	
	if entity.moveComponent.config.MoveType == FightEnum.MoveType.TrackPoint then
		entity.moveComponent.moveComponent:SetEffectEnable(true)
	end
end
function BehaviorFunctions.EndCarRoute(instanceId,blockDistance)
	
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return 
	end
	
	if entity.moveComponent.config.MoveType == FightEnum.MoveType.TrackPoint then
		entity.moveComponent.moveComponent:SetEnable(false,nil,blockDistance)
		entity.moveComponent.moveComponent:SetTccaBlock(blockDistance)
	end
end

function BehaviorFunctions.CarEnableCheckObstacle(instanceId,ison)
	
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return 
	end
	
	if entity.moveComponent.config.MoveType == FightEnum.MoveType.TrackPoint then
		entity.moveComponent.moveComponent:EnableCheckObstacle(ison)
	end
end


function BehaviorFunctions.AddCarMotion(instanceId,aiCarMotion)
	
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return 
	end

	if entity.moveComponent.config.MoveType == FightEnum.MoveType.TrackPoint then
		
		local controller =  entity.moveComponent.moveComponent:GetAiCarController()
		
		controller:AddMotion(aiCarMotion)
	end
end



function BehaviorFunctions.EnterControlDroneMode(targetInstanceId, isSetState)
	local hackManager = BehaviorFunctions.fight.hackManager
	if hackManager then
		return hackManager:OpenDronePanel(targetInstanceId, isSetState)
	end
end

function BehaviorFunctions.ExitControlDroneMode(isSetState)
	local hackManager = BehaviorFunctions.fight.hackManager
	if hackManager then
		return hackManager:CloseDronePanel(isSetState)
	end
end

function BehaviorFunctions.SetLevelCamera(instanceId)
	return BehaviorFunctions.fight.clientFight.cameraManager:SetLevelCamera(instanceId)
end

function BehaviorFunctions.GetLevelCameraParamTable()
	return BehaviorFunctions.fight.clientFight.cameraManager:GetLevelCameraParamTable()
end

function BehaviorFunctions.SetLevelCameraParamTable(params)
	BehaviorFunctions.fight.clientFight.cameraManager:SetLevelCameraParamTable(params)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraState(FightEnum.CameraState.Level)
end

function BehaviorFunctions.SetCollisionLayer(instanceId, layer)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.collistionComponent then
		entity.collistionComponent:SetCollisionLayer(layer)
	end
end

function BehaviorFunctions.IsMercenaryHuntArea(position, mapId)
	local forbidAreaCfg = MercenaryHuntConfig.GetForbidHuntArea(mapId)
	if not forbidAreaCfg then
		return false
	end

	for _, area_id in pairs(forbidAreaCfg) do
		if BehaviorFunctions.CheckPointInArea(position, area_id, FightEnum.AreaType.Mercenary, mapId) then
			return true
		end
	end

	return false
end

function BehaviorFunctions.ShowPartnerTips(partner_id)
	BehaviorFunctions.fight.noticeManger:AddNewPartner(partner_id)
end

function BehaviorFunctions.SetAimTarget(instanceId, isSet)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	local aimTargetTrans 
	if isSet then
		aimTargetTrans = Fight.Instance.clientFight:GetAimTargetTrans()
	end

	entity.clientTransformComponent:SetGroupVisible("AimGroup", isSet)
	
	local transform = entity.clientTransformComponent:GetTransform()
	CustomUnityUtils.SetAimTarget(transform, aimTargetTrans)
end

function BehaviorFunctions.CustomFSMTryChangeState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.customFSMComponent then
		return entity.customFSMComponent:TryChangeState()
	end
	return false
end

function BehaviorFunctions.GetCustomFSMState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.customFSMComponent then
		return entity.customFSMComponent:GetState()
	end
end

function BehaviorFunctions.GetCustomFSMSubState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.customFSMComponent then
		return entity.customFSMComponent:GetSubState()
	end
end

function BehaviorFunctions.SetBlackBoardValue(key, value)
	CustomDataBlackBoard.Instance:ChangeBlackBoardData(key, value)
end

function BehaviorFunctions.GetBlackBoardValue(key)
	return CustomDataBlackBoard.Instance:GetDataValue(key)
end


function BehaviorFunctions.GetEntityTransformPos(instanceId, boneName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	local pos
	local bone = entity.clientTransformComponent:GetTransform(boneName)
	if UtilsBase.IsNull(bone) then
		pos = entity.transformComponent:GetPosition()
	else 
		pos = bone.position
	end
	return pos.x, pos.y, pos.z
end

function BehaviorFunctions.GetEntityTransformRot(instanceId, boneName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	local rot
	local bone = entity.clientTransformComponent:GetTransform(boneName)
	if UtilsBase.IsNull(bone) then
		rot = entity.transfromComponent:GetRotation():ToEulerAngles()
	else 
		rot = bone.rotation.eulerAngles
	end

	return rot.x, rot.y, rot.z
end


function BehaviorFunctions.SetOnlyKeyInput(keyType, state)
	InputManager.Instance:SetOnlyKeyInputState(keyType, state)
end

function BehaviorFunctions.GetOnlyKey()
	return InputManager.Instance:GetOnlyKeyInputState()
end

function BehaviorFunctions.SetEntityBineVisible(instanceId, name, visible)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	entity.clientTransformComponent:SetBineVisible(name, visible)
end

function BehaviorFunctions.SetEntityTransformVisible(instanceId, name, visible)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	entity.clientTransformComponent:SetTransformVisible(name, visible)
end


function BehaviorFunctions.ShowCoreUIEffect(instanceId, index, active, percent,...)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	EventMgr.Instance:Fire(EventName.ShowCoreUIEffect, entity, index, active, percent, ...)
end

function BehaviorFunctions.SetTrafficEnable(enable)
	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return 
	end
	
	trafficManager:SetTrafficEnable(enable)
end
function BehaviorFunctions.EnableRoadEdge(isOn)

	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return 
	end
	
	trafficManager:EnableRoadEdge(isOn)
end
function BehaviorFunctions.SetTrafficMode(mode,startCb,endCb)
	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return 
	end
	mod.GameSetCtrl:SetDrive(GameSetConfig.SaveKey.TrafficMode, mode)
	trafficManager:SetTrafficMode(mode,startCb,endCb)
end

function BehaviorFunctions.SetTrafficCameraMode(mode)
	local cameraManager = BehaviorFunctions.fight.clientFight.cameraManager
	if not cameraManager then 
		return 
	end
	mod.GameSetCtrl:SetDrive(GameSetConfig.SaveKey.DriveCameraCentralAuto, mode)
	local camera = cameraManager:GetCurCamera()
	if camera.SetTrafficCameraMode then
		camera:SetTrafficCameraMode()
	end
end


function BehaviorFunctions.SetEntityDeathRemainFrame(instanceId, frame)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.timeoutDeathComponent then
		entity.timeoutDeathComponent:SetRemainFrame(frame)
	end
end

function BehaviorFunctions.GetTrafficCtrlEntity()
	local curEntityId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	local ctrlId = Fight.Instance.entityManager:GetTrafficCtrlEntity(curEntityId)
	if ctrlId then
		return BehaviorFunctions.GetEntity(ctrlId)
	end
end

---临时创建车辆
function BehaviorFunctions.CreateDebugCar()
	local curEntityId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	local entity = Fight.Instance.entityManager:GetEntity(curEntityId)
	local pos = entity.transformComponent:GetPosition()

	local callback = function()

		local car =  BehaviorFunctions.CreateEntity(2040811,nil,pos.x, pos.y, pos.z)

		local posCache = {}
		table.insert(posCache ,pos)
		table.insert(posCache ,Vec3.New(1050.05823,107.552994,260.426605))
		
		BehaviorFunctions.StartCarFollowPath(car,true,posCache,true ,0.1)
		BehaviorFunctions.DrawRoadPath3(car)
		BehaviorFunctions.AddCarMotion(car,CarMotionFactory.CreateObstacleMotion(10,true));
		BehaviorFunctions.AddCarMotion(car,CarMotionFactory.CreateUnStopMotion(10));
	end
	BehaviorFunctions.fight.clientFight.assetsNodeManager:LoadEntity(2040811, callback)
	
	
	--BehaviorFunctions.StartCarRoute(car,100,true)
	--BehaviorFunctions.CarEnableCheckObstacle(car,false)
end



function BehaviorFunctions.ChangeDisableMask(instanceId, key, value)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:DisableButton(key, value)
	local btnName = FightEnum.KeyEvent2Btn[key] or FightEnum.KeyEvent2BehaviorBtn[key]
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if not mainUI then
		return
	end
	local skillPanel = mainUI.panelList["FightNewSkillPanel"]
	skillPanel:ChangeDisableMaskByButtonName(btnName, value)
end

function BehaviorFunctions.SetNpcMailState(instanceId, state)
	local npcId = BehaviorFunctions.GetNpcId(instanceId)
	BehaviorFunctions.fight.entityManager.npcEntityManager:SetNpcMailState(npcId, state)
end

function BehaviorFunctions.SetNpcCallState(instanceId, state)
	local npcId = BehaviorFunctions.GetNpcId(instanceId)
	BehaviorFunctions.fight.entityManager.npcEntityManager:SetNpcCallState(npcId, state)
end

function BehaviorFunctions.DoCrossSpace(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity:CallBehaviorFun("DoBehaviorCrossSpace", instanceId)
	end
end

function BehaviorFunctions.SetBatteryVisible(visible)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if mainUI then
		mainUI:SetBatteryVisible(visible)
	end
end

function BehaviorFunctions.SetRamVisible(visible)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if mainUI then
		mainUI:SetRamVisible(visible)
	end
end

function BehaviorFunctions.SetAtomizePointsConfig(config)
	--先设置一遍进出类型
	for k, v in pairs(config or {}) do
		local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId)
		local point = BehaviorFunctions.GetEntity(instanceId or v.instanceId)
		if point then
			config[k].instanceId = point.instanceId
			point:CallBehaviorFun("SetAtomizePointInteractType", v.interactType)
		else
			LogError("AtomizePoint 尚未实例化 ")
		end
	end

	for _, v in pairs(config or {}) do
		local point = BehaviorFunctions.GetEntity(v.instanceId)
		if point then
			point:CallBehaviorFun("SetAtomizePointConfig", v, config)
		end
	end
end

function BehaviorFunctions.WorldTimeLineSwitch(mapId)
	WorldSwitchTimeLine.EnterMap(mapId)
end

function BehaviorFunctions.SetEntityHackEnable(instanceId, enable)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		entity.hackingInputHandleComponent:SetEnable(enable)
	end
end

function BehaviorFunctions.OpenPartnerFightBanner(instanceId)
	if instanceId then
		local partnerEntity = BehaviorFunctions.GetEntity(instanceId)
		local partnerList = Config.DataPartnerMain.FindbyEntityId[partnerEntity.entityId]
		if not partnerList then
			LogError("无法根据配从实体Id获取到配从信息")
		else
			if PartnerFightBannerPanel.isShow then
				PanelManager.Instance:ClosePanel(PartnerFightBannerPanel)
				LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
					PanelManager.Instance:OpenPanel(PartnerFightBannerPanel, {partnerId = next(partnerList)}, UIDefine.CacheMode.hide)
				end)
			else
				PanelManager.Instance:OpenPanel(PartnerFightBannerPanel, {partnerId = next(partnerList)}, UIDefine.CacheMode.hide)
			end
		end
	else
		local roleInstanceId = BehaviorFunctions.GetCtrlEntity()
		local roleEntity = BehaviorFunctions.GetEntity(roleInstanceId)
		local uniqueId = mod.RoleCtrl:GetRolePartner(roleEntity.masterId)
		local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
		if partnerData and partnerData.template_id then
			PanelManager.Instance:OpenPanel(PartnerFightBannerPanel, {partnerId = partnerData.template_id}, UIDefine.CacheMode.hide)
		else
			LogError("玩家背包中没有配从")
		end
	end

end

function BehaviorFunctions.SetEntityTrackPointEnable(instanceId, enable)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return 
	end
	
	if entity.moveComponent.config.MoveType == FightEnum.MoveType.TrackPoint then
		local moveClass = entity.moveComponent.moveComponent
		moveClass:SetEnable(enable, enable)
	end
end

function BehaviorFunctions.SetCameraMouseInput(isInput)
	BehaviorFunctions.fight.clientFight.inputManager:SetCameraMouseInput(isInput)
end

function BehaviorFunctions.GetEntitySignSound(instanceId, signType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.clientSoundComponent  then
		return false
	end
	
	return entity.clientSoundComponent:GetSignSound(signType)
end

function BehaviorFunctions.WeaponPreciseTargetPointMove(instanceId, targetBoneName, isBindTarget, isRevert, targetOffset, moveFrame, maxSpeed, minSpeed)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.clientEntity.weaponComponent then
		return false
	end
	targetOffset = targetOffset or {0, 0, 0}
	maxSpeed = maxSpeed or 999
	minSpeed = minSpeed or 0
	entity.clientEntity.weaponComponent:PTMMove(moveFrame, maxSpeed, minSpeed, isRevert, targetBoneName, isBindTarget, targetOffset)
end

function BehaviorFunctions.CheckEntityHasComponents(instanceId, componentType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.components[componentType] then
		return true
	end

	return false
end

function BehaviorFunctions.CheckNpcCanMail(npcId)
	return BehaviorFunctions.fight.entityManager.npcEntityManager:CheckNpcCanMail(npcId)
end

function BehaviorFunctions.CheckNpcCanCall(npcId)
	return BehaviorFunctions.fight.entityManager.npcEntityManager:CheckNpcCanCall(npcId)
end

function BehaviorFunctions.IsStaminaOverdrawn()
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		return
	end

	return player.fightPlayer:IsStaminaOverdrawn()
end

function BehaviorFunctions.IsStaminaRecoveryDelayed()
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		return
	end

	return player.fightPlayer:IsStaminaRecoveryDelayed()
end

function BehaviorFunctions.GetWeaponPosition(instanceId, boneName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then return end
	local weaponComponent = entity.clientEntity.weaponComponent
	if not weaponComponent then return end
	return weaponComponent:GetWeaponPosition(boneName)
end

function BehaviorFunctions.GetFightMap()
	return BehaviorFunctions.fight:GetFightMap()
end

function BehaviorFunctions.OpenResourceDuplicateUi(ecoId)
	local resDupId = ResDuplicateConfig.GetResDupIdByEcoId(ecoId)
	if not resDupId then return end

	WindowManager.Instance:OpenWindow(ResDuplicateWindow, {resDupId.id})
end

function BehaviorFunctions.OpenCitySimulationMainWindow(npcId)
	local params , cameraParams = StoryConfig.GetNPCCitySimulationJump(npcId)
	
	WindowManager.Instance:OpenWindow(EntrustmentChoiceWindow, {shopId = params[1]})
end

function BehaviorFunctions.DoJumpToSystemByTypeAndInstanceId(type, instanceId)
	JumpToSystemConfig.DoJumpToSystemByTypeAndInstanceId(type, instanceId)
end

function BehaviorFunctions.OpenTaskDuplicateUiByNpc(npcId)
	local params , cameraParams = StoryConfig.GetNpcTaskDuplicateJump(npcId)
	BehaviorFunctions.OpenTaskDuplicateUi(params[1])
end

function BehaviorFunctions.OpenTaskDuplicateUi(duplicateId)
	WindowManager.Instance:OpenWindow(TaskDuplicateWindow, {resDupId = duplicateId})
end

function BehaviorFunctions.OpenNightMareDuplicateUi(typeId)
	WindowManager.Instance:OpenWindow(NightMareMainWindow, {typeId = typeId})
end

function BehaviorFunctions.OpenNightMareDuplicateUiByNpc(npcId)
	local params , cameraParams , condition = StoryConfig.GetNpcNightMareDuplicateJump(npcId)
	local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(condition)
	if isPass then
		BehaviorFunctions.OpenNightMareDuplicateUi(params[1])
	end
end

function BehaviorFunctions.OpenCitySimulationMainWindow(npcId)
	local params , cameraParams = StoryConfig.GetNPCCitySimulationJump(npcId)

	WindowManager.Instance:OpenWindow(EntrustmentChoiceWindow, {shopId = params[1]})
end

function BehaviorFunctions.GetDuplicateSuccess(systemDuplicateId)
	local stateInfo = mod.DuplicateCtrl:GetDuplicateStateBySysId(systemDuplicateId)
	if not stateInfo then
		return false
	end
	return stateInfo.win_times > 0
end

--发送副本进度 
function BehaviorFunctions.SendDuplicateProgress(key, value)
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end
	
	mod.DuplicateCtrl:SetDuplicateProgressBykey(key, value)
	local progress = mod.DuplicateCtrl:GetDuplicateProgressByIpairs()
	mod.DuplicateFacade:SendMsg("duplicate_progress_base", {progress_list = progress})
end

--返回当前副本的进度
function BehaviorFunctions.GetDuplicateProgress(key)
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end
	local progress = mod.DuplicateCtrl:GetDuplicateProgress()
	
	return progress[key]
end

--更新复活点信息
function BehaviorFunctions.UpdateDuplicateRevivePos(pos)
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end
	mod.DuplicateCtrl:SetDuplicatePos(pos)
	local struct_position = {
		pos_x = math.floor(pos.x * 10000),
		pos_y = math.floor(pos.y * 10000),
		pos_z = math.floor(pos.z * 10000),
	}
	local rot = Quat.New(pos.rotX, pos.rotY, pos.rotZ, pos.rotW):ToEulerAngles()
	local struct_rot = {
		pos_x = math.floor(rot.x * 10000),
		pos_y = math.floor(rot.y * 10000),
		pos_z = math.floor(rot.z * 10000),
	}
	mod.DuplicateFacade:SendMsg("duplicate_relive_pos_base", {pos = struct_position, rotate = struct_rot})
end

--返回复活点信息
function BehaviorFunctions.GetDuplicateRevivePos()
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end
	local pos = mod.DuplicateCtrl:GetDuplicatePos()
	if pos.x == 0 and pos.y == 0 and pos.z == 0 then
		pos = mod.DuplicateCtrl:GetDefultDuplicatePos()
	end
	return pos or {}
end

--退出副本节点
function BehaviorFunctions.ExitDuplicate()
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end
	local duplicateManager = BehaviorFunctions.fight.duplicateManager
	if duplicateManager then
		duplicateManager:ExitDuplicate()
	end
end

--开关副本倒计时
function BehaviorFunctions.OpenDuplicateCountdown()
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end

	return BehaviorFunctions.fight.duplicateManager:AddTimerByDuplicateID()
end

--副本倒计时暂停
function BehaviorFunctions.StopDuplicateCountdown()
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end

	local timerId = BehaviorFunctions.fight.duplicateManager:GetSystemDuplicateTimerId()
	if not timerId then
		return
	end

	BehaviorFunctions.fight.duplicateManager:RemoveTimer(timerId)
end

--副本倒计时重置
function BehaviorFunctions.ResetDuplicateCountdown()
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end

	local timerId = BehaviorFunctions.fight.duplicateManager:GetSystemDuplicateTimerId()
	if not timerId then
		return
	end

	BehaviorFunctions.fight.duplicateManager:ResetTimer(timerId)
end

--返回副本倒计时剩余时间剩余多少帧
function BehaviorFunctions.ReturnDuplicateCountdownRemain()
	if not BehaviorFunctions.CheckIsInDup() then
		return
	end

	local timerId = BehaviorFunctions.fight.duplicateManager:GetSystemDuplicateTimerId()
	if not timerId then
		return
	end

	local remainTime = BehaviorFunctions.fight.duplicateManager:ReturnTimerTime(timerId)
	local remainFrame = remainTime / FightUtil.deltaTimeSecond
	return math.floor(remainFrame)
end

function BehaviorFunctions.StartLevelTimer(time, timerType)
	return BehaviorFunctions.fight.duplicateManager:AddTimer(time, timerType)
end

function BehaviorFunctions.StopLevelTimer(timerId)
	BehaviorFunctions.fight.duplicateManager:RemoveTimer(timerId)
end

function BehaviorFunctions.ResetLevelTimer(timerId)
	BehaviorFunctions.fight.duplicateManager:ResetTimer(timerId)
end

function BehaviorFunctions.SetLevelTimerPauseState(timerId, state)
	BehaviorFunctions.fight.duplicateManager:SetTimerPauseState(timerId, state)
end

function BehaviorFunctions.ReturnLevelTimerTime(timerId)
	return BehaviorFunctions.fight.duplicateManager:ReturnTimerTime(timerId)
end

function BehaviorFunctions.AddLevelTimerTime(timerId, time)
	BehaviorFunctions.fight.duplicateManager:AddTimerTime(timerId, time)
end

--当前是否处于副本状态
function BehaviorFunctions.CheckIsInDup()
	local isDup = mod.WorldMapCtrl:CheckIsDup()
	if not isDup then
		LogError("当前不处于副本状态")
		return false
	end
	return true
end

function BehaviorFunctions.SetMotionBlur(state, quality, intensity, clamp, useMask)
	CustomUnityUtils.SetMotionBlur(state, quality, intensity, clamp, useMask)
end

function BehaviorFunctions.SetDroneParams(instanceId, MaxHSpeed, hAcc, MaxVSpeed, vAcc, costElectricity)
	--PV专用,设置无人机速度和耗电参数
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then return end
	local behavior = entity.commonBehaviorComponent:GetBehaviorByName("CommonControlDroneBehavior")
	if not behavior then return end
	behavior:SetDroneParams(MaxHSpeed, hAcc, MaxVSpeed, vAcc, costElectricity)
end


function BehaviorFunctions.GetDroneParams(instanceId)
	--PV专用,设置无人机速度和耗电参数
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then return end
	local behavior = entity.commonBehaviorComponent:GetBehaviorByName("CommonControlDroneBehavior")
	if not behavior then return end
	return behavior:GetDroneParams()
end

function BehaviorFunctions.SetDroneCameraSprint(isSprint)
	--PV专用,设置无人机相机为冲刺模式
	if CameraManager.Instance.curState == FightEnum.CameraState.Drone then
		if isSprint then
			CameraManager.Instance.statesMachine:ChangeToSprint()
		else
			CameraManager.Instance.statesMachine:ChangeToNormal()
		end
	end
end


function BehaviorFunctions.SetRotateSpeed(instanceId, speed)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.rotateComponent then return end
	
	entity.rotateComponent:SetRotateSpeed(speed)
end

function BehaviorFunctions.AddCameraFovChangeData(amplitud, time)
	local params = {
		ChangeAmplitud = amplitud,
		ChangeTime = time
	}
	BehaviorFunctions.fight.clientFight.cameraManager:AddCameraFovChangeData(params)
end

function BehaviorFunctions.CheckCreatResDupBoosLinkEntity(ecoId)
	local resDupLinkCfg = ResDuplicateConfig.GetBossDupLinkConfig(ecoId)
	if not resDupLinkCfg then return end
	local linkEcoId = resDupLinkCfg.reward_eco_id
	if not linkEcoId or linkEcoId == 0 then return end
	BehaviorFunctions.ChangeEcoEntityCreateState(linkEcoId, true)
	local ecoConfig = BehaviorFunctions.fight.entityManager.ecosystemEntityManager:GetEcoEntityConfig(linkEcoId)
	if not ecoConfig then return end
	BehaviorFunctions.fight.entityManager:CreateSysEntityCtrl(ecoConfig, FightEnum.CreateEntityType.Ecosystem)
end

-- 通过生态ID创建实体, 测试时需要修改生态表怪物重生时间为负数，怪物生成地点是对应生态表的position(GM指令)
function BehaviorFunctions.CreateEcoEntity(_ecoId, _level)
	local ecoCfg = Config.DataEcosystem.data_entity_monster[tonumber(_ecoId)] or Config.DataEcosystem.data_entity_collect[tonumber(_ecoId)]
			or Config.DataEcosystem.data_entity_object[tonumber(_ecoId)] or Config.DataEcosystem.data_entity_transport[tonumber(_ecoId)];
	local level = tonumber(_level)

	if ecoCfg == nil then
		LogError("生态配置表内不存在该ID")
		return
	end
	
	if _level ~= "怪物等级" and level == nil then
		LogError("等级填写错误")
		return
	end

	local gmCfg = {}
	gmCfg.level = level
	ecoCfg.gmCfg = gmCfg
	BehaviorFunctions.fight.entityManager:CreateSysEntityCtrl(ecoCfg, FightEnum.CreateEntityType.Ecosystem, nil, true)
end

function BehaviorFunctions.CheckResourceEcoHit(ecoId)
	mod.ResDuplicateCtrl:CheckResourceEcoHit(ecoId)
end

function BehaviorFunctions.GetResDupLinkEcoId(ecoId)
	return ResDuplicateConfig.GetResDupLinkEcoId(ecoId)
end

function BehaviorFunctions.SetForceCameraAmplitudMultiple(multiple)
	return BehaviorFunctions.fight.clientFight.cameraManager:SetForceCameraAmplitudMultiple(multiple)
end

function BehaviorFunctions.CameraTargetGroupAddMember(insId, groupName, targetInsId, targetBindName, weight, radius)
	local entity = BehaviorFunctions.GetEntity(insId)
	if not entity then return end
	local groupTrans = entity.clientTransformComponent:GetTransform(groupName)
	if not groupTrans then
		LogError("缺少group对象")
		return
	end

	local cameraGroup = groupTrans:GetComponent(CinemachineTargetGroup)
	if not cameraGroup then
		LogError(string.format("该节点【%s】无CinemachineTargetGroup组件", groupName))
		return
	end

	local targetEntity = BehaviorFunctions.GetEntity(targetInsId)
	if not targetEntity then return end
	local targetTrans = targetEntity.clientTransformComponent:GetTransform(targetBindName)
	if not targetTrans then
		LogError("缺少目标对象")
		return
	end

	weight = weight or 1
	radius = radius or 1
	self.targetGroup:AddMember(targetTrans, weight, radius)
end

function BehaviorFunctions.ReturnTargetGroupMember(insId, groupName)
	local entity = BehaviorFunctions.GetEntity(insId)
	if not entity then return end

	local groupTrans = entity.clientTransformComponent:GetTransform(groupName)
	if not groupTrans then
		LogError("缺少group对象")
		return
	end

	local cameraGroup = groupTrans:GetComponent(CinemachineTargetGroup)
	if not cameraGroup then
		LogError(string.format("该节点【%s】无CinemachineTargetGroup组件", groupName))
		return
	end
	local clientEntityManager = BehaviorFunctions.fight.clientFight.clientEntityManager
	local tab = {}
	local count = cameraGroup.m_Targets == nil and 0 or cameraGroup.m_Targets.Length

	for i = 0, count - 1 do
		local data = cameraGroup.m_Targets[i]
		local target = data.target.gameObject
		local weight = data.weight
		local radius = data.radius
		local instanceId = clientEntityManager:GetEntityInstanceId(target:GetInstanceID())

		local newTab = {
			index = i,
			instanceId = instanceId,
			bindTrans = target.name,
			weight = weight
		}
		table.insert(tab, newTab)
	end
	
	return tab
end
-- BehaviorFunctions.RemoveTargetGroupMember(6, "TagrgetGroup", 2, "CameraTarget")
function BehaviorFunctions.RemoveTargetGroupMember(insId, groupName, targetInsId, targetBindName)
	local entity = BehaviorFunctions.GetEntity(insId)
	if not entity then return end
	-- local trans = entity.clientTransformComponent.transform
	-- local groupTrans = trans:Find(groupName)
	local groupTrans = entity.clientTransformComponent:GetTransform(groupName)
	if not groupTrans then
		LogError("缺少group对象")
		return
	end

	local cameraGroup = groupTrans:GetComponent(CinemachineTargetGroup)
	if not cameraGroup then
		LogError(string.format("该节点【%s】无CinemachineTargetGroup组件", groupName))
		return
	end

	local targetEntity = BehaviorFunctions.GetEntity(targetInsId)
	if not targetEntity then return end
	local targetTrans = targetEntity.clientTransformComponent:GetTransform(targetBindName)
	if not targetTrans then
		LogError("缺少目标对象")
		return
	end
	cameraGroup:RemoveMember(targetTrans)
end

-- BehaviorFunctions.GetDoppelgangerPosByTarget(2, 8, 2, 45, "Tail", 2, 2, 0, true)
-- offset：距离中心的距离
-- angleOffset：每一次检测的角度
-- targetPart:目标部位,如果没有就按照当前锁定的部位
-- ingoreHeight：忽略高度，用在大体型/多部位怪上
-- randomNum:返回随机个数
-- randomAngleOffset:随机的角度修正 正负加到角度上
-- heightCheck:返回的pos是否贴地
-- safeguard:是不是要留一个pos做保底值
-- 获取分身生成位置
function BehaviorFunctions.GetDoppelgangerPosByTarget(instanceId, targetInstanceId, offset, angleOffset, targetPart, ingoreHeight, randomNum, randomAngleOffset, heightCheck, safeguard)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetE = BehaviorFunctions.GetEntity(targetInstanceId)
	if not entity or not targetE then
		return
	end

	-- 找部位先 有指定部位就用指定部位 没有就用当前锁定的部位 都没有就找第一个
	-- 然后算出一个对应的UI包围框
	local targetParts = targetE.partComponent:GetPart(targetPart)
	local colliders = targetParts:GetColliderList()
	local t = {}
	for k, v in pairs(colliders) do
		local bounds = v.colliderCmp.bounds
		local uiMinTP = UtilsBase.WorldToUIPointBase(bounds.min.x, bounds.min.y, bounds.min.z)
		local uiMaxTP = UtilsBase.WorldToUIPointBase(bounds.max.x, bounds.max.y, bounds.max.z)
		table.insert(t, {min = uiMinTP, max = uiMaxTP})
	end

	-- 算角色自己的框
	local parts = entity.partComponent:GetPart()
	for k, v in pairs(parts:GetColliderList()) do
		local bounds = v.colliderCmp.bounds
		local uiMinTP = UtilsBase.WorldToUIPointBase(bounds.min.x, bounds.min.y, bounds.min.z)
		local uiMaxTP = UtilsBase.WorldToUIPointBase(bounds.max.x, bounds.max.y, bounds.max.z)
		table.insert(t, {min = uiMinTP, max = uiMaxTP})
	end
	-- LogTable("t", t)

	-- 获取部位的攻击挂点
	local attackP = BehaviorFunctions.GetPartAttackTransform(targetInstanceId, targetPart)
	local attackTPx, attackTPy, attackTPz = BehaviorFunctions.GetEntityTransformPos(targetInstanceId, attackP)

	-- 算出对应方位的生成点
	-- z轴可以用于对比是不是在碰撞内
	local angle = angleOffset and angleOffset or 45
	randomAngleOffset = randomAngleOffset and math.random(-randomAngleOffset, randomAngleOffset) or 0
	angle = angle + randomAngleOffset
	if angle == 0 then angle = angleOffset end

	local times = 360 / angle
	local p = {}
	local rp = {}
	local targetP = Vec3.New(attackTPx, attackTPy, attackTPz)
	local targetR = targetE.transformComponent:GetRotation()
	local groundHeight, haveGround
	if heightCheck then
		groundHeight, haveGround = BehaviorFunctions.CheckPosHeight(targetP)
	end

	ingoreHeight = ingoreHeight or 0
	for i = 0, times - 1 do
		local c = Quat.Euler(0, targetR.y + i * angle, 0)
		local o = {}
		local temp = targetP + Vec3.forward * offset * c
		local uitempb = UtilsBase.WorldToUIPointBase(temp.x, temp.y, temp.z)
		local uitempt = UtilsBase.WorldToUIPointBase(temp.x, temp.y + ingoreHeight, temp.z)
		o.pos = temp
		o.angle = targetR.y + i * angle
		o.uiPosb = uitempb
		o.uiPost = uitempt
		table.insert(p, o)

		--rp[o.angle] = temp
		table.insert(rp, Vec3.New(temp.x, temp.y, temp.z))
		if heightCheck and haveGround then
			rp[#rp].y = rp[#rp].y - groundHeight
		end
	end
	-- LogTable("p", rp)

	-- 剔除掉不符合条件的点位
	for k = #p, 1, -1 do
		for i = 1, #t do
			local remove = false
			if (t[i].min.x <= p[k].uiPosb.x and t[i].max.x >= p[k].uiPosb.x and t[i].max.y - t[i].min.y >= p[k].uiPost.y - p[k].uiPosb.y) or
				(t[i].max.z <= p[k].uiPosb.z and t[i].min.z >= p[k].uiPosb.z) then
				table.remove(rp, k)
				--rp[p[k].angle] = nil
				table.remove(p, k)
				break
			end
		end

		if safeguard and #p == 1 then
			break
		end
	end
	-- LogTable("aap", rp)

	-- 返回随机个数
	randomNum = randomNum or 1
	if randomNum and #p > randomNum then
		for i = 1, #p - randomNum do
			local r = math.random(1, #p)
			--rp[p[r].angle] = nil
			table.remove(rp, r)
			table.remove(p, r)
		end
	end
	-- LogTable("ap", rp)

	return rp
end

function BehaviorFunctions.SearchEntityOnScreen(instanceId, camp, MaxDistance, tags)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	local CenterPos = entity.transformComponent.position
	local distanceSquare = MaxDistance * MaxDistance
	local entites = BehaviorFunctions.fight.entityManager:GetEntites()
	local targets = {}
	for _instanceId, v in pairs(entites) do
		if v.tagComponent and TableUtils.ContainValue(tags, v.tagComponent.npcTag) then
			if v.tagComponent and v.tagComponent.camp == camp and Vec3.SquareDistance(CenterPos, v.transformComponent.position) < distanceSquare then
				local transform = v.clientTransformComponent:GetTransform("HitCase")
				if transform then
					local uiPos = UtilsBase.WorldToUIPointBase(transform.position.x, transform.position.y, transform.position.z)
					if uiPos.z > 0 and math.abs(uiPos.x) <= 640 and math.abs(uiPos.y) <= 360 then
						table.insert(targets, {instanceId = _instanceId, distance = uiPos.x * uiPos.x +  uiPos.y * uiPos.y})
					end
				end
			end
		end
	end

	table.sort(targets, function(a, b) return a.distance < b.distance end)
	return targets
end

function BehaviorFunctions.CheckPosIsInScreen(position)
	local uiPos = UtilsBase.WorldToUIPointBase(position.x, position.y, position.z)
	local screenW = Screen.width * 0.5
	local screenH = Screen.height * 0.5

	return  uiPos.z > 0 and math.abs(uiPos.x) <= screenW and math.abs(uiPos.y) <= screenH
end

-- 精准位移到相对于目标的偏移位置
function BehaviorFunctions.DoPreciseMove(instanceId, targetInstanceId, offsetX, offsetY, offsetZ, frame, updateTargetFrame)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	entity.moveComponent:PreciseMove(frame, targetInstanceId, offsetX, offsetY, offsetZ, updateTargetFrame)
end

-- 精准位移到某个位置
function BehaviorFunctions.DoPreciseMoveToPosition(instanceId, x, y, z, frame)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	entity.moveComponent:PreciseMoveTo(frame, Vec3.New(x, y, z))
end

-- 精准位移到某个位置(拓展新接口)
function BehaviorFunctions.DoPreciseMoveToPositionBySpeed(instanceId, x, y, z, speed)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	entity.moveComponent:PreciseMoveToBySpeed(speed, Vec3.New(x, y, z))
end

function BehaviorFunctions.SetAttackCheckList(instanceId, idList)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.attackComponent then
		return
	end
	
	entity.attackComponent:SetCheckList(idList)
end

function BehaviorFunctions.SetAttackFilterList(instanceId, idList)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.attackComponent then
		return
	end

	entity.attackComponent:SetFilterList(idList)
end

function BehaviorFunctions.SetTrackedOffset(x, y, z)
	local cameraManager = BehaviorFunctions.fight.clientFight.cameraManager
	local camera = cameraManager:GetCurCamera()
	if camera.SetTrackedOffset then
		camera:SetTrackedOffset(x, y, z)
	end
end

function BehaviorFunctions.SetComposerOffset(x, y, z)
	local cameraManager = BehaviorFunctions.fight.clientFight.cameraManager
	local camera = cameraManager:GetCurCamera()
	if camera.SetComposerOffset then
		camera:SetComposerOffset(x, y, z)
	end
end

function BehaviorFunctions.SetPartnerContrlCameraVisible(isVisible, state)
	local cameraManager = BehaviorFunctions.fight.clientFight.cameraManager
	state = state or FightEnum.CameraState.PartnerContrlCamera
	local camera = cameraManager:GetCamera(state)
	if camera then
		if isVisible then
			camera:OnEnter()
		else
			camera:OnLeave()
		end
	end
end

function BehaviorFunctions.SetPartnerContrlCameraLockTarget(targetInstanceId, transformName, state)
	local cameraManager = BehaviorFunctions.fight.clientFight.cameraManager
	state = state or FightEnum.CameraState.PartnerContrlCamera
	local camera = cameraManager:GetCamera(state)
	if not camera then return end
	if ctx then
		if targetInstanceId then
			local target = BehaviorFunctions.GetEntity(targetInstanceId)
			if not target then
				camera:ClearTarget()
				return
			end

			local clientTransformComponent = target.clientTransformComponent
			local targetTrans = clientTransformComponent.transform
			local lookatTarget
			if transformName then
				lookatTarget = clientTransformComponent:GetTransform(transformName)
				if not lookatTarget then
					lookatTarget = targetTrans.transform:Find("CameraTarget")
				end
			else
				lookatTarget = targetTrans.transform:Find("CameraTarget")
			end
			camera:SetTarget(lookatTarget)
		else
			camera:ClearTarget()
		end
	end
end

function BehaviorFunctions.SetLookAtTargetWeight(instanceId, boneName, weight, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local target
	if boneName then
		target = entity.clientTransformComponent:GetTransform(boneName)
	else
		target = entity.clientTransformComponent.gameObject
	end

	CameraManager.Instance:SetLookAtTargetWeight(target, weight, state)
end

function BehaviorFunctions.AddLookAtTarget(instanceId, boneName, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	local target
	if boneName then
		target = entity.clientTransformComponent:GetTransform(boneName)
	else
		target = entity.clientTransformComponent.gameObject
	end
	CameraManager.Instance:AddLookAtTarget(target, state)
end

function BehaviorFunctions.RemoveAllLookAtTarget()
	CameraManager.Instance:RemoveAllLookAtTarget()
end

function BehaviorFunctions.RemoveLookAtTarget(instanceId, boneName, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local target
	if boneName then
		target = entity.clientTransformComponent:GetTransform(boneName)
	else
		target = entity.clientTransformComponent.gameObject
	end
	CameraManager.Instance:RemoveLookAtTarget(target, state)
end

function BehaviorFunctions.CheckHasTransform(instanceId, boneName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return false
	end

	local bone = entity.clientTransformComponent:GetTransform(boneName)
	if bone and not UtilsBase.IsNull(bone) then
		return true
	end

	return false
end

function BehaviorFunctions.GetCameraState()
	return BehaviorFunctions.fight.clientFight.cameraManager:GetCameraState()
end

function BehaviorFunctions.SetGoodsInteractVisible(visible)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if mainUI then
		mainUI:SetGoodsInteract(visible)
	end
end

--TODO 有临时处理部分
function BehaviorFunctions.CameraPosReduction(recenterTime, isClose, recenterEndTime)
	BehaviorFunctions.fight.clientFight.cameraManager:CameraPosReduction({RecenterTime = recenterTime}, isClose, recenterEndTime)
end

--TODO 为了优化大量NPC时的性能
function BehaviorFunctions.CheckNPCOnScreen(entity)
	local CenterPos = entity.transformComponent.position
	local x, y, z = CustomUnityUtils.WorldToViewportPoint(CenterPos.x, CenterPos.y, CenterPos.z)
	if z > 0 and x > -0.2 and x < 1.2 and y > -0.2 and y < 1.2 then
		return true
	end

	return false
end

function BehaviorFunctions.GetTrafficMode()
	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return FightEnum.TrafficMode.Normal
	end
	return trafficManager:GetTrafficMode()
end

function BehaviorFunctions.GetTrafficCameraMode()
	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
	if not trafficManager then
		return FightEnum.TrafficMode.Normal
	end
	return trafficManager.cameraMode
end

function BehaviorFunctions.SetAnimatorTimeScale(instanceId, scale)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.animatorComponent then
		entity.animatorComponent:SetAnimatorSpeed(scale)
	end
end

function BehaviorFunctions.SetEntityCollisionPriority(instanceId, priority)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.collistionComponent then
		entity.collistionComponent:SetPriority(priority)
	end
end

function BehaviorFunctions.ChangeConfigKeyVal(state, groupKey, key, val)
	BehaviorFunctions.fight.clientFight.cameraManager:ChangeConfigKeyVal(state, groupKey, key, val)
end

function BehaviorFunctions.GetCurCameraFollowTargetToScreenPos()
	local pos = BehaviorFunctions.fight.clientFight.cameraManager:GetCurCameraFollowTargetToScreenPos()
	return pos
end

function BehaviorFunctions.GetCurCameraLookAtTargetToScreenPos()
	local pos = BehaviorFunctions.fight.clientFight.cameraManager:GetCurCameraLookAtTargetToScreenPos()
	return pos
end

function BehaviorFunctions.GetShuffleList(inputTable)
    local orderedTable = {}
	local length = 0
    for k, v in pairs(inputTable) do
        table.insert(orderedTable,k)
		length = length + 1
    end

    for i = length, 2, -1 do
        local randomIndex = math.random(i)
        if i ~= randomIndex then
			orderedTable[i], orderedTable[randomIndex] = orderedTable[randomIndex], orderedTable[i]
		end
    end

    return orderedTable
end

function BehaviorFunctions.SetEntityFakeDeath(instanceId, state, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.stateComponent then
		return
	end

	entity.stateComponent.stateFSM.states[FightEnum.EntityState.Death]:SetFakeDeathParam(state, time)
end

function BehaviorFunctions.DynamicChangeCameraDistance(cameraState, isOpen, targetInsId, bindName, time, maxDis)
	CameraManager.Instance:DynamicChangeCameraDistance(cameraState, isOpen, targetInsId, bindName, time, maxDis)
end

function BehaviorFunctions.SetCameraDistance(cameraState, targetDis, allTime, isReplace)
	CameraManager.Instance:SetCameraDistance(cameraState, targetDis, allTime, isReplace)
end

function BehaviorFunctions.SetCameraDistance2(cameraState, targetDis, allTime, targetDis2, allTime2)
	CameraManager.Instance:SetCameraDistance2(cameraState, targetDis, allTime, targetDis2, allTime2)
end

function BehaviorFunctions.GetCameraDistance(state)
	return CameraManager.Instance:GetCameraDistance(state)
end

function BehaviorFunctions.SetCameraFixedLookAt(state, isOpen, targetInsId, bindName, lookAtInsId, lookAtName)
	CameraManager.Instance:SetCameraFixedLookAt(state, isOpen, targetInsId, bindName, lookAtInsId, lookAtName)
end

function BehaviorFunctions.ChangeDamageParam(type, value)
	Fight.Instance.damageCalculate:ChangeDamageParam(type, value)
end

function BehaviorFunctions.ChangeCureParam(type, value)
	Fight.Instance.damageCalculate:ChangeCureParam(type, value) 
end

function BehaviorFunctions.GetDamageParam(type)
	return Fight.Instance.damageCalculate:GetDamageParam(type)
end

function BehaviorFunctions.GetCureParam(type)
	return Fight.Instance.damageCalculate:GetCureParam(type)
end

function BehaviorFunctions.GetTranslationValue(instanceId, type, originalType, ...)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.attrComponent:GetTranslationValue(type, originalType, ...)
end

function BehaviorFunctions.AddAttrTranslation(instanceId, type, originalType, targetAttr, dynamicUpdate, ...)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.attrComponent:AddTranslation(type, originalType, targetAttr, dynamicUpdate, ...)
end

function BehaviorFunctions.RemoveAttrTranslation(instanceId, uniqueKey)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.attrComponent:RemoveTranslation(uniqueKey)
end

function BehaviorFunctions.GetRoguelikePointInfo(eventId)
	local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(eventId)
	if not eventCfg then
		LogError("缺少肉鸽事件配置，事件iD = "..eventId)
		return
	end

	local recvData = {
		positionId = eventCfg.position_id,
		logicName = eventCfg.position[1],
		position = eventCfg.position[2],
	}
	return recvData
end

function BehaviorFunctions.SetRoguelikeEventCompleteState(eventId, isComplete)
	BehaviorFunctions.fight.rouguelikeManager:SetRoguelikeEventCompleteState(eventId, isComplete)
end

function BehaviorFunctions.SetTimelineTrackCameraLookAtState(isOpen)
	BehaviorFunctions.fight.clientFight.clientTimelineManager:SetTimelineTrackCameraLookAtState(isOpen)
end

function BehaviorFunctions.SetCorrectEulerData(state, isOpen, allTime, targetEulerX, targetEulerY)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCorrectEulerData(state, isOpen, allTime, targetEulerX, targetEulerY)
end

function BehaviorFunctions.SetDynamicCameraDistance(state, isOpen, maxDis, time)
	BehaviorFunctions.fight.clientFight.cameraManager:SetDynamicCameraDistance(state, isOpen, maxDis, time)
end

function BehaviorFunctions.ChangeCameraDistance(state, isChange, changeVal)
	BehaviorFunctions.fight.clientFight.cameraManager:ChangeCameraDistance(state, isChange, changeVal)
end

function BehaviorFunctions.PlayerIdentity()
	return mod.IdentityCtrl:GetPlayerIdentity()
end

function BehaviorFunctions.PlayerNowIdentity()
	return mod.IdentityCtrl:GetNowIdentity()
end

function BehaviorFunctions.CheckSaveDialog(dialogId)
	return mod.StoryCtrl:GetSaveDialog(dialogId)
end

function BehaviorFunctions.AddBounty(type)
	mod.CrimeCtrl:AddBounty(type)
end

function BehaviorFunctions.GetBountyStar()
	return mod.CrimeCtrl:GetBountyStar()
end

function BehaviorFunctions.GoPrison()
	local prisonId,prisonPos = mod.CrimeCtrl:GetNearPrisonPos()  --mod.WorldCtrl:GetNearByPrisonPoint()
    local mapId = Fight.Instance:GetFightMap()

	local id,cmd = mod.CrimeFacade:SendMsg("crime_prison_info",1,prisonId)
	mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
			mod.CrimeCtrl:SetPrison(1,prisonId)
			mod.WorldMapFacade:SendMsg("map_enter", mapId, prisonPos.x, prisonPos.y, prisonPos.z)
			mod.CrimeCtrl:CreatePrisonGameLevel()
            --BehaviorFunctions.Transport()
        end
    end)
    --local mapConfig = mod.WorldMapCtrl:GetMapConfig(mapId)
	
    --mod.WorldMapCtrl:SendMapPrison(mapConfig.level_id, prisonPoint)
end

function BehaviorFunctions.GetProtectorType(instanceId)
	return Fight.Instance.protectorManager:GetProtectorType(instanceId)
end

function BehaviorFunctions.EnableWeakEffect(instanceId, enable)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		local aimFSM = entity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM
		aimFSM:EnableWeakEffect(enable)
	end
end

function BehaviorFunctions.SetFixedCameraVerticalDir(state, isFixed)
	BehaviorFunctions.fight.clientFight.cameraManager:SetFixedCameraVerticalDir(state, isFixed)
end

function BehaviorFunctions.GetCameraRotation()
	return BehaviorFunctions.fight.clientFight.cameraManager:GetCameraRotation()
end

function BehaviorFunctions.SetCameraFixedEulerVal(verticalVal, horizontalVal, allTime)
	return BehaviorFunctions.fight.clientFight.cameraManager:SetCameraFixedEulerVal(verticalVal, horizontalVal, allTime)
end

-- local r, p = BehaviorFunctions.GetTimelinePos(8, 600010100, 2, "Track")
-- LogTable("r", r)
-- LogTable("p", p)
function BehaviorFunctions.GetTimelinePos(instanceId, magicId, frame, trackName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	local magicCfg
	local parentInstance = entity.parent and entity.parent.instanceId or nil
	local buffCfg = MagicConfig.GetBuff(magicId, entity.entityId, nil, parentInstance)
	if not buffCfg or not next(buffCfg) then
		magicCfg = MagicConfig.GetMagic(magicId, entity.entityId, nil, parentInstance)
	else
		for i = 1, #buffCfg.MagicIds do
			magicCfg = MagicConfig.GetMagic(buffCfg.MagicIds[i], entity.entityId, nil, parentInstance)
			if magicCfg.Type ~= FightEnum.MagicType.Preform or magicCfg.Type ~= FightEnum.MagicType.CameraTrack then
				break
			end
		end
	end

	if not magicCfg or not next(magicCfg) or (magicCfg.Type ~= FightEnum.MagicType.Preform and magicCfg.Type ~= FightEnum.MagicType.CameraTrack) then
		return
	end

	local path = magicCfg.Type == FightEnum.MagicType.Preform and magicCfg.Param.TimelinePath or magicCfg.Param.CameraTrackPath
	local strs = StringHelper.Split(path, "/")
	local name = StringHelper.Split(strs[#strs], ".prefab")[1]
	local nameTable = StringHelper.Split(name, "_")

	name = ""
	for i = 1, #nameTable do
		name = name .. nameTable[i]
	end

	local rotList = Config[name.."Rotation"]
	local posList = Config[name.."Position"]

	local rTable = {}
	local pTable = {}
	local entityPos = entity.transformComponent:GetPosition()
	local entityRot = entity.transformComponent:GetRotation():ToEulerAngles()
	if trackName then
		if rotList[trackName] then
			rTable[trackName] = Vec3.New(rotList[trackName][frame][1] + entityRot.x, rotList[trackName][frame][2] + entityRot.y, rotList[trackName][frame][3] + entityRot.z)
		end

		if posList[trackName] then
			pTable[trackName] = Vec3.New(posList[trackName][frame][1] + entityPos.x, posList[trackName][frame][2] + entityPos.y, posList[trackName][frame][3] + entityPos.z)
		end
	else
		for k, v in pairs(rotList) do
			if v[frame] then
				rTable[k] = Vec3.New(v[frame][1] + entityRot.x, v[frame][2] + entityRot.y, v[frame][3] + entityRot.z)
			end
		end

		for k, v in pairs(posList) do
			if v[frame] then
				pTable[k] = Vec3.New(v[frame][1] + entityPos.x, v[frame][2] + entityPos.y, v[frame][3] + entityPos.z)
			end
		end
	end

	return rTable, pTable
end

function BehaviorFunctions.CheckIsTarget(instanceId, targetInstanceId, checkType)
	if checkType == FightEnum.AttackTarget.All then
		return true
	end

	local entity = BehaviorFunctions.GetEntity(instanceId, true)
	local target = BehaviorFunctions.GetEntity(targetInstanceId, true)
	if not entity or not target then
		return false
	end

	local tagComponent = (entity.root and entity.root.tagComponent) and entity.root.tagComponent or entity.tagComponent
	local targetTagComponent = (target.root and target.root.tagComponent) and target.root.tagComponent or target.tagComponent

	if not tagComponent or not targetTagComponent then
		return false
	end

	local targetType = tagComponent.camp == targetTagComponent.camp and FightEnum.AttackTarget.Ally or FightEnum.AttackTarget.Enemy
	local _, isPlayer = BehaviorFunctions.fight.playerManager:GetPlayer():GetEntityQTEIndex(targetInstanceId)
	if targetType ~= checkType then
		return checkType == FightEnum.AttackTarget.Player and isPlayer
	end

	return true
end

function BehaviorFunctions.SwitchUIRoulette(instanceId, key)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:SwitchUIRoulette(key)
end

-- LogError("weaponid = "..BehaviorFunctions.GetRoleWeaponId(2))
function BehaviorFunctions.GetRoleWeaponId(instanceId)
	local entityInfo = BehaviorFunctions.fight.playerManager:GetPlayer():GetEntityInfo(instanceId)
	if not entityInfo then
		return
	end

	if BehaviorFunctions.fight:IsDebugDuplicate() then
		return mod.BagCtrl:GetWeaponData(nil, entityInfo.HeroId).template_id
	else
		local uniqueId = mod.RoleCtrl:GetRoleWeapon(entityInfo.HeroId)
		local weaponData = mod.BagCtrl:GetWeaponData(uniqueId, entityInfo.HeroId)
		return weaponData.template_id
	end
end

function BehaviorFunctions.BindWeapon(instanceId, weaponId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not weaponId then
		return
	end

	entity.clientTransformComponent:BindWeapon(weaponId)
end

function BehaviorFunctions.DoHackInputKey(instanceId, key, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.hackingInputHandleComponent then
		return
	end
	state = state or FightEnum.KeyInputStatus.Down
	if key == FightEnum.KeyEvent.HackUpButton then
		entity.hackingInputHandleComponent:ClickUp(state, true)
	elseif key == FightEnum.KeyEvent.HackDownButton then
		entity.hackingInputHandleComponent:ClickDown(state, true)
	elseif key == FightEnum.KeyEvent.HackLeftButton then
		entity.hackingInputHandleComponent:ClickLeft(state, true)
	elseif key == FightEnum.KeyEvent.HackRightButton then
		entity.hackingInputHandleComponent:ClickRight(state, true)
	end
end

function BehaviorFunctions.CheckPCPlatform()
	return UtilsUI.CheckPCPlatform()
end

function BehaviorFunctions.CheckMouseDisplay()
	if Cursor.lockState == CursorLockMode.None then
		return true
	elseif Cursor.lockState == CursorLockMode.Locked  then
		return false
	end
	return InputManager.Instance and InputManager.Instance.disPlayMouse or false
end

function BehaviorFunctions.GetInputScreenMove()
	if FightMainUIView and FightMainUIView.bgInput then
		return {x = FightMainUIView.bgInput.x,y = FightMainUIView.bgInput.y}
	end
	return {x = 0, y = 0}
end

function BehaviorFunctions.StopHackingMode()
	EventMgr.Instance:Fire(EventName.ExitHackingMode)
end

function BehaviorFunctions.GetEntityElement(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local elementCmp = entity.elementStateComponent
	return elementCmp and elementCmp.config.ElementType or FightEnum.ElementType.Phy
end

function BehaviorFunctions.CheckEntityInFormation(instanceId)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	return player:IsMyEntity(instanceId)
end

function BehaviorFunctions.GetEntityInFormationIndex(instanceId)
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	local roleId = player:GetHeroIdByInstanceId(instanceId)
	local roleList = mod.FormationCtrl:GetOriginalFormation().roleList
	for i = 1, #roleList, 1 do
		if roleId == roleList[i] then
			return i
		end
	end
end

function BehaviorFunctions.GetTotalShild(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.attrComponent:GetTotalShild()
end

-- 临时的设置复活位置 后续修改到其他配置/流程中
function BehaviorFunctions.SetReviveTransportPos(x, y, z)
	mod.WorldCtrl:SetTransportPos(x, y, z)
end

function BehaviorFunctions.SetFlyMoveTarget(instanceId,targetInstanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if BehaviorFunctions.CheckEntity(targetInstanceId) then
		entity.moveComponent:SetFlyMoveTarget(targetInstanceId)
	end
end

function BehaviorFunctions.ClearFlyMoveTarget(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.moveComponent:SetFlyMoveTarget()
end
function BehaviorFunctions.SetFlyTargetPos(instanceId,pos)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity.moveComponent:SetFlyTargetPos(pos)
	end
end

function BehaviorFunctions.ClearFlyTargetPos(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity.moveComponent:SetFlyTargetPos()
	end
end

function BehaviorFunctions.IsFlyEntity(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		return entity.moveComponent.isFlyEntity
	end
end

function BehaviorFunctions.IsBuildEntity(instanceId)
	return BuildConfig.CheckInstanceIsBuild(instanceId)
end

function BehaviorFunctions.CostPlayerElectricity(costCount)
	if costCount == 0 then
		return true
	end
	costCount = costCount * (1 - BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.ElectricityCostPercent)/10000)
	costCount = costCount < 0 and 0 or costCount
	if BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurElectricityValue) >= costCount then
		BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurElectricityValue, -costCount)
		return true
	end
	return false
end

function BehaviorFunctions.ShowPartnerByAbilityWheel(instanceId, isShow)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or entity.parent.instanceId ~= 1 then
		LogError("实体附属错误")
	else
		entity.stateComponent:ChangeBackstage(isShow and FightEnum.Backstage.Foreground or FightEnum.Backstage.Background)
	end
end


--切换角色选择最佳位置
function BehaviorFunctions.GetChangeOptimumPos(instanceId,targetId,radius,type,up,down,ring)
	up = up or 1
	down = down or 1
	ring = ring or 0
	local left = type == 1
	local selfPos = BehaviorFunctions.GetPositionP(instanceId)
	--local targetPos = BehaviorFunctions.GetPositionP(targetId)
	--if targetId == nil or instanceId == targetId then
		--local go = GameObject.CreatePrimitive(PrimitiveType.Sphere)
		--UnityUtils.SetLocalPosition(go.transform, pos.x, pos.y, pos.z)
		local leftPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId,radius,90)
		local rightPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId,radius,-90)
		local leftDir = Vec3.Normalize(selfPos - leftPos)
		local rightDir = Vec3.Normalize(selfPos - rightPos)
		local disStep = (radius-ring)/10
		for i = 1, 10 do 
			local dir = left and leftDir or rightDir
			local pos = left and leftPos or rightPos
			pos = pos + dir * disStep * i
			pos.y = pos.y + up + 0.1
			local height = BehaviorFunctions.CheckPosHeight(pos)
			if height then
				pos.y = pos.y - height
				if selfPos.y - pos.y < down and not UnityUtils.LineCast(selfPos.x, selfPos.y+1.7, selfPos.z,pos.x, pos.y+1.7, pos.z) then
					--local go = GameObject.CreatePrimitive(PrimitiveType.Sphere)
					--UnityUtils.SetLocalPosition(go.transform, pos.x, pos.y, pos.z)
					--LogError("1111 "..pos.y)
					return pos,true
				end
			end
			--local x, y, z, isOk = CustomUnityUtils.GetNavmeshRandomPos(pos.x, pos.y, pos.z, 1)
			--local go = GameObject.CreatePrimitive(PrimitiveType.Sphere)
			--UnityUtils.SetLocalPosition(go.transform, pos.x, pos.y, pos.z)
			-- if isOk then
			-- 	pos.x = x
			-- 	pos.y = y
			-- 	pos.z = z
			-- end
			left = not left
		end
		--LogError("2222 "..selfPos.y)
		return selfPos,false
	--end
	
	--[[
	local dis = BehaviorFunctions.GetDistanceFromPos(selfPos,targetPos)
	local dir = selfPos - targetPos
	local targetQ = Quat.LookRotationA(dir.x,0,dir.z)
	local r = targetQ * Quat.Euler(0, 90, 0)
	local p = selfPos + r * Vec3.forward * radius
	local tempDir = p - targetPos
	local minAngle  = Quat.Angle(targetQ, Quat.LookRotationA(tempDir.x,0,tempDir.z))
	local maxAngle = minAngle + 30


	local count = 10
	local angleStep = (maxAngle - minAngle) / count / 2
	
	for i = 1, count*2 do

		local q
		if left then
			q = Quat.Euler(0, minAngle +(i/2)*angleStep, 0)
		else
			q = Quat.Euler(0, -minAngle - (i/2)*angleStep, 0)
		end
		local offsetR = targetQ * q

		local pos = targetPos + offsetR * Vec3.forward * dis
		pos.y = pos.y + 0.2
		local height = BehaviorFunctions.CheckPosHeight(pos)
		if height then
			pos.y = pos.y - height
		end
		local x, y, z, isOk = CustomUnityUtils.GetNavmeshRandomPos(pos.x, pos.y, pos.z, 1)
		--local go = GameObject.CreatePrimitive(PrimitiveType.Sphere)
		--UnityUtils.SetLocalPosition(go.transform, pos.x, pos.y, pos.z)
		if isOk then
			pos.x = x
			pos.y = y
			pos.z = z
		end
		if not UnityUtils.LineCast(pos.x, pos.y, pos.z, targetPos.x, targetPos.y, targetPos.z) then
			--local go = GameObject.CreatePrimitive(PrimitiveType.Sphere)
			--UnityUtils.SetLocalPosition(go.transform, pos.x, pos.y, pos.z)
			
			return pos
		end
	end
	return selfPos
	--]]
end

--关闭战斗界面的能力轮盘面板
function BehaviorFunctions.CloseFightAbilityWheel()
	mod.AbilityWheelCtrl:CloseFightAbilityWheel()
end

--对能力施加CD
function BehaviorFunctions.ApplyAbilityWheelCoolTime(abilityId)
	mod.AbilityWheelCtrl:ApplyCoolTime(abilityId)
end

--设置战斗界面的能力轮盘快捷键图标
function BehaviorFunctions.SetAbilityWheelIcon(skillId)
	mod.AbilityWheelCtrl:ChangeCurCtrlPartnerIcon(skillId)
end

function BehaviorFunctions.SetAbilityCanUse(abilityId, isCanUse)
	mod.AbilityWheelCtrl:SetAbilityCanUse(abilityId, not isCanUse)
end

function BehaviorFunctions.CheckAbilityCanUse(abilityId)
	return mod.AbilityWheelCtrl:CheckAbilityCanUse(abilityId)
end


function BehaviorFunctions.SetOneHandAimIk(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity.clientIkComponent:SetOneHandAim(true)
	end
end

-- 设置瞄准参数 true 单手 false 双手
function BehaviorFunctions.SetTwoHandAimIk(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity.clientIkComponent:SetTwoHandAim(true)
	end
end

--设置是否可以打开战斗能力轮盘
function BehaviorFunctions.SetCanOpenFightAbilityWheel(canOpen)
	mod.AbilityWheelCtrl:SetCanOpenFightAbilityWheel(canOpen)
end

-- 打开创角
function BehaviorFunctions.ChooseGender()
	CreateRoleWindow.OpenWindow()
end

function BehaviorFunctions.DoSetCameraFovChangeEffect(isNoEffect)
	if ctx then
		BehaviorFunctions.fight.clientFight.cameraManager:SetFovChangeEffect(isNoEffect)
	end
end

function BehaviorFunctions.GetPartnerCountByCondition(lev, quality, entityId)
	local partnerList = mod.BagCtrl:GetBagByType(BagEnum.BagType.Partner)
	local count = 0
	for k, data in pairs(partnerList) do
		local config = ItemConfig.GetItemConfig(data.template_id)
		local res = false
		if data.lev >= lev and config.quality >= quality then
			res = true
		end
		if entityId then
			res = res and config.entity_id == entityId
		end
		if res then count = count + 1 end
	end
	return count
end

function BehaviorFunctions.SetAllowDoubleJump(instanceId, allow)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:SetAllowDoubleJump(allow)
end

function BehaviorFunctions.ClosePhotoPanel()
	mod.PhotoCtrl:ClosePhoto()
end

function BehaviorFunctions.SetBuffTime(instanceId, buffInstanceId, durationFrame)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.buffComponent:SetBuffTime(buffInstanceId, durationFrame)
end

-- effectType = FightEnum.HackingEffectType. ..
function BehaviorFunctions.SetHackingEntityEffect(instanceId, effectType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		if entity.hackingInputHandleComponent then
			entity.hackingInputHandleComponent:SetEffectType(effectType)
		else
			LogError("实体 " .. instanceId .. " 没有骇入组件")
		end
	end
end

function BehaviorFunctions.CastPlayerRam(costCount)
	if costCount == 0 then
		return true
	end

	if BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurRamValue) >= costCount then
		BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurRamValue, -costCount)
		EventMgr.Instance:Fire(EventName.PlayerRamChange)
		return true
	end

	return false
end

---检查实体是否处于持续耗电状态
function BehaviorFunctions.CheckEntityContinueCostElectricityState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		return entity.hackingInputHandleComponent:GetContinueCostElectricityState()
	else
		LogError("实体 " .. instanceId .. " 没有骇入组件")
	end
end

---设置实体的持续耗电状态
function BehaviorFunctions.SetEntityContinueCostElectricityState(instanceId, isActive)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		return entity.hackingInputHandleComponent:SetContinueCostElectricityState(isActive)
	else
		LogError("实体 " .. instanceId .. " 没有骇入组件")
	end
end

--设置实体的持续耗电量
function BehaviorFunctions.SetEntityContinueCostElectricityNum(instanceId, num)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		return entity.hackingInputHandleComponent:SetContinueCostElectricityNum(num)
	else
		LogError("实体 " .. instanceId .. " 没有骇入组件")
	end
end

--检查实体的骇入组件是否处于激活状态
function BehaviorFunctions.GetEntityHackIsActiveState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		return entity.hackingInputHandleComponent:GetIsActiveState()
	else
		LogError("实体 " .. instanceId .. " 没有骇入组件")
	end
end

--设置实体骇入组件的激活状态
function BehaviorFunctions.SetEntityHackActiveState(instanceId, isActive)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		return entity.hackingInputHandleComponent:SetIsActiveState(isActive)
	else
		LogError("实体 " .. instanceId .. " 没有骇入组件")
	end
end

-- 获取对应实体ID的tagComponent的tag
function BehaviorFunctions.GetTagByEntityId(entityId)
	return BehaviorFunctions.fight.entityManager:GetTagByEntityId(entityId)
end

function BehaviorFunctions.SetEntityHackEffectIsTask(instanceId, isTask)
	Fight.Instance.hackManager:SetEntityTaskSign(instanceId, isTask)
end

function BehaviorFunctions.GetEntityHackEffectIsTask(instanceId)
	Fight.Instance.hackManager:CheckEntityIsTaskSign(instanceId)
end

function BehaviorFunctions.CheckChooseGenderFinish()
	return mod.InformationCtrl:GetPlayerInfo().sex ~= 0
end

function BehaviorFunctions.SetOrginSceneVisible(isVisible)
	BehaviorFunctions.fight.clientFight.clientMap:SetOrginSceneVisible(isVisible)
end

function BehaviorFunctions.SetBakeData(instanceId, bakeId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		return
	end
	entity.clientTransformComponent:SetBakeData(bakeId)
end

--检查骇入按钮是否开启
function BehaviorFunctions.GetHackingButtonIsActive(instanceId, hackingKey)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		return entity.hackingInputHandleComponent:GetHackingButtonIsActive(hackingKey)
	else
		LogError("实体 " .. instanceId .. " 没有骇入组件")
	end
end

--设置骇入按钮开启状态
function BehaviorFunctions.SetHackingButtonActive(instanceId, hackingKey, isActive)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		return entity.hackingInputHandleComponent:SetHackingButtonActive(hackingKey, isActive)
	else
		LogError("实体 " .. instanceId .. " 没有骇入组件")
	end
end

--论辩类型讨价还价进入入口 
function BehaviorFunctions.EnterBargain(npcInstanceId, negotiateId)
	mod.BargainCtrl:EnterBargainByNpcInstance(BargainEnum.Type.Bargain, negotiateId, npcInstanceId)
end

function BehaviorFunctions.CheckEntityInPhotoFrame(instanceId)
	return mod.PhotoCtrl:CheckEntityInPhotoFrame(instanceId)
end

function BehaviorFunctions.HideSceneObjectByPath(path, hide)
	--TODO 阮杉让临时加的，年后删除
	Fight.Instance.clientFight:SetActiveByPath(path, not hide)
end

function BehaviorFunctions.CheckAbilityWheelHasAbility(abilityId)
	return mod.AbilityWheelCtrl:GetLinkIdInWheelPos(abilityId) ~= 0 
end

function BehaviorFunctions.SetInputKeyDisable(key,state)
	BehaviorFunctions.fight.clientFight.inputManager:SetKeyDisable(key, state)
end

function BehaviorFunctions.CheckEntityOnBuildControl(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		return Fight.Instance.clientFight.buildManager:CheckEntityOnBuildControl(instanceId)
	end
end

function BehaviorFunctions.GetCurAbility()
	local curSelectWheelAbilityIndex = mod.AbilityWheelCtrl:GetCurSelectWheelAbilityIndex()
    local linkId = mod.AbilityWheelCtrl:GetAbilityLinkId(curSelectWheelAbilityIndex)
	if linkId == 0 then
		return nil
	end
	return linkId
end

function BehaviorFunctions.GetAbilitySkillCoolTime(abilityId)
	return Fight.Instance.abilityWheelManager:GetAbilitySkillCoolTime(abilityId)
end

function BehaviorFunctions.SetEntityIsKinematic(instanceId, isKinematic)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		entity.clientTransformComponent:SetRigidBodyIsKinematic(isKinematic)
	end
end

function BehaviorFunctions.GetAllFightTarget()
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	local fightPlayer = player.fightPlayer
	local targetList = fightPlayer:GetAllFightTarget() or {}
	return targetList
end

function BehaviorFunctions.TempSetAllEntityIsKinematicOnPause(isKinematic)
	--TODO 先这样来防止暂停时刚体穿过地面
	local Entites = Fight.Instance.entityManager:GetEntites()
	for _, entity in pairs(Entites) do
		if not entity.clientTransformComponent.isKinematic then
			entity.clientTransformComponent.rigidbody.isKinematic = isKinematic
		end
	end
end

function BehaviorFunctions.GetMagicValue(instanceId, magicid, index, level)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local params = entity:GetMagicParams(magicid, level, index)
	if params then
		if params.type == FightEnum.CustomBehaviorParamType.Bool then
			return params.bValue
		elseif params.type == FightEnum.CustomBehaviorParamType.Number then
			return tonumber(params.sValue)
		else
			return params.sValue
		end
	end
end

--检查某角色身上是否佩戴指定月灵
function BehaviorFunctions.CheckPartnerOn(hero_id, partner_id)
	local uniqueId = mod.RoleCtrl:GetRolePartner(hero_id)
	if (not uniqueId) or uniqueId == 0 then
		if not partner_id then
			return true
		end
		return false
	end
	local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
	if partnerData and partnerData.template_id then
		return partnerData.template_id == partner_id
	end
	return false
end

--检查玩家身上是否装配指定武器
function BehaviorFunctions.CheckWeaponOn(hero_id,weapon_id)
	local uniqueId = mod.RoleCtrl:GetRoleWeapon(hero_id)
	local weaponData = mod.BagCtrl:GetWeaponData(uniqueId, hero_id)
	if weaponData then
		return weaponData.template_id == weapon_id
	end
	return false
end

--检查玩家是否正在佩戴指定能力
function BehaviorFunctions.CheckAbilityOn(ability_id)
	return mod.AbilityWheelCtrl:GetCurSelectWheelAbilityId() == ability_id
end

--检查当前的前台角色是否为指定角色
function BehaviorFunctions.CheckRoleUsing(hero_id)
	local roleInstanceId = BehaviorFunctions.GetCtrlEntity()
	local roleEntity = BehaviorFunctions.GetEntity(roleInstanceId)
	return roleEntity.masterId == hero_id
end

--检查是否满足某条件id
function BehaviorFunctions.CheckCondition(condition_id)
	return Fight.Instance.conditionManager:CheckConditionByConfig(condition_id)
end

--检查这个levelId是否被区域占用了(**没被占用返回false, 被占用了返回true)
function BehaviorFunctions.ChecklevelOccupy(levelId)
	local result = BehaviorFunctions.fight.levelManager:CheckLevelOccupy(levelId)
	return not result
end

-- TODO 把获取怪物配置的地方改一下
-- 获取怪物的攻击类型
function BehaviorFunctions.GetMonsterAttackType(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.tagComponent or not entity.tagComponent:IsMonster() then
		return
	end

	return entity.tagComponent:GetMonsterAttackType()
end

-- 获取怪物的权重
function BehaviorFunctions.GetMonsterPriority(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.tagComponent or not entity.tagComponent:IsMonster() then
		return
	end

	return entity.tagComponent:GetMonsterPriority()
end

--获取指定角色的等级
function BehaviorFunctions.GetRoleLevel(heroId)
	local roleList = mod.RoleCtrl:GetRoleList()
	if roleList[heroId] then
		local heroLev = roleList[heroId].lev       --角色等级
		return heroLev
	end
end

--获取指定角色的突破等级
function BehaviorFunctions.GetRoleStage(heroId)
	local roleList = mod.RoleCtrl:GetRoleList()
	if roleList[heroId] then
		local heroStage = roleList[heroId].stage       --角色突破等级
		return heroStage
	end
end

--获取某角色身上正在佩戴的武器的等级
function BehaviorFunctions.GetHeroWeaponLevel(heroId)
	local roleList = mod.RoleCtrl:GetRoleList()
	if roleList[heroId] then
		local weaponUniqueId = roleList[heroId].weapon_id       --武器
		if weaponUniqueId ~= 0 then
			local weaponData = mod.BagCtrl:GetWeaponData(weaponUniqueId, heroId)
			if weaponData then
				return weaponData.lev
			end
		end
	end
end

--获取某角色身上正在佩戴的武器的突破等级
function BehaviorFunctions.GetHeroWeaponStage(heroId)
	local roleList = mod.RoleCtrl:GetRoleList()
	if roleList[heroId] then
		local weaponUniqueId = roleList[heroId].weapon_id       --武器
		if weaponUniqueId ~= 0 then
			local weaponData = mod.BagCtrl:GetWeaponData(weaponUniqueId, heroId)
			if weaponData then
				return weaponData.stage
			end
		end
	end
end

--获取某角色身上正在穿戴的月灵的等级
function BehaviorFunctions.GetHeroPartnerLevel(heroId)
	local roleList = mod.RoleCtrl:GetRoleList()
	if roleList[heroId] then
		local partnerUniqueId = roleList[heroId].partner_id  --配从
		if partnerUniqueId ~= 0 then
			local partnerData = mod.BagCtrl:GetPartnerData(partnerUniqueId)
			if partnerData then
				return partnerData.lev
			end
		end
	end
end

function BehaviorFunctions.GetEntitySkillLevel(instanceId, skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId, true)
	if entity and entity.skillComponent then
		return entity.skillComponent:GetSkillLevel(skillId)
	end
end

function BehaviorFunctions.GetEntityMagicLevel(instanceId, magicId)
	local entity = BehaviorFunctions.GetEntity(instanceId, true)
	if entity and entity.skillComponent then
		return entity.skillComponent:GetMagicLevel(magicId)
	end
end

function BehaviorFunctions.GetEntityLevelByEntity(instanceId, entityId)
	local entity = BehaviorFunctions.GetEntity(instanceId, true)
	if entity and entity.skillComponent then
		return entity.skillComponent:GetEntityLevel(entityId)
	end
end

function BehaviorFunctions.SetEntityAttackLevel(instanceId, level)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity:SetDefaultSkillLevel(level)
end

-- 驾驶距离计数开关
function BehaviorFunctions.SetAccumulateDistanceSwitch(_handle)
	local trafficManager = BehaviorFunctions.fight.entityManager.trafficManager

	trafficManager:SetAccumulateDistanceSwitch(_handle)
end

function BehaviorFunctions.SetEntityNpcTag(instanceId, tag)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.tagComponent and entity.tagComponent.tag == FightEnum.EntityTag.Npc then
		entity.tagComponent:ChangeNpcTag(tag)
	end
end

--修改骇入物信息
function BehaviorFunctions.SetEntityHackInformation(instanceId, title, icon, desc)
	local hackManager = BehaviorFunctions.fight.hackManager
	hackManager:SetOverrideEntityHackInformation(instanceId, title, icon, desc)
end

--修改骇入按钮信息
function BehaviorFunctions.SetEntityHackButtonInformation(instanceId, hackingKey, Name, icon, hackingRam, hackingDesc)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.hackingInputHandleComponent then
		entity.hackingInputHandleComponent:SetOverrideButtonConfig(hackingKey, icon, Name, hackingRam, hackingDesc)
	end
end

--修改骇入物骇入特效状态
function BehaviorFunctions.SetEntityHackEffectState(instandeId, effectType)
	local hackManager = BehaviorFunctions.fight.hackManager
	hackManager:SetOverrideEntityEffect(instandeId, effectType)
end

-- 获取当前配从变身状态
function BehaviorFunctions.GetPartnerHenshinState(instanceId)
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetPartnerHenshinState(instanceId)
end

function BehaviorFunctions.SetMPAPValue(instanceId, name, value1, value2, value3, value4)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.clientEntity.clientEffectComponent then
		return
	end

	entity.clientEntity.clientEffectComponent:SetMPAPValue(name, value1, value2, value3, value4)
end

function BehaviorFunctions.GetMonsterBreakEnergy(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local monsterCfg = Config.DataMonster.Find[entity.masterId]
	local t = BehaviorFunctions.GetNpcType(instanceId)
	local defaultValue = 1
	if t == FightEnum.EntityNpcTag.Monster 
			or t == FightEnum.EntityNpcTag.Elite 
			or t == FightEnum.EntityNpcTag.Boss then
		if monsterCfg then
			return monsterCfg.break_energy * 0.0001
		end
	end
	return defaultValue
end

function BehaviorFunctions.UseConcludeItem(itemId, targetEcoId)
	BehaviorFunctions.fight.partnerManager:UseConcludeItem(itemId, targetEcoId)
end

function BehaviorFunctions.CheckUseCurConcludeItem()
	local id, num = BehaviorFunctions.fight.partnerManager:CheckUseCurConcludeItem()
	return id, num
end

function BehaviorFunctions.GetRaycastEntityInstanceId(pos, dir, distance)
	local layer = FightEnum.LayerBit.Entity
	local gameObjectId = CustomUnityUtils.GetRaycastEntityObjectInstanceID(pos.x, pos.y, pos.z, dir.x, dir.y, dir.z, distance, layer)
	local entity = BehaviorFunctions.fight.entityManager:GetColliderEntity(gameObjectId)
	return entity and entity.instanceId or nil
end

function BehaviorFunctions.AddLevelTips(tipsId, levelId, ...)
	return TipQueueManger.Instance:AddLevelTips(tipsId, levelId, ...)
end

function BehaviorFunctions.ChangeLevelTitleTips(tipsUniqueId, ...)
	TipQueueManger.Instance:ChangeLevelTitleTips(tipsUniqueId, ...)
end


function BehaviorFunctions.ChangeLevelSubTipsState(tipsUniqueId, index, state)
	TipQueueManger.Instance:ChangeLevelSubTipsState(index, tipsUniqueId, state)
end

function BehaviorFunctions.ChangeLevelSubTips(tipsUniqueId, index, ...)
	TipQueueManger.Instance:ChangeLevelSubTips(index, tipsUniqueId, ...)
end

function BehaviorFunctions.RemoveLevelTips(tipsUniqueId)
	TipQueueManger.Instance:RemoveLevelTips(tipsUniqueId)
end

function BehaviorFunctions.ShowLevelInstruction(tipId)
	local setting = { args = { tipId } }
    EventMgr.Instance:Fire(EventName.AddSystemContent, LevelInstructionPanel, setting)
end

function BehaviorFunctions.StopGameTime(isPause)
	if isPause then
		DayNightMgr.Instance:Pause()
	else
		DayNightMgr.Instance:Resume()
	end
end

function BehaviorFunctions.GetDayNightTime()
	return DayNightMgr.Instance:GetTime()
end

function BehaviorFunctions.ShowAbilityTips(ability_id)
	mod.AbilityWheelCtrl:OpenAbilityFirstGetPanel(ability_id)
end

function BehaviorFunctions.ShowMapArea(levelId, isShow)
	BehaviorFunctions.fight.levelManager:ShowMapArea(levelId, isShow)
end

function BehaviorFunctions.ShowLevelEnemy(levelId, isShow)
	BehaviorFunctions.fight.levelManager:ShowLevelEnemyOnMap(levelId, isShow)
end

function BehaviorFunctions.CheckPartnerObtain()
	local costConfig = Config.DataCommonCfg.Find["PartnerObtain"]
	local haveCount = mod.BagCtrl:GetItemCountById(costConfig.int_val)
	if costConfig.int_val2 > haveCount then
		MsgBoxManager.Instance:ShowTips(string.format(TI18N("%s不足，可在月灵中心生产"),ItemConfig.GetItemConfig(costConfig.int_val).name))
		return false
	end
	return true
end

-- TODO 临时的危险接口 开关实体的KCC
function BehaviorFunctions.BanKccMove(instanceId, state)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	entity.clientTransformComponnt:BanKccMove(state)
end

---------------------------性能分析临时逻辑,新增节点要放在这段逻辑前面----------------------------
--if ctx and ctx.IsDebug then
--	for k, v in pairs(BehaviorFunctions or {}) do
--		local mt = {
--			__call = function(_, ...)
--				UnityUtils.BeginSample("BehaviorFunctions.".. k)
--				local args = {BehaviorFunctions[k](...)}
--				UnityUtils.EndSample()
--				return table.unpack(args)
--			end
--		}
--		BehaviorFunctions[k] = setmetatable({}, mt)
--	end
--else
--	for k,v in pairs(BehaviorFunctions) do
--		BehaviorFunctions[k] = v
--	end
--end