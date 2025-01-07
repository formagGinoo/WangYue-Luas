TrackPointMoveComponent = BaseClass("TrackPointMoveComponent",PoolBaseClass)

local Vec3 = Vec3
local Quat = Quat
local _clamp = MathX.Clamp
local _min = math.min
local _max = math.max
local _abs = math.abs
local _sqrt = math.sqrt
local _random = math.random
local _huge = math.huge

local DeccelerateMaxAngle = 25 --转弯角度，比这个大就开始减到固定速度
local DeccelerateMinAngle = 8 --转弯角度，比这个大就开始减速
local DeccFixSpeedInterval = 0.3 -- 转弯减速阈值
local MinRotateSpeed = 2 --最小的转弯速度

local MovementState = {
	Idle = 1,
	SpeedUp = 2,
	SpeedDown = 3,
	TurnLeft = 4,
	TurnRight = 5,
}


local MoveType = {
	none = 0,
	default = 1,
	tcca = 2
}

local checkBlockSpeedTcca = 0.1

local MovementState2Anim = {
	[MovementState.Idle] = "Stand1",
	[MovementState.SpeedUp] = "SpeedUp",
	[MovementState.SpeedDown] = "SpeedDown",
	[MovementState.TurnLeft] = "TurnLeft",
	[MovementState.TurnRight] = "TurnRight",
}

function TrackPointMoveComponent:__init()
end

function TrackPointMoveComponent:Init(moveComponent, config)
	self.entity = moveComponent.entity
	self.moveComponent = moveComponent
	self.rotateComponent = self.entity.rotateComponent
	self.transformComponent = self.entity.transformComponent
	self.config = config
	
	self.acc = config.TrackPointAcceleration * FightUtil.deltaTimeSecond
	self.decc = config.TrackPointDeceleration * FightUtil.deltaTimeSecond
	self.maxSpeed = config.TrackPointMaxSpeed * FightUtil.deltaTimeSecond
	self.calcMaxSpeed = self.maxSpeed
	self.obstacleDistance = config.TrackPointObstacleDistance
	
	self.trafficManager = Fight.Instance.entityManager.trafficManager

	self.speed = 0
	self.targetSpeed = self.maxSpeed
	
	self.trackPath = nil
	self.curStreetIndex = -1
	self.curCrossIndex = -1
	self.targetIdx = -1
	
	self.obstacleDis = _huge -- 当前检测到最近的障碍距离
	self.enable = true
	self.enableBlock = true
	self.blockFrame = 0
	self.EnableCheckOb = true
	self.MoveType = MoveType.none
	self.tcca = nil
	self.lastCheckIndex = nil
	self.roadPointCheckBlock = true

	self.DD_cache1 = self.DD_cache1 or Vec3.New()
	self.DD_cache2 = self.DD_cache2 or Vec3.New()
	self.DD_cache3 = self.DD_cache3 or Vec3.New()

	self._lastPosition = Vec3.New()
	self._curPosition = Vec3.New()

	self.AiCarController = Fight.Instance.objectPool:Get(AiCarController)
	
	EventMgr.Instance:AddListener(EventName.FightPause, self:ToFunc("OnFightPause"))
end

function TrackPointMoveComponent:LateInit()
	self:RelateTCCA()
    self.modelWheels = self.entity.clientTransformComponent:GetTransformGroup("wheelsModel")
    self.wheels = self.entity.clientTransformComponent:GetTransformGroup("wheels")
end
function TrackPointMoveComponent:RelateTCCA()
	if not self.entity then
		return 
	end
	
	local gb = self.entity.clientTransformComponent.gameObject
	if not gb then
		return 
	end
	
	self.tcca = gb:GetComponent(TCCAInvoke)
	if not self.tcca then
		self.tcca = gb:AddComponent(TCCAInvoke)
	end
	
	self.AiCarController:Init(self)
end



--都是车子相关的参数，改为其他实体需要重载，包括GetSpeed、GetRotation、CheckReach
function TrackPointMoveComponent:InitParams()
	-- 达到满速后，减速阶段的行驶距离
	self.deccMoveDistance = 0.5 * self.decc * (self.maxSpeed / self.decc)^2
	-- 到达下个点的范围
	self.reachRange = 2.5 --self.trafficParams.road_width * 0.5

	self.rootTransform = self.entity.clientTransformComponent:GetTransform()
	self.checkTransform = self.entity.clientTransformComponent:GetTransform("ObstacleCheck")
	if not self.checkTransform then
		self.checkTransform = self.rootTransform
	end

	self.forwardTransform = self.entity.clientTransformComponent:GetTransform("ForwardCheck")
	self.backTransform = self.entity.clientTransformComponent:GetTransform("BackCheck")

	local vec = self.forwardTransform.position - self.rootTransform.position
	self.wheelToGroundOffset = Vec3.Dot(self.rootTransform.rotation * Vector3.up, vec)


	
    -- 获取车辆体积
    if self.halfCheckBox == nil then
        if self.entity.collistionComponent and #self.entity.collistionComponent.config.PartList > 0 and self.entity.collistionComponent.config.PartList[1].BoneColliders[1] then
            local size = self.entity.collistionComponent.config.PartList[1].BoneColliders[1].LocalScale
            self.halfCheckBox = Vector3(size[1], size[2], 0.1) * 0.5
            self.halfCheckBox.x = self.halfCheckBox.x
		else
			-- 检测碰撞盒：x是路面宽度，y是obstacle点到路面的2倍，z是固定值0.1
			vec = self.checkTransform.position - self.rootTransform.position
			local checkBoxY = Vec3.Dot(self.rootTransform.rotation * Vector3.up, vec) * 2
			self.halfCheckBox = Vector3(3, checkBoxY, 0.1) * 0.5
        end
    end
	if self.passCheckBox == nil then
		self.passCheckBox = Vector3(self.halfCheckBox.x + self.halfCheckBox.x/2,self.halfCheckBox.y,self.halfCheckBox.z)
	end
	
	self.movementState = MovementState.Idle
end

-- 设置是否使用路点障碍检测
function TrackPointMoveComponent:SetRoadPointCheckBlock(ison)
	
	self.roadPointCheckBlock = ison
end
function TrackPointMoveComponent:PlayStateAnim(turn, acc)	
	local state = MovementState.Idle
	if self.speed > 0 then
		state = acc > 0 and MovementState.SpeedUp or MovementState.SpeedDown

		if math.abs(turn) > 0.01 then
			state = turn > 0 and MovementState.TurnRight or MovementState.TurnLeft
		else
			state = acc == 0 and MovementState.SpeedUp or state
		end
	end

	if state == self.movementState then
		return 
	end
	self.movementState = state
	if self.entity.animatorComponent then
		--self.entity.animatorComponent:PlayAnimation(MovementState2Anim[state])
	end
end

function TrackPointMoveComponent:SetEnable(enable, enableBlock,blockDistance)
	self.enable = enable
	
	if enableBlock == nil then
		enableBlock = true
	end

	self.enableBlock = enableBlock

end

function TrackPointMoveComponent:SetTccaBlock(blockDistance)

	if self.MoveType == MoveType.tcca and self.tcca then
		self.tcca:SetBlockInDistance(blockDistance or 5)
	end
end

function TrackPointMoveComponent:ClearTrackPath()
	self:ClearCheckPoint()
	if self.trackPath then
		for i, v in ipairs(self.trackPath) do
			v:OnCache()
		end
		TableUtils.ClearTable(self.trackPath)
	end
end
function TrackPointMoveComponent:ConfigTrackPath(trackPath)

	-- 回收路点
	self:ClearTrackPath()

	for i = 1, #trackPath do
		local pointConfig = trackPath[i]
		
		if i ~= #trackPath then
			pointConfig.dir = Vec3.Normalize(trackPath[i + 1].pos - trackPath[i].pos)
		else
			
			if self.loop then 
				pointConfig.dir = trackPath[1].dir
			else
				pointConfig.dir = trackPath[i - 1].dir
			end
		end
	end

	
	--角度计算
	for i = 1, #trackPath do
		local pointConfig = trackPath[i]
		
		local curDir = pointConfig.dir
		local nextDir = pointConfig.dir
		if i ~= #trackPath then
			nextDir = trackPath[i + 1].dir
		else
			if self.loop then 
				nextDir = trackPath[1].dir
			end
		end
		curDir = Vec3.ProjectOnPlane(curDir, Vec3.up)
		nextDir = Vec3.ProjectOnPlane(nextDir, Vec3.up)
	end

	self.trackPath = trackPath
end

function TrackPointMoveComponent:GetTrackingIndex(idx)
	idx = idx + 1
	if idx > #self.trackPath then
		idx = -1
		if self.loop and #self.trackPath > 0 then
			idx = 1
		end
	end	
	return idx
end

local YOffset = 0.1
function TrackPointMoveComponent:SetTrackPath(trackPath,trafficParams,callback,loop,motor,useTcca)
	if not trackPath or #trackPath < 2 then
		LogError("传入位移路径点长度小于2，请检查")
		return
	end
	
	self.trafficParams = trafficParams
	self.trackEndCB = callback
	self.loop = loop
	self.motor = motor or -1
	self:InitParams()
	
	self:ConfigTrackPath(trackPath)
	
	
	self:SetMoveType(useTcca and MoveType.tcca or MoveType.default)
	
	if #self.trackPath > 0 then
		local point = self.trackPath[1]
		local bornPos = point.pos

		if not useTcca then
			self.transformComponent:SetPosition(bornPos.x, bornPos.y + YOffset, bornPos.z)
			self.rotateComponent:SetRotation(Quat.LookRotationA(point.dir.x ,point.dir.y ,point.dir.z))
		else
			local rotate = Quat.LookRotationA(point.dir.x ,point.dir.y ,point.dir.z)
			self.tcca:SetTransform(bornPos.x,bornPos.y + YOffset,bornPos.z,rotate.x, rotate.y, rotate.z, rotate.w)
		end
	end
	
	self.targetIdx = 1
	self:SetTargetIdx()
	--self:DrawPoints() 


	--Debug.DrawLine(point.pos, point.pos + point.dir, Color.red, 1)	
end

function TrackPointMoveComponent:DrawPoints()
	if self.drawPoints and TableUtils.GetTabelLen(self.drawPoints) > 0 then
		for k, v in pairs(self.drawPoints) do
		    GameObject.Destroy(v)
		end
		TableUtils.ClearTable(self.drawPoints)
	end
	if self.trackPath and #self.trackPath > 0 then
		self.drawPoints = self.trafficManager:DrawPoints(self.trackPath,self.entity.instanceId .. " ")
	end
end
function TrackPointMoveComponent:CheckReach(index)
	if not self.trackPath[index] or not self:CheckPass(self.trackPath[index]) then
		return false
	end
	
	local pos = self.rootTransform.position
	local nextPos = self.trackPath[index].pos
	
	return Vec3.SquareDistanceXZ(pos, nextPos) <= self.reachRange^2
end

function TrackPointMoveComponent:CheckPass(trackPoint)
	
	local result = self.trafficManager:CheckCrossPass(trackPoint.streetIndex, not trackPoint.ingnoreCross and  trackPoint.crossIndex )
	return result
end
function TrackPointMoveComponent:GetRotation(lookAt)
	if self.speed == 0 then
		return lookAt, 0
	end
	
	local pos = self.rootTransform.position

	
	local targetDir = nil
	if self.targetIdx ~= -1 then
		local nextPos = self.trackPath[self.targetIdx].pos
		targetDir = Vec3.ProjectOnPlane(Vec3.Normalize(nextPos - pos), Vec3.up)
	else
		return lookAt, 0
	end
	
	local timeScale = self.entity.timeComponent:GetTimeScale()

	
	--计算后的方向转换到原本的面向平面，即只应用Y的角度
	local rot = lookAt
	local rotTo = Quat.LookRotation(Vec3.ProjectOnPlane(targetDir, rot * Vec3.up))
	local remainDis = Vec3.Distance(self.trackPath[self.targetIdx].pos, pos)
	local remainTime = remainDis/ 50--(self.transformComponent:GetSpeed() * 2)
	local targetAngle = Quat.Angle(rot, rotTo)

	local rotateSpeed = FightUtil.deltaTimeSecond * targetAngle/remainTime  * timeScale
	local newRot = Quat.RotateTowards(rot, rotTo, rotateSpeed)
	return newRot, Vec3.Dot(self.transformComponent:GetRotation() * Vec3.right, newRot * Vec3.forward)
end

function TrackPointMoveComponent:EnableCheckObstacle(ison)
	self.EnableCheckOb = ison
end


function TrackPointMoveComponent:CheckObstacle()
	if not self.EnableCheckOb then
		return
	end


	self.CO_cache1 = self.CO_cache1 or Vec3.New()

	--考虑碰撞盒的大小，把它内嵌到车子内部，防止过近时检测错误
	local checkPosition = self.checkTransform.position - self.checkTransform.forward * self.halfCheckBox.z
	local checkDistance = self.obstacleDistance + self.deccMoveDistance + self.halfCheckBox.z

	
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local pos = player.transformComponent.position
	
	if self.roadPointCheckBlock then
		if Vec3.SquareDistanceXZ(checkPosition, pos) > 20 ^ 2 then
			if self.targetIdx ~= -1 then
				local targetPoint = self.trackPath[self.targetIdx]
	
				-- 检查玩家阻碍
				if targetPoint.streetIndex == self.trafficManager.currentStreetId and targetPoint.currentPointIndex == self.trafficManager.pointIndex and targetPoint.currentRoadLine == self.trafficManager.roadLine then
					
					local dis = self.trafficManager:DistancePointToLineSegmentXZ(pos,checkPosition, targetPoint.originPos)
					if dis < self.halfCheckBox.x then
						return true, Vec3.DistanceXZ(checkPosition, pos) , pos
					end
				end
				
				local checkIndex = self.targetIdx
				local checkBlock = false
				while not checkBlock and checkIndex do
					local checkTargetPoint = self.trackPath[checkIndex].originPos
					-- 获取检测范围内的路点填充信息
					if Vec3.SquareDistanceXZ(checkPosition, checkTargetPoint) < self.deccMoveDistance ^ 2 then
						
						local checkStreetIndex = self.trackPath[checkIndex].streetIndex
						local checkPointIndex = self.trackPath[checkIndex].pointIndex
						local checkRoadLine= self.trackPath[checkIndex].roadLine
						local lastCheckPointIndex
						if self.lastCheckIndex then
							local lastCheckPoint = self.trackPath[self.lastCheckIndex]
							if lastCheckPoint.streetIndex == checkStreetIndex and  lastCheckPoint.roadLine == checkRoadLine then
								lastCheckPointIndex = lastCheckPoint.pointIndex 
							end
						end

						checkBlock = self.trafficManager:GetRoadPointCheck(checkStreetIndex,checkPointIndex,checkRoadLine,lastCheckPointIndex)
						-- 未命中，检测下一个点
						if not checkBlock then
							local targetIdxForward
							if (checkIndex + 1) > #self.trackPath then
								targetIdxForward = (self.loop and 1 or nil)
							else
								targetIdxForward = checkIndex + 1
							end
							checkIndex = targetIdxForward
						end
						
					else
						checkIndex = nil
					end
				end
				if checkBlock then
					return true , Vec3.DistanceXZ(checkPosition, self.trackPath[checkIndex].originPos),self.trackPath[checkIndex].originPos
				end
			end
			return
		end
	end

	--self:SetHideRayCast()
	
	
	local checkForward
	if self.targetIdx ~= -1 then
		checkForward = self.CO_cache1
		checkForward:SetA(self.trackPath[self.targetIdx].pos)
		checkForward:Sub(checkPosition)
		checkForward:SetNormalize()
	else
		checkForward = self.checkTransform.forward
	end
		
	local check, dis = CS.PhysicsTerrain.NearestDistanceBoxCast(checkPosition, self.halfCheckBox, self.checkTransform.rotation,
		checkForward, checkDistance, 0, FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.CarBody,false,false, self.entity.clientTransformComponent.transform)
	
	--self:SetShowRayCast()

	local blockPos
	if dis > 0 then
		blockPos = checkPosition + self.checkTransform.forward * dis
	end
	return check, dis,blockPos
end

function TrackPointMoveComponent:SetHideRayCast()

	if self.entity.collistionComponent then
		self.entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)
	end
	
end

function TrackPointMoveComponent:SetShowRayCast()

	if self.entity.collistionComponent then
		self.entity.collistionComponent:SetCollisionLayer(FightEnum.Layer.EntityCollision)
	end
end

function TrackPointMoveComponent:CheckGround(distance, offsetY)
	local layer
	local model = self.entity.clientTransformComponent.model
	if model then
		layer = model.gameObject.layer
		model.gameObject.layer = FightEnum.Layer.IgnoreRayCastLayer
		for i = 0, model.childCount - 1 do
			model:GetChild(i).gameObject.layer = FightEnum.Layer.IgnoreRayCastLayer
		end
	end
	
	local checkDistance = distance + self.wheelToGroundOffset
	local check, yHeight, xDir, yDir, zDir = CS.PhysicsTerrain.CarCheck(self.forwardTransform.position, self.backTransform.position, 
		self.transformComponent.rotation, checkDistance, offsetY)

	if layer and self.entity.clientTransformComponent.model then
		model.gameObject.layer = layer
		for i = 0, model.childCount - 1 do
			model:GetChild(i).gameObject.layer = layer
		end
	end
	return yHeight, xDir, yDir, zDir
end

-- 这里的很多参数都是调试出来的值，不值得信任，如果表现有问题，需要考虑重构此函数
function TrackPointMoveComponent:GetTargetSpeed()
	local targetSpeed = self.calcMaxSpeed
	local forceSet = false
	
	local nextPos = self.trackPath[self.targetIdx].pos
	
	targetSpeed = 1
	
	local check, dis,blockpos = self:CheckObstacle()
	--有障碍
	if check then
		local obstacleSpeed = targetSpeed
		-- 过近了
		if dis <= self.obstacleDistance then
			obstacleSpeed, forceSet = 0, true
		-- 减速阶段相对近
		elseif dis <= self.obstacleDistance + self.deccMoveDistance * 0.2 then
			obstacleSpeed = self.calcMaxSpeed * 0.1
		-- 刚进入减速阶段
		elseif dis <= self.obstacleDistance + self.deccMoveDistance then
			obstacleSpeed = self.calcMaxSpeed * DeccFixSpeedInterval
		end
		if not self.unStopable then
			
			targetSpeed = _min(targetSpeed, obstacleSpeed)
		end

		self.obstacleDis = dis
	else
		self.obstacleDis = _huge
	end
	
	if targetSpeed == 0 then
		return 0, forceSet, blockpos
	end
	
	--点无法通过
	local pass = self:CheckPass(self.trackPath[self.targetIdx])
	local pos = self.checkTransform.position
	local squareDis = Vec3.SquareDistance(pos, nextPos)
	
	if not pass then
		local passSpeed = targetSpeed
		if squareDis <= self.obstacleDistance^2 then
			passSpeed, forceSet = 0, true
		elseif squareDis <= (self.obstacleDistance + self.deccMoveDistance)^2 then
			passSpeed = self.calcMaxSpeed * DeccFixSpeedInterval
		end
		targetSpeed = _min(targetSpeed, passSpeed)
		blockpos = self.trackPath[self.targetIdx].pos
	end
	
	if targetSpeed == 0 then
		return 0, forceSet, blockpos
	end
	
	-- 转弯减速，需要优化
	local rotateMoveSpeed = targetSpeed
	if squareDis <= self.deccMoveDistance^2 then
		rotateMoveSpeed = self.calcMaxSpeed * DeccFixSpeedInterval
		local interval = 1
		rotateMoveSpeed = rotateMoveSpeed + (1 - DeccFixSpeedInterval) * interval
	else
		-- 上一次的转弯速度，只在刚切换路径点时会用到，为了不让速度突然变化
		self.cacheTargetSpeed = nil
	end
	
	return targetSpeed, false , blockpos
end



function TrackPointMoveComponent:GetSpeed()
	local timeScale = self.entity.timeComponent:GetTimeScale()
	
	-- 强制设置速度，比如突然变成红灯或者其他实体突然距离过近
	local forceUse = false
	local blockVector
	self.targetSpeed, forceUse, blockVector = self:GetTargetSpeed()
	if _abs(self.targetSpeed - self.speed) <= 1e-6 then
		return self.speed * timeScale, 0,blockVector
	end
	
	local cacheSpeed = self.speed
	if not forceUse then
		local acc = self.targetSpeed > self.speed and self.acc or -self.decc
		self.speed = self.speed + acc * timeScale
		
		self.speed = _clamp(self.speed, 0, self.calcMaxSpeed * timeScale)
	else
		self.speed = self.targetSpeed
	end
	return self.speed * timeScale, self.speed - cacheSpeed, blockVector
end


function TrackPointMoveComponent:SetEffectEnable(ison)
	if self.tcca then
		self.tcca:SetEffectEnable(ison)
	end
end

--搜寻目标点
function TrackPointMoveComponent:SetTargetIdx()
	
	if self.targetIdx == -1 then
		return 
	end

	if not self:CheckPass(self.trackPath[self.targetIdx]) then
		local pos = self.rootTransform.position
		self:UpdateCheck(pos)
		return
	end
	
	self.STI_cache1 = self.STI_cache1 or  Vec3.New()
	self.STI_cache2 = self.STI_cache2 or  Vec3.New()

	local pos = self.rootTransform.position
	local checkPos = self.checkTransform.position
	
	if self.MoveType == MoveType.default then
		
		local targetIndex = self.targetIdx

		local errorCount = 0
		while targetIndex and self:CheckReach(targetIndex) and errorCount <= #self.trackPath do
			if (targetIndex + 1) > #self.trackPath then
				targetIndex = (self.loop and 1 or nil)
			else
				targetIndex = targetIndex + 1
			end
			errorCount = errorCount + 1
		end
		if targetIndex then
			self.targetIdx = targetIndex
		else
			self.targetIdx = -1 
		end
	else
		
		-- 因为物理可能偏航，所以通过一个循环找到targetIdx是往前还是往后推进

		local targetIdx
		local loopCount = 0
		while not targetIdx and loopCount <= 1000 do
			loopCount = loopCount + 1
			if loopCount == 1000 then
				LogError("寻找目标点出现了死循环")
				
			end
			-- 目标前点
			local targetIdxForward
			if (self.targetIdx + 1) > #self.trackPath then
				targetIdxForward = (self.loop and 1 or nil)
			else
				targetIdxForward = self.targetIdx + 1
			end
			-- 当前位置点
			local currentIdx
			if self.targetIdx - 1 < 1 then
				currentIdx = self.loop and #self.trackPath or nil
			else
				currentIdx = self.targetIdx - 1
			end
			-- 当前位置后点
			local currentIdxBackward
			
			-- 当前位置点为空，说明目标点为第一个点，退出循环
			if not currentIdx then
				if self:CheckReach(self.targetIdx) then
					self.targetIdx = targetIdxForward or -1
				end
				break
			else
				if currentIdx - 1 < 1 then
					currentIdxBackward = (self.loop and #self.trackPath or nil)
				else
					currentIdxBackward = currentIdx - 1
				end
			end


			local dis1 = self.trafficManager:DistancePointToLineSegmentXZ(pos, self.trackPath[currentIdx].pos, self.trackPath[self.targetIdx].pos)
			local dis2 
			if currentIdxBackward then
				dis2 = self.trafficManager:DistancePointToLineSegmentXZ(pos, self.trackPath[currentIdx].pos, self.trackPath[currentIdxBackward].pos)
			else
				dis2 = _huge
			end

			if self:CheckReach(self.targetIdx) then
				-- 目标点最近，目标修改为目标前点
				if not targetIdxForward then
					-- 目标前点为空，目标点为最后一个点，退出循环
					break
				end
				self.targetIdx = targetIdxForward
			elseif dis1 <= dis2 then
				self.STI_cache1:SetA(checkPos)
				self.STI_cache1:Sub(self.trackPath[self.targetIdx].pos)
				self.STI_cache2:SetA(self.trackPath[currentIdx].pos)
				self.STI_cache2:Sub(self.trackPath[self.targetIdx].pos)
				
				if Vec3.Angle(self.STI_cache1,self.STI_cache2) >= 100 then
					-- 目标点最近，目标修改为目标前点
					if not targetIdxForward then
						-- 目标前点为空，目标点为最后一个点，退出循环
						break
					end
					self.targetIdx = targetIdxForward 
				else
					-- 当前点最近，则目标就是targetIdx
					targetIdx = self.targetIdx	
				end
			else
				
				self.STI_cache1:SetA(checkPos)
				self.STI_cache1:Sub(self.trackPath[currentIdx].pos)
				self.STI_cache2:SetA(self.trackPath[currentIdxBackward].pos)
				self.STI_cache2:Sub(self.trackPath[currentIdx].pos)
				if  Vec3.Angle(self.STI_cache1,self.STI_cache2) >= 100 or self:CheckReach(currentIdx)  then
					-- 当前点最近，则目标就是targetIdx
					targetIdx = self.targetIdx
				else
					-- 当前位置后点最近，目标修改为当前点
					self.targetIdx = currentIdx
				end
			end
		end
	end


	-- 登陆所在点
	self:UpdateCheck(pos)
	
	-- 进入新道路/路口时，还原道路/路口的坐标，避免循环道路继续走变道后的道路
	if self.trackPath[self.targetIdx] then
		local newStreetIndex = self.trackPath[self.targetIdx].streetIndex
		local newCrossIndex = self.trackPath[self.targetIdx].crossIndex
		if newStreetIndex and self.curStreetIndex ~= newStreetIndex then
			self.curStreetIndex = newStreetIndex
			self.curCrossIndex = -1

			local tempIndex = self.targetIdx
        -- 当前道路终点
			while tempIndex + 1 <= #self.trackPath do
				tempIndex = tempIndex + 1
				if self.trackPath[tempIndex].streetIndex and self.trackPath[tempIndex].streetIndex == newStreetIndex then
					self.trackPath[tempIndex].pos:SetA(self.trackPath[tempIndex].originPos)
				else
					break
				end
			end
			-- 当前道路起点
			tempIndex = self.targetIdx
			while tempIndex - 1 > 0 do
				tempIndex = tempIndex - 1
				if self.trackPath[tempIndex].streetIndex and self.trackPath[tempIndex].streetIndex == newStreetIndex then
					self.trackPath[tempIndex].pos:SetA(self.trackPath[tempIndex].originPos)
				else
					break
				end
			end

		elseif newCrossIndex and self.curCrossIndex ~= newCrossIndex then
			self.curStreetIndex = -1
			self.curCrossIndex = newCrossIndex

			local tempIndex = self.targetIdx
       		 -- 当前路口终点
			while tempIndex + 1 <= #self.trackPath do
				tempIndex = tempIndex + 1
				if self.trackPath[tempIndex].crossIndex and self.trackPath[tempIndex].crossIndex == newCrossIndex then
					self.trackPath[tempIndex].pos:SetA(self.trackPath[tempIndex].originPos)
				else
					break
				end
			end
			-- 当前路口起点
			tempIndex = self.targetIdx
			while tempIndex - 1 > 0 do
				tempIndex = tempIndex - 1
				if self.trackPath[tempIndex].crossIndex and self.trackPath[tempIndex].crossIndex == newCrossIndex then
					self.trackPath[tempIndex].pos:SetA(self.trackPath[tempIndex].originPos)
				else
					break
				end
			end
		elseif not newCrossIndex and not  newStreetIndex then
			self.curStreetIndex = -1
			self.curCrossIndex = -1
		end
	end
	-- 到达终点
	if not self.loop and (self.targetIdx == #self.trackPath and self:CheckReach(self.targetIdx) or self.targetIdx == -1) then
		self:ClearCheckPoint()
		self.targetIdx = -1
		if self.trackEndCB then
			local cb = self.trackEndCB
			self.trackEndCB = nil
			cb()
		end
		
		Fight.Instance.entityManager:CallBehaviorFun("onTrackPointMoveEnd", self.entity.instanceId)
		return
	end

end

function TrackPointMoveComponent:GetCurStreetIndex()
	if self.targetIdx  ~= -1 and self.trackPath and self.trackPath[self.targetIdx] then
		return self.trackPath[self.targetIdx].streetIndex
	end
end

function TrackPointMoveComponent:UpdateCheck(pos)
	self.UC_cache1 = self.UC_cache1 or Vec3.New()
	self.UC_cache2 = self.UC_cache2 or Vec3.New()
-- 登陆所在点
	if self.targetIdx  ~= -1 then
	
		local currentCheckIndex
		if self.targetIdx - 1 < 1 then
			currentCheckIndex = self.loop and #self.trackPath or -1
		else
			currentCheckIndex = self.targetIdx - 1
		end
	
		if currentCheckIndex and currentCheckIndex ~= -1 then
			-- 判断currentCheckIndex是否仍在车体身前，这时需要更往后取点
			self.UC_cache1:SetA(pos)
			self.UC_cache1:Sub(self.trackPath[currentCheckIndex].pos)
			self.UC_cache2:SetA(self.trackPath[self.targetIdx].pos)
			self.UC_cache2:Sub(self.trackPath[currentCheckIndex].pos)
	
			if Vec3.Dot(self.UC_cache1,self.UC_cache2) < 0 then
				if currentCheckIndex - 1 < 1 then
					currentCheckIndex = self.loop and #self.trackPath or currentCheckIndex
				else
					currentCheckIndex = currentCheckIndex - 1
				end
			end
		end
		-- 所在点修改
		if currentCheckIndex ~= self.lastCheckIndex then
			self:ClearCheckPoint()
	
			if currentCheckIndex ~= -1 then
				self.lastCheckIndex = currentCheckIndex
				local currentCheckPoint = self.trackPath[currentCheckIndex]
				self.trafficManager:SetRoadPointCheck(currentCheckPoint.streetIndex,currentCheckPoint.pointIndex,currentCheckPoint.roadLine)
			end
		end
	
	end
end

function TrackPointMoveComponent:ClearCheckPoint()
	
	if self.lastCheckIndex and self.lastCheckIndex ~= -1 then
		local lastCheckPoint = self.trackPath[self.lastCheckIndex]
		self.trafficManager:RemoveRoadPointCheck(lastCheckPoint.streetIndex,lastCheckPoint.pointIndex,lastCheckPoint.roadLine)
	end
	self.lastCheckIndex = nil
end


function TrackPointMoveComponent:GetTargetTrackPoint()
	if self.targetIdx > 0 and #self.trackPath > 0 then
		return self.trackPath[self.targetIdx]
	end
end

function TrackPointMoveComponent:CountRemainToTrack()
	if self.targetIdx > 0 and #self.trackPath > 0 then
		if self.loop then
			return _huge
		else
			return #self.trackPath - self.targetIdx + 1
		end
	else
		return 0
	end
end

function TrackPointMoveComponent:GetPositonVelocity()
	if self._lastPosition and self._curPosition then
		local result = Vec3.DistanceXZ(self._lastPosition,self._curPosition) / FightUtil.deltaTimeSecond
 		return  _min(result,30)
	else
		return 0
	end
end

function TrackPointMoveComponent:Update()
	if self.entity.transformComponent then
		self._lastPosition:SetA(self._curPosition)
		self._curPosition:SetA(self.entity.transformComponent.position)
	end

	if not self.tcca then
		self:RelateTCCA()
	end
	--阻塞帧数
	if self.enableBlock then
		self.blockFrame = self.blockFrame + 1
	end
	
	self:SetTargetIdx()
	

	if not self.enable then
		self.targetIdx = -1
		return
	end
	
	if self.targetIdx == -1 then
		if self.trackPath and #self.trackPath > 0  and self.tcca then
			self.tcca:SetBlockPoint(self.trackPath[#self.trackPath].pos)
			self:ClearTrackPath()
		end
		return 
	end


	
	local speed
	local speedOffset
	if self.MoveType == MoveType.default then

		--[[
		local checkHeight = self.speed == 0 and 0.1 or self.speed
		local yHeight, xDir, yDir, zDir = self:CheckGround(checkHeight, 0)
		local lookAt = Quat.LookRotationA(xDir, yDir, zDir)
		--self.transformComponent:SetPositionOffset(0, y, 0)
		local rot, turnDot = lookAt, 0
		if self.speed > 1e-5 then
			rot, turnDot = self:GetRotation(lookAt)
			self.rotateComponent:SetRotation(rot)
		end
		
		speed, speedOffset = self:GetSpeed()
		local y = yHeight - self.entity.transformComponent.position.y
		local move = (rot * Vec3.forward) * speed
		self.move = move
		self.moveComponent:SetPositionOffset(move.x,move.y + y,move.z)
		
		self:PlayStateAnim(turnDot, speedOffset)
		]]
		
		-- 非物理改用最简单的Lerp方式
		
		self.rotate_cache1 = self.rotate_cache1 or Quat.New()
		self.rotate_cache2 = self.rotate_cache2 or Quat.New()
		self.position_cache = self.position_cache or Vec3.New()
		if self.targetIdx ~= -1 then
			local nextPos = self.trackPath[self.targetIdx].pos
			local pos = self.transformComponent.position
			local targetDistance = Vec3.Distance(nextPos,pos)
			if targetDistance > 0 then
				local x = nextPos.x - pos.x
				local y =  nextPos.y - pos.y or 0
				local z = nextPos.z - pos.z
	
				local rX, rY, rZ, rW
				
				rX, rY, rZ, rW = CustomUnityUtils.LookRotation(x, y, z, rX, rY, rZ, rW)
				
				self.rotate_cache1:Set(rX, rY, rZ, rW)
	
				speed = self:GetSpeed()
				local lerpT = speed/targetDistance
				lerpT = _clamp(lerpT, 0, 1)
				Quat.LerpA(self.transformComponent.rotation, self.rotate_cache1, lerpT*2, self.rotate_cache2)
	
				self.transformComponent:SetRotation(self.rotate_cache2)
				self.moveComponent:SetPositionOffset((nextPos.x - pos.x) * lerpT,(nextPos.y - pos.y) * lerpT,(nextPos.z - pos.z) * lerpT)
			end
			
		else
			
		end
		
	else
		local blockVector = nil
		speed, speedOffset,blockVector = self:GetSpeed()
		if self.unStopable then
			blockVector = nil
		end
		if blockVector and _abs(self.tcca:GetForwardVelocity()) < checkBlockSpeedTcca then
			speed = 0
		end
		
		self:SetTCCATargetPoint(self.targetIdx,self.motor,blockVector)
			
		self.AiCarController:Update()
	end

	if speed ~= 0 then
		self.blockFrame = 0
	end
	
end

function TrackPointMoveComponent:GetAiCarController()
	return self.AiCarController
end


function TrackPointMoveComponent:SetMoveType(type)
	if self.MoveType == type then
		return
	end
	if self.entity.collistionComponent then
		self.entity.collistionComponent:EnableCrashBox(true)
	end
	if type == MoveType.tcca then
		if self.tcca then
			
			self.MoveType = MoveType.tcca
			if self.entity.clientTransformComponent:GetIsLuaControlEntityMove()  then
				self.entity.clientTransformComponent:SetLuaControlEntityMove(false)
			end
			self:ChangeWheels(false)
			if not self.tcca:WasInitialized() then
				self.tcca:Initialize()
				self.tcca:SetAntiCarSlide(true)
			else
				self.tcca:ClearRunData()
				self.tcca:SetPause(false)
			end
			local currentV = self:GetPositonVelocity() or 0
			self.tcca:SetForwardVelocity(currentV)
		end
	else
		self:ChangeWheels(true)
		local wasInit = self.tcca:WasInitialized()
		-- 如果在tcca需要等待init完成才允许切换，否则出现movetype切换了tcca却没关的问题
		if self.MoveType ~= MoveType.tcca or (self.MoveType == MoveType.tcca and self.tcca and wasInit ) then

			self.MoveType = MoveType.default
			
			if not self.entity.clientTransformComponent:GetIsLuaControlEntityMove()  then
				self.entity.clientTransformComponent:SetLuaControlEntityMove(true)
			end	
			if self.tcca then
				self.tcca:SetPause(true)
			end
		end
	end
	
	self.entity.clientTransformComponent:Async()
end

function TrackPointMoveComponent:ChangeWheels(activeModel)
	if not self.modelWheels or not self.modelWheels then
		return
	end
	for k, bone in pairs(self.modelWheels) do
		UnityUtils.SetActive(bone.gameObject,activeModel)
	end
	for k, bone in pairs(self.wheels) do
		UnityUtils.SetActive(bone.gameObject,not activeModel)
	end
end

	


function TrackPointMoveComponent:SetTCCATargetPoint(pointIndex,motorDelta,blockVector)
	if self.tcca then
		
		self.tcca:SetPathPoint(self.trackPath[pointIndex].pos,motorDelta)
		if blockVector then
			self.tcca:SetBlockPoint(blockVector)
		else
			self.tcca:SetBlockPoint()
		end
	end
end

function TrackPointMoveComponent:OnFightPause(pause)
	if self.tcca then
		self.tcca:SetPause(pause)
	end
end

function TrackPointMoveComponent:ClearTCCATargetPoint()
	if self.tcca then
		self.tcca:ClearRunData()
		self.tcca:ClearPathPoint()
	end
end

function TrackPointMoveComponent:OnCache()
	self.trackEndCB = nil
	-- 回收路点
	self:ClearTrackPath()

	if self.tcca and self.tcca:WasInitialized() then
		self.tcca:Clear()
		self.tcca = nil
	end
	
	if self.drawPoints and TableUtils.GetTabelLen(self.drawPoints) > 0 then
		for k, v in pairs(self.drawPoints) do
		    GameObject.Destroy(v)
		end
		TableUtils.ClearTable(self.drawPoints)
	end
	
	EventMgr.Instance:RemoveListener(EventName.FightPause, self:ToFunc("OnFightPause"))
	
	Fight.Instance.objectPool:Cache(AiCarController, self.AiCarController)
	Fight.Instance.objectPool:Cache(TrackPointMoveComponent,self)
end

function TrackPointMoveComponent:__delete()
	if self.tcca and self.tcca:WasInitialized() then
		self.tcca:Clear()
		self.tcca = nil
	end
	
	if self.drawPoints and TableUtils.GetTabelLen(self.drawPoints) > 0 then
		for k, v in pairs(self.drawPoints) do
		    GameObject.Destroy(v)
		end
		TableUtils.ClearTable(self.drawPoints)
	end
	EventMgr.Instance:RemoveListener(EventName.FightPause, self:ToFunc("OnFightPause"))
end