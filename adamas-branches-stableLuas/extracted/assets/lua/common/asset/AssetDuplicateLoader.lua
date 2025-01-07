-- 多资源加载 允许重复资源, 使用该类要严格执行销毁方法
-- 推荐使用AssetBatchLoader, 有重复资源才使用这个类
-- 增加cacheType属性，用于判断资源是否可多次获取，但Loader必须DeleteMe()释放掉
-- @author huangyq
AssetDuplicateLoader = BaseClass("AssetDuplicateLoader")

function AssetDuplicateLoader:__init(name)
    self.name = name
    -- 优先级不同的使用分帧加载
    -- {{path, type, callback, priority, asset}}
    self.resList = {}
    self.resDict = {}

    -- 根据优先级分级的资源
    -- {{index = X, list = {}}}
    self.resPList ={{}}

    -- {priority, EventLib}
    self.eventDict = {}
    self.isLoading = false

    self.cacheType = AssetCacheType.None
end

function AssetDuplicateLoader:__delete()
    if self.isLoading then
        LogError("非法操作，资源正在加载中\r\n"..debug.traceback())
    end
    self.resPList = nil
    for _, data in ipairs(self.resList) do
        if data.asset ~= nil then
            AssetManager.DecreaseReferenceCount(data.path)
            if data.type == AssetType.Prefab then
                -- GameObject.DestroyImmediate(data.asset)
            end
        end
    end
    self.resList = nil

    for _, data in pairs(self.eventDict) do
        data:DeleteMe()
    end
    self.eventDict = nil
end

function AssetDuplicateLoader:SetCacheType(cType)
    self.cacheType = cType
end

function AssetDuplicateLoader:AddListener(callback, priority)
    if priority == nil then
        priority = 1
    end
    local event = self:GetEvent(priority)
    event:AddListener(callback)
end

function AssetDuplicateLoader:RemoveListener(callback, priority)
    if priority == nil then
        priority = 1
    end
    local event = self:GetEvent(priority)
    event:RemoListener(callback)
end

function AssetDuplicateLoader:LoadAll(list)
    self.resList = BaseUtils.copytab(list)
    for i, data in ipairs(self.resList) do
        self.resDict[data.path] = true
        if data.priority == nil then
            data.priority = 1
        end
    end
    self.resPList = self:Grouping()
    if #self.resPList > 0 then
        self:LoadAssetByPriority()
    else
        local event = self.eventDict[1]
        if event ~= nil then
            self.isLoading = false
            event:Fire()
        end
    end
end

function AssetDuplicateLoader:LoadAssetByPriority()
    if #self.resPList > 0 then
        local pCell = self.resPList[1]
        table.remove(self.resPList, 1)
        self.isLoading = true
        for _, data in ipairs(pCell.list) do
            local cdata = data
            local holdTime = data.holdTime
            if holdTime == nil then
                -- 缓存时间默认30秒
                -- 这个时间是以引用数变为0时开始算
                holdTime = 30
            end
            if data.type == AssetType.Prefab then
                local cb = function(go)
                    self:OnGameObjectLoaded(go, cdata)
                end
                AssetManager.GetGameObject(data.path, holdTime, cb, 5)
            elseif data.type == AssetType.Object then
                local cb = function(go)
                    self:OnObjectLoaded(go, cdata)
                end
                AssetManager.GetObject(data.path, holdTime, cb, 5)
            elseif data.type == AssetType.Asset then
                local cb = function(path)
                    self:OnAssetLoaded(path, cdata)
                end
                AssetManager.GetAsset(data.path, holdTime, cb, 5)
            else
                LogError("【非法资源类型】 path:" .. tostring(data.path) .. "  type:" .. tostring(data.type))
            end
        end
    end
end

function AssetDuplicateLoader:Grouping()
    local gDict = {}
    for _, data in ipairs(self.resList) do
        local gCell = gDict[data.priority]
        if gCell == nil then
            gCell = {index = data.priority, list = {}}
            gDict[data.priority] = gCell
        end
        table.insert(gCell.list, data)
    end
    local gList = {}
    for _, data in pairs(gDict) do
        table.insert(gList, data)
    end
    local sortfun = function(a,b)
        return a.index < b.index
    end
    table.sort(gList, sortfun)
    return gList
end

function AssetDuplicateLoader:OnGameObjectLoaded(obj, ldata)
    local completed = true
    if self.resList == nil then
        return
    end
    for _, data in ipairs(self.resList) do
        if data.path == ldata.path and data.asset == nil then
            data.asset = obj
            AssetManager.IncreaseReferenceCount(data.path)
            if data.callback ~= nil then
                data.callback(data.path)
            end
        elseif data.asset == nil and data.priority == ldata.priority then
            completed = false
        end
    end
    if completed then
        local event = self.eventDict[ldata.priority]
        if event ~= nil then
            self.isLoading = false
            event:Fire()
        end
    end
    if self.resList ~= nil and #self.resPList > 0 then
        self:LoadAssetByPriority()
    end
end

function AssetDuplicateLoader:OnObjectLoaded(obj, ldata)
    local completed = true
    if self.resList == nil then
        return
    end
    for _, data in ipairs(self.resList) do
        if data.path == ldata.path and data.asset == nil then
            data.asset = obj
            AssetManager.IncreaseReferenceCount(data.path)
            if data.callback ~= nil then
                data.callback(data.path)
            end
        elseif data.asset == nil and data.priority == ldata.priority then
            completed = false
        end
    end
    if completed then
        local event = self.eventDict[ldata.priority]
        if event ~= nil then
            self.isLoading = false
            event:Fire()
        end
    end
    if self.resList ~= nil and #self.resPList > 0 then
        self:LoadAssetByPriority()
    end
end

function AssetDuplicateLoader:OnAssetLoaded(path, ldata)
    local completed = true
    if self.resList == nil then
        return
    end
    for _, data in ipairs(self.resList) do
        if data.path == ldata.path and data.asset == nil then
            data.asset = path
            AssetManager.IncreaseReferenceCount(data.path)
            if data.callback ~= nil then
                data.callback(data.path)
            end
        elseif data.asset == nil and data.priority == ldata.priority then
            completed = false
        end
    end
    if completed then
        local event = self.eventDict[ldata.priority]
        if event ~= nil then
            self.isLoading = false
            event:Fire()
        end
    end
    if self.resList ~= nil and #self.resPList > 0 then
        self:LoadAssetByPriority()
    end
end

function AssetDuplicateLoader:GetEvent(priority)
    if priority == nil then
        LogError("call GetEvent Error: priority is nil")
    end
    local event = self.eventDict[priority]
    if event == nil then
        event = EventLib.New()
        self.eventDict[priority] = event
    end
    return event
end

-- 拿出资源
function AssetDuplicateLoader:Pop(path)
    if self.isLoading then
        LogError("非法操作，资源正在加载中不可拿出数据 \n\r" .. debug.traceback())
    end
    for _, data in ipairs(self.resList) do
        if data.path == path and data.asset ~= nil then
            local asset = data.asset
            if data.type == AssetType.Prefab then
                if BaseUtils.IsNull(asset) then
                    LogError("非法操作，资源已被取出，或资源为空".. data.path)
                end
                local gameObject = GameObject.Instantiate(asset)
                AssetManager.AddAssetAutoReleaser(gameObject, data.path)
                if self.cacheType ~= AssetCacheType.All and self.cacheType ~= AssetCacheType.Prefab then
                    AssetManager.DecreaseReferenceCount(path)
                    data.asset = nil
                end

                return gameObject
            else
                if self.cacheType ~= AssetCacheType.All and self.cacheType ~= AssetCacheType.Object then
                    AssetManager.DecreaseReferenceCount(path)
                    data.asset = nil
                end
                return asset
            end
        end
    end
end

function AssetDuplicateLoader:Contain(path)
    if self.resDict[path] == nil then
        return false
    else
        return true
    end
end
