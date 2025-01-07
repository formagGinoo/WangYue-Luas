CarCamera = BaseClass("CarCamera",CameraMachineBase)

function CarCamera:__init(cameraManager)
    self.cameraManager = cameraManager
    self.cameraParent = cameraManager.camera.transform:Find("Car")
    self.camera = self.cameraParent:Find("CarCamera")
    self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)

    --CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.lockingPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
end

function CarCamera:SetMainTarget(target)
    if self.mainTarget == target then
        return
    end
    self.mainTarget = target
    self.cinemachineCamera.m_Follow = self.mainTarget
    self.cinemachineCamera.m_LookAt = self.mainTarget
    self:SetTrafficCameraMode()
    self:ClearRotationX()
end

function CarCamera:SetCameraMgrNoise()
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cameraManager.noise = self.noise
end
function CarCamera:SetTrafficCameraMode()
	local verticalRecentering = self.lockingPOV.m_VerticalRecentering
	local horizontalRecentering = self.lockingPOV.m_HorizontalRecentering

    
	local value = PlayerPrefs.GetInt(GameSetConfig.SaveKey.DriveCameraCentralAuto,FightEnum.TrafficCameraMode.Along)
    if  value == FightEnum.TrafficCameraMode.Along then
		verticalRecentering.m_enabled = true
		horizontalRecentering.m_enabled = true
    else
		verticalRecentering.m_enabled = false
		horizontalRecentering.m_enabled = false
	end
    self:SetPOVRecenterState(verticalRecentering, horizontalRecentering)
end

function CarCamera:ClearRotationX()
	self.lastRxValue = 0
	self.rxValue = 0
end

function CarCamera:Update(lerpTime)
end


function CarCamera:SetTccaCamera(tcca)
	if tcca then
		tcca:SetTccaCamera(self.cinemachineCamera,self.framingTransposer,self.noise)
	end
end



function CarCamera:SetPOVRecenterState(verticalRecentering, horizontalRecentering)
	self.lockingPOV.m_VerticalRecentering = verticalRecentering
	self.lockingPOV.m_HorizontalRecentering = horizontalRecentering
end
function CarCamera:UpdateTargetRotation(targetPositionOffset)
	local axisH = self.lockingPOV.m_HorizontalAxis
	axisH.Value = axisH.Value + targetPositionOffset.x
	self.lockingPOV.m_HorizontalAxis = axisH
	
	local axisV = self.lockingPOV.m_VerticalAxis
	axisV.Value = axisV.Value + targetPositionOffset.y
	self.lockingPOV.m_VerticalAxis = axisV
end

function CarCamera:SetCameraLookAt(lookat)
    self.cinemachineCamera.m_LookAt = lookat
end

function CarCamera:OnEnter()
    self.cameraParent.gameObject:SetActive(true)
end

function CarCamera:OnLeave()
    self.cameraParent.gameObject:SetActive(false)
    self:ClearRotationX()
end

function CarCamera:__delete()
end

function CarCamera:GetCurCameraDistance()
	return self.framingTransposer.m_CameraDistance
end

function CarCamera:SetInheritPosition(isInherit)
	CinemachineInterface.SetCinemachineInheritPosition(self.camera.transform, isInherit)

	local verticalRecentering = self.lockingPOV.m_VerticalRecentering
	local horizontalRecentering = self.lockingPOV.m_HorizontalRecentering
	verticalRecentering.m_enabled = isInherit
	horizontalRecentering.m_enabled = isInherit

	self.lockingPOV.m_VerticalRecentering = verticalRecentering
	self.lockingPOV.m_HorizontalRecentering = horizontalRecentering
end