---@class MagicManager
MagicManager = BaseClass("MagicManager")

local DataMagic = Config.DataMagic.data_magic
local DataConstMagic = Config.DataMagic.data_const_magic

function MagicManager:__init(fight)
	self.fight = fight
	self.magicFuns = {}
	for k, v in pairs(FightEnum.MagicFuncName) do
		self.magicFuns[v] = self[v]
	end

	-- 延时释放Magic
	self.delayMagic = {}
	-- 给震动组的instanceId缓存
	self.cameraShakeGroupInstance = {}
	self.cameraShakeGroupInstanceId = 0
end

function MagicManager:Update()
	for k, v in pairs(self.delayMagic) do
		self.delayMagic[k].delayFrame = self.delayMagic[k].delayFrame - 1
		if self.delayMagic[k].delayFrame <= 0 then
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

function MagicManager.GetMagicLevelConfig(magicId, fileId, magicLv)
	if not magicId or not fileId or not magicLv then
		return
	end

	local key = string.format("%s_%s_%s", magicId, magicLv, fileId)
	if key and DataMagic[key] then
		return DataMagic[key]
	end
end

function MagicManager.GetMagicConstConfig(magicId, fileId)
	if not magicId or not fileId then
		return
	end

	local key = string.format("%s_%s", magicId, fileId)
	if key and DataConstMagic[key] then
		return DataConstMagic[key]
	end
end

function MagicManager.GetMagicParam(magicType, config, magicLv)
	local levelParam = Config.NormalMagicParam[magicType]
	if not levelParam or not config.MagicId then
		return config.Param
	end

	magicLv = magicLv and magicLv > 0 and magicLv or 1

	local levelConfig = MagicManager.GetMagicLevelConfig(config.MagicId, config.kindId, magicLv)
	local constConfig = MagicManager.GetMagicConstConfig(config.MagicId, config.kindId)
	if levelConfig or constConfig then
		local param = UtilsBase.copytab(config.Param)
		for k, v in pairs(levelParam) do
			local key = "param"..k
			local levValue = levelConfig and levelConfig[key] or -999999
			local constValue = constConfig and constConfig[key] or -999999
			local rValue = levValue and levValue ~= -999999 and levValue or (constValue and constValue ~= -999999 and constValue or param[v])
			param[v] = rValue
		end
		return param
	end
	return config.Param
end

function MagicManager:DoMagic(config, magicLv, entity, targetEntity, isEnd, instanceId, kind, part, attackEntity, customParams, skillType)
	local magicType = FightEnum.MagicFuncName[config.Type]
	if not magicLv and entity then
		local magicId = config.OrginMagicId and config.OrginMagicId ~= 0 and config.OrginMagicId or config.MagicId
		magicLv = BehaviorFunctions.GetEntityMagicLevel(entity.instanceId, magicId)
		magicLv = magicLv or entity:GetDefaultSkillLevel() or 1
	end
	if not magicLv or magicLv == 0 then magicLv = 1 end

	local param = MagicManager.GetMagicParam(magicType, config, magicLv)
	-- 如果是添加行为树的话，那自定义的参数需要去数值表里面找有没有对应等级的数值
	if config.Type == FightEnum.MagicType.AddBehavior or config.Type == FightEnum.MagicType.PassParameter then
		param = UtilsBase.copytab(config.Param)
		local levelConfig = MagicManager.GetMagicLevelConfig(config.MagicId, config.kindId, magicLv)
		local constConfig = MagicManager.GetMagicConstConfig(config.MagicId, config.kindId)
		if levelConfig or constConfig then
			for k, v in pairs(param.paramList) do
				local key = "param"..k
				local levValue = levelConfig and levelConfig[key] or nil
				local constValue = constConfig and constConfig[key] or nil
				local rValue = levValue and levValue ~= -999999 and levValue or (constValue and constValue ~= -999999 and constValue or param.paramList[k].sValue)
				param.paramList[k].sValue = rValue
			end
		end
	end

	-- TODO 将magic信息记录在参数中
	-- 记录部分magic需要的参数
	param.orginMagicId = config.OrginMagicId and config.OrginMagicId ~= 0 and config.OrginMagicId or config.MagicId
	param.magicLevel = magicLv
	param.MagicId = config.MagicId
	param._SkillType = skillType

	if customParams and next(customParams) then
		for k, v in pairs(customParams) do
			param[k] = v
		end
	end

	if param.DelayFrame and param.DelayFrame > 0 then
		local attackInstance = nil
		if attackEntity then
			attackInstance = attackEntity.instanceId
		end

		local magicTemp = {
			magicType = magicType,
			entityInstanceId = entity.instanceId,
			targetInstanceId = targetEntity.instanceId,
			isEnd = isEnd,
			magicLv = magicLv,
			param = param,
			instanceId = instanceId,
			kind = kind,
			part = part,
			attackInstanceId = attackInstance,
			delayFrame = param.DelayFrame
		}
		table.insert(self.delayMagic, magicTemp)
	else
		UnityUtils.BeginSample("DoMagic_"..magicType)
		local val = self.magicFuns[magicType](self, entity, targetEntity, isEnd or false, magicLv, param, instanceId, kind, part, attackEntity)
		UnityUtils.EndSample()
		return val
	end
end

-- 把一些比较复杂的magic做成behavior行为 挂载在实体上 主要用于数值perk
function MagicManager:DoMagicBehavior(entity, targetEntity, isEnd, level, param, instanceId, kind, part, attackEntity)

end

function MagicManager:AddBuff(entity,targetEntity,isEnd,level,param,instanceId, kind, part, attackEntity)
	if isEnd then
		targetEntity.buffComponent:RemoveBuffByInstacneId(instanceId)
		return
	end
	local buffId = param.BuffId
	local buffLevel = level
	local buff = targetEntity.buffComponent:AddBuff(entity, buffId, buffLevel, instanceId, kind, part, param._SkillType)
	return buff.instanceId
end

function MagicManager:DoDamage(entity,targetEntity,isEnd,level,param,instanceId,kind,part,attackEntity)
	if isEnd then return end
	local oldSkillPoint
	if DebugConfig.ShowSkillPointChangeByDamage then
		if entity.attrComponent then
			oldSkillPoint = entity.attrComponent:GetValue(FightEnum.RoleSkillPoint.Normal)
		end
	end
	if param.AddSkillPoint and attackEntity and attackEntity.attackComponent and not attackEntity.attackComponent.hited then
		local addPoint = param.AddSkillPoint * 0.0001
		BehaviorFunctions.AddSkillPoint(entity.instanceId, FightEnum.RoleSkillPoint.Normal, addPoint)
	end

	self.fight.damageCalculate:DoDamage(self.fight, entity, targetEntity, param, part,attackEntity)
	if oldSkillPoint then
		local newValue = entity.attrComponent:GetValue(FightEnum.RoleSkillPoint.Normal)
		if oldSkillPoint ~= newValue then
			Log(string.format("伤害结算完毕:magicId:%s, 当前日相:%s, 变化值:%s", param.MagicId, newValue, newValue - oldSkillPoint))
		end
	end
end

function MagicManager:DoCure(entity,targetEntity,isEnd,level,param,instanceId,kind,part,attackEntity)
	if isEnd then return end
	if not BehaviorFunctions.CheckEntity(targetEntity.instanceId) then
		return
	end
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
			self.fight.entityManager.commonTimeScaleManager:RemoveEnemyCommonTimeScaleCurve(instanceId)
		else
			self.fight.entityManager.commonTimeScaleManager:RemoveEnemyCommonTimeScale(timeScale)
		end
		return
	end
	if param.CurveId and param.CurveId > 0 then
		return self.fight.entityManager.commonTimeScaleManager:AddEnemyCommonTimeScaleCurve(entity,param.CurveId,false, entity)
	else
		self.fight.entityManager.commonTimeScaleManager:AddEnemyCommonTimeScale(timeScale, nil, nil, entity)
	end
	
end

function MagicManager:RoleCommonTimeScale(entity,targetEntity,isEnd,level,param,instanceId)
	local timeScale = param.TimeScale
	if isEnd then
		if param.CurveId and param.CurveId > 0 then
			self.fight.entityManager.commonTimeScaleManager:RemoveRoleCommonTimeScaleCurve(instanceId)
		else
			self.fight.entityManager.commonTimeScaleManager:RemoveRoleCommonTimeScale(timeScale)
		end
		return
	end
	if param.CurveId and param.CurveId > 0 then
		return self.fight.entityManager.commonTimeScaleManager:AddRoleCommonTimeScaleCurve(entity,param.CurveId,false, entity)
	else
		self.fight.entityManager.commonTimeScaleManager:AddRoleCommonTimeScale(timeScale, nil, nil, entity)
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
				local id = self.fight.clientFight.cameraManager.cameraShakeManager:Shake(v, entity)

				table.insert(instanceGroup, id)
			end

			self.cameraShakeGroupInstance[cameraShakeInstanceId] = instanceGroup
		else
			cameraShakeInstanceId = self.fight.clientFight.cameraManager.cameraShakeManager:Shake(param, entity)
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

	newEntity:SetDefaultSkillLevel(level)
	newEntity:SetDefaultSkillType(param._SkillType)

	if newEntity.skillComponent then
		newEntity.attackComponent:SetPartnerSkillType(param._SkillType)
	end

	-- 相对绑定特效点偏移
	if ctx then
		local clientTransformComponent = newEntity.clientTransformComponent
		local offsetPos = {x = 0, y = 0, z = 0}
		if param.IsBindEntity and entity.transformComponent then
			local position = entity.transformComponent.position
			local rot = entity.transformComponent:GetRotation()
			offsetPos.x = position.x
			offsetPos.y = position.y
			offsetPos.z = position.z

			clientTransformComponent:SetForceLocation(offsetPos.x, offsetPos.y, offsetPos.z, rot.x, rot.y, rot.z, rot.w)
		elseif param.BindOffsetX and param.BindOffsetY and param.BindOffsetZ then
			offsetPos.x = offsetPos.x + param.BindOffsetX
			offsetPos.y = offsetPos.y + param.BindOffsetY
			offsetPos.z = offsetPos.z + param.BindOffsetZ
			
			clientTransformComponent:SetBindTransformOffset(offsetPos.x, offsetPos.y, offsetPos.z)
			clientTransformComponent:UpdateBindTransform(true)
		end
	
		if newEntity.clientEffectComponent and newEntity.partComponent then
			newEntity.clientEffectComponent:SetHitPart(part)
		end
	end

	if newEntity.rotateComponent then
		-- entity.rotateComponent:LookAtPosition(param.BornRotX, param.BornRotZ)
	end

	return newEntity.instanceId
end

function MagicManager:AddShadow(entity,targetEntity,isEnd,level,param,instanceId, kind, part, attackEntity)
	if isEnd then return end
	local entityId = param.EntityId
	local newEntity = self.fight.entityManager:CreateEntity(entityId, targetEntity)
	local animName = entity.animatorComponent.animationName
	local startTime = entity.animatorComponent.frame/entity.animatorComponent.animFrame

    newEntity.clientEntity.clientAnimatorComponent:PlayAnimation(animName,0,startTime,0,true)
	newEntity.clientEntity.clientAnimatorComponent:SetForcePauseState(true)
end

function MagicManager:AddBuffState(entity,targetEntity,isEnd,level,param)
	if not targetEntity.buffComponent then return end
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
		local targetClientTransformComponent = targetEntity.clientTransformComponent
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
				if targetHideBone[name] ~= 0 then goto continue end
			elseif not isEnd then
				targetHideBone[name] = count + 1
				if targetHideBone[name] ~= 1 then goto continue end
			end
			if name == "Root" then
				targetEntity.clientBuffComponent:SetActivity(targetHideBone[name] == 0)
			end
			targetClientTransformComponent:SetBineVisible(name,targetHideBone[name] == 0)

			::continue::
		end
	end
end

function MagicManager:HideGroupBone(entity,targetEntity,isEnd,level,param)
	if ctx then
		local name = param.GroupName
		local targetClientTransformComponent = targetEntity.clientTransformComponent
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
			if targetHideGroup[name] ~= 0 then return end
		elseif not isEnd then
			targetHideGroup[name] = targetHideGroup[name] + 1
			if targetHideGroup[name] ~= 1 then return end
		end

		targetClientTransformComponent:SetGroupVisible(name,targetHideGroup[name] == 0)
		if name == "Root" then
			targetEntity.clientBuffComponent:SetActivity(targetHideGroup[name] == 0)
			if targetEntity.clientTransformComponent.kCCCharacterProxy then
				targetEntity.clientTransformComponent.kCCCharacterProxy:SetActive(targetHideGroup[name] == 0)
			end
		end
	end
end

function MagicManager:ForceMove(entity,targetEntity,isEnd,level,param)
	if targetEntity.buffComponent and targetEntity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneForceMove) then
		return 
	end

	local dis = BehaviorFunctions.GetDistanceFromTarget(entity.instanceId, targetEntity.instanceId)
	local f = dis / param.Radius
	f = f < 0 and 0 or f
	local speed = param.StartSpeed + (param.EndSpeed - param.StartSpeed) * f
	local offset = Vec3.New(param.OffsetX or 0, 0, param.OffsetZ or 0)
	local pos1 = Vec3.New(entity.transformComponent.position.x, 0, entity.transformComponent.position.z) -- Vector2(entity.transformComponent.position.x,entity.transformComponent.position.z)
	local pos2 = Vec3.New(targetEntity.transformComponent.position.x, 0, targetEntity.transformComponent.position.z) -- Vector2(targetEntity.transformComponent.position.x,targetEntity.transformComponent.position.z)

	local v2 = Vec3.Normalize(pos2 - (pos1 + offset))
	local radius1 = entity.collistionComponent and entity.collistionComponent.config.Radius or 0
	local radius2 = targetEntity.collistionComponent and targetEntity.collistionComponent.config.Radius or 0

	-- if Vector2.Distance(pos1, pos2) > radius1 + radius2 + 0.05 then
	if dis > radius1 + radius2 + 0.05 then
		local move = v2 * speed * FightUtil.deltaTimeSecond
		targetEntity.moveComponent:DoMove(move.x,move.y)
	end
end

function MagicManager:ChangeAttr(entity,targetEntity,isEnd,level,param)
	if targetEntity.attrComponent then
		local attrType = param.AttrType
		local attrValue = param.AttrValue
		if param.sourceParam then
			param.sourceParam.maxValue = param.MaxValue or 0
			param.sourceParam.haveMaxValue = param.HaveMaxValue or false
		end
		local keepRatio = false
		if isEnd then
			attrValue = -attrValue
			keepRatio = param.KeepRatioEnd
		else
			keepRatio = param.KeepRatioStart
		end
		--是否保持关联属性比例
		local ratios
		if keepRatio then
			ratios = {}
			local tempAttrType = EntityAttrsConfig.Attr2Total[attrType] or attrType
			ratios[tempAttrType] = ratios[tempAttrType] or 0
			if EntityAttrsConfig.AttrPercent2Attr[tempAttrType] then
				for k, v in pairs(EntityAttrsConfig.AttrPercent2Attr[tempAttrType]) do
					ratios[v] = ratios[v] or 0
				end
			end
			for k, v in pairs(ratios) do
				if EntityAttrsConfig.AttrType2MaxType[k + 1000] then
					ratios[k] = targetEntity.attrComponent:GetValueRatio(k + 1000) * 0.0001
				else
					ratios[k] = false
				end
			end
		end

		targetEntity.attrComponent:AddValue(attrType, attrValue, param.sourceParam)

		if keepRatio and ratios then
			for k, v in pairs(ratios) do
				if v then
					local maxValue = targetEntity.attrComponent:GetValue(k)
					targetEntity.attrComponent:SetValue(k + 1000, maxValue * v)
				end
			end
		end
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

function MagicManager:ElementResistance(entity,targetEntity,isEnd,level,param, instanceId, kind, part,attackEntity)
	local resistanceVal = param.ElementResistanceValue
	local isInsert = not isEnd
	--local magicCfg = params.config
	local magicId = param.MagicId

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
	if not targetEntity.behaviorComponent then
		return
	end

	if isEnd and instanceId then
		targetEntity.behaviorComponent:RemoveBehavior(instanceId)
		return
	end

	local behavior = targetEntity.behaviorComponent:AddBehavior(param.behaviorName, nil, param)

	return behavior.behaviorInstancesId
end

function MagicManager:Preform(entity, targetEntity, isEnd, level, param)
	self.fight.clientFight.cameraManager:Track(not isEnd)
	if isEnd then
		self.fight.timelineManager:StopTrack(entity, targetEntity, param.TimelinePath)
		return
	end

	self.fight.timelineManager:PlayTrack(entity, targetEntity, param)
end

function MagicManager:CameraTrack(entity, targetEntity, isEnd, level, param)
	--self.fight.clientFight.cameraManager:Track(not isEnd)
	if ctx then
		if isEnd then
			self.fight.timelineManager:StopCameraTrack(param.CameraTrackPath)
			return
		end

		-- 临时 获取实体位置 创建一个碰撞盒 检测地形
		local size = param.CameraCheckRadius or 0
		if size > 0 then
			local layer = FightEnum.LayerBit.Default | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
			local pos = entity.transformComponent:GetPosition()
			local rot = entity.transformComponent:GetRotation()
			pos.y = pos.y + entity.collistionComponent.height
			local collider
			local count = 0
			collider, count = CustomUnityUtils.OverlapBoxCollider(pos, rot, size * 2, entity.collistionComponent.height * 2, size * 2, layer)
			if count ~= 0 then
				return
			end
		end

		self.fight.timelineManager:PlayCameraTrack(entity, targetEntity, param)
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
		targetEntity.clientTransformComponent:SetActive(isEnd)
	end
end

function MagicManager:HideLifeBar(entity, targetEntity, isEnd, level, param)
	if ctx then
		if targetEntity.clientLifeBarComponent then
			targetEntity.clientLifeBarComponent:SetLifeBarForceVisibleType(3)
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
	if targetEntity.clientTransformComponent then 
		targetEntity.clientTransformComponent:SetTranslucentPause(not isEnd)
	end
end

function MagicManager:ForbiddenBoneShake(entity, targetEntity, isEnd, level, param,instanceId)
	targetEntity.hitComponent:SetForbiddenBoneShake(not isEnd)
end

function MagicManager:BuffTimeOffset(entity, targetEntity, isEnd, level, param,instanceId)
	if targetEntity.buffComponent then
		targetEntity.buffComponent:UpdateBuffTimeOffset(isEnd, param.BuffKind, param.BuffEffectType, param.Factor)
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

function MagicManager:Execute(entity, targetEntity, isEnd, level, param, instnaceId)
	if isEnd then return end
	
	if targetEntity.stateComponent then
		EventMgr.Instance:Fire(EventName.EntityWillDie, targetEntity.instanceId)
		targetEntity.stateComponent:SetState(FightEnum.EntityState.Death, FightEnum.DeathReason.ExecuteDeath, self.damageAttackEntity, param.DelayToDeath)
	end
end

function MagicManager:AdditionYAxisParam(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.moveComponent or not targetEntity.moveComponent.yMoveComponent then
		return
	end

	local t = isEnd and -1 or 1
	local params = {
		gravity = param.ChangeType == 1 and param.AdditionGravity * t or (not isEnd and param.AdditionGravity or nil),
		FSM = param.ChangeType == 1 and param.AdditionMaxFallSpeed * t or (not isEnd and param.AdditionMaxFallSpeed or nil),
		RemoveWhenLand = param.RemoveWhenLand
	}

	if param.ChangeType == 1 then
		targetEntity.moveComponent.yMoveComponent:SetAdditionParam(params)
	else
		targetEntity.moveComponent.yMoveComponent:SetCoverParam(params)
	end
end

function MagicManager:ChangeJumpParam(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.moveComponent or not targetEntity.moveComponent.yMoveComponent then
		return
	end

	targetEntity.moveComponent.yMoveComponent:SetCoverJumpUpSpeed(not isEnd and param.JumpUpSpeed or nil)
	targetEntity.moveComponent.yMoveComponent:SetCoverJumpAcc(not isEnd and param.JumpAcc or nil)
end

function MagicManager:ChangeCollisionCheckTagFlags(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.collistionComponent then
		return
	end

	targetEntity.collistionComponent:ChangeCollisionCheckTagFlags(isEnd, param.Flags)
end

function MagicManager:ChangeCollisionBeCheckTagFlags(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.collistionComponent then
		return
	end

	targetEntity.collistionComponent:ChangeCollisionBeCheckTagFlags(isEnd, param.Flags)
end

function MagicManager:WindArea(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.moveComponent then
		return
	end

	if isEnd then
		targetEntity.moveComponent.yMoveComponent:SetGliderConfig()
		return
	end

	local accParam = {
		minAcc = param.AccDamping and param.MinUpAcc or param.UpAcc,
		maxAcc = param.AccDamping and param.MaxUpAcc or param.UpAcc,
		rate = param.AccDamping and param.MaxAttenuation or 0
	}
	targetEntity.moveComponent.yMoveComponent:SetGliderConfig(accParam, param.MaxUpSpeed, param.MaxHeight, param.RelativeGround, entity.instanceId, param.Offset)
end

function MagicManager:AttrTranslationPercent(entity, targetEntity, isEnd, level, param, instanceId)
	if isEnd then
		targetEntity.attrComponent:RemoveTranslation(instanceId)
	else
		return targetEntity.attrComponent:AddTranslation(FightEnum.AttrTranslationType.Percentage,
		param.originalAttr, param.targetAttr, param.dynamicUpdate, param.param1)
	end
end

function MagicManager:AttrTranslationFixedValue(entity, targetEntity, isEnd, level, param, instanceId)
	if isEnd then
		targetEntity.attrComponent:RemoveTranslation(instanceId)
	else
		return targetEntity.attrComponent:AddTranslation(FightEnum.AttrTranslationType.FixedValue,
		param.originalAttr, param.targetAttr, param.dynamicUpdate, param.param1, param.param2, param.param3)
	end
end

function MagicManager:AddShield(entity, targetEntity, isEnd, level, param, instanceId)
	if isEnd and instanceId then
		targetEntity.attrComponent:RemoveShield(param.MagicId)
		return
	end

	local attrValue = entity.attrComponent:GetValue(param.attrType)
	local finalValue = attrValue * param.SkillParam * 0.0001 + param.SkillBaseDmg

	targetEntity.attrComponent:AddShield(param.shieldType, finalValue, param.MagicId, param.valueOverlay, param.maxValue)

	return param.MagicId
end

function MagicManager:WeaponEffect(entity, targetEntity, isEnd, level, param, instanceId)
	if not targetEntity.clientEntity.weaponComponent then
		return
	end

	if isEnd then
		targetEntity.clientEntity.weaponComponent:RemoveWeaponEffect(instanceId)
		return
	end

	return targetEntity.clientEntity.weaponComponent:AddWeaponEffect(param.effectPath, param.Offset)
end

function MagicManager:PassParameter(entity, targetEntity, isEnd, level, param, instanceId)
	--把传递的参数记录到实体
	local magicId = param.orginMagicId
	if isEnd then
		targetEntity:RemoveMagicParams(magicId, level)
	else
		targetEntity:AddMagicParams(magicId, level, param.paramList)
	end
end

function MagicManager:Conclude(entity, targetEntity, isEnd, level, param, instanceId)
	if isEnd then
		targetEntity:RemoveConcludeBuffState()
	else
		local cfg = PartnerConfig.GetPartnerBuffCfg(level)
		if cfg then
			targetEntity:AddConcludeBuffState(cfg.buff_id, level)
		end
	end
end

function MagicManager:ConcludeElementBreak(entity, targetEntity, isEnd, level, param, instanceId)
	targetEntity:UpdateConcludeElementBreakState(isEnd)
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