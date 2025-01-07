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
}

function FrameEventComponent:__init()
end

function FrameEventComponent:Init(fight,skillComponent)
	self.fight = fight
	self.skillComponent = skillComponent
	self.entity = self.skillComponent.entity
end

function FrameEventComponent:SetFrameEventConfig(frameEventConfig)
	self.frameEventConfig = frameEventConfig
end

function FrameEventComponent:DoFrameEvent(frame, skillLev)
	local frameEventList = self.frameEventConfig.FrameEvent[frame]
	if not frameEventList then
		return
	end

	for k, v in pairs(frameEventList) do
		self:DoEvent(v, skillLev,frame)
	end
end

function FrameEventComponent:DoEvent(params, skillLev,frame)
	if self:CheckEnableEvent(params) then
	    local func = FrameEventFuns[params.EventType]
		UnityUtils.BeginSample("DoEvent_"..func)
	    --assert(func, "error frameEvent func: " .. params.EventType)
	    self[func](self, params, skillLev)
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

function FrameEventComponent:DoCreateEntity(params,skillLev)
	local entity = self.fight.entityManager:CreateEntity(params.EntityId, self.entity) 

	if entity.attackComponent then
		entity.attackComponent:SetDefaultAttackLevel(skillLev)
	end

	local setBornOffset = true
	if entity.moveComponent and entity.moveComponent:IsBindMoveType() then
		setBornOffset = false
	end
	
	if entity.moveComponent then
		local target = self.skillComponent.target
		if not target and self.entity.owner then
			target = self.entity.owner.skillComponent.target
		end
		
		if target then
			if entity.moveComponent.moveComponent.SetTarget then
				entity.moveComponent.moveComponent:SetTarget(target)
			end
		elseif entity.moveComponent.config.MoveType == FightEnum.MoveType.Track then
			local targetPosition = self.skillComponent.targetPosition
			if not targetPosition and self.entity.owner then
				targetPosition = self.entity.owner.skillComponent.targetPosition
			end
			
			if targetPosition then
				entity.moveComponent.moveComponent:SetTrackPosition(targetPosition.x, targetPosition.y, targetPosition.z)
			end
		end
	end

	if not entity.clientEntity.clientEffectComponent and setBornOffset and 
		(params.BornOffsetX or params.BornOffsetY or params.BornOffsetZ) then
		local position 
		local bornOffset = Vec3.New(params.BornOffsetX or 0, params.BornOffsetY or 0, params.BornOffsetZ or 0)
		
		if params.CreateEntityType and params.CreateEntityType == 2 then
			position = self.skillComponent.targetPosition
			if params.IsBindTargetLogicPos then
				local target = self.skillComponent.target
				if target then
					position = target.transformComponent:GetPosition()
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
				local transform = self.entity.clientEntity.clientTransformComponent:GetTransform(params.BindTransform)
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
	end

	if entity.rotateComponent then
		if params.LookatTarget and params.LookAngleRange and params.LookAngleRange > 0 then
			local targetOffsetY = params.TargetOffsetY and params.TargetOffsetY or 0
			local targetPosition = self.skillComponent.targetPosition
			if self.skillComponent.target and self.skillComponent.target.partComponent then
				targetPosition = self.skillComponent.target.partComponent:GetPart(self.skillComponent.targetPart).lockTransform.position
			end
			local entityRotation = self.entity.clientEntity.clientTransformComponent.transform.rotation
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
			local eulerAngles = self.entity.clientEntity.clientTransformComponent.transform.rotation.eulerAngles
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
	end

	if entity.campComponent then
		local camp = self.entity.campComponent.camp
		entity.campComponent:SetCamp(camp)
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

	self.fight.entityManager:CallBehaviorFun("KeyFrameAddEntity", entity.instanceId, entity.sInstanceId)
end

function FrameEventComponent:DoPlayAnimation(params)
	self.entity.animatorComponent:PlayAnimation(params.Name,params.StartFrame)
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
		--if self.entity.owner.instanceId ~= self.fight.playerManager:GetPlayer():GetCtrlEntity() then
			--return
		--end
		if params.CameraShake then
			for k, v in pairs(params.CameraShake) do
				self.fight.clientFight.cameraManager.cameraShakeManager:Shake(v.ShakeType,
					v.StartAmplitude,v.StartFrequency,v.TargetAmplitude,v.TargetFrequency,
					v.AmplitudeChangeTime,v.FrequencyChangeTime,v.DurationTime,v.Sign,v.DistanceDampingId,v.StartOffset,v.Random)
			end
		else
			-- 旧的方式
			self.fight.clientFight.cameraManager.cameraShakeManager:Shake(params.ShakeType,
				params.StartAmplitude,params.StartFrequency,params.TargetAmplitude,params.TargetFrequency,
				params.AmplitudeChangeTime,params.FrequencyChangeTime,params.DurationTime,params.Sign,params.DistanceDampingId,params.StartOffset,params.Random)
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
		params.InputSpeed,params.MinDistance,params.IgnoreYAxis,params.SkillMoveDone,customDir)
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

function FrameEventComponent:AddBuff(params, skillLev)
	for i = 1, params.Count do
		if params.AddType == 1 then
			local buff = self.entity.buffComponent:AddBuff(self.entity,params.BuffId, skillLev or 1)
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

function FrameEventComponent:DoMagic(params, skillLev)
	for i = 1, params.Count do
		local magic = MagicConfig.GetMagic(params.MagicId, self.entity.entityId)
		local buff = MagicConfig.GetBuff(params.MagicId, self.entity.entityId)
		if magic then
			self.fight.magicManager:DoMagic(magic, skillLev, self.entity,self.entity,false)
		elseif buff and self.entity.buffComponent then
			local buff = self.entity.buffComponent:AddBuff(self.entity, params.MagicId, 1)
			if buff and params.LifeBindBuff then
				self.skillComponent:LifeBindBuff(buff)
			end
		end
	end
end

function FrameEventComponent:EntitySign(params)
	if params.Type == 1 then
		self.entity.stateComponent:AddSignState(params.Sign,params.LastTime,params.IgnoreTimeScale)
	elseif params.Type == 2 then
		self.entity.stateComponent:RemoveSignState(params.Sign)
	end
end

function FrameEventComponent:VerticalSpeed(params)
	if not self.entity.moveComponent.isAloft then
		return 
	end 
	
	local yMoveComponent = self.entity.moveComponent.yMoveComponent
	local extraSpeed = params.BaseSpeed and params.BaseSpeed or 0
	local yMoveConfig = {
		speedY = params.ResetSpeed and extraSpeed or yMoveComponent.params.speedY + extraSpeed,
		forceUseGravity = params.UseGravity,
		accelerationY = params.AccelerationY and params.AccelerationY or 0,
		duration = params.Duration,
		maxFallSpeed = params.MaxFallSpeed,
		useGravity = params.UseGravity,
	}

	yMoveComponent:AddForceParam(yMoveConfig, true)
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
	local gameObject = self.entity.clientEntity.clientTransformComponent:GetGameObject()
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
		hDuration,vDuration,params.IgnoreY,params.MaxSpeed,params.MinSpeed,params.BoneName)
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

	self.skillComponent:DoPreciseTargetRotate(durationFrame, maxSpeed, minSpeed)
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

function FrameEventComponent:OnCache()
	self.fight.objectPool:Cache(FrameEventComponent,self)
end

function FrameEventComponent:__cache()
	self.frameEventConfig = nil
end

function FrameEventComponent:__delete()
end