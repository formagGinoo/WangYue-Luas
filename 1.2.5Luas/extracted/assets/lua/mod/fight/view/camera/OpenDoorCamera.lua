OpenDoorCamera = BaseClass("OpenDoorCamera",CameraMachineBase)

function OpenDoorCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("OpenDoor")
	self.camera = self.cameraParent:Find("OpenDoorCamera")
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    -- self.targetGroup = self.cameraParent:Find("TargetGroup")
    -- self.cinemachineTargetGroup = self.targetGroup.gameObject:GetComponent(Cinemachine.CinemachineTargetGroup)

end

function OpenDoorCamera:SetMainTarget(target)
    if self.mainTarget == target then
		return
	end
	self.cinemachineCamera.m_Follow = target
	self.cinemachineCamera.m_LookAt = target
end

function OpenDoorCamera:OnEnter()
	local position = self.cameraManager.cinemachineBrain.transform.position
	local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	--self.cinemachineCamera:ForceCameraPosition(position,rotation)
	self.cameraParent.gameObject:SetActive(true)
end

function OpenDoorCamera:OnLeave()
	self.cameraParent.gameObject:SetActive(false)
end

function OpenDoorCamera:__delete()
end