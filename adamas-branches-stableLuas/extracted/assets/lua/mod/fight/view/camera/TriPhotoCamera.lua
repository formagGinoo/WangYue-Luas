TriPhotoCamera = BaseClass("TriPhotoCamera",CameraMachineBase)

function TriPhotoCamera:__init(cameraManager)
    self.cameraManager = cameraManager
    self.cameraParent = cameraManager.camera.transform:Find("TriPhoto")
    self.camera = self.cameraParent:Find("TriPhotoCamera")
    self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
    self.cameraPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
end

function TriPhotoCamera:SetMainTarget(target)
    if self.mainTarget == target then
        return
    end
    self.mainTarget = target
    self.cinemachineCamera.m_Follow = self.mainTarget
    self.cinemachineCamera.m_LookAt = self.mainTarget
end

function TriPhotoCamera:SetCameraLookAt(target)
    self.cinemachineCamera.m_LookAt = target
end

function TriPhotoCamera:GetMainTarget()
    return self.mainTarget
end

function TriPhotoCamera:SetCamera(target)
    if self.mainTarget == target then
        return
    end
    self.mainTarget = target
    self.cinemachineCamera.m_Follow = self.mainTarget
    self.cinemachineCamera.m_LookAt = self.mainTarget
end

function TriPhotoCamera:UpdateCameraRotation(h, v)
	local axisV = self.cameraPOV.m_VerticalAxis
	axisV.Value = v
	self.cameraPOV.m_VerticalAxis = axisV
	
    local axisH = self.cameraPOV.m_HorizontalAxis
    axisH.Value = h
    self.cameraPOV.m_HorizontalAxis = axisH
end

function TriPhotoCamera:UpdateCameraVerticalRotation(v)
	local axisV = self.cameraPOV.m_VerticalAxis
	axisV.Value = v
	self.cameraPOV.m_VerticalAxis = axisV
end

function TriPhotoCamera:UpdateCameraHorizontalRotation(h)
    local axisH = self.cameraPOV.m_HorizontalAxis
    axisH.Value = h
    self.cameraPOV.m_HorizontalAxis = axisH
end


function TriPhotoCamera:SetScreenOffset(screenX, screenY)
    self.framingTransposer.m_ScreenX = screenX
	self.framingTransposer.m_ScreenY = screenY
end

function TriPhotoCamera:SetDistance(distance)
    self.framingTransposer.m_CameraDistance = distance
end

function TriPhotoCamera:OnEnter()
    self.cameraParent.gameObject:SetActive(true)
end

function TriPhotoCamera:OnLeave()
    self.cameraParent.gameObject:SetActive(false)
end

function TriPhotoCamera:__delete()
end