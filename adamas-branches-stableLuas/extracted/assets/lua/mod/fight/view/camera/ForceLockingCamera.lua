ForceLockingCamera = BaseClass("ForceLockingCamera",CameraMachineBase)
local editor = ctx.Editor

function ForceLockingCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("ForceLocking")
	self.camera = self.cameraParent:Find("ForceLockingCamera")
	self.targetGroupTransform = self.cameraParent:Find("TargetGroup").transform
	self.targetGroup = self.targetGroupTransform:GetComponent(CinemachineTargetGroup)
	self.lookAtTargetGroupTransform = self.cameraParent:Find("LookAtTargetGroup").transform
	self.lookAtTargetGroup = self.lookAtTargetGroupTransform:GetComponent(CinemachineTargetGroup)
	--self.noise = CinemachineInterface.GetNoise(self.camera)
	--self.noise = self.cameraManager.noise
	CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	-- self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	--self.targetGroup = self.cameraParent:Find("TargetGroup")--.gameObject:GetComponent(Cinemachine.CinemachineTargetGroup)
	--self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	--self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.cinemachineComposer = CinemachineInterface.GetComposer(self.camera)
	self.customLockCameraY = CinemachineInterface.GetCustomLockCameraY(self.camera)
	--self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	
	-- self:SetCameraMgrNoise()
	self.m_XDamping = self.framingTransposer.m_XDamping
	self.m_YDamping = self.framingTransposer.m_YDamping
	self.m_ZDamping = self.framingTransposer.m_ZDamping
	self.cinemachineCamera.m_Follow = self.targetGroupTransform
	self.cinemachineCamera.m_LookAt = self.lookAtTargetGroupTransform
	self.mainTarget = self.targetGroupTransform

	if editor then
		self.cameraRuntimeParms = self.camera.gameObject:AddComponent(CS.CinemachineLastParams)
	end
end

function ForceLockingCamera:SetCameraMgrNoise()
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cameraManager.noise = self.noise
end

function ForceLockingCamera:SetMainTarget(target)
	if self.groupMainTarget == target then
		return
	end
	--self.cinemachineCamera.m_Follow = target
	--self.cinemachineCamera.m_LookAt = target
	--if self.mainTarget then
	--self.targetGroup:RemoveMember(self.mainTarget)
	--end
	self.targetGroup:RemoveMember(self.groupMainTarget)
	self.targetGroup:AddMember(target,1,1)
	self.groupMainTarget = target
	--self.cinemachineCamera.m_Follow = target
	--if self.mainTarget then
	--self.targetGroup:RemoveMember(self.mainTarget)
	--end
	--self.mainTarget = target
	--self.targetGroup:AddMember(self.mainTarget,1,1)
end

function ForceLockingCamera:SetTarget(target)
	if UtilsBase.IsNull(target) then
		return
	end

	--self.cinemachineCamera.m_LookAt = self.target
	self.lookAtTargetGroup:RemoveMember(self.target)
	self.lookAtTargetGroup:AddMember(target,1,1)
	self.target = target
	--if self.target then
	--self.targetGroup:RemoveMember(self.target)
	--end
	--self.target = target
	--self.targetGroup:AddMember(self.target,1,1)
	--self.cinemachineCamera.m_LookAt = target
end

function ForceLockingCamera:AddFollowTarget(target)
	self.targetGroup:AddMember(target,1,1)
	self.target = self.targetGroupTransform
	--self.groupCount = self.groupCount + 1
end

function ForceLockingCamera:RemoveFollowTarget(target)
	self.targetGroup:RemoveMember(target)
	--self.groupCount = self.groupCount - 1
end

function ForceLockingCamera:SetFollowTargetWeight(target,weight)
	self.targetGroup:SetMemberWeight(target,weight)
end

function ForceLockingCamera:SetGroupPositionMode(mode)
	self.targetGroup.m_PositionMode = mode
end

function ForceLockingCamera:AddLookAtTarget(target)
	self.lookAtTargetGroup:AddMember(target,1,1)
end

function ForceLockingCamera:RemoveLookAtTarget(target)
	self.lookAtTargetGroup:RemoveMember(target)
end

function ForceLockingCamera:SetLookAtTargetWeight(target,weight)
	self.lookAtTargetGroup:SetMemberWeight(target,weight)
end

function ForceLockingCamera:RevertLookAtTarget()
	if not self.CacheLookAtMember then return end
	self.lookAtTargetGroup.m_Targets = self.CacheLookAtMember
	self.CacheLookAtMember = nil
end

function ForceLockingCamera:RevertFollowTarget()
	if not self.CacheFollowMember then return end
	self.targetGroup.m_Targets = self.CacheFollowMember
	self.CacheFollowMember = nil
end

function ForceLockingCamera:Update()
	-- if UtilsBase.IsNull(self.target) then
	-- 	return
	-- end

	self:UpdateCenter()
	self:UpdateCameraTransScreenInfo()

	if editor then
		self:UpdateCinemachineRuntimeParms()
	end
	-- if UtilsBase.IsNull(self.target) then
	-- 	return
	-- end
	-- do return end
	-- local pos = self.target.position
	-- if pos.y - 0.5 < self.mainTarget.position.y then
	-- 	pos.y = self.mainTarget.position.y + 0.5
	-- end
	-- self.targetGroup.transform.position = pos
end

function ForceLockingCamera:UpdateCameraTransScreenInfo()
	-- 存在参数时不直接设置参数 pv版本设置
	if self.cameraParams.MinBodyScreenX then
		return
	end

	local targetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.lookAtTargetGroupTransform.position)
	local mainTargetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.mainTarget.position)

	if mainTargetPoint.z > targetPoint.z then
		if Vector3.Cross(self.cameraManager.mainCamera.transform.forward, self.lookAtTargetGroupTransform.position).y > 0 then--right
			self.framingTransposer.m_ScreenX = 0.475
		else--left
			self.framingTransposer.m_ScreenX = 0.525
		end
	else
		self.framingTransposer.m_ScreenX = 0.5
	end
end

local minDis = 1
local maxDis = 6
local minBodyScreenY = 0.55
local maxBodyScreenY = 0.6
local minAimScreenY = 0.4
local maxAimScreenY = 0.35

local minBodyScreenX = 0.5
local maxBodyScreenX = 0.6
local minAimScreenX = 0.55
local maxAimScreenX = 0.4

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

local minXdifAimScreenX = 0
local maxXdifAimScreenX = 0.1


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

local minXdifBodyScreenX = 0
local maxXdifBodyScreenX = 0.1

function ForceLockingCamera:UpdateCenter()
	local x1 = self.mainTarget.position.x
	local z1 = self.mainTarget.position.z
	local y1 = self.mainTarget.position.y
	local x2 = self.lookAtTargetGroupTransform.position.x
	local z2 = self.lookAtTargetGroupTransform.position.z
	local y2 = self.lookAtTargetGroupTransform.position.y
	local dis
	if x1 and x2 and z1 and z2 then
		dis = math.sqrt((x1 - x2) * (x1 - x2) + (z1 - z2) * (z1 - z2))
	else
		LogError("计算出现错误，当前计算值为")
		print("x1 = ", x1, "x2 = ", x2, "z1 = ", z1, "z2 = ", z2)
	end
	if not dis then return end
	if not minDis or not maxDis then
		LogError("参数错误，当前参数配置id = ", self.cameraParamsId)
	end

	if dis < minDis then
		dis = minDis
	end
	if dis > maxDis then
		dis = maxDis
	end

	local p = (dis - minDis) / (maxDis - minDis)
	local bodyScreenY = minBodyScreenY + (maxBodyScreenY - minBodyScreenY) * p
	local bodyScreenX = minBodyScreenX + (maxBodyScreenX - minBodyScreenX) * p


	local aniScreenY = minAimScreenY + (maxAimScreenY - minAimScreenY) * p
	local aniScreenX = minAimScreenX + (maxAimScreenX - minAimScreenX) * p

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

	local xdifAimScreenX = minXdifAimScreenX + (maxXdifAimScreenX - minXdifAimScreenX) * yp
	self.cinemachineComposer.m_ScreenX = aniScreenX + xdifAimScreenX
	
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

	local xdifBodyScreenX = minXdifBodyScreenX + (maxXdifBodyScreenX - minXdifBodyScreenX) * yp
	self.framingTransposer.m_ScreenX = bodyScreenX + xdifBodyScreenX
	
	local yCameraDistance = minYCameraDistance + (maxYCameraDistance - minYCameraDistance) * yp
	
	self.framingTransposer.m_CameraDistance = cameraDistance + yDif * 0.5 + yCameraDistance
end

function ForceLockingCamera:SetGlideCameraParams(id)
	local params = Config.CameraParams[id]
	if not params then
		return
	end

	if params.XDamping then
		self.framingTransposer.m_XDamping = params.XDamping
	end
	if params.YDamping then
		self.framingTransposer.m_YDamping = params.YDamping
	end
	if params.ZDamping then
		self.framingTransposer.m_ZDamping = params.ZDamping
	end
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
	self.cameraParamsId = id
	self.cameraParams = params
	maxDis = params.MaxDis or maxDis
	minBodyScreenY = params.MinBodyScreenY or minBodyScreenY
	maxBodyScreenY = params.MaxBodyScreenY or maxBodyScreenY
	minAimScreenY = params.MinAimScreenY or minAimScreenY
	maxAimScreenY = params.MaxAimScreenY or maxAimScreenY

	minBodyScreenX = params.MinBodyScreenX or 0.5
	maxBodyScreenX = params.MaxBodyScreenX or 0.6
	minAimScreenX = params.MinAimScreenX or 0.55
	maxAimScreenX = params.MaxAimScreenX or 0.4

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

	minXdifAimScreenX = params.MinXdifAimScreenX or 0
	maxXdifAimScreenX = params.MaxXdifAimScreenX or 0.1

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
	
	if params.XDamping then
		self.framingTransposer.m_XDamping = params.XDamping
	end
	if params.YDamping then
		self.framingTransposer.m_YDamping = params.YDamping
	end
	if params.ZDamping then
		self.framingTransposer.m_ZDamping = params.ZDamping
	end
	self:ApplyCinemachineRuntimeParms()
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
	if x > 0 then
		self.framingTransposer.m_XDamping = x
	end
	if y > 0 then
		self.framingTransposer.m_YDamping = y
	end
	if z > 0 then
		self.framingTransposer.m_ZDamping = z
	end
end

function ForceLockingCamera:SetDefaulBodyDamping()
	self.framingTransposer.m_XDamping = self.m_XDamping
	self.framingTransposer.m_YDamping = self.m_YDamping
	self.framingTransposer.m_ZDamping = self.m_ZDamping
end

function ForceLockingCamera:SetTrackedOffset(x, y, z)
	local offset = self.framingTransposer.m_TrackedObjectOffset
	offset.x = offset.x + x
	offset.y = offset.y + y
	offset.z = offset.z + z
	self.framingTransposer.m_TrackedObjectOffset = offset
end

function ForceLockingCamera:SetComposerOffset(x, y, z)
	local offset = self.cinemachineComposer.m_TrackedObjectOffset
	offset.x = offset.x + x
	offset.y = offset.y + y
	offset.z = offset.z + z
	self.cinemachineComposer.m_TrackedObjectOffset = offset
end

function ForceLockingCamera:RemoveAllLookAtTarget()
	self.CacheLookAtMember = self.lookAtTargetGroup.m_Targets
	self.lookAtTargetGroup:RemoveAllMember()
end

function ForceLockingCamera:RemoveAllFollowTarget()
	self.CacheFollowMember = self.targetGroup.m_Targets
	self.targetGroup:RemoveAllMember()
end

function ForceLockingCamera:__delete()
end

-- 方便测试pv修改相机参数
function ForceLockingCamera:ApplyCinemachineRuntimeParms()
	if not self.cameraRuntimeParms then return end
	local params = self.cameraParams
	local cameraRuntimeParms = self.cameraRuntimeParms
	cameraRuntimeParms.ConfigId = self.cameraParamsId
	cameraRuntimeParms.MinDis = params.MinDis or minDis
	cameraRuntimeParms.MaxDis = params.MaxDis or maxDis
	cameraRuntimeParms.MinBodyScreenY = params.MinBodyScreenY
	cameraRuntimeParms.MaxBodyScreenY = params.MaxBodyScreenY
	cameraRuntimeParms.MinAimScreenY = params.MinAimScreenY
	cameraRuntimeParms.MaxAimScreenY = params.MaxAimScreenY

	cameraRuntimeParms.MinBodyScreenX = params.MinBodyScreenX or minBodyScreenX
	cameraRuntimeParms.MaxBodyScreenX = params.MaxBodyScreenX or maxBodyScreenX
	cameraRuntimeParms.MinAimScreenX = params.MinAimScreenX or minAimScreenX
	cameraRuntimeParms.MaxAimScreenX = params.MaxAimScreenX or maxAimScreenX

	cameraRuntimeParms.MinXdifAimScreenX = params.MinXdifAimScreenX
	cameraRuntimeParms.MaxXdifAimScreenX = params.MaxXdifAimScreenX
	cameraRuntimeParms.MinAimDeadZoneHeight = params.MinAimDeadZoneHeight
	cameraRuntimeParms.MaxAimDeadZoneHeight = params.MaxAimDeadZoneHeight
	cameraRuntimeParms.MinAimSoftZoneHeight = params.MinAimSoftZoneHeight
	cameraRuntimeParms.MaxAimSoftZoneHeight = params.MaxAimSoftZoneHeight
	cameraRuntimeParms.MinAimDeadZoneWidth = params.MinAimDeadZoneWidth
	cameraRuntimeParms.MaxAimDeadZoneWidth = params.MaxAimDeadZoneWidth
	cameraRuntimeParms.MinAimSoftZoneWidth = params.MinAimSoftZoneWidth
	cameraRuntimeParms.MaxAimSoftZoneWidth = params.MaxAimSoftZoneWidth

	cameraRuntimeParms.MinCameraDistance = params.MinCameraDistance
	cameraRuntimeParms.MaxCameraDistance = params.MaxCameraDistance

	cameraRuntimeParms.MinYCameraDistance = params.MinYCameraDistance
	cameraRuntimeParms.MaxYCameraDistance = params.MaxYCameraDistance

	cameraRuntimeParms.EnableMinCameraYPosition = params.EnableMinCameraYPosition
	cameraRuntimeParms.MinCameraYPosition = params.MinCameraYPosition
	cameraRuntimeParms.MaxCameraYPosition = params.MaxCameraYPosition

	cameraRuntimeParms.MinYdif = params.MinYdif
	cameraRuntimeParms.MaxYdif = params.MaxYdif
	cameraRuntimeParms.MinYdifBodyScreenY = params.MinYdifBodyScreenY
	cameraRuntimeParms.MaxYdifBodyScreenY = params.MaxYdifBodyScreenY
	cameraRuntimeParms.MinYdifAimScreenY = params.MinYdifAimScreenY
	cameraRuntimeParms.MaxYdifAimScreenY = params.MaxYdifAimScreenY
	cameraRuntimeParms.MinYdifAimDeadZoneHeight = params.MinYdifAimDeadZoneHeight
	cameraRuntimeParms.MaxYdifAimDeadZoneHeight = params.MaxYdifAimDeadZoneHeight
	cameraRuntimeParms.MinYdifAimSoftZoneHeight = params.MinYdifAimSoftZoneHeight
	cameraRuntimeParms.MaxYdifAimSoftZoneHeight = params.MaxYdifAimSoftZoneHeight
	cameraRuntimeParms.MinYdifAimDeadZoneWidth = params.MinYdifAimDeadZoneWidth
	cameraRuntimeParms.MaxYdifAimDeadZoneWidth = params.MaxYdifAimDeadZoneWidth
	cameraRuntimeParms.MinYdifAimSoftZoneWidth = params.MinYdifAimSoftZoneWidth
	cameraRuntimeParms.MaxYdifAimSoftZoneWidth = params.MaxYdifAimSoftZoneWidth

	cameraRuntimeParms.MinXdifBodyScreenX = params.MinXdifBodyScreenX or minXdifBodyScreenX
	cameraRuntimeParms.MaxXdifBodyScreenX = params.MaxXdifBodyScreenX or maxXdifBodyScreenX
end

function ForceLockingCamera:UpdateCinemachineRuntimeParms()
	if not self.cameraRuntimeParms then return end
	local cameraRuntimeParms = self.cameraRuntimeParms
	if cameraRuntimeParms.ConfigId == 0 then return end

	if cameraRuntimeParms.ConfigId ~= self.cameraParamsId then
		self:SetCameraParams(cameraRuntimeParms.ConfigId)
		return
	end

	maxDis = cameraRuntimeParms.MaxDis
	minBodyScreenY = cameraRuntimeParms.MinBodyScreenY or minBodyScreenY
	maxBodyScreenY = cameraRuntimeParms.MaxBodyScreenY or maxBodyScreenY
	minAimScreenY = cameraRuntimeParms.MinAimScreenY or minAimScreenY
	maxAimScreenY = cameraRuntimeParms.MaxAimScreenY or maxAimScreenY

	minBodyScreenX = cameraRuntimeParms.MinBodyScreenX or minBodyScreenX
	maxBodyScreenX = cameraRuntimeParms.MaxBodyScreenX or maxBodyScreenX
	minAimScreenX = cameraRuntimeParms.MinAimScreenX or minAimScreenX
	maxAimScreenX = cameraRuntimeParms.MaxAimScreenX or maxAimScreenX

	minAimDeadZoneHeight = cameraRuntimeParms.MinAimDeadZoneHeight
	maxAimDeadZoneHeight = cameraRuntimeParms.MaxAimDeadZoneHeight
	minAimSoftZoneHeight = cameraRuntimeParms.MinAimSoftZoneHeight
	maxAimSoftZoneHeight = cameraRuntimeParms.MaxAimSoftZoneHeight
	minAimDeadZoneWidth = cameraRuntimeParms.MinAimDeadZoneWidth
	maxAimDeadZoneWidth = cameraRuntimeParms.MaxAimDeadZoneWidth
	minAimSoftZoneWidth = cameraRuntimeParms.MinAimSoftZoneWidth
	maxAimSoftZoneWidth = cameraRuntimeParms.MaxAimSoftZoneWidth
	minCameraDistance = cameraRuntimeParms.MinCameraDistance
	maxCameraDistance = cameraRuntimeParms.MaxCameraDistance
	
	minYdif = cameraRuntimeParms.MinYdif
	maxYdif = cameraRuntimeParms.MaxYdif
	minYCameraDistance = cameraRuntimeParms.MinYCameraDistance
	maxYCameraDistance = cameraRuntimeParms.MaxYCameraDistance

	minYdifAimScreenY = cameraRuntimeParms.MinYdifAimScreenY
	maxYdifAimScreenY = cameraRuntimeParms.MaxYdifAimScreenY

	minXdifAimScreenX = cameraRuntimeParms.MinXdifAimScreenX or 0
	maxXdifAimScreenX = cameraRuntimeParms.MaxXdifAimScreenX or 0.1

	minYdifAimDeadZoneHeight = cameraRuntimeParms.MinYdifAimDeadZoneHeight
	maxYdifAimDeadZoneHeight = cameraRuntimeParms.MaxYdifAimDeadZoneHeight
	minYdifAimSoftZoneHeight = cameraRuntimeParms.MinYdifAimSoftZoneHeight

	maxYdifAimSoftZoneHeight = cameraRuntimeParms.MaxYdifAimSoftZoneHeight
	minYdifAimDeadZoneWidth = cameraRuntimeParms.MinYdifAimDeadZoneWidth
	maxYdifAimDeadZoneWidth = cameraRuntimeParms.MaxYdifAimDeadZoneWidth
	minYdifAimSoftZoneWidth = cameraRuntimeParms.MinYdifAimSoftZoneWidth
	maxYdifAimSoftZoneWidth = cameraRuntimeParms.MaxYdifAimSoftZoneWidth
	minCameraYPosition = cameraRuntimeParms.MinCameraYPosition
	maxCameraYPosition = cameraRuntimeParms.MaxCameraYPosition
	
	minYdifBodyScreenY = cameraRuntimeParms.MinYdifBodyScreenY
	maxYdifBodyScreenY = cameraRuntimeParms.MaxYdifBodyScreenY

	minXdifBodyScreenX = cameraRuntimeParms.MinXdifBodyScreenX or minXdifBodyScreenX
	maxXdifBodyScreenX = cameraRuntimeParms.MaxXdifBodyScreenX or maxXdifBodyScreenX
end

function ForceLockingCamera:GetCurCameraDistance()
	return self.framingTransposer.m_CameraDistance
end