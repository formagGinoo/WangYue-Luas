---@class NavPathDrawItem 道路引导线
NavPathDrawItem = BaseClass("NavPathDrawItem",PoolBaseClass)

local Vec3 = Vec3
local _random = math.random
local _max = math.max
local _min = math.min
local _abs = math.abs
local _floor = math.floor
local _clamp = MathX.Clamp
local _ceil = math.ceil
local _atan = math.atan
local _sqrt = math.sqrt
local _huge = math.huge

local refreshDelayTime = 3
local refreshDelayDis = 1
local _navPathMaxDistance = 100

function NavPathDrawItem:__init()
    self.pos = Vec3.New(0,0,0)
	self.cachePath = {}
	self.curDrawPoint = {}
	self.curDrawPoint3D = {}
	self.curDrawPointUI = {}
	self.currCachePath = {}
	self.addUpTime = 0
	self.DD_cache1 = self.DD_cache1 or Vec3.New()
	self.DD_cache2 = self.DD_cache2 or Vec3.New()
	self.DD_cache3 = self.DD_cache3 or Vec3.New()
	self.DD_cache4 = self.DD_cache4 or Vec3.New()
	self.DD_cache5 = self.DD_cache5 or Vec3.New()
	self.DD_cache6 = self.DD_cache6 or Vec3.New()
	self.DD_cache7 = self.DD_cache7 or Vec3.New()
	self.DD_cache8 = self.DD_cache8 or Vec3.New()
end


function NavPathDrawItem:Init(type, args, navPathDrawInstanceId, mapNavPathInstanceId)  
	self.type = type
	self.args = args
	self.NavPathDrawInstanceId = navPathDrawInstanceId
	self.mapNavPathInstanceId = mapNavPathInstanceId
	
	if type == FightEnum.NavPathDrawType.Static then
		local color = args[2]
		self.color = color
		local pointList = args[1]
		self:DrawPosList(pointList)
		EventMgr.Instance:Fire(EventName.UpdateRoadPath, navPathDrawInstanceId, self.mapNavPathInstanceId)
	elseif type == FightEnum.NavPathDrawType.Self2Static then
		local color = args[3]
		self.color = color
		-- 获取目标所在道路信息
		local targetPos = args[1]
		self.targetStreetId = Fight.Instance.entityManager.trafficManager:GetClosestStreet(targetPos)
		self:Update()

	elseif type == FightEnum.NavPathDrawType.self2Entity then
		local color = args[3]
		self.color = color
		self:Update()
	end

end

--- 画静态线
---@param pointList any
function NavPathDrawItem:DrawPosList(pointList)
	if Fight.Instance:GetFightMap() ~= 10020005 then
		return
	end
	self:ClearPath()
	local startPos = pointList[1]
	local startTrackPoint = Fight.Instance.entityManager.trafficManager:CreateTrackPoint(startPos,1)
	table.insert(self.cachePath,startTrackPoint)
	for i = 2, #pointList, 1 do
		local v = pointList[i]
		if not Fight.Instance.entityManager.trafficManager:GetTrackPathTarget(startPos,v,self.cachePath,true,nil,nil,nil) then
			break
		end
		startPos = v
	end
	
	for k, v in ipairs(self.cachePath) do
		local targetVec3 = Fight.Instance.entityManager.trafficManager:PopVec3A(v.pos)
		targetVec3.y = targetVec3.y  + Fight.Instance.entityManager.trafficManager.defaultGuideHigh
		table.insert(self.curDrawPoint, targetVec3 )
		v:OnCache()
	end
	TableUtils.ClearTable(self.cachePath)

	
	-- 计算ui显示线
	self.curDrawPoint3D = self.curDrawPoint
	Fight.Instance.entityManager.trafficManager:PushVec3List(self.curDrawPointUI)
	if #self.curDrawPoint > 1 then
		table.insert(self.curDrawPointUI, Fight.Instance.entityManager.trafficManager:PopVec3A(self.curDrawPoint[1]))
		for i = 2, #self.curDrawPoint -1, 1 do
			
			self.DD_cache6:SetA(self.curDrawPoint[i])
			self.DD_cache6:Sub(self.curDrawPoint[i - 1])
			self.DD_cache7:SetA(self.curDrawPoint[i + 1])
			self.DD_cache7:Sub(self.curDrawPoint[i])
			self.DD_cache6.y = 0
			self.DD_cache7.y = 0

			local dotValue = Vec3.Dot(self.DD_cache6:SetNormalize() ,self.DD_cache7:SetNormalize())
			-- 如果和前一个向量没啥差别，就不加了
			if dotValue < 0.9999  then
				table.insert(self.curDrawPointUI, Fight.Instance.entityManager.trafficManager:PopVec3A(self.curDrawPoint[i]))
			end
		end
		table.insert(self.curDrawPointUI, Fight.Instance.entityManager.trafficManager:PopVec3A(self.curDrawPoint[#self.curDrawPoint]))
	end

end

function NavPathDrawItem:Update()
	if Fight.Instance:GetFightMap() ~= 10020005 then
		return
	end
	
	local deltaTime = FightUtil.deltaTimeSecond
	self.addUpTime = self.addUpTime + deltaTime

	if self.type == FightEnum.NavPathDrawType.Self2Static then
		self:_doUpdate()
	elseif self.type == FightEnum.NavPathDrawType.self2Entity then
		self:_doUpdate()
	end
end


-- 计算路线传入画线器
-- 计算一次路径每次按照当前位置截取，如果检测到偏移路径3秒则重新计算路径
function NavPathDrawItem:_doUpdate()

	local pos -- 当前位置
	local targetPos  -- 目标位置
	local targetStreetId   -- 目标街道
	local unloadDis	-- 卸载距离
	if self.type == FightEnum.NavPathDrawType.Self2Static then
		local curEntityId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
		local selfEntity = Fight.Instance.entityManager:GetEntity(curEntityId)
		pos = selfEntity.transformComponent:GetPosition()
		targetPos = self.args[1]
		unloadDis = self.args[2] or Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMin
		targetStreetId = self.targetStreetId
	elseif self.type == FightEnum.NavPathDrawType.self2Entity then

		local curEntityId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
		local selfEntity = Fight.Instance.entityManager:GetEntity(curEntityId)
		pos = selfEntity.transformComponent:GetPosition()

		local targetInstance = self.args[1]
		unloadDis = self.args[2] or Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMin
		-- 目标实体已消失
		local targetEntity = Fight.Instance.entityManager:GetEntity(targetInstance)
		if not targetEntity then
			Fight.Instance.mapNavPathManager:_RemoveRoadGuideEffect(self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
			return
		end
		targetPos = targetEntity.transformComponent:GetPosition()
		targetStreetId = Fight.Instance.entityManager.trafficManager:GetClosestStreet(targetPos)
	end

	-- 到达卸载距离
	if Vec3.DistanceXZ(pos,targetPos) < unloadDis then
		Fight.Instance.mapNavPathManager:_RemoveRoadGuideEffect(self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
		return
	end



	local playerDriving = BehaviorFunctions:CheckCtrlDrive()
	local isPlayerDrivingChange = false
	if self.playerDriving ~= playerDriving then
		self.playerDriving  = playerDriving
		isPlayerDrivingChange = true
		if not playerDriving then
			Fight.Instance.entityManager.trafficManager:PushVec3List(self.curDrawPoint3D)
			Fight.Instance.entityManager.trafficManager:PushVec3List(self.curDrawPointUI)
			Fight.Instance.entityManager.trafficManager:PushVec3List(self.curDrawPoint)
			self.curStreetId = nil
			self.lastPos = nil
			EventMgr.Instance:Fire(EventName.UpdateRoadPath, self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
		end
	end

	-- 获取当前所在道路信息
	local curStreetId = Fight.Instance.entityManager.trafficManager:GetClosestStreet(pos)
	local curPointIndex,roadLine,isProject = Fight.Instance.entityManager.trafficManager:GetClosestStartPointIndex(pos,curStreetId,true)
	local streetCenter = Fight.Instance.entityManager.trafficManager.trafficMapConfig.streetConfig[curStreetId]

	-- 起点或终点未搜寻到道路
	if curStreetId == 0 or targetStreetId == 0 then
		Fight.Instance.mapNavPathManager:_RemoveRoadGuideEffect(self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
		return
	end

	-- 检查位移
	local posChange = true
	if not self.lastPos or not self.lastTarPos then
		self.lastPos = Vec3.New(pos.x,pos.y,pos.z)
		self.lastTarPos = Vec3.New(targetPos.x,targetPos.y,targetPos.z)
		posChange = true
	else
		local patSens = playerDriving and Fight.Instance.entityManager.trafficManager.defaultGuidePatSens or refreshDelayDis
		posChange = Vec3.DistanceXZ(self.lastPos,pos) > patSens or Vec3.DistanceXZ(self.lastTarPos,targetPos) > patSens
	end

	if not posChange and not isPlayerDrivingChange then
		return 
	end
	

	self.lastPos:SetA(pos)
	self.lastTarPos:SetA(targetPos)

	local selfChange = self.curStreetId ~= curStreetId
	local targetChange = self.targetStreetId ~= targetStreetId
	local sameStreet = curStreetId == targetStreetId
	local needRefresh = not self.curStreetId or targetChange or sameStreet

	-- 当前最近道路变化
	if not needRefresh and selfChange then
		
		local isGoesOff = true
		for i, v in ipairs(self.cachePath) do
			if v.streetIndex == curStreetId then
				isGoesOff = false
			end
		end
		if isGoesOff then
			-- 偏离导航
			if not self.goesOffTime then
				self.goesOffTime = self.addUpTime
			end
		else
			
			self.goesOffTime = nil
		end
	end
	self.curStreetId = curStreetId
	self.targetStreetId = targetStreetId

	-- 偏离超过一定时间
	if self.goesOffTime and self.addUpTime - self.goesOffTime > refreshDelayTime then
		needRefresh = true
		self.goesOffTime = nil
	end

	if isPlayerDrivingChange then
		needRefresh = true
		self.goesOffTime = nil
	end
	
	-- 道路信息变化，整体重新寻路
	if needRefresh then
		for i, v in ipairs(self.cachePath) do
			v:OnCache()
		end
		TableUtils.ClearTable(self.cachePath)
		Fight.Instance.entityManager.trafficManager:GetTrackPathTarget(pos,targetPos,self.cachePath,true,-1,nil,nil,true)
	
	end
	
	-- 清理容器
	Fight.Instance.entityManager.trafficManager:PushVec3List(self.curDrawPoint)
	Fight.Instance.entityManager.trafficManager:PushVec3List(self.curDrawPoint3D)
	Fight.Instance.entityManager.trafficManager:PushVec3List(self.curDrawPointUI)

	--不开车状态且与目标点小于100米时，不画道路线
	if not playerDriving and Vec3.DistanceXZ(pos,targetPos) < _navPathMaxDistance then
		EventMgr.Instance:Fire(EventName.UpdateRoadPath, self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
		return
	end

	local addFunc = function(newPoint)
		table.insert(self.curDrawPoint, Fight.Instance.entityManager.trafficManager:PopVec3(newPoint.x,newPoint.y + Fight.Instance.entityManager.trafficManager.defaultGuideHigh,newPoint.z))
	end

	if #self.cachePath > 0 then
		-- 计算当前画线起点
		local minDist = _huge
		local closeIndex = 1
		for k, v in ipairs(self.cachePath) do
			local tmpDis = Vec3.DistanceXZ(pos,v.pos)
			if tmpDis < minDist then
				minDist = tmpDis
				closeIndex = k
			end
		end
		-- 根据投影判断是否+1
		if closeIndex < #self.cachePath then
			self.DD_cache1:SetA(self.cachePath[closeIndex+1].pos)
			self.DD_cache1:Sub(self.cachePath[closeIndex].pos)
			self.DD_cache1.y = 0
			local lineDirection = self.DD_cache1:SetNormalize()

			self.DD_cache2:SetA(pos)
			self.DD_cache2:Sub(self.cachePath[closeIndex].pos)
			self.DD_cache2.y = 0
			local lineDirection2 = self.DD_cache2:SetNormalize()

			if Vec3.Dot(lineDirection2 , lineDirection) > 0 then
				closeIndex = closeIndex + 1
			end
		end

		-- 添加当前画线
		for i = closeIndex, #self.cachePath, 1 do
			local v = self.cachePath[i]
			addFunc(v.pos)
		end

		-- 计算3d显示线
		local startDirect1 = self.DD_cache5 -- 内指导点方向
		local startDirect2 = self.DD_cache8 -- 内指导点方向
		if closeIndex > 1 then
			startDirect1:SetA(self.cachePath[closeIndex - 1].pos)
			startDirect2:SetA(self.cachePath[closeIndex].pos)
		else
			startDirect1:SetA(pos) -- 保底指向自己
			startDirect2:SetA(self.cachePath[1].pos)
		end

		local nearIndex
		local outIndex
		-- 计算显示范围的内外点
		local firstUnload = false

		local showNearDirect = false
		local showOutDirect = false
		for i, newPovint in ipairs(self.curDrawPoint) do

			local newPovint = self.curDrawPoint[i]
			-- 第一个大于显示范围的点
			if Vec3.DistanceXZ(newPovint,pos) > Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMax then
				outIndex = i
				showOutDirect = true
				break
			end
			-- 最后一个小于显示范围的点
			if Vec3.DistanceXZ(newPovint,pos) < Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMin then
				nearIndex = i
			else
				showNearDirect = true
			end
		end
		local startPos = nearIndex and nearIndex + 1 or 1
		local endPos = outIndex and outIndex - 1 or #self.curDrawPoint

		if self.playerDriving then
			if #self.curDrawPoint > 1 then

				-- 内指导点
				if showNearDirect then
					if startPos > 1 and startPos <= #self.curDrawPoint then
						startDirect1 = self.curDrawPoint[startPos - 1]
						startDirect2 = self.curDrawPoint[startPos]
					end

					local dirNormal = self.DD_cache3
					local firstPos  = self.DD_cache4


					-- 在指导方向上的投影点
					Fight.Instance.entityManager.trafficManager:FindProjectionPoint(pos, startDirect2, startDirect1 ,firstPos)
					-- 指导方向
					dirNormal:SetA(startDirect2)
					dirNormal:Sub(startDirect1)
					dirNormal:SetNormalize()
					local addLength = 0
					if Vec3.SquareDistanceXZ(firstPos,pos) < Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMin^2 then
						addLength = _sqrt(Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMin^2 - Vec3.SquareDistanceXZ(firstPos,pos))
					end
					firstPos:Add( dirNormal:Mul(addLength))
					firstPos.y = self.curDrawPoint[1].y
					table.insert(self.curDrawPoint3D,Fight.Instance.entityManager.trafficManager:PopVec3(firstPos.x,firstPos.y,firstPos.z))
				end


				-- 插入内外点范围内的点
				for i = startPos, endPos, 1 do
					table.insert(self.curDrawPoint3D, Fight.Instance.entityManager.trafficManager:PopVec3A(self.curDrawPoint[i]))
				end

				-- 外指导点
				if showOutDirect and endPos > 0 then

					local endDirect1 = self.curDrawPoint[endPos]
					local endDirect2 = self.curDrawPoint[endPos + 1]

					local dirNormal = self.DD_cache3
					local firstPos  = self.DD_cache4

					-- 在指导方向上的投影点
					Fight.Instance.entityManager.trafficManager:FindProjectionPoint(pos, endDirect2, endDirect1 ,firstPos)
					-- 指导方向
					dirNormal:SetA(endDirect2)
					dirNormal:Sub(endDirect1)
					dirNormal:SetNormalize()
					local addLength = 0
					if Vec3.SquareDistanceXZ(firstPos,pos) < Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMax^2 then
						addLength = _sqrt(Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMax^2 - Vec3.SquareDistanceXZ(firstPos,pos))
					end
					firstPos:Add( dirNormal:Mul(addLength))
					firstPos.y = self.curDrawPoint[endPos].y
					table.insert(self.curDrawPoint3D,Fight.Instance.entityManager.trafficManager:PopVec3(firstPos.x,firstPos.y,firstPos.z))
				end

			end
		end

		-- 计算ui显示线
		if #self.curDrawPoint > 1 then
			table.insert(self.curDrawPointUI, Fight.Instance.entityManager.trafficManager:PopVec3A(self.curDrawPoint[1]))
			for i = 2, #self.curDrawPoint -1, 1 do

				self.DD_cache6:SetA(self.curDrawPoint[i])
				self.DD_cache6:Sub(self.curDrawPoint[i - 1])
				self.DD_cache7:SetA(self.curDrawPoint[i + 1])
				self.DD_cache7:Sub(self.curDrawPoint[i])
				self.DD_cache6.y = 0
				self.DD_cache7.y = 0

				local dotValue = Vec3.Dot(self.DD_cache6:SetNormalize() ,self.DD_cache7:SetNormalize())
				-- 如果和前一个向量没啥差别，就不加了
				if dotValue < 0.9999  then
					table.insert(self.curDrawPointUI, Fight.Instance.entityManager.trafficManager:PopVec3A(self.curDrawPoint[i]))
				end
			end
			table.insert(self.curDrawPointUI, Fight.Instance.entityManager.trafficManager:PopVec3A(self.curDrawPoint[#self.curDrawPoint]))
		end

	end


	EventMgr.Instance:Fire(EventName.UpdateRoadPath, self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
end

function NavPathDrawItem:ClearPath()
	
	self.nextFirstPoint = nil
	self.curStreetId = nil
	self.playerDriving = nil
	self.lastPos = nil
	self.goesOffTime = nil
	local fight = Fight.Instance
	if fight and not fight.clearing then
			
		for i, v in ipairs(self.currCachePath) do
			v:OnCache()
		end
		for i, v in ipairs(self.cachePath) do
			v:OnCache()
		end
		for i, v in ipairs(self.curDrawPoint) do
			Fight.Instance.entityManager.trafficManager:PushVec3(v)
		end
		for i, v in ipairs(self.curDrawPoint3D) do
			Fight.Instance.entityManager.trafficManager:PushVec3(v)
		end
		for i, v in ipairs(self.curDrawPointUI) do
			Fight.Instance.entityManager.trafficManager:PushVec3(v)
		end
	end
	
	TableUtils.ClearTable(self.cachePath)
	TableUtils.ClearTable(self.currCachePath)
	TableUtils.ClearTable(self.curDrawPointUI)
	TableUtils.ClearTable(self.curDrawPoint3D)
	TableUtils.ClearTable(self.curDrawPoint)
end


function NavPathDrawItem:OnCache()
	
	self.targetStreetId = nil
	self:ClearPath()
	
	local fight = Fight.Instance
	if fight and not fight.clearing and Fight.Instance.objectPool.objectPool[NavPathDrawItem] then
		Fight.Instance.objectPool:Cache(NavPathDrawItem,self)
	end

end

function NavPathDrawItem:__cache()
end

function NavPathDrawItem:__delete()
end