UICamera = BaseClass("UICamera",CameraMachineBase)

function UICamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("UI")
	self.camera = self.cameraParent:Find("UICamera")
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
end

function UICamera:SetMainTarget(target)
	if self.mainTarget == target then
		return
	end
	self.mainTarget = target
	self.cinemachineCamera.m_Follow = self.mainTarget
	self.cinemachineCamera.m_LookAt = self.mainTarget
end


function UICamera:OnEnter()
	local position = self.cameraManager.cinemachineBrain.transform.position
	local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	self.cinemachineCamera:ForceCameraPosition(position,rotation)
	self.cameraParent.gameObject:SetActive(true)
end

function UICamera:OnLeave()
	self.cameraParent.gameObject:SetActive(false)
end

function UICamera:__delete()
end