---@class MagicManager
MagicManager = BaseClass("MagicManager")

local DataMagic = Config.DataMagic.data_magic
-- 效果等级影响的参数
local MagicTypeLevelParam =
{
	["DoDamage"] = { "SkillParam", "SkillBaseDmg" }
}

function MagicManager:__init(fight)
	self.fight = fight
	self.magicFuns = {}
	self.magicFuns.AddBuff = self.AddBuff
	self.magicFuns.DoDamage = self.DoDamage
	self.magicFuns.DoCure = self.DoCure
	self.magicFuns.SetTimeScale = self.SetTimeScale
	self.magicFuns.CameraShake = self.CameraShake
	self.magicFuns.CreateEntity = self.CreateEntity
	self.magicFuns.AddBuffState = self.AddBuffState
	self.magicFuns.HideBone = self.HideBone
	self.magicFuns.HideGroupBone = self.HideGroupBone
	self.magicFuns.ForceMove = self.ForceMove
	self.magicFuns.ChangeAttr = self.ChangeAttr
	self.magicFuns.ScreenEffect = self.ScreenEffect
	self.magicFuns.EnemyCommonTimeScale = self.EnemyCommonTimeScale
	self.magicFuns.SetSceneSpeed = self.SetSceneSpeed
	self.magicFuns.AddBehavior = self.AddBehavior
	self.magicFuns.Preform = self.Preform
	self.magicFuns.CameraTrack = self.CameraTrack
	self.magicFuns.PartLock = self.PartLock
	self.magicFuns.PartLogicVisible = self.PartLogicVisible
	self.magicFuns.DeadTransport = self.DeadTransport
	self.magicFuns.ChangeEntityState = self.ChangeEntityState
	self.magicFuns.HideEntity = self.HideEntity
	self.magicFuns.HideLifeBar = self.HideLifeBar
	self.magicFuns.CameraOffset = self.CameraOffset
	self.magicFuns.PauseTranslucent = self.PauseTranslucent
	self.magicFuns.ForbiddenBoneShake = self.ForbiddenBoneShake
	self.magicFuns.BuffTimeOffset = self.BuffTimeOffset
	self.magicFuns.EnableAnimMove = self.EnableAnimMove
	self.magicFuns.CameraFixed = self.CameraFixed
	self.magicFuns.ConditionListener = self.ConditionListener
	self.magicFuns.ChangeYAxisParam = self.ChangeYAxisParam
	self.magicFuns.ChangeAttrAccumulate = self.ChangeAttrAccumulate
	self.magicFuns.EnableAnimMoveWithAxis = self.EnableAnimMoveWithAxis
	self.magicFuns.ChangePlayerAttr = self.ChangePlayerAttr
	self.magicFuns.ElementResistance = self.ElementResistance
	self.magicFuns.Revive = self.Revive

	-- 延时释放Magic
	self.delayMagic = {}
	-- 给震动组的instanceId缓存
	self.cameraShakeGroupInstance = {}
	self.cameraShakeGroupInstanceId = 0
end

function MagicManager:Update()
	for k, v in pairs(self.delayMagic) do
		self.delayMagic[k].delayFrame = self.delayMagic[k].delayFrame - 1
		if self.delayMagic[k].delayFrame == 0 then
			local entity = Fight.Instance.entityManager:GetEntity(v.entityInstanceId)
			local targetEntity = Fight.Instance.entityManager:GetEntity(v.targetInstanceId)
			local canCast = (v.entityInstanceId and entity) and (v.targetInstanceId and targetEntity)
			local attackEntity = nil
			if v.attackInstanceId then
				attackEntity = Fight.Instance.entityManager:GetEntity(v.attackInstanceId)
				canCast = canCast and attackEntity
			end

			if canCast then
				self.magicFuns[v.magicType](self, entity, targetEntity, v.isEnd or false, v.magicLv, v.param, v.instanceId, v.kind, v.part, attackEntity)
			end
			self.delayMagic[k] = nil
		end
	end
end

function MagicManager:GetMagicParam(magicType, config, magicLv)
	local levelParam = MagicTypeLevelParam[magicType]
	if not levelParam or not config.MagicId then
		return config.Param
	end

	magicLv = magicLv or 1

	local magicConfigKey = UtilsBase.GetDoubleKeys(config.MagicId, magicLv, 16)
	local levelConfig = DataMagic[magicConfigKey]
	if levelConfig then
		local param = UtilsBase.copytab(config.Param)
		for k, v in ipairs(levelParam) do
			param[v] = levelConfig["param"..k]
		end
		return param
	end
	return config.Param
end

function MagicManager:DoMagic(config, magicLv, entity, targetEntity, isEnd, instanceId, kind, part,attackEntity)
	local magicType = FightEnum.MagicFuncName[config.Type]
	local param = self:GetMagicParam(magicType, config, magicLv)
	--TODO 将magic信息记录在参数中
	param.orginMagicId = config.MagicId
	param.magicLevel = magicLv or 0
	
	if param.DelayFrame and param.DelayFrame ~= 0 then
		local attackInstance = nil
		if attackEntity then
			attackInstance = attackEntity.instanceId
		end

		local magicTemp = { magicType = magicType, entityInstanceId = entity.instanceId, targetInstanceId = targetEntity.instanceId, isEnd = isEnd, magicLv = magicLv, param = param, instanceId = instanceId, kind = kind, part = part, attackInstanceId = attackInstance, delayFrame = param.DelayFrame }
		table.insert(self.delayMagic, magicTemp)
	else
		UnityUtils.BeginSample("DoMagic_"..magicType)

		local params = {
			config = config
		}

		local val = self.magicFuns[magicType](self,entity, targetEntity, isEnd or false, magicLv, param, instanceId, kind, part,attackEntity, params)
		if config.effectFontType and config.effectFontType > 0 then
	        Fight.Instance.clientFight.fontAnimManager:PlayEffectAnimation(self.entity, config.effectFontType)
	    end
		UnityUtils.EndSample()
		return val
	end
end

function MagicManager:AddBuff(entity,targetEntity,isEnd,level,param,instanceId, kind, part)
	if isEnd then
		targetEntity.buffComponent:RemoveBuffByInstacneId(instanceId)
		return
	end
	local buffId = param.BuffId
	local buffLevel = level
	local buff = targetEntity.buffComponent:AddBuff(entity, buffId, buffLevel, instanceId, kind, part)
	return buff.instanceId
end

function MagicManager:DoDamage(entity,targetEntity,isEnd,level,param,instanceId,kind,part,attackEntity)
	if isEnd then return end
	self.fight.damageCalculate:DoDamage(self.fight, entity, targetEntity, param, part,attackEntity)
end

function MagicManager:DoCure(entity,targetEntity,isEnd,level,param,instanceId,kind,part,attackEntity)
	self.fight.damageCalculate:DoCure(self.fight, entity, targetEntity, param)
end

function MagicManager:SetTimeScale(entity,targetEntity,isEnd,level,param,instanceId)
	if isEnd then
		if param.CurveId and param.CurveId > 0 then
			targetEntity.timeComponent:RemoveTimeScaleCurve(instanceId)
		else
			targetEntity.timeComponent:RemoveTimeScale(param.TimeScale)
		end
		return
	end
	if param.CurveId and param.CurveId > 0 then
		return targetEntity.timeComponent:AddTimeScaleCurve(entity.entityId, param.CurveId)
	else
		targetEntity.timeComponent:AddTimeScale(param.TimeScale)
	end
end

function MagicManager:EnemyCommonTimeScale(entity,targetEntity,isEnd,level,param,instanceId)
	local timeScale = param.TimeScale
	if isEnd then
		if param.CurveId and param.CurveId > 0 then
			self.fight.entityManager:RemoveEnemyCommonTimeScaleCurve(instanceId)
		else
			self.fight.entityManager:RemoveEnemyCommonTimeScale(timeScale)
		end
		return
	end
	if param.CurveId and param.CurveId > 0 then
		return self.fight.entityManager:AddEnemyCommonTimeScaleCurve(entity,param.CurveId,false)
	else
		self.fight.entityManager:AddEnemyCommonTimeScale(timeScale)
	end
	
end

function MagicManager:CameraShake(entity,targetEntity,isEnd,level,param,instanceId)
	if ctx then
		if isEnd and instanceId then
			if param.isGroup and self.cameraShakeGroupInstance[instanceId] then
				for _, v in pairs(self.cameraShakeGroupInstance[instanceId]) do
					self.fight.clientFight.cameraManager.cameraShakeManager:RemoveShake(v)
				end

				self.cameraShakeGroupInstance[instanceId] = nil
			else
				self.fight.clientFight.cameraManager.cameraShakeManager:RemoveShake(instanceId)
			end

			return
		end

		local cameraShakeInstanceId
		if param.isGroup then
			self.cameraShakeGroupInstanceId = self.cameraShakeGroupInstanceId + 1
			cameraShakeInstanceId = self.cameraShakeGroupInstanceId

			local instanceGroup = {}
			for _, v in pairs(param.cameraShakeGroup) do
				local id = self.fight.clientFight.cameraManager.cameraShakeManager:Shake(v.ShakeType,
				v.StartAmplitude,v.StartFrequency,v.TargetAmplitude,v.TargetFrequency,
				v.AmplitudeChangeTime,v.FrequencyChangeTime,v.DurationTime,v.Sign,v.DistanceDampingId,v.StartOffset,v.Random)

				table.insert(instanceGroup, id)
			end

			self.cameraShakeGroupInstance[cameraShakeInstanceId] = instanceGroup
		else
			cameraShakeInstanceId = self.fight.clientFight.cameraManager.cameraShakeManager:Shake(param.ShakeType,
			param.StartAmplitude,param.StartFrequency,param.TargetAmplitude,param.TargetFrequency,
			param.AmplitudeChangeTime,param.FrequencyChangeTime,param.DurationTime,param.Sign,param.DistanceDampingId,param.StartOffset,param.Random)
		end

		return cameraShakeInstanceId
	end
end

function MagicManager:CreateEntity(entity,targetEntity,isEnd,level,param,instanceId,kind,part)
	if isEnd then
		self.fight.entityManager:RemoveEntity(instanceId)
		return
	end
	local entityId = param.EntityId
	local newEntity = self.fight.entityManager:CreateEntity(entityId, targetEntity)

	if newEntity.attackComponent then
		newEntity.attackComponent:SetDefaultAttackLevel(level)
	end

	-- 相对绑定特效点偏移
	if ctx then
		local clientTransformComponent = newEntity.clientEntity.clientTransformComponent
		local offsetPos = {x = 0, y = 0, z = 0}
		if param.IsBindEntity and entity.transformComponent then
			local position = entity.transformComponent.position
			offsetPos.x = position.x
			offsetPos.y = position.y
			offsetPos.z = position.z

			clientTransformComponent:SetForcePosition(offsetPos.x, offsetPos.y, offsetPos.z)
		elseif param.BindOffsetX and param.BindOffsetY and param.BindOffsetZ then
			offsetPos.x = offsetPos.x + param.BindOffsetX
			offsetPos.y = offsetPos.y + param.BindOffsetY
			offsetPos.z = offsetPos.z + param.BindOffsetZ
			
			clientTransformComponent:SetBindTransformOffset(offsetPos.x, offsetPos.y, offsetPos.z)
			clientTransformComponent:UpdateBindTransform(true)
		end
	
		if newEntity.clientEntity.clientEffectComponent and newEntity.partComponent then
			newEntity.clientEntity.clientEffectComponent:SetHitPart(part)
		end
	end

	if newEntity.rotateComponent then
		-- entity.rotateComponent:LookAtPosition(param.BornRotX, param.BornRotZ)
	end

	return newEntity.instanceId
end

function MagicManager:AddBuffState(entity,targetEntity,isEnd,level,param)
	if isEnd then
		for i = 1, #param.BuffStates do
			targetEntity.buffComponent:RemoveState(param.BuffStates[i])
		end
	else
		for i = 1, #param.BuffStates do
			targetEntity.buffComponent:AddState(param.BuffStates[i])
		end
		
	end
end

function MagicManager:HideBone(entity,targetEntity,isEnd,level,param)
	if ctx then
		local targetClientTransformComponent = targetEntity.clientEntity.clientTransformComponent
		if not targetClientTransformComponent then
			return
		end

		local targetHideBone = targetClientTransformComponent.hideBone
		for i = 1, #param.BoneNames do
			local name = param.BoneNames[i]
			if not targetHideBone[name] then
				if isEnd then
					break
				end

				targetHideBone[name] = 0
			end
			local count = targetHideBone[name]
			if isEnd and targetHideBone[name] > 0 then
				targetHideBone[name] = count - 1
			elseif not isEnd then
				targetHideBone[name] = count + 1
			end
			if name == "Root" then
				targetEntity.clientEntity.clientBuffComponent:SetActivity(targetHideBone[name] == 0)
			end
			targetClientTransformComponent:SetBineVisible(name,targetHideBone[name] == 0)
		end
	end
end

function MagicManager:HideGroupBone(entity,targetEntity,isEnd,level,param)
	if ctx then
		local name = param.GroupName
		local targetClientTransformComponent = targetEntity.clientEntity.clientTransformComponent
		if not targetClientTransformComponent then
			return
		end

		local targetHideGroup = targetClientTransformComponent.hideGroup
		if not targetHideGroup[name] then
			if isEnd then
				return
			end

			targetHideGroup[name] = 0
		end

		if isEnd and targetHideGroup[name] > 0 then
			targetHideGroup[name] = targetHideGroup[name] - 1
		elseif not isEnd then
			targetHideGroup[name] = targetHideGroup[name] + 1
		end

		targetClientTransformComponent:SetGroupVisible(name,targetHideGroup[name] == 0)
		if name == "Root" then
			targetEntity.clientEntity.clientBuffComponent:SetActivity(targetHideGroup[name] == 0)
		end
	end
end

function MagicManager:ForceMove(entity,targetEntity,isEnd,level,param)
	if targetEntity.buffComponent and targetEntity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneForceMove) then
		return 
	end
	
	local dis = BehaviorFunctions.GetDistanceFromTarget(entity.instanceId,targetEntity.instanceId)
	local f = dis / param.Radius
	f = f < 0 and 0 or f
	local speed = param.StartSpeed + (param.EndSpeed - param.StartSpeed) * f
	local pos1 = Vector2(entity.transformComponent.position.x,entity.transformComponent.position.z)
	local pos2 = Vector2(targetEntity.transformComponent.position.x,targetEntity.transformComponent.position.z)
	local v2 = (pos2 - pos1).normalized
	local radius1 = entity.collistionComponent and entity.collistionComponent.config.Radius or 0
	local radius2 = targetEntity.collistionComponent and targetEntity.collistionComponent.config.Radius or 0
	if Vector2.Distance(pos1, pos2) > radius1 + radius2 + 0.05 then
		local move = v2 * speed * FightUtil.deltaTimeSecond
		targetEntity.moveComponent:DoMove(move.x,move.y)
	end
end

function MagicManager:ChangeAttr(entity,targetEntity,isEnd,level,param)
	if targetEntity.attrComponent then
		local attrType = param.AttrType
		local attrValue = param.AttrValue
		local attrGroupType = param.attrGroupType
		if isEnd then
			attrValue = -attrValue
		end

		targetEntity.attrComponent:AddValue(attrType, attrValue, attrGroupType)
	end
end

function MagicManager:ChangePlayerAttr(entity,targetEntity,isEnd,level,param)
	local attrType = param.AttrType
	local attrValue = param.AttrValue
	if isEnd and param.TempAttr then
		attrValue = -attrValue
	end
	BehaviorFunctions.ChangePlayerAttr(attrType, attrValue)
end

function MagicManager:ElementResistance(entity,targetEntity,isEnd,level,param, instanceId, kind, part,attackEntity, params)
	local resistanceVal = param.ElementResistanceValue
	local isInsert = not isEnd
	local magicCfg = params.config
	local magicId = magicCfg.MagicId

	if targetEntity.elementStateComponent then
		targetEntity.elementStateComponent:UpdateElementResistanceVal(magicId, resistanceVal, isInsert)
	end
end

function MagicManager:ScreenEffect(entity,targetEntity,isEnd,level,param)
	if not ctx then
		return
	end

	if not isEnd then
		CameraManager.Instance:AddScreenEffect(entity.instanceId, param.Effect)
	else
		CameraManager.Instance:RemoveScreenEffect(entity.instanceId, param.Effect)
	end
end

function MagicManager:SetSceneSpeed(entity,targetEntity,isEnd,level,param)
	if not ctx then
		return
	end
	if not isEnd then
		self.fight.levelManager:SetSceneSpeed(param.Speed)
	else
		self.fight.levelManager:SetSceneSpeed(1)
	end
end

function MagicManager:AddBehavior(entity, targetEntity, isEnd, level, param, instanceId)
	if isEnd then
		if targetEntity.behaviorComponent then
		targetEntity.behaviorComponent:RemoveBehavior(instanceId)
		end
		return
	end

	local instanceId = 0
	if targetEntity.behaviorComponent then
		local behavior = targetEntity.behaviorComponent:AddBehavior(param.behaviorName)
		instanceId = behavior.behaviorInstancesId
	end

	return instanceId
end

function MagicManager:Preform(entity, targetEntity, isEnd, level, param)
	self.fight.clientFight.cameraManager:Track(not isEnd)
	if isEnd then
		self.fight.timelineManager:StopTrack(entity, targetEntity,param.TimelinePath)
		return
	end
	self.fight.timelineManager:PlayTrack(entity, targetEntity,param.TimelinePath,param.TimeIn,param.TimeOut,param.UseTimeScale)
end

function MagicManager:CameraTrack(entity, targetEntity, isEnd, level, param)
	self.fight.clientFight.cameraManager:Track(not isEnd)
	if ctx then
		if isEnd then
			self.fight.clientFight.clientTimelineManager:StopCameraTrack(param.CameraTrackPath,param.AutoResetVAxis,param.VAxisOffset,param.AutoResetHAxis,param.HAxisOffset)
			return
		end
		self.fight.clientFight.clientTimelineManager:PlayCameraTrack(entity, targetEntity,param.CameraTrackPath,param.TimeIn,param.TimeOut,param.UseTimeScale)
	end
	
end


function MagicManager:PartLock(entity, targetEntity, isEnd, level, param)
	local partName = param.PartName
	local part = targetEntity.partComponent:GetPart(partName)
	part:SetLogicLock(param.IsLock)
end

function MagicManager:PartLogicVisible(entity, targetEntity, isEnd, level, param)
	local partName = param.PartName
	local part = targetEntity.partComponent:GetPart(partName)
	part:SetLogicVisible(param.IsVisible)
end

function MagicManager:DeadTransport(entity, targetEntity, isEnd, level, param)
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	player:SetDeadTransport()
end

function MagicManager:ChangeEntityState(entity, targetEntity, isEnd, level, param)
	if not targetEntity.stateComponent then
		return
	end

	targetEntity.stateComponent:SetState(param.EntityState)
end

function MagicManager:HideEntity(entity, targetEntity, isEnd, level, param)
	if isEnd then return end
	if ctx then
		targetEntity.clientEntity.clientTransformComponent:SetActive(isEnd)
	end
end

function MagicManager:HideLifeBar(entity, targetEntity, isEnd, level, param)
	if ctx then
		if targetEntity.clientEntity.clientLifeBarComponent then
			targetEntity.clientEntity.clientLifeBarComponent:SetLifeBarForceVisibleType(3)
		end
	end
end

function MagicManager:CameraOffset(entity, targetEntity, isEnd, level, param,instanceId)
	if isEnd then
		self.fight.clientFight.cameraManager:RemoveOffset(instanceId)
	else
		param.EntityId = entity.entityId
		return self.fight.clientFight.cameraManager:CreatOffset(param)
	end
	
end

function MagicManager:CameraFixed(entity, targetEntity, isEnd, level, param,instanceId)
	if isEnd then
		self.fight.clientFight.cameraManager:RemoveFixed(instanceId)
	else
		param.EntityId = entity.entityId
		return self.fight.clientFight.cameraManager:CreatFixed(param)
	end
	
end

function MagicManager:PauseTranslucent(entity, targetEntity, isEnd, level, param,instanceId)
	targetEntity.clientEntity.clientTransformComponent:SetTranslucentPause(not isEnd)
end

function MagicManager:ForbiddenBoneShake(entity, targetEntity, isEnd, level, param,instanceId)
	targetEntity.hitComponent:SetForbiddenBoneShake(not isEnd)
end

function MagicManager:BuffTimeOffset(entity, targetEntity, isEnd, level, param,instanceId)
	if targetEntity.buffComponent then
		targetEntity.buffComponent:UpdateBuffTimeOffset(isEnd, param.BuffKind, param.Factor)
	end
end

function MagicManager:EnableAnimMove(entity, targetEntity, isEnd, level, param,instanceId)
	if not targetEntity.moveComponent or 
		targetEntity.moveComponent.config.MoveType ~= FightEnum.MoveType.AnimatorMoveData then
		return 
	end
	
	local enable = param.Enable
	if isEnd then
		enable = ~param.Enable
	end
	targetEntity.moveComponent.moveComponent.enabled = enable
end

function MagicManager:EnableAnimMoveWithAxis(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.moveComponent or 
		targetEntity.moveComponent.config.MoveType ~= FightEnum.MoveType.AnimatorMoveData then
		return 
	end

	targetEntity.moveComponent.moveComponent:SetXZMoveEnable(param.XZEnable)
	targetEntity.moveComponent.moveComponent:SetYAxisMoveEnable(param.YEnable)
end

function MagicManager:ConditionListener(entity, targetEntity, isEnd, level, param,instanceId)
	if self.fight.fightConditionManager then
		self.fight.fightConditionManager:AddListenerList(targetEntity.instanceId, param.ConditionData)
	end
end

function MagicManager:ChangeYAxisParam(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.moveComponent or not targetEntity.moveComponent.yMoveComponent then
		return
	end

	local yMoveComponent = targetEntity.moveComponent.yMoveComponent
	if not isEnd then
		local extraSpeed = 0
		if param.BaseSpeed then
			extraSpeed = param.BaseSpeed
		end

		local paramTable = {
			speedY = param.ResetSpeed and extraSpeed or yMoveComponent.params.speedY + extraSpeed,
			forceUseGravity = param.UseGravity,
			accelerationY = param.AccelerationY and param.AccelerationY or 0,
			maxFallSpeed = param.MaxFallSpeed,
			useGravity = param.UseGravity,
		}

		return yMoveComponent:AddForceParam(paramTable, true)
	else
		yMoveComponent:RemoveForceParam(instanceId)
	end
end

-- 给Buff添加/扣除累计值
function MagicManager:ChangeAttrAccumulate(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.buffComponent then
		return
	end

	EventMgr.Instance:Fire(EventName.BuffValueChange, targetEntity, param.BuffValueType, param.ChangeValue)
end

function MagicManager:Revive(entity, targetEntity, isEnd, level, param, instnaceId)
	if not targetEntity or not targetEntity.attrComponent then
		return
	end

	local reviveLife = param.ReviveValue
	if param.IsPrecentRevive then
		local _, maxLife = targetEntity.attrComponent:GetValueAndMaxValue(EntityAttrsConfig.AttrType.Life)
		reviveLife = maxLife * param.ReviveValue * 0.01
	end
	targetEntity:Revive(false, reviveLife)
end

function MagicManager:__cache()
	if self.delayMagic and next(self.delayMagic) then
		for k, v in pairs(self.delayMagic) do
			self.delayMagic[k] = nil
		end
	end
end

function MagicManager:__delete()
end