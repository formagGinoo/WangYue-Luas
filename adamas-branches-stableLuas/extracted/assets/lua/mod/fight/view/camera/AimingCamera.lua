AimingCamera = BaseClass("AimingCamera",CameraMachineBase)

local AimScreenW = Screen.width * 0.5
local AimScreenH = Screen.height * 0.5
local AimParam = Config.EntityCommonConfig.AimParam

local AimMousePC = Config.EntityCommonConfig.AimMousePC
local AimMousePhone = Config.EntityCommonConfig.AimMousePhone

local AimSetting = Config.EntityCommonConfig.AimSetting
local AimTargetDistanceSpeed =Config.EntityCommonConfig.AimTargetDistanceSpeed

local MouseSensitivityX
local MouseSensitivityY

local AimTargetLayer = FightEnum.LayerBit.Entity|FightEnum.LayerBit.Default|FightEnum.LayerBit.Terrain
local AimWeakMouseMoveParam = Config.EntityCommonConfig.AimWeakMouseMoveParam

function AimingCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("Aiming")
	self.camera = self.cameraParent:Find("AimingCamera")
	--self.noise = CinemachineInterface.GetNoise(self.camera)
	--self.noise = self.cameraManager.noise
	CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.cinemachineCamera.gameObject:SetActive(false)
	self.aimTargetTrans = Fight.Instance.clientFight:GetAimTargetTrans()
	self.mainCameraTransform = self.cameraManager.mainCamera.transform
	self.btnStopMoveFrame = 0
	self.aimTargetDistance = 0
	self.lockTargetTime = 0
	self.bulletRoot = Fight.Instance.clientFight.clientEntityManager.bulletRoot
end

function AimingCamera:SetNowSensitityByNowDevice()
	if self.nowDevice == InputImageChangerManager.Instance:GetNowDevice() then
		return
	end
	if InputImageChangerManager.Instance:GetNowDevice() == InputImageChangerManager.Instance.DeviceType.KeyMouse then
		MouseSensitivityX = AimSetting.AimMousePC.X
		MouseSensitivityY = AimSetting.AimMousePC.Y
	elseif InputImageChangerManager.Instance:GetNowDevice() == InputImageChangerManager.Instance.DeviceType.PS then
		MouseSensitivityX = AimSetting.AimPS.X
		MouseSensitivityY = AimSetting.AimPS.Y
	elseif InputImageChangerManager.Instance:GetNowDevice() == InputImageChangerManager.Instance.DeviceType.XBox then
		MouseSensitivityX = AimSetting.AimXbox.X
		MouseSensitivityY = AimSetting.AimXbox.Y
	elseif InputImageChangerManager.Instance:GetNowDevice() == InputImageChangerManager.Instance.DeviceType.Phone then
		MouseSensitivityX = AimSetting.AimPhone.X
		MouseSensitivityY = AimSetting.AimPhone.Y
	else
		MouseSensitivityX = AimSetting.AimMousePC.X
		MouseSensitivityY = AimSetting.AimMousePC.Y
	end
	self.nowDevice = InputImageChangerManager.Instance:GetNowDevice()
end

function AimingCamera:SetMixing(mixTransform)
	self.cinemachineCamera.transform:SetParent(mixTransform)
end

function AimingCamera:Update()

end

function AimingCamera:AfterUpdate()
	local mouseCameraMove = InputManager.Instance.cameraMouseInput
	if mouseCameraMove then
		self:SetNowSensitityByNowDevice()
		if InputManager.Instance.isAimMode == true then
			local x = FightMainUIView.bgInput.x  
			local y = FightMainUIView.bgInput.y 
			if InputImageChangerManager.Instance:GetNowDevice() == InputImageChangerManager.Instance.DeviceType.KeyMouse then
				self:MouseMove(x * MouseSensitivityX * 0.015, -y * MouseSensitivityY * 0.015)
			else
				self:MouseMove(x * MouseSensitivityX, -y * MouseSensitivityY)
			end
			
		else
			if InputImageChangerManager.Instance:GetNowDevice() == InputImageChangerManager.Instance.DeviceType.KeyMouse then
				self:MouseMove(Input.GetAxis("Mouse X") * MouseSensitivityX, -Input.GetAxis("Mouse Y") * MouseSensitivityY)
			else
				self:SetNowSensitityByNowDevice()
				local x = FightMainUIView.bgInput.x  
				local y = FightMainUIView.bgInput.y 
				self:MouseMove(x * MouseSensitivityX, -y * MouseSensitivityY)
				-- local x = FightMainUIView.btnInput.x  
				-- local y = FightMainUIView.btnInput.y 
				-- if x == 0 and y == 0 then
				-- 	self.btnStopMoveFrame = self.btnStopMoveFrame + 1
				-- else
				-- 	self.btnStopMoveFrame = 0
				-- end
   
				-- if self.btnStopMoveFrame > 2 then
				-- 	if Input.touchCount == 1 or FightJoyStickPanel.IsJoystickDown then
				-- 		x = FightMainUIView.bgInput.x  
				-- 		y = FightMainUIView.bgInput.y 
				-- 	end
				-- end
			end
		end
		FightMainUIView.bgInput.x = 0
		FightMainUIView.bgInput.y = 0
		FightMainUIView.btnInput.x = 0
		FightMainUIView.btnInput.y = 0
	end
end

function AimingCamera:UpdatePosition(position,rotate)
	self.cinemachineCamera:ForceCameraPosition(position,rotate)
end

function AimingCamera:SetLockTarget(lockTarget)
	self.lockTarget = lockTarget
	self.aimTargetTrans.position = lockTarget.transform.position
	self.aimEntityFSM:RotateToLockTarget(lockTarget)
	self.lockTargetTime = 0.1
end

function AimingCamera:MouseMove(mouseX, mouseY)
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
			self.aimEntityFSM.lockTargetMoveX = 0
		else
			mouseX = 0
		end
	end

	local mouseFixY = false
	if self.aimEntityFSM.lockTargetMoveY ~= 0 then
		if math.abs(mouseY) > math.abs(self.aimEntityFSM.lockTargetMoveY) then
			mouseY = mouseY - self.aimEntityFSM.lockTargetMoveY
			self.aimEntityFSM.lockTargetMoveY = 0
		else
			mouseY = 0
		end
	end

	if mouseX ~= 0 then
		self.aimEntity.rotateComponent:SetRotateOffset(mouseX)
		self.aimEntity.clientTransformComponent:UpdateRotate(1)
	end

	if mouseY ~= 0 then
		local x = self.mainTarget.localRotation.eulerAngles.x + mouseY
		if x > 180 then
			x = x - 360
		end
		x = Mathf.Clamp(x, -60, 60)
		self.mainTarget.localRotation = Quaternion.Euler(Vector3(x, self.mainTarget.localRotation.eulerAngles.y, 0)) 
	end

	-- self.cinemachineCamera:CameraTransformSync(self.mainCameraTransform)

	-- 虚拟相机同步位置
	-- print("Global.deltaTime "..Global.deltaTime.." time "..Time.deltaTime)
	self.cinemachineCamera:UpdateCameraState(Vector3.up, Global.deltaTime)
	-- self.cinemachineCamera:InternalUpdateCameraState(Vector3.up, Global.deltaTime)
	local position = self.camera.transform.position
	local rotation = self.camera.transform.rotation
	self.cameraManager.mainCamera.transform.position = position
	self.cameraManager.mainCamera.transform.rotation = rotation

	if self.aimTargetTrans then
	    -- self.aimTargetTrans.position = CustomUnityUtils.GetScreenRayWorldPos(self.cameraManager.mainCameraComponent, 
	    -- 	AimScreenW, AimScreenH, AimParam.AimMaxDistance, AimParam.AimMinDistance, AimTargetLayer)

	    -- self.bulletGo.layer = FightEnum.Layer.IgnoreRayCastLayer
	    local speed = AimTargetDistanceSpeed * Global.deltaTime
	    local screenW = GameSetCtrl.ScreenW or Screen.width
	    local screenh = GameSetCtrl.ScreenH or Screen.height
		self.aimTargetDistance = CustomUnityUtils.SetAimTargetPos(self.aimTargetTrans, self.cameraManager.mainCameraComponent, 
	    	screenW * 0.5, screenh * 0.5, AimParam.AimMaxDistance, AimParam.AimMinDistance, AimTargetLayer, self.aimTargetDistance, speed, self.bulletRoot.transform)
		-- self.bulletGo.layer = FightEnum.Layer.Default
	end
end

function AimingCamera:OnEnter()
	self.mainTarget = self.cameraManager.mainTarget
	self.cinemachineCamera.m_Follow = self.mainTarget
	self.cinemachineCamera.m_LookAt = self.mainTarget

	self.aimEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	self.aimEntityFSM = self.aimEntity.stateComponent.stateFSM.states[FightEnum.EntityState.Aim].aimFSM
	local transform = self.cameraManager.cinemachineBrain.transform
	local position = transform.position
	local rotation = transform.rotation
	self.mainTarget.localRotation = Quaternion.Euler(Vector3(rotation.eulerAngles.x, 0, 0)) 
	self.cinemachineCamera:ForceCameraPosition(position,rotation)
	self.cinemachineCamera.PreviousStateIsValid = false

	self.cinemachineCamera.gameObject:SetActive(true)
	self.countX = 0
end

function AimingCamera:OnLeave()
	self.aimEntity = nil
	self.cinemachineCamera.m_Follow = nil
	self.cinemachineCamera.m_LookAt = nil
	self.aimTargetDistance = 0
	--self.mainTarget.localRotation = Quaternion.identity
	self.cinemachineCamera.gameObject:SetActive(false)
end

function AimingCamera:UpdateTargetOffset(targetPositionOffset)
	
end

function AimingCamera:UpdateTargetRotation(targetPositionOffset)
	
end

function AimingCamera:__delete()
end


