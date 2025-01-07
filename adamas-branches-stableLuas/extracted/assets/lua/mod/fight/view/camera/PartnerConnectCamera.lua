PartnerConnectCamera = BaseClass("PartnerConnectCamera", ForceLockingCamera)

function PartnerConnectCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("PartnerConnect")
	self.camera = self.cameraParent:Find("PartnerConnectCamera")
	self.targetGroupTransform = self.cameraParent:Find("TargetGroup").transform
	self.targetGroup = self.targetGroupTransform:GetComponent(CinemachineTargetGroup)
	self.lookAtTargetGroupTransform = self.cameraParent:Find("LookAtTargetGroup").transform
	self.lookAtTargetGroup = self.lookAtTargetGroupTransform:GetComponent(CinemachineTargetGroup)
	CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	--self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.cinemachineComposer = CinemachineInterface.GetComposer(self.camera)
	self.customLockCameraY = CinemachineInterface.GetCustomLockCameraY(self.camera)
	
	self:SetCameraMgrNoise()
	self.m_XDamping = self.framingTransposer.m_XDamping
	self.m_YDamping = self.framingTransposer.m_YDamping
	self.m_ZDamping = self.framingTransposer.m_ZDamping
	self.cinemachineCamera.m_Follow = self.targetGroupTransform
	self.cinemachineCamera.m_LookAt = self.lookAtTargetGroupTransform
	self.mainTarget = self.targetGroupTransform
end

function PartnerConnectCamera:OnEnter()
	self.cameraParent.gameObject:SetActive(true)
end

function PartnerConnectCamera:OnLeave()
	self.cameraParent.gameObject:SetActive(false)
end

function PartnerConnectCamera:IsUpdate()
	return self.cameraParent.gameObject.activeSelf
end

function PartnerConnectCamera:ClearTarget()
	return self.cameraParent.gameObject.activeSelf
end
