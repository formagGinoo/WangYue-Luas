LevelCamera = BaseClass("LevelCamera", CameraMachineBase)

local minDis
local maxDis
local minBodyScreenY
local maxBodyScreenY
local minAimScreenY
local maxAimScreenY
local minAimDeadZoneHeight
local maxAimDeadZoneHeight
local minAimSoftZoneHeight
local maxAimSoftZoneHeight
local minAimDeadZoneWidth
local maxAimDeadZoneWidth
local minAimSoftZoneWidth
local maxAimSoftZoneWidth

--最小最大镜头水平/高度距离偏差
local minCameraDistance
local maxCameraDistance
local minCameraYPosition
local maxCameraYPosition

--高度差Aim相关参数
local minYdif
local maxYdif
local minYCameraDistance
local maxYCameraDistance
local minYdifAimScreenY
local maxYdifAimScreenY
local minYdifAimDeadZoneHeight
local maxYdifAimDeadZoneHeight
local minYdifAimSoftZoneHeight
local maxYdifAimSoftZoneHeight
local minYdifAimDeadZoneWidth
local maxYdifAimDeadZoneWidth
local minYdifAimSoftZoneWidth
local maxYdifAimSoftZoneWidth

local minYdifBodyScreenY
local maxYdifBodyScreenY

function LevelCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.camera = nil
	self.brainSet = false
end

function LevelCamera:SetCamera(instanceId)
	if not instanceId then
		self.cameraManager:SetCameraState(FightEnum.CameraState.Operating)
		return false
	end

    local entity = BehaviorFunctions.GetEntity(instanceId)
    if not entity then
        self.cameraManager:SetCameraState(FightEnum.CameraState.Operating)
        return false
    end

    local transform = entity.clientEntity.clientTransformComponent.transform
    self.cameraParent = transform
    for i = 0, transform.childCount - 1 do
        local go = transform:GetChild(i)
        if not self.camera and go.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera) then
            self.camera = go
		elseif not self.brainSet and go.gameObject:GetComponent(Cinemachine.CinemachineBrain) then
			local brain = go.gameObject:GetComponent(Cinemachine.CinemachineBrain)
			CustomUnityUtils.MergeCustomBlend(self.cameraManager.cinemachineBrain, brain)
			brain.enabled = false
			self.brainSet = true
        end

		if self.camera and self.brainSet then
			break
		end
    end

    if not self.camera then
        self:ResetCamera()
        return false
    end

    CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)

	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	self.cinemachineComposer = CinemachineInterface.GetComposer(self.camera)
	self.customLockCameraY = CinemachineInterface.GetCustomLockCameraY(self.camera)

	self.m_XDamping = self.framingTransposer.m_XDamping
	self.m_YDamping = self.framingTransposer.m_YDamping
	self.m_ZDamping = self.framingTransposer.m_ZDamping

	self.mainTarget = self.cinemachineCamera.m_Follow
	self.target = self.cinemachineCamera.m_LookAt

	self:InitLevelCameraParam()

    return true
end

function LevelCamera:InitLevelCameraParam()
	minBodyScreenY = self.framingTransposer.m_ScreenY / 2
	maxBodyScreenY = self.framingTransposer.m_ScreenY / 2
	minAimScreenY = self.cinemachineComposer.m_ScreenY / 2
	maxAimScreenY = self.cinemachineComposer.m_ScreenY / 2
	minAimDeadZoneHeight = self.cinemachineComposer.m_DeadZoneHeight / 2
	maxAimDeadZoneHeight = self.cinemachineComposer.m_DeadZoneHeight / 2
	minAimSoftZoneHeight = self.cinemachineComposer.m_SoftZoneHeight / 2
	maxAimSoftZoneHeight = self.cinemachineComposer.m_SoftZoneHeight / 2
	minAimDeadZoneWidth = self.cinemachineComposer.m_DeadZoneWidth / 2
	maxAimDeadZoneWidth = self.cinemachineComposer.m_DeadZoneWidth / 2
	minAimSoftZoneWidth = self.cinemachineComposer.m_SoftZoneWidth / 2
	maxAimSoftZoneWidth = self.cinemachineComposer.m_SoftZoneWidth / 2

	--最小最大镜头水平/高度距离偏差
	minCameraDistance = self.framingTransposer.m_CameraDistance / 2
	maxCameraDistance = self.framingTransposer.m_CameraDistance / 2

	--高度差Aim相关参数
	minYCameraDistance = self.framingTransposer.m_CameraDistance / 2
	maxYCameraDistance = self.framingTransposer.m_CameraDistance / 2
	minYdifAimScreenY = self.cinemachineComposer.m_ScreenY / 2
	maxYdifAimScreenY = self.cinemachineComposer.m_ScreenY / 2
	minYdifAimDeadZoneHeight = self.cinemachineComposer.m_DeadZoneWidth / 2
	maxYdifAimDeadZoneHeight = self.cinemachineComposer.m_DeadZoneWidth / 2
	minYdifAimSoftZoneHeight = self.cinemachineComposer.m_SoftZoneHeight / 2
	maxYdifAimSoftZoneHeight = self.cinemachineComposer.m_SoftZoneHeight / 2
	minYdifAimDeadZoneWidth = self.cinemachineComposer.m_DeadZoneWidth / 2
	maxYdifAimDeadZoneWidth = self.cinemachineComposer.m_DeadZoneWidth / 2
	minYdifAimSoftZoneWidth = self.cinemachineComposer.m_SoftZoneWidth / 2
	maxYdifAimSoftZoneWidth = self.cinemachineComposer.m_SoftZoneWidth / 2

	minYdifBodyScreenY = self.framingTransposer.m_ScreenY / 2
	maxYdifBodyScreenY = self.framingTransposer.m_ScreenY / 2
end

function LevelCamera:ResetCamera()
    self.cameraParent = nil
    self.camera = nil
	self.brainSet = false
    self.noise = nil
    self.cinemachineCamera = nil
    self.framingTransposer = nil
	self.cinemachineComposer = nil
	self.customLockCameraY = nil

    self.m_XDamping = nil
	self.m_YDamping = nil
	self.m_ZDamping = nil

	self:ResetLevelCameraParam()
end

function LevelCamera:ResetLevelCameraParam()
	minDis = nil
	maxDis = nil
	minBodyScreenY = nil
	maxBodyScreenY = nil
	minAimScreenY = nil
	maxAimScreenY = nil
	minAimDeadZoneHeight = nil
	maxAimDeadZoneHeight = nil
	minAimSoftZoneHeight = nil
	maxAimSoftZoneHeight = nil
	minAimDeadZoneWidth = nil
	maxAimDeadZoneWidth = nil
	minAimSoftZoneWidth = nil
	maxAimSoftZoneWidth = nil

	minCameraDistance = nil
	maxCameraDistance = nil
	minCameraYPosition = nil
	maxCameraYPosition = nil

	minYdif = nil
	maxYdif = nil
	minYCameraDistance = nil
	maxYCameraDistance = nil
	minYdifAimScreenY = nil
	maxYdifAimScreenY = nil
	minYdifAimDeadZoneHeight = nil
	maxYdifAimDeadZoneHeight = nil
	minYdifAimSoftZoneHeight = nil
	maxYdifAimSoftZoneHeight = nil
	minYdifAimDeadZoneWidth = nil
	maxYdifAimDeadZoneWidth = nil
	minYdifAimSoftZoneWidth = nil
	maxYdifAimSoftZoneWidth = nil

	minYdifBodyScreenY = nil
	maxYdifBodyScreenY = nil
end

function LevelCamera:SetMainTarget(target)
	self.mainTarget = target
	self.cinemachineCamera.m_Follow = target
end

function LevelCamera:SetTarget(target)
	if UtilsBase.IsNull(target) then
		LogError("SetTarget nil!")
		return
	end
	self.target = target
	self.cinemachineCamera.m_LookAt = self.target
end

function LevelCamera:Update()
	if UtilsBase.IsNull(self.target) then
		return
	end

	self:UpdateCenter()

	-- local targetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.target.position)
	-- local mainTargetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.mainTarget.position)
	-- if mainTargetPoint.z > targetPoint.z then
	-- 	if Vector3.Cross(self.cameraManager.mainCamera.transform.forward, self.target.position).y > 0 then
	-- 		self.framingTransposer.m_ScreenX = 0.475
	-- 	else--left
	-- 		self.framingTransposer.m_ScreenX = 0.525
	-- 	end
	-- else
	-- 	self.framingTransposer.m_ScreenX = 0.5
	-- end

	do return end
	if UtilsBase.IsNull(self.target) then
		return
	end
	local pos = self.target.position
	if pos.y - 0.5 < self.mainTarget.position.y then
		pos.y = self.mainTarget.position.y + 0.5
	end
end

function LevelCamera:UpdateCenter()
	local p = 1
	local yp = 1

	if minDis and maxDis then
		local x1 = self.mainTarget.position.x
		local z1 = self.mainTarget.position.z
		local x2 = self.target.position.x
		local z2 = self.target.position.z
		local dis = math.sqrt((x1-x2)*(x1-x2) + (z1-z2)*(z1-z2))
		if dis < minDis then
			dis = minDis
		end
		if dis > maxDis then
			dis = maxDis
		end

		p = (dis - minDis) / (maxDis - minDis)
	end

	local y1 = self.mainTarget.position.y
	local y2 = self.target.position.y
	local yDif = math.max(y2 - y1,0)
	if minYdif and maxYdif then
		if yDif < minYdif then
			yDif = minYdif
		end
		if yDif > maxYdif then
			yDif = maxYdif
		end

		yp = (yDif - minYdif) / (maxYdif - minYdif)
	end

	local bodyScreenY = minBodyScreenY + (maxBodyScreenY - minBodyScreenY) * p
	local aniScreenY = minAimScreenY + (maxAimScreenY - minAimScreenY) * p
	local deadZoneHeight = minAimDeadZoneHeight + (maxAimDeadZoneHeight - minAimDeadZoneHeight) * p
	local softZoneHeight = minAimSoftZoneHeight + (maxAimSoftZoneHeight - minAimSoftZoneHeight) * p
	local deadZoneWidth = minAimDeadZoneWidth + (maxAimDeadZoneWidth - minAimDeadZoneWidth) * p
	local softZoneWidth = minAimSoftZoneWidth + (maxAimSoftZoneWidth - minAimSoftZoneWidth) * p
	local cameraDistance = minCameraDistance + (maxCameraDistance - minCameraDistance) * p

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
end

function LevelCamera:SetCameraParams(params)
	minDis = params.MinDis and params.MinDis or minDis
	maxDis = params.MaxDis and params.MaxDis or maxDis
	minBodyScreenY = params.MinBodyScreenY and params.MinBodyScreenY or minBodyScreenY
	maxBodyScreenY = params.MaxBodyScreenY and params.MaxBodyScreenY or maxBodyScreenY
	minAimScreenY = params.MinAimScreenY and params.MinAimScreenY or minAimScreenY
	maxAimScreenY = params.MaxAimScreenY and params.MaxAimScreenY or maxAimScreenY
	minAimDeadZoneHeight = params.MinAimDeadZoneHeight and params.MinAimDeadZoneHeight or minAimDeadZoneHeight
	maxAimDeadZoneHeight = params.MaxAimDeadZoneHeight and params.MaxAimDeadZoneHeight or maxAimDeadZoneHeight
	minAimSoftZoneHeight = params.MinAimSoftZoneHeight and params.MinAimSoftZoneHeight or minAimSoftZoneHeight
	maxAimSoftZoneHeight = params.MaxAimSoftZoneHeight and params.MaxAimSoftZoneHeight or maxAimSoftZoneHeight
	minAimDeadZoneWidth = params.MinAimDeadZoneWidth and params.MinAimDeadZoneWidth or minAimDeadZoneWidth
	maxAimDeadZoneWidth = params.MaxAimDeadZoneWidth and params.MaxAimDeadZoneWidth or maxAimDeadZoneWidth
	minAimSoftZoneWidth = params.MinAimSoftZoneWidth and params.MinAimSoftZoneWidth or minAimSoftZoneWidth
	maxAimSoftZoneWidth = params.MaxAimSoftZoneWidth and params.MaxAimSoftZoneWidth or maxAimSoftZoneWidth
	minCameraDistance = params.MinCameraDistance and params.MinCameraDistance or minCameraDistance
	maxCameraDistance = params.MaxCameraDistance and params.MaxCameraDistance or maxCameraDistance

	minYdif = params.MinYdif and params.MinYdif or minYdif
	maxYdif = params.MaxYdif and params.MaxYdif or maxYdif
	minYCameraDistance = params.MinYCameraDistance and params.MinYCameraDistance or minYCameraDistance
	maxYCameraDistance = params.MaxYCameraDistance and params.MaxYCameraDistance or maxYCameraDistance
	minYdifAimScreenY = params.MinYdifAimScreenY and params.MinYdifAimScreenY or minYdifAimScreenY
	maxYdifAimScreenY = params.MaxYdifAimScreenY and params.MaxYdifAimScreenY or maxYdifAimScreenY
	minYdifAimDeadZoneHeight = params.MinYdifAimDeadZoneHeight and params.MinYdifAimDeadZoneHeight or minYdifAimDeadZoneHeight
	maxYdifAimDeadZoneHeight = params.MaxYdifAimDeadZoneHeight and params.MaxYdifAimDeadZoneHeight or maxYdifAimDeadZoneHeight
	minYdifAimSoftZoneHeight = params.MinYdifAimSoftZoneHeight and params.MinYdifAimSoftZoneHeight or minYdifAimSoftZoneHeight
	maxYdifAimSoftZoneHeight = params.MaxYdifAimSoftZoneHeight and params.MaxYdifAimSoftZoneHeight or maxYdifAimSoftZoneHeight
	minYdifAimDeadZoneWidth = params.MinYdifAimDeadZoneWidth and params.MinYdifAimDeadZoneWidth or minYdifAimDeadZoneWidth
	maxYdifAimDeadZoneWidth = params.MaxYdifAimDeadZoneWidth and params.MaxYdifAimDeadZoneWidth or maxYdifAimDeadZoneWidth
	minYdifAimSoftZoneWidth = params.MinYdifAimSoftZoneWidth and params.MinYdifAimSoftZoneWidth or minYdifAimSoftZoneWidth
	maxYdifAimSoftZoneWidth = params.MaxYdifAimSoftZoneWidth and params.MaxYdifAimSoftZoneWidth or maxYdifAimSoftZoneWidth
	minCameraYPosition = params.MinCameraYPosition and params.MinCameraYPosition or minCameraYPosition
	maxCameraYPosition = params.MaxCameraYPosition and params.MaxCameraYPosition or maxCameraYPosition

	minYdifBodyScreenY = params.MinYdifBodyScreenY and params.MinYdifBodyScreenY or minYdifBodyScreenY
	maxYdifBodyScreenY = params.MaxYdifBodyScreenY and params.MaxYdifBodyScreenY or maxYdifBodyScreenY

    if self.customLockCameraY then
        self.customLockCameraY.m_YMinPosition = params.MinCameraYPosition and params.MinCameraYPosition or self.customLockCameraY.m_YMinPosition
        self.customLockCameraY.m_YMaxPosition = params.MaxCameraYPosition and params.MaxCameraYPosition or self.customLockCameraY.m_YMaxPosition
        self.customLockCameraY.enabled  = params.EnableMinCameraYPosition and params.EnableMinCameraYPosition or self.customLockCameraY.enabled
    end

	if params.Fov then
		local lens = self.cinemachineCamera.m_Lens
		lens.FieldOfView = params.Fov
		self.cinemachineCamera.m_Lens = lens
	end

    self:Update()
end

function LevelCamera:GetCameraParam()
    local params = {
        MinDis = minDis,
        MaxDis = maxDis,
        MinBodyScreenY = minBodyScreenY,
        MaxBodyScreenY = maxBodyScreenY,
        MinAimScreenY = minAimScreenY,
        MaxAimScreenY = maxAimScreenY,
        MinAimDeadZoneHeight = minAimDeadZoneHeight,
        MaxAimDeadZoneHeight = maxAimDeadZoneHeight,
        MinAimSoftZoneHeight = minAimSoftZoneHeight,
        MaxAimSoftZoneHeight = maxAimSoftZoneHeight,
        MinAimDeadZoneWidth = minAimDeadZoneWidth,
        MaxAimDeadZoneWidth = maxAimDeadZoneWidth,
        MinAimSoftZoneWidth = minAimSoftZoneWidth,
        MaxAimSoftZoneWidth = maxAimSoftZoneWidth,
        MinCameraDistance = minCameraDistance,
        MaxCameraDistance = maxCameraDistance,
        MinYCameraDistance = minYCameraDistance,
        MaxYCameraDistance = maxYCameraDistance,
        EnableMinCameraYPosition = self.customLockCameraY and self.customLockCameraY.enabled or tostring(false),
        MinCameraYPosition = self.customLockCameraY and self.customLockCameraY.m_YMinPosition or 0,
        MaxCameraYPosition = self.customLockCameraY and self.customLockCameraY.m_YMaxPosition or 0,
        MinYdif = minYdif,
        MaxYdif = maxYdif,
        MinYdifBodyScreenY = minYdifBodyScreenY,
        MaxYdifBodyScreenY = maxYdifBodyScreenY,
        MinYdifAimScreenY = minYdifAimScreenY,
        MaxYdifAimScreenY = maxYdifAimScreenY,
        MinYdifAimDeadZoneHeight = minYdifAimDeadZoneHeight,
        MaxYdifAimDeadZoneHeight = maxYdifAimDeadZoneHeight,
        MinYdifAimSoftZoneHeight = minYdifAimSoftZoneHeight,
        MaxYdifAimSoftZoneHeight = maxYdifAimSoftZoneHeight,
        MinYdifAimDeadZoneWidth = minYdifAimDeadZoneWidth,
        MaxYdifAimDeadZoneWidth = maxYdifAimDeadZoneWidth,
        MinYdifAimSoftZoneWidth = minYdifAimSoftZoneWidth,
        MaxYdifAimSoftZoneWidth = maxYdifAimSoftZoneWidth,
    }

    return params
end

function LevelCamera:OnEnter()

end

function LevelCamera:OnLeave()
	self.target = nil
    self:ResetCamera()
end

function LevelCamera:SetNoise(type,amplitud,frequency,resetTime)
	self.noise:SetNoise(type,amplitud,frequency,resetTime)
end

function LevelCamera:SetSoftZone(unlimited)
	self.framingTransposer.m_UnlimitedSoftZone = unlimited
end

function LevelCamera:SetBodyDamping(x,y,z)
	self.framingTransposer.m_XDamping = x
	self.framingTransposer.m_YDamping = y
	self.framingTransposer.m_ZDamping = z
end

function LevelCamera:SetDefaulBodyDamping()
	self.framingTransposer.m_XDamping = self.m_XDamping
	self.framingTransposer.m_YDamping = self.m_YDamping
	self.framingTransposer.m_ZDamping = self.m_ZDamping
end

function LevelCamera:__delete()
end