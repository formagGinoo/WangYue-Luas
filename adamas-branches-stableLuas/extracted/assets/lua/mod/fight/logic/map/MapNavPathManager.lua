---@class MapNavPathManager
MapNavPathManager = BaseClass("MapNavPathManager")

function MapNavPathManager:__init(fight)
    self.fight = fight
    
    self.mapNavPathDrawList = {} --地图引导线实例
    self.mapNavPathDrawInstanceId = 0 --地图引导线实例id
end

function MapNavPathManager:StartFight()
    local traceMarks = mod.WorldMapCtrl:GetTraceMarks()
    for instanceId, _ in pairs(traceMarks) do
        --添加地图追踪线
        mod.WorldMapCtrl:AddTraceGuideAndPath(instanceId)
    end
end

function MapNavPathManager:AfterUpdate()
    if not self.fight or mod.WorldMapCtrl:CheckIsDup() then
        return 
    end
    if not next(self.mapNavPathDrawList) then
        return
    end

    for i, mapNavPathDraw in pairs(self.mapNavPathDrawList) do
        mapNavPathDraw:AfterUpdate()
    end
end

--- 获取当前道路点的画线
---@param instanceId any
function MapNavPathManager:GetCurDrawPointUI(instanceId, mapNavPathInstanceId)
    if self.mapNavPathDrawList[mapNavPathInstanceId] then
        return self.mapNavPathDrawList[mapNavPathInstanceId]:GetCurDrawPointUI(instanceId)
    end
end

---@param instanceId any
function MapNavPathManager:GetCurDrawPoint3D(instanceId, mapNavPathInstanceId)
    if self.mapNavPathDrawList[mapNavPathInstanceId] then
        return self.mapNavPathDrawList[mapNavPathInstanceId]:GetCurDrawPoint3D(instanceId)
    end
end

---@param instanceId any
function MapNavPathManager:GetCurDrawPointColor(instanceId, mapNavPathInstanceId)
    if self.mapNavPathDrawList[mapNavPathInstanceId] then
        return self.mapNavPathDrawList[mapNavPathInstanceId]:GetCurDrawPointColor(instanceId)
    end
end

--- 获取当前navMesh的画线
---@param instanceId any
function MapNavPathManager:GetCurNavMeshPoint(instanceId, mapNavPathInstanceId)
    if self.mapNavPathDrawList[mapNavPathInstanceId] then
        return self.mapNavPathDrawList[mapNavPathInstanceId]:GetCurNavMeshPoint(instanceId)
    end
end

---@param instanceId any
function MapNavPathManager:GetCurNavMeshPointColor(instanceId, mapNavPathInstanceId)
    if self.mapNavPathDrawList[mapNavPathInstanceId] then
        return self.mapNavPathDrawList[mapNavPathInstanceId]:GetCurNavMeshPointColor(instanceId)
    end
end

function MapNavPathManager:_DrawGuideEffect(type, ...)
    local args = {...}

    --可以画线，new一个道路线的实例
    self.mapNavPathDrawInstanceId = self.mapNavPathDrawInstanceId + 1 
    self.mapNavPathDrawList[self.mapNavPathDrawInstanceId] = Fight.Instance.objectPool:Get(MapNavPathDraw)
    self.mapNavPathDrawList[self.mapNavPathDrawInstanceId]:Init(type, args, self.mapNavPathDrawInstanceId)

    return self.mapNavPathDrawInstanceId
end

--移除整个道路指引
function MapNavPathManager:_RemoveGuideEffect(instanceId)
    if not self.mapNavPathDrawList[instanceId] then
        return 
    end
    self.mapNavPathDrawList[instanceId]:OnCache()
    self.mapNavPathDrawList[instanceId] = nil
end

--移除所有指引
function MapNavPathManager:_RemoveGuideEffectAll()
    for i, v in pairs(self.mapNavPathDrawList) do
        v:OnCache()
    end
    TableUtils.ClearTable(self.mapNavPathDrawList)
end

--移除道路指引
function MapNavPathManager:_RemoveRoadGuideEffect(instanceId, mapNavPathInstanceId)
    if not self.mapNavPathDrawList[mapNavPathInstanceId] then
        return
    end
    
    self.mapNavPathDrawList[mapNavPathInstanceId]:_RemoveRoadGuideEffect(instanceId)
end

--移除navMesh指引
function MapNavPathManager:_RemoveNavMeshGuideEffect(instanceId, mapNavPathInstanceId)
    if not self.mapNavPathDrawList[mapNavPathInstanceId] then
        return
    end

    self.mapNavPathDrawList[mapNavPathInstanceId]:_RemoveNavMeshGuideEffect(instanceId)
end

function MapNavPathManager:__delete()
   self:_RemoveGuideEffectAll() 
end