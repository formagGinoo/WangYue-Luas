DroneCamera = BaseClass("DroneCamera",CameraMachineBase)

function DroneCamera:__init(cameraManager)
    self.cameraManager = cameraManager
    self.cameraParent = cameraManager.camera.transform:Find("Drone")
    self.camera = self.cameraParent:Find("DroneCamera")
    self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.sprintCamera = self.cameraParent:Find("DroneSprintCamera")
    self.sprintCinemachineCamera = self.sprintCamera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)

    self.noise = CinemachineInterface.GetNoise(self.camera)
    self.sprintNoise = CinemachineInterface.GetNoise(self.sprintCamera)
end

function DroneCamera:SetCameraMgrNoise()
    self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
    self.sprintNoise.cinemachineBrain = self.cameraManager.cinemachineBrain
    self.cameraManager.noise = self.noise
end

function DroneCamera:SetMainTarget(target)
    if self.mainTarget == target then
        return
    end
    self.mainTarget = target
    self.cinemachineCamera.m_Follow = self.mainTarget
    self.cinemachineCamera.m_LookAt = self.mainTarget

    self.sprintCinemachineCamera.m_Follow = self.mainTarget
    self.sprintCinemachineCamera.m_LookAt = self.mainTarget
end

function DroneCamera:SetFightTarget(follow, lookAt)
    self.cinemachineCamera.m_Follow = follow
    self.cinemachineCamera.m_LookAt = lookAt

    self.sprintCinemachineCamera.m_Follow = follow
    self.sprintCinemachineCamera.m_LookAt = lookAt
end

function DroneCamera:ChangeToSprint()
    self.camera.gameObject:SetActive(false)
    self.sprintCamera.gameObject:SetActive(true)
    self.cameraManager.noise = self.sprintNoise
end

function DroneCamera:ChangeToNormal()
    self.camera.gameObject:SetActive(true)
    self.sprintCamera.gameObject:SetActive(false)
    self.cameraManager.noise = self.noise
end

function DroneCamera:OnEnter()
    self.cameraParent.gameObject:SetActive(true)
    self.camera.gameObject:SetActive(true)
    self.sprintCamera.gameObject:SetActive(false)
end

function DroneCamera:OnLeave()
    self.cameraParent.gameObject:SetActive(false)
end

function DroneCamera:__delete()
end