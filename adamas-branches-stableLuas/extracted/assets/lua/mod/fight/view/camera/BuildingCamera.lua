BuildingCamera = BaseClass("BuildingCamera", CameraMachineBase)

function BuildingCamera:__init(cameraManager)
    self.cameraManager = cameraManager
    self.cameraParent = cameraManager.camera.transform:Find("Building")
    self.camera = self.cameraParent:Find("BuildingCamera")
    self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.CameraPOV = CinemachineInterface.GetCinemachinePOV(self.camera)
    self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)

    self.selectCamera = self.cameraParent:Find("BuildingSelectCamera")
    self.cinemachineSelectCamera = self.selectCamera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)

    self.targetGroupTransform = self.cameraParent:Find("TargetGroup").transform
    self.targetGroup = self.targetGroupTransform:GetComponent(CinemachineTargetGroup)

    self.cinemachineCamera.m_Follow = self.targetGroupTransform
    self.cinemachineCamera.m_LookAt = self.targetGroupTransform
end

function BuildingCamera:SetMainTarget(target)
    if self.mainTarget == target then
        return
    end
    self.targetGroup:RemoveMember(self.mainTarget)
    self.targetGroup:AddMember(target, 1, 2)
    self.mainTarget = target

    self.cinemachineSelectCamera.m_Follow = target
    self.cinemachineSelectCamera.m_LookAt = target
end

function BuildingCamera:SetExtraTarget(target)
    if self.extraTarget == target then
        return
    end
    self.targetGroup:RemoveMember(self.extraTarget)
    self.targetGroup:AddMember(target, 1, 1)
    self.extraTarget = target
end

function BuildingCamera:RemoveExtraTarget()
    if not self.extraTarget then
        return
    end
    self.targetGroup:RemoveMember(self.extraTarget)
    self.extraTarget = nil
end

function BuildingCamera:ChangeToSelect()
    self.selectCamera:SetActive(true)
    self.camera:SetActive(false)
end

function BuildingCamera:ChangeToBuild()
    self.selectCamera:SetActive(false)
    self.camera:SetActive(true)
end

function BuildingCamera:EnterBuildModel()

end

function BuildingCamera:SetInputAxisValue(value)
    local axisH = self.CameraPOV.m_HorizontalAxis
    axisH.m_InputAxisValue = value
    self.CameraPOV.m_HorizontalAxis = axisH
end

function BuildingCamera:SetCameraDistance(distance)
    self.framingTransposer.m_CameraDistance = distance
end

--function BuildingCamera:SetCameraAxisHSpeed(percent)
--    local axisY = self.CameraPOV.m_HorizontalAxis
--    if not self.oldAxisHSpeed then
--        self.oldAxisHSpeed = axisY.m_Speed
--    end
--    axisY.m_Speed = self.oldAxisHSpeed * percent
--    self.CameraPOV.m_VerticalAxis = axisY
--end

function BuildingCamera:SetCameraAxisHSpeed(percent)
    local axisH = self.CameraPOV.m_HorizontalAxis
    if not self.oldAxisHSpeed then
        self.oldAxisHSpeed = axisH.m_MaxSpeed
    end
    axisH.m_MaxSpeed = self.oldAxisHSpeed * percent
    self.CameraPOV.m_HorizontalAxis = axisH
end

function BuildingCamera:OnEnter()
    self.cameraParent.gameObject:SetActive(true)
end

function BuildingCamera:OnLeave()
    self.cameraParent.gameObject:SetActive(false)
end

function BuildingCamera:__delete()
end