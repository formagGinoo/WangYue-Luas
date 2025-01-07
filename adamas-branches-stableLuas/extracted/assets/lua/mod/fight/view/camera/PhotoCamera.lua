PhotoCamera = BaseClass("PhotoCamera",CameraMachineBase)

function PhotoCamera:__init(cameraManager)
    self.cameraManager = cameraManager
    self.cameraParent = cameraManager.camera.transform:Find("Photo")
    self.camera = self.cameraParent:Find("PhotoCamera")
    self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.cameraPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
end

function PhotoCamera:SetMainTarget(target)
    if self.mainTarget == target then
        return
    end
    self.mainTarget = target
    self.cinemachineCamera.m_Follow = self.mainTarget
    self.cinemachineCamera.m_LookAt = self.mainTarget
end

function PhotoCamera:SetCameraLookAt(target)
    self.cinemachineCamera.m_LookAt = target
end

function PhotoCamera:GetMainTarget()
    return self.mainTarget
end

function PhotoCamera:SetCamera(target)
    if self.mainTarget == target then
        return
    end
    self.mainTarget = target
    self.cinemachineCamera.m_Follow = self.mainTarget
    self.cinemachineCamera.m_LookAt = self.mainTarget
end

function PhotoCamera:UpdateCameraRotation(h, v)
	local axisV = self.cameraPOV.m_VerticalAxis
	axisV.Value = v
	self.cameraPOV.m_VerticalAxis = axisV
	
    local axisH = self.cameraPOV.m_HorizontalAxis
    axisH.Value = h
    self.cameraPOV.m_HorizontalAxis = axisH

end


function PhotoCamera:OnEnter()
    self.cameraParent.gameObject:SetActive(true)
end

function PhotoCamera:OnLeave()
    self.cameraParent.gameObject:SetActive(false)
end

function PhotoCamera:__delete()
end