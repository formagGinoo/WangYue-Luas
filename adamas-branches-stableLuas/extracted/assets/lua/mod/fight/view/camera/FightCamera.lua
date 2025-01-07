FightCamera = BaseClass("FightCamera",CameraMachineBase)

local _abs = math.abs
local CameraBlendHitType = {
	None = 0,
	Spherical = 1,
	Cylindrical = 2,
	ScreenSpace = 3,
}

local CorrectEulerVal = 7
local editor = ctx.Editor
function FightCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("Fighting")
	self.camera = self.cameraParent:Find("FightingCamera")

    CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)

	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)

	self.aim = CinemachineInterface.GetComposer(self.camera.transform)
	self.body = CinemachineInterface.GetFramingTransposer(self.camera)
	self.cameraCollider = CinemachineInterface.GetCameraCollider(self.camera)
	if editor then
		self.cameraRuntimeParms = self.camera.gameObject:AddComponent(CS.CinemachineRuntimeParms)
	end

	self.followTargetGroup = self.cameraParent:Find("FollowTargetGroup")
	self.followTargetGroupCmp = self.followTargetGroup:GetComponent(CinemachineTargetGroup)
	self.lookAtTargetGroup = self.cameraParent:Find("LookAtTargetGroup")
	self.lookAtTargetGroupCmp = self.lookAtTargetGroup:GetComponent(CinemachineTargetGroup)

    self.bodyTrackedObjectOffset = Vector3(0,0,0)
    self.aimTrackedObjectOffset = Vector3(0,0,0)
	self.verticalOffset = false
	self.horizontaltOffset = false
	self.distancePrecentOffset = false
	self.isFixedVerticalDir = false
	self.isDefCorrect = true
end

function FightCamera:SetCameraMgrNoise()
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cameraManager.noise = self.noise
end

function FightCamera:SetMainTarget(target)
    if self.mainTarget == target then
		return
	end
	self.mainTarget = target
	self.followTargetGroupCmp:AddMember(self.mainTarget,1,1)
end

function FightCamera:SetTarget(target)
    if self.target == target then return end
    self.target = target
    --self.cinemachineCamera.m_LookAt = target
	self.lookAtTargetGroupCmp:AddMember(self.target,1,1)
end

function FightCamera:OnEnter()
    self.cameraParent.gameObject:SetActive(true)
    self.cinemachineCamera.gameObject:SetActive(true)
	if self.isDefCorrect then
		self:CorrectCameraParams()
	else
		self:SetCameraParams(Config.CameraConfig.DefFightCameraId)
	end
	self:SetBlendHint(CameraBlendHitType.Cylindrical)
	self:CheckCorrectCamera()
	self.cameraManager:SetIgnoreStopBlendState(true)
end

-- 首次进入战斗相机检查是否需要修正角度
function FightCamera:CheckCorrectCamera()
	if not self.target then return end
	-- 操作相机面向旋转
	local lookatTarget = self.target.transform
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(ctrlEntity)
	if not entity then return end
	local cameraPos = self.cameraManager.cameraTransform.position
	local targetPos = lookatTarget.transform.position
	local entityPos = entity.transformComponent.position

	local lastCamera = self.cameraManager:GetCamera(self.cameraManager.lastState)
	local lastCameraPos = lastCamera.camera.position
	local targetDir = Vec3.Normalize(lastCameraPos - targetPos)
	local roleDir = Vec3.Normalize(entityPos - targetPos)
	local eulerAngles = Vec3.Angle(targetDir, roleDir)
	if eulerAngles < 50 then
		-- 修正X轴
		self:SetCorrectEulerData(true, 0.8, CorrectEulerVal)
		return
	end

	local lookAtPos = (targetPos + entityPos) / 2
	-- local lookAtPos = self.lookAtTargetGroup.position
	local dot = Vec3.Cross(cameraPos - targetPos, targetPos - entityPos)
	local roleRotation = entity.clientTransformComponent.transform.rotation
	local x = lookAtPos.x - entityPos.x
	local y = lookAtPos.y - entityPos.y
	local z = lookAtPos.z - entityPos.z
	local lookAtRotate = Quat.LookRotationA(x,y,z)
	local rotation = Quat._RotateTowards(roleRotation, lookAtRotate, 1)
	local eulerAngles = rotation:ToEulerAngles()
	local angleY = eulerAngles.y
	local val = dot.y >= 0 and 50 or -50
	local targetVal = Quat.NormalizeEuler(angleY + val)
	self:SetCorrectEulerData(true, 3, CorrectEulerVal, targetVal)
end

function FightCamera:SetCorrectCameraState(isDefCorrect)
	self.isDefCorrect = isDefCorrect
end

function FightCamera:SetCorrectEulerData(isOpen, allTime, targetEulerX, targetEulerY)
	-- if self.correctTime and self.correctTime > 0 then return end
	local cb = function()
		self.correctTime = 0
	end
	targetEulerY = targetEulerY or -999
	self.aim:SetCorrectEuler(isOpen, allTime, targetEulerX, targetEulerY, cb)
	self.correctTime = allTime
end

function FightCamera:SetBlendHint(type)
	type = CameraBlendHitType.Cylindrical
	local transitions = self.cinemachineCamera.m_Transitions
	if transitions.m_BlendHint == type then
		return
	end
	transitions.m_BlendHint = type
	self.cinemachineCamera.m_Transitions = transitions
end

function FightCamera:OnLeave()
	self.lookAtTargetGroupCmp:RemoveMember(self.mainTarget)
	self.cameraParent.gameObject:SetActive(false)
	self.cinemachineCamera.gameObject:SetActive(false)
	self.target = nil
	self.curve = nil
	self.isisDisplacedCorrect = false
	self:ClearDistanceCacheData()
	self.aim:SetCorrectEuler(false)
end

function FightCamera:ClearDistanceCacheData()
	self.relativeDistance = nil
	self.dynamicCameraDis = nil
	self.effectTargetDis = nil
	self.changeDisVal = nil
end

function FightCamera:SetCamerIgnoreData(isIgnore, ignoreRatio)
	self.aim:SetCamerIgnoreData(isIgnore, ignoreRatio)
end

-- 修正相机
function FightCamera:CorrectCameraParams()
	self:SetCameraParams(Config.CameraConfig.CorrectFightCameraId)
	self.isCorrect = true
	self.correctData = {
		xTime = self.base.BodyXDamping,
		yTime = self.base.BodyYDamping,
		zTime = self.base.BodyZDamping,
		curTime = 0
	}
end

function FightCamera:NormalizeEuler(value)
	if value < -180 then
		value = value + 360
	elseif value > 180 then
		value = value - 360
	end
	return value
end

function FightCamera:UpdateCorrectTime()
	if not self.correctData or not self.isCorrect then return end
	local data = self.correctData

	if self.cameraManager.cinemachineBrain.IsBlending then return end
	local timeScale = 1
	local decTime = timeScale * FightUtil.deltaTimeSecond

	if data.xTime <= data.curTime and data.yTime <= data.curTime and data.zTime <= data.curTime then
		self.correctData = nil
		self.isCorrect = false
		self:SetCameraParams(Config.CameraConfig.DefFightCameraId)
		return
	end
	data.curTime = data.curTime + decTime
end

-- 设置相机参数
function FightCamera:SetCameraParams(id, coverDefult)
    if not id and not self.curParamsId then return end
	if id == self.curParamsId then return end
	
    if not self.curParamsId or coverDefult then
        self.curParamsId = id
    end

    if not id then
        id = self.curParamsId
    end

    self.curParamsId = id
	local cameraKey = "Cameraconfig"..id
	local params = Config[cameraKey]
	if not params then
		params = Config.CameraParams[id]
	end

	if not params then
        LogError("缺少相机配置，id = "..id)
        return
    end

	self:ApplyCameraParams(params, true)
	self:SetCurve(params.CurveId)
	self.curveId = params.CurveId
	self.curParams = params
	self.limitVerticalParams = params.LimitParms
	self:SetVerticalRotationLimitVal()
	
	if editor then
		self.cameraRuntimeParms.Id = id
		self.cameraRuntimeParms.CurveId = params.CurveId

		self:CheckSetLimitParms(true)
		self:SetRuntimeParms(params.Base,self.cameraRuntimeParms.Base)
		
		self.cameraRuntimeParms.VerticalOffset.PositiveOffset.MinValue = params.VerticalOffset.PositiveOffset.MinValue
		self.cameraRuntimeParms.VerticalOffset.PositiveOffset.MaxValue = params.VerticalOffset.PositiveOffset.MaxValue
		self:SetRuntimeParms(params.VerticalOffset.PositiveOffset.MinOffset,self.cameraRuntimeParms.VerticalOffset.PositiveOffset.MinOffset)
		self:SetRuntimeParms(params.VerticalOffset.PositiveOffset.MaxOffset,self.cameraRuntimeParms.VerticalOffset.PositiveOffset.MaxOffset)

		self.cameraRuntimeParms.VerticalOffset.NegativeOffset.MinValue = params.VerticalOffset.NegativeOffset.MinValue
		self.cameraRuntimeParms.VerticalOffset.NegativeOffset.MaxValue = params.VerticalOffset.NegativeOffset.MaxValue
		self:SetRuntimeParms(params.VerticalOffset.NegativeOffset.MinOffset,self.cameraRuntimeParms.VerticalOffset.NegativeOffset.MinOffset)
		self:SetRuntimeParms(params.VerticalOffset.NegativeOffset.MaxOffset,self.cameraRuntimeParms.VerticalOffset.NegativeOffset.MaxOffset)

		
		self.cameraRuntimeParms.HorizontaltOffset.PositiveOffset.MinValue = params.HorizontaltOffset.PositiveOffset.MinValue
		self.cameraRuntimeParms.HorizontaltOffset.PositiveOffset.MaxValue = params.HorizontaltOffset.PositiveOffset.MaxValue
		self:SetRuntimeParms(params.HorizontaltOffset.PositiveOffset.MinOffset,self.cameraRuntimeParms.HorizontaltOffset.PositiveOffset.MinOffset)
		self:SetRuntimeParms(params.HorizontaltOffset.PositiveOffset.MaxOffset,self.cameraRuntimeParms.HorizontaltOffset.PositiveOffset.MaxOffset)

		self.cameraRuntimeParms.HorizontaltOffset.NegativeOffset.MinValue = params.HorizontaltOffset.NegativeOffset.MinValue
		self.cameraRuntimeParms.HorizontaltOffset.NegativeOffset.MaxValue = params.HorizontaltOffset.NegativeOffset.MaxValue
		self:SetRuntimeParms(params.HorizontaltOffset.NegativeOffset.MinOffset,self.cameraRuntimeParms.HorizontaltOffset.NegativeOffset.MinOffset)
		self:SetRuntimeParms(params.HorizontaltOffset.NegativeOffset.MaxOffset,self.cameraRuntimeParms.HorizontaltOffset.NegativeOffset.MaxOffset)

		
		if self.distancePrecentOffset then
			-- 配置数据
			local distanceOffset = params.DistancePrecentOffset
			local offsetParams = distanceOffset.CameraParmsOffset

			-- 这个是组件中默认数据，修改一下
			local component = self.cameraRuntimeParms.DistancePrecentOffset
			component.CameraParmsOffset.PositiveOffset.MinValue = offsetParams.PositiveOffset.MinValue
			component.CameraParmsOffset.PositiveOffset.MaxValue = offsetParams.PositiveOffset.MaxValue
			self:SetRuntimeParms(offsetParams.PositiveOffset.MinOffset,component.CameraParmsOffset.PositiveOffset.MinOffset)
			self:SetRuntimeParms(offsetParams.PositiveOffset.MaxOffset,component.CameraParmsOffset.PositiveOffset.MaxOffset)

			component.CameraParmsOffset.NegativeOffset.MinValue = offsetParams.NegativeOffset.MinValue
			component.CameraParmsOffset.NegativeOffset.MaxValue = offsetParams.NegativeOffset.MaxValue
			self:SetRuntimeParms(offsetParams.NegativeOffset.MinOffset,component.CameraParmsOffset.NegativeOffset.MinOffset)
			self:SetRuntimeParms(offsetParams.NegativeOffset.MaxOffset,component.CameraParmsOffset.NegativeOffset.MaxOffset)

			component.HeightWeight = distanceOffset.HeightWeight
			component.DistanceWeight = distanceOffset.DistanceWeight
		end 
	end
end

function FightCamera:SetGlideCameraParams(id)
	local params = Config.CameraParams[id]
	if not params then
		return
	end

	if params.XDamping then
		self.body.m_XDamping = params.XDamping
	end
	if params.YDamping then
		self.body.m_YDamping = params.YDamping
	end
	if params.ZDamping then
		self.body.m_ZDamping = params.ZDamping
	end
end

function FightCamera:SetCurve(curveId)
	if not curveId or curveId ~= 0 then return end

	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(ctrlEntity)
	self.curve = CurveConfig.GetCurve(entity.entityId, curveId, 1000)
end

function FightCamera:CheckSetLimitParms(isInit)
	if not self.cameraRuntimeParms then return end 
	local cameraLimitParms = self.cameraRuntimeParms.LimitParms
	if not cameraLimitParms then return end
	
	self.limitVerticalParams = self.limitVerticalParams or {}
	local curLimitParams = self.limitVerticalParams or {}

	if isInit then
		cameraLimitParms.IsLimitVerticalVal = curLimitParams.IsLimitVerticalVal
		cameraLimitParms.AimMinVerticalVal = curLimitParams.AimMinVerticalVal or 0
		cameraLimitParms.AimMaxVerticalVal = curLimitParams.AimMaxVerticalVal or 0
		return
	end

	local update = false
	if cameraLimitParms.IsLimitVerticalVal ~= curLimitParams.IsLimitVerticalVal or
		cameraLimitParms.AimMinVerticalVal ~= curLimitParams.AimMinVerticalVal or
		cameraLimitParms.AimMaxVerticalVal ~= curLimitParams.AimMaxVerticalVal then
		update = true
	end
	self.limitVerticalParams.IsLimitVerticalVal = cameraLimitParms.IsLimitVerticalVal
	self.limitVerticalParams.AimMinVerticalVal = cameraLimitParms.AimMinVerticalVal
	self.limitVerticalParams.AimMaxVerticalVal = cameraLimitParms.AimMaxVerticalVal

	if update then
		self:SetVerticalRotationLimitVal()
	end

end

function FightCamera:SetRuntimeParms(params,cameraRuntimeParms)
	cameraRuntimeParms.BodyTrackedObjectOffsetX = params.BodyTrackedObjectOffsetX or 0
	cameraRuntimeParms.BodyTrackedObjectOffsetY = params.BodyTrackedObjectOffsetY or 0
	cameraRuntimeParms.BodyTrackedObjectOffsetZ = params.BodyTrackedObjectOffsetZ or 0
	cameraRuntimeParms.BodyXDamping = params.BodyXDamping or 0
	cameraRuntimeParms.BodyYDamping = params.BodyYDamping or 0
	cameraRuntimeParms.BodyZDamping = params.BodyZDamping or 0
	cameraRuntimeParms.BodyScreenX = params.BodyScreenX or 0
	cameraRuntimeParms.BodyScreenY = params.BodyScreenY or 0
	cameraRuntimeParms.BodyCameraDistance = params.BodyCameraDistance or 0
	cameraRuntimeParms.BodyDeadZoneWidth = params.BodyDeadZoneWidth or 0
	cameraRuntimeParms.BodyDeadZoneHeight = params.BodyDeadZoneHeight or 0
	cameraRuntimeParms.BodyDeadZoneDepth = params.BodyDeadZoneDepth or 0
	cameraRuntimeParms.BodyUnlimitedSoftZone = params.BodyUnlimitedSoftZone
	cameraRuntimeParms.BodySoftZoneWidth = params.BodySoftZoneWidth or 0
	cameraRuntimeParms.BodySoftZoneHeight = params.BodySoftZoneHeight or 0
	cameraRuntimeParms.BodyBiasX = params.BodyBiasX or 0
	cameraRuntimeParms.BodyBiasY = params.BodyBiasY or 0
	cameraRuntimeParms.AimTrackedObjectOffsetX = params.AimTrackedObjectOffsetX or 0
	cameraRuntimeParms.AimTrackedObjectOffsetY = params.AimTrackedObjectOffsetY or 0
	cameraRuntimeParms.AimTrackedObjectOffsetZ = params.AimTrackedObjectOffsetZ or 0
	cameraRuntimeParms.AimHorizontalDamping = params.AimHorizontalDamping or 0
	cameraRuntimeParms.AimVerticalDamping = params.AimVerticalDamping or 0
	cameraRuntimeParms.AimScreenX = params.AimScreenX or 0
	cameraRuntimeParms.AimScreenY = params.AimScreenY or 0
	cameraRuntimeParms.AimDeadZoneWidth = params.AimDeadZoneWidth or 0
	cameraRuntimeParms.AimDeadZoneHeight = params.AimDeadZoneHeight or 0
	cameraRuntimeParms.AimSoftZoneWidth = params.AimSoftZoneWidth or 0
	cameraRuntimeParms.AimSoftZoneHeight = params.AimSoftZoneHeight or 0
	cameraRuntimeParms.AimBiasX = params.AimBiasX or 0
	cameraRuntimeParms.AimBiasY = params.AimBiasY or 0
end

-- editor模式下动态设置
function FightCamera:ApplyCameraParams(params, isEnter)
	if self.CurveId ~= params.CurveId then
		self:SetCurve(params.CurveId)
		self.curveId = params.CurveId
	end
	self:CheckSetLimitParms()
	
	self.base = params.Base
	self.verticalOffset = params.VerticalOffset
	self.horizontaltOffset = params.HorizontaltOffset
	 self.distancePrecentOffset = params.DistancePrecentOffset

	--base body
	self.bodyTrackedObjectOffset.x = params.Base.BodyTrackedObjectOffsetX
	self.bodyTrackedObjectOffset.y = params.Base.BodyTrackedObjectOffsetY
	self.bodyTrackedObjectOffset.z = params.Base.BodyTrackedObjectOffsetZ
	self.body.m_TrackedObjectOffset = self.bodyTrackedObjectOffset
	self.body.m_XDamping = params.Base.BodyXDamping + (self.xDampingFix or 0)
	self.body.m_YDamping = params.Base.BodyYDamping + (self.yDampingFix or 0)
	self.body.m_ZDamping = params.Base.BodyZDamping + (self.zDampingFix or 0)
	self.body.m_ScreenX = params.Base.BodyScreenX
	self.body.m_ScreenY = params.Base.BodyScreenY
	self.body.m_DeadZoneWidth = params.Base.BodyDeadZoneWidth
	self.body.m_DeadZoneHeight = params.Base.BodyDeadZoneHeight
	self.body.m_DeadZoneDepth = params.Base.BodyDeadZoneDepth
	self.body.m_UnlimitedSoftZone = params.Base.BodyUnlimitedSoftZone
	self.body.m_SoftZoneWidth = params.Base.BodySoftZoneWidth
	self.body.m_SoftZoneHeight = params.Base.BodySoftZoneHeight
	self.body.m_BiasX = params.Base.BodyBiasX
	self.body.m_BiasY = params.Base.BodyBiasY
	--base aim
	self.aimTrackedObjectOffset.x = params.Base.AimTrackedObjectOffsetX
	self.aimTrackedObjectOffset.y = params.Base.AimTrackedObjectOffsetY
	self.aimTrackedObjectOffset.z = params.Base.AimTrackedObjectOffsetZ
	self.aim.m_TrackedObjectOffset = self.aimTrackedObjectOffset
	self.aim.m_HorizontalDamping = params.Base.AimHorizontalDamping
	self.aim.m_VerticalDamping = params.Base.AimVerticalDamping
	self.aim.m_ScreenY = params.Base.AimScreenY
	self.aim.m_DeadZoneHeight = params.Base.AimDeadZoneHeight
	self.aim.m_SoftZoneHeight = params.Base.AimSoftZoneHeight
	self.aim.m_BiasX = params.Base.AimBiasX
	self.aim.m_BiasY = params.Base.AimBiasY

	-- 最开始进入的时候初始化使用，后面由别的方法接管
	if isEnter then
		self.body.m_CameraDistance = params.Base.BodyCameraDistance
		self.aim.m_DeadZoneWidth = params.Base.AimDeadZoneWidth
		self.aim.m_SoftZoneWidth = params.Base.AimSoftZoneWidth
		self.aim.m_ScreenX = params.Base.AimScreenX
	end
end

local CachePos = Vec3.New()
function FightCamera:Update()
	-- TODO 暂时先处理
	local positon = self.lookAtTargetGroup.position
	CachePos.x = positon.x
	CachePos.z = positon.z
	CachePos.y = self.followTargetGroup.position.y


	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(ctrlEntity)
	local entityPos = entity.transformComponent.position
	self.lookAtTargetGroup:LookAt(entityPos)
	self.followTargetGroup:LookAt(CachePos)

	if editor then
		self:ApplyCameraParams(self.cameraRuntimeParms)
	end

	if not self.base then return end

	self:UpdateCameraOffsetEffect()

	self:UpdateCorrectTime()
	self:CheckLookEnd()

	self:UpdateCameraRelativePos()
	self:GetNewDistance()
	-- 用于动态计算相机的臂长，使相机与角色的距离是恒定的
	self:UpdateCameraDistance()

	self:UpdateAimScreenOffset()

	self:UpdateColliderCorrect()

	-- self:UpdateTestCollider()
end

function FightCamera:UpdateCameraOffsetEffect()
	if self.correctTime and self.correctTime > 0 then
		return
	end

	if self.verticalOffset then
		self:UpdateVerticalOffset()
	end

	if self.horizontaltOffset then
		self:UpdateHorizontalOffset()
	end

	if self.distancePrecentOffset then
		self:UpdateDistancePrecentOffset()
	end
end

function FightCamera:UpdateColliderCorrect()
	do
		return end
	if not self.cameraCollider then return end
	local isDisplaced = self.cameraCollider:CameraWasDisplaced(self.cinemachineCamera)
	if not isDisplaced then
		self.displacedTime = 2
		self.isisDisplacedCorrect = false
		return
	end
	self.displacedTime = self.displacedTime or 2
	self.displacedTime = self.displacedTime - FightUtil.deltaTimeSecond
	if self.displacedTime <= 0 and not self.isisDisplacedCorrect then
		self:CheckCorrectCamera()
		self.isisDisplacedCorrect = true
	end
end

function FightCamera:GetCurveCalPVal(dif)
	if not self.curve then return end
	local selectData
	for _, data in ipairs(self.curve) do
		if dif >= data.dis then
			selectData = data
		end
	end

	if not selectData then return end
	return selectData.val
end

function FightCamera:GetEntiyAndTargetPos()
	-- 角色的pos
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(ctrlEntity)
	local position = entity.transformComponent.position

	-- 目标的pos
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	local fightPlayer = player.fightPlayer
	if self.target then
		return position, self.target.position
	end

	local target = fightPlayer:GetFightTarget()
	if not target then return end
	local targetEntity = BehaviorFunctions.GetEntity(target)
	local targetPos = targetEntity.transformComponent.position

	return position, targetPos
end

function FightCamera:CheckVerticalDiffVal()
	if not self.verticalOffset then return end
	local position, targetPos = self:GetEntiyAndTargetPos()
	if not position or not targetPos then return end

	if position.y >= targetPos.y then
		return self.verticalOffset.PositiveOffset
	end

	return self.verticalOffset.NegativeOffset
end

function FightCamera:UpdateVerticalOffset()
	local verticalOffset = self:CheckVerticalDiffVal()
	if not verticalOffset then return end

	local minOffset = verticalOffset.MinOffset
	local maxOffset = verticalOffset.MaxOffset

	local minVal, maxVal = verticalOffset.MinValue, verticalOffset.MaxValue

	local dif = maxVal - minVal
	if dif == 0 or not minOffset or not maxOffset then
		return
	end
	local y1 = self.followTargetGroup.position.y
	local y2 = self.lookAtTargetGroup.position.y
	local yOffset = y2 - y1
	if yOffset < minVal then
		return
	end
	if yOffset > maxVal then
		yOffset = maxVal
	end

	--body
	local p = (yOffset - minVal) / dif

	-- 曲线限制
	local curveP = self:GetCurveCalPVal(dif)
	p = curveP and curveP or p

	if editor then
		self.cameraRuntimeParms.VerticalOffset.PositiveOffset.Distance = yOffset
		self.cameraRuntimeParms.VerticalOffset.PositiveOffset.Percent = p

		self.cameraRuntimeParms.VerticalOffset.NegativeOffset.Distance = yOffset
		self.cameraRuntimeParms.VerticalOffset.NegativeOffset.Percent = p
	end

	self:SetCameraEffectParams(minOffset, maxOffset, p, p, maxVal, minVal)
end

local cacheCameraForwoard = Vec3.New()
function FightCamera:CheckHorizontalDiffVal()
	if not self.horizontaltOffset then return end
	local position, targetPos = self:GetEntiyAndTargetPos()
	if not position or not targetPos then return end

	local cameraTrans = self.cameraManager.cameraTransform
	local cameraPos = cameraTrans.position
	local cameraForward = cameraTrans.forward
	cacheCameraForwoard.x = cameraForward.x
	cacheCameraForwoard.y = cameraForward.y
	cacheCameraForwoard.z = cameraForward.z

	-- 水平投影对比
	local entityPlane = Vec3.ProjectOnPlane(position - cameraPos, cacheCameraForwoard)
	local targetPlane = Vec3.ProjectOnPlane(targetPos - cameraPos, cacheCameraForwoard)

	if entityPlane.x >= targetPlane.x then
		return self.horizontaltOffset.PositiveOffset
	end

	return self.horizontaltOffset.NegativeOffset
end

function FightCamera:UpdateHorizontalOffset()
	local HorizontaltOffset = self:CheckHorizontalDiffVal()
	if not HorizontaltOffset then return end

	local minOffset = HorizontaltOffset.MinOffset
	local maxOffset = HorizontaltOffset.MaxOffset
	local x1 = self.followTargetGroup.position.x
	local z1 = self.followTargetGroup.position.z
	local x2 = self.lookAtTargetGroup.position.x
	local z2 = self.lookAtTargetGroup.position.z
	local dis = math.sqrt((x1-x2)*(x1-x2) + (z1-z2)*(z1-z2))

	local minVal, maxVal = HorizontaltOffset.MinValue, HorizontaltOffset.MaxValue

	if dis < minVal then
		dis = minVal
	end
	if dis > maxVal then
		dis = maxVal
	end
	if dis == 0 or not minOffset or not maxOffset then
		return
	end
	local p = (maxVal - dis) / (maxVal - minVal)

	-- 曲线限制
	local curveP = self:GetCurveCalPVal(dis)
	p = curveP and curveP or p

	if editor then
		self.cameraRuntimeParms.HorizontaltOffset.PositiveOffset.Distance = dis
		self.cameraRuntimeParms.HorizontaltOffset.PositiveOffset.Percent = p

		self.cameraRuntimeParms.HorizontaltOffset.NegativeOffset.Distance = dis
		self.cameraRuntimeParms.HorizontaltOffset.NegativeOffset.Percent = p
	end
 
	self:SetCameraEffectParams(minOffset, maxOffset, p, p, maxVal, minVal)
end

function FightCamera:CheckDistanceDiffVal(difVal)
	local paramsCfg = self.distancePrecentOffset.CameraParmsOffset
	if difVal > 0 then
		return paramsCfg.PositiveOffset
	end
	return paramsCfg.NegativeOffset
end

function FightCamera:UpdateDistancePrecentOffset()
	local distancePrecentOffset = self.distancePrecentOffset
	if not distancePrecentOffset then return end

	local followPos = self.followTargetGroup.position
	local lookAtPos = self.lookAtTargetGroup.position

	local x1 = followPos.x
	local z1 = followPos.z
	local x2 = lookAtPos.x
	local z2 = lookAtPos.z
	local dis = math.sqrt((x1-x2)*(x1-x2) + (z1-z2)*(z1-z2))
	if dis == 0 then
		return
	end
	local y1 = followPos.y
	local y2 = lookAtPos.y
	local height = y2 - y1

	local cameraOffset = self:CheckDistanceDiffVal(height)
	local minOffset = cameraOffset.MinOffset
	local maxOffset = cameraOffset.MaxOffset

	local heightWeight = distancePrecentOffset.HeightWeight
	local distanceWeight = distancePrecentOffset.DistanceWeight
	
	local minVal, maxVal = cameraOffset.MinValue, cameraOffset.MaxValue
	local dif = maxVal - minVal

	local difPrecent = (heightWeight * height) / (dis * distanceWeight)
	if difPrecent ~= difPrecent or difPrecent == 0 or not minOffset or not maxOffset then
		return
	end
	
	local newPrecentVal = (difPrecent - minVal) / dif

	if editor then
		self.cameraRuntimeParms.DistancePrecentOffset.CameraParmsOffset.PositiveOffset.Distance = dis
		self.cameraRuntimeParms.DistancePrecentOffset.CameraParmsOffset.PositiveOffset.Percent = difPrecent
	end

	self:SetCameraEffectParams(minOffset, maxOffset, newPrecentVal, difPrecent, maxVal ,minVal)
end

function FightCamera:SetNewVal(calcVal, difPrecent, minVal, maxVal, minOffset, maxOffset, key)
	if difPrecent <= minVal then
		calcVal = minOffset[key]
	elseif difPrecent >= maxVal then
		calcVal = maxOffset[key]
	end

	return calcVal
end

function FightCamera:SetCameraEffectParams(minOffset, maxOffset, precent, difPrecent, maxVal, minVal)
	if minOffset.BodyTrackedObjectOffsetX and maxOffset.BodyTrackedObjectOffsetX and minOffset.BodyTrackedObjectOffsetX ~= maxOffset.BodyTrackedObjectOffsetX then
		local bodyTrackedObjectOffsetX = minOffset.BodyTrackedObjectOffsetX + (maxOffset.BodyTrackedObjectOffsetX - minOffset.BodyTrackedObjectOffsetX) * precent
		local bodyTrackedObjectOffsetY = minOffset.BodyTrackedObjectOffsetY + (maxOffset.BodyTrackedObjectOffsetY - minOffset.BodyTrackedObjectOffsetY) * precent
		local bodyTrackedObjectOffsetZ = minOffset.BodyTrackedObjectOffsetZ + (maxOffset.BodyTrackedObjectOffsetZ - minOffset.BodyTrackedObjectOffsetZ) * precent

		bodyTrackedObjectOffsetX = self:SetNewVal(bodyTrackedObjectOffsetX, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyTrackedObjectOffsetX")
		bodyTrackedObjectOffsetY = self:SetNewVal(bodyTrackedObjectOffsetX, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyTrackedObjectOffsetY")
		bodyTrackedObjectOffsetZ = self:SetNewVal(bodyTrackedObjectOffsetX, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyTrackedObjectOffsetZ")

		self.bodyTrackedObjectOffset.x = self.base.BodyTrackedObjectOffsetX + bodyTrackedObjectOffsetX
		self.bodyTrackedObjectOffset.y = self.base.BodyTrackedObjectOffsetY + bodyTrackedObjectOffsetY
		self.bodyTrackedObjectOffset.z = self.base.BodyTrackedObjectOffsetZ + bodyTrackedObjectOffsetZ
		self.body.m_TrackedObjectOffset = self.bodyTrackedObjectOffset
	end

	if minOffset.BodyXDamping and maxOffset.BodyXDamping and minOffset.BodyXDamping ~= maxOffset.BodyXDamping then
		local bodyXDamping = minOffset.BodyXDamping + (maxOffset.BodyXDamping - minOffset.BodyXDamping) * precent
		bodyXDamping = self:SetNewVal(bodyXDamping, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyXDamping")

		self.body.m_XDamping = self.base.BodyXDamping + bodyXDamping + (self.xDampingFix or 0)
	end
	
	if minOffset.BodyYDamping and maxOffset.BodyYDamping and minOffset.BodyYDamping ~= maxOffset.BodyYDamping then
		local bodyYDamping = minOffset.BodyYDamping + (maxOffset.BodyYDamping - minOffset.BodyYDamping) * precent
		bodyYDamping = self:SetNewVal(bodyYDamping, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyYDamping")

		self.body.m_YDamping = self.base.BodyYDamping + bodyYDamping + (self.yDampingFix or 0)
	end
	if minOffset.BodyZDamping and maxOffset.BodyZDamping and minOffset.BodyZDamping ~= maxOffset.BodyZDamping then
		local bodyZDamping = minOffset.BodyZDamping + (maxOffset.BodyZDamping - minOffset.BodyZDamping) * precent
		bodyZDamping = self:SetNewVal(bodyZDamping, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyZDamping")

		self.body.m_ZDamping = self.base.BodyZDamping + bodyZDamping + (self.zDampingFix or 0)
	end
	if minOffset.BodyScreenX and maxOffset.BodyScreenX then
		local bodyScreenX = minOffset.BodyScreenX + (maxOffset.BodyScreenX - minOffset.BodyScreenX) * precent
		bodyScreenX = self:SetNewVal(bodyScreenX, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyScreenX")

		self.body.m_ScreenX = self.base.BodyScreenX + bodyScreenX
	end
	if minOffset.BodyScreenY and maxOffset.BodyScreenY then
		local bodyScreenY = minOffset.BodyScreenY + (maxOffset.BodyScreenY - minOffset.BodyScreenY) * precent
		bodyScreenY = self:SetNewVal(bodyScreenY, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyScreenY")

		self.body.m_ScreenY = self.base.BodyScreenY + bodyScreenY
	end

	if minOffset.BodyCameraDistance and maxOffset.BodyCameraDistance then
		local bodyCameraDistance = minOffset.BodyCameraDistance + (maxOffset.BodyCameraDistance - minOffset.BodyCameraDistance) * precent
		bodyCameraDistance = self:SetNewVal(bodyCameraDistance, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyCameraDistance")
		local fixeOffsetVal = self.fixedOffsetCameraDis or 0
		self.effectTargetDis = self.base.BodyCameraDistance + bodyCameraDistance + fixeOffsetVal
	end

	if minOffset.BodyDeadZoneWidth and maxOffset.BodyDeadZoneWidth then
		local bodyDeadZoneWidth = minOffset.BodyDeadZoneWidth + (maxOffset.BodyDeadZoneWidth - minOffset.BodyDeadZoneWidth) * precent
		bodyDeadZoneWidth = self:SetNewVal(bodyDeadZoneWidth, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyDeadZoneWidth")

		self.body.m_DeadZoneWidth = self.base.BodyDeadZoneWidth + bodyDeadZoneWidth
	end
	if minOffset.BodyDeadZoneHeight and maxOffset.BodyDeadZoneHeight and maxOffset.BodyDeadZoneHeight ~= minOffset.BodyDeadZoneHeight then
		local bodyDeadZoneHeight = minOffset.BodyDeadZoneHeight + (maxOffset.BodyDeadZoneHeight - minOffset.BodyDeadZoneHeight) * precent
		bodyDeadZoneHeight = self:SetNewVal(bodyDeadZoneHeight, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyDeadZoneHeight")

		self.body.m_DeadZoneHeight = self.base.BodyDeadZoneHeight + bodyDeadZoneHeight
	end
	if minOffset.BodyDeadZoneDepth and maxOffset.BodyDeadZoneDepth and minOffset.BodyDeadZoneDepth ~= maxOffset.BodyDeadZoneDepth then
		local bodyDeadZoneDepth = minOffset.BodyDeadZoneDepth + (maxOffset.BodyDeadZoneDepth - minOffset.BodyDeadZoneDepth) * precent
		bodyDeadZoneDepth = self:SetNewVal(bodyDeadZoneDepth, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyDeadZoneDepth")

		self.body.m_DeadZoneDepth = self.base.BodyDeadZoneDepth + bodyDeadZoneDepth
	end
	if minOffset.BodySoftZoneWidth and maxOffset.BodySoftZoneWidth and minOffset.BodySoftZoneWidth ~= maxOffset.BodySoftZoneWidth then
		local bodySoftZoneWidth = minOffset.BodySoftZoneWidth + (maxOffset.BodySoftZoneWidth - minOffset.BodySoftZoneWidth) * precent
		bodySoftZoneWidth = self:SetNewVal(bodySoftZoneWidth, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodySoftZoneWidth")

		self.body.m_SoftZoneWidth = self.base.BodySoftZoneWidth + bodySoftZoneWidth
	end
	if minOffset.BodySoftZoneHeight and maxOffset.BodySoftZoneHeight and minOffset.BodySoftZoneHeight ~= maxOffset.BodySoftZoneHeight then
		local bodySoftZoneHeight = minOffset.BodySoftZoneHeight + (maxOffset.BodySoftZoneHeight - minOffset.BodySoftZoneHeight) * precent
		bodySoftZoneHeight = self:SetNewVal(bodySoftZoneHeight, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodySoftZoneHeight")

		self.body.m_SoftZoneHeight = self.base.BodySoftZoneHeight + bodySoftZoneHeight
	end
	if minOffset.BodyBiasX and maxOffset.BodyBiasX and minOffset.BodyBiasX ~= maxOffset.BodyBiasX then
		local bodyBiasX = minOffset.BodyBiasX + (maxOffset.BodyBiasX - minOffset.BodyBiasX) * precent
		bodyBiasX = self:SetNewVal(bodyBiasX, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyBiasX")

		self.body.m_BiasX = self.base.BodyBiasX + bodyBiasX
	end
	if minOffset.BodyBiasY and maxOffset.BodyBiasY and minOffset.BodyBiasY ~= maxOffset.BodyBiasY then
		local bodyBiasY = minOffset.BodyBiasY + (maxOffset.BodyBiasY - minOffset.BodyBiasY) * precent
		bodyBiasY = self:SetNewVal(bodyBiasY, difPrecent, minVal, maxVal, minOffset, maxOffset, "BodyBiasY")

		self.body.m_BiasY = self.base.BodyBiasY + bodyBiasY
	end
	--aim
	if minOffset.AimTrackedObjectOffsetX and maxOffset.AimTrackedObjectOffsetX and minOffset.AimTrackedObjectOffsetX ~= maxOffset.AimTrackedObjectOffsetX then
		local aimTrackedObjectOffsetX = minOffset.AimTrackedObjectOffsetX + (maxOffset.AimTrackedObjectOffsetX - minOffset.AimTrackedObjectOffsetX) * precent
		local aimTrackedObjectOffsetY = minOffset.AimTrackedObjectOffsetY + (maxOffset.AimTrackedObjectOffsetY - minOffset.AimTrackedObjectOffsetY) * precent
		local aimTrackedObjectOffsetZ = minOffset.AimTrackedObjectOffsetZ + (maxOffset.AimTrackedObjectOffsetZ - minOffset.AimTrackedObjectOffsetZ) * precent

		aimTrackedObjectOffsetX = self:SetNewVal(aimTrackedObjectOffsetX, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimTrackedObjectOffsetX")
		aimTrackedObjectOffsetY = self:SetNewVal(aimTrackedObjectOffsetY, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimTrackedObjectOffsetY")
		aimTrackedObjectOffsetZ = self:SetNewVal(aimTrackedObjectOffsetZ, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimTrackedObjectOffsetZ")

		self.aimTrackedObjectOffset.x = self.base.AimTrackedObjectOffsetX + aimTrackedObjectOffsetX
		self.aimTrackedObjectOffset.y = self.base.AimTrackedObjectOffsetY + aimTrackedObjectOffsetY
		self.aimTrackedObjectOffset.z = self.base.AimTrackedObjectOffsetZ + aimTrackedObjectOffsetZ
		self.aim.m_TrackedObjectOffset = self.aimTrackedObjectOffset
	end

	if minOffset.AimHorizontalDamping and maxOffset.AimHorizontalDamping and minOffset.AimHorizontalDamping ~= maxOffset.AimHorizontalDamping then
		local aimHorizontalDamping = minOffset.AimHorizontalDamping + (maxOffset.AimHorizontalDamping - minOffset.AimHorizontalDamping) * precent
		aimHorizontalDamping = self:SetNewVal(aimHorizontalDamping, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimHorizontalDamping")

		self.aim.m_HorizontalDamping = self.base.AimHorizontalDamping + aimHorizontalDamping
	end

	if minOffset.AimVerticalDamping and maxOffset.AimVerticalDamping and minOffset.AimVerticalDamping ~= maxOffset.AimVerticalDamping then
		local aimVerticalDamping = minOffset.AimVerticalDamping + (maxOffset.AimVerticalDamping - minOffset.AimVerticalDamping) * precent
		aimVerticalDamping = self:SetNewVal(aimVerticalDamping, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimVerticalDamping")

		self.aim.m_VerticalDamping = self.base.AimVerticalDamping + aimVerticalDamping
	end

	if minOffset.AimScreenX and maxOffset.AimScreenX and minOffset.AimScreenX ~= maxOffset.AimScreenX then
		local aimScreenX = minOffset.AimScreenX + (maxOffset.AimScreenX - minOffset.AimScreenX) * precent
		aimScreenX = self:SetNewVal(aimScreenX, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimScreenX")

		if not self.isAimDeadZoneWidth then
			self.aim.m_ScreenX = self.base.AimScreenX + aimScreenX
		end
	end

	if minOffset.AimScreenY and maxOffset.AimScreenY and minOffset.AimScreenY ~= maxOffset.AimScreenY then
		local aimScreenY = minOffset.AimScreenY + (maxOffset.AimScreenY - minOffset.AimScreenY) * precent
		aimScreenY = self:SetNewVal(aimScreenY, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimScreenY")

		self.aim.m_ScreenY = self.base.AimScreenY + aimScreenY
	end

	if minOffset.AimDeadZoneWidth and maxOffset.AimDeadZoneWidth and minOffset.AimDeadZoneWidth ~= maxOffset.AimDeadZoneWidth then
		local aimDeadZoneWidth = minOffset.AimDeadZoneWidth + (maxOffset.AimDeadZoneWidth - minOffset.AimDeadZoneWidth) * precent
		aimDeadZoneWidth = self:SetNewVal(aimDeadZoneWidth, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimDeadZoneWidth")

		if not self.isAimDeadZoneWidth then
			self.aim.m_DeadZoneWidth = self.base.AimDeadZoneWidth + aimDeadZoneWidth
		end
	end

	if minOffset.AimDeadZoneHeight and maxOffset.AimDeadZoneHeight and minOffset.AimDeadZoneHeight ~= maxOffset.AimDeadZoneHeight then
		local aimDeadZoneHeight = minOffset.AimDeadZoneHeight + (maxOffset.AimDeadZoneHeight - minOffset.AimDeadZoneHeight) * precent
		aimDeadZoneHeight = self:SetNewVal(aimDeadZoneHeight, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimDeadZoneHeight")

		self.aim.m_DeadZoneHeight = self.base.AimDeadZoneHeight + aimDeadZoneHeight
	end

	if minOffset.AimSoftZoneWidth and maxOffset.AimSoftZoneWidth and minOffset.AimSoftZoneWidth ~= maxOffset.AimSoftZoneWidth then
		local aimSoftZoneWidth = minOffset.AimSoftZoneWidth + (maxOffset.AimSoftZoneWidth - minOffset.AimSoftZoneWidth) * precent
		aimSoftZoneWidth = self:SetNewVal(aimSoftZoneWidth, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimSoftZoneWidth")
		if not self.isAimDeadZoneWidth then
			self.aim.m_SoftZoneWidth = self.base.AimSoftZoneWidth + aimSoftZoneWidth
		end
	end

	if minOffset.AimSoftZoneHeight and maxOffset.AimSoftZoneHeight and minOffset.AimSoftZoneHeight ~= maxOffset.AimSoftZoneHeight then
		local aimSoftZoneHeight = minOffset.AimSoftZoneHeight + (maxOffset.AimSoftZoneHeight - minOffset.AimSoftZoneHeight) * precent
		aimSoftZoneHeight = self:SetNewVal(aimSoftZoneHeight, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimSoftZoneHeight")
		self.aim.m_SoftZoneHeight = self.base.AimSoftZoneHeight + aimSoftZoneHeight
	end

	if minOffset.AimBiasX and maxOffset.AimBiasX and minOffset.AimBiasX ~= maxOffset.AimBiasX then
		local aimBiasX = minOffset.AimBiasX + (maxOffset.AimBiasX - minOffset.AimBiasX) * precent
		aimBiasX = self:SetNewVal(aimBiasX, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimBiasX")

		self.aim.m_BiasX = self.base.AimBiasX + aimBiasX
	end

	if minOffset.AimBiasY and maxOffset.AimBiasY and minOffset.AimBiasY ~= maxOffset.AimBiasY then
		local aimBiasY = minOffset.AimBiasY + (maxOffset.AimBiasY - minOffset.AimBiasY) * precent
		aimBiasY = self:SetNewVal(aimBiasY, difPrecent, minVal, maxVal, minOffset, maxOffset, "AimBiasY")

		self.aim.m_BiasY = self.base.AimBiasY + aimBiasY
	end
end

function FightCamera:SetFollowTargetWeight(target,weight)
	self.followTargetGroupCmp:SetMemberWeight(target,weight)
end

function FightCamera:SetGroupPositionMode(mode)
	self.followTargetGroupCmp.m_PositionMode = mode
end

function FightCamera:AddFollowTarget(target)
	self.followTargetGroupCmp:AddMember(target,1,1)
end

function FightCamera:RemoveFollowTarget(target)
	self.followTargetGroupCmp:RemoveMember(target)
end

function FightCamera:RemoveAllFollowTarget()
	self.CacheFollowMember = self.followTargetGroupCmp.m_Targets
	self.followTargetGroupCmp:RemoveAllMember()
end

function FightCamera:AddLookAtTarget(target)
	self.lookAtTargetGroupCmp:AddMember(target,1,0)
end

function FightCamera:RemoveLookAtTarget(target)
	self.lookAtTargetGroupCmp:RemoveMember(target)
end

function FightCamera:SetLookAtTargetWeight(target,weight)
	self.lookAtTargetGroupCmp:SetMemberWeight(target,weight)
end

function FightCamera:RemoveAllLookAtTarget()
	self.CacheLookAtMember = self.lookAtTargetGroupCmp.m_Targets
	self.lookAtTargetGroupCmp:RemoveAllMember()
end

function FightCamera:RevertLookAtTarget()
	if not self.CacheLookAtMember then return end
	self.lookAtTargetGroupCmp.m_Targets = self.CacheLookAtMember
	self.CacheLookAtMember = nil
end

function FightCamera:RevertFollowTarget()
	if not self.CacheFollowMember then return end
	self.followTargetGroupCmp.m_Targets = self.CacheFollowMember
	self.CacheFollowMember = nil
end

function FightCamera:FindLookAtTarget(target)
	local val = self.lookAtTargetGroupCmp:FindMember(target)
	return val
end

function FightCamera:ChangeConfigKeyVal(groupKey, key, val)
	if not editor or not self.cameraRuntimeParms then
		return
	end
	if groupKey and groupKey ~= "" then
		self.cameraRuntimeParms[groupKey][key] = val
	else
		self.cameraRuntimeParms[key] = val
	end
end

function FightCamera:SetCameraFixedLookAt(isOpen, targetInsId, bindName, lookAtInsId, lookAtName)
	if not isOpen then
		self:CloseLookAt()
		return
	end
	local target = BehaviorFunctions.GetEntity(targetInsId)
    local clientTransformComponent = target.clientTransformComponent
    local targetTrans = clientTransformComponent:GetTransform(bindName)

	local lookAtEntity = BehaviorFunctions.GetEntity(lookAtInsId)
    local lookAtTransCompent = lookAtEntity.clientTransformComponent
    local lookatTrans = lookAtTransCompent:GetTransform(lookAtName)

	self.lookAtData = {
		targetInsId = targetInsId,
		bindName = bindName,
		targetTrans = targetTrans,
		lookatTrans = lookatTrans
	}
end

function FightCamera:UpdateLookAtPos()
	local params = self.lookAtData
    local targetPos = params.lookatTrans.position

	self.cachePos = targetPos
	local cameraPos = self.cameraManager.cameraTransform.position
	local dir = targetPos - cameraPos
	self.aim:SetFixedRotationVal(true, dir.x, dir.y, dir.z)
end

function FightCamera:CheckLookEnd()
	if not self.lookAtData then return end
	self:UpdateLookAtPos()
	local cameraComponent = self.cameraManager.mainCameraComponent
    local left = cameraComponent.rect.xMin
    local right = cameraComponent.rect.xMax
    local top = cameraComponent.rect.yMax
    local bottom = cameraComponent.rect.yMin
	if self:CheckTargetIsScreenContain(left, right, top, bottom) then return end

	local instanceId = BehaviorFunctions.GetCtrlEntity()
    local entity = BehaviorFunctions.GetEntity(instanceId)
    local pos1 = entity.clientTransformComponent.transform.position

	local point1ScreenPos = cameraComponent:WorldToViewportPoint(pos1)
    local point2ScreenPos = cameraComponent:WorldToViewportPoint(self.cachePos)

    local isPoint1InsideCamera = point1ScreenPos.x >= left and point1ScreenPos.x <= right and point1ScreenPos.y >= bottom and point1ScreenPos.y <= top
    local isPoint2InsideCamera = point2ScreenPos.x >= left and point2ScreenPos.x <= right - 0.2 and point2ScreenPos.y >= bottom and point2ScreenPos.y <= top
	if not isPoint1InsideCamera or not isPoint2InsideCamera then return end
	self:CloseLookAt()
end

function FightCamera:CheckTargetIsScreenContain(left, right, top, bottom)
	local target = self.lookAtData.targetTrans
	local cameraComponent = self.cameraManager.mainCameraComponent
	local pos = target.position
	local pointScreenPos = cameraComponent:WorldToViewportPoint(pos)
	local isPointInsideCamera = pointScreenPos.x >= left and pointScreenPos.x <= right and pointScreenPos.y >= bottom and pointScreenPos.y <= top
	if not isPointInsideCamera then
		self:CloseLookAt()
		return true
	end
	return true
end

function FightCamera:CloseLookAt()
	self.aim:SetFixedRotationVal(false)
	self.lookAtData = nil
end

function FightCamera:SetFixedCameraVerticalDir(isFixed, isNoCache)
	self.aim:SetFixedCameraVerticalDir(isFixed)
	if not isNoCache then
		self.isFixedVerticalDir = isFixed
	end
end

function FightCamera:SetBodyDamping(x,y,z)
	if not self.base then return end
	self.xDampingFix = x - self.base.BodyXDamping
	self.yDampingFix = y - self.base.BodyYDamping
	self.zDampingFix = z - self.base.BodyZDamping
end

function FightCamera:SetDefaulBodyDamping()
	self.xDampingFix = nil
	self.yDampingFix = nil
	self.zDampingFix = nil
end

function FightCamera:SetVerticalRotationLimitVal()
	local curLimitParams = self.limitVerticalParams
	if not curLimitParams then return end
	self.aim:SetVerticalRotationLimitVal(curLimitParams.IsLimitVerticalVal, CorrectEulerVal, curLimitParams.AimMaxVerticalVal)
end


-----------------相机修正
function FightCamera:UpdateAimScreenOffset(isCorrectr)
	if not self.target then return end
	if self.correctTime and self.correctTime > 0 then
		self.correctTime = self.correctTime - FightUtil.deltaTimeSecond
		return
	end
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(ctrlEntity)
	local entityPos = entity.clientTransformComponent.transform.position
	local entityTrans = entity.clientTransformComponent.transform

	local targetPos = self.target.position

	local cameraTrans = self.cameraManager.cameraTransform
	local cameraPos = cameraTrans.position
	local cameraForward = cameraTrans.forward
	cacheCameraForwoard.x = cameraForward.x
	cacheCameraForwoard.y = cameraForward.y
	cacheCameraForwoard.z = cameraForward.z

	local val = Vec3.Dot(cameraPos - targetPos, targetPos - entityPos)
	local curAimScreenX = self.aim.m_ScreenX
	local curZoneVal = self.aim.m_DeadZoneWidth
	
	local targetZoneVal
	if val > 0 then -- 需要修正
		self.isAimDeadZoneWidth = true
		targetZoneVal = 0.01
		self:SetFixedCameraVerticalDir(true, true)
		self:UpdateLookAtTargetGroupWeight(true)
		
		local newZoneVal = MathX.lerp_number(curZoneVal, targetZoneVal, 0.05)
		self.aim.m_DeadZoneWidth = newZoneVal
		
		local crossVal = Vec3.Cross(cameraPos - targetPos, targetPos - entityPos)
		local screenX = 0.5
		if crossVal.y > 0 then
			screenX = 0.6
		elseif crossVal.y < 0 then
			screenX = 0.4
		end
		local newScreenX = MathX.lerp_number(curAimScreenX, screenX, 0.05)
		self.aim.m_ScreenX = newScreenX
		
	else
		self.isAimDeadZoneWidth = false
		targetZoneVal = self.base.AimDeadZoneWidth
		self:SetFixedCameraVerticalDir(self.isFixedVerticalDir)
		self:UpdateLookAtTargetGroupWeight(false)
		
		local newScreenX = MathX.lerp_number(curAimScreenX, 0.5, 0.05)
		self.aim.m_ScreenX = newScreenX
		
		local newZoneVal = MathX.lerp_number(curZoneVal, targetZoneVal, 0.05)
		self.aim.m_DeadZoneWidth = newZoneVal
	end
end

function FightCamera:UpdateLookAtTargetGroupWeight(isCorrectWeight)
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(ctrlEntity)
	-- 这里只找角色的CameraTarget挂点
	local entityTarget = entity.clientTransformComponent:GetTransform("CameraTarget")

	local curIdx = self:FindLookAtTarget(entityTarget)
	if curIdx == -1 then return end

	local memberWeight = self.lookAtTargetGroupCmp.m_Targets[curIdx].weight
	local weight = isCorrectWeight and 0 or 1
	
	local newWeight = MathX.lerp_number(memberWeight, weight, 0.01)
	self.lookAtTargetGroupCmp:SetMemberWeight(entityTarget, newWeight)
end

------------------- 相机距离臂长修正
-- 刷新相机的相对位置，保持相机和角色的距离是一定的
function FightCamera:UpdateCameraRelativePos()
	if not self.bodyTrackedObjectOffset or not self.base then
		self.relativeDistance = nil
		return
	end
	-- local followPos = self.followTargetGroup.position
	local cameraPos = self.cameraManager.cameraTransform.position

	local pos = self.followTargetGroup.position + self.followTargetGroup.forward * self.bodyTrackedObjectOffset.z
	pos.y = cameraPos.y
	local dis = Vector3.Distance(pos, cameraPos)


	local pos2 = self.followTargetGroup.position
	pos2.y = cameraPos.y
	local dis2 = Vector3.Distance(pos2, cameraPos)

	self.disOffset = dis - dis2
	local finalCameraDistance = self.base.BodyCameraDistance + self.disOffset
	local curCameraDistance = self.body.m_CameraDistance
	local fix = finalCameraDistance > curCameraDistance and 1 or -1 
	local cameraDistance = math.min(curCameraDistance + 0.01 * fix, finalCameraDistance)
	self.relativeDistance = cameraDistance
end

function FightCamera:UpdateCameraDistance()
	if not self.base then return end 
	local curDistance = self:GetCurCameraDistance()
	local addDis = 0
	-- local targetDis = self.effectTargetDis or self.base.BodyCameraDistance
	local baseDis = self.base.BodyCameraDistance
	local targetDis = baseDis
	-- 效果目标臂长
	if self.effectTargetDis then
		targetDis = math.max(targetDis, self.effectTargetDis)
	end

	-- 相对目标臂长
	if self.relativeDistance then
		targetDis = math.max(targetDis, self.relativeDistance)
	end

	-- 动态目标臂长
	if self.dynamicCameraDis then
		targetDis = math.max(targetDis, self.dynamicCameraDis)
	end
	addDis = targetDis - baseDis
	local newDistance = baseDis + addDis
	newDistance = self.changeDisVal and newDistance + self.changeDisVal or newDistance
		
 	local lerpDis = MathX.lerp_number(curDistance, newDistance, 0.1)
	self.body.m_CameraDistance = lerpDis
end

function FightCamera:SetDynamicCameraDistance(isOpen, maxDis, time)
	if not isOpen then
		self.dynamicDis = nil
		self.dynamicCameraDis = nil
		return
	end

	self.dynamicDis = {
		maxDis = maxDis,
		time = time
	}
end

-- 在有目标的情况下，尽量保证角色和目标都在相机的范围内
function FightCamera:GetNewDistance()
	 if not self.dynamicDis then return end
	 local params = self.dynamicDis

    local instanceId = BehaviorFunctions.GetCtrlEntity()
    local entity = BehaviorFunctions.GetEntity(instanceId)
    local rolePos = entity.clientTransformComponent.transform.position
    local targetPos = self.target.position

	local isContainPos, isFixedBase = self:IsContainPos(rolePos, targetPos)
    if isContainPos then
		if isFixedBase and self.dynamicCameraDis then
			self.dynamicCameraDis = math.max(self.dynamicCameraDis - 0.1, self.base.BodyCameraDistance)
		end
		return
	end

	local curDis = self:GetCurCameraDistance()
    if curDis >= params.maxDis then return end
    local maxDistance = params.maxDis
	local newDis = math.min(curDis + 0.1, maxDistance)
	self.dynamicCameraDis = newDis
end

function FightCamera:IsContainPos(pos1, pos2)
    local cameraComponent = self.cameraManager.mainCameraComponent
    local left = cameraComponent.rect.xMin
    local right = cameraComponent.rect.xMax
    local top = cameraComponent.rect.yMax
    local bottom = cameraComponent.rect.yMin

    local point1ScreenPos = cameraComponent:WorldToViewportPoint(pos1)
    local point2ScreenPos = cameraComponent:WorldToViewportPoint(pos2)
    local isPoint1InsideCamera = point1ScreenPos.x >= left and point1ScreenPos.x <= right and point1ScreenPos.y >= bottom and point1ScreenPos.y <= top
    local isPoint2InsideCamera = point2ScreenPos.x >= left and point2ScreenPos.x <= right and point2ScreenPos.y >= bottom and point2ScreenPos.y <= top
		
	local fixedBase = (point2ScreenPos.x >= 0.1 and point2ScreenPos.x <= 0.9) and (point2ScreenPos.y >= 0.1 and point2ScreenPos.y <= 0.9)

	return isPoint1InsideCamera and isPoint2InsideCamera, fixedBase
end

function FightCamera:GetCurCameraDistance()
	return self.body.m_CameraDistance
end

function FightCamera:SetCameraDistance(distance)
	if not self.base or not self.curParams then return end
	self.fixedOffsetCameraDis = distance - self.body.m_CameraDistance
	if editor then
		self.cameraRuntimeParms.Base.BodyCameraDistance = distance
	end
end

function FightCamera:ChangeCameraDistance(isChange, changeVal)
	self.isChangeCameraDistance = isChange
	if not isChange then
		self.changeDisVal = nil
		return
	end
	
	self.changeDisVal = changeVal
end

------------- 相机碰撞修正逻辑修改 ----------------
function FightCamera:UpdateTestCollider()
	if self.correctTime and self.correctTime > 0 then
		return
	end
	local lookatTarget = self.target.transform
	local targetPos = lookatTarget.position
	local cameraTrans = self.cameraManager.mainCameraTransform
	local cameraPos = cameraTrans.position
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(ctrlEntity)
	local entityPos = entity.clientTransformComponent.transform.position
	local dir = Vec3.Normalize(entityPos - cameraPos)
	local dis = self:GetCurCameraDistance()

	if not self.cameraCollider then return end
	local isDisplaced = self.cameraCollider:CameraWasDisplaced(self.cinemachineCamera)
	if not isDisplaced then
		self.isDisplacedTime = 0
		return
	else
		self.isDisplacedTime = self.isDisplacedTime or 0
		self.isDisplacedTime = self.isDisplacedTime + FightUtil.deltaTimeSecond
		if self.isDisplacedTime < 1 then return end
	end

	local curRotation = cameraTrans.rotation
	local euler = Quat.ToEulerAngles(curRotation)
	local crossVal = Vec3.Cross(cameraPos - targetPos, targetPos - entityPos)
	local addVal = crossVal.y > 0 and 50 or -50
	local y = Quat.NormalizeEuler(euler.y + addVal)

	-- 正向旋转50检查是否有碰撞
	local newQuat = Quat.Euler(euler.x, y, euler.z)
	local newDir = newQuat * dir
	local newPos = cameraPos + newDir * dis

	local isHit
	local AimTargetLayer = FightEnum.LayerBit.Default|FightEnum.LayerBit.Water|FightEnum.LayerBit.Terrain|FightEnum.LayerBit.NoClimbing|FightEnum.LayerBit.Marsh
	newDir = Vec3.Normalize(entityPos - newPos)
	isHit = CustomUnityUtils.CheckRayCastHit(newPos, newDir, dis, AimTargetLayer)
	if not isHit then
		self:SetCorrectEulerData(true, 3, CorrectEulerVal, euler.y + addVal)
	end
end