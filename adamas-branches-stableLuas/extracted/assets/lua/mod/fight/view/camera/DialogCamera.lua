DialogCamera = BaseClass("DialogCamera",CameraMachineBase)

function DialogCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("Dialog")
	self.camera = self.cameraParent:Find("DialogCamera")
	CustomUnityUtils.SetCameraBodyFov(self.camera, 50)
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.targetGroup = self.cameraParent:Find("TargetGroup")
    self.cinemachineTargetGroup = self.targetGroup.gameObject:GetComponent(Cinemachine.CinemachineTargetGroup)

end

function DialogCamera:SetMainTarget(target)
    if self.mainTarget == target then
		return
	end
	self.cinemachineCamera.m_Follow = target
	self.cinemachineCamera.m_LookAt = target
end

function DialogCamera:SetTargetList(target1, target2)
	if target1 then
        self.target1 = target1
		self.cinemachineTargetGroup:AddMember(target1, 1, 0)
	end
	if target2 then
        self.target2 = target2
		self.cinemachineTargetGroup:AddMember(target2, 1, 0)
	end
end

function DialogCamera:OnEnter()
	local position = self.cameraManager.cinemachineBrain.transform.position
	local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	--self.cinemachineCamera:ForceCameraPosition(position,rotation)
	self.cameraParent.gameObject:SetActive(true)
end

function DialogCamera:OnLeave()
    if self.target1 then
		self.cinemachineTargetGroup:RemoveMember(self.target1)
	end
    if self.target2 then
		self.cinemachineTargetGroup:RemoveMember(self.target2)
	end
	self.cameraParent.gameObject:SetActive(false)
end

function DialogCamera:__delete()
end