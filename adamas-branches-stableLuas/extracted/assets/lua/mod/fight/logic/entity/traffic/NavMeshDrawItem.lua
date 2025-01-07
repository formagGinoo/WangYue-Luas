---@class NavMeshDrawItem 道路引导线（人物行走部分）
NavMeshDrawItem = BaseClass("NavMeshDrawItem",PoolBaseClass)

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

local refreshDelayTime = 1
local refreshDelayDis = 1
local _navPathMaxDistance = 100

function NavMeshDrawItem:__init()
    --self.pos = Vec3.New(0,0,0)
    self.cachePath = {} --保存上次寻路的数据
    self.pointList = {}
    
    self.addUpTime = 0 --时间
end


function NavMeshDrawItem:Init(type, meshDrawType, args, navPathDrawInstanceId, navRoadPathDrawInstanceId, mapNavPathInstanceId)
    self.type = type
    self.meshDrawType = meshDrawType --当前是哪种虚线
    self.args = args
    self.NavPathDrawInstanceId = navPathDrawInstanceId --自身的id
    self.navRoadPathDrawInstanceId = navRoadPathDrawInstanceId --道路线实例id 
    self.mapNavPathInstanceId = mapNavPathInstanceId --父对象的id

    if self.type == FightEnum.NavPathDrawType.Static then
        self.color = self.args[2]
        self:DrawStaticPointList()
        return 
    end
    
    self:Update()
end

function NavMeshDrawItem:DrawStaticPointList()
    local curEntityId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
    local selfEntity = Fight.Instance.entityManager:GetEntity(curEntityId)
    local pos = selfEntity.transformComponent:GetPosition()-- 当前人物位置
    local roadPosList = Fight.Instance.mapNavPathManager:GetCurDrawPointUI(self.navRoadPathDrawInstanceId, self.mapNavPathInstanceId)
    
    local targetPosList = self.args[1]
    
    local startPos = pos 
    local targetPos
    if self.meshDrawType == FightEnum.NavMeshDrawType.Role2Road then
        if roadPosList and #roadPosList > 0 then
            targetPos = roadPosList[1]
        end
    elseif self.meshDrawType == FightEnum.NavMeshDrawType.Road2Target then
        if roadPosList and #roadPosList > 0 then
            startPos = roadPosList[#roadPosList]
        end
        targetPos = targetPosList[#targetPosList]
    end

    TableUtils.ClearTable(self.cachePath)
    local posArray, count = self:FindPathByNavMesh(startPos, targetPos)
    if posArray then
        for i = 0, count - 1 do
            table.insert(self.cachePath, Vec3.New(posArray[i].x, posArray[i].y, posArray[i].z))
        end
    else
        self:FindPathByMidPoints(startPos, targetPos)
    end
    if #self.cachePath > 0 then
        TableUtils.ClearTable(self.pointList)
        for i, v in ipairs(self.cachePath) do
            self.pointList[i] = v
        end
        EventMgr.Instance:Fire(EventName.UpdateNavMeshPath, self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
    end
end

function NavMeshDrawItem:Update()
    

    local deltaTime = FightUtil.deltaTimeSecond
    self.addUpTime = self.addUpTime + deltaTime

    self:_doUpdate()
end

-- 计算路线传入画线器
-- 计算一次路径每次按照当前位置截取，如果检测到偏移路径3秒则重新计算路径
function NavMeshDrawItem:_doUpdate()
    local curEntityId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
    local selfEntity = Fight.Instance.entityManager:GetEntity(curEntityId)
    local pos = selfEntity.transformComponent:GetPosition()-- 当前人物位置

    local startPos = pos   -- 起始位置
    local targetPos        -- 目标位置
    local unloadDis -- 卸载距离
    local roadPosList = Fight.Instance.mapNavPathManager:GetCurDrawPointUI(self.navRoadPathDrawInstanceId, self.mapNavPathInstanceId)
    local playerDriving = BehaviorFunctions.CheckCtrlDrive()

    if self.type == FightEnum.NavPathDrawType.Self2Static then
        targetPos = self.args[1]
        unloadDis = self.args[2] or Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMin
        self.color = self.args[3]
    elseif self.type == FightEnum.NavPathDrawType.self2Entity then
        -- 目标实体已消失
        local targetInstance = self.args[1]
        local targetEntity = Fight.Instance.entityManager:GetEntity(targetInstance)
        if not targetEntity then
            Fight.Instance.mapNavPathManager:_RemoveNavMeshGuideEffect(self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
            return
        end
        unloadDis = self.args[2] or Fight.Instance.entityManager.trafficManager.defaultGuidePathShowMin
        self.color = self.args[3]
        targetPos = targetEntity.transformComponent:GetPosition()
    end

    if self.meshDrawType == FightEnum.NavMeshDrawType.Role2Road then
        if playerDriving then
            self:ClearAndHidePath()
            return
        end
        if not roadPosList or #roadPosList == 0 then
            self:ClearAndHidePath()
            return --没有道路数据直接return
        end

        targetPos = roadPosList[1]
    elseif self.meshDrawType == FightEnum.NavMeshDrawType.Road2Target then
        if roadPosList and #roadPosList > 0 then
            startPos = roadPosList[#roadPosList]
        end
    end
    
    -- 到达卸载距离
    if Vec3.DistanceXZ(pos,targetPos) < unloadDis then
        self:ClearAndHidePath()
        return 
    end
    
    --有驾驶状态变更时，清空缓存路径cache
    local isPlayerDrivingChange = false
    if self.playerDriving ~= playerDriving then
        self.playerDriving = playerDriving
        isPlayerDrivingChange = true
        TableUtils.ClearTable(self.cachePath)
    end

    --范围变更，清空缓存路径cache
    local inRect = Vec3.DistanceXZ(pos, targetPos) < _navPathMaxDistance
    if self.playerRectChange ~= inRect and not playerDriving then
        self.playerRectChange = inRect
        TableUtils.ClearTable(self.cachePath)
    end

    -- 检查位移 ，当起始点、终点变化 并且超过一定时间后刷新
    local posChange = true
    if not self.lastPos or not self.lastTarPos then
        self.lastPos = Vec3.New(startPos.x, startPos.y, startPos.z)
        self.lastTarPos = Vec3.New(targetPos.x,targetPos.y,targetPos.z)
        posChange = true
    else
        local newPosChange = Vec3.DistanceXZ(self.lastPos, startPos)
        local newTarPos = Vec3.DistanceXZ(self.lastTarPos,targetPos)
        posChange = newPosChange > refreshDelayDis or newTarPos > refreshDelayDis
    end

    if not posChange and not isPlayerDrivingChange then
        return
    end
    
    TableUtils.ClearTable(self.cachePath)
    self.lastPos:SetA(startPos)
    self.lastTarPos:SetA(targetPos)


    --在有道路数据情况下，且在100米范围外时，不用检查更新
    local needRefresh = (#self.cachePath <= 0)
    if not needRefresh then
        return
    end
    --if posChange then
    --    -- 偏离导航
    --    if not self.goesOffTime then
    --        self.goesOffTime = self.addUpTime
    --    end
    --    -- 偏离超过一定时间
    --    if self.goesOffTime and self.addUpTime - self.goesOffTime > refreshDelayTime then
    --        needRefresh = true
    --        self.goesOffTime = nil
    --    end
    --end

    -- 道路信息变化，整体重新寻路
    if needRefresh then
        TableUtils.ClearTable(self.cachePath)
        local posArray, count = self:FindPathByNavMesh(startPos, targetPos)
        if posArray then
            for i = 0, count - 1 do
                table.insert(self.cachePath, Vec3.New(posArray[i].x, posArray[i].y, posArray[i].z))
            end
        else
            self:FindPathByMidPoints(startPos, targetPos)
        end
    end

    if #self.cachePath > 0 then
        TableUtils.ClearTable(self.pointList)
        for i, v in ipairs(self.cachePath) do
            self.pointList[i] = v
        end
        EventMgr.Instance:Fire(EventName.UpdateNavMeshPath, self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
    end

end

function NavMeshDrawItem:FindPathByMidPoints(point1, point2)
    local deltaX = point2.x - point1.x;
    local deltaY = point2.y - point1.y;
    local deltaZ = point2.z - point1.z;

    local totalPoints = math.max(math.abs(deltaX), math.abs(deltaZ)) 

    local stepX = deltaX / totalPoints;
    local stepY = deltaY / totalPoints;
    local stepZ = deltaZ / totalPoints;

    table.insert(self.cachePath, Vec3.New(point1.x, point1.y, point1.z))
    
    for i = 1, math.floor(totalPoints) do
        local newX = point1.x + stepX * i;
        local newY = point1.y + stepY * i;
        local newZ = point1.z + stepZ * i;
        table.insert(self.cachePath, Vec3.New(newX, newY, newZ))
    end
end

function NavMeshDrawItem:FindPathByNavMesh(curPos, targetPos)
    local posArray, count = CustomUnityUtils.NavCalculatePath(curPos, targetPos, 1)
    if count > 0 then
        return posArray, count
    end
    return
end

function NavMeshDrawItem:ClearAndHidePath()
    if #self.cachePath > 0 or #self.pointList > 0 then
        TableUtils.ClearTable(self.cachePath)
        TableUtils.ClearTable(self.pointList)
        EventMgr.Instance:Fire(EventName.UpdateNavMeshPath, self.NavPathDrawInstanceId, self.mapNavPathInstanceId)
    end
end

function NavMeshDrawItem:ClearPath()
    self.lastPos = nil
    self.lastTarPos = nil
    self.goesOffTime = nil
    self.cachePath = {}
    self.pointList = {}
end


function NavMeshDrawItem:OnCache()
    self:ClearPath()

    local fight = Fight.Instance
    if fight and not fight.clearing and Fight.Instance.objectPool.objectPool[NavMeshDrawItem] then
        Fight.Instance.objectPool:Cache(NavMeshDrawItem,self)
    end
end

function NavMeshDrawItem:__cache()
end

function NavMeshDrawItem:__delete()
end