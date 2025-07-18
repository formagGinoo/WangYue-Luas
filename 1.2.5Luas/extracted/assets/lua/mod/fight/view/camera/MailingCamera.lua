MailingCamera = BaseClass("MailingCamera",CameraMachineBase)

function MailingCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("Mailing")
	self.camera = self.cameraParent:Find("MailingCamera")
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.lockingPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
	
	self.cameraBack = self.cameraParent:Find("MailingBackCamera")
	self.cinemachineCameraBack = self.cameraBack.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.framingTransposerBack = CinemachineInterface.GetFramingTransposer(self.cameraBack)
	self.lockingPOVBack = CinemachineInterface.GetCinemachinePOV(self.cameraBack.transform)
end

function MailingCamera:SetMainTarget(target)
	if self.mainTarget == target then
		return
	end
	self.mainTarget = target
	self.cinemachineCamera.m_Follow = self.mainTarget
	self.cinemachineCamera.m_LookAt = self.mainTarget
	
	self.cinemachineCameraBack.m_Follow = self.mainTarget
	self.cinemachineCameraBack.m_LookAt = self.mainTarget
end

function MailingCamera:SetCameraParam(ScreenX, ScreenY, distance)
	self.framingTransposer.m_ScreenX = ScreenX
	self.framingTransposer.m_ScreenY = ScreenY
	self.framingTransposer.m_CameraDistance = distance
end


function MailingCamera:OnEnter()
	--local position = self.cameraManager.cinemachineBrain.transform.position
	--local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	--self.cinemachineCamera:ForceCameraPosition(position,rotation)
	self.camera.gameObject:SetActive(true)
	self.cameraBack.gameObject:SetActive(false)
	self.cameraParent.gameObject:SetActive(true)
end

function MailingCamera:OnLeave()
	self.camera.gameObject:SetActive(false)
	self.cameraBack.gameObject:SetActive(true)
	
	local delayFunc = function()
		self.cameraParent.gameObject:SetActive(false)
	end
	LuaTimerManager.Instance:AddTimerByNextFrame(1, 0.5, delayFunc)
end

function MailingCamera:__delete()
end