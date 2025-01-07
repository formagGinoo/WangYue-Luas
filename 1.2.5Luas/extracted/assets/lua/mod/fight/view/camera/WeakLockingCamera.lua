WeakLockingCamera = BaseClass("WeakLockingCamera",CameraMachineBase)

function WeakLockingCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.cameraParent = cameraManager.camera.transform:Find("WeakLocking")
	self.camera = self.cameraParent:Find("WeakLockingCamera")
	--self.noise = CinemachineInterface.GetNoise(self.camera)
	--self.noise = self.cameraManager.noise
	CinemachineInterface.SetCinemachineNoiseExtend(self.camera,self.cameraManager.noise)
	self.noise = CinemachineInterface.GetNoise(self.camera)
	-- self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cinemachineCamera = self.camera.gameObject:GetComponent(Cinemachine.CinemachineVirtualCamera)
	self.targetGroup = self.cameraParent:Find("TargetGroup")--.gameObject:GetComponent(Cinemachine.CinemachineTargetGroup)
	--self.cinemachineCamera.m_LookAt = self.targetGroup.transform
	--self.cinemachineCamera.m_Follow = self.targetGroup.transform
	self.framingTransposer = CinemachineInterface.GetFramingTransposer(self.camera)
	--self.composer = CinemachineInterface.GetComposer(self.camera)
	self.lockingPOV = CinemachineInterface.GetCinemachinePOV(self.camera.transform)
	self.blendInfo = self.cameraManager.cinemachineBrain.m_CustomBlends:GetBlendForVirtualCameras("WeakLockingCamera","WeakLockingCamera",self.cameraManager.cinemachineBrain.m_DefaultBlend)
	self.curve = self.blendInfo.m_CustomCurve
	self.minDisAngle = 30 --首次的修正角度
	self.maxDisAngle = 75
	self.minDisAngleFix = 10 --第二次的修正角度
	self.maxDisAngleFix = 75
	self.minDistance = 1
	self.maxDistance = 12
	self.blendTime = self.blendInfo.BlendTime
	self.curBlendTime = -1
	self.startValue = 0
	self.targetValue = 0
	
	
	self.owBlendInfo = self.cameraManager.cinemachineBrain.m_CustomBlends:GetBlendForVirtualCameras("OperatingCamera","WeakLockingCamera",self.cameraManager.cinemachineBrain.m_DefaultBlend)
	self.owCurve = self.owBlendInfo.m_CustomCurve
	self.owBlendTime = self.owBlendInfo.BlendTime
	self.owCurBlendTime = 0
	self.first = true
	
	self.offsetZ = 0
	self.lastOffsetZ = 0
	
	self.disOffset = 0
	
	self.bottomBlendInfo = self.cameraManager.cinemachineBrain.m_CustomBlends:GetBlendForVirtualCameras("WeakLockingCameraBottom","WeakLockingCamera",self.cameraManager.cinemachineBrain.m_DefaultBlend)
	self.bottomCurve = self.bottomBlendInfo.m_CustomCurve
	self.bottomBlendTime = self.bottomBlendInfo.BlendTime
	self.isBottom = false
	
	self.m_XDamping = self.framingTransposer.m_XDamping
	self.m_YDamping = self.framingTransposer.m_YDamping
	self.m_ZDamping = self.framingTransposer.m_ZDamping
	self.cinemachineCamera.m_Follow = self.targetGroup.transform
	self.cinemachineCamera.m_LookAt = self.targetGroup.transform
end

function WeakLockingCamera:SetMainTarget(target)
	if self.mainTarget == target then
		return
	end
	--self.cinemachineCamera.m_Follow = target
	--self.cinemachineCamera.m_LookAt = target
	--if self.mainTarget then
		--self.targetGroup:RemoveMember(self.mainTarget)
	--end
	self.mainTarget = target
	self.rotation = self.mainTarget.rotation
	--self.targetGroup:AddMember(self.mainTarget,1,1)
end

function WeakLockingCamera:SetCameraMgrNoise()
	self.noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	self.cameraManager.noise = self.noise
end

function WeakLockingCamera:SetMixing(mixTransform)
	self.cinemachineCamera.transform:SetParent(mixTransform)
end

function WeakLockingCamera:SetTarget(target,targetEntity)
	self.targetEntity = targetEntity
	if self.target == target then
		return
	end
	if self.target then
		--self.targetGroup:RemoveMember(self.target)
	end
	self.targetEntity = targetEntity
	self.target = target
	self.first = true
	--self.targetGroup:AddMember(self.target,1,1)
end

function WeakLockingCamera:ClearTarget()
	--self.target = nil
end

function WeakLockingCamera:Update(lerpTime)
	if not self.mainTarget then
		return
	end
	self.targetGroup.transform.position = self.mainTarget.position
	
	if UtilsBase.IsNull(self.target) then
		return
	end
	local targetPosition = self.target.position
	targetPosition.y = self.mainTarget.position.y
	self.targetGroup.transform:LookAt(targetPosition)
	--if self.target and not UtilsBase.IsNull(self.target) then
		--local pos = (self.mainTarget.position + self.target.position) * 0.5
		--pos.y = self.mainTarget.position.y
		--self.targetGroup.position = pos
	--else
		--self.targetGroup.position = self.mainTarget.position
	--end
	--self:CheckTarget()
	--if self.curBlendTime > 0 then
		--self.curBlendTime = self.curBlendTime - Global.deltaTime
		--local axisH = self.lockingPOV.m_HorizontalAxis
		--axisH.Value = axisH.Value + self.speed * Global.deltaTime
		--self.lockingPOV.m_HorizontalAxis = axisH
	--end
	self:UpdateOffset()
	if self.cameraManager:CheckPauseCameraRotate() then
		return
	end
	
	if self.cameraManager.cinemachineBrain.IsBlending then
		self.blendWeight = self.cameraManager.cinemachineBrain.ActiveBlend.BlendWeight
		--Log("self.blendWeight "..self.blendWeight)
		local curValue = self.startValueVertical + (self.targetValueVertical - self.startValueVertical) * self.blendWeight
		local axisV = self.lockingPOV.m_VerticalAxis
		axisV.Value = curValue
		self.lockingPOV.m_VerticalAxis = axisV
	end
	
	if self.needRotate  then
		if self.forceFix then
			local timeScale = 1--self.cameraManager:GetMainRoleTimeScale() or 1
			self.forceFixCurTime = self.forceFixCurTime + Global.deltaTime * timeScale
			if self.forceFixCurTime > self.forceFixTime then
				self.forceFix = false
				self.needRotate = false
				return
			end
			local deltaTime = 1/30
			local roleLerpTime = (self.forceFixCurTime % deltaTime) / deltaTime
			local frame = math.floor(self.forceFixCurTime * 30) + 1
			local lastValue = 0
			if frame > 1 then
				lastValue = self.forceFixCurve[frame-1]
			end
			local curValue = self.forceFixCurve[frame]
			local value = lastValue + (curValue - lastValue) * roleLerpTime * timeScale
			local dif = self.targetValue - self.startValue
			dif = dif > 180 and 360 - dif or dif
			dif = dif < -180 and 360 + dif or dif
			local curValue = self.startValue + dif * value
			local axisH = self.lockingPOV.m_HorizontalAxis
			axisH.Value = curValue
			self.lockingPOV.m_HorizontalAxis = axisH
			return
		elseif self.first then
			--self.blendWeight = self.cameraManager.cinemachineBrain.ActiveBlend.BlendWeight
			--Log("frame = "..self.cameraManager.clientFight.fight.fightFrame..self.cameraManager.cinemachineBrain.ActiveBlend.CamA.Name.." - "..self.cameraManager.cinemachineBrain.ActiveBlend.CamB.Name)
			--Log("frame = "..self.cameraManager.clientFight.fight.fightFrame.." self.blendWeight "..self.blendWeight)
			self.owCurBlendTime = self.owCurBlendTime + Global.deltaTime
			if self.owCurBlendTime >= self.owBlendTime then
				self.needRotate = false
				self.first = false
				self.owCurBlendTime = 0
				self.curBlendTime = -1
				return
			end
			self.blendWeight = self.owCurve:Evaluate(self.owCurBlendTime / self.owBlendTime)
			--Log("self.blendWeight 1 "..self.blendWeight)
			local dif = self.targetValue - self.startValue
			dif = dif > 180 and 360 - dif or dif
			dif = dif < -180 and 360 + dif or dif
			local curValue = self.startValue + dif * self.blendWeight
			local axisH = self.lockingPOV.m_HorizontalAxis
			axisH.Value = curValue
			self.lockingPOV.m_HorizontalAxis = axisH
			self.curBlendTime = -1
			return
		elseif self.curBlendTime >= 0 then
			--self.needRotate = false
			self.curBlendTime = self.curBlendTime + Global.deltaTime
			local blendTime = self.isBottom and self.bottomBlendTime or self.blendTime
			if self.curBlendTime >= blendTime then

				self.needRotate = false
				--Log("done "..self.curBlendTime)
				self.curBlendTime = -1
				self:CheckTarget()
				return
			end
			local curve = self.isBottom and self.bottomCurve or self.curve 
			self.blendWeight = curve:Evaluate(self.curBlendTime / blendTime)
			local dif = self.targetValue - self.startValue
			dif = dif > 180 and 360 - dif or dif
			dif = dif < -180 and 360 + dif or dif
			local curValue = self.startValue + dif * self.blendWeight
			local axisH = self.lockingPOV.m_HorizontalAxis
			--if not self.isBottom and math.abs(axisH.Value - curValue) > 3 and math.abs(axisH.Value - curValue) < 90 then
				----Log("self.blendWeight 2 "..self.blendWeight.."dif = "..(axisH.Value - curValue))
				--self.needRotate = false
				--self:CheckTarget()
				--curValue = axisH.Value
				
				----Log("done "..self.curBlendTime)
				--self.curBlendTime = -1
			--end
			--Log("self.blendWeight "..self.blendWeight.." curValue = "..axisH.Value.." target = "..curValue)
			--if math.abs(curValue - axisH.Value) > 180 then
				--if curValue >  axisH.Value then
					--curValue = curValue - 360
				--else
					--curValue = curValue + 360
				--end
			--end
			axisH.Value = curValue
			--Log("axisH.Value "..axisH.Value)
			self.lockingPOV.m_HorizontalAxis = axisH
			if self.curBlendTime >= blendTime then
				
				self.needRotate = false
				--Log("done "..self.curBlendTime)
				self.curBlendTime = -1
				self:CheckTarget()
				return
			end
			if not self.isBottom then
				self:UpdateTargetValue()
			end
			self:CheckTargetOutScreen()
		else
			self.needRotate = false
			self:CheckTarget()
		end
	else
		self:CheckTarget()
	end
	
end

function WeakLockingCamera:AfterUpdate(isNotState)
	if UtilsBase.IsNull(self.target) then
		return
	end
	self.targetGroup.transform.position = self.mainTarget.position
	local pos = self.target.position
	pos.y = self.mainTarget.position.y
	self.targetGroup.transform:LookAt(pos)
	--local target = Quaternion.LookRotation(pos)
	--local dir = pos - self.mainTarget.position

	--self.targetGroup.transform:LookAt(targetPosition)
	--self.rotation = Quaternion.Slerp(self.rotation, target,20 * Global.deltaTime);
	--self.mainTarget.rotation = self.rotation
	----self.mainTarget:LookAt(self.target)
	if isNotState then
		local offset = self.framingTransposer.m_TrackedObjectOffset
		offset.z = math.max(offset.z - 0.02,0)
		self.framingTransposer.m_TrackedObjectOffset = offset
	end
end

local offsetMinDis = 2
local offsetMaxDis = 8
local offsetMin = 0.8
local offsetMax = 1.5
function WeakLockingCamera:UpdateOffset()
	--local pos = self.target.position
	--pos.y = self.mainTarget.position.y
	--self.mainTarget:LookAt(pos)
	local x1 = self.mainTarget.position.x
	local z1 = self.mainTarget.position.z
	local x2 = self.target.position.x
	local z2 = self.target.position.z
	local dis = math.sqrt((x1-x2)*(x1-x2)+(z1-z2)*(z1-z2))
	--local offset = 0
	if dis <= offsetMinDis then
		self.offsetZ = offsetMin 
	elseif dis >= offsetMaxDis then
		self.offsetZ = offsetMax
	else
		local offset = (dis - offsetMinDis) / (offsetMaxDis - offsetMinDis)
		--print(offset,dis)
		self.offsetZ = offsetMin + (offsetMax - offsetMin) * offset
	end
	--Log("dis = "..dis..", self.offsetZ = "..self.offsetZ)
	local m_TrackedObjectOffset = self.framingTransposer.m_TrackedObjectOffset
	--m_TrackedObjectOffset.z = self.offsetZ
	
	--m_TrackedObjectOffset.z = Mathf.Lerp(m_TrackedObjectOffset.z,self.offsetZ,0.5)--m_TrackedObjectOffset.z * self.blendWeight
	local z = math.min(m_TrackedObjectOffset.z + 0.01,self.offsetZ) * (self.cameraDistance) / self.cameraDistance

	m_TrackedObjectOffset.z = z >= dis and dis or z
	self.framingTransposer.m_TrackedObjectOffset = m_TrackedObjectOffset

	--self.framingTransposer.m_TrackedObjectOffset = m_TrackedObjectOffset
	
	local pos = self.mainTarget.position + self.mainTarget.forward * m_TrackedObjectOffset.z
	pos.y = self.cameraManager.mainCamera.transform.position.y
	local dis = Vector3.Distance(pos,self.cameraManager.mainCamera.transform.position)
	
	local pos2 = self.mainTarget.position
	pos2.y = self.cameraManager.mainCamera.transform.position.y
	local dis2 = Vector3.Distance(pos2,self.cameraManager.mainCamera.transform.position)
	
	self.disOffset = dis - dis2
	local finalCameraDistance = self.cameraDistance + self.disOffset
	local curCameraDistance = self.framingTransposer.m_CameraDistance
	local fix = finalCameraDistance > curCameraDistance and 1 or -1 
	local cameraDistance = math.min(curCameraDistance + 0.01*fix,finalCameraDistance)
	self.framingTransposer.m_CameraDistance = cameraDistance
	--Log("self.disOffset "..self.disOffset)
	--local dis2 = Vector3.Distance(Vector3.Project(self.mainTarget.position-self.cameraManager.mainCamera.transform.position,self.cameraManager.mainCamera.transform.forward)
		--,Vector3.zero)
	--self.disOffset = 4.5 - dis2
	--Log("dis "..dis2)
	--self.framingTransposer.m_CameraDistance = 4.5 + self.disOffset
end

function WeakLockingCamera:UpdateTargetValue()
	--do return end
	local targetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.target.position)
	if targetPoint.z > 0.5 and targetPoint.x > 0.2 and targetPoint.x < 0.8 and targetPoint.y > 0.3 then
		return
	end
	local targetValue = self:GetAngle(self.mainTarget.position.x,self.mainTarget.position.z,self.target.position.x,self.target.position.z)
	targetValue = targetValue < 0 and targetValue + 360 or targetValue
	local newTargetValue = targetValue
	--Log("self.targetValue1 "..targetValue)
	--targetValue = targetValue - self.fixAngle
	local fixAngle = self:GetFixAngle()
	--Log("fixAngle "..fixAngle)
	local curValue = self:GetHorizontalAxisValue()
	curValue = curValue < 0 and curValue + 360 or curValue
	local dif = math.abs(targetValue - curValue)
	if math.abs(targetValue - curValue) > 180 then
		if targetValue > curValue then
			newTargetValue = targetValue - 360 + fixAngle
		else
			newTargetValue = targetValue + 360 - fixAngle
		end
	else
		if targetValue > curValue then
			newTargetValue = targetValue - fixAngle
		else
			newTargetValue = targetValue + fixAngle
		end
	end
	--self.startValue = curValue
	self.targetValue = newTargetValue
end

function WeakLockingCamera:CheckTargetOutScreen()
	local targetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.target.position)
	if self:TargetIsFly() then
		if targetPoint.x < 0 or targetPoint.x > 1 or targetPoint.y < 0 then
			self:CheckTarget(true)
		end
	else
		if targetPoint.x < 0 or targetPoint.x > 1 or targetPoint.y < 0 then
			self:CheckTarget(true)
		end
	end
	
end

function WeakLockingCamera:GetYBound()
	--if self.targetEntity then
		--local instanceId = self.targetEntity.instanceId
		--local targetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.target.position)
		--local mainYargetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.mainTarget.position)
		--if targetPoint.z < mainYargetPoint.z and self:TargetIsFly() then
			--return 0.5
		--end
	--end
	return 0.2
end

function WeakLockingCamera:TargetIsFly()
	if not self.targetEntity then 
		return false
	end
	local instanceId = self.targetEntity.instanceId
	return BehaviorFunctions.CheckHitType(instanceId,FightEnum.EntityHitState.HitFly)
	or BehaviorFunctions.CheckHitType(instanceId,FightEnum.EntityHitState.HitFlyUp)
	or BehaviorFunctions.CheckHitType(instanceId,FightEnum.EntityHitState.HitFlyUpLoop)
	or BehaviorFunctions.CheckHitType(instanceId,FightEnum.EntityHitState.HitFlyFall)
	or BehaviorFunctions.CheckHitType(instanceId,FightEnum.EntityHitState.HitFlyFallLoop)
	or BehaviorFunctions.CheckHitType(instanceId,FightEnum.EntityHitState.HitFlyHover)
	--or BehaviorFunctions.CheckHitType(instanceId,FightEnum.EntityHitState.HitFlyLand)
	--or BehaviorFunctions.CheckHitType(instanceId,FightEnum.EntityHitState.Lie)
end

function WeakLockingCamera:CheckTarget(first,forceFix)
	local mainTargetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.mainTarget.position)
	local targetPoint = self.cameraManager.mainCameraComponent:WorldToViewportPoint(self.target.position)
	--Log("targetPoint z "..targetPoint.z)
	--if targetPoint.z < 0 then
	--targetPoint.x = targetPoint.x * -1
	--end
	self.first = first
	if self.first then
		--Log("first")
		self.owCurBlendTime = 0
	end
	local y = self:GetYBound()
	self.isBottom = targetPoint.z > mainTargetPoint.z or targetPoint.y < y
	if forceFix then
		if targetPoint.z > mainTargetPoint.z and targetPoint.x > 0.2 and targetPoint.x < 0.8 and targetPoint.y > y then
			--Log("targetPoint x "..targetPoint.x)
			if not self.needRotate then
				self.needRotate = false
				self.curBlendTime = -1
			end
			return
		end
	else
		if targetPoint.z > 0.5 and targetPoint.x > 0.2 and targetPoint.x < 0.8 and targetPoint.y > y then
			--Log("targetPoint x "..targetPoint.x)
			if not self.needRotate then
				self.needRotate = false
				self.curBlendTime = -1
			end
			return
		end
	end
	
	
	if self.isBottom then
		--Log("isBottom")
	end
	if not self.needRotate then
		self.curBlendTime = 0
	end
	self.needRotate = true
	
	--local cross = Vector3.Cross(self.cameraManager.mainCamera.transform.forward, self.target.position).y
	--local cross = Vector3.Cross(self.target.position - self.mainTarget.position, self.cameraManager.cameraRoot.transform.position).y
	 --= Global.deltaTime * 30
	--if cross > 0 then --right
	local targetValue = self:GetAngle(self.mainTarget.position.x,self.mainTarget.position.z,self.target.position.x,self.target.position.z)
	targetValue = targetValue < 0 and targetValue + 360 or targetValue
	--Log("self.targetValue1 "..targetValue)
	--targetValue = targetValue - self.fixAngle
	local fixAngle = self:GetFixAngle(first)
	--Log("fixAngle "..fixAngle)
	local curValue = self:GetHorizontalAxisValue()
	curValue = curValue < 0 and curValue + 360 or curValue
	local dif = math.abs(targetValue - curValue)
	local fix = false
	if fixAngle > dif then
		--fix = true
	end
	local newTargetValue = targetValue
	if math.abs(targetValue - curValue) > 180 then
		if targetValue > curValue then
			newTargetValue = targetValue - 360 + fixAngle
		else
			newTargetValue = targetValue + 360 - fixAngle
		end
	else
		if targetValue > curValue then
			newTargetValue = targetValue - fixAngle
		else
			newTargetValue = targetValue + fixAngle
		end
	end
	--curValue = curValue < 0 and curValue + 360 or curValue
	--curValue = curValue > 360 and curValue - 360 or curValue
	--newTargetValue = newTargetValue < 0 and newTargetValue + 360 or newTargetValue
	--newTargetValue = newTargetValue > 360 and newTargetValue - 360 or newTargetValue
	--Log("self.targetValue1 "..newTargetValue)
	--Log("self.startValue1 "..curValue)
	--if math.abs(curValue - newTargetValue) > 180  then
		--if curValue > newTargetValue then
			--curValue = 360 - curValue
		--else
			--newTargetValue = 360 - newTargetValue
		--end
	--end
	self.startValue = curValue
	self.targetValue = newTargetValue
	--Log("self.targetValue2 "..self.targetValue)
	--Log("self.startValue2 "..self.startValue)
	--local difValue = targetValue - curValue
	--Log("difValue 1 "..difValue)
	--difValue = difValue > 180 and -(360 - difValue) or difValue
	--difValue = difValue < -180 and 360 + difValue or difValue
	--difValue = difValue > 0 and difValue - self.fixAngle or difValue + self.fixAngle
	--Log("targetValue "..targetValue)
	--Log("curValue "..curValue)
	--Log("difValue 2 "..difValue)
	--if difValue > 0 then
		--difValue = difValue - self.fixAngle
	--else
		--difValue = difValue + self.fixAngle
	--end
	--self.speed =  difValue / self.blendTime
end


function WeakLockingCamera:GetFixAngle(first)
	local minAngle = first and self.minDisAngle or self.minDisAngleFix
	local maxAngle = first and self.maxDisAngle or self.maxDisAngleFix
	local dis = Vector3.Distance(self.mainTarget.position,self.target.position)
	--Log("dis = "..dis)
	if dis < self.minDistance then
		dis = self.minDistance
	end
	if dis > self.maxDistance then
		dis = self.maxDistance
	end
	local p = dis / (self.maxDistance - self.minDistance)
	local fixAngle = minAngle + (maxAngle - minAngle) * (1-p)
	--Log("fixAngle "..fixAngle)
	return fixAngle
end

function WeakLockingCamera:SetFOV(fov)
	local lens = self.cinemachineCamera.m_Lens
	lens.FieldOfView = fov
	self.cinemachineCamera.m_Lens = lens
end

function WeakLockingCamera:GetFOV()
	local lens = self.cinemachineCamera.m_Lens
	return lens.FieldOfView
end

function WeakLockingCamera:UpdateTarget()
	if not self.mainTarget then
		return
	end
	
	if not UtilsBase.IsNull(self.target) then
		--local pos = (self.mainTarget.position + self.target.position) * 0.5
		local pos = self.target.position
		pos.y = self.mainTarget.position.y
		self.targetGroup.position = pos
	else
		self.targetGroup.position = self.mainTarget.position
	end
	
end

function WeakLockingCamera:GetAngle(selfX,selfZ,targetX,targetZ)
	local cameraPosition = self.cameraManager.mainCamera.transform.position
	local angle = Vector2.SignedAngle(Vector2(selfX,selfZ)-Vector2(targetX,targetZ)
		,Vector2.up) + 180
	return angle
end

function WeakLockingCamera:GetHorizontalAxisValue()
	local axisH = self.lockingPOV.m_HorizontalAxis
	return axisH.Value
end

function WeakLockingCamera:GetVerticalAxisValue()
	local axisV = self.lockingPOV.m_VerticalAxis
	return axisV.Value
end

function WeakLockingCamera:UpdatePosition(position,rotate)
	--self.cinemachineCamera:ForceCameraPosition(position,rotate)
end

function WeakLockingCamera:ForceFix(curveId,time)
	self:CheckTarget(true,true)
	self.forceFix = true
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.fight.entityManager:GetEntity(ctrlEntity)
	self.forceFixCurve = CurveConfig.GetCurve(entity.entityId, curveId,1000)
	self.forceFixTime = time
	self.forceFixCurTime = 0
end

function WeakLockingCamera:OnEnter()
	--Log("WeakLockingCamera:OnEnter()")
	self.needRotate = false
	self.cinemachineCamera.gameObject:SetActive(true)
	--local position = self.cameraManager.cinemachineBrain.transform.position
	--local rotation = self.cameraManager.cinemachineBrain.transform.rotation
	--self.framingTransposer.m_ScreenX = 0.5
	--self.composer.m_ScreenX = 0.5
	--self:UpdateOffset()
	--self.cinemachineCamera:ForceCameraPosition(position,rotation)
	--local axisV = self.lockingPOV.m_VerticalAxis
	--axisV.Value = 8
	--self.lockingPOV.m_VerticalAxis = axisV
	
	local axisH = self.lockingPOV.m_HorizontalAxis
	axisH.Value = self.cameraManager.cinemachineBrain.transform.rotation.eulerAngles.y
	self.lockingPOV.m_HorizontalAxis = axisH
	self.framingTransposer.m_TrackedObjectOffset = Vector3.zero
	--self.cameraManager.cinemachineBrain:SetCameraOverride(2,self.cinemachineCamera,self.cinemachineCamera,1,Time.deltaTime)
	self.framingTransposer.m_XDamping = 0.1
	self.framingTransposer.m_YDamping = 0.1
	self.framingTransposer.m_ZDamping = 0.1
	self.startValueVertical = self:GetVerticalAxisValue()
	self.targetValueVertical = 8
	self.fixOffsetZ = 0
	self.first = true
	self.needRotate = false
	self:CheckTarget(true)
	--self.cameraManager.cinemachineBrain:ManualUpdate()
	--Log(self:GetAngle(self.mainTarget.position.x,self.mainTarget.position.z,self.targetGroup.position.x,self.targetGroup.position.z))
	--self.cameraManager.cinemachineBrain:ManualUpdate()
	--if self.cameraManager.cinemachineBrain.IsBlending then
		--self.blendTime = self.cameraManager.cinemachineBrain.ActiveBlend.Duration
	--end
end

function WeakLockingCamera:SetCameraParams(id,coverDefult)
	if not self.defult or coverDefult then
		self.defult = id
	end
	if id == nil then
		id = self.defult
	end
	--Log(self.disOffset)
 	local config = Config.CameraParams[id]
	--self.framingTransposer.m_CameraDistance = config.CameraDistance + self.disOffset
	if config.Fov then
		local lens = self.cinemachineCamera.m_Lens
		lens.FieldOfView = Config.CameraParams[id].Fov
		self.cinemachineCamera.m_Lens = lens
	end
	if config.BodySoftWidth then
		self.framingTransposer.m_SoftZoneWidth = config.BodySoftWidth
	end
	if config.BodySoftHeight then
		self.framingTransposer.m_SoftZoneHeight = config.BodySoftHeight
	end
	self.cameraDistance = config.CameraDistance 
	--if Config.CameraParams[id].CameraDistance.AimSoftWidth then

	--end
	--if Config.CameraParams[id].CameraDistance.AimSoftWidth then

	--end
end

function WeakLockingCamera:OnLeave()
	--Log("WeakLockingCamera:OnLeave()")
	self.needRotate = false
	self.targetEntity = nil
	self.defult = nil
	--self.lastTargetPointX = nil
	--self.target = nila
	--self.framingTransposer.m_ScreenX = 0.5
	--self.composer.m_ScreenX = 0.5
	self.framingTransposer.m_XDamping = 0.2
	self.framingTransposer.m_YDamping = 0.2
	self.framingTransposer.m_ZDamping = 0.2
	self.lastOffsetZ = 0
	self.cinemachineCamera.gameObject:SetActive(false)
	--self.framingTransposer.m_TrackedObjectOffset = Vector3.zero
end

function WeakLockingCamera:UpdateTargetOffset(targetPositionOffset)
	self.framingTransposer.m_TrackedObjectOffset = targetPositionOffset
end
function WeakLockingCamera:SetOffsetZ(offsetZ)
	self.fixOffsetZ = offsetZ
end

function WeakLockingCamera:UpdateTargetRotation(targetPositionOffset)
	local axisH = self.lockingPOV.m_HorizontalAxis
	axisH.Value = axisH.Value + targetPositionOffset.x
	self.lockingPOV.m_HorizontalAxis = axisH

	local axisV = self.lockingPOV.m_VerticalAxis
	axisV.Value = axisV.Value + targetPositionOffset.y
	self.lockingPOV.m_VerticalAxis = axisV
end

function WeakLockingCamera:SetSoftZone(unlimited)
	self.framingTransposer.m_UnlimitedSoftZone = unlimited
end

function WeakLockingCamera:SetBodyDamping(x,y,z)
	self.framingTransposer.m_XDamping = x
	self.framingTransposer.m_YDamping = y
	self.framingTransposer.m_ZDamping = z
end

function WeakLockingCamera:SetDefaulBodyDamping()
	self.framingTransposer.m_XDamping = self.m_XDamping
	self.framingTransposer.m_YDamping = self.m_YDamping
	self.framingTransposer.m_ZDamping = self.m_ZDamping
end

function WeakLockingCamera:__delete()
end