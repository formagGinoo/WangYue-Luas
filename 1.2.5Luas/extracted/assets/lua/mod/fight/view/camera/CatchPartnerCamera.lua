CatchPartnerCamera = BaseClass("CatchPartnerCamera",CameraMachineBase)

function CatchPartnerCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("CatchPartner")
	self.camera = self.cameraParent:Find("CatchPartnerCamera")
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
end

function CatchPartnerCamera:SetCameraMgrNoise()
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cameraManager.noise = self.noise
end

function CatchPartnerCamera:SetMainTarget(target)
    if self.mainTarget == target then
		return
	end
	self.cinemachineCamera.m_Follow = target
	self.cinemachineCamera.m_LookAt = target
end

function CatchPartnerCamera:OnEnter()
	local position = self.cameraManager.cinemachineBrain.transform.position
	local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	self.cameraParent.gameObject:SetActive(true)
end

function CatchPartnerCamera:OnLeave()
	self.cameraParent.gameObject:SetActive(false)
end

function CatchPartnerCamera:__delete()
end