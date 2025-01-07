OperatingCamera = BaseClass("OperatingCamera",CameraMachineBase)

function OperatingCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("Operating")
	self.camera = self.cameraParent:Find("OperatingCamera")
	self.targetGroupTransform = self.cameraParent:Find("TargetGroup").transform
	self.targetGroup = self.targetGroupTransform:GetComponent(CinemachineTargetGroup)
	self.lookAtTargetGroupTransform = self.cameraParent:Find("LookAtTargetGroup").transform
	self.lookAtTargetGroup = self.lookAtTargetGroupTransform:GetComponent(CinemachineTargetGroup)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.cinemachineCollider = self.camera.gameObject:GetComponent(CinemachineCollider)
	self.colliderDamping = self.cinemachineCollider.m_Damping
	
	self.lockingPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.cameraCollider = CinemachineInterface.GetCameraCollider(self.camera)
	self.blendInfo = self.cameraManager.cinemachineBrain.m_CustomBlends:GetBlendForVirtualCameras("TrackCamera","OperatingCamera",self.cameraManager.cinemachineBrain.m_DefaultBlend)
	self.curve = self.blendInfo.m_CustomCurve
	self.blendTime = self.blendInfo.BlendTime
	self.curBlendTime = -1

	-- 只有操作相机需要首次调用
	self:SetCameraMgrNoise()

	self.autoFixTime = 0
	self.isPauseAutoFix = false
	
	self.m_XDamping = self.framingTransposer.m_XDamping
	self.m_YDamping = self.framingTransposer.m_YDamping
	self.m_ZDamping = self.framingTransposer.m_ZDamping
	self.cinemachineCamera.m_Follow = self.targetGroupTransform
	self.cinemachineCamera.m_LookAt = self.lookAtTargetGroupTransform
	self.framingTransposer.m_GroupFramingMode = 3--none
	--self.targetGroup.m_PositionMode = 2--HorizontalOnly
	--self.groupCount = 1
end

function OperatingCamera:SetCameraMgrNoise()
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cameraManager.noise = self.noise
end

function OperatingCamera:SetMainTarget(target)
	if self.mainTarget == target then
		return
	end
	self.targetGroup:RemoveMember(self.mainTarget)
	self.targetGroup:AddMember(target,1,1)

	self.lookAtTargetGroup:RemoveMember(self.mainTarget)
	self.lookAtTargetGroup:AddMember(target,1,1)

	self.mainTarget = target
end

function OperatingCamera:AddFollowTarget(target, weigth)
	weigth = weigth or 1
	self.targetGroup:AddMember(target,weigth,1)
	--self.cinemachineCamera.m_Follow = self.targetGroupTransform
	--self.groupCount = self.groupCount + 1
end

function OperatingCamera:RemoveAllLookAtTarget()
	self.lookAtTargetGroup:RemoveAllMember()
end

function OperatingCamera:RemoveAllFollowTarget()
	self.targetGroup:RemoveAllMember()
end

function OperatingCamera:RemoveFollowTarget(target)
	self.targetGroup:RemoveMember(target)
	--self.cinemachineCamera.m_Follow = self.mainTarget
	--self.groupCount = self.groupCount - 1
end

function OperatingCamera:SetFollowTargetWeight(target,weight)
	self.targetGroup:SetMemberWeight(target,weight)
end

function OperatingCamera:SetGroupPositionMode(mode)
	self.targetGroup.m_PositionMode = mode
end

function OperatingCamera:AddLookAtTarget(target)
	self.lookAtTargetGroup:AddMember(target,1,1)
end

function OperatingCamera:RemoveLookAtTarget(target)
	self.lookAtTargetGroup:RemoveMember(target)
end

function OperatingCamera:SetLookAtTargetWeight(target,weight)
	self.lookAtTargetGroup:SetMemberWeight(target,weight)
end

function OperatingCamera:SetMixing(mixTransform)
	self.cinemachineCamera.transform:SetParent(mixTransform)
end

function OperatingCamera:Update()
	if self.fixHorizontalAxis and self.cameraManager.cinemachineBrain.IsBlending then
		self.blendWeight = self.cameraManager.cinemachineBrain.ActiveBlend.BlendWeight
		local value = self.startHValue + (self.targetHValue - self.startHValue) * self.blendWeight
		local axisH = self.lockingPOV.m_HorizontalAxis
		axisH.Value = value
		self.lockingPOV.m_HorizontalAxis = axisH
	end

	if not self.startVValue and self.fixVerticalAxis then
		local axisV = self.lockingPOV.m_VerticalAxis
		self.startVValue = axisV.Value
	end

	if self.fixVerticalAxis and self.cameraManager.cinemachineBrain.IsBlending then
		self.blendWeight = self.cameraManager.cinemachineBrain.ActiveBlend.BlendWeight
		local value = self.startVValue + (self.targetVValue - self.startVValue) * self.blendWeight
		local axisV = self.lockingPOV.m_VerticalAxis
		axisV.Value = value
		self.lockingPOV.m_VerticalAxis = axisV
	else
		self.startVValue = nil
		self.fixVerticalAxis = nil
	end
	
	if self.fixVerticalAxisByTime then
		self.curfixVAxisTime = self.curfixVAxisTime + Global.deltaTime
		if self.curfixVAxisTime >= self.fixVAxisTime then
			self.fixVerticalAxisByTime = false
			local axisV = self.lockingPOV.m_VerticalAxis
			axisV.Value = self.targetVValueT
			self.lockingPOV.m_VerticalAxis = axisV
			return
		end
		local blendWeight = self.curfixVAxisTime / self.fixVAxisTime
		local value = self.startVValueT + (self.targetVValueT - self.startVValueT) * blendWeight
		local axisV = self.lockingPOV.m_VerticalAxis
		axisV.Value = value
		self.lockingPOV.m_VerticalAxis = axisV
	end
	self:UpdateAutoFixTime()
	self:UpdatePosReductionState()
	self:UpdateFoxHorizontalVal()
	self:UpdateCameraDistance()
end

function OperatingCamera:IsContainPos(pos2)
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(ctrlEntity)
	local pos1 = entity.transformComponent.position

    local cameraComponent = self.cameraManager.mainCameraComponent
    local left = cameraComponent.rect.xMin
    local right = cameraComponent.rect.xMax
    local top = cameraComponent.rect.yMax
    local bottom = cameraComponent.rect.yMin

    local point1ScreenPos = cameraComponent:WorldToViewportPoint(pos1)
    local point2ScreenPos = cameraComponent:WorldToViewportPoint(pos2)

    local isPoint1InsideCamera = point1ScreenPos.x >= left and point1ScreenPos.x <= right and point1ScreenPos.y >= bottom and point1ScreenPos.y <= top
    local isPoint2InsideCamera = point2ScreenPos.x >= left and point2ScreenPos.x <= right and point2ScreenPos.y >= bottom and point2ScreenPos.y <= top
    return isPoint1InsideCamera and isPoint2InsideCamera
end

function OperatingCamera:SetFixHorizontalVal(val, cb, target)
	local axisH = self.lockingPOV.m_HorizontalAxis
	self.fixHorizontalData = {
		start = axisH.Value,
		targetVal = val,
		time = FightUtil.deltaTimeSecond * 30,
		startTime = 0,
		cb = cb,
		target = target
	}
end

function OperatingCamera:lerp_number(num1, num2, t)
	return num1 + (num2 - num1) * t
end

function OperatingCamera:UpdateFoxHorizontalVal()
	if not self.fixHorizontalData then return end
	local data = self.fixHorizontalData

	if data.startTime >= data.time or self:IsContainPos(data.target.transform.position) then
		if data.cb then
			data.cb()
		end
		self:SetDefaulBodyDamping()
		self.fixHorizontalData = nil
		return
	end

	data.startTime = data.startTime + FightUtil.deltaTimeSecond
	local t = data.startTime / data.time
	local axisH = self.lockingPOV.m_HorizontalAxis
	
	-- local pos = data.target.transform.position

	-- local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	-- local entity = BehaviorFunctions.GetEntity(ctrlEntity)
	-- local pos1 = entity.transformComponent.position
	-- local cameraPos = self.cameraManager.cameraTransform.position
	-- local lookAtRotate = Quat.LookRotationA(pos.x - entityPos.x, pos.y - entityPos.y, pos.z - entityPos.z)
	-- local rotationEulerAngles = lookAtRotate:ToEulerAngles()
	-- local rotY = Quat.NormalizeEuler(rotationEulerAngles.y)
	-- data.targetVal = rotY

    local newVal = self:lerp_number(axisH.Value, data.targetVal, t)
	axisH.Value = newVal
	self.lockingPOV.m_HorizontalAxis = axisH

	local axisV = self.lockingPOV.m_VerticalAxis
    local newVal2 = self:lerp_number(axisV.Value, 9, t)
	axisV.Value = newVal2
	self.lockingPOV.m_VerticalAxis = axisV
end

function OperatingCamera:UpdateAutoFixTime()
	if self.isPauseAutoFix then
		return
	end
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(ctrlEntity)
	if not entity then
		return
	end
	if (entity.stateComponent:IsState(FightEnum.EntityState.Move) and 
			(entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move]:IsState(FightEnum.EntityMoveSubState.Run)
				or entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move]:IsState(FightEnum.EntityMoveSubState.Sprint)) )
		or entity.stateComponent:IsState(FightEnum.EntityState.Swim)
		then
		self.autoFixTime = self.autoFixTime + Global.deltaTime
		if self.autoFixTime > 1 then
			self.autoFixTime = 0
			self:FixVerticalAxisByTime(8,1)
		end
	else
		self.autoFixTime = 0
		self.fixVerticalAxisByTime = false
	end
end

function OperatingCamera:ResetTimeAutoFixTime(isPause)
	self.isPauseAutoFix = isPause
	self.fixVerticalAxisByTime = false
	self.autoFixTime = 0
end

function OperatingCamera:UpdatePosition(position,rotate)
	--self.cinemachineCamera:ForceCameraPosition(position,rotate)
end

function OperatingCamera:SetFOV(fov)
	local lens = self.cinemachineCamera.m_Lens
	lens.FieldOfView = fov
	self.cinemachineCamera.m_Lens = lens
end

function OperatingCamera:GetFOV()
	local lens = self.cinemachineCamera.m_Lens
	return lens.FieldOfView
end

function OperatingCamera:OnEnter()
	--Log("OperatingCamera:OnEnter() ")
	--local axisH = self.lockingPOV.m_HorizontalAxis
	--local axisV = self.lockingPOV.m_VerticalAxis
	--Log("H "..axisH.Value)
	--Log("V "..axisV.Value)
	--axisH.Value = self.cameraManager.cinemachineBrain.transform.rotation.eulerAngles.y
	--axisV.Value = 8
	local position = self.cameraManager.mainCamera.transform.position
	local rotation = self.cameraManager.mainCamera.transform.rotation
	--local position = self.cameraManager.lastPosition
	--local rotation = self.cameraManager.lastRotation
	--local position = self.cameraManager.cinemachineBrain.transform.position
	--local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	--self.lockingPOV.m_HorizontalAxis = axisH
	--self.lockingPOV.m_VerticalAxis = axisV

	self.cinemachineCamera.gameObject:SetActive(true)
	if self.cameraManager.ignoreForceCameraPosition then
		self.cameraManager.ignoreForceCameraPosition = false
	else
		-- self.cinemachineCamera:ForceCameraPosition(position,rotation)
	end

	--self.cameraManager.cinemachineBrain:SetCameraOverride(1,self.cinemachineCamera,self.cinemachineCamera,1,Time.deltaTime)
	--self.lockingPOV.m_HorizontalAxis.m_Recentering:RecenterNow()
	--self.lockingPOV.m_VerticalAxis.m_Recentering:RecenterNow()
	
	--self.lockingPOV:UpdateInputAxisProvider()
	
	self:ResetTimeAutoFixTime()
	--Log("H1 "..self.lockingPOV.m_HorizontalAxis.Value)
	--Log("V2 "..self.lockingPOV.m_VerticalAxis.Value)
	self.fixVerticalAxis = false
	self.fixVerticalAxisByTime = false
	self.fixHorizontalAxis = false

end

function OperatingCamera:SetCameraParams(id,coverDefult)
	if id == self.defult then return end
	if not self.cinemachineCamera.gameObject.activeSelf then
		return
	end
	
	if not self.defult or coverDefult then
		self.defult = id
	end
	if id == nil then
		id = self.defult
	end

	if not id or id == self.curParamsId then return end

    self.curParamsId = id
	--Log(Config.ForceCameraConfig[id].CameraDistance)
	local config = Config.CameraParams[id]
	self.cameraCfg = config
	self.framingTransposer.m_CameraDistance = config.CameraDistance
	if config.Fov then
		local lens = self.cinemachineCamera.m_Lens
		lens.FieldOfView = config.Fov
		self.cinemachineCamera.m_Lens = lens
	end
	self:SetCameraSoftZoneInfo()
	self.framingTransposer.m_XDamping = config.XDamping or 0.5
	self.framingTransposer.m_YDamping = config.YDamping or 0.5
	self.framingTransposer.m_ZDamping = config.ZDamping or 0.5
end

function OperatingCamera:SetCameraSoftZoneInfo(width, height)
	self.framingTransposer.m_SoftZoneWidth = width or 0.4
	self.framingTransposer.m_SoftZoneHeight = height or 0.5
end

function OperatingCamera:SetGlideCameraParams(id)
	local params = Config.CameraParams[id]
	if not params then
		return
	end

	if params.XDamping then
		self.framingTransposer.m_XDamping = params.XDamping
	end
	if params.YDamping then
		self.framingTransposer.m_YDamping = params.YDamping
	end
	if params.ZDamping then
		self.framingTransposer.m_ZDamping = params.ZDamping
	end
end

function OperatingCamera:GetCameraSoftZoneInfo()
	return self.framingTransposer.m_SoftZoneWidth, self.framingTransposer.m_SoftZoneHeight
end

function OperatingCamera:GMSetData(target, dis, is3RD)
	self.mainTarget = target
	self.cinemachineCamera.m_Follow = self.mainTarget
	self.cinemachineCamera.m_LookAt = self.mainTarget
	-- if is3RD then
	-- 	CinemachineInterface.RemoveBodyComponent(1, self.camera)
	-- 	self.Test = CinemachineInterface.Add3RDPreonFollow(self.camera)
	-- else
	-- 	CinemachineInterface.RemoveBodyComponent(2, self.camera)
	-- 	self.framingTransposer = CinemachineInterface.AddFramingTransposer(self.camera)
	-- 	self.framingTransposer.m_CameraDistance = 5
	-- end
end

function OperatingCamera:OnLeave()
	--Log("OperatingCamera:OnLeave()")
	self.curParamsId = nil
	self.defult = nil
	self:ResetTimeAutoFixTime()
	self.cinemachineCamera.gameObject:SetActive(false)
end

function OperatingCamera:FixHorizontalAxis(offset)
	self.fixHorizontalAxis = true
	local axisH = self.lockingPOV.m_HorizontalAxis
	self.startHValue = self.mainTarget.transform.rotation.eulerAngles.y
	self.targetHValue = self.mainTarget.transform.rotation.eulerAngles.y + offset
	local dif = self.targetHValue - self.startHValue
	if math.abs(dif) > 180 then
		if self.targetHValue > self.startHValue then
			self.targetHValue = self.targetHValue - 360
		else
			self.targetHValue = self.targetHValue + 360
		end
	end
	--axisH.Value = self.cameraManager.cinemachineBrain.transform.rotation.eulerAngles.y + offset
	--self.lockingPOV.m_HorizontalAxis = axisH	
end

function OperatingCamera:FixVerticalAxis(offset)
	self.fixVerticalAxis = true
	local axisV = self.lockingPOV.m_VerticalAxis
	-- self.startVValue = axisV.Value
	self.targetVValue = offset
	--axisV.Value = offset
	--self.lockingPOV.m_VerticalAxis = axisV
end

function OperatingCamera:ResetColliderDamping()
	self.cinemachineCollider.m_Damping = 0
	LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
		self.cinemachineCollider.m_Damping = self.colliderDamping
	end)
end

function OperatingCamera:FixVerticalAxisByTime(offset,time)
	self.fixVerticalAxisByTime = true
	self.fixVAxisTime = time
	self.curfixVAxisTime = 0
	local axisV = self.lockingPOV.m_VerticalAxis
	self.startVValueT = axisV.Value
	self.targetVValueT = offset
end

function OperatingCamera:UpdateTargetOffset(targetPositionOffset)
	self.framingTransposer.m_TrackedObjectOffset = targetPositionOffset
end

function OperatingCamera:SetBlendHint(type)
	local transitions = self.cinemachineCamera.m_Transitions
	transitions.m_BlendHint = type
	self.cinemachineCamera.m_Transitions = transitions
end

function OperatingCamera:UpdateTargetRotation(targetPositionOffset)
	local axisH = self.lockingPOV.m_HorizontalAxis
	axisH.Value = axisH.Value + targetPositionOffset.x
	self.lockingPOV.m_HorizontalAxis = axisH
	
	local axisV = self.lockingPOV.m_VerticalAxis
	axisV.Value = axisV.Value + targetPositionOffset.y
	self.lockingPOV.m_VerticalAxis = axisV
end

function OperatingCamera:SetFixePovAxisVal(horizontalVal, verticalVal)
	local axisH = self.lockingPOV.m_HorizontalAxis
	axisH.Value = horizontalVal
	self.lockingPOV.m_HorizontalAxis = axisH

	local axisV = self.lockingPOV.m_VerticalAxis
	axisV.Value = verticalVal
	self.lockingPOV.m_VerticalAxis = axisV
end

function OperatingCamera:SetInheritPosition(isInherit)
	CinemachineInterface.SetCinemachineInheritPosition(self.camera.transform, isInherit)
end

function OperatingCamera:SetSoftZone(unlimited)
	self.framingTransposer.m_UnlimitedSoftZone = unlimited
end

function OperatingCamera:SetBodyDamping(x,y,z)
	self.framingTransposer.m_XDamping = x
	self.framingTransposer.m_YDamping = y
	self.framingTransposer.m_ZDamping = z
end

function OperatingCamera:SetDefaulBodyDamping()
	self.framingTransposer.m_XDamping = self.m_XDamping
	self.framingTransposer.m_YDamping = self.m_YDamping
	self.framingTransposer.m_ZDamping = self.m_ZDamping
end

function OperatingCamera:EnableCameraCollider(enable)
	self.cameraCollider.enabled = enable
end
function OperatingCamera:SetCameraColliderDamping(damping)
	self.cameraCollider.m_Damping = damping
end
function OperatingCamera:SetCameraVerticalRange(min,max)
	local verticalAxis = self.lockingPOV.m_VerticalAxis
	verticalAxis.m_MinValue = min
	verticalAxis.m_MaxValue = max
	self.lockingPOV.m_VerticalAxis = verticalAxis
end

function OperatingCamera:SetCameraHorizontalRange(min,max)
	local horizontalAxis = self.lockingPOV.m_HorizontalAxis
	horizontalAxis.m_MinValue = min
	horizontalAxis.m_MaxValue = max
	self.lockingPOV.m_HorizontalAxis = horizontalAxis
end

function OperatingCamera:GetCameraRotateVal()
	local axisH = self.lockingPOV.m_HorizontalAxis
	local axisHVal = axisH.Value

	local axisV = self.lockingPOV.m_VerticalAxis
	local axisVVal = axisV.Value
	
	return axisHVal, axisVVal
end

function OperatingCamera:CameraPosReduction(params, isClose, recenterEndTime)
	local verticalRecentering = self.lockingPOV.m_VerticalRecentering
	local horizontalRecentering = self.lockingPOV.m_HorizontalRecentering

	if isClose then
		verticalRecentering.m_enabled = false
		horizontalRecentering.m_enabled = false
		self:SetPOVRecenterState(verticalRecentering, horizontalRecentering)
		return
	end

	local time = params.RecenterTime
	self.povRecenterTime = recenterEndTime or 1
	verticalRecentering.m_RecenteringTime = time
	horizontalRecentering.m_RecenteringTime = time

	verticalRecentering.m_enabled = true
	horizontalRecentering.m_enabled = true
	self:SetPOVRecenterState(verticalRecentering, horizontalRecentering)
	self.posReductionData = {
		vertical = true,
		horizontal = true,
	}
end

function OperatingCamera:SetPOVRecenterState(verticalRecentering, horizontalRecentering)
	self.lockingPOV.m_VerticalRecentering = verticalRecentering
	self.lockingPOV.m_HorizontalRecentering = horizontalRecentering
end

function OperatingCamera:UpdatePosReductionState()
	if not self.posReductionData then
		return
	end

	local recentTarget = self.lockingPOV:GetRecenterTarget()
	local cacheData = self.posReductionData

	local axisH = self.lockingPOV.m_HorizontalAxis
	local axisHVal = axisH.Value

	local axisV = self.lockingPOV.m_VerticalAxis
	local axisVVal = axisV.Value

	local verticalRecentering = self.lockingPOV.m_VerticalRecentering
	local horizontalRecentering = self.lockingPOV.m_HorizontalRecentering

	if self.povRecenterTime < 0 then
		verticalRecentering.m_enabled = false
		horizontalRecentering.m_enabled = false
		self:SetPOVRecenterState(verticalRecentering, horizontalRecentering)
		self.posReductionData = nil
		self.povRecenterTime = 0
		return
	end

	if cacheData.vertical and math.abs(recentTarget.y - axisVVal) < 0.01 then
		verticalRecentering.m_enabled = false
		cacheData.vertical = false
		self.lockingPOV.m_VerticalRecentering = verticalRecentering
	end

	if cacheData.horizontal and math.abs(recentTarget.x - axisHVal) < 0.01 then
		horizontalRecentering.m_enabled = false
		cacheData.horizontal = false
		self.lockingPOV.m_HorizontalRecentering = horizontalRecentering
	end

	if not cacheData.vertical and not cacheData.horizontal then
		self.posReductionData = nil
	end

	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local timeScale = entity.timeComponent:GetTimeScale()
	self.povRecenterTime = self.povRecenterTime - FightUtil.deltaTimeSecond * timeScale
end

function OperatingCamera:__delete()
end

function OperatingCamera:GetParamsDistance()
	return self.cameraCfg.CameraDistance
end

function OperatingCamera:GetCurCameraDistance()
	return self.framingTransposer.m_CameraDistance
end

function OperatingCamera:SetCameraDistance(distance)
	local baseDis = self.cameraCfg.CameraDistance
	self.fixedDis = distance - baseDis
end

function OperatingCamera:AddCameraDistance(distance)
	self.addDis = distance
end

function OperatingCamera:ChangeCameraDistance(isChange, changeVal)
	self.isChangeCameraDistance = isChange
	if not isChange then
		self.changeDisVal = nil
		return
	end
	self.changeDisVal = changeVal
end

function OperatingCamera:UpdateCameraDistance()
	if not self.cameraCfg then return end
	local baseDis = self.cameraCfg.CameraDistance
	if self.fixedDis then
		baseDis = baseDis + self.fixedDis
	end

	if self.addDis then
		baseDis = baseDis + self.addDis
	end

	if self.changeDisVal then
		baseDis = baseDis + self.changeDisVal
	end
	local curDis = self.framingTransposer.m_CameraDistance
	local newDis = MathX.lerp_number(curDis, baseDis, 0.1)
	self.framingTransposer.m_CameraDistance = newDis
end


-- 滑翔镜头效果
function OperatingCamera:SetHorizontalPovVal(addVal)
	local axisH = self.lockingPOV.m_HorizontalAxis
	axisH.Value = axisH.Value + addVal
	self.lockingPOV.m_HorizontalAxis = axisH
end