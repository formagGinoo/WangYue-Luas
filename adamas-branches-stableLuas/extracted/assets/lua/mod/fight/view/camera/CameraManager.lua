---@class CameraManager
CameraManager = BaseClass("CameraManager",FSM)

local CameraState = FightEnum.CameraState
local defFovVal = 45

local CallFuncStates = {
	CameraState.Operating,
	CameraState.WeakLocking,
	CameraState.ForceLocking,
	CameraState.Fight,
	CameraState.PartnerContrlCamera,
	CameraState.PartnerConnectCamera,
	CameraState.Car,
}

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
	--self.lookAtTargetGroup = TargetGroup.New(clientFight)

	self.screenEntityEffect = {}
	self.screenEntityEffectRoot = {}
	self.cameras = {}
	self.cameraTransformPos = Vec3.New(0,0,0)
	self.cameraTransformForward = Vec3.New(0,0,0)

	-- 相机效果管理器
	self.cameraEffectMgr = CameraEffectManager.New(self)
	self.GlideCamera = GlideCamera.New(self)
end

function CameraManager:SetCameraNoise(transform)
	--CinemachineInterface.SetCinemachineNoiseExtend(transform,self.commonNoise)
end

function CameraManager:StartFight()
	local path = Config.CameraConfig.DefaultCamera
	self.mainCamera = self.clientFight.assetsPool:Get(Config.CameraConfig.ManinCameraPrefab)
	self.mainCameraTransform = self.mainCamera.transform
	self.mainCameraComponent = self.mainCamera:GetComponent(Camera)
	self.cinemachineBrain = self.mainCameraTransform:GetComponent(Cinemachine.CinemachineBrain)
	self.cameraTransform = self.mainCameraTransform
	self.cameraTransform:SetParent(self.cameraRoot.transform)
	self.effectRoot = self.mainCameraTransform:Find("EffectRoot")
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
	self:AddState(CameraState.Fight, FightCamera.New(self))

	self:AddState(CameraState.PartnerContrlCamera, PartnerContrlCamera.New(self))
	self:AddState(CameraState.PartnerConnectCamera, PartnerConnectCamera.New(self))

	self:AddState(CameraState.Aiming, AimingCamera.New(self))
	self:AddState(CameraState.UI, UICamera.New(self))
	self:AddState(CameraState.Dialog, DialogCamera.New(self))
	self:AddState(CameraState.Pause, PauseCamera.New(self))
	self:AddState(CameraState.OpenDoor, OpenDoorCamera.New(self))
	self:AddState(CameraState.NpcShop, NpcShopCamera.New(self))
	self:AddState(CameraState.Mailing, MailingCamera.New(self))
	self:AddState(CameraState.CatchPartner, CatchPartnerCamera.New(self))
	self:AddState(CameraState.Drone, DroneCamera.New(self))
	self:AddState(CameraState.Level, LevelCamera.New(self))
	self:AddState(CameraState.Hacking, HackingCamera.New(self))
	self:AddState(CameraState.Monitor, MonitorCamera.New(self))
	self:AddState(CameraState.Car, CarCamera.New(self))
	self:AddState(CameraState.Atomize, AtomizeCamera.New(self))
	self:AddState(CameraState.Photo, PhotoCamera.New(self))
	self:AddState(CameraState.Building, BuildingCamera.New(self))
	self:AddState(CameraState.TriPhoto, TriPhotoCamera.New(self))
	self:AddState(CameraState.StoryExplore, StoryExploreCamera.New(self))

	self:RecordCameraFovVal()
	self.curState = nil
	self.initState = true
	self:SwitchState(CameraState.Operating)
	self.targetState = CameraState.Operating
	self.lastState = CameraState.Operating
	--local ditherCamera = self.mainCamera:GetComponent(DitherCameraTrigger)
	--ditherCamera:SetLookAt(self.lookAtTarget)
	--self.cameraBlend = CameraBlend.New(self)
	--self:SetMixing(self.cameraBlend.cameraParent)
end

function CameraManager:RecordCameraFovVal()
	self.recordCameraFovVal = {}
	for _, state in pairs(FightEnum.CameraState) do
		local cameraClass = self.states[state]
		local cineCamera = cameraClass.cinemachineCamera
		if cineCamera then
			local lensSetting = cineCamera.m_Lens
			local curFovVal = lensSetting.FieldOfView
			local insId = cineCamera.gameObject:GetInstanceID()
			self.recordCameraFovVal[insId] = curFovVal
		end
	end
end

function CameraManager:EnableCameraComponentCamera()
	local curCamera = self.states[self.curState]
	curCamera:OnLeave()
	self.isStopUpdate = true
end

function CameraManager:DisableCameraComponent()
	local curCamera = self.states[self.curState]
	curCamera:OnEnter()
	local instanceId = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local eulerAngles = entity.clientTransformComponent.transform.rotation.eulerAngles
	self:SetCameraRotation(entity.transformComponent.rotation)
	self.isStopUpdate = false
end

function CameraManager:SetIgnoreStopBlendState(isIgnoreStopBlend)
	self.isIgnoreStopBlend = isIgnoreStopBlend
end

function CameraManager:CheckScreenOperation()
	if self.isIgnoreStopBlend then return end
	local screenMove = BehaviorFunctions.CheckKeyPress(FightEnum.KeyEvent.ScreenMove)
	local screenPress = BehaviorFunctions.CheckKeyPress(FightEnum.KeyEvent.ScreenPress)
	-- 屏幕按压同时鼠标没有隐藏
	if screenPress and not InputManager.Instance.disPlayMouse then
		return true
	end

	if screenMove then
		return true
	end

	return false
end

function CameraManager:InformCameraBlendState(isBlend)
	if isBlend then
		-- BehaviorFunctions.RemoveAllFollowTarget()
		BehaviorFunctions.RemoveAllLookAtTarget()
		local insId = BehaviorFunctions.GetCtrlEntity()
		-- BehaviorFunctions.AddFollowTarget(insId,"CameraTarget")
		BehaviorFunctions.AddLookAtTarget(insId,"CameraTarget")
	else
		self:RevertTarget()
	end

	Fight.Instance.entityManager:CallBehaviorFun("InformCameraBlendState", isBlend, self.lastState, self.curState)
end

function CameraManager:GetCameraBlendTime()
	local lastCamera = self.states[self.lastState]
	local newCamera = self.states[self.curState]
	if not lastCamera or not newCamera then return end

	local lastCameraTrans = lastCamera.camera
	local newCameraComp = newCamera.camera
	if not lastCameraTrans or not newCameraComp then return end

	local lastCameraName = lastCameraTrans.gameObject.name
	local newCameraName = newCameraComp.gameObject.name

	local blendTime = CustomUnityUtils.GetVCCameraBlendTime(CameraManager.Instance.cinemachineBrain, lastCameraName, newCameraName)
	if blendTime < 0 then
		blendTime = CustomUnityUtils.GetVCCameraBlendTime(CameraManager.Instance.cinemachineBrain, "**ANY CAMERA**", newCameraName)
	end

	if blendTime < 0 then
		blendTime = CustomUnityUtils.GetVCCameraBlendTime(CameraManager.Instance.cinemachineBrain, lastCameraName, "**ANY CAMERA**")
	end

	return blendTime
end

-- 战斗相机切换操作相机特殊处理过渡状态
function CameraManager:UpdataFightToOperatingBlend()
	if self.lastState == CameraState.Fight and self.curState == CameraState.Operating and self.cinemachineBrain.IsBlending then
		self.isFightToOperatingBlend = true
		return true
	end

	if self.isFightToOperatingBlend then
		self.isFightToOperatingBlend = false
		self:SetIgnoreStopBlendState(false)
	end
end

function CameraManager:Update(lerpTime)
	UnityUtils.BeginSample("statesMachine.Update")
	self.statesMachine:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("cameraShakeManager.Update")
	self.cameraShakeManager:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("cameraOffsetManager.Update")
	self.cameraOffsetManager:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("cameraFixedManager.Update")
	self.cameraFixedManager:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("cameraEffectMgr.Update")
	self.cameraEffectMgr:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("GlideCamera.Update")
	self.GlideCamera:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("PartnerContrlCameraUpdate.Update")
	self:PartnerContrlCameraUpdate()
	UnityUtils.EndSample()

	UnityUtils.BeginSample("UpdataFightToOperatingBlend.Update")
	self:UpdataFightToOperatingBlend()
	UnityUtils.EndSample()

	if self.cinemachineBrain.IsBlending then

		if self:CheckScreenOperation() and not self.isFightToOperatingBlend then
			self.cinemachineBrain.ActiveBlend = nil
		end

	end

	if self.isBlend and not self.cinemachineBrain.IsBlending then
		self:InformCameraBlendState(false)
		self.isBlend = false
	end

	self:UpdateFovChangeVal(self.FOVChangeData, lerpTime)
	if self.BreakCameraFovData and self.BreakCameraFovData.isBreakFov then
		self:UpdateFovChangeVal(self.BreakCameraFovData, lerpTime)
	end
	UnityUtils.BeginSample("CheckRoleGlide.Update")
	self:CheckRoleGlide()
	UnityUtils.EndSample()
	self.cameraTransformPos:SetA(self.cameraTransform.position)
	self.cameraTransformForward:SetA(self.cameraTransform.rotation * Vector3.forward)
end

function CameraManager:PartnerContrlCameraUpdate()
	if self.states[CameraState.PartnerContrlCamera]:IsUpdate() then
		self.states[CameraState.PartnerContrlCamera]:Update()
	end

	if self.states[CameraState.PartnerConnectCamera]:IsUpdate() then
		self.states[CameraState.PartnerConnectCamera]:Update()
	end
end

function CameraManager:StopBlend()
	self.cinemachineBrain.ActiveBlend = nil
end

function CameraManager:IsInheritPosSetCameraState(state, selectState, IsInheritPos)
	self:SetCameraState(state)
	LuaTimerManager.Instance:AddTimerByNextFrame(1,0,function ()
		self:SetInheritPosition(selectState, IsInheritPos)
	end)
end

function CameraManager:SetCameraPosition(x,y,z)
	local pos = Vector3(x,y,z)
	UnityUtils.SetPosition(self.cameraTransform,x,y,z)
	self.statesMachine.cinemachineCamera:ForceCameraPosition(pos,self.mainCameraTransform.rotation)
	self.statesMachine.cinemachineCamera.PreviousStateIsValid = false
end

-- 修正角色位置
function CameraManager:CorrectCameraPos()
	local curInstanceId = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(curInstanceId)
	local position = entity.transformComponent.position
	self:SetCameraPosition(position.x, position.y, position.z)
end

function CameraManager:SetCameraRotation(rotation)
	local camera = self.states[self.curState]
	camera.cinemachineCamera:ForceCameraPosition(self.cameraTransform.position, rotation)
end

function CameraManager:SetCameraPreviousState(isValid)
	self.statesMachine.cinemachineCamera.PreviousStateIsValid = isValid
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
		--local eulerAngles = self.mainCameraTransform.rotation.eulerAngles
		--eulerAngles.z = 0
		--local rotation = self.mainCameraTransform.rotation
		--rotation.eulerAngles = eulerAngles
		--self.mainCameraTransform.rotation = rotation
	else
		----if self.curState ~= self.targetState then
			----self:SwitchState(self.targetState)
			----self.targetState = self.curState
		----end
		--self.cinemachineBrain.m_BlendUpdateMethod = 1--CinemachineBrain.BrainUpdateMethod.LateUpdate;
	end
end

function CameraManager:SetLockTarget(target)
	if self.statesMachine.SetLockTarget then
		self.statesMachine:SetLockTarget(target)
	end
end

function CameraManager:SetMainTarget(target)
	self.mainTarget = target.transform:Find("CameraTarget")

	self.states[CameraState.Operating]:SetMainTarget(self.mainTarget)
	self.states[CameraState.WeakLocking]:SetMainTarget(self.mainTarget)
	self.states[CameraState.ForceLocking]:SetMainTarget(self.mainTarget)
	self.states[CameraState.Fight]:SetMainTarget(self.mainTarget)

	self.states[CameraState.PartnerContrlCamera]:SetMainTarget(self.mainTarget)
	self.states[CameraState.PartnerConnectCamera]:SetMainTarget(self.mainTarget)
	
	self.states[CameraState.UI]:SetMainTarget(self.mainTarget)
	--self.states[CameraState.Drone]:SetMainTarget(self.mainTarget)
	self.states[CameraState.Car]:SetMainTarget(self.mainTarget)

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
	local clientTransformComponent = entity.clientTransformComponent
	local bone = boneName and clientTransformComponent:GetTransform(boneName) or nil
	if not bone then
		bone = clientTransformComponent.transform:Find("CameraTarget")
	end
	self.states[CameraState.Operating]:SetMainTarget(bone)
	self.states[CameraState.WeakLocking]:SetMainTarget(bone)
	self.states[CameraState.ForceLocking]:SetMainTarget(bone)
	self.states[CameraState.PartnerContrlCamera]:SetMainTarget(bone)
	self.states[CameraState.PartnerConnectCamera]:SetMainTarget(bone)
	self.states[CameraState.Photo]:SetCameraLookAt(bone)
	self.states[CameraState.TriPhoto]:SetCameraLookAt(bone)
end

function CameraManager:SetCarCameraLookAt(entity,boneName)
	local clientTransformComponent = entity.clientTransformComponent
	local bone = boneName and clientTransformComponent:GetTransform(boneName) or nil
	if not bone then
		bone = clientTransformComponent.transform:Find("CameraTarget")
	end
	self.states[CameraState.Car]:SetCameraLookAt(bone)
end
function CameraManager:SetCameraFollow(entity,boneName)
	local clientTransformComponent = entity.clientTransformComponent
	local bone = boneName and clientTransformComponent:GetTransform(boneName) or nil
	if not bone then
		bone = clientTransformComponent.transform:Find("CameraTarget")
	end
	self.states[CameraState.Operating]:SetMainTarget(bone)
	self.states[CameraState.WeakLocking]:SetMainTarget(bone)
	self.states[CameraState.ForceLocking]:SetMainTarget(bone)
	self.states[CameraState.PartnerContrlCamera]:SetMainTarget(bone)
	self.states[CameraState.PartnerConnectCamera]:SetMainTarget(bone)
	self.states[CameraState.Car]:SetMainTarget(bone)
end

function CameraManager:SetMixing(mixTransform)
	--Log("SetMixing")
	self.states[CameraState.Operating]:SetMixing(mixTransform)
	self.states[CameraState.WeakLocking]:SetMixing(mixTransform)
	self.states[CameraState.Aiming]:SetMixing(mixTransform)
	--self.states[CameraState.ForceLocking]:SetMixing(self.mainTarget)
end

function CameraManager:SetTarget(targetEntity,clientTransformComponent, transformName, uiLockBindName)
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

	local uiLockBind
	if uiLockBindName then
		uiLockBind = clientTransformComponent:GetTransform(uiLockBindName)
	end

	local hitCaseNode = transformName or "HitCase"	
	local hitCase = clientTransformComponent:GetTransform(hitCaseNode)
	EventMgr.Instance:Fire(EventName.SetLockTarget, hitCase or lookatTarget, uiLockBind or hitCase)
	self.states[CameraState.WeakLocking]:SetTarget(lookatTarget,targetEntity)
	self.states[CameraState.ForceLocking]:SetTarget(lookatTarget,targetEntity)
	self.states[CameraState.Fight]:SetTarget(lookatTarget,targetEntity)
	-- self.states[CameraState.PartnerContrlCamera]:SetTarget(lookatTarget,targetEntity)
end

function CameraManager:ClearTarget()
	EventMgr.Instance:Fire(EventName.SetLockTarget, nil)
	self:SetCameraState(CameraState.Operating)
	self.states[CameraState.WeakLocking]:ClearTarget()
end

-- TODO 加入临时变量 控制是否要操作 operating 镜头回正
function CameraManager:SetCameraState(state, ingoreAsync)
	if self.curState == CameraState.Aiming then
		self.forceState = false
	end

	--PV临时处理
	if self.forceState and state ~= CameraState.Aiming then
		return
	end

	-- 关卡的是自动切的 由于可能不存在相机 不允许手动切换
	if self.curState == state and not self.initState then
		return
	end

	-- if state == CameraState.WeakLocking or state == CameraState.ForceLocking or state == 1 then
	-- 	state = CameraState.Fight
	-- end
	self:SetBodyDamping(0, 0, 0)
	self.lastState = self.curState

	if state ==  CameraState.Operating then
		EventMgr.Instance:Fire(EventName.SetLockTarget, nil)
		if not ingoreAsync then
			local camera = self.states[state]
			local pos = self.cameraTransform.position
			local ctrRole = BehaviorFunctions.GetCtrlEntity()
			local restQuat = self.mainCameraTransform.rotation
			if self.initState then
				pos = BehaviorFunctions.GetPositionP(ctrRole)
				camera:SetBodyDamping(0, 0, 0)
				local rot = BehaviorFunctions.GetRotation(ctrRole)
				local euler = rot:ToEulerAngles()
				restQuat = Quaternion.Euler(0, euler.y, 0)
			end
			
			camera.cinemachineCamera:ForceCameraPosition(pos, restQuat)
			camera.cinemachineCamera.PreviousStateIsValid = false

		end
	end
	if self.curState == CameraState.Operating and state == CameraState.WeakLocking then
		self.states[CameraState.Operating]:SetBlendHint(2)
	else
		self.states[CameraState.Operating]:SetBlendHint(3)
	end

	if self.curState == CameraState.Operating and state == CameraState.Aiming then
		LuaTimerManager.Instance:AddTimerByNextFrame(1, FightUtil.deltaTimeSecond, function ()
			self:SwitchCamera(state)
		end)
	else
		self:SwitchCamera(state)
	end
	self:ResetCameraFovVal(self.lastState)
	self.forceCameraShakeMultiple = nil

	self:InformCameraBlendState(true)

	local blendTime = self:GetCameraBlendTime() or 0
	if blendTime < 0 then
		-- Fight.Instance.entityManager:CallBehaviorFun("InformCameraBlendState", false, self.lastState, self.curState)
		self:InformCameraBlendState(false)
	else
		self.isBlend = true
	end
	self.initState = false
end

function CameraManager:SetCameraStateForce(state,force)
	self.forceState = force
	-- 关卡的是自动切的 由于可能不存在相机 不允许手动切换
	if self.curState == state then
		return
	end
	if self.curState == CameraState.Aiming then
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

	local lastState = self.curState
	if state ==  CameraState.Operating then
		EventMgr.Instance:Fire(EventName.SetLockTarget, nil)
		local camera = self.states[state]
		camera.cinemachineCamera:ForceCameraPosition(self.cameraTransform.position,self.mainCameraTransform.rotation)
		camera.cinemachineCamera.PreviousStateIsValid = false
	end
	if self.curState == CameraState.Operating and state == CameraState.WeakLocking then
		self.states[CameraState.Operating]:SetBlendHint(2)
	else
		self.states[CameraState.Operating]:SetBlendHint(3)
	end

	if self.curState == CameraState.Operating and state == CameraState.Aiming then
		LuaTimerManager.Instance:AddTimerByNextFrame(1, FightUtil.deltaTimeSecond, function ()
				self:SwitchCamera(state)
			end)
	else
		self:SwitchCamera(state)
	end
	self:ResetCameraFovVal(lastState)
	self.forceCameraShakeMultiple = nil
end

function CameraManager:SwitchCamera(state)
	self:SwitchState(state)
	if self.states[state].SetCameraMgrNoise then
		self.states[state]:SetCameraMgrNoise()
	end
end

function CameraManager:SetCameraInheritPosition(isInherit)
	local camera = self.states[self.curState]
	if not camera then
		LogError("确少当前状态相机,相机状态Id = "..self.curState)
		return
	end
	local transitions = camera.cinemachineCamera.m_Transitions
	transitions.m_InheritPosition = isInherit
	camera.cinemachineCamera.m_Transitions = transitions
end

function CameraManager:ResetCameraColliderDamping()
	local cameraClass = self.states[self.curState]
	if cameraClass.ResetColliderDamping then
		cameraClass:ResetColliderDamping()
	end
end

function CameraManager:ResetNoiseVal()
	-- local ShakeType
	-- local Lenght = FightEnum.CameraShakeType.Lenght
	for _, val in pairs(FightEnum.CameraShakeType) do
		self:NoiseEffectEnd(val)
	end
end

function CameraManager:SetCameraParams(state,id,coverDefult)
	self.states[state]:SetCameraParams(id,coverDefult)
end

function CameraManager:SetGlideCameraParams(state,id)
	if self.states[state].SetGlideCameraParams then
		self.states[state]:SetGlideCameraParams(id)
	else
		LogError("当前相机确少飞翔配置设置，联系程序，当前相机id = ", state)
	end
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

function CameraManager:GetCurCamera()
	return self.states[self.curState]
end

function CameraManager:GetCamera(state)
	return self.states[state]
end

function CameraManager:IsLockingTarget()
	return self.curState ~= CameraState.Operating
end

function CameraManager:CorrectCameraParams(state)
	local camera = self.states[state]
	if camera and camera.CorrectCameraParams then
		camera:CorrectCameraParams()
	end
end

function CameraManager:SetCamerIgnoreData(state, isIgnore, ignoreRatio)
	local camera = self.states[state]
	if camera and camera.SetCamerIgnoreData then
		camera:SetCamerIgnoreData(isIgnore, ignoreRatio)
	end
end

function CameraManager:GetMove(x,y)
	--TODO 优化
	self.targetDirection.x = x
	self.targetDirection.y = 0
	self.targetDirection.z = y
	local y = self.mainCameraTransform.rotation.eulerAngles.y
	self.targetDirection = Quaternion.Euler(0, y, 0) * self.targetDirection
	return self.targetDirection.x,self.targetDirection.z
end

function CameraManager:SetNoise(type,amplitud,frequency,resetTime,startOffset,random)
	local timeScale = self:GetMainRoleTimeScale()
	--timeScale = timeScale == 0 and 0.001 or timeScale
	if self.curState == CameraState.ForceLocking then
		amplitud = self.forceCameraShakeMultiple and self.forceCameraShakeMultiple * amplitud or amplitud
	end

	self.noise:SetNoise(type - 1,amplitud,frequency,resetTime,startOffset,random)
end

function CameraManager:SetForceCameraAmplitudMultiple(multiple)
	self.forceCameraShakeMultiple = multiple
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
	return self.mainCameraTransform.rotation
end

function CameraManager:GetMainCameraTransform( )
	return self.mainCameraTransform
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

function CameraManager:SetInheritPosition(selectState, isInheritPosition)
	self.inheritPosition = self.inheritPosition or 0
	self.noInheritPosition = self.noInheritPosition or 0

	-- 添加设置计数
	self.inheritPosition = isInheritPosition and self.inheritPosition + 1 or self.inheritPosition
	self.noInheritPosition = not isInheritPosition and self.noInheritPosition + 1 or self.noInheritPosition

	if isInheritPosition then
		self.noInheritPosition = math.max(0, self.noInheritPosition - 1)
		if self.noInheritPosition > 0 then
			isInheritPosition = false
		end
	end
	
	if not isInheritPosition then
		self.inheritPosition = math.max(0, self.inheritPosition - 1)
		if self.inheritPosition > 0 then
			isInheritPosition = true
		end
	end

	if selectState then
		if selectState and self.states[selectState] and self.states[selectState].SetInheritPosition then
			self.states[selectState]:SetInheritPosition(isInheritPosition)
		end
		return
	end

	for k, state in pairs(CallFuncStates) do
		if self.states[state].SetInheritPosition then
			self.states[state]:SetInheritPosition(isInheritPosition)
		end
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
	local forceCamera = self.states[CameraState.ForceLocking]
	if forceCamera.cinemachineComposer then
		forceCamera.cinemachineComposer.IsStopMutateCamera = pause
	end
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
	if not selectNoise then return end
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
	self.states[CameraState.PartnerContrlCamera]:SetSoftZone(unlimited)
	self.states[CameraState.PartnerConnectCamera]:SetSoftZone(unlimited)
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
	self.cameraFixedManager:RealRemoveAll()
end

function CameraManager:SetCorrectCameraState(state, isCorrect)
	local camera = self.states[state]
	if camera and camera.SetCorrectCameraState then
		camera:SetCorrectCameraState(isCorrect)
	end
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

function CameraManager:CameraPosReduction(params, isClose, recenterEndTime)
	local camera = self.states[self.curState]
	if camera.CameraPosReduction then
		camera:CameraPosReduction(params, isClose, recenterEndTime)
	end
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

	CameraManager.Instance = nil
end
 
function CameraManager:SetCullingMask(cullingMask)
	self.mainCameraComponent.cullingMask = cullingMask
end

function CameraManager:GetCurActiveCamera()
	local cineCamera = self.cinemachineBrain.ActiveVirtualCamera.VirtualCameraGameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	return cineCamera
end

function CameraManager:AddCameraFovChangeData(params)
	local stateCamera = self.states[self.curState]
	local cineCamera = stateCamera.cinemachineCamera
	if not cineCamera then return end

	local lensSetting = cineCamera.m_Lens
	local curFovVal = lensSetting.FieldOfView

	local insId = cineCamera.gameObject:GetInstanceID()
	local recordVal = self.recordCameraFovVal[insId]
	curFovVal = recordVal and recordVal or curFovVal

	if self.BreakCameraFovData and self.BreakCameraFovData.isBreakFov then
		curFovVal = self.BreakCameraFovData.targetFov
		self.BreakCameraFovData = nil
	end

	self.FOVChangeData = {
		cineCamera = cineCamera,
		startFov = params.startFov or curFovVal,
		targetFov = params.targetFov or (curFovVal + params.ChangeAmplitud),
		-- timeFrame = math.ceil(params.ChangeTime / FightUtil.deltaTimeSecond),
		timeFrame = params.ChangeTime,
		CameraState = self.curState,
		startFrame = 0,
	}
	self.time = 0
end

function CameraManager:GetCameraFov()
	local cineCamera = self:GetCurActiveCamera()
	if not cineCamera then return end

	local lensSetting = cineCamera.m_Lens
	return lensSetting.FieldOfView
end

function CameraManager:SetFovChangeEffect(isNoEffect)
	self.NoChangeFov = isNoEffect
end

function CameraManager:UpdateFovChangeVal(data, lerpTime)
	if not data then return end
	if self.NoChangeFov then return end
	local cineCamera = data.cineCamera
	
	local lensSetting = cineCamera.m_Lens
	local curFovVal = lensSetting.FieldOfView

	if data.timeFrame <= data.startFrame then
		if data.isBreakFov then
			data.isBreakFov = false
		end
		lensSetting.FieldOfView = data.targetFov
		cineCamera.m_Lens = lensSetting
		data = nil
		self.time = 0
		return
	end
	
	local t = data.startFrame / data.timeFrame
    local newVal = (1 - t) * data.startFov + t * data.targetFov
	lensSetting.FieldOfView = newVal
	cineCamera.m_Lens = lensSetting
	data.startFrame = data.startFrame + Time.deltaTime * self:GetMainRoleTimeScale()
end

function CameraManager:AddBreakFovChangeData(params)
	local stateCamera = self.states[self.curState]
	local cineCamera = stateCamera.cinemachineCamera
	local lensSetting = cineCamera.m_Lens
	local curFovVal = lensSetting.FieldOfView
	-- 设个默认值
	local time = params.ChangeTime <= 0 and 0.5 or params.ChangeTime
	self.BreakCameraFovData = {
		cineCamera = cineCamera,
		startFov = curFovVal,
		targetFov = defFovVal,
		startFrame = 0,
		timeFrame = time,
		isBreakFov = true,
	}
	self.FOVChangeData = nil
end

function CameraManager:clearBreakFovChangeData()
	if self.BreakCameraFovData and self.BreakCameraFovData.isBreakFov then return end
	self.BreakCameraFovData = nil
end

function CameraManager:SkillBreakFovChange()
	if not self.FOVChangeData then return end
	-- if not self.BreakCameraFovData then return end
	self.BreakCameraFovData = self.BreakCameraFovData or {}

	local curState = self.FOVChangeData.CameraState
	local camera = self.states[curState]
	local cineCamera = camera.cinemachineCamera
	local lensSetting = cineCamera.m_Lens
	local curFovVal = lensSetting.FieldOfView
	local data = self.BreakCameraFovData
	data.cineCamera = cineCamera
	data.startFov = curFovVal
	data.targetFov = defFovVal
	data.isBreakFov = true
	data.timeFrame = data.timeFrame or math.ceil(0.5 / FightUtil.deltaTimeSecond)
	data.startFrame = 0
	self.FOVChangeData = nil
end

function CameraManager:ResetCameraFovVal(state)
	local camera = self.states[state]
	if not camera or not camera.cinemachineCamera then return end
	local cineCamera = camera.cinemachineCamera
	local lensSetting = cineCamera.m_Lens
	lensSetting.FieldOfView = defFovVal
	cineCamera.m_Lens = lensSetting
end

function CameraManager:ChangeConfigKeyVal(state, groupKey, key, val)
	local camera = self.states[state]
	if not camera or not camera.ChangeConfigKeyVal then return end
	camera:ChangeConfigKeyVal(groupKey, key, val)
end

function CameraManager:GetCurCameraFollowTargetToScreenPos()
	local camera = self.states[self.curState]
	local targetTrans = camera.followTargetGroup
	if targetTrans then
		local pos = self.cinemachineBrain.OutputCamera:WorldToScreenPoint(targetTrans.position)
		return pos
	end
end

function CameraManager:GetCurCameraLookAtTargetToScreenPos()
	local camera = self.states[self.curState]
	local lookTrans = camera.lookAtTargetGroup
	if lookTrans then
		local pos = self.cinemachineBrain.OutputCamera:WorldToScreenPoint(lookTrans.position)
		return pos
	end
end

function CameraManager:SetFollowTargetWeight(target, weight, selectState)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].SetFollowTargetWeight and (not selectState or selectState == state) then
			self.states[state]:SetFollowTargetWeight(target,weight)
		end
	end
end

function CameraManager:AddFollowTarget(target, selectState, weight)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].AddFollowTarget and (not selectState or selectState == state) then
			self.states[state]:AddFollowTarget(target, weight)
		end
	end
end

function CameraManager:RemoveFollowTarget(target, selectState)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].RemoveFollowTarget and (not selectState or selectState == state) then
			self.states[state]:RemoveFollowTarget(target)
		end
	end
end

function CameraManager:SetGroupPositionMode(mode, selectState)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].SetGroupPositionMode and (not selectState or selectState == state) then
			self.states[state]:SetGroupPositionMode(mode)
		end
	end
end

function CameraManager:SetLookAtTargetWeight(target, weight, selectState)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].SetLookAtTargetWeight and (not selectState or selectState == state) then
			self.states[state]:SetLookAtTargetWeight(target,weight)
		end
	end
end

function CameraManager:AddLookAtTarget(target, selectState)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].AddLookAtTarget and (not selectState or selectState == state) then
			self.states[state]:AddLookAtTarget(target)
		end
	end
end

function CameraManager:RemoveLookAtTarget(target, selectState)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].RemoveLookAtTarget and (not selectState or selectState == state) then
			self.states[state]:RemoveLookAtTarget(target)
		end
	end
end

function CameraManager:RemoveAllLookAtTarget(selectState)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].RemoveAllLookAtTarget and (not selectState or selectState == state) then
			self.states[state]:RemoveAllLookAtTarget()
		end
	end
end

function CameraManager:RemoveAllFollowTarget(selectState)
	for _, state in pairs(CallFuncStates) do
		if self.states[state].RemoveAllFollowTarget and (not selectState or selectState == state) then
			self.states[state]:RemoveAllFollowTarget()
		end
	end
end

function CameraManager:RevertTarget()
	for _, state in pairs(CallFuncStates) do
		if self.states[state].RevertLookAtTarget then
			self.states[state]:RevertLookAtTarget()
		end

		-- if self.states[state].RevertFollowTarget then
		-- 	self.states[state]:RevertFollowTarget()
		-- end
	end
end


function CameraManager:GetCameraDistance(state)
	local camera = self:GetCamera(state)
	if camera.GetCurCameraDistance then
		return camera:GetCurCameraDistance()
	end
end

function CameraManager:DynamicChangeCameraDistance(cameraState, isOpen, targetInsId, bindName, time, maxDis)
	local params = {
		isOpen = isOpen,
		cameraState = cameraState,
		targetInsId = targetInsId,
		bindName = bindName,
		time = time,
		maxDis = maxDis,
	}
	self.cameraEffectMgr:AddNewEffect(CameraEffectManager.EffectType.DynamicDistance, params)
end

function CameraManager:SetCameraDistance(cameraState, targetDis, allTime, isReplace)
	local params = {
		cameraState = cameraState,
		targetDis = targetDis,
		allTime = allTime or FightUtil.deltaTimeSecond,
		isTargetDis = true,
		curTime = 0,
		isReplace = isReplace
	}
	self.cameraEffectMgr:AddNewEffect(CameraEffectManager.EffectType.DynamicDistance, params)
end

-- 设置相机固定旋转角度
function CameraManager:SetCameraFixedEulerVal(verticalVal, horizontalVal, allTime)
	local params = {
		verticalVal = verticalVal,
		horizontalVal = horizontalVal,
		allTime = allTime or FightUtil.deltaTimeSecond,
	}
	self.cameraEffectMgr:AddNewEffect(CameraEffectManager.EffectType.FixedEuler, params)
end

function CameraManager:SetCameraFixedLookAt(state, isOpen, targetInsId, bindName, lookAtInsId, lookAtName)
	local camera = self:GetCamera(state)
	if camera.SetCameraFixedLookAt then
		camera:SetCameraFixedLookAt(isOpen, targetInsId, bindName, lookAtInsId, lookAtName)
	end
end

function CameraManager:SetCorrectEulerData(state, isOpen, allTime, targetEulerX)
	local camera = self:GetCamera(state)
	if camera.SetCorrectEulerData then
		camera:SetCorrectEulerData(isOpen, allTime, targetEulerX)
	end
end

function CameraManager:SetFixedCameraVerticalDir(state, isFixed)
	local camera = self:GetCamera(state)
	if camera.SetFixedCameraVerticalDir then
		camera:SetFixedCameraVerticalDir(isFixed)
	end
end

function CameraManager:GetCameraRotation()
	local eulerAngles = self.mainCameraTransform.rotation.eulerAngles
	return eulerAngles.x, eulerAngles.y, eulerAngles.z
end

function CameraManager:SetDynamicCameraDistance(state, isOpen, maxDis, time)
	local camera = self.states[state]
	if not camera then return end

	if not camera.SetDynamicCameraDistance then
		return
	end
	camera:SetDynamicCameraDistance(isOpen, maxDis, time)
end

function CameraManager:ChangeCameraDistance(state, isChange, changeVal)
	local camera = self.states[state]
	if not camera then return end

	if not camera.ChangeCameraDistance then
		return
	end
	camera:ChangeCameraDistance(isChange, changeVal)
end

function CameraManager:CheckContainPosByInsId(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then return end
	local entityPos = entity.clientTransformComponent.transform.position
	local cameraComponent = self.mainCameraComponent
    local left = cameraComponent.rect.xMin
    local right = cameraComponent.rect.xMax
    local top = cameraComponent.rect.yMax
    local bottom = cameraComponent.rect.yMin

    local pointScreenPos = cameraComponent:WorldToViewportPoint(entityPos)
    local isPointInsideCamera = pointScreenPos.x >= left and pointScreenPos.x <= right and pointScreenPos.y >= bottom and pointScreenPos.y <= top
	return isPointInsideCamera
end



-------------------- 滑翔镜头调整 --------------------

function CameraManager:CheckRoleGlide()
	local insId = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(insId)
	if not entity then return end

	local stateComp = entity.stateComponent
	local isGlide = stateComp:CanGlide()
	if not isGlide then
		self:ClearGlideCameraEffect()
		return
	end
	self:UpdateGlideDis()
	self:UpdateGlideEuler()
end

function CameraManager:UpdateGlideDis()
	local curCamera = self:GetCurCamera()
	if not curCamera.GetParamsDistance then return end

	-- 相机臂长
	local cfgDis = curCamera:GetParamsDistance()
	local targetDis = cfgDis + 0.5
	curCamera:SetCameraDistance(targetDis)
	self.isGlideDis = true
end

function CameraManager:UpdateGlideEuler()
	local curCamera = self:GetCurCamera()
	if not curCamera.SetHorizontalPovVal then return end

	local moveEvent = Fight.Instance.operationManager:GetMoveEvent(true)
	if not moveEvent or moveEvent.x == 0 then
		self.glideEulerData = nil
		return
	end

	if not self.glideEulerData then
		self.glideEulerData = {
			time = 0,
			acc = 0.02,
			lastSpeed = 0.02,
			targetSpeed = 0.3
		}
	end
	local data = self.glideEulerData
	local speed = data.lastSpeed + data.time * data.acc
	speed = math.min(speed, data.targetSpeed)
	data.lastSpeed = speed
	data.time = data.time + FightUtil.deltaTimeSecond
	local addVal = moveEvent.x >= 0 and speed or 0 - speed
	curCamera:SetHorizontalPovVal(addVal)
end

function CameraManager:ClearGlideCameraEffect()
	if not self.isGlideDis then return end
	self.glideEulerData = nil
	local curCamera = self:GetCurCamera()
	if not curCamera.GetParamsDistance then return end
	local cfgDis = curCamera:GetParamsDistance()
	curCamera:SetCameraDistance(cfgDis)
	self.isGlideDis = false
end