---@class CameraManager
CameraManager = BaseClass("CameraManager",FSM)

local CameraState = FightEnum.CameraState

function CameraManager:__init(clientFight)
	CameraManager.Instance = self
	self.clientFight = clientFight
	self.cameraRoot = GameObject("Camera")
	self.cameraRoot.transform:SetParent(self.clientFight.fightRoot.transform)
	UnityUtils.SetPosition(self.cameraRoot.transform,0, 0, 0)
	self.targetDirection = Vector3(0, 0, 0)
	self.cameraShakeManager = CameraShakeManager.New(self)
	self.cameraOffsetManager = CameraOffsetManager.New(self)
	self.cameraFixedManager = CameraFixedManager.New(self)
	self.targetGroup = TargetGroup.New(clientFight)
	self.screenEntityEffect = {}
	self.screenEntityEffectRoot = {}
	self.cameras = {}
	self.cameraTransformPos = Vec3.New(0,0,0)
	self.cameraTransformForward = Vec3.New(0,0,0)
end

function CameraManager:SetCameraNoise(transform)
	--CinemachineInterface.SetCinemachineNoiseExtend(transform,self.commonNoise)
end

function CameraManager:StartFight()
	local path = Config.CameraConfig.DefaultCamera
	self.mainCamera = self.clientFight.assetsPool:Get(Config.CameraConfig.ManinCameraPrefab)
	self.mainCameraComponent = self.mainCamera:GetComponent(Camera)
	self.cinemachineBrain = self.mainCamera.transform:GetComponent(Cinemachine.CinemachineBrain)
	self.cameraTransform = self.mainCamera.transform
	self.cameraTransform:SetParent(self.cameraRoot.transform)
	self.effectRoot = self.mainCamera.transform:Find("EffectRoot")
	self:MergeCustomBlends()
	
	self.camera = self.clientFight.assetsPool:Get(path)
	self.camera.transform:SetParent(self.cameraRoot.transform)
	UnityUtils.SetPosition(self.camera.transform,0, 0, 0)
	--local cameraData = ctx.MainCamera:GetUniversalAdditionalCameraData()
	--ctx.MainCamera.gameObject:SetActive(false)

	local camera = self.mainCamera:GetComponent(Camera)
	if not camera then
		LogError("self.mainCamera找不到 Camera")
	end
	--Log(ctx.MainCamera.name)
	if ctx.MainCamera.enabled then
		--Log(ctx.MainCamera.name.." true")
		
		
	else
		ctx.MainCamera.enabled = true
		--Log(ctx.MainCamera.name.." false")
	end
	local UniversalAdditionalCameraData = ctx.MainCamera:GetComponent(Rendering.Universal.UniversalAdditionalCameraData)
	local uiCamera = UniversalAdditionalCameraData.cameraStack[0]
	ctx.MainCamera.gameObject:SetActive(false)

	local cameraData = self.mainCamera:GetComponent(Rendering.Universal.UniversalAdditionalCameraData)
	cameraData.cameraStack:Add(uiCamera)
	Cinemachine.CinemachineCore.GetInputAxis = self.clientFight.inputManager.CameraInput
	self:InitStates()
end

function CameraManager:MergeCustomBlends()
	if self.clientFight.clientMap.mapCinemachineBrain and self.clientFight.clientMap.mapCinemachineBrain.m_CustomBlends then
		CustomUnityUtils.MergeCustomBlend(self.cinemachineBrain,self.clientFight.clientMap.mapCinemachineBrain)
	end
end


function CameraManager:InitStates()
	self:AddState(CameraState.Operating, OperatingCamera.New(self))
	self:AddState(CameraState.WeakLocking, WeakLockingCamera.New(self))
	self:AddState(CameraState.ForceLocking, ForceLockingCamera.New(self))
	self:AddState(CameraState.Aiming, AimingCamera.New(self))
	self:AddState(CameraState.UI, UICamera.New(self))
	self:AddState(CameraState.Dialog, DialogCamera.New(self))
	self:AddState(CameraState.OpenDoor, OpenDoorCamera.New(self))
	self:AddState(CameraState.NpcShop, NpcShopCamera.New(self))
	self:AddState(CameraState.Mailing, MailingCamera.New(self))
	self:AddState(CameraState.CatchPartner, CatchPartnerCamera.New(self))
	self:AddState(CameraState.Drone, DroneCamera.New(self))
	self:AddState(CameraState.Level, LevelCamera.New(self))
	self:AddState(CameraState.Hacking, HackingCamera.New(self))
	self:AddState(CameraState.Monitor, MonitorCamera.New(self))

	self:SwitchState(CameraState.Operating)
	self.targetState = CameraState.Operating
	self.lastState = CameraState.Operating
	--local ditherCamera = self.mainCamera:GetComponent(DitherCameraTrigger)
	--ditherCamera:SetLookAt(self.lookAtTarget)
	--self.cameraBlend = CameraBlend.New(self)
	--self:SetMixing(self.cameraBlend.cameraParent)
end

function CameraManager:Update(lerpTime)
	self.statesMachine:Update(lerpTime)
	self.cameraShakeManager:Update(lerpTime)
	self.cameraOffsetManager:Update(lerpTime)
	self.cameraFixedManager:Update(lerpTime)
	if self.cinemachineBrain.IsBlending and (BehaviorFunctions.CheckKeyPress(FightEnum.KeyEvent.ScreenPress) or BehaviorFunctions.CheckKeyPress(FightEnum.KeyEvent.ScreenMove)) then
		--self.cinemachineBrain.ActiveBlend.TimeInBlend = self.cinemachineBrain.ActiveBlend.Duration
		self.cinemachineBrain.ActiveBlend = nil
		--if not self.clicked then
			--if(BehaviorFunctions.CheckKeyPress(FightEnum.KeyEvent.ScreenPress) or BehaviorFunctions.CheckKeyPress(FightEnum.KeyEvent.ScreenMove)) then
				--self.clicked = true
			--end
		--end
		----self.cinemachineBrain.ActiveBlend.TimeInBlend = self.cinemachineBrain.ActiveBlend.Duration
		--if self.clicked then
			--local camB = self.cinemachineBrain.ActiveBlend.CamB.VirtualCameraGameObject
			--self.statesMachine.cinemachineCamera:ForceCameraPosition(camB.transform.position,camB.transform.rotation)
		--end
	end
	--self:UpdateNoiseTimeScale()
	--self.states[CameraState.WeakLocking]:UpdateTarget()
	--if self.cinemachineBrain.IsBlending then
	--else
		--if self.curState ~= self.targetState then
			--self:SwitchState(self.targetState)
			--self.targetState = self.curState
		--end
	--end
	--self:LockEulerZ()
	--if self.cameraBlend.blending then
		--self.cameraBlend:Update()
	--end

	self.cameraTransformPos:SetA(self.cameraTransform.position)
	self.cameraTransformForward:SetA(self.cameraTransform.rotation * Vector3.forward)
end

function CameraManager:StopBlend()
	self.cinemachineBrain.ActiveBlend = nil
end

function CameraManager:SetCameraPosition(x,y,z)
	local pos = Vector3(x,y,z)
	UnityUtils.SetPosition(self.cameraTransform,x,y,z)
	self.statesMachine.cinemachineCamera:ForceCameraPosition(pos,self.mainCamera.transform.rotation)
	self.statesMachine.cinemachineCamera.PreviousStateIsValid = false
end

function CameraManager:AfterUpdate()
	if self.statesMachine.AfterUpdate then
		self.statesMachine:AfterUpdate()
	end
	if self.curState == CameraState.Operating and self.curState ~= CameraState.WeakLocking then
		self.states[CameraState.WeakLocking]:AfterUpdate(true)
	end
	
end

function CameraManager:LockEulerZ()
	if self.cinemachineBrain.IsBlending then
		--self.cinemachineBrain.m_BlendUpdateMethod = 0--CinemachineBrain.BrainUpdateMethod.FixedUpdate;
		--local eulerAngles = self.mainCamera.transform.rotation.eulerAngles
		--eulerAngles.z = 0
		--local rotation = self.mainCamera.transform.rotation
		--rotation.eulerAngles = eulerAngles
		--self.mainCamera.transform.rotation = rotation
	else
		----if self.curState ~= self.targetState then
			----self:SwitchState(self.targetState)
			----self.targetState = self.curState
		----end
		--self.cinemachineBrain.m_BlendUpdateMethod = 1--CinemachineBrain.BrainUpdateMethod.LateUpdate;
	end
end

function CameraManager:SetLockTarget(target)
	self.statesMachine:SetLockTarget(target)
end

function CameraManager:SetMainTarget(target)
	--Log("SetMainTarget")
	self.mainTarget = target.transform:Find("CameraTarget")
	self.states[CameraState.Operating]:SetMainTarget(self.mainTarget)
	self.states[CameraState.WeakLocking]:SetMainTarget(self.mainTarget)
	self.states[CameraState.ForceLocking]:SetMainTarget(self.mainTarget)
	self.states[CameraState.UI]:SetMainTarget(self.mainTarget)
	self.states[CameraState.Drone]:SetMainTarget(self.mainTarget)

	CustomUnityUtils.SetCameraVolumeTrigger(target, FightEnum.CameraTriggerLayer)
	self:SetSoftZone(true)

	if self.timer then 
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil 
    end

	local callback = function()
		self:SetSoftZone(false)
	end
	self.timer = LuaTimerManager.Instance:AddTimer(1, 1, callback)
end

function CameraManager:SetCameraLookAt(entity,boneName)
	local clientTransformComponent = entity.clientEntity.clientTransformComponent
	local bone = boneName and clientTransformComponent:GetTransform(boneName) or nil
	if not bone then
		bone = clientTransformComponent.transform:Find("CameraTarget")
	end
	self.states[CameraState.Operating]:SetMainTarget(bone)
	self.states[CameraState.WeakLocking]:SetMainTarget(bone)
	self.states[CameraState.ForceLocking]:SetMainTarget(bone)
end

function CameraManager:SetCameraFollow(entity,boneName)
	local clientTransformComponent = entity.clientEntity.clientTransformComponent
	local bone = boneName and clientTransformComponent:GetTransform(boneName) or nil
	if not bone then
		bone = clientTransformComponent.transform:Find("CameraTarget")
	end
	self.states[CameraState.Operating]:SetMainTarget(bone)
	self.states[CameraState.WeakLocking]:SetMainTarget(bone)
	self.states[CameraState.ForceLocking]:SetMainTarget(bone)
end

function CameraManager:SetMixing(mixTransform)
	--Log("SetMixing")
	self.states[CameraState.Operating]:SetMixing(mixTransform)
	self.states[CameraState.WeakLocking]:SetMixing(mixTransform)
	self.states[CameraState.Aiming]:SetMixing(mixTransform)
	--self.states[CameraState.ForceLocking]:SetMixing(self.mainTarget)
end

function CameraManager:SetTarget(targetEntity,clientTransformComponent, transformName)
	local target = clientTransformComponent.transform
	if self.target == target then return end

	local lookatTarget
	if transformName then
		lookatTarget = clientTransformComponent:GetTransform(transformName)
		if not lookatTarget then
			lookatTarget = target.transform:Find("CameraTarget")
		end
	else
		lookatTarget = target.transform:Find("CameraTarget")
	end
		
	local hitCaseNode = transformName or "HitCase"	
	local hitCase = clientTransformComponent:GetTransform(hitCaseNode)
	EventMgr.Instance:Fire(EventName.SetLockTarget, hitCase or lookatTarget)
	--Log("SetTarget")
	self.states[CameraState.WeakLocking]:SetTarget(lookatTarget,targetEntity)
	self.states[CameraState.ForceLocking]:SetTarget(lookatTarget,targetEntity)
	-- self.states[CameraState.Aiming]:SetTarget(lookatTarget)

	--self:SwitchState(CameraState.WeakLocking)
	--self:SetCameraState(CameraState.WeakLocking)
	
end

function CameraManager:ClearTarget()
	--Log("ClearTarget")
	EventMgr.Instance:Fire(EventName.SetLockTarget, nil)
	self:SetCameraState(CameraState.Operating)
	self.states[CameraState.WeakLocking]:ClearTarget()
	--self.states[CameraState.ForceLocking]:ClearTarget()
end

function CameraManager:SetCameraState(state)
	--if state == CameraState.ForceLocking then
		--state = CameraState.WeakLocking
	--end

	-- 关卡的是自动切的 由于可能不存在相机 不允许手动切换
	if self.curState == state then
		return
	end
	--self.targetState = state

	----瞄准状态秒切
	--if state ~= CameraState.Aiming and self.lastState ~= CameraState.Aiming then
		--if self.cinemachineBrain.IsBlending then
			--if self.cinemachineBrain.ActiveBlend.BlendWeight < 0.8 then
				--return
			--end
		--end
	--end
	----self.cameraBlend:SetBlendInfo(self.lastState,state,2)
	--self.lastState = state
	--if self.cinemachineBrain.IsBlending then
		--Log("SetCameraState IsBlending "..self.clientFight.fight.fightFrame)
		--self.cinemachineBrain.ActiveBlend.TimeInBlend = self.cinemachineBrain.ActiveBlend.Duration
		--self.cinemachineBrain:ManualUpdate()
	--end


	if state ==  CameraState.Operating then
		EventMgr.Instance:Fire(EventName.SetLockTarget, nil)
	end
	
	if self.curState == CameraState.Operating and state == CameraState.WeakLocking then
		self.states[CameraState.Operating]:SetBlendHint(2)
	else
		self.states[CameraState.Operating]:SetBlendHint(3)
	end

	self:SwitchState(state)

	if self.states[state].SetCameraMgrNoise then
		self.states[state]:SetCameraMgrNoise()
	end
end

function CameraManager:SetCameraParams(state,id,coverDefult)
	self.states[state]:SetCameraParams(id,coverDefult)
end

function CameraManager:SetLevelCamera(instanceId)
	return self.states[CameraState.Level]:SetCamera(instanceId)
end

function CameraManager:SetLevelCameraParamTable(params)
	self.states[CameraState.Level]:SetCameraParams(params)
end

function CameraManager:GetLevelCameraParamTable()
	return self.states[CameraState.Level]:GetCameraParam()
end

function CameraManager:FixHorizontalAxis(offset)
	self.states[CameraState.Operating]:FixHorizontalAxis(offset)
end
 
function CameraManager:FixVerticalAxis(offset)
	self.states[CameraState.Operating]:FixVerticalAxis(offset)
end

function CameraManager:FixVerticalAxisByTime(offset,time)
	self.states[CameraState.Operating]:FixVerticalAxisByTime(offset,time)
end

function CameraManager:ResetTimeAutoFixTime(isPause)
	if self.states[CameraState.Operating] then
		self.states[CameraState.Operating]:ResetTimeAutoFixTime(isPause)
	end
end

function CameraManager:GetCameraState()
	return self.curState
end

function CameraManager:IsLockingTarget()
	return self.camerState ~= CameraState.Operating
end


function CameraManager:GetMove(x,y)
	--TODO 优化
	self.targetDirection.x = x
	self.targetDirection.y = 0
	self.targetDirection.z = y
	local y = self.mainCamera.transform.rotation.eulerAngles.y
	self.targetDirection = Quaternion.Euler(0, y, 0) * self.targetDirection
	return self.targetDirection.x,self.targetDirection.z
end

function CameraManager:SetNoise(type,amplitud,frequency,resetTime,startOffset,random)
	local timeScale = self:GetMainRoleTimeScale()
	--timeScale = timeScale == 0 and 0.001 or timeScale
	
	self.noise:SetNoise(type - 1,amplitud,frequency,resetTime,startOffset,random)
	--self.states[CameraState.Aiming]:SetNoise(type - 1,amplitud,frequency,resetTime)
	--self.states[CameraState.Operating]:SetNoise(type - 1,amplitud,frequency,resetTime)
	--self.states[CameraState.WeakLocking]:SetNoise(type - 1,amplitud,frequency,resetTime)
	--self.states[CameraState.ForceLocking]:SetNoise(type - 1,amplitud,frequency,resetTime)
	--self.lockingNoise:SetNoise(type - 1,amplitud,frequency,resetTime)
	--self.operatingNoise:SetNoise(type - 1,amplitud,frequency,resetTime)
	--if type > 7 then return end
	--self.commonNoise:SetNoise(type - 1,amplitud,frequency,resetTime)
end

function CameraManager:UpdateNoiseTimeScale(timeScale)
	--local timeScale = self:GetMainRoleTimeScale()
	--Log("timeScale "..timeScale)
	self.noise:SetTimeScale(timeScale)
end

function CameraManager:AddScreenEffect(instanceId, path)
	if not self.screenEntityEffect[instanceId] then
		local entityEffectRoot = GameObject("EntityEffectRoot"..instanceId)
		entityEffectRoot.transform:SetParent(self.effectRoot.transform)
		entityEffectRoot.transform:ResetAttr()
		self.screenEntityEffect[instanceId] = {}
		self.screenEntityEffectRoot[instanceId] = entityEffectRoot
	end

 	if self.screenEntityEffect[instanceId][path] then
		return
	end

	local gameObject = self.clientFight.assetsPool:Get(path)
	gameObject:SetActive(true)
    local transform = gameObject.transform
	transform:SetParent(self.screenEntityEffectRoot[instanceId].transform)
	transform:ResetAttr()
	self.screenEntityEffect[instanceId][path] = gameObject
end

function CameraManager:RemoveScreenEffect(instanceId, path)
	if not self.screenEntityEffect[instanceId] then
		return
	end

	local gameObject = self.screenEntityEffect[instanceId][path]
	if gameObject then
		self.clientFight.assetsPool:Cache(path, gameObject)
		self.screenEntityEffect[instanceId][path] = nil
	end
end

function CameraManager:SetEntityEffectVisible(instanceId, visible)
	if not self.screenEntityEffectRoot[instanceId] then
		return
	end

	self.screenEntityEffectRoot[instanceId]:SetActive(visible)
end

function CameraManager:GetCameraRotaion()
	return self.mainCamera.transform.rotation
end

function CameraManager:GetMainCameraTransform( )
	return self.mainCamera.transform
end

function CameraManager:SetFOV(fov, state)

	local machine = state and self.states[state] or self.statesMachine
	if machine.SetFOV then
		machine:SetFOV(fov)
	end
end

function CameraManager:GetFOV()
	if self.statesMachine and self.statesMachine.GetFOV then
		return self.statesMachine:GetFOV()
	end
end

function CameraManager:MouseMove(x, y)
	if self.curState == CameraState.Aiming then
		self.statesMachine:MouseMove(x, y)
	end
end

function CameraManager:SetDialogTargets(target1, target2)
	self.states[CameraState.Dialog]:SetTargetList(target1, target2)
end

function CameraManager:SetInheritPosition(state, isInheritPosition)
	if state and self.states[state] and self.states[state].SetInheritPosition then
		self.states[state]:SetInheritPosition(isInheritPosition)
	end
end

function CameraManager:CreatOffset(params)
	local instanceId = self.cameraOffsetManager:Create(params)
	return instanceId
end

function CameraManager:RemoveOffset(instanceId)
	self.cameraOffsetManager:Remove(instanceId)
end

function CameraManager:CreatFixed(params)
	local instanceId = self.cameraFixedManager:Create(params)
	return instanceId
end

function CameraManager:RemoveFixed(instanceId)
	self.cameraFixedManager:Remove(instanceId)
end

function CameraManager:SetCameraRotatePause(pause)
	self.pauseCameraRotate = pause
end

function CameraManager:CheckPauseCameraRotate(count)
	return self.pauseCameraRotate
end

--noise 前面是做震屏用的，后面是做相机偏移用的，
function CameraManager:OffsetPositionXByCamera(value)
	local type = FightEnum.CameraShakeType.PositionX + FightEnum.CameraShakeType.Lenght - 3
	self.noise:AddNoise(type,value,0,false)
end
function CameraManager:OffsetPositionYByCamera(value)
	local type = FightEnum.CameraShakeType.PositionY + FightEnum.CameraShakeType.Lenght - 3
	self.noise:AddNoise(type,value,0,false)
end
function CameraManager:OffsetPositionZByCamera(value)
	local type = FightEnum.CameraShakeType.PositionZ + FightEnum.CameraShakeType.Lenght - 3
	local offsetX = self.noise:AddNoise(type,value,0,false)
	self.states[CameraState.WeakLocking]:SetOffsetZ(offsetX)
end
function CameraManager:OffsetRotationXByCamera(value)
	local type = FightEnum.CameraShakeType.RotationX + FightEnum.CameraShakeType.Lenght - 3
	self.noise:AddNoise(type,value,0,false)
end
function CameraManager:OffsetRotationYByCamera(value)
	local type = FightEnum.CameraShakeType.RotationY + FightEnum.CameraShakeType.Lenght - 3
	self.noise:AddNoise(type,value,0,false)
end
function CameraManager:OffsetRotationZByCamera(value)
	local type = FightEnum.CameraShakeType.RotationZ + FightEnum.CameraShakeType.Lenght - 3
	self.noise:AddNoise(type,value,0,false)
end

function CameraManager:NoiseEffectEnd(type, noise)
	local selectNoise = noise and noise or self.noise
	selectNoise:SetNoise(type,0,0,true)
end

local targetPositionOffset = Vector3(0,0,0)
function CameraManager:OffsetPositionXByTarget(value)
	targetPositionOffset.x = targetPositionOffset.x + value
	self.statesMachine:UpdateTargetOffset(targetPositionOffset)
end
function CameraManager:OffsetPositionYByTarget(value)
	targetPositionOffset.y = targetPositionOffset.y + value
	self.statesMachine:UpdateTargetOffset(targetPositionOffset)
end
function CameraManager:OffsetPositionZByTarget(value)
	targetPositionOffset.z = targetPositionOffset.z + value
	self.statesMachine:UpdateTargetOffset(targetPositionOffset)
end

local targetRotationOffset = Vector3(0,0,0)
function CameraManager:OffsetRotationXByTarget(value)
	targetPositionOffset.x = targetPositionOffset.x + value
	self.statesMachine:UpdateTargetRotation(targetRotationOffset)
end
function CameraManager:OffsetRotationYByTarget(value)
	targetPositionOffset.y = targetPositionOffset.y + value
	self.statesMachine:UpdateTargetRotation(targetRotationOffset)
end
function CameraManager:OffsetRotationZByTarget(value)
	targetPositionOffset.z = targetPositionOffset.z + value
	self.statesMachine:UpdateTargetRotation(targetRotationOffset)
end

function CameraManager:FixedPositionXByCamera(value)
	local type = FightEnum.CameraShakeType.PositionX + FightEnum.CameraShakeType.Lenght - 3
	self.noise:SetNoise(type,value,0,false)
end
function CameraManager:FixedPositionYByCamera(value)
	local type = FightEnum.CameraShakeType.PositionY + FightEnum.CameraShakeType.Lenght - 3
	self.noise:SetNoise(type,value,0,false)
end
function CameraManager:FixedPositionZByCamera(value)
	local type = FightEnum.CameraShakeType.PositionZ + FightEnum.CameraShakeType.Lenght - 3
	local offsetX = self.noise:SetNoise(type,value,0,false)
	self.states[CameraState.WeakLocking]:SetOffsetZ(value)
end
function CameraManager:FixedRotationXByCamera(value)
	local type = FightEnum.CameraShakeType.RotationX + FightEnum.CameraShakeType.Lenght - 3
	self.noise:SetNoise(type,value,0,false)
end
function CameraManager:FixedRotationYByCamera(value)
	local type = FightEnum.CameraShakeType.RotationY + FightEnum.CameraShakeType.Lenght - 3
	self.noise:SetNoise(type,value,0,false)
end
function CameraManager:FixedRotationZByCamera(value)
	local type = FightEnum.CameraShakeType.RotationZ + FightEnum.CameraShakeType.Lenght - 3
	self.noise:SetNoise(type,value,0,false)
end

local targetPositionFixed = Vector3(0,0,0)
function CameraManager:FixedPositionXByTarget(value)
	targetPositionFixed.x = value
	self.statesMachine:UpdateTargetOffset(targetPositionFixed)
end
function CameraManager:FixedPositionYByTarget(value)
	targetPositionFixed.y = value
	self.statesMachine:FixedTargetOffset(targetPositionFixed)
end
function CameraManager:FixedPositionZByTarget(value)
	targetPositionFixed.z = value
	self.statesMachine:UpdateTargetOffset(targetPositionFixed)
end

local targetRotationFixed = Vector3(0,0,0)
function CameraManager:FixedRotationXByTarget(value)
	targetRotationFixed.x = value
	self.statesMachine:UpdateTargetRotation(targetRotationFixed)
end
function CameraManager:FixedRotationYByTarget(value)
	targetRotationFixed.y = value
	self.statesMachine:UpdateTargetRotation(targetRotationFixed)
end
function CameraManager:OffsetRotationZByTarget(value)
	targetRotationFixed.z = value
	self.statesMachine:UpdateTargetRotation(targetRotationFixed)
end

function CameraManager:GetMainRoleTimeScale()
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(ctrlEntity)
	return entity.timeComponent:GetTimeScale()
end

function CameraManager:GetMainRoleFrame()
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(ctrlEntity)
	return entity.timeComponent.frame
end

function CameraManager:SetSoftZone(unlimited)
	self.states[CameraState.Operating]:SetSoftZone(unlimited)
	self.states[CameraState.WeakLocking]:SetSoftZone(unlimited)
	self.states[CameraState.ForceLocking]:SetSoftZone(unlimited)
end

function CameraManager:SetBodyDamping(x,y,z)
	if x then
		if self.statesMachine.SetBodyDamping then
			self.statesMachine:SetBodyDamping(x,y,z)
		end
	else
		if self.statesMachine.SetDefaulBodyDamping then
			self.statesMachine:SetDefaulBodyDamping()
		end
	end
end

function CameraManager:ForceFix(curveId,time)
	if self.statesMachine.ForceFix then
		self.statesMachine:ForceFix(curveId,time)
	end
end

function CameraManager:StopAllCameraOffset()
	self.cameraOffsetManager:RealRemoveAll()
end

function CameraManager:Track(isStart)
	self.states[CameraState.Operating]:EnableCameraCollider(not isStart)
end

function CameraManager:SetCameraColliderDamping(damping)
	self.states[CameraState.Operating]:SetCameraColliderDamping(damping)
end
function CameraManager:SetCameraVerticalRange(min,max)
	self.states[CameraState.Operating]:SetCameraVerticalRange(min,max)
end
function CameraManager:SetCameraHorizontalRange(min,max)
	self.states[CameraState.Operating]:SetCameraVerticalRange(min,max)
end

function CameraManager:OnTransportCallback(x,y,z)
	self:SetCameraState(CameraState.Operating)
	local instanceId = BehaviorFunctions.GetCtrlEntity()
	BehaviorFunctions.SetMainTarget(instanceId)
	self:SetCameraPosition(x,y,z)
end

function CameraManager:__delete()
	if self.timer then 
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil 
    end
	
	ctx.MainCamera.gameObject:SetActive(true)

	if self.cameraShakeManager then
		self.cameraShakeManager:DeleteMe()
	end

	if self.screenEntityEffect then
		for _, entityEffectList in pairs(self.screenEntityEffect) do
			for k, v in pairs(entityEffectList) do
				self.clientFight.assetsPool:Cache(k, v)
			end
		end
		self.screenEntityEffect = nil
	end

	if self.screenEntityEffectRoot then
		for k, v in pairs(self.screenEntityEffectRoot) do
			GameObject.Destroy(v)
		end
		self.screenEntityEffectRoot = nil
	end
end
