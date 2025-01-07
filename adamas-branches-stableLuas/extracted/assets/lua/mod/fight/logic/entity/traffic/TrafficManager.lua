TrafficManager = BaseClass("TrafficManager")

local Vec3 = Vec3
local _random = math.random
local _max = math.max
local _min = math.min
local _abs = math.abs
local _floor = math.floor
local _clamp = MathX.Clamp
local _ceil = math.ceil
local _atan = math.atan
local _sin = math.sin
local _sqrt = math.sqrt
local _huge = math.huge

local DataTraffic = Config.DataTraffic.Find

local LoadType = {
	None = 0,
	Clear = 1,
	Reload = 1 << 1,
	Run = 1 << 2,
}


local TrafficLightType =
{
    Green = 1,
    FlickerGreen = 2,
    Yellow = 3,
    Red = 4
}


local TrafficLightCacheType =
{
    AlwaysPass = 1,
    AlwaysBlock = 2,
    SameSigal = 3,
    OppositeSigal= 4
}


function TrafficManager:__init(fight, entityManager)
	self.fight = fight
	self.entityManager = entityManager

	self.trafficMapConfig = nil

	self.mapLocation = {
		mapId = -1,
		areaId = -1,
	}
	self.loadType = LoadType.None

	self.trafficMode = -1
	self.enableRoadEdge = true

	self.carNum = 0
	self.carInstanceId = 0

	self.trafficLightCtrls = {}
	self.showTrafficLight = {}


	self.carCtrls = {}
	self.addCtrls = {}
	self.removeCtrls = {}
	self.navDrawId2Draw3dId = {}
	self.draw3dId2EntityId = {}
	self.draw3dId2Nav3d = {}

	self.Vec3Pool = {}

	self.enable = true

	self.StreetNodeCache = {}
	--debug
	self.debug = false

	self.defaultSearchDis = 200	-- 搜索道路距离
	self.loadCarDis = 50	-- 开始刷车的最近道路距离
	self.defaultTrackPointDis = 12	-- 默认路点最远间隔
	self.defaultCrossPointDis = 10	-- 默认路口路点间隔
	self.defaultGenPathLen = 10 -- 默认生产路径长度
	self.defaultTrackPointHighSens = 0.05 -- 默认路点高度偏移敏感度

	self.defaultGuidePathShowMax = 100 -- 默认引导线3d最远距离
	self.defaultGuidePathShowMin = 13 -- 默认引导线3d最近距离
	self.defaultGuidePatSens = 4 -- 引导线刷新敏感度
	self.defaultGuidePathUnload = 30 -- 默认引导线卸载
	self.defaultGuideHigh = 0.12 -- 默认引导线距离地面高度

	
	self.LoadInternalTimer = 0
	self.LoadInternalTime = 0.5 -- 刷车间隔

	self.NavDraw3dInstanceId = 0 -- 3d引导线实例

	self.addUpTime = 0 -- 累计时间
	self.trafficLightInterval = 12 -- 红绿灯持续
	self.trafficLightYellow = 3 -- 黄灯持续
	self.trafficLightFlicker = 3 -- 绿灯闪烁

	self.tccaLodEnable = true
	self.tccaLodDistance = 50


	self.enableAiTurnLeft = false 	-- 是否启用Ai车左转
	self.enableRedLight = true 	-- 是否显示车道红灯
	
	self.SummonInstanceId = 0 -- 召唤车实例
	self.SummonCtrl = {} -- 召唤车实例

	self.accumulateDistanceSwitch = false	-- 检测开关
	self.totalDistance = 0					-- 历史累计驾驶距离
	self.accumulationDistance = 0			-- 单次驾驶距离
	self.lastPosition = Vec3.New()
	self.frameDelay = 0

	self.pattern = "CrossRoadMesh(%d+)"
	self.roadPattern = "RoadMesh(%d+)"
	-- 路点占位检查
	self.RoadPointCheck = {}
	
	-- 交通灯信息缓存
	self.TrafficLightCache = {}
end

function TrafficManager:EnableRoadEdge(isOn)
	
	if self.enableRoadEdge == isOn then
		return
	end
	self.enableRoadEdge = isOn
    EventMgr.Instance:Fire(EventName.EnableRoadEdge, isOn)
end
function TrafficManager:SetTrafficMode(trafficMode,beginLoadCb,enCb)
	
	if self.trafficMode == trafficMode then
		return
	end

	self.trafficMode = trafficMode

	if self.mapLocation.mapId ~= 10020005  then
		return
	end
	
	
	--self.beginLoadCb = beginLoadCb
	
	self.trafficParams = self:GetTrafficParams(self.mapLocation.mapId, self.trafficMode)
	--self.LoadedCallBack = enCb
	self:ClearCtrl()
end

function TrafficManager:GetTrafficMode()
	return self.trafficMode
end

function TrafficManager:StartFight()
	--self.debug = DebugClientInvoke.Cache and DebugClientInvoke.Cache.trafficTest or false

	self:BindListener()

	local mapId = self.fight:GetFightMap()

	-- 每次进入都是安全模式，策划临时需求
	PlayerPrefs.SetInt(GameSetConfig.SaveKey.TrafficMode,FightEnum.TrafficMode.Normal)
	local trafficMode = PlayerPrefs.GetInt(GameSetConfig.SaveKey.TrafficMode,FightEnum.TrafficMode.Normal)

	self.trafficMode = trafficMode > 0 and trafficMode or FightEnum.TrafficMode.Normal
	if mapId then
		self:OnEnterMap(mapId)
	end
	
end

function TrafficManager:BindListener()
	-- EventMgr.Instance:AddListener(EventName.EnterMap, self:ToFunc("OnEnterMap"))
	--EventMgr.Instance:AddListener(EventName.EnterMapArea, self:ToFunc("OnEnterMapArea"))
	EventMgr.Instance:AddListener(EventName.GetInCar, self:ToFunc("OnGetInCar"))
	EventMgr.Instance:AddListener(EventName.GetOffCar, self:ToFunc("OnGetOffCar"))
	EventMgr.Instance:AddListener(EventName.CrashCar, self:ToFunc("OnCrashCar"))
	EventMgr.Instance:AddListener(EventName.UpdateRoadPath, self:ToFunc("OnUpdateRoadPath"))
	EventMgr.Instance:AddListener(EventName.RemoveRoadPath, self:ToFunc("OnRemoveRoadPath"))

	
end

function TrafficManager:RemoveListener()
	-- EventMgr.Instance:RemoveListener(EventName.EnterMap, self:ToFunc("OnEnterMap"))
	--EventMgr.Instance:RemoveListener(EventName.EnterMapArea, self:ToFunc("OnEnterMapArea"))
	EventMgr.Instance:RemoveListener(EventName.GetInCar, self:ToFunc("OnGetInCar"))
	EventMgr.Instance:RemoveListener(EventName.GetOffCar, self:ToFunc("OnGetOffCar"))
	EventMgr.Instance:RemoveListener(EventName.CrashCar, self:ToFunc("OnCrashCar"))
	EventMgr.Instance:RemoveListener(EventName.UpdateRoadPath, self:ToFunc("OnUpdateRoadPath"))
	EventMgr.Instance:RemoveListener(EventName.RemoveRoadPath, self:ToFunc("OnRemoveRoadPath"))
end

function TrafficManager:SetTrafficEnable(enable)
	if self.enable == enable then
		return
	end

	self.enable = enable
	for _, carCtrl in pairs(self.carCtrls) do
		carCtrl:EnableLogic(enable)
	end
end

-- 开启路程计数开关
function TrafficManager:OpenMonitorDistance()
	EventMgr.Instance:AddListener(EventName.MonitorDistance, self:ToFunc("AccumulateDistance"))

	-- 清空数据
	self.accumulationDistance = 0
	self.lastPosition:SetA(Vec3.zero)
end

-- 关闭路程计数开关
function TrafficManager:CloseMonitorDistance()
	EventMgr.Instance:RemoveListener(EventName.MonitorDistance, self:ToFunc("AccumulateDistance"))

	-- 发送协议更新数据，向下取整
	local data = {type = 6, value = math.floor(self.accumulationDistance)}
	mod.RoleCtrl:SendStatisticClientData(data)

	-- 清空数据
	self.accumulationDistance = 0
	self.lastPosition:SetA(Vec3.zero)
end

-- 驾驶过程中计算行驶距离
function TrafficManager:AccumulateDistance(_position)
	if not self.accumulateDistanceSwitch then
		return
	end
	
	if self.lastPosition:Equals(Vec3.zero) then
		self.frameDelay = self.fight.fightFrame
		self.lastPosition:SetA(_position)
	end
	
	if self.fight.fightFrame - self.frameDelay < 30 then	-- 30帧计算一次
		return
	end
	
	self.accumulationDistance = self.accumulationDistance + Vec3.DistanceXZ(_position, self.lastPosition)
	self.frameDelay = self.fight.fightFrame
	self.lastPosition:SetA(_position)
end

function TrafficManager:SetAccumulateDistanceSwitch(_handle)
	self.accumulateDistanceSwitch = _handle
end

function TrafficManager:GetPointConfig(id)
	if not self.trafficMapConfig then
		return
	end

	return self.trafficMapConfig.points[id]
end

function TrafficManager:GetStreetCenterData(id)
	if not self.trafficMapConfig then
		return
	end

	return self.trafficMapConfig.streetConfig[id]
end

function TrafficManager:GetCrossData(id)
	if not self.trafficMapConfig then
		return
	end
	if not id then
		return
	end

	return self.trafficMapConfig.crossConfig[id]
end

function TrafficManager:PopVec3(x,y,z)
	x = x or 0
	y = y or 0
	z = z or 0
	local result
	if #self.Vec3Pool > 0 then
		result = self.Vec3Pool[#self.Vec3Pool]
		table.remove(self.Vec3Pool,#self.Vec3Pool)
	else
		result = Vec3.New()
	end
	
	result:Set(x,y,z)
	return result
end
function TrafficManager:PopVec3A(vec3)
	local result = self:PopVec3()
	if vec3 then
		result:SetA(vec3)
	end
	return result
end

function TrafficManager:PushVec3List(v)
	for i, v in ipairs(v) do
		self:PushVec3(v)
	end
	TableUtils.ClearTable(v)
end

-- 回收vector3
function TrafficManager:PushVec3(v)
	if not v then
		return
	end
	v:Set(0,0,0)
	table.insert(self.Vec3Pool,v)
end


function TrafficManager:OnUpdateRoadPath(drawInstance, mapNavPathInstace)
	if self.mapLocation.mapId ~= 10020005 then
        return
    end
    
    local navDraw3dId = self.navDrawId2Draw3dId[mapNavPathInstace]
	local curDrawsPoints3D, navDrawType = Fight.Instance.mapNavPathManager:GetCurDrawPoint3D(drawInstance, mapNavPathInstace)

    if not navDraw3dId then
        
		self.NavDraw3dInstanceId = self.NavDraw3dInstanceId + 1
		self.navDrawId2Draw3dId[mapNavPathInstace] = self.NavDraw3dInstanceId
		navDraw3dId = self.NavDraw3dInstanceId

		local callback = function()
			local drawEntity = self.fight.entityManager:CreateEntity(20408002)
			BehaviorFunctions.CopyEntityRotate(nil, drawEntity.instanceId , 90, 0, 0)

			local draw = drawEntity.clientTransformComponent.gameObject:GetComponentInChildren(NavPathDraw, true)
			local color = Fight.Instance.mapNavPathManager:GetCurDrawPointColor(drawInstance, mapNavPathInstace)
			local sortingOrder = FightEnum.NavDrawColor2SortingOrder[color]
			-- 设置颜色
			draw:SetNavPathColor(color)
			-- 设置层级
			draw:SetNavPathSortingOrder(sortingOrder)

			self.draw3dId2EntityId[navDraw3dId] = drawEntity.instanceId
			self.draw3dId2Nav3d[navDraw3dId] = draw

			self:_doGuideDraw(navDraw3dId,curDrawsPoints3D,navDrawType == FightEnum.NavPathDrawType.Static)
		end
		self.fight.clientFight.assetsNodeManager:LoadEntity(20408002, callback)
    else
		self:_doGuideDraw(navDraw3dId,curDrawsPoints3D)
    end
end

function TrafficManager:OnRemoveRoadPath(drawInstance, mapNavPathInstace)
    local navDraw3dId = self.navDrawId2Draw3dId[mapNavPathInstace]
    if navDraw3dId then
		self.fight.entityManager:RemoveEntity(self.draw3dId2EntityId[navDraw3dId])
		self.draw3dId2EntityId[navDraw3dId] = nil
		self.draw3dId2Nav3d[navDraw3dId] = nil
		self.navDrawId2Draw3dId[mapNavPathInstace] = nil
    end
end

function TrafficManager:_doGuideDraw(navDraw3dInstanceId,curDrawsPoints3D,notCurve)
	local draw =  self.draw3dId2Nav3d[navDraw3dInstanceId]
	if draw and curDrawsPoints3D then
		local urDrawsPoints3D
		if notCurve then
			draw:DrawPath(curDrawsPoints3D)
		else
			draw:DrawBezierCurvePath(curDrawsPoints3D)
		end
		
	end
end

function TrafficManager:_DrawPoint(id, point, color, scale)
	local gb = GameObject.CreatePrimitive(PrimitiveType.Sphere)

	scale = scale or 1
	gb.transform.localScale = Vector3(scale, scale, scale)
	gb.transform.position = Vector3(point.x, point.y, point.z)
	gb.name = tostring(id)

	color = color or Color(0.5,0.5,0.5,0.2)
	CustomUnityUtils.SetPrimitiveMaterialColor(gb, color)

	local collider = gb:GetComponent(Collider)
	collider.enabled = false

	return gb
end

function TrafficManager:_UpdatePointColor(gb, type)
	local color
	if type == FightEnum.TrafficLightType.Red then
		color = Color(1, 0, 0, 0.2)
	elseif type == FightEnum.TrafficLightType.Yellow then
		color = Color(1, 1, 0, 0.2)
	elseif type == FightEnum.TrafficLightType.Green then
		color = Color(0, 1, 0, 0.2)
	end

	CustomUnityUtils.SetPrimitiveMaterialColor(gb, color)
end

function TrafficManager:DrawPoints(pointList,streetId)
	local debugPoints = {}

	for k, v in ipairs(pointList) do
		if not debugPoints[streetId.."_"..k] then
			debugPoints[streetId.."_"..k] = self:_DrawPoint(streetId.."road_point"..k, v.pos or v, nil, 1)
		end
		local meshRender = debugPoints[streetId.."_"..k]:GetComponent(MeshRenderer)
		meshRender.enabled = true

		--self:_UpdatePointColor(debugPoints[streetId.."_"..k], v.pass and 3 or 1)
	end

	return debugPoints
end


function TrafficManager:AddTrafficLightCtrl(streetId,crossId)
	local lightPos = self:GetTrafficLightPos(streetId, crossId)
	
	self.showTrafficLight[streetId * 10000 + crossId] = lightPos or 0
end

function TrafficManager:UpdateTrafficLight()
	if not self.currentStreetId or self.currentStreetId == 0 then
		return
	end
	if self.lastStreetId ~= self.currentStreetId then
		self.lastStreetId = self.currentStreetId

		TableUtils.ClearTable(self.showTrafficLight)

		local curStreet = self:GetStreetCenterData(self.currentStreetId)
		self:AddTrafficLightCtrl(self.currentStreetId,curStreet.AssCross)
		self:AddTrafficLightCtrl(self.currentStreetId,curStreet.HeadCross)
		for i, v in ipairs(curStreet.AssCrossNode) do
			self:AddTrafficLightCtrl(v,curStreet.AssCross)
		end
		for i, v in ipairs(curStreet.HeadCrossNode) do
			self:AddTrafficLightCtrl(v,curStreet.HeadCross)
		end
	end
end

-- 获取全局signal信号状态
function TrafficManager:GetTrafficLightSigal(revert)
	local curLightTime = self.addUpTime % ((self.trafficLightInterval + self.trafficLightYellow)*2)
	if not revert then
		if (curLightTime > self.trafficLightInterval * 2 + self.trafficLightYellow) then
			return TrafficLightType.Yellow
		elseif (curLightTime > self.trafficLightInterval + self.trafficLightYellow)then
			return TrafficLightType.Red
		elseif curLightTime > self.trafficLightInterval then
			return TrafficLightType.Yellow
		elseif curLightTime > self.trafficLightInterval - self.trafficLightFlicker then
			return TrafficLightType.FlickerGreen
		else
			return TrafficLightType.Green
		end
	else
		if (curLightTime > self.trafficLightInterval * 2 + self.trafficLightYellow) then
			return TrafficLightType.Yellow
		elseif (curLightTime > self.trafficLightInterval  * 2 + self.trafficLightYellow - self.trafficLightFlicker)then
			return TrafficLightType.FlickerGreen
		elseif curLightTime > self.trafficLightInterval  + self.trafficLightYellow then
			return TrafficLightType.Green
		elseif curLightTime > self.trafficLightInterval then
			return TrafficLightType.Yellow
		else
			return TrafficLightType.Red
		end
	end

end

--- 判断交通信号是否可通行
---@param signalType any
function TrafficManager:CheckSingalPass(signalType)
	local curLightTime = self.addUpTime % (self.trafficLightInterval + self.trafficLightYellow)
	if signalType == TrafficLightType.Green or signalType == TrafficLightType.FlickerGreen then
		return true
	else
		return false
	end
end

-- 判断是否与全局signal一致
function TrafficManager:CheckStreetCrossSingal(streetId, crossId)
	if not streetId or not crossId then
		return
	end

	local trafficCacheKey = crossId * 10000  + streetId

	if not self.TrafficLightCache[trafficCacheKey] then
		local curStreet = self:GetStreetCenterData(streetId)
		local cross = self:GetCrossData(crossId)

		local signStreetId = cross.StreetNodes[1]

		local result = true
		if signStreetId ~= streetId then
			local targetStreet = self.trafficMapConfig.streetConfig[signStreetId]
			local isOpposite = self:CheckIfOppositeStreet(curStreet,targetStreet,cross)
			if not isOpposite then
				result = false
			end
		end
		self.TrafficLightCache[trafficCacheKey] = result and TrafficLightCacheType.SameSigal or TrafficLightCacheType.OppositeSigal
	end

	return self.TrafficLightCache[trafficCacheKey] == TrafficLightCacheType.SameSigal
end

--- 检查该道路信号灯是否通行
---@param streetId any
---@param crossId any
function TrafficManager:CheckSigalPass(isSame)

	local signalOn = isSame and self:GetTrafficLightSigal() or self:GetTrafficLightSigal(true)

	return self:CheckSingalPass(signalOn)
end
--- 获取该道路在该路口的红绿灯信号类型
function TrafficManager:GetTrafficLightType(streetId, crossId)
	
	local isSame = self:CheckStreetCrossSingal(streetId, crossId)

	if isSame then 
		return self:GetTrafficLightSigal(),self:GetTrafficLightSigal(true)
	else
		return self:GetTrafficLightSigal(true),self:GetTrafficLightSigal()
	end
end


function TrafficManager:GetTrafficLightPos(streetId, crossId)

	local curStreet = self:GetStreetCenterData(streetId)
	local cross = self:GetCrossData(crossId)

	local targetTrafficLight
	
    local oppsiteStreetId =  self:GetOppositeStreet(streetId, crossId)
    if oppsiteStreetId then
        local oppsiteStreet = self:GetStreetCenterData(oppsiteStreetId)
        local oppsiteStreetIsHead = oppsiteStreet.HeadCross == crossId 
        targetTrafficLight = oppsiteStreetIsHead and oppsiteStreet.HeadTrafficLignt or oppsiteStreet.AssTrafficLignt
    else
        targetTrafficLight = nil
    end 
	
	-- 该方向无灯
	if targetTrafficLight and targetTrafficLight.x ~= 0 then
		return targetTrafficLight
	end
end

--- 获取该道路在该路口上是否通行
---@param streetId any
---@param crossId any
function TrafficManager:CheckCrossPass(streetId, crossId)
	
	if not streetId or not crossId then
		return true
	end
	
	local trafficCacheKey = crossId * 10000  + streetId
	if not self.TrafficLightCache[trafficCacheKey] then
		local trafficLightCacheType
		local curStreet = self:GetStreetCenterData(streetId)
		local cross = self:GetCrossData(crossId)
		-- 没有路口，死路
		if not cross then
			trafficLightCacheType = TrafficLightCacheType.AlwaysBlock
			return false
		end
		-- 这里无灯指示
		if not self:GetTrafficLightPos(streetId, crossId) then
			trafficLightCacheType = TrafficLightCacheType.AlwaysPass
			return true
		end
		if self:CheckStreetCrossSingal(streetId, crossId) then
			trafficLightCacheType = TrafficLightCacheType.SameSigal
		else
			trafficLightCacheType = TrafficLightCacheType.OppositeSigal
		end
		self.TrafficLightCache[trafficCacheKey] = trafficLightCacheType
	end
	
	local trafficCache = self.TrafficLightCache[trafficCacheKey]

	if trafficCache == TrafficLightCacheType.AlwaysPass then
		return true
	elseif trafficCache == TrafficLightCacheType.AlwaysBlock then
		return false
	elseif trafficCache == TrafficLightCacheType.SameSigal then
		return self:CheckSigalPass(true)
	elseif trafficCache == TrafficLightCacheType.OppositeSigal then
		return self:CheckSigalPass(false)
	end
end

function TrafficManager:GetOppositeStreet(streetId,crossId)

	self.GOS_cache1 = self.GOS_cache1 or Vec3.New()
	self.GOS_cache2 = self.GOS_cache2 or Vec3.New()
	self.GOS_cache3 = self.GOS_cache3 or Vec3.New()

	
	local street = self:GetStreetCenterData(streetId)
	local cross = self:GetCrossData(crossId)

	if not street or not cross then
		return
	end
	if TableUtils.ContainValue(cross.StreetNodes,street.RoadIndex) then
		local targetNodes = street.HeadCross == cross.CrossIndex and street.HeadCrossNode or street.AssCrossNode
		
		-- 死路
		if #targetNodes == 0 then
			return
		end
		if #targetNodes == 3 then
			-- 十字路口，中间的为对向道路
			return targetNodes[2]
		elseif #targetNodes == 1 then
			-- 双向道路，必为对向道路
			return targetNodes[1]
		else
			-- 三岔路，最接近直线的为对向路
			local road1 = self.trafficMapConfig.streetConfig[targetNodes[1]]
			local road2 = self.trafficMapConfig.streetConfig[targetNodes[2] ]
			
			local road2FirstPos = road2.HeadCross == cross.CrossIndex and road2.CenterPoint[1] or road2.CenterPoint[#road2.CenterPoint]
			local road1FirstPos = road1.HeadCross == cross.CrossIndex and road1.CenterPoint[1] or road1.CenterPoint[#road1.CenterPoint]
			local curRoadFirstPos = street.HeadCross == cross.CrossIndex and street.CenterPoint[1] or street.CenterPoint[#street.CenterPoint]
			self.GOS_cache1:SetA(road2FirstPos)
			self.GOS_cache1:Sub(cross.CenterPoint)
			self.GOS_cache1:SetNormalize()
			self.GOS_cache2:SetA(road1FirstPos)
			self.GOS_cache2:Sub(cross.CenterPoint)
			self.GOS_cache2:SetNormalize()
			self.GOS_cache3:SetA(curRoadFirstPos)
			self.GOS_cache3:Sub(cross.CenterPoint)
			self.GOS_cache3:SetNormalize()

			local dot1 = Vec3.Dot(self.GOS_cache1,self.GOS_cache2)
			local dot2 = Vec3.Dot(self.GOS_cache1,self.GOS_cache3)
			local dot3 = Vec3.Dot(self.GOS_cache2,self.GOS_cache3)

			if dot3 < dot2 and dot3 < dot1 then
				-- targetNodes[1]为对向路
				return targetNodes[1]
			elseif dot1 < dot2 and dot1 < dot3 then
				--street没有对向路
				return 
			else
				-- targetNodes[2]为对向路
				return targetNodes[2]
			end
			return
		end
	else
		LogError(street.RoadIndex.."道路并不在路口"..cross.CrossIndex)
	end
end

--- 判断两个道路在路口上是否为对向道路，对向道路共用红绿灯信号
---@param street any
---@param targetStreet any
---@param cross any
function TrafficManager:CheckIfOppositeStreet(street,targetStreet,cross)
	self.CIO_cache1 = self.CIO_cache1 or Vec3.New()
	self.CIO_cache2 = self.CIO_cache2 or Vec3.New()
	self.CIO_cache3 = self.CIO_cache3 or Vec3.New()

	if not street or not targetStreet or not cross then
		return
	end

	if TableUtils.ContainValue(cross.StreetNodes,street.RoadIndex) and TableUtils.ContainValue(cross.StreetNodes,targetStreet.RoadIndex) then
		local targetNodes = street.HeadCross == cross.CrossIndex and street.HeadCrossNode or street.AssCrossNode
		if #targetNodes == 0 then
			return false
		end
		if #targetNodes == 3 and targetNodes[2] == targetStreet.RoadIndex then
			-- 十字路口，中间的为对向道路
			return true
		elseif #targetNodes == 1 then
			-- 双向道路，必为对向道路
			return true
		else
			-- 三岔路，最接近直线的为对向路
			local anotherRoadId = targetNodes[1] == targetStreet.RoadIndex and targetNodes[2] or targetNodes[1]
			local anotherRoad = self.trafficMapConfig.streetConfig[anotherRoadId]
			local anotherRoadFirstPos = anotherRoad.HeadCross == cross.CrossIndex and anotherRoad.CenterPoint[1] or anotherRoad.CenterPoint[#anotherRoad.CenterPoint]
			local targetRoadFirstPos = targetStreet.HeadCross == cross.CrossIndex and targetStreet.CenterPoint[1] or targetStreet.CenterPoint[#targetStreet.CenterPoint]
			local curRoadFirstPos = street.HeadCross == cross.CrossIndex and street.CenterPoint[1] or street.CenterPoint[#street.CenterPoint]
			self.CIO_cache1:SetA(anotherRoadFirstPos)
			self.CIO_cache1:Sub(cross.CenterPoint)
			self.CIO_cache1:SetNormalize()
			self.CIO_cache2:SetA(targetRoadFirstPos)
			self.CIO_cache2:Sub(cross.CenterPoint)
			self.CIO_cache2:SetNormalize()
			self.CIO_cache3:SetA(curRoadFirstPos)
			self.CIO_cache3:Sub(cross.CenterPoint)
			self.CIO_cache3:SetNormalize()

			local dot1 = Vec3.Dot(self.CIO_cache1,self.CIO_cache2)
			local dot2 = Vec3.Dot(self.CIO_cache1,self.CIO_cache3)
			local dot3 = Vec3.Dot(self.CIO_cache2,self.CIO_cache3)

			-- 返回street是否与目标道路为对向路，是否street没有对向路
			return dot3 < dot2 and dot3 < dot1, dot1 < dot2 and dot1 < dot3
		end
	else
		LogError(street.RoadIndex.."和"..targetStreet.RoadIndex.."道路并不在路口"..cross.CrossIndex.."交汇")
	end
end

--切换地图时才会计算一次
function TrafficManager:UpdateTrafficConfig(pointsConfig,crossConfig)
	local config = {}
	config.points = {}

	local curFrame = self.fight.fightFrame
	config.streetConfig = pointsConfig
	config.crossConfig = crossConfig
	return config
end

function TrafficManager:OnEnterMap(mapId)
	if self.mapLocation.mapId == mapId  then
		return
	end

	self.mapLocation.mapId = mapId

	
	self.trafficParams = self:GetTrafficParams(mapId, self.trafficMode)
	if not self.trafficParams then
		return
	end
	if #self.trafficParams.car_ids <= 0 then
		LogError("[Traffic]CarEntityIds至少需要一个数据")
		return
	end

	local enableMap = mapId == 10020005
	local pointsConfig = TrafficConfig.GetRoadDotConfig(mapId)
	local crossConfig = TrafficConfig.GetRoadCrossConfig(mapId)

	if pointsConfig and crossConfig and enableMap then

		self.trafficMapConfig = self:UpdateTrafficConfig(pointsConfig,crossConfig)
		self.loadType = LoadType.Clear | LoadType.Reload | LoadType.Run

	else
		self.loadType = LoadType.Clear
	end

	 self:UpdateEnable()
end


function TrafficManager:GetTrafficParams(mapId, trafficMode)
	return DataTraffic[mapId .. "_"..trafficMode]
end

function TrafficManager:OnEnterMapArea(areaType, areaId)
	if areaId == self.mapLocation.areaId then
		return
	end

	self.mapLocation.areaId = areaId

end

function TrafficManager:AddCtrl(entityId, startPos, streetIndex)
	self.carNum = self.carNum + 1
	self.carInstanceId = self.carInstanceId + 1
	table.insert(self.addCtrls, {id = self.carInstanceId, entityId = entityId,startPos = startPos ,streetIndex = streetIndex})
end

function TrafficManager:AddCtrl2(instanceId)
	self.carNum = self.carNum + 1
	self.carInstanceId = self.carInstanceId + 1
	table.insert(self.addCtrls, {id = self.carInstanceId, instanceId = instanceId})
end


function TrafficManager:RemoveCtrl(instanceId)
	self.carNum = self.carNum - 1
	table.insert(self.removeCtrls, instanceId)
end

function TrafficManager:SetCarHacking(instanceId, isHacking)
	for _, v in pairs(self.carCtrls) do
		if v.isLoad and v.entity and v.entity.instanceId == instanceId then
			v:SetHacking(isHacking)
			return
		end
	end
end

function TrafficManager:OnGetOffCar(instanceId,curDriveId)
	--self:CloseMonitorDistance()
	
	for _, v in pairs(self.carCtrls) do
		if v.isLoad and v.entity and v.entity.instanceId == instanceId then
			v:SetDriveOn(false,curDriveId)
		end
	end
	for _, v in pairs(self.SummonCtrl) do
		if v.isLoad and v.entity and v.entity.instanceId == instanceId then
			v:SetDriveOn(false,curDriveId)
		end
	end
end
function TrafficManager:OnGetInCar(instanceId,curDriveId)
	self:OpenMonitorDistance()
	
	for _, v in pairs(self.carCtrls) do
		if v.isLoad and v.entity and v.entity.instanceId == instanceId then
			v:SetDriveOn(true,curDriveId)
		end
	end
	for _, v in pairs(self.SummonCtrl) do
		if v.isLoad and v.entity and v.entity.instanceId == instanceId then
			v:SetDriveOn(true,curDriveId)
		end
	end
end

function TrafficManager:OnCrashCar(instanceId)
	for _, v in pairs(self.carCtrls) do
		if v.isLoad and v.entity and v.entity.instanceId == instanceId then
			v:SetCrash()
		end
	end
	for _, v in pairs(self.SummonCtrl) do
		if v.isLoad and v.entity and v.entity.instanceId == instanceId then
			v:SetCrash()
		end
	end
end


function TrafficManager:UpdateEnable()
	if DebugClientInvoke.Cache.IsDisableEcoAndCar then
		return false
	end

	if self.loadType == LoadType.None then
		return false
	end

	if self.loadType == LoadType.Run then
		return true
	end

	if self.loadType & LoadType.Clear ~= 0 then
		self:Clear()
		self.loadType = self.loadType ~ LoadType.Clear
	end

	if self.loadType & LoadType.Reload ~= 0 then
		self:Load()
		self.loadType = self.loadType ~ LoadType.Reload

	end

	return self.loadType == LoadType.Run
end

function TrafficManager:ClearStreetNode()
	for k, v in pairs(self.StreetNodeCache) do
		v.gValue = 0
		v.hValue = 0
		v.parent = nil
	end
end

--- func 获取两点之间的路径路点
---@param startPos any
---@param endPos any
---@param cachePath any
---@param ignoreRoadLine 忽略车道转向，画引导线用
---@param offsetStart 起点在方向上的偏移
---@param offsetEnd 终点在方向上的偏移  默认终点偏移量为-1，防止超过目标点
---@param ignoreCross 无视红绿灯
function TrafficManager:GetTrackPathTarget(startPos,endPos,cachePath,ignoreRoadLine,offsetStart,offsetEnd,ignoreCross,singleCrossNode)
	if Vec3.DistanceXZ(startPos,endPos) < 5 then
		return
	end
	local streetId = self:GetClosestStreet(startPos)
	local targetStreetId = self:GetClosestStreet(endPos)
	if streetId == 0 or targetStreetId == 0 then
		return 
	end
	
    -- 初始化开集和闭集
	self.openSet = self.openSet or {}
	self.closedSet = self.closedSet or {}
	TableUtils.ClearTable(self.openSet)
	TableUtils.ClearTable(self.closedSet )
	self.openSet[streetId] = 1
	self:ClearStreetNode()
	-- 初始结点
	self.StreetNodeCache[streetId] = self.StreetNodeCache[streetId] or {gValue = 0 ,hValue = 0}

	-- 获取最低F值得结点
	local getLowestFScoreNode = function(setList)
        local lowestFScore = _huge
        local lowestFScoreNode = nil

		for i, v in pairs(setList) do
			local nodeCache = self.StreetNodeCache[i]
			if nodeCache.gValue + nodeCache.hValue < lowestFScore then
				lowestFScore = nodeCache.gValue + nodeCache.hValue
				lowestFScoreNode = i
			end
		end
		return lowestFScoreNode
	end
	-- 获取邻路
	local getNeighbors = function(stId)
		
		local streetData= self:GetStreetCenterData(stId)
		self.neighbors = self.neighbors or {}
		TableUtils.ClearTable(self.neighbors)

		for i, v in ipairs(streetData.AssCrossNode) do
			table.insert(self.neighbors ,v)
		end
		for i, v in ipairs(streetData.HeadCrossNode) do
			table.insert(self.neighbors ,v)
		end
		return self.neighbors
	end
	-- 道路之间中点的距离
	local manhattanDistance = function(street1,street2)
		local streetData1 = self:GetStreetCenterData(street1)
		local streetData2 = self:GetStreetCenterData(street2)
		return Vec3.Distance(streetData1.CenterPoint[_floor(#streetData1.CenterPoint/2)],streetData2.CenterPoint[_floor(#streetData2.CenterPoint/2)])
	end

	-- A星寻路
	self.aStarPath = self.aStarPath  or {}
	TableUtils.ClearTable(self.aStarPath)
	local path = self.aStarPath
	local currentStreetId = 0
	TableUtils.GetTabelLen(self.openSet)
	while TableUtils.GetTabelLen(self.openSet) > 0 and #path == 0 do
        -- 从开集中获取具有最低f值的节点
		currentStreetId = getLowestFScoreNode(self.openSet)
        local currentNode = self.StreetNodeCache[currentStreetId]
		-- 找到目标道路，开始回溯路径
		if currentStreetId == targetStreetId then
			table.insert(path, 1, currentStreetId)
            while currentNode.parent do
				if currentNode.parent ~= streetId then
					table.insert(path, 1, currentNode.parent)
				end
                currentNode = self.StreetNodeCache[currentNode.parent]
            end
		else
			self.openSet[currentStreetId] = nil
			self.closedSet[currentStreetId] = 1
			for i, v in ipairs(getNeighbors(currentStreetId)) do
				if not self.closedSet[v] then
					local newG = currentNode.gValue + manhattanDistance(currentStreetId , v)
					self.StreetNodeCache[v] = self.StreetNodeCache[v] or {gValue = 0 ,hValue = 0}
					if not self.openSet[v] or newG < self.StreetNodeCache[v].gValue then
						-- 更新路径
						self.openSet[v] = 1
						self.StreetNodeCache[v].parent = currentStreetId
						self.StreetNodeCache[v].gValue = newG
						self.StreetNodeCache[v].hValue = manhattanDistance(v , targetStreetId)
					end
				end
			end
		end
	end

	if #path == 0 then
        local currentNode = self.StreetNodeCache[currentStreetId]
		table.insert(path, 1, currentStreetId)
		while currentNode.parent do
			if currentNode.parent ~= streetId then
				table.insert(path, 1, currentNode.parent)
			end
			currentNode = self.StreetNodeCache[currentNode.parent]
		end
		LogError(string.format("streetId %s 搜寻路径到 streetId %s 失败，最后的搜索结点是streetId %s",tostring(streetId) , tostring(targetStreetId),tostring(currentStreetId)) )
	end
	-- 计算出street路径，生成具体点路径
	if #path > 0 then
		local pointPath = cachePath or {}
		local startPointIndex,roadLine = self:GetClosestStartPointIndex(startPos,streetId )
		local endPointIndex,endRoadLine = self:GetClosestStartPointIndex(endPos,targetStreetId)

		local curStreet = self:GetStreetCenterData(streetId)
		
		if offsetStart == -1 and streetId ~= targetStreetId then
			-- 传入-1时，起点改为从道路尽头开始
			offsetStart = 0
			startPointIndex = TableUtils.ContainValue(curStreet.AssCrossNode ,path[1]) and 1 or #curStreet.CenterPoint
		else
			offsetStart = offsetStart or 0
		end
		offsetEnd = offsetEnd or -1
		
		local startData = {pointIndex = startPointIndex,roadLine = roadLine ,offset = offsetStart}
		local endData = {pointIndex = endPointIndex,roadLine = endRoadLine ,offset = offsetEnd}
		local trackPath = self:GetTrackPath(curStreet,startData,pointPath,_huge,path,endData,ignoreRoadLine,ignoreCross,singleCrossNode)

		return pointPath
	end
end

function TrafficManager:GetRamdonNextRoad(street,forward)
	
	local nextNextList
	if forward then
		nextNextList = street.AssCrossNode
	else
		nextNextList = street.HeadCrossNode
	end

	if #nextNextList == 0 then
		return
	end

	if self.enableAiTurnLeft then
		-- 纯随机
		local ramdomIndex = _random(#nextNextList)
		return nextNextList[ramdomIndex]
	else
		-- 剔除所有的左转
		if #nextNextList  == 3 then
			local ramdomIndex = _random(2)
			return nextNextList[ramdomIndex]
		elseif #nextNextList  == 2 then
			local crossId = forward and street.AssCross or street.HeadCross
			local cross = self:GetCrossData(crossId)
			local targetStreet = self.trafficMapConfig.streetConfig[nextNextList[2]]
			-- 如果左侧车道是对向车道（"Y"的左边为直行），或者没有对向车道("T")，则可以通行
			local isOpposite,hasNotOpposite = self:CheckIfOppositeStreet(street,targetStreet,cross)
			if isOpposite or hasNotOpposite then
				local ramdomIndex = _random(2)
				return nextNextList[ramdomIndex]
			else
				-- 如果左侧车道不是对向车道（"Y"的左边为左转），则不允许通行
				return nextNextList[1]
			end
		else
			return nextNextList[1]
		end
	end
end

function TrafficManager:CreateTrackPoint(addPoint,speedModfiy,streetIndex,pointIndex,roadLine,crossIndex,ignoreCross)
	
	local trackPoint = self.fight.objectPool:Get(TrackPoint)
	trackPoint:Init(self.fight,addPoint,speedModfiy,streetIndex,pointIndex,roadLine,crossIndex,ignoreCross)
	return trackPoint
end

--- 根据起点随机或指定往后获取路点
---@param street 起始道路
---@param startData 起始点信息
---@param cachePath 缓存路点表
---@param totalNum 路点最大长度
---@param selectList 按照传入路径选择道路
---@param endData 结束点信息
---@param ignoreRoadLine 是否取消约束车道，道路引导线不约束车道，ai车路径约束车道（因为不能逆行需要掉头） 
---@param singleCrossNode 是否路口点差值数量为1 
---约束车道会根据路与路的联通关系计算准确的车道，会考虑掉头所以影响路径点
---不约束车道会直接调整到右手内侧车道，且不考虑掉头问题
function TrafficManager:GetTrackPath(street, startData,cachePath,totalNum,selectList,endData,ignoreRoadLine,ignoreCross,singleCrossNode)
	
	self.GTP_cache1 = self.GTP_cache1 or Vec3.New()
	self.GTP_cache2 = self.GTP_cache2 or Vec3.New()
	self.GTP_cache3 = self.GTP_cache3 or Vec3.New()
	self.GTP_cache4 = self.GTP_cache4 or Vec3.New()
	self.GTP_cache5 = self.GTP_cache5 or Vec3.New()
	self.GTP_cache6 = self.GTP_cache6 or Vec3.New()
	self.GTP_cache7 = self.GTP_cache7 or Vec3.New()
	self.GTP_cache8 = self.GTP_cache8 or Vec3.New()
	self.GTP_cache9 = self.GTP_cache9 or Vec3.New()
	self.GTP_cache10 = self.GTP_cache10 or Vec3.New()
	self.GTP_cache11 = self.GTP_cache11 or Vec3.New()

	if not street then
		return
	end

	totalNum = totalNum and totalNum or self.defaultGenPathLen
	local trackPath = cachePath or {}

	
	local roadSelect = 1
	local cycleNum = 0

	local roadLine = startData.roadLine
	local startPointIndex = startData.pointIndex
	local startOffset = startData.offset or 0
	

	local addTrackPoint = function(newPoint,forceAdd,countCycle,streetIndex,pointIndex,roadLine,crossIndex)
		local addPoint 
		if #trackPath > 1 then
			self.GTP_cache1:SetA(trackPath[#trackPath].pos)
			self.GTP_cache1:Sub(trackPath[#trackPath - 1].pos)
			local beforeDir = self.GTP_cache1

			self.GTP_cache2:SetA(newPoint)
			self.GTP_cache2:Sub(trackPath[#trackPath].pos)
			local thisDir = self.GTP_cache2

			beforeDir:SetNormalize()
			thisDir:SetNormalize()
			local dotValue = Vec3.Dot(beforeDir,thisDir)
			
			local reachLastPoint = cycleNum == totalNum -1
			local tooFar = Vec3.Distance(trackPath[#trackPath].pos,newPoint) > self.defaultTrackPointDis
			local tooHigh = _abs(newPoint.y - trackPath[#trackPath].pos.y) > self.defaultTrackPointHighSens
			-- 如果和前一个向量没啥差别，就不加了
			if dotValue < 0.9999 or  forceAdd or tooFar or tooHigh then
				addPoint = newPoint
			end
		else
			addPoint = newPoint
		end
		if addPoint then
			local trackPoint = self:CreateTrackPoint(addPoint,1,streetIndex,pointIndex,roadLine,crossIndex,ignoreCross)
			table.insert(trackPath, trackPoint)
			if countCycle then
				cycleNum = cycleNum + 1
			end
		end
	end

 	-- 提前获取下段路
	local nextRoadIndex	
	if selectList then
		nextRoadIndex = selectList[roadSelect]
	else
		-- 当前车道已固定，所以第一次会根据当前车道选择下一条路
		nextRoadIndex = self:GetNextRoadByLine(street,roadLine)
	end
	-- 一开始就在目标位置 , 直接返回了
	if nextRoadIndex == street.RoadIndex and endData and endData.pointIndex == startPointIndex and (ignoreRoadLine or startData.roadLine == endData.roadLine) then
		
		local newPoint =  self.GTP_cache3
		newPoint:SetA(street.CenterPoint[startPointIndex])
		self:CalStreetPointPos(street, startPointIndex, roadLine ,newPoint)
		
		local forwardCurent = roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2

		if forwardCurent and startPointIndex == #street.CenterPoint then
			addTrackPoint(newPoint,true,true,street.RoadIndex,startPointIndex,roadLine,street.AssCross)
		elseif not forwardCurent and startPointIndex == 1 then
			addTrackPoint(newPoint,true,true,street.RoadIndex,startPointIndex,roadLine,street.HeadCross)
		else
			addTrackPoint(newPoint,true,true,street.RoadIndex,startPointIndex,roadLine)
		end
		return trackPath
	end

	local nextNextRoadIndex	-- 下下段路
	-- 如果不约束车道，需要对于初始车道进行矫正
	if ignoreRoadLine then
		local forwardCurent = roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
		--直接设置初始车道到右手内侧车道
		roadLine = self:Offset2RoadLine(forwardCurent and 1 or -1,self:GetRoadLineNum(street.RoadLevel))
		-- 然后判断是否需要掉头，如果需要掉头需要再对车道做一次调整
		local isNextForwardnext = TableUtils.ContainValue(street.AssCrossNode ,nextRoadIndex)
		local notNeedReturnNext -- 无需掉头
		if nextRoadIndex == street.RoadIndex then
			if forwardCurent then
				notNeedReturnNext = endData.pointIndex > startPointIndex
			else
				notNeedReturnNext = endData.pointIndex < startPointIndex
			end
		else
			-- 当前方向和下个道路同为正向或同为反向则无需变换车道
			notNeedReturnNext = (not forwardCurent and not isNextForwardnext) or ( forwardCurent and isNextForwardnext)
		end
		-- 需要掉头
		if not notNeedReturnNext then
			roadLine = self:Offset2RoadLine(forwardCurent and -1 or 1,self:GetRoadLineNum(street.RoadLevel))
			-- 掉头后，根据方向矫正初始点的偏移
			startPointIndex = forwardCurent and startPointIndex - 1 or startPointIndex + 1
			startPointIndex = _clamp(startPointIndex,1,#street.CenterPoint)
		end
	end
	-- 已在同道同侧，需要排除startOffset和endoffset导致的无意义掉头
	if nextRoadIndex == street.RoadIndex and endData then
		local nextForward = endData.roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
		local forwardCurent = endData.roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
		if forwardCurent ==  nextForward then
			-- 目标不需要掉头，就不要因为offset产生无意义掉头
			if nextForward and endData.pointIndex >= startPointIndex or not nextForward and endData.pointIndex <= startPointIndex then
				local offsetMax = _abs(endData.pointIndex - startPointIndex) 
				local offsetEnd = -endData.offset or 0
				local offsetStart = startData.offset or 0
				offsetEnd = _min(offsetMax,offsetEnd)
				offsetMax = offsetMax - offsetEnd
				offsetStart = _min(offsetStart,offsetEnd)
				startData.offset = offsetStart
				endData.offset = -offsetEnd
			end
		end
	end
	
	-- 对起始点根据方向做偏移
	startPointIndex = startPointIndex + (roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2  and startOffset or -startOffset)
	startPointIndex = _clamp(startPointIndex,1,#street.CenterPoint)

	-- 死路
	local deadRoad = not nextRoadIndex

	local changeRoadLineIndex
	local targetRoadLine
	while not deadRoad and cycleNum <= totalNum do
		local maxCount = #street.CenterPoint
		-- 到达路口
		if startPointIndex < 1 or startPointIndex > maxCount then

			if not nextRoadIndex then
				deadRoad = true
			else
				if selectList then
					-- 钦定下下段路
					roadSelect = roadSelect + 1
					if roadSelect <= #selectList then
						nextNextRoadIndex = selectList[roadSelect]
					else
						nextNextRoadIndex = nil
					end
				else
					-- 预测出下下段路
					local newStreet = self:GetStreetCenterData(nextRoadIndex)
					
					local nextNextList
					

					
					-- 下一段路是从顺读
					local nextStreetStartHead = TableUtils.ContainValue(newStreet.HeadCrossNode, street.RoadIndex)

					-- 随机获取下下段路
					nextNextRoadIndex = self:GetRamdonNextRoad(newStreet,nextStreetStartHead)

				end
			
			end

			-- 选择了下一段路
			if not deadRoad and nextRoadIndex then

				-- 如果寻路导致的下一条路和当前车道不匹配，需要先掉个头
				local forward = roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
				local isNextForward = TableUtils.ContainValue(street.AssCrossNode ,nextRoadIndex)
				local notNeedReturn = (not forward and not isNextForward) or ( forward and isNextForward)
				if not notNeedReturn then
					
					startPointIndex = forward and #street.CenterPoint or 1
					
					-- 计算掉头车道
					roadLine = self:GetNextRoadLine(not forward,street,nextRoadIndex)
					
					-- 在掉头时插入一个掉头点
					local midPoint = self.GTP_cache10
					midPoint:SetA(trackPath[#trackPath].pos)
					-- 计算出掉头后点
					local firstReturnPoint =  self.GTP_cache9
					firstReturnPoint:SetA(street.CenterPoint[startPointIndex])
					self:CalStreetPointPos(street, startPointIndex, roadLine ,firstReturnPoint)
					Vec3.LerpA(midPoint, firstReturnPoint, 0.5, midPoint)
					-- 计算出掉头点方向法线
					local midPointNormal = self.GTP_cache11
					midPointNormal:SetA(firstReturnPoint)
					midPointNormal:Sub(trackPath[#trackPath].pos)
					midPointNormal.y = 0
					midPointNormal:SetNormalize()
					midPointNormal:CrossB(Vec3.up)
					-- 插入
					midPoint:Add(midPointNormal:Mul(Vec3.DistanceXZ(trackPath[#trackPath].pos,firstReturnPoint) * 0.5))
					addTrackPoint(midPoint,true,false)

					local reachEnd
					while not reachEnd  do
						local newPoint =  self.GTP_cache9
						newPoint:SetA(street.CenterPoint[startPointIndex])
						self:CalStreetPointPos(street, startPointIndex, roadLine ,newPoint)
						local forceAdd = cycleNum == totalNum -1 or startPointIndex == 1 or startPointIndex == #street.CenterPoint
						addTrackPoint(newPoint,forceAdd,true,street.RoadIndex,startPointIndex,roadLine)
						if forward then
							startPointIndex = startPointIndex - 1
							reachEnd = startPointIndex == 1 
						else
							startPointIndex = startPointIndex + 1
							reachEnd = startPointIndex == #street.CenterPoint 
						end
					end
				end

				-- 计算出当前路径的最后两点
				local lastPoint = trackPath[#trackPath].pos
				local lastPoint2 = self.GTP_cache10
				local lastPoint2Index = forward and #street.CenterPoint - 1 or  2
				lastPoint2:SetA(street.CenterPoint[lastPoint2Index])
				self:CalStreetPointPos(street, lastPoint2Index, roadLine, lastPoint2)

				local newStreet = self:GetStreetCenterData(nextRoadIndex)
				
				if ignoreRoadLine then
					-- 不约束车道，则直接设置车道到目标方向内侧车道
					
					local toward = TableUtils.ContainValue(newStreet.HeadCrossNode, street.RoadIndex)
					roadLine = self:Offset2RoadLine(toward and 1 or -1,self:GetRoadLineNum(newStreet.RoadLevel))
				else
					local toward = TableUtils.ContainValue(newStreet.HeadCrossNode, street.RoadIndex)
					-- 约束车道，则按照下下条路方向决定下条路车道
					if not nextNextRoadIndex then
						-- 没有下下条路，则下条路车道仅根据方向随机
						local totalLineNum = self:GetRoadLineNum(newStreet.RoadLevel)
						local lineType = totalLineNum/2
						roadLine = toward and lineType + _random(lineType) or  _random(lineType)
					else
						-- 根据下下段路计算在下段路的车道
						-- 当前车道偏移
						local curRoadLineOffset = self:RoadLine2Offset(roadLine, self:GetRoadLineNum(street.RoadLevel))
						-- 车道偏移换算到下段路的偏移
						local sameRead = TableUtils.ContainValue(street.AssCrossNode, newStreet.RoadIndex) and TableUtils.ContainValue(newStreet.HeadCrossNode, street.RoadIndex) 
										or TableUtils.ContainValue(street.HeadCrossNode, newStreet.RoadIndex) and TableUtils.ContainValue(newStreet.AssCrossNode, street.RoadIndex) 
						curRoadLineOffset = sameRead and curRoadLineOffset or -curRoadLineOffset
						-- 并不马上变道，而是随机一个变道位置
						targetRoadLine , roadLine = self:GetNextRoadLine(toward,newStreet,nextNextRoadIndex,curRoadLineOffset)
						changeRoadLineIndex = 1 + _random(#newStreet.CenterPoint -2) 
					end
				end
				
				-- 进入新道路
				nextRoadIndex = nextNextRoadIndex
				street = newStreet
				-- 根据车道判断读向
				forward = roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2

				-- 下一段路进入的点
				local nextPoint = self.GTP_cache3
				local nextPoint2 = self.GTP_cache4
				local pointIndex
				if forward then
					startPointIndex = 1
					nextPoint:SetA(street.CenterPoint[1])
					self:CalStreetPointPos(street, 1, roadLine, nextPoint)
					pointIndex = 1
					nextPoint2:SetA(street.CenterPoint[2])
					self:CalStreetPointPos(street, 2, roadLine, nextPoint2)
				else
					startPointIndex = #newStreet.CenterPoint
					nextPoint:SetA(street.CenterPoint[#newStreet.CenterPoint])
					self:CalStreetPointPos(street, #newStreet.CenterPoint, roadLine, nextPoint)
					pointIndex = #newStreet.CenterPoint
					
					nextPoint2:SetA(street.CenterPoint[#newStreet.CenterPoint - 1])
					self:CalStreetPointPos(street, #newStreet.CenterPoint - 1, roadLine, nextPoint2)
				end
				
				-- 处理在路口上的差值
				if #trackPath > 0 then
					-- 当前路径的最后两点  与下一条路点的前两点 的交点

					local middleX,middleZ = self:calculateIntersectionPoint(lastPoint.x,lastPoint.z,lastPoint2.x,lastPoint2.z,nextPoint.x,nextPoint.z,nextPoint2.x,nextPoint2.z)
					local middleY = (lastPoint.y + nextPoint.y) /2
					-- 计算出交点
					local middlePos = self.GTP_cache5
					middlePos:Set(middleX,middleY,middleZ)
					
					local totalCrossLength = (Vec3.DistanceXZ(lastPoint , middlePos) + Vec3.DistanceXZ(nextPoint , middlePos))
					if not singleCrossNode then
						local crossBezierCount = _ceil(totalCrossLength/self.defaultCrossPointDis)
						local lengthPer = totalCrossLength/crossBezierCount
						for i = 1, crossBezierCount -1, 1 do
							--插入贝塞尔曲线点
							local tValue = lengthPer * i /totalCrossLength
							local calPos = Vec3:CalculateBezierPoint(tValue,lastPoint,middlePos,nextPoint,self.GTP_cache6,self.GTP_cache7,self.GTP_cache8)
							addTrackPoint(calPos,true,false,nil,nil,nil, forward and street.HeadCross or street.AssCross)-- 路口差值点均不算入总量，防止在最终断在路口
						end

					else
						local tValue = Vec3.DistanceXZ(lastPoint , middlePos)/totalCrossLength
						local calPos = Vec3:CalculateBezierPoint(tValue,lastPoint,middlePos,nextPoint,self.GTP_cache6,self.GTP_cache7,self.GTP_cache8)
						addTrackPoint(calPos,true,false,nil,nil,nil, forward and street.HeadCross or street.AssCross)-- 路口差值点均不算入总量，防止在最终断在路口
					end
				end
				
				-- 插入下一条路的第一个点
				addTrackPoint(nextPoint,true,true,street.RoadIndex,pointIndex,roadLine)
			end

		else
			-- 到了变道点，变道
			if targetRoadLine and changeRoadLineIndex and  startPointIndex == changeRoadLineIndex then
				roadLine = targetRoadLine
				targetRoadLine = nil
				changeRoadLineIndex = nil
			end
			-- 计算具体位置
			local newPoint =  self.GTP_cache3
			newPoint:SetA(street.CenterPoint[startPointIndex])
			self:CalStreetPointPos(street, startPointIndex, roadLine ,newPoint)
			local forceAdd = cycleNum == totalNum -1 or startPointIndex == 1 or startPointIndex == maxCount
			local forward = roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2

			-- 如果是最后的路点，需要传入路口
			local crossIndex
			if (forward and startPointIndex == maxCount) or (not forward and startPointIndex == 1)  then
				crossIndex = forward and street.AssCross or street.HeadCross
			end
			addTrackPoint(newPoint,forceAdd,true,street.RoadIndex,startPointIndex,roadLine,crossIndex)
		end


		if selectList and street.RoadIndex == selectList[#selectList] then
			-- 当前已经处于目标道路，一口气插完所有剩下的点

			-- roadLine跟目标车道属于同侧
			local sameSide =  self:RoadLine2Offset(roadLine, self:GetRoadLineNum(street.RoadLevel)) * self:RoadLine2Offset(endData.roadLine, self:GetRoadLineNum(street.RoadLevel)) > 0
			-- 目标车道读向
			local targetForward = endData.roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
			-- 如果ignoreRoadLine并且roadLine跟目标车道不属于同侧，说明最终会省略一个掉头，此时offset应该做相反
			if ignoreRoadLine and not sameSide then
				targetForward = not targetForward
			end
			-- 对目标车道终点根据方向做偏移
			local endOffset = endData.offset or 0
			endData.pointIndex = endData.pointIndex + (targetForward and endOffset or -endOffset)
			endData.pointIndex = _clamp(endData.pointIndex,1,#street.CenterPoint)
			
			-- 如果ignoreRoadLine则不处于同侧也视为满足目标
			while not ((sameSide or ignoreRoadLine) and startPointIndex == endData.pointIndex) do

				local forward = roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
				local overTarget = forward and startPointIndex > endData.pointIndex or startPointIndex < endData.pointIndex
				if sameSide and not overTarget then
					-- 同侧且目标在车头前方，直接变道
					-- 如果ignoreRoadLine统一为中间两侧车道
					roadLine =  ignoreRoadLine and self:Offset2RoadLine(forward and 1 or -1,self:GetRoadLineNum(street.RoadLevel)) or endData.roadLine
				end
				
				if forward then
					startPointIndex = startPointIndex + 1
				else
					startPointIndex = startPointIndex - 1
				end
				
				-- 到达路口，掉头
				if startPointIndex < 1 or startPointIndex > #street.CenterPoint then
					startPointIndex = forward and #street.CenterPoint or 1
					-- 另一侧的边缘车道
					local sideLine = forward and 1 or self:GetRoadLineNum(street.RoadLevel)
					-- 掉头时设置目标车道
					roadLine = sameSide and sideLine or endData.roadLine
					sameSide = not sameSide

					-- 在掉头时插入一个掉头点
					local midPoint = self.GTP_cache10
					midPoint:SetA(trackPath[#trackPath].pos)
					-- 计算出掉头后点
					local firstReturnPoint =  self.GTP_cache9
					firstReturnPoint:SetA(street.CenterPoint[startPointIndex])
					self:CalStreetPointPos(street, startPointIndex, roadLine ,firstReturnPoint)
					Vec3.LerpA(midPoint, firstReturnPoint, 0.5, midPoint)
					-- 计算出掉头点方向法线
					local midPointNormal = self.GTP_cache11
					midPointNormal:SetA(firstReturnPoint)
					midPointNormal:Sub(trackPath[#trackPath].pos)
					midPointNormal.y = 0
					midPointNormal:SetNormalize()
					midPointNormal:CrossB(Vec3.up)
					-- 插入
					midPoint:Add(midPointNormal:Mul(Vec3.DistanceXZ(trackPath[#trackPath].pos,firstReturnPoint) * 0.5))
					addTrackPoint(midPoint,true,false)
				end
				-- 计算具体位置
				local newPoint =  self.GTP_cache3
				newPoint:SetA(street.CenterPoint[startPointIndex])
				self:CalStreetPointPos(street, startPointIndex, roadLine ,newPoint)
				local forceAdd = cycleNum == totalNum -1 or startPointIndex == 1 or startPointIndex == #street.CenterPoint or startPointIndex == endData.pointIndex
				addTrackPoint(newPoint,forceAdd,true,street.RoadIndex,startPointIndex, roadLine)
			end

			deadRoad = true
		else
			-- 正常按步走
			local forward = roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
			if forward then
				startPointIndex = startPointIndex + 1
			else
				startPointIndex = startPointIndex - 1
			end
		end
	end
	return trackPath
end

-- 计算p点在p1-p2线段上的投影点
function TrafficManager:FindProjectionPoint(p, p1, p2 , pointCache)
	self.projectionCache = self.projectionCache or Vec3.New()
	self.projectionCache2 = self.projectionCache2 or Vec3.New()

	local v = self.projectionCache
	local v2 = self.projectionCache2
	v:SetA(p2)
	v:Sub(p1)
	v2:SetA(p)
	v2:Sub(p1)
	v:Mul(Vec3.Dot(v2, v) / Vec3.Dot(v, v)):Add(p1)
	pointCache:SetA(v)
end

-- 这个道路在这个roadLine尽头路口的相邻道路按照右手边逆时针排序
function TrafficManager:GetNextStreetList(street,forward)
	return forward and street.AssCrossNode or street.HeadCrossNode
end
--- 根据车道位置选择下一条路
---@param street any
---@param roadLine any
function TrafficManager:GetNextRoadByLine(street,roadLine)

	local roadList1 = nil
	local roadList2 = nil

	local totalLineNum = self:GetRoadLineNum(street.RoadLevel)
	local lineType = totalLineNum/2
	
	local forward = roadLine > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
	-- 可选道路
	local nextStreetList = self:GetNextStreetList(street,forward)
	-- 当前车道相对中线位置
	local curLineAbs = _abs(self:RoadLine2Offset(roadLine,totalLineNum))

	-- 临时，绕过广州大桥
	if TableUtils.ContainValue(nextStreetList,43) then
		local newNextStreetList = {}
		for i, v in ipairs(nextStreetList) do
			if v ~= 43 then
				table.insert(newNextStreetList,v)
			end
		end
		nextStreetList = newNextStreetList
	end
	if lineType == 3 then
		-- 三车道
		if #nextStreetList == 3 then
			-- 十字路口
			if curLineAbs == 1 then
				
				if self.enableAiTurnLeft then
					-- 最左侧车道只能往左
					return nextStreetList[3]
				else
						
					-- 暂时屏蔽AI车左转能力
					return nextStreetList[2]
				end

				
			elseif curLineAbs == 2 then
				--中间车道只能往前
					return nextStreetList[2]
	
			else
				return nextStreetList[1]
			end
		elseif #nextStreetList == 2 then
			-- 三岔路口
			if curLineAbs == 1 then
				
				if self.enableAiTurnLeft then
					-- 最左侧车道只能往左
					return nextStreetList[2]
				else
					
					-- 暂时屏蔽AI车左转能力
					local crossId = forward and street.AssCross or street.HeadCross
					local cross = self:GetCrossData(crossId)
					local targetStreet = self.trafficMapConfig.streetConfig[nextStreetList[2]]
					-- 如果左侧车道是对向车道（"Y"的左边为直行），或者没有对向车道("T")，则可以通行
					local isOpposite,hasNotOpposite = self:CheckIfOppositeStreet(street,targetStreet,cross)
					if isOpposite or hasNotOpposite then
						return nextStreetList[2]
					else
						-- 如果左侧车道不是对向车道（"Y"的左边为左转），则不允许通行
						return nextStreetList[1]
					end
				end



			elseif curLineAbs == 2 then

				if self.enableAiTurnLeft then
				-- 中间车道可任选
				else
					-- 暂时屏蔽AI车左转能力
					local crossId = forward and street.AssCross or street.HeadCross
					local cross = self:GetCrossData(crossId)
					local targetStreet = self.trafficMapConfig.streetConfig[nextStreetList[2]]
					-- 如果左侧车道是对向车道（"Y"的左边为直行），或者没有对向车道("T")，则可以通行
					local isOpposite,hasNotOpposite = self:CheckIfOppositeStreet(street,targetStreet,cross)
					if isOpposite or hasNotOpposite then
					else
						-- 如果左侧车道不是对向车道（"Y"的左边为左转），则不允许通行
						return nextStreetList[1]
					end
				end

			else
				return nextStreetList[1]
			end
		end
	elseif lineType == 2 then
		-- 双车道
		if #nextStreetList == 3 then
			-- 十字路口
			if curLineAbs == 1 then

				if self.enableAiTurnLeft then
					-- 左侧车道可以往左或往前
					
					return nextStreetList[1+ _random(2)]
				else
					-- 暂时屏蔽AI车左转能力
					return nextStreetList[2]
				end

				
			else
				-- 左侧车道可以往右或往前
				return nextStreetList[_random(2)]
			end
		elseif #nextStreetList == 2 then
			-- 三岔路口
			if curLineAbs == 1 then
				
				if self.enableAiTurnLeft then
					-- 左侧车道只能往左
					return nextStreetList[2]

				else
					-- 暂时屏蔽AI车左转能力
					local crossId = forward and street.AssCross or street.HeadCross
					local cross = self:GetCrossData(crossId)
					local targetStreet = self.trafficMapConfig.streetConfig[nextStreetList[2]]
					-- 如果左侧车道是对向车道（"Y"的左边为直行），或者没有对向车道("T")，则可以通行
					local isOpposite,hasNotOpposite = self:CheckIfOppositeStreet(street,targetStreet,cross)
					if isOpposite or hasNotOpposite then
					else
						-- 如果左侧车道不是对向车道（"Y"的左边为左转），则不允许通行
						return nextStreetList[1]
					end
				end
				
			else
				-- 左侧车道只能往右
				return nextStreetList[1]
			end
		end
	
	else
		-- 单车道
		if self.enableAiTurnLeft then
			-- nothing
		else
			-- 暂时屏蔽AI车左转能力
			if #nextStreetList == 3 then
				-- 十字路口
				return nextStreetList[_random(2)]
			elseif #nextStreetList == 2 then
				-- 三岔路口
				local crossId = forward and street.AssCross or street.HeadCross
				local cross = self:GetCrossData(crossId)
				local targetStreet = self.trafficMapConfig.streetConfig[nextStreetList[2]]
				-- 如果左侧车道是对向车道（"Y"的左边为直行），或者没有对向车道("T")，则可以通行
				local isOpposite,hasNotOpposite = self:CheckIfOppositeStreet(street,targetStreet,cross)
				if isOpposite or hasNotOpposite then
				else
					-- 如果左侧车道不是对向车道（"Y"的左边为左转），则不允许通行
					return nextStreetList[1]
				end
			end
		
		end

	end

	return nextStreetList[_random(#nextStreetList)]
end

function TrafficManager:SetRoadPointCheck(roadIndex,pointIndex,roadLine)
	if not roadIndex or  not pointIndex or not roadLine then
		return 
	end
	if not self.RoadPointCheck[roadIndex] then
		self.RoadPointCheck[roadIndex] = {}
	end
	if not self.RoadPointCheck[roadIndex][pointIndex] then
		self.RoadPointCheck[roadIndex][pointIndex] = {}
	end
	if not self.RoadPointCheck[roadIndex][pointIndex][roadLine] then
		self.RoadPointCheck[roadIndex][pointIndex][roadLine] = 0
	end
	self.RoadPointCheck[roadIndex][pointIndex][roadLine]  = self.RoadPointCheck[roadIndex][pointIndex][roadLine]  + 1
end

function TrafficManager:RemoveRoadPointCheck(roadIndex,pointIndex,roadLine)
	if not roadIndex or  not pointIndex or not roadLine then
		return 
	end
	if self.RoadPointCheck[roadIndex] and self.RoadPointCheck[roadIndex][pointIndex] and self.RoadPointCheck[roadIndex][pointIndex][roadLine] then
		self.RoadPointCheck[roadIndex][pointIndex][roadLine]  = _max(0,self.RoadPointCheck[roadIndex][pointIndex][roadLine]  - 1) 
	end
end

function TrafficManager:GetStreetCheckNum(roadIndex)
	if not roadIndex then
		return 
	end

	if self.RoadPointCheck[roadIndex] then
		local count = 0
		for k, pointIndex in pairs(self.RoadPointCheck[roadIndex]) do
			for kw, roadLineCheck in pairs(pointIndex) do
				if roadLineCheck then
					count = count + roadLineCheck
				end
			end
		end
		return count
	end
	return 0
end
-- 检查路点占据
function TrafficManager:GetRoadPointCheck(roadIndex,pointIndex,roadLine,lastPointIndex)
	if not roadIndex or  not pointIndex or not roadLine then
		return 
	end
	if lastPointIndex then
		-- 如果传入lastPointIndex，检测从lastPointIndex到pointIndex中间所有路点
		if lastPointIndex <= pointIndex then
			for i = lastPointIndex + 1, pointIndex, 1 do
				if self.RoadPointCheck[roadIndex] and self.RoadPointCheck[roadIndex][i] and self.RoadPointCheck[roadIndex][i][roadLine] then
					if self.RoadPointCheck[roadIndex][i][roadLine] > 0 then
						return true
					end
				end
			end
		else
			for i = lastPointIndex -1, pointIndex, -1 do
				if self.RoadPointCheck[roadIndex] and self.RoadPointCheck[roadIndex][i] and self.RoadPointCheck[roadIndex][i][roadLine] then
					if self.RoadPointCheck[roadIndex][i][roadLine] > 0 then
						return true
					end
				end
			end
		end
	else
		if self.RoadPointCheck[roadIndex] and self.RoadPointCheck[roadIndex][pointIndex] and self.RoadPointCheck[roadIndex][pointIndex][roadLine] then
			return self.RoadPointCheck[roadIndex][pointIndex][roadLine] > 0
		end
	end
	
end

--- 根据下一条路选择这一条路的车道，乐
---@param street any
---@param nextRoadIndex any
---@param nextNextRoadIndex any
function TrafficManager:GetNextRoadLine(forward,roadCnter,nextRoadIndex,oldRoadLineOffset)

	-- 下一条路就是这条路，返回对最外侧车道作为掉头车道
	if roadCnter.RoadIndex == nextRoadIndex then
		local roadNumNew = self:GetRoadLineNum(roadCnter.RoadLevel)
		return forward and roadNumNew or 1
	end
	-- 获取下条路和下下条路的路口街道
	local nextStreetList = self:GetNextStreetList(roadCnter,forward)
	-- 获取下下条路的逆时针次序
	local targetIndex 
	for i, v in ipairs(nextStreetList) do
		if v == nextRoadIndex then
			targetIndex = i
		end
	end
	if not targetIndex then
		LogError("计算车道错误，道路"..nextRoadIndex.."不在道路"..roadCnter.RoadIndex.."的"..(forward and "foward"or "backword").."方向上")
		return 1
	end

	local totalLineNum = self:GetRoadLineNum(roadCnter.RoadLevel)
	local lineType = totalLineNum/2
	local targetRoadLine
	
	
	if targetIndex then 
		if #nextStreetList == 3 then
			-- 十字路口
			if lineType == 3 then
				-- 三车道 ， 三个方向各自分一条
				targetRoadLine = forward and (totalLineNum + 1 - targetIndex) or targetIndex 
			elseif lineType == 2 then
				-- 双车道
				if targetIndex == 1 then
					-- 右拐只能是右车道
					targetRoadLine = forward and 4 or 1
				elseif targetIndex == 2 then
					-- 前进左右车道都可
					targetRoadLine = forward and 2 + _random(2) or _random(2)
				else
					-- 左拐只能是左车道
					targetRoadLine =  forward and 3 or 2
				end
			else
				-- 单车道
				targetRoadLine = forward and 2 or 1
			end
		elseif #nextStreetList == 2 then
			-- 三岔路
			if lineType == 3 then
				-- 三车道
				if targetIndex == 1 then
					-- 右手道路，可以是右边两个车道
					targetRoadLine = forward and 3 + 1 + _random(2) or  _random(2)
				else
					-- 左手道路，可以是左边两个车道
					targetRoadLine = forward and 3 + _random(2) or 1 + _random(2)
				end
			elseif lineType == 2 then
				-- 双车道，两个方向各自分一条
				targetRoadLine = forward and (totalLineNum + 1 - targetIndex) or targetIndex 
			else
				-- 单车道
				targetRoadLine = forward and 2 or 1
			end
		else
			-- 双向路口，随意车道
			targetRoadLine = forward and lineType + _random(lineType) or _random(lineType)
		end 

		if oldRoadLineOffset then
			oldRoadLineOffset = TrafficManager:Offset2RoadLine(oldRoadLineOffset, totalLineNum)
		end
		return targetRoadLine,oldRoadLineOffset
	end

end

-- 获取路点的方向向量
function TrafficManager:GetStreetPointIndexDirect(street, startPointIndex ,cachePoint)
	if self:GetStreetPointIndexNormal(street, startPointIndex ,cachePoint) then
		return cachePoint:CrossA(Vec3.up)
	end
end
-- 获取路点的方向法线
function TrafficManager:GetStreetPointIndexNormal(street, startPointIndex ,cachePoint)
	if not street.CenterPoint[startPointIndex] then
		return
	end
	
	self.CSPP_cache2 = self.CSPP_cache2 or Vec3.New()

	-- 前后点
	local prePointIndex = startPointIndex - 1
	local nextPointIndex = startPointIndex + 1
	-- 当前点
	
	-- 路点方向法线
	local direct = cachePoint

	-- 前点为空
	if street.CenterPoint[prePointIndex] == nil then
		direct:SetA(street.CenterPoint[nextPointIndex])
		direct:Sub(street.CenterPoint[startPointIndex])
		direct:CrossB(Vec3.up)
		-- 后点为空
	elseif street.CenterPoint[nextPointIndex] == nil then
		
		direct:SetA(street.CenterPoint[startPointIndex])
		direct:Sub(street.CenterPoint[prePointIndex])
		direct:CrossB(Vec3.up)
	else

		self.CSPP_cache2:SetA(street.CenterPoint[prePointIndex])
		self.CSPP_cache2.y = 0
		self.CSPP_cache2:Sub(street.CenterPoint[startPointIndex]):SetNormalize()
		direct:SetA(street.CenterPoint[nextPointIndex])
		direct:Sub(street.CenterPoint[startPointIndex]):SetNormalize()

		direct:Sub(self.CSPP_cache2):CrossB(Vec3.up)
	end
	direct:SetNormalize()

	return direct
end
-- 获取street上index和roadline换算后的具体点
function TrafficManager:CalStreetPointPos(street, startPointIndex, roadLine ,cachePoint)

	self.CSPP_cache1 = self.CSPP_cache1 or Vec3.New()
	local direct = self:GetStreetPointIndexNormal(street, startPointIndex,self.CSPP_cache1)
	if not direct then
		return
	end
	
	local newPoint
	if cachePoint then
		newPoint = cachePoint
	else
		newPoint =  Vec3.CreateByCustom(street.CenterPoint[startPointIndex])
	end

	-- d
	local roadOffset = self:GetRoadLineOffset(street.RoadLevel,roadLine)
	if roadOffset == 0 then
		roadOffset = self:GetRoadLineOffset(street.RoadLevel,roadLine)
	end
	newPoint:Add(direct:Mul(roadOffset))
	return newPoint,roadOffset
end

-- 当前车道处于中心线的偏移步数，带正负号
function TrafficManager:RoadLine2Offset(roadLine, roadNum)
	
	if roadLine <( roadNum + 1) /2 then
		return _floor(roadLine - ((roadNum + 1) /2))
	else
		return roadLine - roadNum/2
	end

end

-- 通过偏移量计算车道位置
function TrafficManager:Offset2RoadLine(offset, roadNum)

	offset = _clamp(offset,-roadNum/2,roadNum/2) 

	if offset > 0 then
		return _floor((roadNum+1)/2 + offset)
	else
		return _ceil((roadNum+1)/2 + offset)
	end
end

function TrafficManager:Update()
	if not self:UpdateEnable() then
		return
	end

	if not self.enable then
		return
	end
	local deltaTime = FightUtil.deltaTimeSecond

	self.addUpTime = self.addUpTime + deltaTime

	self:UpdateTrafficLight()

	for i, v in pairs(self.trafficLightCtrls) do
		if not self.showTrafficLight[i] then
			self.fight.objectPool:Cache(TrafficLightCtrl, v)
			self.trafficLightCtrls[i] = nil
		end
	end

	for i, v in pairs(self.showTrafficLight) do
		if not self.trafficLightCtrls[i] then
			local ctrl = self.fight.objectPool:Get(TrafficLightCtrl)
			ctrl:Init(self.fight, self, i,v)
			self.trafficLightCtrls[i] = ctrl
		end
	end

	for _, v in pairs(self.trafficLightCtrls) do
		v:Update()
	end

	for _, v in pairs(self.removeCtrls) do
		if self.carCtrls[v] then
			self.fight.objectPool:Cache(CarCtrl, self.carCtrls[v])
			self.carCtrls[v] = nil
		end
	end
	TableUtils.ClearTable(self.removeCtrls)

	for _, v in pairs(self.addCtrls) do
		local ctrl = self.fight.objectPool:Get(CarCtrl)
		if v.instanceId then
			ctrl:InitByEntity(self.fight, self, v.id, v.instanceId)
		else
			ctrl:Init(self.fight, self, v.id, v.entityId, v.startPos, v.streetIndex)
		end
		self.carCtrls[v.id] = ctrl
	end
	TableUtils.ClearTable(self.addCtrls)

	for _, v in pairs(self.carCtrls) do
		v:Update()
	end

	if self.LoadInternalTimer == 0 then
		self:Load()
	end
	self.LoadInternalTimer = self.LoadInternalTimer >= self.LoadInternalTime and 0 or self.LoadInternalTimer + deltaTime

end

function TrafficManager:Clear()
	TableUtils.ClearTable(self.addCtrls)
	TableUtils.ClearTable(self.showTrafficLight)
	
	TableUtils.ClearTable(self.removeCtrls)
	self.currentStreetId = nil
	self.lastStreetId = nil

	for id, v in pairs(self.carCtrls) do
		self.carCtrls[id] = nil
		self.fight.objectPool:Cache(CarCtrl, v)
	end
	for id, v in pairs(self.SummonCtrl) do
		self.SummonCtrl[id] = nil
		self.fight.objectPool:Cache(SummonCarCtrl, v)
	end

	for id, v in pairs(self.trafficLightCtrls) do
		self.fight.objectPool:Cache(TrafficLightCtrl, v)
	end
	

	TableUtils.ClearTable(self.trafficLightCtrls)
	TableUtils.ClearTable(self.StreetNodeCache)
	self.carNum = 0
end

-- 清理车辆
function TrafficManager:ClearCtrl()

	for id, v in pairs(self.carCtrls) do
		if not v:CheckIsDriving() then
			self.carCtrls[id] = nil
			self.fight.objectPool:Cache(CarCtrl, v)
		end
	end

	self.carNum = 0
end


--- 获取这条路上距离pos最近的路点index和车道
---@param pos any
---@param streetId any
function TrafficManager:GetClosestStartPointIndex(pos,streetId,ignoreRoadLine)
	
	self.GCSPI_cache1 = self.GCSPI_cache1 or Vec3.New()
	self.GCSPI_cache2 = self.GCSPI_cache2 or Vec3.New()

	local streetCenter = self.trafficMapConfig.streetConfig[streetId]
	if not streetCenter then
		return
	end

	local lastLoadPoint = 1

	local dist = _huge
	local nearestCoord
	local edgePoints = streetCenter.CenterPoint
	local isPrj
	for j, coord in ipairs(edgePoints) do
		if j ~= #edgePoints then
			local distance ,closePoint,isProject = self:DistancePointToLineSegmentXZ(pos,edgePoints[j + 1], edgePoints[j])
			if distance < dist then
				dist = distance
				nearestCoord = j
				isPrj = isProject
			end
		end
	end

	
	self.GCSPI_cache1:SetA(edgePoints[nearestCoord + 1])
	local towardDir = self.GCSPI_cache1:Sub(edgePoints[nearestCoord])
	self.GCSPI_cache2:SetA(pos)
	local towardPos = self.GCSPI_cache2:Sub(edgePoints[nearestCoord])
	-- 是否处于右手车道
	-- 如果忽略车道差异则默认为右边
	local isRight = towardDir:CrossA(towardPos).y > 0
	if ignoreRoadLine then
		isRight = true
	end

	local roadOffset 
	local roadLine = -1
	if dist <= TrafficManager:GetRoadWidth(streetCenter.RoadLevel , true) then
		local lineOffset = self.RoadLineEdgeOffsets[streetCenter.RoadLevel]
		for i, v in ipairs(lineOffset) do
			if v > dist and not roadOffset then
				roadOffset = i
			end
		end
		if not roadOffset then
			roadOffset = lineOffset[#lineOffset]
		end
		roadOffset = isRight and roadOffset or -roadOffset
		local roadNumNew = self:GetRoadLineNum(streetCenter.RoadLevel)
		roadLine = self:Offset2RoadLine(roadOffset,roadNumNew)
	else
		 -- 在车道外返回边缘车道
		roadLine = isRight and self:GetRoadLineNum(streetCenter.RoadLevel) or 1
	end

	local nextPointIndex

	--返回车道方向上pos位置的下一个点
	nextPointIndex = isRight and nearestCoord + 1 or nearestCoord

	return _clamp(nextPointIndex , 1,#edgePoints),roadLine,isPrj,streetCenter
end
-- 

--- 截取边缘片段
---@param pos 当前点
---@param edges 边缘集
---@param checkDistance 检测距离
---@param length 截取长度
---@param high 高度偏移
function TrafficManager:GetClosestEdge(pos,edges,checkDistance,length,high,closestEdge)
	self.GCE_cache1 = self.GCE_cache1 or Vec3.New()
	self.GCE_cache2 = self.GCE_cache2 or Vec3.New()

	closestEdge = closestEdge or {}

	if not edges or #edges == 0 then
		return
	end

	local minDist = _huge
	local nearestEdge = nil	--最近的边缘
	local nearestEdgeIndex = nil --最近的边缘上最近的路点
	local closestPoint = self.GCE_cache1 --最近的边缘上最近的切点
	
	for i, edgePoints in ipairs(edges) do
		local dist = _huge
		local nearestCoord
		local clsPoint = self.GCE_cache2
		for j, coord in ipairs(edgePoints) do
			if j ~= #edgePoints then
				local distance ,closePoint = self:DistancePointToLineSegmentXZ(pos,edgePoints[j + 1], edgePoints[j])
				if distance < dist then
					dist = distance
					nearestCoord = j
					clsPoint:SetA(closePoint) 
				end
			end
		end
		if dist < minDist then
			minDist = dist
			nearestEdge = i
			nearestEdgeIndex = nearestCoord
			closestPoint:SetA(clsPoint) 
		end
	end
	
	if minDist > checkDistance then
		-- 距离未达标
		return nil
	else
		-- 需要以closestPoint为中心，左右分别切出length/2的长度
		local targetEdge = edges[nearestEdge]
		local result = closestEdge
		local halfLen = length/2
		local rightLen = 0	-- 右边累计长度
		local leftLen = 0	-- 左边累计长度
		local addIndex = nearestEdgeIndex 
		local subIndex = nearestEdgeIndex + 1	-- 如果 1 -2 段为最近向量，则nearestEdgeIndex为1，计算边缘点应该包括考虑1和2点，所以这里这个做个offset
		local addArray = {}
		local subArray = {}
		local originPos = closestPoint
		table.insert(addArray , originPos)
		table.insert(subArray , originPos)
		while ((addIndex + 1 <= #targetEdge and rightLen < halfLen) or (subIndex - 1 >= 1 and leftLen < halfLen) ) do
			-- 累计算左边点
			if addIndex + 1 <= #targetEdge and rightLen < halfLen then
				addIndex = addIndex + 1
				local addLength = Vec3.DistanceXZ(targetEdge[addIndex],addArray[#addArray])

				if rightLen + addLength > halfLen then
					local tvalue = (halfLen - rightLen)/addLength
					local addPoint = self:PopVec3()
					Vec3.LerpA(addArray[#addArray], targetEdge[addIndex] , tvalue,addPoint)
					rightLen = halfLen
					table.insert(addArray , addPoint)
				else
					rightLen = rightLen + addLength
					table.insert(addArray,self:PopVec3A(targetEdge[addIndex])) 
				end
			end

			-- 累计算右边点
			if subIndex - 1 >= 1 and leftLen < halfLen then
				subIndex = subIndex - 1
				local subLength = Vec3.DistanceXZ(targetEdge[subIndex],subArray[#subArray])

				if leftLen + subLength > halfLen then
					local tvalue = (halfLen - leftLen)/subLength
					local addPoint = self:PopVec3()
					Vec3.LerpA( subArray[#subArray], targetEdge[subIndex],tvalue,addPoint)
					leftLen = halfLen
					table.insert(subArray , addPoint)
				else
					leftLen = leftLen + subLength
					table.insert(subArray,self:PopVec3A(targetEdge[subIndex])) 
				end
			end
		end

		for i = #addArray, 2, -1 do
			table.insert(result,addArray[i])
			addArray[i].y = addArray[i].y + high
		end

		for i = 2, #subArray, 1 do
			table.insert(result,subArray[i])
			subArray[i].y = subArray[i].y + high
		end
		return result
	end
end

function TrafficManager:DistancePointToLine(point, lineStart, lineEnd)
	local distance = _abs((lineEnd.z - lineStart.z) * point.x - (lineEnd.x - lineStart.x) * point.z + lineEnd.x * lineStart.z - lineEnd.z * lineStart.x)
					/ ((lineEnd.z - lineStart.z)^2 + (lineEnd.x - lineStart.x)^2)
	return distance
end

-- 点到线段xz平面距离,和点在线段xz平面上的投影点
function TrafficManager:DistancePointToLineSegmentXZ(point, lineStart, lineEnd)
	
	self.DPTLS_cache1 = self.DPTLS_cache1 or Vec3.New()
	self.DPTLS_cache2 = self.DPTLS_cache2 or Vec3.New()
	self.DPTLS_cache3 = self.DPTLS_cache3 or Vec3.New()
	self.DPTLS_cache4 = self.DPTLS_cache4 or Vec3.New()
	self.DPTLS_cache1:SetA(lineEnd)
	self.DPTLS_cache1:Sub(lineStart)
	self.DPTLS_cache1.y = 0
    local lineSegmentMagnitude = self.DPTLS_cache1:Magnitude()
    local lineDirection = self.DPTLS_cache1:SetNormalize()
	self.DPTLS_cache2:SetA(point)
	self.DPTLS_cache2:Sub(lineStart)
	self.DPTLS_cache2.y = 0

	-- 在xz平面的点积
    local dotProduct = Vec3.Dot(self.DPTLS_cache2 , lineDirection)
    dotProduct = _max(0, _min(dotProduct, lineSegmentMagnitude))
	-- 再次获取包括y轴的方向，保证投影点在线段上
	lineDirection:SetA(lineEnd)
	lineDirection:Sub(lineStart)
	lineDirection:SetNormalize()
	self.DPTLS_cache3:SetA(lineStart)
    local closestPointOnLine = self.DPTLS_cache3:Add(lineDirection:Mul(dotProduct))

	-- 距离只算xz
	self.DPTLS_cache4:SetA(point)
	self.DPTLS_cache4:Sub(closestPointOnLine)
	self.DPTLS_cache4.y = 0
    local distance = self.DPTLS_cache4:Magnitude()

    return distance,closestPointOnLine, dotProduct > 0
end

-- 获取道路两侧边缘点集
function TrafficManager:GetStreetEdge(streetId,edgeList)
	self.GSE_cache1 = self.GSE_cache1 or Vec3.New()
	self.GSE_cache2 = self.GSE_cache2 or Vec3.New()
	self.GSE_cache3 = self.GSE_cache3 or Vec3.New()
	self.GSE_cache4 = self.GSE_cache4 or Vec3.New()
	local streetCenter = self.trafficMapConfig.streetConfig[streetId]
	if not streetCenter then
		return
	end

	local leftEdge = {}
	local rightEdge = {}	

	local lastLoadPoint = 1
	for i = 1, #streetCenter.CenterPoint, 1 do
		-- 把头部路口边缘加上
		if i == 1 and streetCenter.HeadCross ~= 0 then
			local  edges = self:GetEdgesInCross(streetCenter.HeadCross ,streetCenter.RoadIndex)
			if edges then
				local crossRightEdge = edges[1]
				local crossLeftEdge = edges[2]
				-- 以右手顺时针方向计算edge ， 从头部插入时左边缘逆读 , 少加一个重复点
				for j = #crossRightEdge, 2, -1 do
					local edgePoint = crossRightEdge[j]
					table.insert(leftEdge,edgePoint)
				end
				self:PushVec3(crossRightEdge[1])
				
				-- 以右手顺时针方向计算edge ， 从头部插入时右边缘瞬读  , 少加一个重复点
				for j = 1, #crossLeftEdge -1, 1 do
					local edgePoint = crossLeftEdge[j]
					table.insert(rightEdge,edgePoint)
				end
				self:PushVec3(crossLeftEdge[#crossLeftEdge])
			end
		end
		
		local edgePos = streetCenter.CenterPoint

		local isSkip = false
		if i > 2 then
			self.GSE_cache1:SetA(edgePos[i - 1])
			self.GSE_cache1:Sub(edgePos[i - 2])
			self.GSE_cache2:SetA(edgePos[i])
			self.GSE_cache2:Sub(edgePos[i -1])
			
			local dotValue = Vec3.Dot(self.GSE_cache1:SetNormalize() ,self.GSE_cache2:SetNormalize())
			
			local reachEnd = i == #streetCenter.CenterPoint
			local tooFar = Vec3.Distance(edgePos[i],edgePos[lastLoadPoint]) > 20
			-- 如果和前一个向量没啥差别，就不加了
			if dotValue > 0.9999 and not reachEnd and not tooFar then
				isSkip = true
			end
		end
		
		if not isSkip then
			lastLoadPoint = i
			-- 点的位置向量
			local dirt = self.GSE_cache1
			if i == 1 then
				dirt:Set(edgePos[2].x - edgePos[1].x,0,edgePos[2].z - edgePos[1].z) 
			elseif i == #edgePos then
				dirt:Set(edgePos[#edgePos].x - edgePos[#edgePos - 1].x,0,edgePos[#edgePos].z - edgePos[#edgePos - 1].z)
			else
				self.GSE_cache1:Set(edgePos[i -1].x - edgePos[i].x,0,edgePos[i -1].z - edgePos[i].z)
				local beforeDir = self.GSE_cache1:SetNormalize()
				self.GSE_cache2:Set(edgePos[i +1].x - edgePos[i].x,0,edgePos[i +1].z - edgePos[i].z)
				local nextDir = self.GSE_cache2:SetNormalize()
				dirt = nextDir:Sub(beforeDir)
			end
			dirt:SetNormalize():CrossB(Vec3.up)
			self.GSE_cache3:SetA(dirt)
			self.GSE_cache4:SetA(dirt)
			-- 计算出左右边缘
			local left  = self.GSE_cache3:Mul(TrafficManager:GetRoadWidth(streetCenter.RoadLevel,true) * -1):Add(edgePos[i])
			local right  = self.GSE_cache4:Mul(TrafficManager:GetRoadWidth(streetCenter.RoadLevel,true)):Add(edgePos[i])
			table.insert(leftEdge, self:PopVec3A(left))
			table.insert(rightEdge, self:PopVec3A(right))
		end
		
		-- 把尾部路口边缘加上
		if i == #streetCenter.CenterPoint and streetCenter.AssCross ~= 0 then
			local  edges = self:GetEdgesInCross(streetCenter.AssCross ,streetCenter.RoadIndex)
			if edges then
				
				local crossRightEdge = edges[1]
				local crossLeftEdge = edges[2]

				-- 以右手顺时针方向计算edge ， 从尾部插入时右边缘顺读  , 少加一个重复点
				for j = 2, #crossRightEdge, 1 do
					local edgePoint = crossRightEdge[j]
					table.insert(rightEdge,edgePoint)
				end
				
				self:PushVec3(crossRightEdge[1])

				-- 以右手顺时针方向计算edge ， 从尾部插入时左边缘逆读
				for j = #crossLeftEdge -1 , 1, -1 do
					local edgePoint = crossLeftEdge[j]
					table.insert(leftEdge,edgePoint)
				end
				self:PushVec3(crossLeftEdge[#crossLeftEdge])
			end
	
		end
	end
	edgeList = edgeList or {}
	table.insert(edgeList,leftEdge)
	table.insert(edgeList,rightEdge)
	return edgeList
end

-- 获取路口边缘点集
function TrafficManager:GetEdgesInCross(crossId ,targetStreet, edgeList)
	self.GEIC_cache1 = self.GEIC_cache1 or Vec3.New()
	self.GEIC_cache2 = self.GEIC_cache2 or Vec3.New()
	self.GEIC_cache3 = self.GEIC_cache3 or Vec3.New()
	self.GEIC_cache4 = self.GEIC_cache4 or Vec3.New()
	self.GEIC_cache5 = self.GEIC_cache5 or Vec3.New()
	self.GEIC_cache6 = self.GEIC_cache6 or Vec3.New()
	self.GEIC_cache7 = self.GEIC_cache7 or Vec3.New()
	self.GEIC_cache8 = self.GEIC_cache8 or Vec3.New()
	local cross = self:GetCrossData(crossId)

	if not cross then return end
	
	edgeList = edgeList or {}
	local rightEdge
	local leftEdge

	
	for i, curStreetId in ipairs(cross.StreetNodes) do
		-- StreetNodes中街道已按顺时针排序过，这里直接取下一个即为右手边
		local nextStreetId = i == #cross.StreetNodes and cross.StreetNodes[1] or cross.StreetNodes[i+1]

		local curStreet = self:GetStreetCenterData(curStreetId)
		local nextStreet = self:GetStreetCenterData(nextStreetId)

		local curStreetPos1 = curStreet.AssCross == crossId and  curStreet.CenterPoint[#curStreet.CenterPoint] or curStreet.CenterPoint[1]
		local curStreetPos2 = curStreet.AssCross == crossId and  curStreet.CenterPoint[#curStreet.CenterPoint -1] or curStreet.CenterPoint[2]
		local curStreetWidth = TrafficManager:GetRoadWidth(curStreet.RoadLevel,true)
		
		local nextStreetPos1 = nextStreet.AssCross == crossId and  nextStreet.CenterPoint[#nextStreet.CenterPoint] or nextStreet.CenterPoint[1]
		local nextStreetPos2 = nextStreet.AssCross == crossId and  nextStreet.CenterPoint[#nextStreet.CenterPoint -1] or nextStreet.CenterPoint[2]
		local nextStreetWidth = TrafficManager:GetRoadWidth(nextStreet.RoadLevel,true)

		-- 如果有限定targetStreet，只输出targetStreet相关edge
		if not targetStreet or targetStreet == curStreet.RoadIndex or targetStreet == nextStreet.RoadIndex then
			-- 当前路方向向量
			self.GEIC_cache1:SetA(curStreetPos1)
			self.GEIC_cache1:Sub(curStreetPos2)
			self.GEIC_cache1.y = 0
			self.GEIC_cache1:SetNormalize()
			self.GEIC_cache1:CrossB(Vec3.up)
			
			self.GEIC_cache2:SetA(self.GEIC_cache1)
			self.GEIC_cache3:SetA(self.GEIC_cache1)
			local right1 = self.GEIC_cache2:Mul(curStreetWidth):Add(curStreetPos1)
			local right2 = self.GEIC_cache3:Mul(curStreetWidth):Add(curStreetPos2)

			
			-- 右手边的路的方向向量
			self.GEIC_cache4:SetA(nextStreetPos1)
			self.GEIC_cache4:Sub(nextStreetPos2)
			self.GEIC_cache4.y = 0
			self.GEIC_cache4:SetNormalize()
			self.GEIC_cache4:CrossB(Vec3.up)

			self.GEIC_cache5:SetA(self.GEIC_cache4)
			self.GEIC_cache6:SetA(self.GEIC_cache4)

			local nextLeft1  = self.GEIC_cache5:Mul(nextStreetWidth * -1):Add(nextStreetPos1)
			local nextLeft2  = self.GEIC_cache6:Mul(nextStreetWidth * -1):Add(nextStreetPos2)
			
			-- 右手路边和下一条路的左手路边的相交点
			local middleX,middleZ = self:calculateIntersectionPoint(right1.x,right1.z,right2.x,right2.z,nextLeft1.x,nextLeft1.z,nextLeft2.x,nextLeft2.z)
			local middleY = (right1.y + nextLeft2.y) /2
			local edge = {}

			-- 第一个点
			table.insert(edge,self:PopVec3A(right1))

			self.GEIC_cache7:Set(middleX,middleY,middleZ)
			local middlePos = self.GEIC_cache7
			local valueT = Vec3.DistanceXZ(right1 , middlePos)/(Vec3.DistanceXZ(right1 , middlePos) + Vec3.DistanceXZ(nextLeft1 , middlePos))

			
			local bezierPos = self:PopVec3()
			table.insert(edge,Vec3:CalculateBezierPoint(valueT,right1,middlePos,nextLeft1,self.GEIC_cache1,self.GEIC_cache8,self.GEIC_cache4,bezierPos))
			
			-- 第三个点
			table.insert(edge,self:PopVec3A(nextLeft1))

			if targetStreet then
				if targetStreet == curStreet.RoadIndex then
					rightEdge = edge
				else
					leftEdge = edge
				end
			else 
				table.insert(edgeList,edge)
			end
		end
	end
	if targetStreet then
		if rightEdge then
			table.insert(edgeList,rightEdge)
		end
		if leftEdge then
			table.insert(edgeList,leftEdge)
		end
	end

	return edgeList
end
-- 求两线相交
function TrafficManager:calculateIntersectionPoint(x1, y1, x2, y2, x3, y3, x4, y4)
	self.CIP_cache1 = self.CIP_cache1 or Vec3.New()
	self.CIP_cache2 = self.CIP_cache2 or Vec3.New()

	-- 计算参数方程的分母
	local denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

	-- 如果分母为0，则表示两条直线平行或重合，无交点
	if _abs(denominator) < 0.01 then
		return (x1 + x3)/2, (y1 + y3)/2
	end

	-- 计算参数 t1 和 t2
	local t1 = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
	local t2 = ((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator

	-- 计算交点的坐标
	local intersectionX = x1 + t1 * (x2 - x1)
	local intersectionY = y1 + t1 * (y2 - y1)

	
	
	self.CIP_cache1:Set(intersectionX - x1,0,intersectionY - y1)
	self.CIP_cache1:SetNormalize()
	self.CIP_cache2:Set(x1 - x2,0,y1 - y2)
	self.CIP_cache2:SetNormalize()
	local dot1 = Vec3.Dot(self.CIP_cache1,self.CIP_cache2)
	local onLine1 = _abs(dot1) > 0.9999
	
	self.CIP_cache1:Set(intersectionX - x3,0,intersectionY - y3)
	self.CIP_cache1:SetNormalize()
	self.CIP_cache2:Set(x3 - x4,0,y3 - y4)
	self.CIP_cache2:SetNormalize()
	local dot2 = Vec3.Dot(self.CIP_cache1,self.CIP_cache2)
	local onLine2 = _abs(dot2) > 0.9999

	local  length1 = ((x1 + x3)/2 - intersectionX) ^ 2  + ((y1 + y3)/2 - intersectionY) ^ 2
	local length2 = ((x1 - x3) ^ 2 + (y1 - y3) ^ 2)

	-- 没有在期望的地方相交，或者相交点太远
	-- 强制调整成中点，规避出现奇怪的点
	if not (onLine1 and onLine2) or length1 > length2 then
		return (x1 + x3)/2, (y1 + y3)/2
	end

	return intersectionX, intersectionY
end

--- 搜索距离该坐标xz平面上最近的道路
---@param pos any
---@param maxSearchDistanceXZ any
function TrafficManager:GetClosestStreet(pos,maxSearchDistanceXZ)
	local minDist = _huge
	local nearestCoord = 0

	if self.mapLocation.mapId ~= 10020005 then
		return nearestCoord , nearestCoord
	end 
	maxSearchDistanceXZ = maxSearchDistanceXZ or self.defaultSearchDis --xz平面200米
	local offset = 1
	local step = 5
	
	local pattern = self.pattern
	local roadPattern = self.roadPattern
	self.searchResultList = self.searchResultList or {}
	TableUtils.ClearTable(self.searchResultList)
	local curRoadList = RoadMeshConfig.GetRoadMeshId(pos.x, pos.z)
	if curRoadList then
		for k, v in ipairs(curRoadList) do
			local crossNum = string.match(v, pattern)
			local roadNum = string.match(v, roadPattern)
			if not crossNum and roadNum then
				if not self.searchResultList[roadNum] then
					self.searchResultList[roadNum] = tonumber(roadNum)
				end
			end
		end
	end
	
	-- 一圈一圈找
	while TableUtils.GetTabelLen(self.searchResultList) == 0 and offset < maxSearchDistanceXZ/5 do
		for i = -offset, offset, 1 do
			for j = -offset, offset, 1 do
				if _abs(i) > offset-1 or _abs(j) > offset-1 then
					local result = RoadMeshConfig.GetRoadMeshId(pos.x + i * 5 , pos.z + j * 5 )
					if result and #result > 0 then
						for k, v in ipairs(result) do
							local crossNum = string.match(v, pattern)
							local roadNum = string.match(v, roadPattern)
							if not crossNum and roadNum then
								if not self.searchResultList[roadNum] then
									self.searchResultList[roadNum] = tonumber(roadNum)
								end
							end
						end
						if TableUtils.GetTabelLen(self.searchResultList) ~= 0 then
							break
						end
					end
				end
			end
		end
		offset = offset + 1
	end


	local resultCount = TableUtils.GetTabelLen(self.searchResultList)
	if resultCount > 0 then
		if TableUtils.GetTabelLen(self.searchResultList) > 1 then
			-- 需要找出距离最近的道路
			self.searchNearPoint = self.searchNearPoint or {} 
			TableUtils.ClearTable(self.searchNearPoint)
			for k, v in pairs(self.searchResultList) do
				local street = self:GetStreetCenterData(v)
				if street then
					local nearIndex , dis = self:GetCloseLineInArray(street.CenterPoint,pos)
					self.searchNearPoint[k] = dis
				else
					LogError("RoadMeshConfig获取了未知的RoadIndex ".. v.." ,请检查配置是否需要更新")
				end
			end
			for k, distance in pairs(self.searchNearPoint) do
				if distance < minDist then
					minDist = distance
					nearestCoord = k
				end
			end
		else
			minDist = 0
			for k, v in pairs(self.searchResultList) do
				nearestCoord = k
			end
		end
		
	end

	return tonumber(nearestCoord) ,minDist
end
function TrafficManager:GetStreetAtPos(pos)

	if not self.mapLocation or self.mapLocation.mapId ~= 10020005 then
		return
	end
	

	local gb = CS.PhysicsTerrain.GetRayCastObject(pos.x,pos.y + 1,pos.z,0,-1,0,10,1)

	local pattern = self.pattern
	local roadPattern = self.roadPattern
	local crossNum = nil
	local roadNum = nil

	if gb then
		crossNum = string.match(gb.name, pattern)
		roadNum = string.match(gb.name, roadPattern)
	end

	-- 输出cross
	if crossNum then
		return nil,tonumber(crossNum)
	end
	-- 输出street
	if not crossNum and roadNum then
		local street = self:GetStreetCenterData(tonumber(roadNum))
		return tonumber(roadNum)
	end

	return
end
--- 获取线段集里距离curCoord最近的线段和最近距离，xz平面
---@param coords any
---@param curCoord any
function TrafficManager:GetCloseLineInArray(coords, curCoord)

	local dist = _huge
	local nearestCoord
	for j, coord in ipairs(coords) do
		if j ~= #coords then
			local distance = self:DistancePointToLineSegmentXZ(curCoord,coords[j + 1], coords[j])
			if distance < dist then
				dist = distance
				nearestCoord = j
			end
		end
	end

	return nearestCoord , dist
end

function TrafficManager:GetNearRoad(streetCenter,curPointIndex,nearRoad,maxNum)
	self.nearRoadDis = self.nearRoadDis or {}
	TableUtils.ClearTable(self.nearRoadDis)

	local targetNodes
	if curPointIndex > #streetCenter.CenterPoint/2 then
		targetNodes = streetCenter.AssCrossNode
	else
		targetNodes = streetCenter.HeadCrossNode
	end
	for i, v in ipairs(targetNodes) do
		if not maxNum or self:GetStreetCheckNum(v) < maxNum then
			table.insert(nearRoad,v)
		end
	end
end


function TrafficManager:SummonCar(entityId)
	local findPoint,targetPos = self:GetNearClearStreetPoint()

	if  findPoint then
		-- 回收之前的车辆
		self:FreeSummonCar(self.SummonInstanceId)

		

		self.SummonInstanceId = self.SummonInstanceId + 1
		local ctrl = self.fight.objectPool:Get(SummonCarCtrl)
		ctrl:Init(self.fight, self, self.SummonInstanceId, entityId, findPoint,targetPos,true)
		self.SummonCtrl[self.SummonInstanceId] = ctrl

		return self.SummonInstanceId 
	end
end


function TrafficManager:FreeSummonCar(summonInstanceId)
	if self.SummonCtrl[summonInstanceId] then
		local freeEntity = self.SummonCtrl[summonInstanceId].entity
		self.fight.objectPool:Cache(SummonCarCtrl, self.SummonCtrl[summonInstanceId])
		
		if freeEntity.instanceId then
			-- 变成Ai车回收
			self:AddCtrl2(freeEntity.instanceId)
		end
		
		--关闭屏幕上所有的交互列表
		Fight.Instance.entityManager:CheckTriggerComponnet(BehaviorFunctions.GetCtrlEntity())
		
		self.SummonCtrl[summonInstanceId] = nil
	end
end

function TrafficManager:GetNearClearStreetPoint()

	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	if not player then
		return
	end
		
	-- 获取离玩家最近的道路
	local pos = player.transformComponent.position
	local streetId , nearDistance = self:GetClosestStreet(pos,CallVehicleConfig.GetCallVehicleDisMaxValue())
	-- 默认搜索范围内没找到路，或最近的路都超过了刷车范围
	if streetId == 0 then return end

	local tryFindPoint = function(targetIndex,street,roadLine)
		if targetIndex + 1 > #street.CenterPoint then
			return
		end
		local randomT = _random(100)
		local ramdomPoint =  Vec3.Lerp(street.CenterPoint[targetIndex],street.CenterPoint[targetIndex + 1],randomT/100)
		
		self:CalStreetPointPos(street, targetIndex, roadLine ,ramdomPoint)

		
		local squareDisClose = Vec3.SquareDistance(pos, ramdomPoint) < CallVehicleConfig.GetCallVehicleDisMinValue() ^2
		local squareDisFar = Vec3.SquareDistance(pos, ramdomPoint) > CallVehicleConfig.GetCallVehicleDisMaxValue() ^2
		local inScreen = BehaviorFunctions.CheckPosIsInScreen(ramdomPoint)
		local hasEntity = Physics.CheckSphere(ramdomPoint, self.trafficParams.road_width, FightEnum.LayerBit.EntityCollision)
		if  not inScreen and not hasEntity and not squareDisClose and not squareDisFar then
			return ramdomPoint
		end
	end

	local tryFindStreet = function(street,startIndex,roadline)
		local findPoint
		local leftPos = startIndex - 1
		local rightPos = startIndex
		local forward = roadline > (self:GetRoadLineNum(street.RoadLevel) + 1 )/2
		while (leftPos >= 1 or rightPos<= #street.CenterPoint) and not findPoint do
			if leftPos >= 1 then
				findPoint = tryFindPoint(leftPos,street,roadline)
			end
			if rightPos<= #street.CenterPoint and not findPoint then
				findPoint = tryFindPoint(rightPos,street,roadline)
			end
			leftPos = leftPos - 1
			rightPos = rightPos + 1
		end
		return findPoint,findFoward
	end


	
	local streetCenter = self.trafficMapConfig.streetConfig[streetId]
	local curPointIndex,roadLine = self:GetClosestStartPointIndex(pos,streetId)
	local forward = roadLine > (self:GetRoadLineNum(streetCenter.RoadLevel) + 1 )/2
	local findPoint , findFoward = tryFindStreet(streetCenter,forward and 1 or #streetCenter.CenterPoint,roadLine)
	
	if not findPoint then
		local nearRoad = {}
		self:GetNearRoad(streetCenter,curPointIndex,nearRoad)

		for i, v in ipairs(nearRoad) do
		
			local nextRoad = self.trafficMapConfig.streetConfig[v]
			local headOn  = TableUtils.ContainValue(nextRoad.HeadCrossNode ,streetId)
			
			findPoint = tryFindStreet(nextRoad,headOn and 1 or #nextRoad.CenterPoint, headOn and self:GetRoadLineNum(nextRoad.RoadLevel) or 1)
			if findPoint then
				break
			end
		end
	end
	

	local targetPos = streetCenter.CenterPoint[curPointIndex]
	targetPos = Vec3.New(targetPos.x,targetPos.y,targetPos.z)
	self:CalStreetPointPos(streetCenter, curPointIndex, roadLine ,targetPos)

	return findPoint,targetPos
end


function TrafficManager:CheckInHotSpace(streetIndex)
	if not streetIndex then
		return
	end
	local streetCenter = self.currentStreetCenter
	if streetCenter and self.currentStreetCenter.RoadIndex ==streetIndex then
		return true
	end
	if streetCenter and self.currentPointIndex then
		
		local targetNodes
		if self.currentPointIndex > #streetCenter.CenterPoint/2 then
			targetNodes = streetCenter.AssCrossNode
		else
			targetNodes = streetCenter.HeadCrossNode
		end
		return TableUtils.ContainValue(targetNodes,streetIndex)
	end
end

function TrafficManager:Load()

	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	if not player then
		return
	end
	
	UnityUtils.BeginSample("trafficManager:Load1")
	if self.beginLoadCb then
		self.beginLoadCb()
		self.beginLoadCb = nil
	end
	-- 获取离玩家最近的道路
	
	local pos = player.transformComponent.position
	local squareMinDis, squareMaxDis = self.trafficParams.range[1]^2, self.trafficParams.range[2]^2
	local streetId , nearDistance = self:GetClosestStreet(pos,self.loadCarDis)
	self.currentStreetId = streetId
	local isPrj
	self.currentPointIndex,self.currentRoadLine,isPrj,self.currentStreetCenter =  self:GetClosestStartPointIndex(pos,streetId)
	


	-- 默认搜索范围内没找到路，或最近的路都超过了刷车范围
	if streetId == 0 or nearDistance^2 > squareMaxDis then return end

	local streetCenter = self.currentStreetCenter

	-- 获取最近道路的处于刷车范围内的邻路
	self.nearRoad = self.nearRoad or {}
	TableUtils.ClearTable(self.nearRoad)
	self:GetNearRoad(streetCenter,self.currentPointIndex,self.nearRoad, math.ceil(self.trafficParams.traffic_volumn/3))
	table.insert(self.nearRoad,streetId)

	local targetTrafficVolmn = self.trafficParams.traffic_volumn--_ceil(_min(#self.nearRoad/3,1) * self.trafficParams.traffic_volumn) 
	
	UnityUtils.EndSample()
	if self.carNum >= targetTrafficVolmn then
		if self.LoadedCallBack then
			self.LoadedCallBack()
			self.LoadedCallBack = nil
		end
		return
	end

	UnityUtils.BeginSample("trafficManager:Load2")
	-- 加载位置缓存
	self.loadPosCache = self.loadPosCache or {}

	for i, cachePos in pairs(self.loadPosCache) do
		cachePos:Set(0,0,0)
	end
	local carEntityIds = self.trafficParams.car_ids
	local coolingFrame = self.trafficParams.cooling * FightUtil.targetFrameRate

	for i = 1, targetTrafficVolmn do
		if self.carNum >= targetTrafficVolmn then
			break
		end

		local findPoint
		local streetIndex
		local errorCount = 0
		local randomAdj = nil
		local randomCenterPointIndex = nil
		local roadLineNum = nil
		while not findPoint and errorCount <1 do
			errorCount = errorCount + 1

			-- 随机邻路
			local randomAdjId = self.nearRoad[_random(#self.nearRoad)]
			randomAdj = self.trafficMapConfig.streetConfig[randomAdjId]

			

			-- 让出生点靠近热点路口,
			-- 从2开始因为要绕开路口首尾点
			if randomAdj.RoadIndex == streetId then
				-- 当前道路上，刷在另一半边
				if self.currentPointIndex > #streetCenter.CenterPoint/2 then
					randomCenterPointIndex = _random(2, _max(2,_floor(TableUtils.GetTabelLen(streetCenter.CenterPoint)/2)))
				else
					local halfLength = _floor(TableUtils.GetTabelLen(streetCenter.CenterPoint)/2)
					randomCenterPointIndex = halfLength +_random(1, _max(2,TableUtils.GetTabelLen(streetCenter.CenterPoint)- 1)- halfLength)
				end
			else
				
				-- 判断这条路是否为对向路
				local isHead = TableUtils.ContainValue(streetCenter.HeadCrossNode,randomAdjId)
				local targetCrossNode = isHead and streetCenter.HeadCrossNode or streetCenter.AssCrossNode
				local cross = self:GetCrossData(isHead and streetCenter.HeadCross or streetCenter.AssCross )
				local isOppsite = self:CheckIfOppositeStreet(streetCenter,randomAdj,cross)
				local headNear = TableUtils.ContainValue(randomAdj.HeadCrossNode,streetId)

				-- 是对向路，刷在另外半边
				if isOppsite then
					headNear = not headNear
				end
				
				-- 否则刷在靠近路口半边
				if headNear then
					randomCenterPointIndex = _random(2, _max(2,_floor(TableUtils.GetTabelLen(randomAdj.CenterPoint)/2)))
				else
					local halfLength = _floor(TableUtils.GetTabelLen(randomAdj.CenterPoint)/2)
					randomCenterPointIndex = halfLength +_random(1, _max(2,TableUtils.GetTabelLen(randomAdj.CenterPoint)- 1)- halfLength)
				end

			end
			-- 随机车道

			-- 优先选择面向当前道路的路口行驶
			if #randomAdj.HeadCrossNode == 0 then--or TableUtils.ContainValue(randomAdj.AssCrossNode,streetId) then
				roadLineNum = self:GetRoadLineNum(randomAdj.RoadLevel)/2 + _random(self:GetRoadLineNum(randomAdj.RoadLevel)/2)
			elseif #randomAdj.AssCrossNode == 0  then--or TableUtils.ContainValue(randomAdj.HeadCrossNode,streetId)  then
				roadLineNum = _random(self:GetRoadLineNum(randomAdj.RoadLevel)/2)
			else
				roadLineNum = _random(self:GetRoadLineNum(randomAdj.RoadLevel))
			end
			-- 路点前后不允许有车
			if self:GetRoadPointCheck(randomAdjId,randomCenterPointIndex,roadLineNum,_max(2,randomCenterPointIndex - 5))
				or self:GetRoadPointCheck(randomAdjId,randomCenterPointIndex,roadLineNum,_min(TableUtils.GetTabelLen(randomAdj.CenterPoint),randomCenterPointIndex + 5)) then
				break
			end
			-- 随机落位
			local randomT = _random(90)
			local ramdomPoint =  Vec3.Lerp(randomAdj.CenterPoint[randomCenterPointIndex],randomAdj.CenterPoint[randomCenterPointIndex + 1],randomT/100)

			self:CalStreetPointPos(randomAdj, randomCenterPointIndex, roadLineNum ,ramdomPoint)
			
			local tooNear = false
			-- 同一次load无法通过检测实体判断，这里缓存一下加载位置剔除重复位置

			for i, cachePos in pairs(self.loadPosCache) do
				if Vec3.SquareDistance(ramdomPoint, cachePos) < 10^2 then
					tooNear = true
				end
			end
			

			local squareDis = Vec3.SquareDistance(pos, ramdomPoint)
			-- 最小距离的相机外，或太远的的相机内
			local checkInView = BehaviorFunctions.CheckPosIsInScreen(ramdomPoint)
			if not tooNear and squareDis >= squareMinDis and squareDis < squareMaxDis
				and (not checkInView  or squareDis > squareMaxDis * 0.7) then
				findPoint = ramdomPoint
				streetIndex = randomAdjId
			end

			if errorCount > 10 then
				LogError("[Traffic]咋找不到能用的点呢")
			end
			
		end
		local randomCenterPoint = nil
		if findPoint then
			local entityId = carEntityIds[_random(#carEntityIds)]
			self:AddCtrl(entityId,findPoint,streetIndex)
			
			self.loadPosCache[i] = self.loadPosCache[i] or Vec3.New()
			self.loadPosCache[i]:SetA(findPoint)
			
		end
	end
	
	UnityUtils.EndSample()
end
-- 生成唯一key
function TrafficManager:SzudzikPairing(x, y, z)
	if x < y then
		return z + ((y + x) * (y + x + 1) / 2) + x
	else
		return z + ((x + y) * (x + y + 1) / 2) + y
	end
end

-- 车道数量
function TrafficManager:GetRoadLineNum(level)
	if level == 1 then
		return 6
	elseif level == 2 then
		return 4
	elseif level == 3 then
		return 4
	elseif level == 4 then
		return 4
	elseif level == 5 then
		return 2
	elseif level == 6 then
		return 2
	else
		return 0
	end
end

TrafficManager.RoadLineOffsets = {{ 3.025,7.225,11.425 },{4.25,8.45},{3.25,7.45},{2.1,6.3},{2.1},{2.1}}
TrafficManager.RoadLineEdgeOffsets = {{ 5.125,9.325,13.525 },{6.35,10.55},{5.35,9.55},{4.2,8.4},{4.2},{4.2}}
-- 当前车道相对于中线的偏移
function TrafficManager:GetRoadLineOffset(level,lineNum)
	local roadNum = self:GetRoadLineNum(level)
	local offset= self:RoadLine2Offset(lineNum,roadNum)
	
	local lineOffset = self.RoadLineOffsets[level][_abs(offset)]
	if lineOffset then
		return offset > 0 and lineOffset or - lineOffset
	end
end


-- 当前车道外边距离
function TrafficManager:GetRoadWidth(level , isOut)
	local dis = -1
	if level == 1 then
		dis = isOut and 13.925 or 0.325
	elseif level == 2 then
		dis = isOut and 12.75 or 2.25
	elseif level == 3 then
		dis = isOut and 9.9 or 1.25
	elseif level == 4 then
		dis = isOut and 8.75 or -1
	elseif level == 5 then
		dis = isOut and 5.8 or -1
	elseif level == 6 then
		dis = isOut and 4.55 or -1
	end
	return dis
end

function TrafficManager:__delete()
	self.loadType = LoadType.Clear
	--self:UpdateEnable()

	self:RemoveListener()


end