-- 多资源加载
-- @author huangyq
AssetBatchLoader = BaseClass("AssetBatchLoader")

local Log = Log

AssetBatchLoader.UseLocalRes = PlayerPrefs.GetInt("UseLocalRes") > 0

local curIndex = 0
function AssetBatchLoader:__init(name)
    local lastCreateName = AssetMgrProxy.Instance:GetLastCreateName()
    if name ~= lastCreateName then
        LogError("请从对象池获取AssetBatchLoader，或者联系技术（纪龙）处理")
    end
    -- {{path, type, callback, priority, asset}}
    self.resList = {}
    self.resMap = {}
    -- {priority, EventLib}
    self.eventDict = {}
    self:Init(name)
end

function AssetBatchLoader:Init(name)
    self.name = name

    -- 优先级不同的使用分帧加载    self.isLoading = false
    self.isCancel = false
    self.defaultType = nil

    curIndex = curIndex + 1
    self.index = curIndex
    AssetMgrProxy.Instance:AddLoader(self.index, self)
end

function AssetBatchLoader:CacheMe()
    AssetMgrProxy.Instance:CacheLoader(self)
end

function AssetBatchLoader:OnCache()
    --LogError("AssetBatchLoader:OnCache", self.name)
    AssetMgrProxy.Instance:RemoveLoader(self.index)
    if self.isLoading then
        self.isCancel =true
        -- print(debug.traceback())
        -- LogError("非法操作，资源正在加载中")
    end
    for _, data in ipairs(self.resList) do
        if data.asset and data.type ~= AssetType.Unity then
            if AssetBatchLoader.UseLocalRes and ctx.Editor then
            else
                AssetManager.DecreaseReferenceCount(data.path)
            end
            if data.type == AssetType.Prefab then
                -- GameObject.DestroyImmediate(data.asset)
            end
        end
    end
    
    TableUtils.ClearTable(self.resList)

    for _, data in pairs(self.eventDict) do
        data:DeleteMe()
    end
    TableUtils.ClearTable(self.eventDict)
    TableUtils.ClearTable(self.resList)
    TableUtils.ClearTable(self.resMap)
end

function AssetBatchLoader:__delete()
    LogError("请将AssetBatchLoader放回对象池", self.name)
end

function AssetBatchLoader:AddListener(callback, priority)
    if priority == nil then
        priority = 1
    end
    local event = self:GetEvent(priority)
    event:AddListener(callback)
end

function AssetBatchLoader:RemoveListener(callback, priority)
    if priority == nil then
        priority = 1
    end
    local event = self:GetEvent(priority)
    event:RemoveListener(callback)
end

function AssetBatchLoader:SetLoadType(type)
    self.defaultType = type
end


function AssetBatchLoader:LoadAll(list)
    list = list or {}
    UtilsBase.copytab(list, self.resList)
    for _, data in ipairs(self.resList) do
        if data.priority == nil then
            data.priority = 1
        end
        self.resMap[data.path] = data
        --
    end
    self:Grouping()
    self.isLoading = true
    -- LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
    --     self:LoadAssetByPriority()
    -- end)
    self:LoadAssetByPriority()
end

function AssetBatchLoader:LoadAssetByPriority()
    for i = 1, #self.resList do
        local data = self.resList[i]
        local holdTime = data.holdTime
        -- 设置默认值
        local loadType = self.defaultType or AssetLoadType.BothAsync
        local loadPriority = self.defaultType == AssetLoadType.BothSync and AssetLoadPriority.High or AssetLoadPriority.Medium    

        if holdTime == nil then
            -- 缓存时间默认30秒, 这个时间是以引用数变为0时开始算
            holdTime = 5--30
        end
        if data.loadType ~= nil then
            loadType = data.loadType
        end

        if not data.type then
            if data.isSoundBank then
                local gameWwise = SoundManager.Instance:GetGameWwise()
                AssetMgrProxy.Instance:LoadSoundBank(self.index, data.path, holdTime, true)
                --gameWwise:LoadSoundBankByLua(data.path, holdTime, true, self:ToFunc("CellLoadDone"))
            end
        elseif data.type == AssetType.Prefab then
            if AssetBatchLoader.UseLocalRes and ctx.Editor then
                CS.EditorAssetLoad.GetGameObject(data.path, self:ToFunc("CellLoadDone"))
            else
                AssetMgrProxy.Instance:GetGameObject(self.index, data.path, holdTime, loadPriority, loadType)
                --AssetManager.GetGameObject(data.path, holdTime, self:ToFunc("CellLoadDone"), loadPriority, loadType)
            end
            
        elseif data.type == AssetType.Object then
            if AssetBatchLoader.UseLocalRes and ctx.Editor then
                CS.EditorAssetLoad.GetObject(data.path, self:ToFunc("CellLoadDone"))
            else
                AssetMgrProxy.Instance:GetObject(self.index, data.path, holdTime, loadPriority, loadType)
                --AssetManager.GetObject(data.path, holdTime, self:ToFunc("CellLoadDone"), loadPriority, loadType)
            end
        elseif data.type == AssetType.Asset then
            if AssetBatchLoader.UseLocalRes and ctx.Editor then
                CS.EditorAssetLoad.GetAsset(data.path, self:ToFunc("CellLoadDone"))
            else
                AssetMgrProxy.Instance:GetAsset(self.index, data.path, holdTime, loadPriority, loadType)
                --AssetManager.GetAsset(data.path, holdTime, self:ToFunc("CellLoadDone"), loadPriority, loadType)
            end
        end
    end
end

function AssetBatchLoader:CellLoadDone(path, object)
    local data = self.resMap[path]
    if not data.type then
        if data.isSoundBank then
            self:OnSoundLoaded(path, data)
        end
    elseif data.type == AssetType.Prefab then
        self:OnGameObjectLoaded(object, data)
    elseif data.type == AssetType.Object then
        self:OnObjectLoaded(object, data)
    elseif data.type == AssetType.Asset then
        self:OnAssetLoaded(path, data)
    end
end

function AssetBatchLoader:Grouping()
    table.sort(self.resList, function(a, b)
        return a.priority > b.priority
    end)
end

function AssetBatchLoader:OnGameObjectLoaded(obj, ldata)
    local completed = true
    if self.resList == nil then
        return
    end
    for _, data in ipairs(self.resList) do
        if data.path == ldata.path then
            data.asset = obj
            if AssetBatchLoader.UseLocalRes and ctx.Editor then
            else
                AssetManager.IncreaseReferenceCount(data.path)
            end
            if data.callback ~= nil then
                data.callback(data.path)
            end
        elseif data.asset == nil and data.priority == ldata.priority then
            completed = false
        end
    end
    if completed then
        if self.isCancel then
            self.isLoading = false
            self:CacheMe()
            return
        end
        local event = self.eventDict[ldata.priority]
        if event ~= nil then
            self.isLoading = false
            event:Fire()
        end
    end
end

function AssetBatchLoader:OnObjectLoaded(obj, ldata)
    local completed = true
    if self.resList == nil then
        return
    end
    for _, data in ipairs(self.resList) do
        if data.path == ldata.path then
            data.asset = obj
            if AssetBatchLoader.UseLocalRes and ctx.Editor then
            else
                AssetManager.IncreaseReferenceCount(data.path)
            end
            if data.callback ~= nil then
                data.callback(data.path)
            end
        elseif data.asset == nil and data.priority == ldata.priority then
            completed = false
        end
    end
    if completed then
        if self.isCancel then
            self.isLoading = false
            self:CacheMe()
            return
        end
        local event = self.eventDict[ldata.priority]
        if event ~= nil then
            self.isLoading = false
            event:Fire()
        end
    end
end

function AssetBatchLoader:OnAssetLoaded(path, ldata)
    local completed = true
    if self.resList == nil then
        return
    end
    for _, data in ipairs(self.resList) do
        if data.path == ldata.path then
            data.asset = path
            if AssetBatchLoader.UseLocalRes and ctx.Editor then
            else
                AssetManager.IncreaseReferenceCount(data.path)
            end
            if data.callback ~= nil then
                data.callback(data.path)
            end
        elseif data.asset == nil and data.priority == ldata.priority then
            completed = false
        end
    end
    if completed then
        if self.isCancel then
            self.isLoading = false
            self:CacheMe()
            return
        end
        local event = self.eventDict[ldata.priority]
        if event ~= nil then
            self.isLoading = false
            event:Fire()
        end
    end
end

function AssetBatchLoader:OnSoundLoaded(path, ldata)
   local completed = true
    if self.resList == nil then
        return
    end
    for _, data in ipairs(self.resList) do
        if data.path == ldata.path then
            data.asset = path
            if data.callback ~= nil then
                data.callback(data.path)
            end
        elseif data.asset == nil and data.priority == ldata.priority then
            completed = false
        end
    end
    if completed then
        if self.isCancel then
            self.isLoading = false
            self:CacheMe()
            return
        end
        local event = self.eventDict[ldata.priority]
        if event ~= nil then
            self.isLoading = false
            event:Fire()
        end
    end
end

function AssetBatchLoader:GetEvent(priority)
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
function AssetBatchLoader:Pop(path, parent)
    if self.isLoading then
        LogError("非法操作，资源正在加载中不可拿出数据"..path)
    end
    for _, data in ipairs(self.resList) do
        if data.path == path then
            if AssetBatchLoader.UseLocalRes and ctx.Editor then
            else
                AssetManager.DecreaseReferenceCount(path)
            end
            local asset = data.asset
            if data.type == AssetType.Prefab then
                if UtilsBase.IsNull(asset) then
                    LogError("非法操作，资源已被取出，或资源为空".. data.path)
                end
                local gameObject = GameObject.Instantiate(asset, parent)
                if AssetBatchLoader.UseLocalRes and ctx.Editor then
                else
                    AssetManager.AddAssetAutoReleaser(gameObject, data.path, true)
                end
                data.asset = nil
                return gameObject
            else
                data.asset = nil  --临时去掉，复制
                return asset
            end
        end
    end
end

function AssetBatchLoader:GetAssetType(path)
    for _, data in ipairs(self.resList) do
        if data.path == path then
            return data.type
        end
    end
end

function AssetBatchLoader:Contain(path)
    if self.resMap[path] == nil then
        return false
    else
        return true
    end
end