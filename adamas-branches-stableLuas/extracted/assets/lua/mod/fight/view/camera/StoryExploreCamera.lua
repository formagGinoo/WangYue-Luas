StoryExploreCamera = BaseClass("StoryExploreCamera",CameraMachineBase)

function StoryExploreCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("StoryExplore")
	self.camera = self.cameraParent:Find("StoryExploreCamera")
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
    self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
end

function StoryExploreCamera:SetFollowAndDistance(target, distance)
	self.mainTarget = target
	self.cinemachineCamera.m_Follow = target
    self.framingTransposer.m_CameraDistance = distance
	--self.cinemachineCamera.m_LookAt = self.mainTarget
end

function StoryExploreCamera:SetPostion(tf)
	self.camera.position = tf.position
end


function StoryExploreCamera:OnEnter()
	-- local position = self.cameraManager.cinemachineBrain.transform.position
	-- local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	-- self.cinemachineCamera:ForceCameraPosition(position,rotation)
	self.cameraParent.gameObject:SetActive(true)
	self:SetInheritPosition(true)
end

function StoryExploreCamera:OnLeave()
	self.cameraParent.gameObject:SetActive(false)
	self:SetInheritPosition(false)
end

function StoryExploreCamera:SetInheritPosition(isInherit)
	CinemachineInterface.SetCinemachineInheritPosition(self.camera.transform, isInherit)
end

function StoryExploreCamera:__delete()
end