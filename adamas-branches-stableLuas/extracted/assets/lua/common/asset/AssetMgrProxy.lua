-- C# AssetManager的代理，并提供一些资源管理额外的功能
-- 除了预设（GameObject）外，其它所有资源都不自动增加引用数
AssetMgrProxy = BaseClass("AssetMgrProxy",BaseManager)
local _string_format = string.format

function AssetMgrProxy:__init()
    if AssetMgrProxy.Instance then
        LogError("不可以对单例对象重复实例化")
    end
    AssetMgrProxy.Instance = self;

    self.loaderMap = {}
    self.loadDataQueue = FixedQueue.New()
    self.path2Loader = {}
    self.cacheLoaderList = {}
    self.useLoaderCount = 0
    self.curUseLoaderMap = {}
end

function AssetMgrProxy:__delete()
end

-- 增加引用数
function AssetMgrProxy:IncreaseReferenceCount(path)
    if AssetBatchLoader.UseLocalRes then
        return
    end
    AssetManager.IncreaseReferenceCount(path)
end

-- 减少引用数
function AssetMgrProxy:DecreaseReferenceCount(path)
    if AssetBatchLoader.UseLocalRes then
        return
    end
	AssetManager.DecreaseReferenceCount(path)
end

-- 设置Icon
function AssetMgrProxy:SetIcon(gameObject, sprite, path)
    local image = gameObject:GetComponent(Image)
    local autoReleaser = gameObject:GetComponent(IconAutoReleaser)
    if autoReleaser == nil then
        autoReleaser = gameObject:AddComponent(IconAutoReleaser)
    else
        if autoReleaser.path ~= nil and autoReleaser.path ~= "" then
            image.sprite = nil
            self:DecreaseReferenceCount(autoReleaser.path)
        end
    end
    image.sprite = nil
    autoReleaser.path = path
    self:IncreaseReferenceCount(path)
    image.sprite = sprite
end

-- 克隆统一用此方法
-- 同一资源对象需要两个或以上的使用该方法
-- 该方法针对挂上IAutoReleaser的对象，如果是UI预设中的某个节点且节点树中没有挂IAutoReleaser，还是可以使用GameObject.Instantiate方法
function AssetMgrProxy:CloneGameObject(gameObject)
    local go = GameObject.Instantiate(gameObject)
	if AssetBatchLoader.UseLocalRes and ctx.Editor then
	else
	    local releaser = go:GetComponentsInChildren(IAutoReleaser, true)
	    local length = releaser.Length
	    for i = 1, length do
	        releaser[i - 1]:OnClone()
	        --releaser[i]:OnClone()
	    end
	end
    return go
end

function AssetMgrProxy:ChangeSprite(gameObject, name)
    local image = gameObject:GetComponent(Image)
    local atlasPath = image.spriteKey
    local s, t = string.find(atlasPath, "folderSprite")
    local physicalPath = nil
    if s ~= nil then
        physicalPath = string.sub(atlasPath, 0, s + 5)
        local obj = AssetManager.GetSubObjectByPhysicalPath(physicalPath, name)
        if obj ~= nil then
            image.sprite = obj
        else
            LogError("ChangeSprite出错了，找不到subSprite信息:[" .. image.name .. ":" .. name .. "]")
        end
    else
        LogError("ChangeSprite出错了，找不到spriteKey信息:[" .. image.name .. ":" .. name .. "]")
    end
end

function AssetMgrProxy:DoUnloadUnusedAssets()
    ctx:DoUnloadUnusedAssets() -- 清理资源
end

function AssetMgrProxy.ToAssetPath(path)
    local targetPath = Application.streamingAssetsPath .. "/" .. path

    if ctx.Editor then
        targetPath = "file:///" .. ctx.EditorResPath .. "/" .. path
        return targetPath
    end

    if AssetManager.ExistLocalAsset(path) then
        if Application.platform == RuntimePlatform.Android then
            return AssetManager.LocalResPath .. "/" .. path
        else
            return "file:///" .. ctx.LocalResPath .. "/" .. path
        end
    else
        if Application.platform == RuntimePlatform.Android then
            return Application.dataPath .. "!assets/" .. path
        elseif Application.platform == RuntimePlatform.IPhonePlayer then
            return "file:///" .. Application.streamingAssetsPath .. "/" .. path
        else
             return "file:///" .. Application.streamingAssetsPath .. "/" .. path
        end
    end
end

function AssetMgrProxy.ConvertUrlToPath(url)
     if Application.platform == RuntimePlatform.Android then
         return url
     else
        return string.gsub(url,"file:///", "")
     end
end

--扩展一下，管理loader内容:分帧加载，减少委托创建
local AssetType = 
{
    Sound = 1,
    GameObject = 2,
    Object = 3,
    Asset = 4,
}

function AssetMgrProxy:AddLoader(index, loader)
    self.loaderMap[index] = loader
end

function AssetMgrProxy:RemoveLoader(index)
    self.loaderMap[index] = nil
end

function AssetMgrProxy:LoadSoundBank(index, path, holdTime, async)
    if not async then
        self:RecordPathMap(path, index)
        local gameWwise = SoundManager.Instance:GetGameWwise()
        gameWwise:LoadSoundBankByLua(path, holdTime, async, self:ToFunc("CellLoadDone"))
        return
    end
    local data = {
        assetType = AssetType.Sound,
        index = index,
        path = path,
        holdTime = holdTime,
        async = async,
    }
    self.loadDataQueue:Push(data)
end

function AssetMgrProxy:GetGameObject(index, path, holdTime, loadPriority, loadType)
    if loadType == AssetLoadType.BothSync then
        self:RecordPathMap(path, index)
        AssetManager.GetGameObject(path, holdTime, self:ToFunc("CellLoadDone"), loadPriority, loadType)
        return
    end
    local data = {
        assetType = AssetType.GameObject,
        index = index,
        path = path,
        holdTime = holdTime,
        loadPriority = loadPriority,
        loadType = loadType,
    }
    self.loadDataQueue:Push(data)
end

function AssetMgrProxy:GetObject(index, path, holdTime, loadPriority, loadType)
    if loadType == AssetLoadType.BothSync then
        self:RecordPathMap(path, index)
        AssetManager.GetObject(path, holdTime, self:ToFunc("CellLoadDone"), loadPriority, loadType)
        return
    end
    local data = {
        assetType = AssetType.Object,
        index = index,
        path = path,
        holdTime = holdTime,
        loadPriority = loadPriority,
        loadType = loadType,
    }
    self.loadDataQueue:Push(data)
end

function AssetMgrProxy:GetAsset(index, path, holdTime, loadPriority, loadType)
    if loadType == AssetLoadType.BothSync then
        self:RecordPathMap(path, index)
        AssetManager.GetAsset(path, holdTime, self:ToFunc("CellLoadDone"), loadPriority, loadType)
        return
    end
    local data = {
        assetType = AssetType.Asset,
        index = index,
        path = path,
        holdTime = holdTime,
        loadPriority = loadPriority,
        loadType = loadType,
    }
    self.loadDataQueue:Push(data)
end

AssetMgrProxy.MaxLoadCount = 20
function AssetMgrProxy:Update()
    local maxCount = AssetMgrProxy.MaxLoadCount
    local totalCount = self.loadDataQueue:Length()
    local notLimit = (LoadPanelManager.Instance:IsLoading() or CurtainManager.Instance:IsCurtain())
    if notLimit then
        maxCount = totalCount
    else
        maxCount = math.min(maxCount, totalCount)
    end
    for i = 1, maxCount, 1 do
        local data = self.loadDataQueue:Pop()
        if self.loaderMap[data.index] then
            self:RecordPathMap(data.path, data.index)
            if data.assetType == AssetType.Sound then
                local gameWwise = SoundManager.Instance:GetGameWwise()
                gameWwise:LoadSoundBankByLua(data.path, data.holdTime, data.async, self:ToFunc("CellLoadDone"))
            elseif data.assetType == AssetType.GameObject then
                AssetManager.GetGameObject(data.path, data.holdTime, self:ToFunc("CellLoadDone"), data.loadPriority, data.loadType)
            elseif data.assetType == AssetType.Object then
                AssetManager.GetObject(data.path, data.holdTime, self:ToFunc("CellLoadDone"), data.loadPriority, data.loadType)
            elseif data.assetType == AssetType.Asset then
                AssetManager.GetAsset(data.path, data.holdTime, self:ToFunc("CellLoadDone"), data.loadPriority, data.loadType)
            end
        end
    end
end

function AssetMgrProxy:CellLoadDone(path, object)
    for index, v in pairs(self.path2Loader[path]) do
        if self.loaderMap[index] then
            self.loaderMap[index]:CellLoadDone(path, object)
        else
            LogError(path)
        end
    end
    TableUtils.ClearTable(self.path2Loader[path])
end

function AssetMgrProxy:RecordPathMap(path, index)
    self.path2Loader[path] = self.path2Loader[path] or {}
    self.path2Loader[path][index] = true
end

function AssetMgrProxy:GetLoader(name)
    local loader
    if next(self.cacheLoaderList) then
        loader = table.remove(self.cacheLoaderList)
        loader:Init(name)
    else
        self.lastCreateName = name
        loader = AssetBatchLoader.New(name)
    end
    self.curUseLoaderMap[name] = self.curUseLoaderMap[name] or 0
    self.curUseLoaderMap[name] = self.curUseLoaderMap[name] + 1

    self.useLoaderCount = self.useLoaderCount + 1
    if self.useLoaderCount > 200 then
        Log("当前创建的AssetBatchLoader过多，请检查代码", self.useLoaderCount)
        self:PrintAllLoader()
    end

    return loader
end

function AssetMgrProxy:CacheLoader(loader)
    loader:OnCache()
    table.insert(self.cacheLoaderList, loader)
    self.useLoaderCount = self.useLoaderCount - 1
    local name = loader.name
    self.curUseLoaderMap[name] = self.curUseLoaderMap[name] - 1
end

function AssetMgrProxy:GetLastCreateName()
    return self.lastCreateName
end
--AssetMgrProxy.Instance:PrintAllLoader()
function AssetMgrProxy:PrintAllLoader()
    local tempTable = {}
    for k, v in pairs(self.curUseLoaderMap) do
        table.insert(tempTable, {name = k, count = v})
    end
    table.sort(tempTable, function(a, b)
        return a.count > b.count
    end)
    local res = {}
    for i, v in ipairs(tempTable) do
        table.insert(res, v.name .. ":" .. v.count)
    end
    Log("当前使用的数量：", self.useLoaderCount)
    LogTable("使用情况", res)
end