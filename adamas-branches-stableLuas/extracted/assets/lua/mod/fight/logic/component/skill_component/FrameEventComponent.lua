FrameEventComponent = BaseClass("FrameEventComponent",PoolBaseClass)

local Vec3 = Vec3

local SkillEventType = FightEnum.SkillEventType
local FrameEventFuns =
{
	[SkillEventType.CreateEntity] = "DoCreateEntity", --需要等级
	[SkillEventType.PlayAnimation] = "DoPlayAnimation",
	[SkillEventType.FrameSign] = "FrameSign",
	[SkillEventType.CameraShake] = "CameraShake",
	[SkillEventType.Log] = "Log",
	[SkillEventType.ActiveDodge] = "DoActiveDodge",
	[SkillEventType.Move] = "DoMove",
	[SkillEventType.Rotate] = "DoRotate",
	[SkillEventType.AddBuff] = "AddBuff", --需要等级
	[SkillEventType.DoMagic] = "DoMagic", --需要等级
	[SkillEventType.EntitySign] = "EntitySign",
	[SkillEventType.VerticalSpeed] = "VerticalSpeed",
	[SkillEventType.ReboundAttack] = "ReboundAttack",
	[SkillEventType.CameraOffsets] = "CameraOffsets",
	[SkillEventType.PlaySound] = "PlaySound",
	[SkillEventType.PostProcess] = "PostProcess",
	[SkillEventType.CameraCtrl] = "CameraCtrl",
	[SkillEventType.PreciseTargetMove] = "PreciseTargetMove",
	[SkillEventType.EnableAnimMove] = "EnableAnimMove",
	[SkillEventType.EarlyWarning] = "EarlyWarning",
	[SkillEventType.CameraFixeds] = "CameraFixeds",
	[SkillEventType.EnableAnimMoveWithAxis] = "EnableAnimMoveWithAxis",
	[SkillEventType.PreciseTargetRotate] = "PreciseTargetRotate",
	[SkillEventType.EnableCollision] = "EnableCollision",
	[SkillEventType.ActiveParry] = "ActiveParry",
	[SkillEventType.Suicide] = "Suicide",
	[SkillEventType.HideFightPanel] = "HideFightPanel",
	[SkillEventType.CameraPosReduction] = "CameraPosReduction",
	[SkillEventType.PlayWeaponAnimation] = "PlayWeaponAnimation",
	[SkillEventType.ShieldTimeAndCameraEffect] = "ShieldTimeAndCameraEffect",
	[SkillEventType.PreciseTargetPointMove] = "PreciseTargetPointMove",
	[SkillEventType.CamerFOVChange] = "CamerFOVChange",
	[SkillEventType.BreakCamerFOVChange] = "BreakCamerFOVChange",
	[SkillEventType.MotionBlur] = "MotionBlur",
	[SkillEventType.HideAllEntity] = "HideAllEntity",
	[SkillEventType.AddShadow] = "DoAddShadow",
	[SkillEventType.AddScreenEffect] = "AddScreenEffect",
}

function FrameEventComponent:__init()
	self.lastSplitFrame = 0
end

function FrameEventComponent:Init(fight,skillComponent)
	self.fight = fight
	self.skillComponent = skillComponent
	self.entity = self.skillComponent.entity

	self.haveTarget = false

	EventMgr.Instance:AddListener(EventName.SetLockTarget, self:ToFunc("OnSetLockTarget"))
end

function FrameEventComponent:SetFrameEventConfig(frameEventConfig)
	self.frameEventConfig = frameEventConfig
end

function FrameEventComponent:DoSplitFrameEvent(SplitFrame)
	if not self.frameEventConfig then
		return
	end
	local frameEventList = self.frameEventConfig.FrameEvent[self.frame]
	if not frameEventList then
		return
	end

	for k, v in pairs(frameEventList) do
		if v.IsSplitFrame then
			if v.SplitFrame > self.lastSplitFrame and v.SplitFrame <= SplitFrame then
				self:DoEvent(v, self.skillLev,self.frame)
			end
		end
	end
	self.lastSplitFrame = SplitFrame
end

function FrameEventComponent:DoFrameEvent(frame, skillLev)
	self.lastSplitFrame = 0
	self.frame = frame
	self.skillLev = skillLev
	local skillType = self.frameEventConfig.SkillType
	local frameEventList = self.frameEventConfig.FrameEvent[frame]
	if not frameEventList then
		return
	end

	for k, v in pairs(frameEventList) do
		if not v.IsSplitFrame then
			self:DoEvent(v, skillLev,frame, skillType)
		end
	end
end

function FrameEventComponent:DoEvent(params, skillLev,frame, skillType)
	if self:CheckEnableEvent(params) then
		local func = FrameEventFuns[params.EventType]
		UnityUtils.BeginSample("DoEvent_"..func)
		--assert(func, "error frameEvent func: " .. params.EventType)
		self[func](self, params, skillLev, skillType)
		UnityUtils.EndSample()
	end
end

function FrameEventComponent:CheckEnableEvent(params)
	local curQuality = nil
	if params._debugQualitySign then
		curQuality = params._debugQualitySign
	end
	if params.QualitySign and curQuality
		and (params.QualitySign | curQuality) == 0 then
		return false
	end

	if not params.ActiveSign or not next(params.ActiveSign) then
		return true
	end

	for _,sign in ipairs(params.ActiveSign.Sign) do
		local isExistSign,_ = self.skillComponent:CheckEventActiveSign(sign)
		if isExistSign then
			return true
		end
	end
	return false
end

function FrameEventComponent:DoAddShadow(params, skillLev,skillType,isRepeat)

	local bodyColor = params.bodyColor
	local edgeColor = params.edgeColor
	local continueFrame = params.continueFrame
	local disappearFrame = params.disappearFrame
	local gopFrame = params.gopFrame
	local animName = self.animName
	local currentState =  self.entity.clientAnimatorComponent.animator:GetCurrentAnimatorStateInfo(0)
	--更改颜色透明度
	bodyColor[4] = params.alphaValue
	edgeColor[4] = params.alphaValue

	if not isRepeat  then
		self.animName = animName
	else
		if animName ~= self.animName then
			LuaTimerManager.Instance:RemoveTimer(self.timer)
			return
		end
	end
	
	local entity = self.fight.entityManager:CreateEntity(params.EntityId, self.entity)
	if entity==nil then
		return
	end
	
	if continueFrame then
		entity.timeoutDeathComponent.remainingFrame = continueFrame + disappearFrame
	end

	local animFrame = self.entity.animatorComponent.animFrame
	--更改材质颜色
	entity.clientTransformComponent:SetMaterialMeshValue("_BaseColor",bodyColor[1],bodyColor[2],bodyColor[3],bodyColor[4])
	entity.clientTransformComponent:SetMaterialMeshValue("_FresnelColor",edgeColor[1],edgeColor[2],edgeColor[3],edgeColor[4])
	entity.clientTransformComponent:SetMaterialMeshValue("_FresnelF0",params.edgeModulusX,params.edgeModulusY,0,0)
	--残影渐消失
	local startTime = (continueFrame/animFrame)*currentState.length
	local loopTime = (disappearFrame/animFrame)*currentState.length
	local endTime = startTime+loopTime
	CustomUnityUtils.SetMaterialSetter(entity.clientTransformComponent.gameObject,startTime,loopTime,endTime)
	self.entity.clientEntity.clientAnimatorComponent:SetAnimationSync(entity)

	if gopFrame~=0 and not isRepeat  then
		local count = math.floor(params.allFrame/gopFrame)
		if count <=0 then
			return
		end
		local time = (gopFrame/animFrame)*currentState.length
		if self.timer then
			LuaTimerManager.Instance:RemoveTimer(self.timer)
		end
		self.timer =  LuaTimerManager.Instance:AddTimer(count, time,function ()
			self:DoAddShadow(params,skillLev,skillType,true)
		end )
	end
end

function FrameEventComponent:DoCreateEntity(params,skillLev, skillType)
	
	local entity = self.fight.entityManager:CreateEntity(params.EntityId, self.entity)

	entity:SetDefaultSkillLevel(skillLev)
	entity:SetDefaultSkillType(skillType)
	if entity.attackComponent then
		entity.attackComponent:SetCameraShakeId(params.CameraShakeId)
		entity.attackComponent:SetPauseFrameId(params.PauseFrameId)
	end
	--如果是召唤物，要一直把skillType传下去
	if entity.skillComponent then
		entity.skillComponent:SetParentSkillType(skillType)
	end

	local setBornOffset = true
	if entity.moveComponent and entity.moveComponent:IsBindMoveType() then
		setBornOffset = false
	end

	if entity.moveComponent then
		local target = self.skillComponent.target
		if not target and self.entity.parent then
			target = self.entity.parent.skillComponent.target
		end

		if target then
			if entity.moveComponent.moveComponent.SetTarget then
				entity.moveComponent.moveComponent:SetTarget(target)
			end
		elseif entity.moveComponent.config.MoveType == FightEnum.MoveType.Track then
			local targetPosition = self.skillComponent.targetPosition
			if not targetPosition and self.entity.parent then
				targetPosition = self.entity.parent.skillComponent.targetPosition
			end

			if targetPosition then
				entity.moveComponent.moveComponent:SetTrackPosition(targetPosition.x, targetPosition.y, targetPosition.z)
			end
		end
	end

	if not entity.clientEffectComponent and setBornOffset and
		(params.BornOffsetX or params.BornOffsetY or params.BornOffsetZ) then
		local position = Vec3.New(0, 0, 0)
		local bornOffset = Vec3.New(params.BornOffsetX or 0, params.BornOffsetY or 0, params.BornOffsetZ or 0)

		if params.CreateEntityType and params.CreateEntityType == 2 then
			local target = self.skillComponent.target
			-- local targetTransform = target and target.clientTransformComponent:GetTransform(params.BindTransform) or nil
			local skillTargetPos = self.skillComponent.targetPosition
			position:Set(skillTargetPos.x, skillTargetPos.y, skillTargetPos.z)
			if not params.IsInherit and target then
				local targetTransform = target and target.clientTransformComponent:GetTransform(params.BindTransform) or nil
				if not UtilsBase.IsNull(targetTransform) then
					local targetTransPos = targetTransform.position
					position:Set(targetTransPos.x, targetTransPos.y, targetTransPos.z)
				end
			end

			if params.IsBindTargetPosGround then
				local height = BehaviorFunctions.CheckPosHeight(position)
				if height then
					position:Set(position.x, position.y - height, position.z)
				end
			end

			local dis = Vec3.Distance(position,self.entity.transformComponent.position)
			local dir = self.entity.transformComponent.position - position
			if dis > params.MaxDistance then
				local normalized = Vec3.Normalize(dir)
				bornOffset = bornOffset + normalized * params.MaxDistance
			else
				bornOffset = dir.normalized * params.BornOffsetZ
				local q = Quat.Euler(0, 90, 0)
				bornOffset = bornOffset + q * dir.normalized * params.BornOffsetX
				bornOffset = bornOffset + Vec3.up * params.BornOffsetY
			end
		else
			if params.BindTransform and params.BindTransform ~= "" then
				local transform = self.entity.clientTransformComponent:GetTransform(params.BindTransform)
				position = transform.position
				bornOffset = transform.rotation * bornOffset
			else
				position = self.entity.transformComponent.position
				bornOffset = self.entity.transformComponent.rotation * bornOffset
			end
		end

		local posX = position.x + bornOffset.x
		local posY = position.y + bornOffset.y
		local posZ = position.z + bornOffset.z
		if params.TerriaOffsetY and params.TerriaOffsetY ~= 0 then
			local height, haveGround = CustomUnityUtils.GetTerrainHeight(posX, posY, posZ)
			posY = posY - height + params.TerriaOffsetY
		end

		entity.transformComponent:SetPosition(posX, posY, posZ)
	elseif entity.clientEffectComponent and (not entity.clientEffectComponent.config.BindTransformName or entity.clientEffectComponent.config.BindTransformName == "") then
		local position = self.entity.transformComponent.position
		local bornOffset = Vec3.New(params.BornOffsetX or 0, params.BornOffsetY or 0, params.BornOffsetZ or 0)
		bornOffset = self.entity.transformComponent.rotation * bornOffset

		local posX = position.x + bornOffset.x
		local posY = position.y + bornOffset.y
		local posZ = position.z + bornOffset.z
		if params.TerriaOffsetY and params.TerriaOffsetY ~= 0 then
			local height, haveGround = CustomUnityUtils.GetTerrainHeight(posX, posY, posZ)
			posY = posY - height + params.TerriaOffsetY
		end

		entity.transformComponent:SetPosition(posX, posY, posZ)
	end

	if entity.rotateComponent then
		if params.LookatTarget and params.LookAngleRange and params.LookAngleRange > 0 then
			local targetOffsetY = params.TargetOffsetY and params.TargetOffsetY or 0
			local targetPosition = self.skillComponent.targetPosition
			if self.skillComponent.target and self.skillComponent.target.partComponent then
				targetPosition = self.skillComponent.target.partComponent:GetPart(self.skillComponent.targetPart).lockTransform.position
			end
			-- local entityRotation = self.entity.clientTransformComponent.transform.rotation
			local entityRotation = self.entity.transformComponent:GetRotation()
			--出生点到目标点的方向向量
			local targetRotation = Quat.LookRotationA(targetPosition.x - entity.transformComponent.position.x,
				targetPosition.y + targetOffsetY - entity.transformComponent:GetRealPositionY(),
				targetPosition.z - entity.transformComponent.position.z)

			local angle = Quat.Angle(entityRotation, targetRotation)
			angle = math.abs(angle < 180 and angle or angle - 360)
			local maxRotation = 0
			if angle > params.LookAngleRange and angle ~= 0 then
				maxRotation = Quat.Slerp(entityRotation, targetRotation, params.LookAngleRange / angle or 1)
			else
				maxRotation = Quat.Slerp(entityRotation, targetRotation, 1)
			end
			local rotation = Quat.Euler(params.BornRotateOffsetX, params.BornRotateOffsetY, params.BornRotateOffsetZ) * maxRotation
			entity.rotateComponent:SetRotation(rotation)
		else
			-- local eulerAngles = self.entity.clientTransformComponent.transform.rotation.eulerAngles
			local eulerAngles = self.entity.transformComponent:GetRotation():ToEulerAngles()
			local rotation = Quat.Euler(params.BornRotateOffsetX + eulerAngles.x, params.BornRotateOffsetY + eulerAngles.y, params.BornRotateOffsetZ + eulerAngles.z)
			entity.rotateComponent:SetRotation(rotation)
		end
		--if params.LookatTarget then
		--entity.rotateComponent:LookAtPositionWhitY(self.skillComponent.targetPosition.x,self.skillComponent.targetPosition.y,
		--self.skillComponent.targetPosition.z)
		--else
		--local rotation = self.entity.transformComponent.rotation
		--entity.rotateComponent:SetRotation(rotation)
		--end
		entity.rotateComponent:Async()
	end

	if entity.tagComponent then
		local camp = self.entity.tagComponent.camp
		entity.tagComponent:SetCamp(camp)
	end

	if params.LifeBindOwner then
		self.entity:LifeBindEntity(entity.instanceId)
	end

	local bindSkillFrame = 0
	if not params.LifeBindSkillFrame then
		if params.LifeBindSkill then
			params.LifeBindSkillFrame = -1
		end
	else
		bindSkillFrame = params.LifeBindSkillFrame
	end

	if bindSkillFrame ~= 0 then
		self.skillComponent:LifeBindEntity(entity.instanceId, bindSkillFrame)
	end

	self.fight.entityManager:CallBehaviorFun("KeyFrameAddEntity", entity.instanceId, entity.entityId)
end

function FrameEventComponent:DoPlayAnimation(params)
	local layer = params.LayerIndex
	if layer > 0 then
		layer = self.entity.clientAnimatorComponent:GetLayerIndex(FightEnum.AnimationLayerIndexToName[params.LayerIndex + 1])
	end
	self.entity.animatorComponent:PlayAnimation(params.Name,params.StartFrame, layer, self.skillComponent.frame == 0)
end

function FrameEventComponent:FrameSign(params)
	self.skillComponent.sign[params.Type] = {
		StartFrame = self.skillComponent.frame,
		EndFrame = self.skillComponent.frame + params.Frame
	}

	self.fight.entityManager:CallBehaviorFun("AddSkillSign", self.entity.instanceId, params.Type)
end

function FrameEventComponent:CameraShake(params)
	if ctx then
		--if self.entity.parent.instanceId ~= self.fight.playerManager:GetPlayer():GetCtrlEntity() then
		--return
		--end
		if params.CameraShake then
			for k, v in pairs(params.CameraShake) do
				self.fight.clientFight.cameraManager.cameraShakeManager:Shake(v, self.entity)
			end
		else
			-- 旧的方式
			self.fight.clientFight.cameraManager.cameraShakeManager:Shake(params, self.entity)
		end
	end
end

function FrameEventComponent:Log(params)
	print(params.Msg)
end

function FrameEventComponent:DoActiveDodge(params)
	self.entity.dodgeComponent:ActiveDodge(params.Frame,params.RingCount)
end

function FrameEventComponent:DoMove(params)
	local startSpeed = 0
	if params.SpeedType == 2 then
		startSpeed = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.WalkSpeed)
	elseif params.SpeedType == 3 then
		startSpeed = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.RunSpeed)
	elseif params.SpeedType == 4 then
	end
	local speed = startSpeed + params.SpeedOffset
	local acceleration = params.Acceleration
	local moveFrame = params.MoveFrame
	local customDir
	if params.CustomX then
		customDir = Vec3.New(params.CustomX,params.CustomY,params.CustomZ)
	else
		customDir = Vec3.New(0,0,0)
	end
	self.skillComponent:DoMoveEvent(speed,acceleration,moveFrame,params.Direction,
		params.InputSpeed,params.MinDistance,params.IgnoreYAxis,params.SkillMoveDone,customDir,params.CanFlick)
end

function FrameEventComponent:DoRotate(params)
	local startSpeed = 0
	if params.UseSelfSpeed == 1 then
		startSpeed = 1720
	end
	local speed = startSpeed + params.SpeedOffset
	local acceleration = params.Acceleration
	local rotateFrame = params.RotateFrame
	self.skillComponent:DoRotateEvent(params.RotateType,speed,acceleration,rotateFrame)
end

function FrameEventComponent:AddBuff(params, skillLev, skillType)
	for i = 1, params.Count do
		if params.AddType == 1 then
			local buff = self.entity.buffComponent:AddBuff(self.entity,params.BuffId, skillLev or 1, nil, nil, nil, skillType)
			if not buff  then
				return
			end
			if params.LifeBindBuff then
				self.skillComponent:LifeBindBuff(buff)
			end
		else
			self.entity.buffComponent:RemoveBuffByBuffId(params.BuffId)
		end
	end
end

function FrameEventComponent:DoMagic(params, skillLev, skillType)
	for i = 1, params.Count do
		local magic = MagicConfig.GetMagic(params.MagicId, self.entity.entityId)
		local buff = MagicConfig.GetBuff(params.MagicId, self.entity.entityId)
		if magic then
			self.fight.magicManager:DoMagic(magic, skillLev, self.entity,self.entity,false, nil, nil, nil, nil, nil, skillType)
		elseif buff and self.entity.buffComponent then
			local buff = self.entity.buffComponent:AddBuff(self.entity, params.MagicId, skillLev or 1, nil, nil, nil, skillType)
			if buff and params.LifeBindBuff then
				self.skillComponent:LifeBindBuff(buff)
			end
		end
	end
end

function FrameEventComponent:EntitySign(params)
	if params.Type == 1 then
		self.entity:AddSignState(params.Sign,params.LastFrame,params.IgnoreTimeScale)
	elseif params.Type == 2 then
		self.entity:RemoveSignState(params.Sign)
	end
end

function FrameEventComponent:VerticalSpeed(params)
	if not self.entity.moveComponent or not self.entity.moveComponent.yMoveComponent then
		return
	end

	local yMoveComponent = self.entity.moveComponent.yMoveComponent
	if params.UseGravity and params.GravityExtraDuration and params.GravityExtraDuration > 0 then
		local gravity = {
			speedY = 0,
			accelerationY = 0,
			duration = params.Duration + params.GravityExtraDuration,
			maxFallSpeed = params.MaxFallSpeed,
			useGravity = params.UseGravity,
			gravity = Config.EntityCommonConfig.JumpParam.Gravity,
		}
		local gravityInstanceId = yMoveComponent:AddForceParam(gravity, true)
		self.skillComponent:LifeBindVS(gravityInstanceId)
	end

	local extraSpeed = params.BaseSpeed and params.BaseSpeed or 0
	local yMoveConfig = {
		speedY = params.ResetSpeed and extraSpeed or yMoveComponent.params.speedY + extraSpeed,
		accelerationY = params.AccelerationY and params.AccelerationY or 0,
		duration = params.Duration,
		maxFallSpeed = params.MaxFallSpeed,
		useGravity = params.UseGravity,
		saveSpeed = params.SaveSpeed,
		gravity = Config.EntityCommonConfig.JumpParam.Gravity,
	}

	local instanceId = yMoveComponent:AddForceParam(yMoveConfig, true)
	self.skillComponent:LifeBindVS(instanceId)
	self.entity.moveComponent:SetAloft(true)
end

function FrameEventComponent:ReboundAttack(params)
	local reboundAttackComponent = self.entity.reboundAttackComponent
	reboundAttackComponent:Start(params)
end

function FrameEventComponent:CameraOffsets(params)
	params.EntityId = self.entity.entityId
	local instanceId = self.fight.clientFight.cameraManager:CreatOffset(params)
	if params.IsBingSkill then
		self.skillComponent:LifeBindCameraOffset(instanceId)
	end
end

function FrameEventComponent:PlaySound(params)
	local gameObject = self.entity.clientTransformComponent:GetGameObject()
	SoundManager.Instance:PlayObjectSound(params.EventName, gameObject)

	if params.LifeBindSkill then
		params.StopDelayFrame = params.StopDelayFrame or 0
		self.skillComponent:AddLifeBindSound(params)
	end
end

function FrameEventComponent:PostProcess(params)
	local postProcessManager = self.fight.clientFight.postProcessManager
	postProcessManager:AddPostProcess(params.PostProcessType, params.PostProcessParams, self.entity)

	if params.LifeBindSkill then
		self.skillComponent:LifeBindPostProcess(params.PostProcessType)
	end
end

function FrameEventComponent:CameraCtrl(params)
	if params.PauseCameraRotate then
		self.skillComponent:AddLifeBindCameraCtrl(params)
	end
end

function FrameEventComponent:PreciseTargetMove(params)
	-- 如果没有目标的话就不生效
	if params.DisableWithoutTarget and not self.haveTarget then
		return
	end

	local offset
	local offsetType = params.OffsetType or FightEnum.PTMOffsetType.MoveDirection
	if offsetType == FightEnum.PTMOffsetType.TargetRelation then
		offset = params.TargetRelationOffset
	elseif offsetType == FightEnum.PTMOffsetType.MoveDirection then
		local hOffset = params.TargetHPositionOffset
		local vOffset = params.TargetVPositionOffset or hOffset
		offset = {hOffset, vOffset, 0}
	end
	local hDuration = params.DurationMoveFrame
	local vDuration = params.VDurationMoveFrame or hDuration
	if vDuration == -1 then
		vDuration = hDuration
	end

	self.skillComponent:DoPreciseTargetMove(params.DurationUpdateTargetFrame,offsetType,offset,
		hDuration,vDuration,params.IgnoreY,params.MaxSpeed,params.MinSpeed,params.BoneName,params.PauseAnimationMove)
end

function FrameEventComponent:PreciseTargetPointMove(params)
	if self.entity.clientEntity.weaponComponent then
		self.entity.clientEntity.weaponComponent:PTMMove(params.MoveFrame, params.MaxSpeed, params.MinSpeed, params.IsRevert,
			params.TargetBoneName, params.IsBindTarget, params.TargetOffset, params.IgnoreY)
	end
end

function FrameEventComponent:EnableAnimMove(params)
	if self.entity.moveComponent and self.entity.moveComponent.config.MoveType == FightEnum.MoveType.AnimatorMoveData then
		self.entity.moveComponent.moveComponent.enabled = params.Enable
	end
end

function FrameEventComponent:EnableAnimMoveWithAxis(params)
	if not self.entity.moveComponent or self.entity.moveComponent.config.MoveType ~= FightEnum.MoveType.AnimatorMoveData then
		return
	end

	self.entity.moveComponent.moveComponent:SetXZMoveEnable(params.XZEnable)
	self.entity.moveComponent.moveComponent:SetYAxisMoveEnable(params.YEnable)
end

function FrameEventComponent:PreciseTargetRotate(params)
	local durationFrame = params.VDurationMoveFrame
	local maxSpeed = params.MaxSpeed
	local minSpeed = params.MinSpeed
	local isFullRotate = params.IsFullRotate

	self.skillComponent:DoPreciseTargetRotate(durationFrame, maxSpeed, minSpeed, isFullRotate)
end

function FrameEventComponent:EarlyWarning(params)
	local targetId = self.skillComponent.target and self.skillComponent.target.instanceId or nil
	if targetId then
		self.fight.entityManager:CallBehaviorFun("Warning", self.entity.instanceId, targetId, params.SignId)
		if params.DurationFrame > 0 then
			self.skillComponent:DoWarningEndEvent(params.SignId, params.DurationFrame, targetId)
		end
	end
end

function FrameEventComponent:CameraFixeds(params)
	params.EntityId = self.entity.entityId
	local instanceId = self.fight.clientFight.cameraManager:CreatFixed(params)
	if params.IsBingSkill then
		self.skillComponent:LifeBindCameraFixed(instanceId)
	end
end

function FrameEventComponent:EnableCollision(params)
	if not self.entity.collistionComponent then
		return
	end

	for partName, enable in pairs(params.CollisionSetting) do
		local part = self.entity.collistionComponent:GetPart(partName)
		if part then
			part:SetPartEnable(enable)
		end
	end
end

function FrameEventComponent:ActiveParry(params)
	self.entity:AddSignState("OnParry",params.Frame, false)
	if params.IsBingSkill then
		self.skillComponent:LifeBindEntitySign("OnParry")
	end
end

function FrameEventComponent:Suicide(params)
	local instanceId = self.entity.instanceId
	BehaviorFunctions.RemoveEntity(instanceId)
end

function FrameEventComponent:HideFightPanel(params)
	self.skillComponent:SetFightUIVisible(params.ShowFightUI, params.BindSkill, params.Frame, params.IsHighestPriority)
end

function FrameEventComponent:CameraPosReduction(params)
	self.fight.clientFight.cameraManager:CameraPosReduction(params)
end

function FrameEventComponent:PlayWeaponAnimation(params)
	if self.entity.clientEntity.weaponComponent then
		self.entity.clientEntity.weaponComponent:PlayWeaponAnimation(params.WeaponIndex,params.AnimationName,params.StartAnimationFrame or 0)
	end
end

function FrameEventComponent:ShieldTimeAndCameraEffect(params)
	local isShieldShake = params.ShieldShake
	local shakeMgr = self.fight.clientFight.cameraManager.cameraShakeManager
	-- 屏蔽震屏
	if isShieldShake then
		local shakeData = {
			durationFrame = params.ShieldShakeParams.DurationFrame,
			bindSkill = params.ShieldShakeParams.BindSkill,
			shieldShakeType = params.ShieldShakeType,
		}
		shakeMgr:AddShieldShakeData(shakeData, self.entity)
	end

	-- 屏蔽顿帧
	local isShieldPauseFrame = params.ShieldPauseFrame
	if isShieldPauseFrame then
		local pauseFrameData = {
			durationFrame = params.ShieldPauseFrameParams.DurationFrame,
			bindSkill = params.ShieldPauseFrameParams.BindSkill,
			shieldPauseFrameType = params.ShieldPauseFrameType,
		}

		self.entity.timeComponent:AddShieldPauseFrame(pauseFrameData)
		self.fight.entityManager.commonTimeScaleManager:AddShieldPauseFrame(pauseFrameData, self.entity)
	end
end

function FrameEventComponent:CheckInsID()
	local npcTag = self.entity.tagComponent.npcTag
	if npcTag ~= FightEnum.EntityNpcTag.Player then
		return true
	end

	local curInsId = BehaviorFunctions.GetCtrlEntity()
	local selfInsId = self.entity.instanceId
	if curInsId ~= selfInsId then return end
	return true
end

function FrameEventComponent:CamerFOVChange(params)
	if not self:CheckInsID() then return end
	self.fight.clientFight.cameraManager:AddCameraFovChangeData(params)
end

function FrameEventComponent:BreakCamerFOVChange(params)
	if not self:CheckInsID() then return end
	self.fight.clientFight.cameraManager:AddBreakFovChangeData(params)
end

function FrameEventComponent:MotionBlur(params)
	self.skillComponent:MotionBlur(params)
end

function FrameEventComponent:HideAllEntity(params)
	self.skillComponent:HideAllEntity(params)
end

-- TODO 后续改到ClientEffect里面去
function FrameEventComponent:AddScreenEffect(params)
	local callBackFunc = function(go)
		self.skillComponent:AddScreenEffect(params, go)
	end

	local effectGo = self.fight.clientFight.assetsPool:Get(params.path, false, true)
	if effectGo then
		callBackFunc(effectGo)
	else
		UIEffectLoader.New(params.path, nil, callBackFunc)
	end
end

function FrameEventComponent:SetAnimatorSync(params)
	
end

function FrameEventComponent:OnSetLockTarget(target, uiLockTarget)
	self.haveTarget = (target ~= nil)
end

function FrameEventComponent:OnCache()
	self.fight.objectPool:Cache(FrameEventComponent,self)

	EventMgr.Instance:RemoveListener(EventName.SetLockTarget, self:ToFunc("OnSetLockTarget"))
end

function FrameEventComponent:__cache()
	self.frameEventConfig = nil
end

function FrameEventComponent:__delete()
end