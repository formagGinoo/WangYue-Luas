-- 多资源加载
-- @author huangyq
AssetBatchLoader = BaseClass("AssetBatchLoader")

local Log = Log

AssetBatchLoader.UseLocalRes = false

function AssetBatchLoader:__init(name)
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

    self.isCancel = false
end

function AssetBatchLoader:__delete()
    if self.isLoading then
        self.isCancel =true
        -- print(debug.traceback())
        -- LogError("非法操作，资源正在加载中")
    end
    self.resPList = nil
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
    self.resList = nil

    for _, data in pairs(self.eventDict) do
        data:DeleteMe()
    end
    self.eventDict = nil
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

function AssetBatchLoader:LoadAll(list)
    self.resList = UtilsBase.copytab(list)
    for _, data in ipairs(self.resList) do
        self.resDict[data.path] = true
        if data.priority == nil then
            data.priority = 1
        end
        --
    end
    self.resPList = self:Grouping()
    if #self.resPList > 0 then
        self:LoadAssetByPriority()
    end
end

function AssetBatchLoader:LoadAssetByPriority()
    if #self.resPList > 0 then
        local pCell = self.resPList[1]
        table.remove(self.resPList, 1)
        self.isLoading = true
        for _, data in ipairs(pCell.list) do
            local cdata = data
            local holdTime = data.holdTime
            -- 设置默认值
            local loadType = AssetLoadType.BothAsync

            if holdTime == nil then
                -- 缓存时间默认30秒
                -- 这个时间是以引用数变为0时开始算
                holdTime = 5--30
            end
            if data.loadType ~= nil then
                loadType = data.loadType
            end

            if not data.type then
                if data.isSoundBank then
                    local cb = function()
                        self:OnSoundLoaded(data.path, cdata)
                    end
					
					local gameWwise = SoundManager.Instance:GetGameWwise()
                    gameWwise:LoadSoundBank(data.path, holdTime, true, cb)
                end
            elseif data.type == AssetType.Prefab then
                local cb = function(go)
                    self:OnGameObjectLoaded(go, cdata)
                end
                if AssetBatchLoader.UseLocalRes and ctx.Editor then
                    CS.EditorAssetLoad.GetGameObject(data.path, cb)
                else
                    AssetManager.GetGameObject(data.path, holdTime, cb, 5, loadType)
                end
                
            elseif data.type == AssetType.Object then
                local cb = function(go)
                    self:OnObjectLoaded(go, cdata)
                end
                if AssetBatchLoader.UseLocalRes and ctx.Editor then
                    CS.EditorAssetLoad.GetObject(data.path, cb)
                else
                    AssetManager.GetObject(data.path, holdTime, cb, 5, loadType)
                end
                
            elseif data.type == AssetType.Asset then
                local cb = function(path)
                    self:OnAssetLoaded(path, cdata)
                end
                if AssetBatchLoader.UseLocalRes and ctx.Editor then
                    CS.EditorAssetLoad.GetAsset(data.path, cb)
                else
                    AssetManager.GetAsset(data.path, holdTime, cb, 5, loadType)
                end
            end
        end
    end
end

function AssetBatchLoader:Grouping()
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
            self:DeleteMe()
            return
        end
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
            self:DeleteMe()
            return
        end
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
            self:DeleteMe()
            return
        end
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
            self:DeleteMe()
            return
        end
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
    if self.resDict[path] == nil then
        return false
    else
        return true
    end
end