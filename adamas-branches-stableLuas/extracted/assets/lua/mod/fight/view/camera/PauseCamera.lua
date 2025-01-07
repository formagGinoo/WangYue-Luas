PauseCamera = BaseClass("PauseCamera",CameraMachineBase)

function PauseCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("Pause")
	self.camera = self.cameraParent:Find("PauseCamera")
	CustomUnityUtils.SetCameraBodyFov(self.camera, 50)
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.lockingPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
    self.targetGroup = self.cameraParent:Find("TargetGroup")
	self.count = 0
end

function PauseCamera:GetMainTarget()
    return self.mainTarget
end

function PauseCamera:Update()
	
end

function PauseCamera:SetCameraRotation(pov, x, y)
    local axisH = pov.m_HorizontalAxis
    axisH.Value = x
    pov.m_HorizontalAxis = axisH

    local axisV = pov.m_VerticalAxis
    axisV.Value = y
    pov.m_VerticalAxis = axisV
end

function PauseCamera:OnEnter()
	self.nowCamera = self.cameraManager.states[self.cameraManager.curState]
	if UtilsBase.IsNull(CinemachineInterface.GetCinemachinePOV(self.nowCamera.camera.transform)) then
		return
	end
	self.count = self.count + 1
	if self.count ~= 1 then 
		return 
	end
	CameraManager.Instance:SetInheritPosition(nil, false)
	
	if self.nowCamera.camera then
		self.nowCameraLockingPOV = CinemachineInterface.GetCinemachinePOV(self.nowCamera.camera.transform)
		self.verticalValue = self.nowCameraLockingPOV.m_VerticalAxis.Value
		self.horizontalValue = self.nowCameraLockingPOV.m_HorizontalAxis.Value
		self:SetCameraRotation(self.nowCameraLockingPOV, 90, 0)
	end
	self.cameraParent.gameObject:SetActive(true)
end

function PauseCamera:OnLeave()
	if UtilsBase.IsNull(CinemachineInterface.GetCinemachinePOV(self.nowCamera.camera.transform)) then
		return
	end
	self.count = self.count - 1
	if self.count < 0 then
		self.count = 0
		return
	end
	if self.count ~= 0 then
		return
	end

	self.cameraParent.gameObject:SetActive(false)
	if self.timer then 
		LuaTimerManager.Instance:RemoveTimer(self.timer)
	end
	self:SetCameraRotation(self.nowCameraLockingPOV, self.horizontalValue, self.verticalValue)
	self.timer = LuaTimerManager.Instance:AddTimerByNextFrame(1,0,function ()
		if self.nowCamera and self.nowCamera.camera then
			CameraManager.Instance:SetInheritPosition(nil, true)
		end
	end)
end

function PauseCamera:GetCameraUpdateState()
	return self.cameraParent and self.cameraParent.gameObject.activeSelf
end

function PauseCamera:SetCameraParentPOV(state)
	self.cameraParent.gameObject:SetActive(state)
	if self.timer then 
		LuaTimerManager.Instance:RemoveTimer(self.timer)
	end
	self.timer = LuaTimerManager.Instance:AddTimerByNextFrame(1,0,function ()
		if self.nowCamera and self.nowCamera.camera then
			self:SetCameraRotation(self.nowCameraLockingPOV, self.horizontalValue, self.verticalValue)
		end
	end)
	self:SetCameraRotation(self.nowCameraLockingPOV, self.horizontalValue, self.verticalValue)
end

function PauseCamera:__delete()
end