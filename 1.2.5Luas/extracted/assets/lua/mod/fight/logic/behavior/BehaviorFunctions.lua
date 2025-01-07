---@class BehaviorFunctions
BehaviorFunctions = {}
--BehaviorFunctions = {}

local Vec3 = Vec3
local Quat = Quat
function BehaviorFunctions.SetFight(fight)
	BehaviorFunctions.fight = fight
end

function BehaviorFunctions.CreateEntity(entityId,ownerId,x,y,z,lockatX, lockatY, lockatZ, levelId, entityLev)
	local masterId
	local createId = entityId
	local monsterCfg = Config.DataMonster[entityId]
	if monsterCfg then
		createId = monsterCfg.entity_id
		masterId = monsterCfg.id
	end

	local owner
	if ownerId then
		owner = BehaviorFunctions.GetEntity(ownerId)
	end
	local params
	if entityLev then
		params = {}
		params.level = entityLev
	end

	local entity = BehaviorFunctions.fight.entityManager:CreateEntity(createId, owner, masterId, nil, levelId, params)
	if x then
		entity.transformComponent:SetPosition(x,y,z)
	end

	if lockatX then
		entity.rotateComponent:LookAtPositionWithY(lockatX,lockatY,lockatZ)
	end

	return entity.instanceId
end

function BehaviorFunctions.CreatNoPreLoadEntity(entityId,ownerId,x,y,z,lockatX, lockatY, lockatZ, levelId, entityLev)
	local cb = function ()
		BehaviorFunctions.CreateEntity(entityId,ownerId,x,y,z,lockatX, lockatY, lockatZ, levelId, entityLev)
    end
    BehaviorFunctions.fight.clientFight.assetsNodeManager:LoadEntity(entityId, cb)
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
function BehaviorFunctions.GetEntity(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then
		LogError("找不到实体! "..instanceId)
	end
	
	return entity
end

function BehaviorFunctions.GetEntityOwner(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity or not entity.owner then
		return
	end

	return entity.owner.instanceId
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

function BehaviorFunctions.CheckKeyDown(key)
	local operationManager = BehaviorFunctions.fight.operationManager
	return operationManager:CheckKeyDown(key)
end

function BehaviorFunctions.CheckKeyUp(key)
	local operationManager = BehaviorFunctions.fight.operationManager
	return operationManager:CheckKeyUp(key)
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
	if not entity or not entity.clientEntity or not entity.clientEntity.clientTransformComponent then
		return
	end

	local transform = entity.clientEntity.clientTransformComponent:GetTransform()
	if UtilsBase.IsNull(transform) then
		return
	end
	local x, y, z
	x, y, z = CustomUnityUtils.GetTransformForwardOffset(transform, offset, angle, x, y, z)
	return Vec3.New(x, y, z)
end

function BehaviorFunctions.GetPosition(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local position = entity.transformComponent.position
	return position.x,position.y,position.z
end

function BehaviorFunctions.GetPositionP(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local position = entity.transformComponent.position
	return position
end

function BehaviorFunctions.GetEcoEntityBornPosition(ecoId)
	local ecoCfg = BehaviorFunctions.fight.entityManager:GetEntityConfigByID(ecoId)
	if not ecoCfg then
		return
	end

	local pos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(ecoCfg.position_id, ecoCfg.position[2], ecoCfg.position[1])
	return pos
end

function BehaviorFunctions.DoMove(instanceId,x,y)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.moveComponent:DoMove(x,y)
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
	return entity.transformComponent:GetDistanceFromTarget(targetEntity,checkRadius)
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

function BehaviorFunctions.CastSkillByTarget(instanceId,skillId,targetInstanceId,targetPart)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not BehaviorFunctions.CheckEntity(instanceId) then
		return
	end

	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	return entity.skillComponent:CastSkillByTarget(skillId,targetEntity,targetPart)
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
	return entity.skillComponent:CastSkillByPosition(skillId,x,y,z)
end

function BehaviorFunctions.CanCastSkill(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not BehaviorFunctions.CheckEntity(instanceId) then
		return false
	end

	return entity.stateComponent:CanCastSkill()
end

function BehaviorFunctions.CanCtrl(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
		return entity.skillComponent:CanFinish()
	else
		return entity.stateComponent:CanCastSkill()
	end
end

function BehaviorFunctions.SetMainTarget(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.clientEntity.clientTransformComponent:SetMainRole(true)
	BehaviorFunctions.fight.clientFight.cameraManager:SetMainTarget(
		entity.clientEntity.clientTransformComponent.transform)
end

function BehaviorFunctions.SetLockTarget(targetInstanceId, transformName)
	if ctx then
		if targetInstanceId then
			local target = BehaviorFunctions.GetEntity(targetInstanceId)
			if not target then
				BehaviorFunctions.fight.clientFight.cameraManager:ClearTarget()
				return
			end
	
			BehaviorFunctions.fight.clientFight.cameraManager:SetTarget(target,
				target.clientEntity.clientTransformComponent, transformName)
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

function BehaviorFunctions.SetCameraParams(state,id,coverDefult)
	BehaviorFunctions.fight.clientFight.cameraManager:SetCameraParams(state,id,coverDefult)
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
	return entity.skillComponent:GetSkillSign(type)
end

function BehaviorFunctions.BreakSkill(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity.skillComponent then
		return
	end

	return entity.skillComponent:BreakBySelf()
end

function BehaviorFunctions.GetSkill(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillComponent.skillId
end

function BehaviorFunctions.GetSkillType(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillComponent.skillType
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


function BehaviorFunctions.Log(info)
	Log(info)
end

function BehaviorFunctions.ShowTip(tipId, ...)
	if ctx then
		EventMgr.Instance:Fire(EventName.MainPanelShowTip, tipId, ...)
	end
end

function BehaviorFunctions.ChangeTitleTipsDesc(tipId, ...)
	if ctx then
		EventMgr.Instance:Fire(EventName.ChangeTitleTips, tipId, ...)
	end
end

function BehaviorFunctions.ChangeSubTipsDesc(index, tipId, ...)
	if ctx then
		EventMgr.Instance:Fire(EventName.ChangeSubTips, index, tipId, ...)
	end
end

function BehaviorFunctions.HideTip(tipId)
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

function BehaviorFunctions.GetKeyPressFrame(key)
	return BehaviorFunctions.fight.operationManager:GetKeyPressFrame(key)
end

function BehaviorFunctions.CheckKeyPress(key)
	return BehaviorFunctions.fight.operationManager:GetKeyPressFrame(key) > 0
end

function BehaviorFunctions.RemoveKeyPress(key)
	BehaviorFunctions.fight.operationManager:RemoveKeyPress(key)
	BehaviorFunctions.fight.clientFight.inputManager:KeyUp(key)
end

function BehaviorFunctions.ClearAllInput()
	BehaviorFunctions.fight.clientFight.inputManager:ClearAllInput()
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
	return player.fightPlayer:GetAttrValueRatio(attrType)
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
	if entity.campComponent then
		return entity.campComponent.camp == camp
	end
	return false
end

function BehaviorFunctions.GetNpcType(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.tagComponent then
		return entity.tagComponent.npcTag
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
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Hit) then
		return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM:GetState() == hitType
	end
	return false
end

function BehaviorFunctions.GetHitType(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Hit) then
		return entity.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM:GetState()
	end
	return 0
end

function BehaviorFunctions.SetHitType(instanceId,hitType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Hit) then
		entity.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM:SetHitType(hitType)
	end
end

function BehaviorFunctions.HasBuffKind(instanceId,kind)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.buffComponent:HasBuffKind(kind)
end

function BehaviorFunctions.CheckBuffKind(entityInstanceId,buffInstanceId,kind)
	local entity = BehaviorFunctions.GetEntity(entityInstanceId)
	return entity.buffComponent:CheckBuffKind(buffInstanceId,kind)
end

function BehaviorFunctions.ChangeBuffAccumulateValue(instanceId, targetInstanceId, buffValueType, value)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not targetEntity.buffComponent then
		return
	end

	EventMgr.Instance:Fire(EventName.BuffValueChange, targetEntity, buffValueType, value)
end

function BehaviorFunctions.DoMagic(instanceId, targetInstanceId, magicId, magicLv, kind, partName)
	if not targetInstanceId and not kind then
		return
	end

	local fromInstanceId = instanceId
	if kind then
		fromInstanceId = targetInstanceId
	end

	local entity = BehaviorFunctions.GetEntity(fromInstanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	local magicConfig = MagicConfig.GetMagic(magicId, entity.entityId, kind)
	local buffConfig = MagicConfig.GetBuff(magicId, entity.entityId, kind)
	local part
	if partName then
		part = targetEntity.partComponent:GetPart(partName)
	end
	if magicConfig then
		BehaviorFunctions.fight.magicManager:DoMagic(magicConfig, magicLv, entity, targetEntity, false, nil, kind, part)
	elseif buffConfig then
		BehaviorFunctions.AddBuff(fromInstanceId, targetInstanceId, magicId, magicLv, kind, part)
	end
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

-- LogError("angle = "..BehaviorFunctions.GetEntityBonesAngle(2, "HitCase", 5, "HitCase"))
function BehaviorFunctions.GetEntityBonesAngle(instanceId, boneName, targetInstanceId, targetBoneName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	if not entity or not targetEntity then
		return
	end

	local bone = entity.clientEntity.clientTransformComponent:GetTransform(boneName)
	local targetBone = targetEntity.clientEntity.clientTransformComponent:GetTransform(targetBoneName)
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
	return entity.clientEntity.clientTransformComponent.eulerAngles.y
end

function BehaviorFunctions.SetEntityWorldAngle(instanceId, angle)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	
	local rotation = entity.transformComponent:GetRotation()
	rotation:SetEuler(0, angle, 0)
	entity.transformComponent:SetRotation(rotation)
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

function BehaviorFunctions.AddEntitySign(instanceId,sign,lastTime,ignoreTimeScale)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:AddSignState(sign,lastTime,ignoreTimeScale)
end

function BehaviorFunctions.RemoveEntitySign(instanceId,sign)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.stateComponent:RemoveSignState(sign)
end

function BehaviorFunctions.HasEntitySign(instanceId,sign)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.stateComponent:HasSignState(sign)
end

function BehaviorFunctions.CopyEntitySign(formInstanceId,toInstanceId,sign)
	local formEntity = BehaviorFunctions.GetEntity(formInstanceId)
	local toEntity = BehaviorFunctions.GetEntity(toInstanceId)
	local signInfo = formEntity.stateComponent:GetSignInfo(sign)
	if not signInfo then
		LogError(" sign is nil, formInstanceId = "..formInstanceId.." sign = "..sign)
	end
	toEntity.stateComponent:AddSignState(sign,signInfo.lastTime,signInfo.ignoreTimeScale)
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

function BehaviorFunctions.AddEntityGuidePointer(instanceId, guideType, offsetY, hideOnSee)
	local guideIndex
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		local setting = { offsetY = offsetY, hideOnSee = hideOnSee }
		guideIndex = Fight.Instance.clientFight.fightGuidePointerManager:AddGuideEntity(entity, setting, guideType)
	end

	return guideIndex
end

function BehaviorFunctions.RemoveEntityGuidePointer(guideIndex)
	if ctx then
		Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(guideIndex)
	end
end

-- 设置左侧任务指引距离显示
function BehaviorFunctions.SetTaskGuideDisState(state)
	if ctx then
		EventMgr.Instance:Fire(EventName.SetTaskGuideDisState, state)
	end
end

-- 任务和实体绑定指引点
function BehaviorFunctions.SetTaskGuideEntity(instanceId)
	if not BehaviorFunctions.fight then
		return
	end

	BehaviorFunctions.fight.taskManager:BindTaskEntity(instanceId)
end

-- 修改正在追踪的任务进度
function BehaviorFunctions.ChangeCurGuideProgress(progressId)
	mod.TaskCtrl:ChangeCurGuideProgress(progressId)
end

-- 修改对应进度任务的追踪点
function BehaviorFunctions.ChangeTaskGuidePoint(pos, progressId)
	BehaviorFunctions.fight.taskManager:ChangeTaskGuidePoint(pos, progressId)
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
	entity.clientEntity.clientTransformComponent:SetMainRole(false)
	BehaviorFunctions.fight.playerManager:GetPlayer():SetCtrlEntity(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.clientEntity.clientTransformComponent:SetMainRole(true)
	BehaviorFunctions.SetJoyMoveEnable(instanceId, true)
end

function BehaviorFunctions.GetCtrlEntity()
	return BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
end

function BehaviorFunctions.ExitLevel(result)
	Fight.Instance:SetFightState(FightEnum.FightState.Exit)
end

function BehaviorFunctions.SetDuplicateResult(result)
	local fightResult = result and FightEnum.FightResult.Win or FightEnum.FightResult.Lose
	Fight.Instance:ResultFight(fightResult)
	if ctx then
		if result then
			local duplicateId, levelId = mod.WorldMapCtrl:GetDuplicateInfo()
			mod.WorldMapFacade:SendMsg("duplicate_finish", duplicateId)
			mod.WorldMapFacade:SendMsg("duplicate_quit", duplicateId)
		else
			WindowManager.Instance:OpenWindow(WorldFailWindow, {true})
		end
	end
end

function BehaviorFunctions.UseRenderHeight(instanceId,flag)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		entity.clientEntity.clientTransformComponent:UseRenderHeight(flag)
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

function BehaviorFunctions.AddBuff(instanceId,targetInstanceId,buffId,buffLev,kind, ignoreTimeScale)
	local relEntity = BehaviorFunctions.GetEntity(instanceId)
	local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
	local buff = targetEntity.buffComponent:AddBuff(relEntity,buffId,buffLev, nil, kind, nil, ignoreTimeScale)
	if buff then
		return buff.instanceId
	else
		return
	end
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
	entity.buffComponent:RemoveBuffByBuffId(buffId)
end

function BehaviorFunctions.RemoveBuffByGroup(instanceId,groupId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.buffComponent:RemoveBuffByGroup(groupId)
end

function BehaviorFunctions.RemoveBuffByKind(instanceId,kind)
	local entity = BehaviorFunctions.GetEntity(instanceId)
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
	
end

function BehaviorFunctions.GetEntityValue(instanceId,key)
	local entity = BehaviorFunctions.GetEntity(instanceId)
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
	entity.skillSetComponent:SetSkillBtnIcon(key, skillIcon)
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

function BehaviorFunctions.CheckBtnUseSkill(instanceId, key)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:CheckUseSkill(key, true)
end

function BehaviorFunctions.GetBtnSkillCostType(instanceId, skillId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:GetSkillCostType(skillId)
end

function BehaviorFunctions.CastSkillCost(instanceId, key)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:CastSkillCost(key)
end

function BehaviorFunctions.SetBtnSkillCDTime(instanceId, keyEvent, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:SetBtnSkillCDTime(keyEvent, time)
end

function BehaviorFunctions.ChangeBtnSkillCDTime(instanceId, keyEvent, time)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.skillSetComponent:ChangeBtnSkillCDTime(keyEvent, time)
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
	if not _G[name] then
		LogError("创建行为树失败！"..name)
		return nil
	end
	local beahvior = _G[name].New()
	
	local mainBehavior
	if parentBehavior.MainBehavior then
		mainBehavior = parentBehavior.ParentBehavior
	else
		mainBehavior = parentBehavior
	end
	table.insert(parentBehavior.childBehaviors,beahvior)
	beahvior:SetInstanceId(mainBehavior.instanceId, mainBehavior.sInstanceId)
	beahvior.MainBehavior = mainBehavior
	beahvior.ParentBehavior = parentBehavior
	
	beahvior:Init()
	
	return beahvior
end

function BehaviorFunctions.ChangeEntityAttr(instanceId, attrType, attrValue, attrGroupType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	entity.attrComponent:AddValue(attrType, attrValue, attrGroupType)
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
	if ctx then
		EventMgr.Instance:Fire(EventName.MainPanelPlayEffect, effectName, parentName, nil, nil, nil, uiContainName, 1, followEntityId)
	end
end

function BehaviorFunctions.StopFightUIEffect(effectName, parentName, uiContainName)
	if ctx then
		EventMgr.Instance:Fire(EventName.MainPanelStopEffect, effectName, parentName, uiContainName)
	end
end

function BehaviorFunctions.PlaySkillUIEffect(effectName, btnName, isLoop)
	if ctx then
		EventMgr.Instance:Fire(EventName.PlaySkillUIEffect, effectName, btnName, isLoop)
	end
end

function BehaviorFunctions.StopSkillUIEffect(effectName, btnName)
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

function BehaviorFunctions.SetSceneCameraLock(cvcName, instanceId)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		BehaviorFunctions.fight.clientFight.clientMap:SetCameraLockAt(cvcName,entity)
	end
end

function BehaviorFunctions.ClientEffectRelation(instanceId, instanceId1, instanceId2, radius)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		local entity1 = BehaviorFunctions.GetEntity(instanceId1)
		local entity2 = BehaviorFunctions.GetEntity(instanceId2)
		entity.clientEntity.clientTransformComponent:RelationEntity(entity1, entity2, radius)
	end
end

function BehaviorFunctions.ClientEffectRemoveRelation(instanceId)
	if ctx then
		local entity = BehaviorFunctions.GetEntity(instanceId)
		entity.clientEntity.clientTransformComponent:RemoveRelationEntity()
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

function BehaviorFunctions.InteractEntityHit(instanceId, ingoreRemove)
	EventMgr.Instance:Fire(EventName.EntityHit, instanceId, ingoreRemove)
end

function BehaviorFunctions.GetEntityEcoId(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
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
			local ecoCfg, type = entityManager:GetEcoEntityConfig(entity.sInstanceId)
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

-- 设置生态实体生成状态
function BehaviorFunctions.ChangeEcoEntityCreateState(ecoId, state)
	BehaviorFunctions.fight.entityManager.ecosystemEntityManager:SetEcoEntitySvrCreateState(ecoId, state)
end

function BehaviorFunctions.GetEntityItemInfo(instanceId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	return entity.itemInfo
end

function BehaviorFunctions.GetNpcId(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.sInstanceId
end

-- LogTable("npc = ", BehaviorFunctions.GetNpcEntity(npcId))
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

local InteractUniqueId = 0
function BehaviorFunctions.WorldInteractActive(type, icon, text, quality, count, instanceId)
	if ctx then
		InteractUniqueId = InteractUniqueId + 1
		EventMgr.Instance:Fire(EventName.ActiveWorldInteract, type, icon, text, quality, count, InteractUniqueId, instanceId)
		return InteractUniqueId, instanceId
	end
end

-- 给不同的道具提供不同的icon 后续可能扩展name和quality
function BehaviorFunctions.WorldItemInteractActive(itemId, instanceId)
	local icon = ItemConfig.GetItemIcon(itemId)
	local itemCfg = ItemConfig.GetItemConfig(itemId)
	return BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Item, icon, itemCfg.name, itemCfg.quality, nil, instanceId)
end

function BehaviorFunctions.WorldNPCInteractActive(instanceId, text)
	return BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Talk, nil, text, 1, nil, instanceId)
end

function BehaviorFunctions.WorldInteractRemove(uniqueId)
	if ctx then
		EventMgr.Instance:Fire(EventName.RemoveWorldInteract, uniqueId)
	end
end

function BehaviorFunctions.AddLevel(levelId, taskId, preload)
	BehaviorFunctions.fight.levelManager:CreateLevel(levelId, taskId, preload)
end

function BehaviorFunctions.RemoveLevel(levelId)
	BehaviorFunctions.fight.levelManager:RemoveLevel(levelId)
end

function BehaviorFunctions.CreateDuplicate(duplicateId)
	mod.WorldMapFacade:SendMsg("duplicate_enter", duplicateId)
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

function BehaviorFunctions.SendGmExec(name, args)
	if ctx then
		mod.GmCtrl:ExecGmCommand(name, args)
	end
end

function BehaviorFunctions.Transport(mapId, x, y, z)
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject() 
	local pos = player.transformComponent.position
	if (pos.x - x)^2 + (pos.y - y)^2 + (pos.z - z)^2 > 10000 then
		mod.WorldMapFacade:SendMsg("map_enter", mapId, x, y, z)
	else
		player.transformComponent:SetPosition(x, y, z)
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

function BehaviorFunctions.CheckAnimatorAnimFrame(instanceId, animName, frame)
	if ctx then
		local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
		local animationName = entity.animatorComponent:GetAnimationName()
		if animationName ~= animName then
			return false
		end

		local animator = entity.clientEntity.clientAnimatorComponent.animator
		return CustomUnityUtils.GetAnimatorCurFrame(animator) == frame
	end
end

function BehaviorFunctions.PlayAnimation(instanceId,name,layer,time)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if layer then
		layer = entity.clientEntity.clientAnimatorComponent:GetLayerIndex(layer)
	else
		layer = 0
	end
	if entity.clientEntity.clientAnimatorComponent then
		entity.clientEntity.clientAnimatorComponent:PlayAnimation(name,time or 0, 0, layer)
	end
end

function BehaviorFunctions.SetCameraDistance(dis)
	-- BehaviorFunctions.fight.clientFight.cameraManager:SetCameraDis(dis)
end

function BehaviorFunctions.IsPause()
	if BehaviorFunctions.fight  then
		BehaviorFunctions.fight.pauseCount = BehaviorFunctions.fight.pauseCount or 0
		return BehaviorFunctions.fight.pauseCount > 0
	end
end

function BehaviorFunctions.Pause()
	if BehaviorFunctions.fight then
		BehaviorFunctions.fight.pauseCount = BehaviorFunctions.fight.pauseCount or 0
		BehaviorFunctions.fight.pauseCount = BehaviorFunctions.fight.pauseCount + 1
		if BehaviorFunctions.fight.pauseCount > 1 then
			return
		elseif BehaviorFunctions.fight.pauseCount <= 0 then
			LogError("暂停计数异常：".. BehaviorFunctions.fight.pauseCount)
		end
		BehaviorFunctions.fight:Pause()
		if not BehaviorFunctions.fight.clientFight then
			return
		end

		local clientEntites = BehaviorFunctions.fight.clientFight.clientEntityManager.clientEntites
		for k, v in pairs(clientEntites) do
			if v.clientAnimatorComponent then
				v.clientAnimatorComponent:SaveTimeScale()
				v.clientAnimatorComponent:SetTimeScale(0)
			end
		end
		local instanceId = BehaviorFunctions.GetCtrlEntity()
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity then
			entity.clientEntity.clientTransformComponent:SetTranslucentPause(true)
		end
	end
end

function BehaviorFunctions.Resume()
	if BehaviorFunctions.fight then
		BehaviorFunctions.fight.pauseCount = BehaviorFunctions.fight.pauseCount or 0
		BehaviorFunctions.fight.pauseCount = BehaviorFunctions.fight.pauseCount - 1
		
		if BehaviorFunctions.fight.pauseCount > 0 then
			return
		elseif BehaviorFunctions.fight.pauseCount < 0 then
			Log("暂停计数异常：".. BehaviorFunctions.fight.pauseCount)
		end
		BehaviorFunctions.fight.pauseCount = BehaviorFunctions.fight.pauseCount < 0 and 0 or BehaviorFunctions.fight.pauseCount
		BehaviorFunctions.fight:Resume()
		local clientEntites = BehaviorFunctions.fight.clientFight.clientEntityManager.clientEntites
		for k, v in pairs(clientEntites) do
			if BehaviorFunctions.CheckEntity(v.entity.instanceId) and v.clientAnimatorComponent then
				v.clientAnimatorComponent:ResetTimeScale()
			end
		end

		local instanceId = BehaviorFunctions.GetCtrlEntity()
		local entity = BehaviorFunctions.GetEntity(instanceId)
		if entity then
			entity.clientEntity.clientTransformComponent:SetTranslucentPause(false)
		end
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



function BehaviorFunctions.StartStoryDialog(dialogId, bindingList, timeIn, timeOut, position, rotation)
	local setting = {bindingList = bindingList, position = position, lookPosition = rotation}
	Fight.Instance.storyDialogManager:SetNextStoryCameraBlend(timeIn, timeOut)
	Fight.Instance.storyDialogManager:StartStoryDialog(dialogId, setting)
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
	local transform = entity.clientEntity.clientTransformComponent:GetTransform()
	CustomUnityUtils.SetAimAnimateDirection(transform, x,y,z)  
end


function BehaviorFunctions.CheckPosHeight(pos, layer)
	layer = layer or ~(FightEnum.LayerBit.IgonreRayCastLayer | FightEnum.LayerBit.Entity | 
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
	return Fight.Instance.storyDialogManager:GetStoryPlayState()
end

function BehaviorFunctions.GetNowPlayingId()
	return Fight.Instance.storyDialogManager:GetNowPlayingId()
end

function BehaviorFunctions.SendTaskProgress(taskId, progressId, progressNum)
	if ctx then
		mod.TaskFacade:SendMsg("task_client_add_progress", taskId, progressId, progressNum)
	end
end

function BehaviorFunctions.ResetTaskProgress(taskId)
	if ctx then
		mod.TaskFacade:SendMsg("task_reset_progress", taskId)
	end
end

function BehaviorFunctions.GetTaskProgress(taskId, progressId)
	if ctx then
		return mod.TaskCtrl:GetTaskProgressNum(taskId, progressId)
	end

	return 0
end

function BehaviorFunctions.CheckTaskIsFinish(taskId)
	return mod.TaskCtrl:CheckTaskIsFinish(taskId)
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
	-- CustomUnityUtils.SetVCCameraBlend(self.cameraManager.cinemachineBrain,"**ANY CAMERA**", "AimingCamera",0)
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

--TODO 临时
function BehaviorFunctions.UpdateCurFomration(roleList)
	mod.FormationCtrl:ReqFormationUpdate(0, roleList)
end

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
	if entity.clientEntity.clientTransformComponent then
		entity.clientEntity.clientTransformComponent:SetActive(state)
	end
end

function BehaviorFunctions.SetEntityLifeBarVisibleType(instanceId, visibleType)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if ctx then
		if entity and entity.clientEntity.clientLifeBarComponent then
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
		if entity.clientEntity.clientLifeBarComponent then
			entity.clientEntity.clientLifeBarComponent:UpdateLifeBar(show)
		end
	end
end

function BehaviorFunctions.SetEntityLifeBarDelayDeathHide(instanceId, delay)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if ctx then
		if entity.clientEntity.clientLifeBarComponent then
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
		local targerTransform = targetEntity.clientEntity.clientTransformComponent
		entity.clientEntity.clientCameraComponent:SetLockTarget(targerTransform,name)
	else
		entity.clientEntity.clientCameraComponent:SetLockTarget(nil)
	end
	
end

function BehaviorFunctions.CameraEntityFollowTarget(instanceId, targetInstanceId, name)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if targetInstanceId then
		local targetEntity = BehaviorFunctions.GetEntity(targetInstanceId)
		local targerTransform = targetEntity.clientEntity.clientTransformComponent
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

function BehaviorFunctions.PlaySoundTest(soundName)
	SoundManager.Instance:PlaySound(soundName)
end

function BehaviorFunctions.DoEntityAudioPlay(instanceId, soundEvent, lifeBindEntity)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.clientEntity.clientSoundComponent then		
		entity.clientEntity.clientSoundComponent:PlaySound(soundEvent, lifeBindEntity)
	end
end

function BehaviorFunctions.DoEntityAudioStop(instanceId, soundEvent)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.clientEntity.clientSoundComponent then		
		entity.clientEntity.clientSoundComponent:StopSound(soundEvent)
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
		if mainUI then
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

function BehaviorFunctions.SetPathFollowPos(instanceId, pos)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity.findPathComponent then
		return
	end

	return entity.findPathComponent:SetPathFollowPos(pos)
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
	if entity and entity.clientEntity.clientEffectComponent then
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
	if entity.clientEntity.clientIkComponent then
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
		local entityTransform = entity.clientEntity.clientTransformComponent.gameObject.transform
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
	entity.clientEntity.clientTransformComponent:SetEntityTranslucent(type,time)
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

function BehaviorFunctions.GetSkillPointCost(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:GetSkillPointCost()
end

function BehaviorFunctions.AddSkillPoint(instanceId, type, addValue)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	return entity.skillSetComponent:AddSkillPoint(type, addValue)
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
	if not entity.clientEntity.clientTransformComponent.targetGroups then
		entity.clientEntity.clientTransformComponent.targetGroups = {}
	end
	if not entity.clientEntity.clientTransformComponent.targetGroups[targetGroupName] then
		local cinemachineTargetGroup = entity.clientEntity.clientTransformComponent:GetTransform(targetGroupName):GetComponent(CinemachineTargetGroup)
		entity.clientEntity.clientTransformComponent.targetGroups[targetGroupName] = cinemachineTargetGroup
	end
	local cinemachineTargetGroup = entity.clientEntity.clientTransformComponent.targetGroups[targetGroupName]
	local target = cinemachineTargetGroup.m_Targets[index-1]
	target.weight = weight
	cinemachineTargetGroup.m_Targets[index-1] = target
end


function BehaviorFunctions.GetTransformDistance(instanceId1,boneName1,instanceId2,boneName2)
	local entity1 = BehaviorFunctions.GetEntity(instanceId1)
	local clientTransformComponent1 = entity1.clientEntity.clientTransformComponent
	local bone1 = clientTransformComponent1:GetTransform(boneName1) or nil
	if not bone1 then
		bone1 = clientTransformComponent1.transform
	end
	
	local entity2 = BehaviorFunctions.GetEntity(instanceId2)
	local clientTransformComponent2 = entity2.clientEntity.clientTransformComponent
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
	All = 1 << 9,
	
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
	parent["FightSystemPanel"].gameObject:SetActive((toggle & FightPanel.FightSystemPanel) ~= 0)
	parent["FightGatherPanel"].gameObject:SetActive((toggle & FightPanel.FightGatherPanel) ~= 0)
	parent["FightInteractPanel"].gameObject:SetActive((toggle & FightPanel.FightInteractPanel) ~= 0)
	parent["FightJoyStickPanel"].gameObject:SetActive((toggle & FightPanel.FightJoyStickPanel) ~= 0)
	parent["FightFormationPanel"].gameObject:SetActive((toggle & FightPanel.FightFormationPanel) ~= 0)
	parent["FightInfoPanel"].gameObject:SetActive((toggle & FightPanel.FightInfoPanel) ~= 0)
	parent["FightNewSkillPanel"].gameObject:SetActive((toggle & FightPanel.FightNewSkillPanel) ~= 0)
	parent["FightTargetInfoPanel"].gameObject:SetActive((toggle & FightPanel.FightTargetInfoPanel) ~= 0)
	parent["FightGuidePanel"].gameObject:SetActive((toggle & FightPanel.FightGuidePanel) ~= 0)
	if (toggle & FightPanel.FightGuidePanel) ~= 0 then
		EventMgr.Instance:Fire(EventName.GuideDelayAnim, true)
	end
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

function BehaviorFunctions.HeadRaySearch(instanceId, instanceId2)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local headTransform = entity.clientEntity.clientTransformComponent:GetHeadTransform()
	local entityTarget = BehaviorFunctions.GetEntity(instanceId2)
	if headTransform then
		return entityTarget.clientEntity.clientTransformComponent:TransformRayCastGroup(headTransform, "SearchRay")
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
	BehaviorFunctions.fight.clientFight.headAlertnessManager:CreateHeadAlertnessUI(instanceId, curAlertnessValue, maxAlertnessValue)
end

function BehaviorFunctions.ShowHeadAlertnessUI(instanceId, isShow)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:ShowHeadAlertnessUI(instanceId, isShow)
end

function BehaviorFunctions.SetHeadAlertnessValue(instanceId, curAlertnessValue)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:SetHeadAlertnessValue(instanceId, curAlertnessValue)
end

function BehaviorFunctions.CreateHeadViewUI(instanceId, curViewValue, maxViewValue)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:CreateHeadViewUI(instanceId, curViewValue, maxViewValue)
end

function BehaviorFunctions.ShowHeadViewUI(instanceId, isShow)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:ShowHeadViewUI(instanceId, isShow)
end

function BehaviorFunctions.SetHeadViewValue(instanceId, curViewValue)
	BehaviorFunctions.fight.clientFight.headAlertnessManager:SetHeadViewValue(instanceId, curViewValue)
end

function BehaviorFunctions.SwitchCoreUIType(instanceId, type)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if not mainUI then
		return
	end
	
	local skillPanel = mainUI.panelList["FightNewSkillPanel"]
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if skillPanel and skillPanel.coreUI[ctrlEntity.masterId] then
		skillPanel.coreUI[ctrlEntity.masterId]:SwitchCoreUIType(type)
	end
end

function BehaviorFunctions.SetCoreUIVisible(instanceId, visible, time)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if not mainUI then
		return
	end
	
	local skillPanel = mainUI.panelList["FightNewSkillPanel"]
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if skillPanel and skillPanel.coreUI[ctrlEntity.masterId] then
		skillPanel.coreUI[ctrlEntity.masterId]:UpdateVisible(visible, time)
	end
end

function BehaviorFunctions.SetCoreUIPosition(instanceId, x, y, lock)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if not mainUI then
		return
	end
	
	local skillPanel = mainUI.panelList["FightNewSkillPanel"]
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if skillPanel and skillPanel.coreUI[ctrlEntity.masterId] then
		skillPanel.coreUI[ctrlEntity.masterId]:UpdateCyclePosition(x, y, lock)
	end
end

function BehaviorFunctions.SetCoreUIScale(instanceId, scale)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if not mainUI then
		return
	end
	
	local skillPanel = mainUI.panelList["FightNewSkillPanel"]
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if skillPanel and skillPanel.coreUI[ctrlEntity.masterId] then
		skillPanel.coreUI[ctrlEntity.masterId]:UpdateScale(scale)
	end
end

function BehaviorFunctions.SetCoreEffectVisible(instanceId, id, visible)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if not mainUI then
		return 
	end
	
	local skillPanel = mainUI.panelList["FightNewSkillPanel"]
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if skillPanel and skillPanel.coreUI[ctrlEntity.masterId] then
		skillPanel.coreUI[ctrlEntity.masterId]:UpdateEffect(id, visible)
	end
end

function BehaviorFunctions.SetCoreUIEnable(instanceId, enable)
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if not mainUI then
		return
	end
	
	local skillPanel = mainUI.panelList["FightNewSkillPanel"]
	local ctrlEntity = BehaviorFunctions.GetEntity(instanceId)
	if skillPanel and skillPanel.coreUI[ctrlEntity.masterId] then
		skillPanel.coreUI[ctrlEntity.masterId]:SetCoreUIEnable(enable)
	end
end

function BehaviorFunctions.SetJoyMoveEnable(instanceId, enable, priority, stopControl)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.handleMoveInputComponent then
		entity.handleMoveInputComponent:SetEnabled(enable, priority, stopControl)
	end
end

local tempEntitys = {}
function BehaviorFunctions.RaycastSector(instanceId, yOffset, angle, radius)
	TableUtils.ClearTable(tempEntitys)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local transform = entity.clientEntity.clientTransformComponent.transform
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
	if entity and entity.clientEntity.clientLifeBarComponent then
		entity.clientEntity.clientLifeBarComponent:UpdateAssassinTip(instanceId, hitId, skillId, magicId, perfectMagicId)
	end
end
function BehaviorFunctions.HideAssassinLifeBarTip(instanceId, hitId)
	local entity = BehaviorFunctions.GetEntity(hitId)
	if entity and entity.clientEntity.clientLifeBarComponent then
		entity.clientEntity.clientLifeBarComponent:HideAssassinTip(instanceId, hitId)
	end
end

function BehaviorFunctions.GetPlayingAnimationName(instanceId, layer)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.animatorComponent then
		return entity.animatorComponent:GetPlayingAnimationName(layer)
	end
	
	return nil, nil
end

function BehaviorFunctions.SetMouseSensitivity(x, y, phonePlatform)
	AimingCamera.SetMouseSensitivity(x, y, phonePlatform)
end

function BehaviorFunctions.GetEntitySpeedY(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.moveComponent then
		return
	end

	return entity.moveComponent.yMoveComponent:GetSpeed()
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

function BehaviorFunctions.CheckEntityCollideAtPosition(entityId,x, y, z, ignoreList, instanceId)
	local entityConfig = EntityConfig.GetEntity(entityId)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity or not entity.transformComponent then
		return false
	end
	local PartList = entityConfig.Components[FightEnum.ComponentConfigName[FightEnum.ComponentType.Collision]].PartList
	local position = Vec3.New(x, y, z)
	local count = 0
	local layer = FightEnum.LayerBit.Defalut | FightEnum.LayerBit.Entity | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
	local tmpHeightVec = Vec3.New()
	local result
	entity.transformComponent:SetPosition(x,y,z)

	for _, PartConfig in pairs(PartList) do
		for _, v in pairs(PartConfig.BoneColliders) do
			local pos = entity.clientEntity.clientTransformComponent:GetTransform(v.ParentName).position
			position:Set(pos.x, pos.y, pos.z)
			position:AddXYZ(v.LocalPosition[1], v.LocalPosition[2], v.LocalPosition[3])
			if v.ShapeType == FightEnum.CollisionType.Sphere then
				result, count = CustomUnityUtils.OverlapSphereCollider(position, v.LocalScale[1]/2, layer, count)
			elseif v.ShapeType == FightEnum.CollisionType.Cube then
				result, count = CustomUnityUtils.OverlapBoxCollider(position, Vec3.zero, v.LocalScale[1], v.LocalScale[2], v.LocalScale[3], layer, count)
			elseif v.ShapeType == FightEnum.CollisionType.Cylinder then
				tmpHeightVec:Set(0, (v.LocalScale[2] * 2 - v.LocalScale[1]) * 0.5 , 0)
				tmpHeightVec.y = tmpHeightVec.y >= 0 and tmpHeightVec.y or 0
				result, count = CustomUnityUtils.OverlapCapsuleCollider(position - tmpHeightVec, position + tmpHeightVec, v.LocalScale[1] * 0.5, layer, count)
			end

			for i = 0, count - 1 do
				local collider = result[i]
				local name = tonumber(collider.gameObject.name)
				for _, ignore_InstanceId in pairs(ignoreList) do
					if name == ignore_InstanceId then
						count = count - 1
						break
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

local CollideCheckLayer = FightEnum.LayerBit.Defalut | FightEnum.LayerBit.Entity | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
function BehaviorFunctions.DoCollideCheckAtPosition(x, y, z, sizeX, sizeY, sizeZ, ignoreList)
	local position = Vec3.New(x, y, z)
	local count = 0
	local result
	result, count = CustomUnityUtils.OverlapBoxCollider(position, Vec3.zero, sizeX, sizeY, sizeZ, CollideCheckLayer, count)

	for i = 0, count - 1 do
		local collider = result[i]
		local name = tonumber(collider.gameObject.name)
		for _, ignore_InstanceId in pairs(ignoreList) do
			if name == ignore_InstanceId then
				count = count - 1
				break
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
	if entity.collistionComponent then
		entity.collistionComponent:ChangeCollistionHeight(height)
	end
end

function BehaviorFunctions.ChangeCollideRadius(instanceId, radius)
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
	if not entity then return end
	if entity.collistionComponent then
		entity.collistionComponent:ChangeCollistionRadius(radius)
	end
end

function BehaviorFunctions.PlayEffectFont(instanceId, fontType, attachPoint)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	Fight.Instance.clientFight.fontAnimManager:PlayEffectAnimation(entity, fontType, attachPoint)
end

function BehaviorFunctions.ChangeCamp(instanceId, campId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.campComponent then return end
	entity.campComponent:SetCamp(campId)
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

function BehaviorFunctions.GetRandomNavRationalPoint(instanceId, minRadius, maxRadius)
	local rolePos = BehaviorFunctions.GetPositionP(instanceId)
	local val = math.random(minRadius, maxRadius)
	local circlePos = Random.insideUnitCircle * val

	local Vec3Pos = Vec3.New(circlePos.x, circlePos.y, 0)
	local len = Vec3.Magnitude(Vec3Pos)

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

function BehaviorFunctions.CheckPointInArea(point, areaId, areaType)
	if not areaId or not areaType then
		return
	end
	
	local bounds = MapPositionConfig.GetAreaEdgeInfo(areaType, areaId)
	local areaPointList = MapPositionConfig.GetAreaBoundsInfo(areaType, areaId)

	if not bounds or not areaPointList then
		return
	end

	if point.x > bounds.maxX or point.x < bounds.minX or point.y > bounds.maxY or point.y < bounds.minY then
		return false
	end

	local isInArea = false
	for i = 1, #areaPointList do
		if i == 1 and
			not (areaPointList[#areaPointList].y > point.y and areaPointList[1].y > point.y) and
			not (areaPointList[#areaPointList].y < point.y and areaPointList[1].y < point.y) and
			point.x < (areaPointList[#areaPointList].x - areaPointList[1].x) * (point.y - areaPointList[1].y) / (areaPointList[#areaPointList].y - areaPointList[1].y) + areaPointList[1].x then
			isInArea = not isInArea
		elseif i > 1 and
				not (areaPointList[i - 1].y > point.y and areaPointList[i].y > point.y) and
				not (areaPointList[i - 1].y < point.y and areaPointList[i].y < point.y) and
				point.x < (areaPointList[i - 1].x - areaPointList[i].x) * (point.y - areaPointList[i].y) / (areaPointList[i - 1].y - areaPointList[i].y) + areaPointList[i].x then
			isInArea = not isInArea
		end
	end

	return isInArea
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
	curEntity.clientEntity.clientTransformComponent:SetBindTransform(bindName, true, offset, nil, nil, nil, bindEntity)
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

function BehaviorFunctions.SetActiveBGM(state)
	if state == "TRUE" then
		SoundManager.Instance:PlayBgmSound("Play_Bgm")
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
	local entityPos = entity.clientEntity.clientTransformComponent.transform:Find("CameraTarget").position
	local position
	local LineCheckLayer = FightEnum.LayerBit.Defalut | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
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

function BehaviorFunctions.TransportByInstanceId(instanceId, posX, posY, posZ, delayTime)
	delayTime = delayTime or 0
	local entity = BehaviorFunctions.GetEntity(instanceId)
	LuaTimerManager.Instance:AddTimer(1, delayTime, function()
		local entityPos = entity.transformComponent.position
		if entityPos.y ~= posY then
			entity.moveComponent:SetAloft(true)	
		end
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

function BehaviorFunctions.EnterHackingMode()
	local curEntity = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	BehaviorFunctions.DoSetEntityState(curEntity, FightEnum.EntityState.Hack)
	
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	BehaviorFunctions.SetFightPanelVisible("10000")
	mainUI.hackPanel = mainUI:OpenPanel(HackMainWindow)
end

function BehaviorFunctions.ExitHackingMode()
	local curEntity = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	BehaviorFunctions.DoSetEntityState(curEntity, FightEnum.EntityState.Idle)
	
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	BehaviorFunctions.SetFightPanelVisible("-1")
	if mainUI.hackPanel then
		mainUI:ClosePanel(mainUI.hackPanel)
		mainUI.hackPanel = nil
	end
	
	if mainUI.buildPanel then
		mainUI:ClosePanel(mainUI.buildPanel)
		mainUI.buildPanel = nil
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

function BehaviorFunctions.IsMercenaryHuntArea(position)
	local forbidAreaCfg = MercenaryHuntConfig.GetForbidHuntArea()
	local checkArea = {x = position.x, y = position.z}
	for _, area_id in pairs(forbidAreaCfg) do
		if BehaviorFunctions.CheckPointInArea(checkArea, area_id, FightEnum.AreaType.Mercenary) then
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

	entity.clientEntity.clientTransformComponent:SetGroupVisible("AimGroup", isSet)
	
	local transform = entity.clientEntity.clientTransformComponent:GetTransform()
	CustomUnityUtils.SetAimTarget(transform, aimTargetTrans)
end

function BehaviorFunctions.CustomFSMTryChangeState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.customFSMComponent then
		entity.customFSMComponent:TryChangeState()
	end
end

function BehaviorFunctions.GetCustomFSMState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.customFSMComponent then
		entity.customFSMComponent:GetState()
	end
end

function BehaviorFunctions.GetCustomFSMSubState(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.customFSMComponent then
		entity.customFSMComponent:GetSubState()
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

	local bone = entity.clientEntity.clientTransformComponent:GetTransform(boneName)
	local pos = bone.position
	return pos.x, pos.y, pos.z
end

function BehaviorFunctions.SetOnlyKeyInput(keyType, state)
	InputManager.Instance:SetOnlyKeyInputState(keyType, state)
end

function BehaviorFunctions.SetEntityBineVisible(instanceId, name, visible)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end
	entity.clientEntity.clientTransformComponent:SetBineVisible(name, visible)
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
