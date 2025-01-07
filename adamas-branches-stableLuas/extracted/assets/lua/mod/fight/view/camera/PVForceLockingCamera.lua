PVForceLockingCamera = BaseClass("PVForceLockingCamera", ForceLockingCamera)

function PVForceLockingCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("PVForceLocking")
	self.camera = self.cameraParent:Find("PVForceLockingCamera")
	self.targetGroupTransform = self.cameraParent:Find("TargetGroup").transform
	self.targetGroup = self.targetGroupTransform:GetComponent(CinemachineTargetGroup)
	CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.cinemachineComposer = CinemachineInterface.GetComposer(self.camera)
	self.customLockCameraY = CinemachineInterface.GetCustomLockCameraY(self.camera)
	
	self:SetCameraMgrNoise()
	self.m_XDamping = self.framingTransposer.m_XDamping
	self.m_YDamping = self.framingTransposer.m_YDamping
	self.m_ZDamping = self.framingTransposer.m_ZDamping
	self.cinemachineCamera.m_Follow = self.targetGroupTransform
	self.mainTarget = self.targetGroupTransform
end
