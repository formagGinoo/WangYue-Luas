---@class SkillComponent
SkillComponent = BaseClass("SkillComponent",PoolBaseClass)

local sqrt = math.sqrt

function SkillComponent:__init()
	-- 策划在技能帧事件中添加的标记
	self.sign = {}
	self.eventActiveSign = {}
	self.magicLevel = {}
	self.skillLevel = {}
	self.entityLevel = {}
end

function SkillComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.frame = 0
	self.skillId = 0
	-- 技能类型 -> FightEnum.SkillType
	self.skillType = 0
	self.parentSkillType = nil
	-- 技能配置的固有标记
	self.skillSign = 0
	self.frameEventComponent = self.fight.objectPool:Get(FrameEventComponent)
	self.frameEventComponent:Init(self.fight,self)
	
	self.attrComponent = self.entity.attrComponent 
	self.skillSetComponent = self.entity.skillSetComponent
	self:InitSkillInfo()
	self.bindLifeSoundList = {}
	self.stopDelaySoundMap = {}
	self.earlyWarningList = {}

	-- 一些技能的保底措施
	self.totalFrame = 0
	self.forceFrame = 0
	self.changeRoleFrame = 0
end

function SkillComponent:LateInit()
	self:InitSkillLevel()
end

function SkillComponent:SetParentSkillType(skillType)
	if skillType and skillType ~= 0 then
		self.parentSkillType = skillType
	end
	
end

function SkillComponent:InitSkillInfo()
	--self.skillMap = {}
	self.skillsConfig = self.entity:GetComponentConfig(FightEnum.ComponentType.Skill).Skills
end

function SkillComponent:InitSkillLevel()
	TableUtils.ClearTable(self.skillLevel)
	TableUtils.ClearTable(self.magicLevel)
	TableUtils.ClearTable(self.entityLevel)
	local tagComponent = self.entity.tagComponent
	if not tagComponent then
		return
	end
	if tagComponent.npcTag == FightEnum.EntityNpcTag.Player then
		-- todo 读系统等级
		local roleId = self.entity.masterId
		local skillList = RoleConfig.GetRoleSkill(roleId) or {}
	
		for k, skillId in pairs(skillList) do
			local skillCfg = RoleConfig.GetSkillConfig(skillId)-- 系统技能id
			--读服务器技能等级
			local skillLevel = mod.RoleCtrl:GetSkillInfo(roleId, skillId)
			RoleConfig.SetSkillLevel(skillCfg, skillLevel, self.skillLevel, self.magicLevel, self.entityLevel)
		end
	elseif tagComponent.npcTag == FightEnum.EntityNpcTag.Partner then
		if not self.entity.parent and self.entity.sInstanceId then
			LogError("怎么又往生态里面配配从哦 生态id = "..self.entity.sInstanceId)
			return
		end

		-- todo 读系统等级
		local partnerId = 0
		local entityParams = self.entity.params
		if entityParams and entityParams.partnerUnId then
			partnerId = entityParams.partnerUnId
		else
			local roleId = self.entity.parent.masterId
			partnerId = mod.RoleCtrl:GetRolePartner(roleId)
		end

		local partnerData = mod.BagCtrl:GetPartnerData(partnerId)
		if partnerData and partnerData.skill_list then
			for _, skillInfo in pairs(partnerData.skill_list) do
				local skillCfg = RoleConfig.GetPartnerSkillConfig(skillInfo.key)-- 系统技能id
				--读服务器技能等级
				local skillLevel = skillInfo.value
				RoleConfig.SetSkillLevel(skillCfg, skillLevel, self.skillLevel, self.magicLevel, self.entityLevel)
			end
		end
	end
end

function SkillComponent:GetSkillLevel(skillId)
	if self.skillLevel[skillId] then
		return self.skillLevel[skillId]
	end
end

function SkillComponent:GetMagicLevel(magicId)
	if self.magicLevel[magicId] then
		return self.magicLevel[magicId]
	end
end

function SkillComponent:GetEntityLevel(entityId)
	if self.entityLevel[entityId] then
		return self.entityLevel[entityId]
	end
end

function SkillComponent:GetSkillConfig(skillId)
	return self.skillsConfig[skillId]
end

function SkillComponent:GetSkillSignWithId(skillId)
	if not self.skillsConfig[skillId] then
		return
	end

	return self.skillsConfig[skillId].SkillSign
end

local StopSoundType = SoundManager.ActionEvent.AkActionOnEventType_Stop
local StopSoundFadeCurve = SoundManager.AkCurveInterpolation.AkCurveInterpolation_SineRecip
function SkillComponent:StopSoundEvent(sound)
	local gameObject = self.entity.clientTransformComponent:GetGameObject()
	if sound.StopSoundEvent and sound.StopSoundEvent ~= "" then
		SoundManager.Instance:PlayObjectSound(sound.StopSoundEvent, gameObject)
		return
	end

	if sound.StopFadeDuration and sound.StopFadeDuration > 0 then
		GameWwiseContext.ExecuteActionOnEvent(sound.EventName, StopSoundType, gameObject, sound.StopFadeDuration, StopSoundFadeCurve)	
		return
	end

	SoundManager.Instance:StopObjectSound(sound.EventName, gameObject)
end

function SkillComponent:Update()
	self:WarningTick()

	for k, sound in pairs(self.stopDelaySoundMap) do
		sound.StopFrame = sound.StopFrame - 1
		if sound.StopFrame <= 0 then
			self:StopSoundEvent(sound)
			self.stopDelaySoundMap[k] = nil
		end
	end

	if self.skillId == 0 then
		return
	end
	if self.frame > self.totalFrame then
		self:Finish()
		return
	end

	--在释放技能当帧不重复触发帧事件
	if self.castSkillFightFrame and self.castSkillFightFrame == self.fight.fightFrame then
		self.castSkillFightFrame = nil
		return
	end
	self.castSkillFightFrame = nil

	self.frame = self.frame + 1

	local skillLev = self:GetSkillLevel(self.skillId)
	skillLev = skillLev or self.entity:GetDefaultSkillLevel()
	self.frameEventComponent:DoFrameEvent(self.frame, skillLev)

	if self.lifeBindEntity then
		for k, v in pairs(self.lifeBindEntity) do
			if v.frame ~= -1 then
				v.frame = v.frame - 1
				if v.frame < 0 then
					table.remove(self.lifeBindEntity, k)
					break
				end
			end
		end
	end
	if self.pauseCameraRotate then
		if self.frame > self.pauseCameraRotateEndFrame then
			self.fight.clientFight.cameraManager:SetCameraRotatePause(false)
			self.pauseCameraRotate = false
		end
	end

	-- todo 优化内容
	if self.fightUIStateFrame and self.fightUIStateFrame > 0 then
		self.fightUIStateFrame = self.fightUIStateFrame - 1
		if self.fightUIStateFrame <= 0 then
			self.fightUIState = not self.fightUIState
			self.lifeBindFightUIState = false
			BehaviorFunctions.SetFightMainNodeVisible(FightEnum.BehaviorUIOpType.behavior,"PanelParent",self.fightUIState, 2)
			BehaviorFunctions.StoryResumeDialog()
		end
	end

	if self.motionBlurFrame and self.motionBlurFrame > 0 then
		self.motionBlurFrame = self.motionBlurFrame - 1
		if self.motionBlurFrame <= 0 then
			BehaviorFunctions.SetMotionBlur(false)
		end
	end

	if self.hideAllEntityFrame and self.hideAllEntityFrame > 0 then
		self.hideAllEntityFrame = self.hideAllEntityFrame - 1
		if self.hideAllEntityFrame <= 0 then
			self.fight.entityManager:ShowAllEntity()
		end
	end

	self:UpdateScreenEffect()

	self.entity:CallBehaviorFun("SkillFrameUpdate", self.entity.instanceId, self.skillId, self.frame)
	if self.entity.parent then
		self.entity.parent:CallBehaviorFun("SkillFrameUpdate", self.entity.instanceId, self.skillId, self.frame)
	end
	--self:UpdatePreciseTargetMove()
end

function SkillComponent:UpdateIgnoreTimeScale()
	if self.castSkillFightFrame then
		return
	end

	self:UpdateMove()
	self:UpdatePreciseTargetMove()
	self:UpdateRotate()
	self:UpdatePreciseTargetRotate()
end

function SkillComponent:GetDistance(pos1, pos2, ignoreY)
	local x = (pos1.x - pos2.x)^2
	local y = ignoreY and 0 or (pos1.y - pos2.y)^2
	local z = (pos1.z - pos2.z)^2
	
	return sqrt(x + y + z)
end

function SkillComponent:CheckReach(moveSpeed)
	if not self.minDistance or self.skillMoveDone == FightEnum.SkillMoveDone.None then
		return false
	end

	self.entity.clientTransformComponent:Async()
	
	local pos = self.entity.transformComponent.position
	local selfClosestPoint = pos
	if self.entity.partComponent then
		local selfColliderList = self.entity.partComponent:GetPart().colliderList
		selfClosestPoint = selfColliderList[1] and selfColliderList[1].colliderCmp:ClosestPoint(self.targetPosition) or pos
		selfClosestPoint.y = pos.y
	end

	local targetPos = self.targetPosition
	if self.target and BehaviorFunctions.CheckEntity(self.target.instanceId) then
		if self.target.partComponent then
			self.target.clientTransformComponent:Async()
			local colliderList = self.target.partComponent:GetPart(self.targetPart).colliderList
			targetPos = colliderList[1] and colliderList[1].colliderCmp:ClosestPoint(pos) or self.targetPosition
			targetPos.y = self.targetPosition.y
		end
	else
		self.target = nil
	end

	local dis = self:GetDistance(selfClosestPoint, targetPos, self.minDisIgnoreYAxis)

	local isReach = dis < (self.minDistance + moveSpeed)
	if moveSpeed < 0 then
		isReach = false
	end

	return isReach, dis - self.minDistance
end

function SkillComponent:UpdateMove()
	if not self.moveEndFrame then return end
	if self.frame >= self.moveEndFrame then
		self.moveSpeed = nil
		self.moveAcceleration = nil
		self.moveEndFrame = nil
		self.moveDirection = nil
		self.minDistance = nil
		self.minDisIgnoreYAxis = nil
		self.skillMoveDone = nil
		self.pauseAnimationMove = nil
		return
	end

	self.moveSpeed = self.moveSpeed or 0
	local forecastSpeed = (self.entity.animationMoveZ or 0 ) + self.moveSpeed * FightUtil.deltaTimeSecond
	local reach, offsetDis = self:CheckReach(forecastSpeed)

	if reach then
		self.entity.moveComponent:ResetMoveVector()
		if self.skillMoveDone == FightEnum.SkillMoveDone.StopMove then
			self.moveSpeed = 0
			self.moveAcceleration = nil
			self.moveEndFrame = nil
			self.moveDirection = nil
			self.minDistance = nil
			self.minDisIgnoreYAxis = nil
			self.skillMoveDone = nil
			--return
		elseif self.skillMoveDone == FightEnum.SkillMoveDone.BreakSkill then
			self:BreakBySelf()
			self.moveSpeed = 0
			self.moveAcceleration = nil
			self.moveEndFrame = nil
			self.moveDirection = nil
			self.minDistance = nil
			self.minDisIgnoreYAxis = nil
			self.skillMoveDone = nil
			--return
		elseif self.skillMoveDone == FightEnum.SkillMoveDone.PauseAnimationMove then
			self.pauseAnimationMove = true
			self.moveEndFrame = nil
			self.skillMoveDone = nil
			--return
		elseif self.skillMoveDone == FightEnum.SkillMoveDone.CheckRadiusMove then
			self.pauseAnimationMove = self.entity.animationMoveZ >= 0
			self.pauseAnimationMoveY = not self.minDisIgnoreYAxis and self.entity.animationMoveZ >= 0
		end
		--return
	else
		if self.skillMoveDone == FightEnum.SkillMoveDone.CheckRadiusMove then
			self.pauseAnimationMove = false
		end
	end

	local scale = self.entity.timeComponent:GetTimeScale()
	local speed = (self.moveSpeed or 0) * scale * FightUtil.deltaTimeSecond
	if reach and self.skillMoveDone ~= FightEnum.SkillMoveDone.None then
		if self.skillMoveDone == FightEnum.SkillMoveDone.CheckRadiusMove or not self.canFlick then
			speed = offsetDis > 0 and offsetDis or 0
		else
			speed = offsetDis
		end
	end

	if self.moveDirection == 1 then
		self.entity.moveComponent:DoMoveForward(speed)
	elseif self.moveDirection == 2 then
		if BehaviorFunctions.CheckMove() then
			local move = self.fight.operationManager:GetMoveEvent()
			local v2 = Vector2(move.x,move.y).normalized
			local inputSpeedPercent = 1 + BehaviorFunctions.GetEntityAttrVal(self.entity.instanceId, FightEnum.PlayerAttr.InputSpeedPerent)
			local move = v2 * self.inputSpeed * scale * FightUtil.deltaTimeSecond * inputSpeedPercent
			self.entity.moveComponent:DoMove(move.x,move.y)
		end
	else
		local move = self.customDir * speed
		--Log(move.y)
		self.entity.moveComponent:DoMove3(move)
		if move.y ~= 0 then
			self.entity.moveComponent:DoMoveUp(move.y)
		end
	end

	if not self.moveAcceleration then return end
	if reach then return end
	self.moveSpeed = self.moveSpeed + self.moveAcceleration * scale * FightUtil.deltaTimeSecond
end

local cacheVec = Vec3.New()
function SkillComponent:UpdatePreciseTargetMove()
	
	if not self.PTM then
		self.PTMpauseAnimationMove = nil
		return
	end
	
	if self.PTMDdurationMoveFrame <= 0 and self.PTMVDdurationMoveFrame <= 0 then
		self.PTM = false
		return
	end
	if self.entity.timeComponent.frame > self.PTMStartFrame and 
		self.entity.timeComponent.frame <= self.PTMStartFrame + self.PTMDurationUpdateTargetFrame then
		local locationPoint = nil
		if self.target then
			locationPoint = self.target.clientTransformComponent:GetTransform(self.PTMLocationBone)
		end

		local pos = self.targetPosition
		if locationPoint and locationPoint.position then
			pos = locationPoint.position
		end

		self.PTMPosition:Set(pos.x,pos.y,pos.z)
		if self.PTMOffsetType == FightEnum.PTMOffsetType.TargetRelation then
			cacheVec:Set(self.PTMOffset[1], self.PTMOffset[2], self.PTMOffset[3])
			if self.target then
				local rot = self.target.transformComponent:GetRotation()
				cacheVec = rot * cacheVec
			end
			self.PTMPosition:Add(cacheVec)
		end
	end
	
	local scale = self.entity.timeComponent:GetTimeScale()
	if self.PTMDdurationMoveFrame > 0 then
		--self.PTMPosition:Set(self.PTMPosition.x,self.entity.transformComponent.position.y,self.PTMPosition.z)
		local dir = self.PTMPosition - self.entity.transformComponent.position
		dir.y = 0
		dir = Vec3.Normalize(dir)
		local dis = math.sqrt((self.PTMPosition.x - self.entity.transformComponent.position.x)^2 +
			(self.PTMPosition.z - self.entity.transformComponent.position.z)^2) -- self.PTMTargetHPositionOffset
		
		if self.PTMOffsetType == FightEnum.PTMOffsetType.MoveDirection then
			dis = dis - self.PTMOffset[1]
		elseif self.PTMOffsetType == FightEnum.PTMOffsetType.TargetRelation then
			dis = dis + self.PTMOffset[3]
		end
		
		local speed = dis / (self.PTMDdurationMoveFrame - 0)
		local animationMoveZ = self.entity.animationMoveZ or 0
		speed = speed - animationMoveZ
		speed = speed > self.PTMMaxSpeed and self.PTMMaxSpeed or speed
		speed = speed < self.PTMMinSpeed and self.PTMMinSpeed or speed
		--Log("dis "..dis.."  speed "..speed.." frame "..self.PTMDdurationMoveFrame)
		local move = dir * speed * scale
		self.entity.moveComponent:DoMove(move.x, move.z)
		self.PTMDdurationMoveFrame = self.PTMDdurationMoveFrame - 1
	end
	if self.PTMVDdurationMoveFrame > 0 then
		if not self.PTMIgnoreY then
			local yDif = self.PTMPosition.y - self.entity.transformComponent.position.y
			if self.PTMOffsetType == FightEnum.PTMOffsetType.MoveDirection then
				yDif = yDif + self.PTMOffset[2]
			end
			local ySpeed = yDif / (self.PTMVDdurationMoveFrame - 0)
			self.entity.moveComponent:SetAloft(true)
			self.entity.moveComponent:DoMoveUp(ySpeed * scale)
		end
		self.PTMVDdurationMoveFrame = self.PTMVDdurationMoveFrame - 1
		
	end
end

function SkillComponent:UpdatePreciseTargetRotate()
	if not self.PTR then return end
	if self.PTRDurationUpdateTargetFrame <= 0 then return end
	
	local trans = self.entity.transformComponent
	local curPosition = trans.position
	local lookAtPos = self.PTRPosition

	local x = lookAtPos.x - curPosition.x
	local y = self.PTRIsFullRotate and lookAtPos.y - curPosition.y or 0
	local z = lookAtPos.z - curPosition.z
	local lookAtRotate = Quat.LookRotationA(x,y,z)

	local curForward = trans.rotation * Vec3.forward
	local lookAtForward = lookAtRotate * Vec3.forward
	local needSpeed = Vec3.Angle(curForward, lookAtForward)

	local curFrame = self.entity.timeComponent.frame
	local frame = curFrame - self.PTRStartFrame

	needSpeed = needSpeed * (frame / self.PTRDurationUpdateTargetFrame)
	needSpeed = needSpeed > self.PTRMaxSpeed and self.PTRMaxSpeed or needSpeed
	needSpeed = needSpeed < self.PTRMinSpeed and self.PTRMinSpeed or needSpeed
	local scale = self.entity.timeComponent:GetTimeScale()
	local rotateSpeed = needSpeed * scale
	trans:SetRotation(Quat.RotateTowards(trans.rotation, lookAtRotate, rotateSpeed))
	if frame >= self.PTRDurationUpdateTargetFrame then
		self.PTR = false
	end
end

function SkillComponent:UpdateRotate()
	if not self.rotateEndFrame then return end
	if self.frame > self.rotateEndFrame then
		self.entity.rotateComponent:Async()
		self.rotateType = nil
		self.rotateSpeed = nil
		self.rotateAcceleration = nil
		self.rotateEndFrame = nil
	else
		local scale = self.entity.timeComponent:GetTimeScale()
		local rotation = self.entity.transformComponent.rotation
		local targetQ = rotation
		if self.rotateType == 1 then --自转
			local speed = self.rotateSpeed
			if self.rotateSpeed < 0 then
				speed = -self.rotateSpeed
			end
			local q = Quat.Euler(0, speed * FightUtil.deltaTimeSecond, 0);
			targetQ = rotation * q
		elseif self.rotateType == 2 then --朝目标转
			if self.target then
				if BehaviorFunctions.CheckEntity(self.target.instanceId) and self.target.transformComponent then
					local pos1 = self.target.transformComponent.position
					local pos2 = self.entity.transformComponent.position
					local newX = pos1.x - pos2.x
					local newZ = pos1.z - pos2.z
					targetQ = Quat.LookRotationA(newX,0,newZ)
				end
				--targetQ = rotation * q
			end
		elseif self.rotateType == 3 then --摇杆方向
			if BehaviorFunctions.CheckMove() then
				local move = self.fight.operationManager:GetMoveEvent()
				local v2 = Vector2(move.x,move.y).normalized
				targetQ = Quat.LookRotationA(v2.x,0,v2.y)
			end
		elseif self.rotateType == 4 then --目标旋转
			if self.target then
				if BehaviorFunctions.CheckEntity(self.target.instanceId) and self.target.transformComponent then
					targetQ = self.target.transformComponent:GetRotation()
				end
			end
		end
		local newQ = Quat.RotateTowards(rotation, targetQ, self.rotateSpeed * scale * FightUtil.deltaTimeSecond)
		self.entity.rotateComponent:SetRotationBlend(newQ)
		self.rotateSpeed = self.rotateSpeed + self.rotateAcceleration * scale * FightUtil.deltaTimeSecond
	end
end

function SkillComponent:CastSkillByTarget(skillId,target,targetPart, targetTransform)
	self:onLevelSkillMachine()
	self.skillId = skillId
	self.target = target
	
	self.targetPart = targetPart
	
	local part = self.target.partComponent:GetPart(targetPart)
	local isLockNil = false
	if UtilsBase.IsNull(part.lockTransform) then
		isLockNil = true
		LogError("target Part is nil, name = "..part.lockTransformName)
	end

	local lockTransfom = self.target.clientTransformComponent:GetTransform(targetTransform)
	self.targetPosition = targetTransform and lockTransfom.position or (not isLockNil and part.lockTransform.position or lockTransfom.position)

	self:CastSkill()
end

function SkillComponent:CastSkillByPosition(skillId,x,y,z)
	self:onLevelSkillMachine()
	self.skillId = skillId
	self.targetPosition = {x = x,y = y,z = z}
	self:CastSkill()
end

function SkillComponent:CanFinish()
	return self.forceFrame == 0 or self.frame > self.forceFrame
end

function SkillComponent:CanCastOtherSkill()
	if not self.anotherBreakFrame then
		return false
	end

	return self.frame > self.anotherBreakFrame
end

function SkillComponent:CanChangeRole()
	if not self.changeRoleFrame or self.changeRoleFrame < 0 then
		return false
	end

	return self.frame > self.changeRoleFrame
end

function SkillComponent:IsLandingSkill()
	if not self.skillId or not self.skillsConfig or not self.skillsConfig[self.skillId] then
		return false
	end

	return self.skillsConfig[self.skillId].IsLanding
end

function SkillComponent:CastSkill()
	self.frame = 0

	if not self.skillsConfig[self.skillId] then
		LogError("找不到技能Id. "..self.skillId)
		return
	end
	if self.parentSkillType then
		self.skillType = self.parentSkillType
	else
		self.skillType = self.skillsConfig[self.skillId].SkillType
	end
	self.skillSign = self.skillsConfig[self.skillId].SkillSign
	self.totalFrame = self.skillsConfig[self.skillId].TotalFrame
	self.forceFrame = self.skillsConfig[self.skillId].ForceFrame
	self.anotherBreakFrame = self.skillsConfig[self.skillId].SkillBreakSkillFrame
	self.changeRoleFrame = self.skillsConfig[self.skillId].ChangeRoleFrame
	self.entity.stateComponent:SetState(FightEnum.EntityState.Skill)
	self.frameEventComponent:SetFrameEventConfig(self.skillsConfig[self.skillId])
	local skillLev = self:GetSkillLevel(self.skillId)
	skillLev = skillLev or self.entity:GetDefaultSkillLevel()
	self.frameEventComponent:DoFrameEvent(0, skillLev)--提前执行，比如由实体逻辑触发释放技能应该当帧释放
	self.castSkillFightFrame = self.fight.fightFrame

	-- self.fight.entityManager:CallBehaviorFun("CastSkill", self.entity.instanceId, self.skillId, self.skillType)
	-- EventMgr.Instance:Fire(EventName.CastSkill, self.entity.instanceId, self.skillId, self.skillType)

	self.fight.entityManager:CallBehaviorFun("CastSkill", self.entity.instanceId, self.skillId, self.skillSign, self.skillType)
	EventMgr.Instance:Fire(EventName.CastSkill, self.entity.instanceId, self.skillId, self.skillSign, self.skillType)

	if ctx then
		self.fight.clientFight.skillGuideManager:SetCurSkill(self.skillId)
	end
end

function SkillComponent:Break(attackId)
	self.attackId = attackId
	self:Finish()
end

function SkillComponent:BreakBySelf()
	self:Finish()
end

function SkillComponent:onLevelSkillMachine()
	local instanceId = self.entity.instanceId
	local skillId = self.skillId
	local skillSign = self.skillSign
	local skillType = self.skillType
	local isFinish = self.frame > self.totalFrame

	self:Clear()
	if skillId == 0 then
		return
	end

	if isFinish then
		self.fight.entityManager:CallBehaviorFun("FinishSkill", instanceId, skillId, skillSign, skillType)
	else
		self:BreakEffect()
		self.fight.entityManager:CallBehaviorFun("BreakSkill", instanceId, skillId, skillSign, skillType)
	end
end

function SkillComponent:Finish()
	if not BehaviorFunctions.CheckEntity(self.entity.instanceId) then
		return
	end

	local isAloft = self.entity.moveComponent and self.entity.moveComponent.isAloft
	local levitation = self.entity.buffComponent and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.Levitation)
	if isAloft and not levitation then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true, false, true)
	else
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end

	if self.entity.clientEntity and self.entity.clientTransformComponent then
		self.entity.clientTransformComponent:SetPivotYOffset()
	end
end

function SkillComponent:GetSkillSign(type)
	if not self.sign[type] then
		return false
	end
	return self.sign[type].StartFrame <= self.frame and self.frame < self.sign[type].EndFrame
end

function SkillComponent:GetSkillTarget()
	return self.target, self.targetPart
end

function SkillComponent:AddEventActiveSign(sign,args)
	self.eventActiveSign[sign] = args or true
end

function SkillComponent:RemoveEventActiveSign(sign)
	if self.eventActiveSign[sign] then
		self.eventActiveSign[sign] = nil
	end
end

function SkillComponent:CheckEventActiveSign(sign)
	return self.eventActiveSign[sign] ~= nil,self.eventActiveSign[sign]
end

function SkillComponent:CheckAnimationMove()
	return not self.pauseAnimationMove and not self.PTMpauseAnimationMove
end

function SkillComponent:CheckAnimationMoveY()
	return not self.pauseAnimationMoveY and not self.PTMpauseAnimationMove
end

function SkillComponent:LifeBindEntity(instanceId, frame)
	self.lifeBindEntity = self.lifeBindEntity or {}
	table.insert(self.lifeBindEntity, {instanceId = instanceId, frame = frame})
end

function SkillComponent:LifeBindBuff(buff)
	self.lifeBindBuff = self.lifeBindBuff or {}
	table.insert(self.lifeBindBuff, buff.instanceId)
end

function SkillComponent:LifeBindCameraOffset(instanceId)
	self.lifeBindCameraOffsets = self.lifeBindCameraOffsets or {}
	table.insert(self.lifeBindCameraOffsets, instanceId)
end

function SkillComponent:LifeBindCameraFixed(instanceId)
	self.lifeBindCameraFixeds = self.lifeBindCameraFixeds or {}
	table.insert(self.lifeBindCameraFixeds, instanceId)
end

function SkillComponent:LifeBindPostProcess(procType)
	self.lifeBindPostProcess = self.lifeBindPostProcess or {}
	table.insert(self.lifeBindPostProcess, procType)
end

function SkillComponent:LifeBindEntitySign(sign)
	self.lifeBindEntitySign = self.lifeBindEntitySign or {}
	table.insert(self.lifeBindEntitySign, sign)
end

function SkillComponent:SetFightUIVisible(state, isBindSkill, frame, isHighestPriority)
	self.lifeBindFightUIState = isBindSkill
	self.fightUIState = state
	self.fightUIStateFrame = frame
	BehaviorFunctions.SetFightMainNodeVisible(FightEnum.BehaviorUIOpType.behavior,"PanelParent",self.fightUIState, 2)
	BehaviorFunctions.StoryPauseDialog()
end

-- 垂直速度修改参数
function SkillComponent:LifeBindVS(instanceId)
	self.lifeBindVS = self.lifeBindVS or {}
	table.insert(self.lifeBindVS, instanceId)
end

function SkillComponent:DoMoveEvent(speed,acceleration,moveFrame,direction,inputSpeed,minDistance,IgnoreYAxis,skillMoveDone,customDir,canFlick)
	self.moveSpeed = speed
	self.moveAcceleration = acceleration
	self.moveEndFrame = self.frame + moveFrame
	self.moveDirection = direction
	self.inputSpeed = inputSpeed
	self.minDistance = minDistance
	self.minDisIgnoreYAxis = IgnoreYAxis
	self.skillMoveDone = skillMoveDone
	self.canFlick = canFlick
	--customDir = customDir:Div(360)
	self.customDir = customDir:SetNormalize()
end

function SkillComponent:DoRotateEvent(rotateType,speed,acceleration,rotateFrame)
	self.rotateType = rotateType
	self.rotateSpeed = speed
	self.rotateAcceleration = acceleration
	self.rotateEndFrame = self.frame + rotateFrame
end

function SkillComponent:DoPreciseTargetMove(durationUpdateTargetFrame,offsetType,offset,durationMoveFrame,vDurationMoveFrame,ignoreY,maxSpeed,minSpeed,boneName, pauseAnimationMove)
	self.PTMPosition = self.target and Vec3.New(self.target.transformComponent.position.x,self.target.transformComponent.position.y,self.target.transformComponent.position.z) or Vec3.New(self.targetPosition.x,self.targetPosition.y,self.targetPosition.z)
	self.PTM = true
	self.PTMLocationBone = boneName or ""
	self.PTMStartFrame = self.entity.timeComponent.frame
	self.PTMOffsetType = offsetType
	self.PTMOffset = offset
	self.PTMSpeed = 0
	self.PTMDurationUpdateTargetFrame = durationUpdateTargetFrame
	self.PTMDdurationMoveFrame = durationMoveFrame
	self.PTMVDdurationMoveFrame = vDurationMoveFrame > 0 and vDurationMoveFrame + 1 or 0
	self.PTMIgnoreY = ignoreY
	self.PTMMaxSpeed = maxSpeed / 30
	self.PTMMinSpeed = minSpeed / 30
	self.PTMpauseAnimationMove = pauseAnimationMove
end

function SkillComponent:DoPreciseTargetRotate(durationFrame, maxSpeed, minSpeed, isFullRotate)
	local pos
	if self.target then
		local targetPos = self.target.transformComponent.position
		pos = Vec3.New(targetPos.x, targetPos.y, targetPos.z)
	else
		pos = Vec3.New(self.targetPosition.x,self.targetPosition.y,self.targetPosition.z)
	end

	self.PTR = true
	self.PTRPosition = pos
	self.PTRStartFrame = self.entity.timeComponent.frame
	self.PTRDurationUpdateTargetFrame = durationFrame
	self.PTRMaxSpeed = maxSpeed
	self.PTRMinSpeed = minSpeed
	self.PTRIsFullRotate = isFullRotate
end

function SkillComponent:WarningTick()
	if #self.earlyWarningList == 0 then
		return
	end
	
	local finishList = {}
	for k, v in pairs(self.earlyWarningList) do
		v.frame = v.frame - 1
		if v.frame <= 0 then
			table.insert(finishList, k)
			self.fight.entityManager:CallBehaviorFun("Warning", self.entity.instanceId, v.targetId, v.signId, true)
		end
	end
	
	for _, v in pairs(finishList) do
		table.remove(self.earlyWarningList, v)
	end
end

function SkillComponent:DoWarningEndEvent(signId, frame, targetId)
	table.insert(self.earlyWarningList, {frame = self.frame + frame, signId = signId, targetId = targetId})
end

function SkillComponent:ClearAnimation()
	if self.entity.animatorComponent then
		self.entity.animatorComponent:ClearAnimation()
	end
end

function SkillComponent:Clear()
	if self.skillId > 0 then
		self.fight.entityManager:CallBehaviorFun("ClearSkill", self.entity.instanceId, self.skillId, self.skillSign, self.skillType)
	end

	self:ClearAnimation()
	self.frame = 0
	self.skillId = 0
	self.skillType = 0
	self.skillSign = 0
	self.target = nil
	self.targetPart = nil
	self.totalFrame = 0
	self.forceFrame = 0
	self.anotherBreakFrame = nil
	self.changeRoleFrame = nil
	TableUtils.ClearTable(self.sign)
	--self.sign = {}
	self.targetPosition = {x = 0,y = 0,z = 0}
	self.moveType = nil
	self.moveSpeed = nil
	self.moveAcceleration = nil
	self.moveEndFrame = nil
	self.minDistance = nil
	self.minDisIgnoreYAxis = nil
	self.skillMoveDone = nil
	self.rotateType = nil
	self.rotateSpeed = nil
	self.rotateAcceleration = nil
	self.rotateEndFrame = nil
	self.pauseAnimationMove = nil
	self.PTMpauseAnimationMove = nil
	self.pauseAnimationMoveY = nil
	self.PTM = false
	self.attackId = nil
	
	self:ClearLifeBindTable()

	self.fight.clientFight.cameraManager:clearBreakFovChangeData()
end

function SkillComponent:ClearLifeBindTable()
	if self.lifeBindEntity then
		for k, v in pairs(self.lifeBindEntity) do
			self.fight.entityManager:RemoveEntity(v.instanceId)
		end
		TableUtils.ClearTable(self.lifeBindEntity)
	end

	if self.lifeBindBuff then
		for k, v in pairs(self.lifeBindBuff) do
			self.entity.buffComponent:RemoveBuffByInstacneId(v)
		end
		TableUtils.ClearTable(self.lifeBindBuff)
	end

	if self.lifeBindCameraOffsets then
		for k, v in pairs(self.lifeBindCameraOffsets) do
			self.fight.clientFight.cameraManager:RemoveOffset(v)
		end
		TableUtils.ClearTable(self.lifeBindCameraOffsets)
	end

	if self.lifeBindCameraFixeds then
		for k, v in pairs(self.lifeBindCameraFixeds) do
			self.fight.clientFight.cameraManager:RemoveFixed(v)
		end
		TableUtils.ClearTable(self.lifeBindCameraFixeds)
	end

	if self.lifeBindPostProcess then
		for k, v in pairs(self.lifeBindPostProcess) do
			self.fight.clientFight.postProcessManager:EndPostProcess(v)
		end
		TableUtils.ClearTable(self.lifeBindPostProcess)
	end

	if self.lifeBindEntitySign then
		for k, v in pairs(self.lifeBindEntitySign) do
			self.entity:RemoveSignState(v)
		end
		TableUtils.ClearTable(self.lifeBindEntitySign)
	end

	if self.lifeBindVS and self.entity.moveComponent and self.entity.moveComponent.yMoveComponent then
		for k, v in pairs(self.lifeBindVS) do
			self.entity.moveComponent.yMoveComponent:RemoveForceParam(v)
		end
		TableUtils.ClearTable(self.lifeBindVS)
	end

	if next(self.bindLifeSoundList) then
		local gameObject = self.entity.clientTransformComponent:GetGameObject()
		for k, sound in pairs(self.bindLifeSoundList) do
			if sound.StopDelayFrame == 0 then
				self:StopSoundEvent(sound)
			else
				sound.StopFrame = sound.StopDelayFrame
				self.stopDelaySoundMap[sound.EventName] = sound
			end
		end
		TableUtils.ClearTable(self.bindLifeSoundList)
	end
	
	if self.pauseCameraRotate then
		self.fight.clientFight.cameraManager:SetCameraRotatePause(false)
		self.pauseCameraRotate = false
	end

	if self.lifeBindFightUIState then
		self.fightUIState = not self.fightUIState
		BehaviorFunctions.SetFightMainNodeVisible(FightEnum.BehaviorUIOpType.behavior,"PanelParent",self.fightUIState, 2)
	end

	if self.lifeBindMotionBlur then
		self.lifeBindMotionBlur = false
		BehaviorFunctions.SetMotionBlur(false)
	end

	if self.lifeBindHideAllEntity then
		self.lifeBindHideAllEntity = false
		self.fight.entityManager:ShowAllEntity()
	end

	self:RemoveAllScreenEffect()
end

function SkillComponent:OnCache()
	self.moveSpeed = nil
	self.moveAcceleration = nil
	self.moveFrame = nil
	TableUtils.ClearTable(self.sign)
	TableUtils.ClearTable(self.eventActiveSign)
	TableUtils.ClearTable(self.magicLevel)
	TableUtils.ClearTable(self.entityLevel)
	TableUtils.ClearTable(self.skillLevel)
	TableUtils.ClearTable(self.stopDelaySoundMap)
	self.fight.objectPool:Cache(SkillComponent,self)
end

function SkillComponent:__cache()

end

function SkillComponent:__delete()
	if self.frameEventComponent then
		self.frameEventComponent:DeleteMe()
		self.frameEventComponent = nil
	end
end


function SkillComponent:AddLifeBindSound(sound)
	self.stopDelaySoundMap[sound.EventName] = nil
	table.insert(self.bindLifeSoundList, sound)
end

function SkillComponent:AddLifeBindCameraCtrl(params)
	self.pauseCameraRotate = true
	self.pauseCameraRotateEndFrame = self.frame + params.DurationnFrame
	self.fight.clientFight.cameraManager:SetCameraRotatePause(true)
end

function SkillComponent:GetSetButtonInfos()
	local setButtonConfigs = {}
	for key, value in pairs(self.skillsConfig) do
		if value.SetButtonInfos then
			setButtonConfigs[key] = value.SetButtonInfos
		end
	end
	return setButtonConfigs
end

function SkillComponent:BreakEffect()
	if self.entity.instanceId == Fight.Instance.playerManager:GetPlayer().ctrlId then
		self:BreakPauseFrame()
		self:BreakCameraEffect()
		self:BreakShieldTimePaused()
	end
end

function SkillComponent:BreakPauseFrame()
	self.entity.timeComponent:RemoveCanBreakPauseFrame()
	self.fight.entityManager.commonTimeScaleManager:RemoveCanBreakPauseFrame()
	BehaviorFunctions.RemoveBuffByKind(self.entity.instanceId, 1008)
end

function SkillComponent:BreakShieldTimePaused()
	self.entity.timeComponent:RemoveShieldData()
	self.fight.entityManager.commonTimeScaleManager:RemoveShieldData()
end

function SkillComponent:BreakCameraEffect()
	self.fight.clientFight.cameraManager.cameraShakeManager:BreakShieldShake()
	self.fight.clientFight.cameraManager:SkillBreakFovChange()
end

-- TODO 后续修改位置吧
function SkillComponent:MotionBlur(params)
	if params.IsAdd == 1 then
		BehaviorFunctions.SetMotionBlur(true, params.Quality, params.Intensity, params.Clamp, params.UseMask)
		self.motionBlurFrame = params.Duration
		self.lifeBindMotionBlur = params.LifeBind
	else
		BehaviorFunctions.SetMotionBlur(false)
	end
end

function SkillComponent:HideAllEntity(params)
	self.hideAllEntityFrame = params.Duration
	self.lifeBindHideAllEntity = true

	local ingoreParam = { [self.entity.instanceId] = { isIgnoreTime = true, isIgnoreHide = true } }
	self.fight.entityManager:HideAllEntity(ingoreParam)
end

function SkillComponent:GetCurSkillConfig()
	if self.skillId == 0 then
		return
	end

	return self.skillsConfig[self.skillId]
end

-- TODO 临时处理 给下落攻击不受掉落伤害用
function SkillComponent:CheckCurSkillIsDropSkill()
	if not self.skillId or self.skillId == 0 then
		return false
	end

	local curSkillInfo = self.skillsConfig[self.skillId]
	if not curSkillInfo then
		return false
	end

	local skillType = curSkillInfo.SkillType
	if skillType & FightEnum.SkillType.DropAttackStart ~= 0 and
 	   skillType & FightEnum.SkillType.DropAttackLoop ~= 0 and
	   skillType & FightEnum.SkillType.DropAttackLand ~= 0 then
		return false
	end

	local skillSign = curSkillInfo.SkillSign
	if skillSign ~= 170 and skillSign ~= 171 and skillSign ~= 172 then
		return false
	end

	return true
end

--#region TODO 后续改到ClientEffect里面去
function SkillComponent:AddScreenEffect(params, go)
	if UtilsBase.IsNull(go) then
		return
	end

	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	if UtilsBase.IsNull(mainUI) then
		return
	end

	self.screenEffectId = self.screenEffectId or 0
	self.screenEffect = self.screenEffect or {}
	self.bindScreenEFrame = self.bindScreenEFrame or {}
	self.screenEffectParam = self.screenEffectParam or {}
	self.screenEffectIdList = self.screenEffectIdList or {}

	self.screenEffectId = self.screenEffectId + 1
	self.screenEffect[self.screenEffectId] = go
	self.screenEffectParam[self.screenEffectId] = params
	self.bindScreenEFrame[self.screenEffectId] = params.BindFrame
	table.insert(self.screenEffectIdList, self.screenEffectId)

	local target = params.CreateType == 2 and self.target or self.entity
	local position = target.transformComponent:GetPosition()
	local rotation = target.transformComponent:GetRotation()
	if params.BindTransform then
		local targetTransform = target.clientTransformComponent:GetTransform(params.BindTransform)
		position = targetTransform.position
		rotation = targetTransform.rotation
	end

	local bornOffset = Vec3.New(params.BornOffsetX or 0, params.BornOffsetY or 0, params.BornOffsetZ or 0)
	bornOffset = rotation * bornOffset

	local uiPos = UtilsBase.WorldToUIPointBase(position.x + bornOffset.x, position.y + bornOffset.y, position.z + bornOffset.z)
	local effectT = go.transform
	effectT:SetParent(mainUI.transform)
	UnityUtils.SetLocalScale(effectT, 1, 1, 1)
	UnityUtils.SetLocalPosition(effectT, uiPos.x, uiPos.y, uiPos.z)
end

function SkillComponent:UpdateScreenEffect()
	if not self.screenEffectIdList or not next(self.screenEffectIdList) then
		return
	end

	self.removeEffectIdList = self.removeEffectIdList or {}

	for k, v in pairs(self.screenEffectIdList) do
		self.bindScreenEFrame[v] = self.bindScreenEFrame[v] - 1
		if self.bindScreenEFrame[v] <= 0 then
			self.fight.clientFight.assetsPool:Cache(self.screenEffectParam[v].path, self.screenEffect[v], true, true)
			self.screenEffectParam[v] = nil
			self.screenEffect[v] = nil
			self.bindScreenEFrame[v] = nil
			table.insert(self.removeEffectIdList, k)
		else
			local params = self.screenEffectParam[v]
			local target = params.CreateType == 2 and self.target or self.entity
			local position = target.transformComponent:GetPosition()
			local rotation = target.transformComponent:GetRotation()
			if params.BindTransform then
				local targetTransform = target.clientTransformComponent:GetTransform(params.BindTransform)
				position = targetTransform.position
				rotation = targetTransform.rotation
			end

			local bornOffset = Vec3.New(params.BornOffsetX or 0, params.BornOffsetY or 0, params.BornOffsetZ or 0)
			bornOffset = rotation * bornOffset

			local uiPos = UtilsBase.WorldToUIPointBase(position.x + bornOffset.x, position.y + bornOffset.y, position.z + bornOffset.z)
			UnityUtils.SetLocalPosition(self.screenEffect[v].transform, uiPos.x, uiPos.y, uiPos.z)
		end
	end

	for i = 1, #self.removeEffectIdList do
		table.remove(self.screenEffectIdList, self.removeEffectIdList[i])
	end

	TableUtils.ClearTable(self.removeEffectIdList)
end

function SkillComponent:RemoveAllScreenEffect()
	if not self.screenEffectIdList or not next(self.screenEffectIdList) then
		return
	end

	for k, v in pairs(self.screenEffectIdList) do
		self.fight.clientFight.assetsPool:Cache(self.screenEffectParam[v].path, self.screenEffect[v], true, true)
		self.screenEffectParam[v] = nil
		self.screenEffect[v] = nil
		self.bindScreenEFrame[v] = nil
		table.insert(self.removeEffectIdList, k)
	end

	TableUtils.ClearTable(self.screenEffectIdList)
	TableUtils.ClearTable(self.removeEffectIdList)
end
--#endregion