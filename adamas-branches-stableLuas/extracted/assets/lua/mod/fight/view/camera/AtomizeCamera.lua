AtomizeCamera = BaseClass("AtomizeCamera", CameraMachineBase)

function AtomizeCamera:__init(cameraManager)
    self.cameraManager = cameraManager
    self.cameraParent = cameraManager.camera.transform:Find("Atomize")

    self.cameraWatch = self.cameraParent:Find("AtomizeWatchCamera")
    self.cinemachineCameraWatch = self.cameraWatch.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.cameraWatchTransposer = CinemachineInterface.GetFramingTransposer(self.cameraWatch)

    self.cameraInto = self.cameraParent:Find("AtomizeIntoCamera")
    self.cinemachinecameraInto = self.cameraInto.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.cameraIntoTransposer = CinemachineInterface.GetFramingTransposer(self.cameraInto)
    self.intoCameraPOV = CinemachineInterface.GetCinemachinePOV(self.cameraInto)

    self.cameraMove = self.cameraParent:Find("AtomizeMoveCamera")
    self.cinemachinecameraMove = self.cameraMove.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.cameraMoveTransposer = CinemachineInterface.GetCinemachineHardLockToTarget(self.cameraMove)
end

function AtomizeCamera:SetMainTarget(target)
    if self.mainTarget == target then
        return
    end
    self.mainTarget = target

    self.cinemachineCameraWatch.m_Follow = self.mainTarget
    self.cinemachineCameraWatch.m_LookAt = self.mainTarget

    self.cinemachinecameraInto.m_Follow = self.mainTarget
    self.cinemachinecameraInto.m_LookAt = self.mainTarget

    --self.cinemachinecameraMove.m_Follow = self.mainTarget
    --self.cinemachinecameraMove.m_LookAt = self.mainTarget
end

function AtomizeCamera:OnEnter()
    self.cameraInto.gameObject:SetActive(false)
    self.cameraWatch.gameObject:SetActive(false)
    self.cameraMove.gameObject:SetActive(false)
    self.cameraParent.gameObject:SetActive(true)
end

function AtomizeCamera:ChangeToWatch()
    --UnityUtils.SetPosition(self.camera, self.mainTarget.position.x, self.mainTarget.position.y, self.mainTarget.position.z)
    self.cameraInto.gameObject:SetActive(false)
    self.cameraMove.gameObject:SetActive(false)
    self.cameraWatch.gameObject:SetActive(true)
end

function AtomizeCamera:ChangeToInto()
    self.cameraWatch.gameObject:SetActive(false)
    self.cameraMove.gameObject:SetActive(false)
    self.cameraInto.gameObject:SetActive(true)
end

function AtomizeCamera:ChangeToMove()
    self.cameraMove.gameObject:SetActive(true)
    self.cameraWatch.gameObject:SetActive(false)
    self.cameraInto.gameObject:SetActive(false)
end

function AtomizeCamera:SetWatchCameraRotation(pitch,yaw,roll)
    self.cameraWatch.localRotation = Quaternion.Euler(Vector3(pitch, yaw, 0))
end

function AtomizeCamera:SetMoveCameraYaw(yaw)
    self.cameraMove.localRotation = Quaternion.Euler(Vector3(0, yaw, 0))
end

function AtomizeCamera:SetAtomizeMoveDamping(value)
    self.cameraMoveTransposer.m_Damping = value
end

function AtomizeCamera:SetAtomizeMovePosition(Pos)
    if self.CameraMoveLastPosition then
        self.CameraMoveLastPosition:SetA(self.CameraMovePosition)
    else
        self.CameraMoveLastPosition = Vec3.New(Pos.x, Pos.y, Pos.z)
    end
    --self.CameraMoveLastPosition = self.CameraMoveLastPosition and self.CameraMoveLastPosition:SetA(self.CameraMovePosition) or Vec3.New(Pos.x, Pos.y, Pos.z)
    self.CameraMovePosition = self.CameraMovePosition and self.CameraMovePosition:SetA(Pos) or Vec3.New(Pos.x, Pos.y, Pos.z)
end

function AtomizeCamera:ClearAtomizeMovePosition()
    self.CameraMoveLastPosition = nil
    self.CameraMovePosition = nil
end

function AtomizeCamera:Update(lerpTime)
    if self.CameraMoveLastPosition and self.CameraMovePosition then
        self.cameraMove.position = Vec3.Lerp(self.CameraMoveLastPosition, self.CameraMovePosition, lerpTime)
    end
end

function AtomizeCamera:SetCameraIntoPovParam(horizontalAxisRange, verticalAxisRange)
    CinemachineInterface.ChangePovParam(self.cameraInto.transform, -horizontalAxisRange, horizontalAxisRange, -verticalAxisRange, verticalAxisRange)
end

function AtomizeCamera:SetIntoCameraDistance(value)
    self.cameraIntoTransposer.m_CameraDistance = value
end

function AtomizeCamera:SetIntoCameraRotation(x,y)
    local axisH = self.intoCameraPOV.m_HorizontalAxis
    axisH.Value = x
    self.intoCameraPOV.m_HorizontalAxis = axisH

    local axisV = self.intoCameraPOV.m_VerticalAxis
    axisV.Value = y
    self.intoCameraPOV.m_VerticalAxis = axisV
end

function AtomizeCamera:SetWatchCameraDistance(value)
    self.cameraWatchTransposer.m_CameraDistance = value
end

function AtomizeCamera:OnLeave()
    self.cameraParent.gameObject:SetActive(false)
end

function AtomizeCamera:__delete()
end