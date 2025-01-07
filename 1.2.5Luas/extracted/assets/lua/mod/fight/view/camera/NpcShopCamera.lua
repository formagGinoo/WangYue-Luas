NpcShopCamera = BaseClass("NpcShopCamera",CameraMachineBase)

function NpcShopCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("NpcShop")
	self.camera = self.cameraParent:Find("NpcShopCamera")
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.lockingPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
end

function NpcShopCamera:SetMainTarget(target)
	if self.mainTarget == target then
		return
	end
	self.mainTarget = target
	self.cinemachineCamera.m_Follow = self.mainTarget
	self.cinemachineCamera.m_LookAt = self.mainTarget
end

function NpcShopCamera:SetCameraParam(ScreenX, ScreenY, axisVValue, axisHValue, distance)
	self.framingTransposer.m_ScreenX = ScreenX
	self.framingTransposer.m_ScreenY = ScreenY

	local axisV = self.lockingPOV.m_VerticalAxis
	axisV.Value = axisVValue
	self.lockingPOV.m_VerticalAxis = axisV

	local axisH = self.lockingPOV.m_HorizontalAxis
	axisH.Value = axisHValue
	self.lockingPOV.m_HorizontalAxis = axisH

	self.framingTransposer.m_CameraDistance = distance
end


function NpcShopCamera:OnEnter()
	--local position = self.cameraManager.cinemachineBrain.transform.position
	--local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	--self.cinemachineCamera:ForceCameraPosition(position,rotation)
	self.cameraParent.gameObject:SetActive(true)
end

function NpcShopCamera:OnLeave()
	self.cameraParent.gameObject:SetActive(false)
end

function NpcShopCamera:__delete()
end