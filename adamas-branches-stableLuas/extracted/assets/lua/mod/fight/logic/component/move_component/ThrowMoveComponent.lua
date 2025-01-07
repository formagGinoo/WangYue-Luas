ThrowMoveComponent = BaseClass("ThrowMoveComponent",PoolBaseClass)

local Vec3 = Vec3
local SectionSpeed = 25
local Math = MathX
local math	= math
local sin 	= math.sin
local cos 	= math.cos
local tan 	= math.tan
local rad 	= math.rad
local asin 	= math.asin
local sqrt 	= math.sqrt
local min	= math.min
local max 	= math.max
local sign	= Math.sign
local atan2 = math.atan
local clamp = Math.Clamp
local abs	= math.abs

function ThrowMoveComponent:__init()
end

function ThrowMoveComponent:Init(moveComponent, moveConfig)
	self.entity = moveComponent.entity
    --自转中心
	--self.rotateSelfPos = moveConfig.RotateSelfPos
	
	self.frame = 1
	
	self.lastFrameSpeed = 0
	self.lastFrameRotateSpeed = 0

	self.moveComponent = moveComponent
	self.transformComponent = self.moveComponent.transformComponent
	
	self.enable = true
	self.EnableBounceOn = false
	
	EventMgr.Instance:AddListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:AddListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end

function ThrowMoveComponent:SetEnable(enable, delayFrame)
		self.enable = enable
end

function ThrowMoveComponent:SetTargetPos(targetPos)
    self.trackPosition = targetPos
end

function ThrowMoveComponent:SetTrackPosition(speedFrameData)
	self.speedFrameData = speedFrameData
end

function ThrowMoveComponent:SetRotateSpeedDataX(rotateSpeedDataX)
	self.rotateSpeedDataX = rotateSpeedDataX
end
function ThrowMoveComponent:SetRotateSpeedDataY(rotateSpeedDataY)
	self.rotateSpeedDataY = rotateSpeedDataY
end
function ThrowMoveComponent:SetRotateSpeedDataZ(rotateSpeedDataZ)
	self.rotateSpeedDataZ = rotateSpeedDataZ
end

-- 计算贝塞尔曲线点
function ThrowMoveComponent:CalculateBezierPoint(t, p0, p1, p2)
    local u = 1 - t
    local tt = t * t
    local uu = u * u

    local point = p0 * uu  + p1 * 2 *u * t + p2 * tt
    return point
end

-- 计算贝塞尔曲线长度
function ThrowMoveComponent:CalculateBezierLength(p0, p1, p2, numSegments)
    local length = 0
    local t = 0
    local deltaT = 1 / numSegments

	local tDis = {}
    for i = 1, numSegments do
        local pA = self:CalculateBezierPoint(t, p0, p1, p2)
        t = t + deltaT
        local pB = self:CalculateBezierPoint(t, p0, p1, p2)
		table.insert(tDis,{t = t , dis = sqrt((pB.x - p0.x)^2 + (pB.y - p0.y)^2+ (pB.z - p0.z)^2)})

        local segmentLength = sqrt((pB.x - pA.x)^2 + (pB.y - pA.y)^2+ (pB.z - pA.z)^2)
        length = length + segmentLength
    end

    return length,tDis
end
-- 设置三轴自转
function ThrowMoveComponent:SetSelfRotateSpeed(x,y,z,originX,originY,originZ)
	self.selfRotateSpeedX = x
	self.selfRotateSpeedY = y
	self.selfRotateSpeedZ = z
	self.selfRotateOriginTarget = Quat.Euler(originX,originY,originZ)
	self.initRotate = false
end

-- 矫正自转速度让目标在经过frame后到达给定角度
function ThrowMoveComponent:SetSelfRotateSpeedTarget(frame,targetX,targetY,targetZ)
	self.selfRotateTarget = Quat.Euler(targetX,targetY,targetZ)
	self.selfRotateTargetFrame = frame
	self.selfRotateTargetStartFrame = self.frame - 1
end

function ThrowMoveComponent:EnableBounce(isOn)
	
	self.EnableBounceOn = isOn
	--part:SetPartEnable(false)
	if isOn then
		if self.entity.partComponent and self.entity.partComponent.parts[1] then
			self.entity.partComponent.parts[1]:SetPartEnable(true)
			self.entity.partComponent.parts[1]:SetTriggerComponent(FightEnum.TriggerType.Collision,FightEnum.LayerBit.Default, true,true)
		end
		self.bouncing = false
	else
		
		if self.entity.partComponent and self.entity.partComponent.parts[1] then
			self.entity.partComponent.parts[1]:SetPartEnable(false)
		end
	end
end

function ThrowMoveComponent:OnEnterTriggerLayer(instanceId, layer,enterInsId,objInsId,vecter3,normal)
	if self.EnableBounceOn and instanceId == self.entity.instanceId and not self.bouncing then

		-- 大致是个水平面才反弹
		if normal.y > 0.5 then
			-- 获取碰撞面法向量，计算反弹后方向
			local x, y, z = Quat.MulVec3A(self.transformComponent.lastRotation, Vec3.forward)
			local directV3 = Vec3.New(x, y, z)
			local targetDirect = Vec3.Reflect(directV3,Vec3.New(normal.x,normal.y,normal.z) )
			targetDirect = targetDirect:Normalize()
			
			local distxz =	tan(rad(30)) * sqrt(targetDirect.x^2 + targetDirect.z^2)
			targetDirect.y = targetDirect.y > distxz  and distxz or targetDirect.y;
			-- 设置方向
			local targetQ = Quat.LookRotationA(targetDirect.x, targetDirect.y, targetDirect.z)
			self.entity.transformComponent:SetRotation(targetQ)
			
			self.rotateLock = self.bounceLockTime or nil
			self.bouncing  = true
		end
	end
end

function ThrowMoveComponent:OnExitTriggerLayer(instanceId, layer)
	if instanceId == self.entity.instanceId  then
		self.bouncing  = false
	end
end

function ThrowMoveComponent:ResetMoveData()
	self.BezierMove = nil
	self.RoundMove  = nil
	self.TraceMove = nil
	
	self.bouncing  = false
	self:EnableBounce(false)
end

-- 设置两点曲线运动，arg1可为坐标或entity
function ThrowMoveComponent:SetMoveCurve(arg1,ctrlPosRate,startPos,speed,frame,callback)
	self:ResetMoveData()
	local move = 
	{
		startPos = startPos or self.transformComponent.position,
		startFrame = self.frame -1,
		speed = speed,
		durationFrame = frame,
		callback = callback,
	}

	if arg1.Entity then
		move.trackTransform =  arg1.Entity.clientTransformComponent:GetTransform(arg1.PartName or "HitCase")
	else
		move.targetPos = arg1
	end

	local targetPos = move.trackTransform and move.trackTransform.position or move.targetPos

	local dir = targetPos - move.startPos
	if ctrlPosRate then
		local zRate = ctrlPosRate.ZRate or 0
		local xRate = ctrlPosRate.XRate or 0
		local yRate = ctrlPosRate.YRate or 0

		local rightDir = Vec3.Cross(dir, Vec3.up):Normalize()
		local ctrlPos = Vec3.Lerp(move.startPos,targetPos,zRate) 
	
		local dist = Vec3.Distance(targetPos, move.startPos)
		
		local upDir = Vec3.up

		move.ctrlPos = ctrlPos + rightDir * xRate * dist
		move.ctrlPos = ctrlPos + upDir * yRate * dist
	else
		move.ctrlPos = Vec3.Lerp(move.startPos,targetPos,0.5)
	end
	
	local tdis = nil
	-- 总长和30个t点的长度信息
	move.totalPath,tdis = self:CalculateBezierLength(move.startPos, move.ctrlPos, targetPos,30)

	-- 单帧位移长度
	if frame then
		local singlePath = move.totalPath /frame
		move.tList = {}
		for i = 1, frame, 1 do
			local targetT = 0
			for k, v in ipairs(tdis) do
				-- 找到距离当前帧最近的一个t点
				if v.dis >= singlePath*i and not move.tList[i] then
					move.tList[i] = v.t
				end
			end
			if not move.tList[i] then
				move.tList[i] = 1
			end
		end
	end
	
	

	self.BezierMove = move
end

-- 追踪，arg1可为坐标或entity
function ThrowMoveComponent:SetMoveTrackTarget(arg1,reachDistance,callback,enableBounce,bounceLockTime,maxAngleY)
	self:ResetMoveData()
	local move = 
	{
		reachDistance = reachDistance,
		callback = callback,
		maxAngleY = maxAngleY
	}
	
	if arg1.clientTransformComponent then
		move.instanceId = arg1.instanceId
		move.trackTransform = arg1.clientTransformComponent:GetTransform("HitCase")
	else
		move.targetPos = arg1
	end

	self.TraceMove = move
	
	self:EnableBounce(enableBounce)
	self.bounceLockTime = bounceLockTime or nil
end

-- 设置圆周运动
function ThrowMoveComponent:SetMoveRound(arg1,radius,speed,quat)
	
	self:ResetMoveData()
	local move = 
	{
		trackTransform = arg1.clientTransformComponent and arg1.clientTransformComponent:GetTransform("HitCase"),
		targetPos = arg1.clientTransformComponent and nil or arg1,
		speed = speed,
		radius = radius,
		targetRotation =  quat
	}
	self.RoundMove = move

end

function ThrowMoveComponent:GetSpeed(scale)
	self.frameSpeed = self.speedFrameData and self.speedFrameData[self.frame] or self.lastFrameSpeed
	self.frameRotateSpeed = self.rotateSpeedFrameData and self.rotateSpeedFrameData[self.frame] or self.lastFrameRotateSpeed
	
	self.lastFrameSpeed = self.frameSpeed
	self.lastFrameRotateSpeed = self.frameRotateSpeed
	

	return self.frameSpeed * scale * FightUtil.deltaTimeSecond
end


function ThrowMoveComponent:GetTrackPosition()

	if not self.TraceMove then return nil end

	if BehaviorFunctions.CheckEntity(self.TraceMove.instanceId ) and not UtilsBase.IsNull(self.TraceMove.trackTransform) then
		return self.TraceMove.trackTransform.position
	end
	
	if not self.TraceMove.targetPos then
		local pos = self.entity.transformComponent.position
		local forward = self.entity.transformComponent.rotation * Vec3.forward
		return pos + forward * 100 --没有目标就往前飞
	end
	
	return self.TraceMove.targetPos
end


function ThrowMoveComponent:GetRotateSpeed()
	if self.rotateLock and self.rotateLock > 0 then
		return 0
	else
		return self.frameRotateSpeed
	end
end

function ThrowMoveComponent:SetTrackSpeedCurve(SpeedCurveId, RotateSpeedCurveId) 
	self.frame = 1
	self.speedFrameData = CurveConfig.GetCurve(self.entity.parent.entityId , SpeedCurveId)
	self.rotateSpeedFrameData = CurveConfig.GetCurve(self.entity.parent.entityId , RotateSpeedCurveId)
end

function ThrowMoveComponent:SetTrackSpeed( constSpeed , constRotateSpeed) 
	self.lastFrameSpeed = constSpeed
	self.lastFrameRotateSpeed = constRotateSpeed
	self.speedFrameData = nil
	self.rotateSpeedFrameData = nil
end

function ThrowMoveComponent:Update()
	if not self.enable then
		return
	end
	
	self.model = self.model or self.entity.clientTransformComponent.model
	
	-- 自转运动
	if self.selfRotateSpeedX and self.selfRotateSpeedY and self.selfRotateSpeedZ  then
			
		local scale = 1
		if self.entity.timeComponent then
			--scale = self.entity.timeComponent:GetTimeScale()
		end
	
		local rotation = Quat.CreateByUnityQuat(self.model.transform.localRotation) 

		local offsetX = self.selfRotateSpeedX * scale
		local offsetY = self.selfRotateSpeedY * scale
		local offsetZ = self.selfRotateSpeedZ * scale
		
		if self.selfRotateOriginTarget and not self.initRotate then
			rotation = self.selfRotateOriginTarget
			self.initRotate = true
		end
		
		rotation =  rotation * Quat.Euler(offsetX,offsetY,offsetZ)
		
		if self.selfRotateTarget then
			local t = (self.frame - self.selfRotateTargetStartFrame)/self.selfRotateTargetFrame
			
			if t == 1 then
				local da = nil
			end
			rotation = Quat.Lerp(rotation, self.selfRotateTarget, t)
			if t == 1 then
				self.selfRotateTarget = nil
				self.selfRotateTargetFrame = nil
				self.selfRotateTargetStartFrame = nil
			end
		end

		self.model.transform.localRotation = rotation:ToUnityQuat()
		--self.model.transform:Rotate(selfRotateSpeedX,selfRotateSpeedY,selfRotateSpeedZ)
	end


	-- 两点曲线运动
	if self.BezierMove then
		
		local scale = 1
		if self.entity.timeComponent then
			--scale = self.entity.timeComponent:GetTimeScale()
		end
		
		local targetPos = self.BezierMove.trackTransform  and self.BezierMove.trackTransform.position or self.BezierMove.targetPos
		
		self.BezierMove.t = self.BezierMove.t or 0
		self.BezierMove.path = self.BezierMove.path or 0
		local startPos = self.entity.transformComponent.position
		if self.BezierMove.speed then
			local dist = Vec3.Distance(targetPos, startPos)
			local speed = self.BezierMove.speed * scale * FightUtil.deltaTimeSecond
			self.BezierMove.path = self.BezierMove.path + speed
			self.BezierMove.t = self.BezierMove.path/self.BezierMove.totalPath
		else
			self.BezierMove.t = self.BezierMove.tList[self.frame - self.BezierMove.startFrame]
		end
		
		
		local curPoint = self:CalculateBezierPoint(self.BezierMove.t, self.BezierMove.startPos, self.BezierMove.ctrlPos, targetPos)
		
		self.entity.transformComponent:SetPositionOffset(curPoint.x-startPos.x,curPoint.y-startPos.y,curPoint.z-startPos.z)
		
		if self.BezierMove.t >= 1 then
			local endCb = self.BezierMove.callback
			self.BezierMove = nil
			if endCb then
				endCb()
			end
		end
	elseif self.TraceMove then
		
	-- 追踪运动
		local scale = 1
		if self.entity.timeComponent then
			--scale = self.entity.timeComponent:GetTimeScale()
		end

		local targetPos =  self:GetTrackPosition()

		local speed = self:GetSpeed(scale)
		local rotateSpeed = self:GetRotateSpeed() * scale
		if self.rotateLock then
			self.rotateLock = self.rotateLock -  scale * FightUtil.deltaTimeSecond
		end

		local dist = Vec3.Distance(targetPos, self.entity.transformComponent.position)
	
		local distPos = targetPos - self.entity.transformComponent.position
		distPos = Vec3.New(distPos.x,distPos.y,distPos.z):Normalize()
		if  self.TraceMove.maxAngleY then
			local distxz = sqrt(distPos.x^2 + distPos.z^2)
			distPos.y = clamp(distPos.y, tan(rad(- self.TraceMove.maxAngleY)) * distxz, tan(rad(self.TraceMove.maxAngleY)) * distxz)
		end
		local targetQ = Quat.LookRotationA(distPos.x, distPos.y, distPos.z)
		

		local rotate = Quat.RotateTowards(self.transformComponent.rotation, targetQ, rotateSpeed)
		self.entity.transformComponent:SetRotation(rotate)
	
		self.moveComponent:DoMoveForward(speed)
		self.moveComponent:AfterUpdate()

		if self.TraceMove and dist <= self.TraceMove.reachDistance then
			local endCb = self.TraceMove.callback
			if endCb then
				endCb()
			end
		end
	elseif self.RoundMove then

	-- 圆周运动
		local scale = 1
		if self.entity.timeComponent then
			--scale = self.entity.timeComponent:GetTimeScale()
		end

		local radius = self.RoundMove.radius
		local targetPos = nil 
		if self.RoundMove.trackTransform then
			local posU3d = self.RoundMove.trackTransform.position
			targetPos = Vec3.New(posU3d.x,posU3d.y,posU3d.z) 
		else
			targetPos = self.RoundMove.targetPos
		end
		local speed = self.RoundMove.speed * scale * FightUtil.deltaTimeSecond

		local startPos = self.transformComponent.position
		local dist = Vec3.Distance(targetPos, startPos)

		if not self.RoundMove.reachCircle then
			if self.RoundMove.outRound == nil then
				self.RoundMove.outRound = dist > radius
			end
			-- 1.先找到上圆轨的点，差值去到圆轨上
			local moveToPoint = nil
			local reachTrack = false
			if not self.RoundMove.outRound  then
				-- 目前点在圆心内，那么根据圆心和当前点画出直径为圆轨半径的小圆，找到小圆和圆轨切点
				local calPos = Vec3.New(startPos.x,targetPos.y,startPos.z)
				local smallRound,reachRing = self:FindCircleCenter(targetPos,calPos,radius/2)
				reachTrack = reachRing
				moveToPoint = targetPos + (smallRound - targetPos) * 2
			else
				-- 如果当前在圆外，找到离速度方向最近的切点
			
				local direct = Vec3.Normalize(startPos - targetPos)

				local angle = atan2(direct.z, direct.x)
				local a = nil
				
				if dist < radius then
					a = asin(1)	-- 已经抵达圆上
					reachTrack = true
				else
					a = asin(radius / dist)-- 计算圆上切点与圆心的连线与圆心到外点的连线的夹角
				end
				local delta = angle - a -- 计算连线与 x 轴正方向的夹角
				local pos1 = Vec3.New(targetPos.x + radius* cos(delta)  ,targetPos.y,targetPos.z + radius* sin(delta) )
				delta = angle + a -- 计算连线与 x 轴正方向的夹角
				local pos2 = Vec3.New(targetPos.x + radius* cos(delta)  ,targetPos.y,targetPos.z + radius* sin(delta) )

				local dot1 = Vec3.Dot(self.transformComponent.velocity, pos1 - startPos)
				local dot2 = Vec3.Dot(self.transformComponent.velocity, pos2 - startPos)
				moveToPoint = dot1 > dot2 and pos1 or pos2
			end

			local moveToDis = Vec3.Distance(moveToPoint, startPos) 
			moveToDis = moveToDis<= 0 and 0.000001 or moveToDis
			local curPoint = Vec3.Lerp(startPos, moveToPoint, speed/moveToDis)

			if not self.RoundMove.TotalPathToRound then
				self.RoundMove.TotalPathToRound = moveToDis
			end
			self.RoundMove.t = clamp(1 - (moveToDis/self.RoundMove.TotalPathToRound),0,1)
			
			
			if reachTrack then
				self.RoundMove.reachCircle = true
				self.RoundMove.t = 1
				
				-- 根据速度方向判断顺逆时针
				local speedVet = self.transformComponent.velocity
				local toPoint = targetPos - startPos
				toPoint:Normalize()
				self.RoundMove.clockwise = (toPoint.x * speedVet.z - speedVet.x * toPoint.z) < 0
					
			end

			if self.RoundMove.targetRotation then
				local newRot = Quat.Lerp(self.entity.transformComponent.rotation,self.RoundMove.targetRotation,self.RoundMove.t)
				self.entity.rotateComponent:SetRotation(newRot)
			end
			
			self.entity.transformComponent:SetPositionOffset(curPoint.x-startPos.x,curPoint.y-startPos.y,curPoint.z-startPos.z)
			
		else
			-- 2.转圈
			if not self.RoundMove.angle then
				local angleDir = startPos - targetPos
				angleDir = angleDir:Normalize()
				self.RoundMove.angle= math.atan(angleDir.z,angleDir.x)
				local singt  = sin(self.RoundMove.angle)
				local cost  = cos(self.RoundMove.angle)
			end
			
			local w = self.RoundMove.clockwise and speed/radius or -speed/radius 
			self.RoundMove.angle = self.RoundMove.angle + w
			local curPoint = targetPos + Vec3.New(cos(self.RoundMove.angle) * radius,0,sin(self.RoundMove.angle) * radius) 
			
			self.entity.transformComponent:SetPositionOffset(curPoint.x-startPos.x,curPoint.y-startPos.y,curPoint.z-startPos.z)
		end

	end

		
	if self.frame then
		self.frame = self.frame + 1
	end
end

function ThrowMoveComponent:FindCircleCenter(pos1, pos2, radius)
    -- 计算两点之间的距离
    local d = Vec3.Distance(pos1, pos2)
    
    -- 计算两点的中点坐标
	local midPos = Vec3.Lerp(pos1, pos2,0.5)
    
    -- 计算两点之间的中垂线长度
	local h = nil
	local reach = false
	if (d/2 > radius) then
		-- 已经去到圆外
		h = 0 
		reach = true
	else
		h = sqrt(radius * radius - (d / 2) * (d / 2))
	end
		
    -- 计算中垂线的方向向量
    local dirX = (pos1.z - pos2.z) / d
    local dirZ = (pos2.x - pos1.x) / d
    
    -- 计算圆心坐标
	midPos.x = midPos.x + h * dirX
	midPos.z = midPos.z + h * dirZ
    
    return midPos,reach
end

function ThrowMoveComponent:OnCache()
	
	self.moveComponent.fight.objectPool:Cache(ThrowMoveComponent,self)
	EventMgr.Instance:RemoveListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:RemoveListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end

function ThrowMoveComponent:__cache()
end

function ThrowMoveComponent:__delete()
	EventMgr.Instance:RemoveListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:RemoveListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end