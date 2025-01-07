OperatingCamera = BaseClass("OperatingCamera",CameraMachineBase)

function OperatingCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("Operating")
	self.camera = self.cameraParent:Find("OperatingCamera")
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.lockingPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.cameraCollider = CinemachineInterface.GetCameraCollider(self.camera)
	self.blendInfo = self.cameraManager.cinemachineBrain.m_CustomBlends:GetBlendForVirtualCameras("TrackCamera","OperatingCamera",self.cameraManager.cinemachineBrain.m_DefaultBlend)
	self.curve = self.blendInfo.m_CustomCurve
	self.blendTime = self.blendInfo.BlendTime
	self.curBlendTime = -1

	self:SetCameraMgrNoise()

	self.autoFixTime = 0
	self.isPauseAutoFix = false
	
	self.m_XDamping = self.framingTransposer.m_XDamping
	self.m_YDamping = self.framingTransposer.m_YDamping
	self.m_ZDamping = self.framingTransposer.m_ZDamping
	
end

function OperatingCamera:SetCameraMgrNoise()
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cameraManager.noise = self.noise
end

function OperatingCamera:SetMainTarget(target)
	if self.mainTarget == target then
		return
	end
	self.mainTarget = target
	self.cinemachineCamera.m_Follow = self.mainTarget
	self.cinemachineCamera.m_LookAt = self.mainTarget
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
	if self.fixVerticalAxis and self.cameraManager.cinemachineBrain.IsBlending then
		self.blendWeight = self.cameraManager.cinemachineBrain.ActiveBlend.BlendWeight
		local value = self.startVValue + (self.targetVValue - self.startVValue) * self.blendWeight
		local axisV = self.lockingPOV.m_VerticalAxis
		axisV.Value = value
		self.lockingPOV.m_VerticalAxis = axisV
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
	if not self.defult or coverDefult then
		self.defult = id
	end
	if id == nil then
		id = self.defult
	end
	--Log(Config.ForceCameraConfig[id].CameraDistance)
	local config = Config.CameraParams[id]
	self.framingTransposer.m_CameraDistance = config.CameraDistance
	if config.Fov then
		local lens = self.cinemachineCamera.m_Lens
		lens.FieldOfView = config.Fov
		self.cinemachineCamera.m_Lens = lens
	end
	if config.BodySoftWidth then
		self.framingTransposer.m_SoftZoneWidth = config.BodySoftWidth
	end
	if config.BodySoftHeight then
		self.framingTransposer.m_SoftZoneHeight = config.BodySoftHeight
	end
end

function OperatingCamera:OnLeave()
	--Log("OperatingCamera:OnLeave()")
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
	self.startVValue = axisV.Value
	self.targetVValue = offset
	--axisV.Value = offset
	--self.lockingPOV.m_VerticalAxis = axisV
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

function OperatingCamera:SetInheritPosition(targetPositionOffset)
	CinemachineInterface.SetCinemachineInheritPosition(self.camera.transform, targetPositionOffset)
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

function OperatingCamera:__delete()
end
