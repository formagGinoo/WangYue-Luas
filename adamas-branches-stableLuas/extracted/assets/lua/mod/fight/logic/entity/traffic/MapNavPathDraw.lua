---@class MapNavPathDraw 地图引导线
MapNavPathDraw = BaseClass("MapNavPathDraw",PoolBaseClass)

function MapNavPathDraw:__init()
    self.type = nil
    self.args = nil
    self.instanceId = nil -- 自身实例id

    self.NavRoadPathDraw = {}
    self.NavRoadPathDrawInstanceId = 0 -- 道路引导线实例id
    self.NavMeshDrawItem = {}
    self.NavMeshDrawInstanceId = 0 -- navMesh寻路线实例id 
end

function MapNavPathDraw:Init(type, args, instanceId)
    self.type = type
    self.args = args
    self.instanceId = instanceId
    
    self:DrawPointList()
end

function MapNavPathDraw:AfterUpdate()
    for i, navRoadPathDraw in pairs(self.NavRoadPathDraw) do
        navRoadPathDraw:Update()
    end
    for i, navMeshDraw in pairs(self.NavMeshDrawItem) do
        navMeshDraw:Update()
    end
end

function MapNavPathDraw:DrawPointList()
    self:_DrawNavRoadGuideEffect(self.type, self.args)
    self:_DrawNavMeshGuideEffect(self.type, FightEnum.NavMeshDrawType.Role2Road, self.args) --人物 -> 道路起点 
    self:_DrawNavMeshGuideEffect(self.type, FightEnum.NavMeshDrawType.Road2Target, self.args) --道路终点-> 目标点
end

--画出道路指引线
function MapNavPathDraw:_DrawNavRoadGuideEffect(type, args)
    self.NavRoadPathDrawInstanceId = self.NavRoadPathDrawInstanceId + 1
    self.NavRoadPathDraw[self.NavRoadPathDrawInstanceId] = Fight.Instance.objectPool:Get(NavPathDrawItem)
    self.NavRoadPathDraw[self.NavRoadPathDrawInstanceId]:Init(type, args, self.NavRoadPathDrawInstanceId, self.instanceId)

    return self.NavRoadPathDrawInstanceId
end

--画出navMesh指引线
function MapNavPathDraw:_DrawNavMeshGuideEffect(type, meshDrawType, args)
    self.NavMeshDrawInstanceId = self.NavMeshDrawInstanceId + 1
    self.NavMeshDrawItem[self.NavMeshDrawInstanceId] = Fight.Instance.objectPool:Get(NavMeshDrawItem)
    self.NavMeshDrawItem[self.NavMeshDrawInstanceId]:Init(type, meshDrawType, args, self.NavMeshDrawInstanceId, self.NavRoadPathDrawInstanceId, self.instanceId)

    return self.NavMeshDrawInstanceId
end

--- 获取当前道路点的画线
---@param instanceId any
function MapNavPathDraw:GetCurDrawPointUI(instanceId)
    if self.NavRoadPathDraw[instanceId] then
        return self.NavRoadPathDraw[instanceId].curDrawPointUI
    end
end

---@param instanceId any
function MapNavPathDraw:GetCurDrawPoint3D(instanceId)
    if self.NavRoadPathDraw[instanceId] then
        return self.NavRoadPathDraw[instanceId].curDrawPoint3D, self.NavRoadPathDraw[instanceId].type
    end
end

---@param instanceId any
function MapNavPathDraw:GetCurDrawPointColor(instanceId)
    if self.NavRoadPathDraw[instanceId] then
        return self.NavRoadPathDraw[instanceId].color
    end
end

--- 获取当前navMesh的画线
---@param instanceId any
function MapNavPathDraw:GetCurNavMeshPoint(instanceId)
    if self.NavMeshDrawItem[instanceId] then
        return self.NavMeshDrawItem[instanceId].pointList
    end
end

---@param instanceId any
function MapNavPathDraw:GetCurNavMeshPointColor(instanceId)
    if self.NavMeshDrawItem[instanceId] then
        return self.NavMeshDrawItem[instanceId].color
    end
end

function MapNavPathDraw:_RemoveRoadGuideEffect(instanceId)
    if not self.NavRoadPathDraw[instanceId] then
        return
    end
    
    local draw = self.NavRoadPathDraw[instanceId]
    draw:OnCache()
    self.NavRoadPathDraw[instanceId] = nil
    EventMgr.Instance:Fire(EventName.RemoveRoadPath, instanceId, self.instanceId)
end

function MapNavPathDraw:_RemoveNavMeshGuideEffect(instanceId)
    if not self.NavMeshDrawItem[instanceId] then
        return
    end
    
    local draw = self.NavMeshDrawItem[instanceId]
    draw:OnCache()
    self.NavMeshDrawItem[instanceId] = nil
    EventMgr.Instance:Fire(EventName.RemoveNavMeshPath, instanceId, self.instanceId)
end

function MapNavPathDraw:RemovePath()
    for i, navRoadPathDraw in pairs(self.NavRoadPathDraw) do
        self:_RemoveRoadGuideEffect(i)
    end
    for i, navMeshDraw in pairs(self.NavMeshDrawItem) do
        self:_RemoveNavMeshGuideEffect(i)
    end
    TableUtils.ClearTable(self.NavRoadPathDraw)
    TableUtils.ClearTable(self.NavMeshDrawItem)
end


function MapNavPathDraw:OnCache()
    
    self:RemovePath()
    EventMgr.Instance:Fire(EventName.RemoveDrawPath, self.instanceId)
    
    local fight = Fight.Instance
    if fight and not fight.clearing and Fight.Instance.objectPool.objectPool[MapNavPathDraw] then
        Fight.Instance.objectPool:Cache(MapNavPathDraw,self)
    end
end

function MapNavPathDraw:__cache()
end

function MapNavPathDraw:__delete()
    
end