DroneCamera = BaseClass("DroneCamera",CameraMachineBase)

function DroneCamera:__init(cameraManager)
    self.cameraManager = cameraManager
    self.cameraParent = cameraManager.camera.transform:Find("Drone")
    self.camera = self.cameraParent:Find("DroneCamera")
    self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    --self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
    --self.lockingPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
end

function DroneCamera:SetMainTarget(target)
    if self.mainTarget == target then
        return
    end
    self.mainTarget = target
    self.cinemachineCamera.m_Follow = self.mainTarget
    self.cinemachineCamera.m_LookAt = self.mainTarget
end

function DroneCamera:OnEnter()
    --local position = self.cameraManager.cinemachineBrain.transform.position
    --local rotation = self.cameraManager.cinemachineBrain.transform.rotation
    --self.cinemachineCamera:ForceCameraPosition(position,rotation)
    self.cameraParent.gameObject:SetActive(true)
end

function DroneCamera:OnLeave()
    self.cameraParent.gameObject:SetActive(false)
end

function DroneCamera:__delete()
end