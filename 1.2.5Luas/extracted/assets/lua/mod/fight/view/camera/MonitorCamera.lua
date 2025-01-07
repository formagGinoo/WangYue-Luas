MonitorCamera = BaseClass("MonitorCamera", CameraMachineBase)

local AimScreenW = Screen.width * 0.5
local AimScreenH = Screen.height * 0.5
local AimParam = Config.EntityCommonConfig.AimParam

local AimTargetLayer = FightEnum.LayerBit.Entity|FightEnum.LayerBit.Defalut|FightEnum.LayerBit.Terrain
local AimWeakMouseMoveParam = Config.EntityCommonConfig.AimWeakMouseMoveParam
local AimTargetDistanceSpeed = 120

function MonitorCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("Monitor")
	self.camera = self.cameraParent:Find("MonitorCamera")

	CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.aimTargetTrans = Fight.Instance.clientFight:GetAimTargetTrans()
	self.mainCameraTransform = self.cameraManager.mainCamera.transform
	self.btnStopMoveFrame = 0
	self.aimTargetDistance = 0
	self.lockTargetTime = 0
end


function MonitorCamera:SetMixing(mixTransform)
	self.cinemachineCamera.transform:SetParent(mixTransform)
end

function MonitorCamera.SetMouseSensitivity(x, y, phonePlatform)
	if ctx.Editor then
		if not phonePlatform then
			MouseSensitivityX = x
			MouseSensitivityY = y
		end
	else
		if phonePlatform then
			MouseSensitivityX = x
			MouseSensitivityY = y
		end
	end
end

function MonitorCamera:Update()

end

function MonitorCamera:AfterUpdate()

end

function MonitorCamera:UpdatePosition(position,rotate)
	self.cinemachineCamera:ForceCameraPosition(position, rotate)
end

function MonitorCamera:SetLockTarget(lockTarget)
	self.lockTarget = lockTarget
	self.aimTargetTrans.position = lockTarget.transform.position
	self.aimEntityFSM:RotateToLockTarget(lockTarget)
	self.lockTargetTime = 0.1
end

function MonitorCamera:MouseMove(mouseX, mouseY)
	if self.lockTargetTime > 0 then
		self.lockTargetTime = self.lockTargetTime - Global.deltaTime
		self.aimEntityFSM:RotateToLockTarget(self.lockTarget)
		return	
	end

	if self.aimEntityFSM:CheckAimPartDecSpeed() then
		mouseX = mouseX * AimWeakMouseMoveParam
		mouseY = mouseY * AimWeakMouseMoveParam
	end

	self.aimEntityFSM:UpdateLockTarget()

	local mouseFixX = false
	if self.aimEntityFSM.lockTargetMoveX ~= 0 then
		if math.abs(mouseX) > math.abs(self.aimEntityFSM.lockTargetMoveX) then
			mouseX = mouseX - self.aimEntityFSM.lockTargetMoveX
		else
			mouseX = 0
		end
	end

	local mouseFixY = false
	if self.aimEntityFSM.lockTargetMoveY ~= 0 then
		if math.abs(mouseY) > math.abs(self.aimEntityFSM.lockTargetMoveY) then
			mouseY = mouseY - self.aimEntityFSM.lockTargetMoveY
		else
			mouseY = 0
		end
	end

	if mouseX ~= 0 then
		self.aimEntity.rotateComponent:SetRotateOffset(mouseX)
		self.aimEntity.clientEntity.clientTransformComponent:UpdateRotate(1)
	end

	if mouseY ~= 0 then
		local x = self.mainTarget.localRotation.eulerAngles.x + mouseY
		if x > 180 then
			x = x - 360
		end
		x = Mathf.Clamp(x, -45, 45)
		self.mainTarget.localRotation = Quaternion.Euler(Vector3(x, self.mainTarget.localRotation.eulerAngles.y, 0)) 
	end

	-- self.cinemachineCamera:CameraTransformSync(self.mainCameraTransform)

	-- 虚拟相机同步位置
	self.cinemachineCamera:UpdateCameraState(Vector3.up, Time.deltaTime)
	-- self.cinemachineCamera:InternalUpdateCameraState(Vector3.up, Time.deltaTime)
	local position = self.camera.transform.position
	local rotation = self.camera.transform.rotation
	self.cameraManager.mainCamera.transform.position = position
	self.cameraManager.mainCamera.transform.rotation = rotation

	if self.aimTargetTrans then
	    local speed = AimTargetDistanceSpeed * Time.deltaTime
		CustomUnityUtils.SetAimTargetPos(self.aimTargetTrans, self.cameraManager.mainCameraComponent, 
	    	AimScreenW, AimScreenH, AimParam.AimMaxDistance, AimParam.AimMinDistance, AimTargetLayer, 0, speed)
	end
end

function MonitorCamera:OnEnter()
	self.cameraParent.gameObject:SetActive(true)
	
	self.mainTarget = self.cameraManager.mainTarget
	self.cinemachineCamera.m_Follow = self.mainTarget
	self.cinemachineCamera.m_LookAt = self.mainTarget

	self.aimEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	self.aimEntityFSM = self.aimEntity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM
	local transform = self.cameraManager.cinemachineBrain.transform
	local position = transform.position
	local rotation = transform.rotation
	self.mainTarget.localRotation = Quaternion.Euler(Vector3(rotation.eulerAngles.x, 0, 0))
	--self.cinemachineCamera:ForceCameraPosition(position,rotation)
end

function MonitorCamera:OnLeave()
	self.cameraParent.gameObject:SetActive(false)
	self.aimEntity = nil
	self.cinemachineCamera.m_Follow = nil
	self.cinemachineCamera.m_LookAt = nil
	self.aimTargetDistance = 0
end

function MonitorCamera:UpdateTargetOffset(targetPositionOffset)
	
end

function MonitorCamera:UpdateTargetRotation(targetPositionOffset)
	
end

function MonitorCamera:__delete()
end


