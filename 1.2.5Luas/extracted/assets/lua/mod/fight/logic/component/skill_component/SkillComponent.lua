---@class SkillComponent
SkillComponent = BaseClass("SkillComponent",PoolBaseClass)

local sqrt = math.sqrt

function SkillComponent:__init()
	self.sign = {}
	self.eventActiveSign = {}
	self.magicLevel = {}
	self.skillLevel = {}
end

function SkillComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.frame = 0
	self.skillId = 0
	self.skillType = 0
	self.frameEventComponent = self.fight.objectPool:Get(FrameEventComponent)
	self.frameEventComponent:Init(self.fight,self)
	
	self.attrComponent = self.entity.attrComponent 
	self.skillSetComponent = self.entity.skillSetComponent
	self:InitSkillInfo()
	self.bindLifeSoundList = {}
	self.stopDelaySoundMap = {}
	self.earlyWarningList = {}
end

function SkillComponent:LateInit()
	self:InitSkillLevel()
end

function SkillComponent:InitSkillInfo()
	--self.skillMap = {}
	self.skillsConfig = self.entity:GetComponentConfig(FightEnum.ComponentType.Skill).Skills
	--self:LoadSkill(self.skillsConfig)

	-- 技能暂时合并，方便统一入口,后续需要优化
	-- if self.entity:GetComponentConfig(FightEnum.ComponentType.Pasv) then
	-- 	local pasvConfig = self.entity:GetComponentConfig(FightEnum.ComponentType.Pasv).Skills
	-- 	self:LoadSkill(pasvConfig)
	-- end
end

function SkillComponent:InitSkillLevel()
	TableUtils.ClearTable(self.skillLevel)
	if self.entity.tagComponent and self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Player then
		-- todo 读系统等级
		local roleId = self.entity.masterId
		local skillList = RoleConfig.GetRoleSkill(roleId) or {}
	
		for k, skillId in pairs(skillList) do
			local skillCfg = RoleConfig.GetSkillConfig(skillId)-- 系统技能id
			--读服务器技能等级
			local skillLevel = mod.RoleCtrl:GetSkillInfo(roleId, skillId)

			--记录实际技能等级
			if skillCfg and skillCfg.fight_skills then
				for key, value in pairs(skillCfg.fight_skills) do
					if value ~= 0 then
						self.skillLevel[value] = skillLevel
					end
				end
			end
		end
	elseif self.entity.tagComponent and self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Partner then
		-- todo 读系统等级
		local partnerId = 0
		local entityParams = self.entity.params
		if entityParams and entityParams.partnerUnId then
			partnerId = entityParams.partnerUnId
		else
			local roleId = self.entity.owner.masterId
			partnerId = mod.RoleCtrl:GetRolePartner(roleId)
		end

		local partnerData = mod.BagCtrl:GetPartnerData(partnerId)
		if partnerData and partnerData.skill_list then
			for _, skillInfo in pairs(partnerData.skill_list) do
				local skillCfg = RoleConfig.GetPartnerSkillConfig(skillInfo.key)-- 系统技能id
				--读服务器技能等级
				local skillLevel = skillInfo.value
				--记录实际技能等级
				if skillCfg and skillCfg.fight_skills then
					for _, value in pairs(skillCfg.fight_skills) do
						if value ~= 0 then
							self.skillLevel[value] = skillLevel
						end
					end
				end
			end
		end
	end
end

function SkillComponent:GetSkillLevel(skillId)
	if self.skillLevel and self.skillLevel[skillId] then
		return self.skillLevel[skillId]
	end
	local entity = self.entity
	if entity.owner ~= entity and entity.owner and entity.owner.skillComponent then
		return entity.owner.skillComponent:GetSkillLevel(skillId)
	end
	return 1
end

--#region TODO 技能资源与cd信息, 已经用不到了
function SkillComponent:LoadSkill(config)
	if not config then
		return
	end

	for skillId, v in pairs(config) do
		local info = 
		{
			level = 1,
			skillId = skillId,
			config = v,
			-- attrType = v.AttrType,
			-- useCostType = v.UseCostType,
			-- useCostValue = v.UseCostValue
		}

		if v.ChargeTimes then
			info.curChargeTimes = 0
			info.maxChargeTimes = v.ChargeTimes
		end
		
		if v.CDtime then 
			info.maxCDtime = v.CDtime * 10000
			info.curCDtime = v.AttrType == FightEnum.SkillAttrType.Base and 0 or info.maxCDtime
		end
		
		self.skillMap[skillId] = info
	end
end

function SkillComponent:GetSkillInfo(skillId)
	return self.skillMap[skillId]
end

--#endregion

function SkillComponent:GetSkillConfig(skillId)
	return self.skillsConfig[skillId]
end

function SkillComponent:GetMagicLevel(magicId)
	if not magicId then
		return 1
	end

	return self.magicLevel[magicId] or 1
end

local StopSoundType = SoundManager.ActionEvent.AkActionOnEventType_Stop
local StopSoundFadeCurve = SoundManager.AkCurveInterpolation.AkCurveInterpolation_SineRecip
function SkillComponent:StopSoundEvent(sound)
	local gameObject = self.entity.clientEntity.clientTransformComponent:GetGameObject()
	if sound.StopSoundEvent and sound.StopSoundEvent then
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
	self.frameEventComponent:DoFrameEvent(self.frame, self:GetSkillLevel(self.skillId))

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
	--self:UpdatePreciseTargetMove()
end

function SkillComponent:UpdateIgnoreTimeScale()
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

	self.entity.clientEntity.clientTransformComponent:Async()
	
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
			self.target.clientEntity.clientTransformComponent:Async()
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
	if self.frame > self.moveEndFrame then
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
		if self.skillMoveDone == FightEnum.SkillMoveDone.CheckRadiusMove then
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
			local move = v2 * self.inputSpeed * scale * FightUtil.deltaTimeSecond
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
	--do return end
	if not self.PTM then
		return
	end
	
	if self.PTMDdurationMoveFrame <= 0 and self.PTMVDdurationMoveFrame <= 0 then
		self.PTM = false
		return
	end
	if self.entity.timeComponent.frame >= self.PTMStartFrame and 
		self.entity.timeComponent.frame < self.PTMStartFrame + self.PTMDurationUpdateTargetFrame then
		local locationPoint = nil
		if self.target then
			locationPoint = self.target.clientEntity.clientTransformComponent:GetTransform(self.PTMLocationBone)
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
			--Log(self.PTMDdurationMoveFrame.."  yDif "..yDif.."  ySpeed "..ySpeed.." ty "..self.PTMPosition.y.." sy"..self.entity.transformComponent.position.y.." dif "..(self.entity.transformComponent.position.y - self.PTMPosition.y))
			--self.entity.moveComponent:DoMoveUp(ySpeed * scale)
			if ySpeed > 0 then
				self.entity.moveComponent:DoMoveUp(ySpeed * scale)
			else
				self.entity.moveComponent:DoMoveDown(ySpeed * scale)
			end
			--print(yDif, ySpeed, self.PTMVDdurationMoveFrame)
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
	local y = lookAtPos.y - curPosition.y
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

function SkillComponent:CastSkillByTarget(skillId,target,targetPart)
	self:Clear()
	self.skillId = skillId
	self.target = target
	
	self.targetPart = targetPart
	
	local part = self.target.partComponent:GetPart(targetPart)
	self.targetPosition = part.lockTransform and part.lockTransform.position or 
						  self.target.clientEntity.clientTransformComponent:GetTransform().position
	
	self:CastSkill()
end

function SkillComponent:CastSkillByPosition(skillId,x,y,z)
	self:Clear()
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

function SkillComponent:CastSkill()
	self.frame = 0
	
	if not self.skillsConfig[self.skillId] then
		LogError("找不到技能Id. "..self.skillId)
		return
	end
	self.skillType = self.skillsConfig[self.skillId].SkillType
	self.totalFrame = self.skillsConfig[self.skillId].TotalFrame
	self.forceFrame = self.skillsConfig[self.skillId].ForceFrame
	self.anotherBreakFrame = self.skillsConfig[self.skillId].SkillBreakSkillFrame
	self.changeRoleFrame = self.skillsConfig[self.skillId].ChangeRoleFrame
	self.entity.stateComponent:SetState(FightEnum.EntityState.Skill)
	self.frameEventComponent:SetFrameEventConfig(self.skillsConfig[self.skillId])
	self.frameEventComponent:DoFrameEvent(0, self:GetSkillLevel(self.skillId))--提前执行，比如由实体逻辑触发释放技能应该当帧释放
	self.castSkillFightFrame = self.fight.fightFrame

	self.fight.entityManager:CallBehaviorFun("CastSkill", self.entity.instanceId, self.skillId,self.skillType)
	EventMgr.Instance:Fire(EventName.CastSkill, self.entity.instanceId, self.skillId, self.skillType)
	if ctx then
		self.fight.clientFight.skillGuideManager:SetCurSkill(self.skillId)
	end
end

function SkillComponent:Break(attackId)
	self.attackId = attackId
	self:Finish()
	self.entity.clientEntity.clientTransformComponent:SetPivotYOffset()
end

function SkillComponent:BreakBySelf()
	self:Finish()
end

function SkillComponent:onLevelSkillMachine()
	local instanceId = self.entity.instanceId
	local skillId = self.skillId
	local skillType = self.skillType
	if self.frame > self.totalFrame then
		self:Clear()
		self.fight.entityManager:CallBehaviorFun("FinishSkill", instanceId, skillId, skillType)
	else
		self:BreakPauseFrame()
		self:Clear()
		self.fight.entityManager:CallBehaviorFun("BreakSkill", instanceId, skillId, skillType)
	end
end

function SkillComponent:Finish()
	if not BehaviorFunctions.CheckEntity(self.entity.instanceId) then
		return
	end

	local isAloft = self.entity.moveComponent and self.entity.moveComponent.isAloft
	if isAloft then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
	else
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function SkillComponent:GetSkillSign(type)
	if not self.sign[type] then
		return false
	end
	return self.sign[type].StartFrame <= self.frame and self.frame < self.sign[type].EndFrame
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

function SkillComponent:DoMoveEvent(speed,acceleration,moveFrame,direction,inputSpeed,minDistance,IgnoreYAxis,skillMoveDone,customDir)
	self.moveSpeed = speed
	self.moveAcceleration = acceleration
	self.moveEndFrame = self.frame + moveFrame
	self.moveDirection = direction
	self.inputSpeed = inputSpeed
	self.minDistance = minDistance
	self.minDisIgnoreYAxis = IgnoreYAxis
	self.skillMoveDone = skillMoveDone
	--customDir = customDir:Div(360)
	self.customDir = customDir:SetNormalize()
end

function SkillComponent:DoRotateEvent(rotateType,speed,acceleration,rotateFrame)
	self.rotateType = rotateType
	self.rotateSpeed = speed
	self.rotateAcceleration = acceleration
	self.rotateEndFrame = self.frame + rotateFrame
end

function SkillComponent:DoPreciseTargetMove(durationUpdateTargetFrame,offsetType,offset,durationMoveFrame,vDurationMoveFrame,ignoreY,maxSpeed,minSpeed,boneName)
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
end

function SkillComponent:DoPreciseTargetRotate(durationFrame, maxSpeed, minSpeed)
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
		self.fight.entityManager:CallBehaviorFun("ClearSkill", self.entity.instanceId, self.skillId, self.skillType)
	end

	self:ClearAnimation()
	self.frame = 0
	self.skillId = 0
	self.skillType = 0
	self.target = nil
	self.targetPart = nil
	self.forceFrame = 0
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
	self.PTM = false
	self.attackId = nil
	
	self:ClearLifeBindTable()
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

	if next(self.bindLifeSoundList) then
		local gameObject = self.entity.clientEntity.clientTransformComponent:GetGameObject()
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
end

function SkillComponent:OnCache()
	self.moveSpeed = nil
	self.moveAcceleration = nil
	self.moveFrame = nil
	TableUtils.ClearTable(self.sign)
	TableUtils.ClearTable(self.eventActiveSign)
	TableUtils.ClearTable(self.magicLevel)
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

function SkillComponent:BreakPauseFrame()
	if self.entity.instanceId == Fight.Instance.playerManager:GetPlayer().ctrlId then
		self.entity.timeComponent:RemoveCanBreakPauseFrame()
		self.fight.entityManager:RemoveCanBreakPauseFrame()
		BehaviorFunctions.RemoveBuffByKind(self.entity.instanceId, 1008)
	end
end