ForceLockingCamera = BaseClass("ForceLockingCamera",CameraMachineBase)

function ForceLockingCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("ForceLocking")
	self.camera = self.cameraParent:Find("ForceLockingCamera")
	--self.noise = CinemachineInterface.GetNoise(self.camera)
	--self.noise = self.cameraManager.noise
	CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.targetGroup = self.cameraParent:Find("TargetGroup")--.gameObject:GetComponent(Cinemachine.CinemachineTargetGroup)
	--self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.cinemachineComposer = CinemachineInterface.GetComposer(self.camera)
	self.customLockCameraY = CinemachineInterface.GetCustomLockCameraY(self.camera)
	--self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	
	self.m_XDamping = self.framingTransposer.m_XDamping
	self.m_YDamping = self.framingTransposer.m_YDamping
	self.m_ZDamping = self.framingTransposer.m_ZDamping
end

function ForceLockingCamera:SetMainTarget(target)
	self.mainTarget = target
	self.cinemachineCamera.m_Follow = target
	--if self.mainTarget then
	--self.targetGroup:RemoveMember(self.mainTarget)
	--end
	--self.mainTarget = target
	--self.targetGroup:AddMember(self.mainTarget,1,1)
end

function ForceLockingCamera:SetTarget(target)
	if UtilsBase.IsNull(target) then
		LogError("SetTarget nil!")
		return
	end
	self.target = target
	self.cinemachineCamera.m_LookAt = self.target
	--if self.target then
	--self.targetGroup:RemoveMember(self.target)
	--end
	--self.target = target
	--self.targetGroup:AddMember(self.target,1,1)
	--self.cinemachineCamera.m_LookAt = target
end

function ForceLockingCamera:Update()
	if UtilsBase.IsNull(self.target) then
		return
	end
	--if self.cameraManager:CheckPauseCameraRotate() then
		--self.cinemachineCamera.m_LookAt = nil
	--else
		--self.cinemachineCamera.m_LookAt = self.target
	--end 
	--do return end
	self:UpdateCenter()
	--do return end
	local targetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.target.position)
	local mainTargetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.mainTarget.position)
	if mainTargetPoint.z > targetPoint.z then
		--self.framingTransposer.m_UnlimitedSoftZone = true
		--self.cinemachineComposer.m_SoftZoneHeight = 2
		--self.cinemachineComposer.m_SoftZoneWidth = 2
		--self.cinemachineComposer.m_DeadZoneWidth = 0.02
		--self.cinemachineComposer.m_HorizontalDamping = 0.2
		if Vector3.Cross(self.cameraManager.mainCamera.transform.forward, self.target.position).y > 0 then--right
			self.framingTransposer.m_ScreenX = 0.475
		else--left
			self.framingTransposer.m_ScreenX = 0.525
		end
	else
		--self.framingTransposer.m_UnlimitedSoftZone = false
		--self.cinemachineComposer.m_SoftZoneHeight = 0.4
		--self.cinemachineComposer.m_SoftZoneWidth = 0.14
		self.framingTransposer.m_ScreenX = 0.5
		--self.cinemachineComposer.m_HorizontalDamping = 0.7
	end
	--self.cinemachineComposer.m_VerticalDamping = 999999
	--local x1 = self.mainTarget.position.x
	--local z1 = self.mainTarget.position.z
	--local x2 = self.target.position.x
	--local z2 = self.target.position.z
	--local dis = math.sqrt((x1-x2)*(x1-x2)+(z1-z2)*(z1-z2))
	--if dis < 3 then
	----self.framingTransposer.m_YDamping = 999999
	----self.cinemachineComposer.m_VerticalDamping = 999999
	--self.cinemachineCamera.m_LookAt = self.mainTarget
	--else
	----self.framingTransposer.m_YDamping = 0.1
	----self.cinemachineComposer.m_VerticalDamping = 0.7
	--self.cinemachineCamera.m_LookAt = self.target
	--end
	--self:UpdateCenter()

	--if self.cameraManager.cinemachineBrain.IsBlending then
	--self.framingTransposer.m_XDamping = 0
	--self.framingTransposer.m_YDamping = 0
	--self.framingTransposer.m_ZDamping = 0
	--self.cinemachineComposer.m_HorizontalDamping = 0
	--self.cinemachineComposer.m_VerticalDamping = 0
	--else
	--self.framingTransposer.m_XDamping = self.startBodyXDamping
	--self.framingTransposer.m_YDamping = self.startBodyYDamping
	--self.framingTransposer.m_ZDamping = self.startBodyZDamping
	--self.cinemachineComposer.m_HorizontalDamping = self.startHDamping
	--self.cinemachineComposer.m_VerticalDamping = self.startVDamping
	--end

	do return end
	if UtilsBase.IsNull(self.target) then
		return
	end
	local pos = self.target.position
	if pos.y - 0.5 < self.mainTarget.position.y then
		pos.y = self.mainTarget.position.y + 0.5
	end
	self.targetGroup.transform.position = pos
end

local minDis = 1
local maxDis = 6
local minBodyScreenY = 0.55
local maxBodyScreenY = 0.6
local minAimScreenY = 0.4
local maxAimScreenY = 0.35
local minAimDeadZoneHeight = 0.1
local maxAimDeadZoneHeight = 0.05
local minAimSoftZoneHeight = 2
local maxAimSoftZoneHeight = 2
local minAimDeadZoneWidth = 0.2
local maxAimDeadZoneWidth = 0.4
local minAimSoftZoneWidth = 1
local maxAimSoftZoneWidth = 1

--最小最大镜头水平/高度距离偏差
local minCameraDistance = 8
local maxCameraDistance = 6
local minCameraYPosition = -3
local maxCameraYPosition = 4

--高度差Aim相关参数
local minYdif = 0
local maxYdif = 4
local minYCameraDistance = 0
local maxYCameraDistance = 1
local minYdifAimScreenY = 0
local maxYdifAimScreenY = 0.1
local minYdifAimDeadZoneHeight = 0.1
local maxYdifAimDeadZoneHeight = 0.05
local minYdifAimSoftZoneHeight = 0.7
local maxYdifAimSoftZoneHeight = 0.3
local minYdifAimDeadZoneWidth = 0.4
local maxYdifAimDeadZoneWidth = 0.03
local minYdifAimSoftZoneWidth = 0.5
local maxYdifAimSoftZoneWidth = 0.08

local minYdifBodyScreenY = 0
local maxYdifBodyScreenY = 0.1
function ForceLockingCamera:UpdateCenter()
	local x1 = self.mainTarget.position.x
	local z1 = self.mainTarget.position.z
	local y1 = self.mainTarget.position.y
	local x2 = self.target.position.x
	local z2 = self.target.position.z
	local y2 = self.target.position.y
	local dis = math.sqrt((x1-x2)*(x1-x2) + (z1-z2)*(z1-z2))
	if dis < minDis then
		dis = minDis
	end
	if dis > maxDis then
		dis = maxDis
	end

	local p = (dis - minDis) / (maxDis - minDis)
	local bodyScreenY = minBodyScreenY + (maxBodyScreenY - minBodyScreenY) * p
	local aniScreenY = minAimScreenY + (maxAimScreenY - minAimScreenY) * p
	--self.framingTransposer.m_ScreenY = bodyScreenY
	--self.cinemachineComposer.m_ScreenY = aniScreenY

	local deadZoneHeight = minAimDeadZoneHeight + (maxAimDeadZoneHeight - minAimDeadZoneHeight) * p
	--self.cinemachineComposer.m_DeadZoneHeight = deadZoneHeight
	local softZoneHeight = minAimSoftZoneHeight + (maxAimSoftZoneHeight - minAimSoftZoneHeight) * p
	--self.cinemachineComposer.m_SoftZoneHeight = softZoneHeight

	local deadZoneWidth = minAimDeadZoneWidth + (maxAimDeadZoneWidth - minAimDeadZoneWidth) * p
	--self.cinemachineComposer.m_DeadZoneWidth = deadZoneWidth
	local softZoneWidth = minAimSoftZoneWidth + (maxAimSoftZoneWidth - minAimSoftZoneWidth) * p
	--self.cinemachineComposer.m_SoftZoneWidth = softZoneWidth

	local cameraDistance = minCameraDistance + (maxCameraDistance - minCameraDistance) * p
	local offset = 1
	local yDif = math.max(y2-y1,0)
	if yDif < minYdif then
		yDif = minYdif
	end
	if yDif > maxYdif then
		yDif = maxYdif
	end
	local yp = (yDif - minYdif) / (maxYdif - minYdif)
	
	
	local ydifAimScreenY = minYdifAimScreenY + (maxYdifAimScreenY - minYdifAimScreenY) * yp
	self.cinemachineComposer.m_ScreenY = aniScreenY + ydifAimScreenY
	
	local ydifAimDeadZoneHeight = minYdifAimDeadZoneHeight + (maxYdifAimDeadZoneHeight - minYdifAimDeadZoneHeight) * yp
	self.cinemachineComposer.m_DeadZoneHeight = deadZoneHeight + ydifAimDeadZoneHeight
	
	local ydifAimSoftZoneHeight = minYdifAimSoftZoneHeight + (maxYdifAimSoftZoneHeight - minYdifAimSoftZoneHeight) * yp
	self.cinemachineComposer.m_SoftZoneHeight = softZoneHeight + ydifAimSoftZoneHeight
	
	local ydifAimDeadZoneWidth = minYdifAimDeadZoneWidth + (maxYdifAimDeadZoneWidth - minYdifAimDeadZoneWidth) * yp
	self.cinemachineComposer.m_DeadZoneWidth = deadZoneWidth + ydifAimDeadZoneWidth
	
	local ydifAimSoftZoneWidth = minYdifAimSoftZoneWidth + (maxYdifAimSoftZoneWidth - minYdifAimSoftZoneWidth) * yp
	self.cinemachineComposer.m_SoftZoneWidth = softZoneWidth + ydifAimSoftZoneWidth
	
	local ydifBodyScreenY = minYdifBodyScreenY + (maxYdifBodyScreenY - minYdifBodyScreenY) * yp
	self.framingTransposer.m_ScreenY = bodyScreenY + ydifBodyScreenY
	
	local yCameraDistance = minYCameraDistance + (maxYCameraDistance - minYCameraDistance) * yp
	
	self.framingTransposer.m_CameraDistance = cameraDistance + yDif * 0.5 + yCameraDistance
	
	
	--self.customLockCameraY.m_YMinPosition
	--self.customLockCameraY.m_YMaxPosition

	--if dis < 3 then
		----self.framingTransposer.m_XDamping = 9999
		--self.framingTransposer.m_YDamping = 9999
		----self.framingTransposer.m_ZDamping = 9999
		--self.cinemachineComposer.m_VerticalDamping = 9999
	--else
		----self.framingTransposer.m_XDamping = 0.1
		--self.framingTransposer.m_YDamping = 0.1
		----self.framingTransposer.m_ZDamping = 0.1
		--self.cinemachineComposer.m_VerticalDamping = 0.1
	--end

end

function ForceLockingCamera:SetCameraParams(id,coverDefult)
	if not self.defult or coverDefult then
		self.defult = id
	end
	if id == nil then
		id = self.defult
	end
	--do return end
	if not id then
		return
	end
	local params = Config.CameraParams[id]
	if not params then
		return
	end
	maxDis = params.MaxDis
	minBodyScreenY = params.MinBodyScreenY
	maxBodyScreenY = params.MaxBodyScreenY
	minAimScreenY = params.MinAimScreenY
	maxAimScreenY = params.MaxAimScreenY
	minAimDeadZoneHeight = params.MinAimDeadZoneHeight
	maxAimDeadZoneHeight = params.MaxAimDeadZoneHeight
	minAimSoftZoneHeight = params.MinAimSoftZoneHeight
	maxAimSoftZoneHeight = params.MaxAimSoftZoneHeight
	minAimDeadZoneWidth = params.MinAimDeadZoneWidth
	maxAimDeadZoneWidth = params.MaxAimDeadZoneWidth
	minAimSoftZoneWidth = params.MinAimSoftZoneWidth
	maxAimSoftZoneWidth = params.MaxAimSoftZoneWidth
	minCameraDistance = params.MinCameraDistance
	maxCameraDistance = params.MaxCameraDistance
	
	minYdif = params.MinYdif
	maxYdif = params.MaxYdif
	minYCameraDistance = params.MinYCameraDistance
	maxYCameraDistance = params.MaxYCameraDistance
	minYdifAimScreenY = params.MinYdifAimScreenY
	maxYdifAimScreenY = params.MaxYdifAimScreenY
	minYdifAimDeadZoneHeight = params.MinYdifAimDeadZoneHeight
	maxYdifAimDeadZoneHeight = params.MaxYdifAimDeadZoneHeight
	minYdifAimSoftZoneHeight = params.MinYdifAimSoftZoneHeight
	maxYdifAimSoftZoneHeight = params.MaxYdifAimSoftZoneHeight
	minYdifAimDeadZoneWidth = params.MinYdifAimDeadZoneWidth
	maxYdifAimDeadZoneWidth = params.MaxYdifAimDeadZoneWidth
	minYdifAimSoftZoneWidth = params.MinYdifAimSoftZoneWidth
	maxYdifAimSoftZoneWidth = params.MaxYdifAimSoftZoneWidth
	minCameraYPosition = params.MinCameraYPosition
	maxCameraYPosition = params.MaxCameraYPosition
	
	minYdifBodyScreenY = params.MinYdifBodyScreenY
	maxYdifBodyScreenY = params.MaxYdifBodyScreenY
	
	self.customLockCameraY.m_YMinPosition = params.MinCameraYPosition
	self.customLockCameraY.m_YMaxPosition = params.MaxCameraYPosition
	
	self.customLockCameraY.enabled  = params.EnableMinCameraYPosition
end

function ForceLockingCamera:OnEnter()
	self.cameraParent.gameObject:SetActive(true)
	self.startBodyXDamping = self.framingTransposer.m_XDamping
	self.startBodyYDamping = self.framingTransposer.m_YDamping
	self.startBodyZDamping = self.framingTransposer.m_ZDamping
	self.startHDamping = self.cinemachineComposer.m_HorizontalDamping
	self.startVDamping = self.cinemachineComposer.m_VerticalDamping
	self:SetCameraParams()
end

function ForceLockingCamera:OnLeave()
	self.cameraParent.gameObject:SetActive(false)
	self.target = nil
	--self.defult = nil
end

function ForceLockingCamera:SetNoise(type,amplitud,frequency,resetTime)
	self.noise:SetNoise(type,amplitud,frequency,resetTime)
end

function ForceLockingCamera:SetSoftZone(unlimited)
	self.framingTransposer.m_UnlimitedSoftZone = unlimited
end

function ForceLockingCamera:SetBodyDamping(x,y,z)
	self.framingTransposer.m_XDamping = x
	self.framingTransposer.m_YDamping = y
	self.framingTransposer.m_ZDamping = z
end

function ForceLockingCamera:SetDefaulBodyDamping()
	self.framingTransposer.m_XDamping = self.m_XDamping
	self.framingTransposer.m_YDamping = self.m_YDamping
	self.framingTransposer.m_ZDamping = self.m_ZDamping
end

function ForceLockingCamera:__delete()
end