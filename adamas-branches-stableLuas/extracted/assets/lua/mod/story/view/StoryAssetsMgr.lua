StoryAssetsMgr = SingleClass("StoryAssetsMgr")
StoryAssetsMgr.CameraInfo = {}
function StoryAssetsMgr:__init(story)
    self.story = story
    self:LoadRoot()
    self.timelineMap = {}
end

function StoryAssetsMgr:StopLoading()
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
end

function StoryAssetsMgr:IsLoading()
    if self.assetLoader then
        return self.assetLoader.isLoading
    end
end

local loadList = {}
function StoryAssetsMgr:LoadStory(id, callback)
    self:StopLoading()
    self.curStory = id
    local tempTable = TableUtils.CopyTable(StoryConfig.GetAddRelevanceId(id)) or {}
    table.insert(tempTable, id)
    TableUtils.ClearTable(loadList)
    for _, storyId in pairs(tempTable) do
        for _, fileId in pairs(StoryConfig.GetRelevanceId(storyId)) do
            if not self.timelineMap[fileId] then
                local path = StoryConfig.GetStoryFilePath(fileId)
                if Fight.Instance.clientFight.assetsPool:Contain(path) then
                    local obj = Fight.Instance.clientFight.assetsPool:Get(path)
                    self:TryAddCacheObj(fileId, storyId, obj)
                else
                    table.insert(loadList, {path = path, type = AssetType.Prefab, _fileId = fileId, _storyId = storyId})
                end
            end
        end
    end

    local loadDone = function ()
        for _, info in pairs(loadList) do
            local obj = self.assetLoader:Pop(info.path)
            self:TryAddCacheObj(info._fileId, info._storyId, obj)
        end
        if callback then
            callback()
        end
    end

    if next(loadList) then
        self.assetLoader = AssetMgrProxy.Instance:GetLoader("StoryLoader_")
        self.assetLoader:AddListener(loadDone)
        self.assetLoader:LoadAll(loadList)
    elseif callback then
        callback()
    end
end

function StoryAssetsMgr:TryAddCacheObj(fileId, storyId, obj)
    return UtilsBase.TryCatch(self.AddCacheObj, self, fileId, storyId, obj)
end

function StoryAssetsMgr:AddCacheObj(fileId, storyId, obj)
    self.timelineMap[fileId] = {obj = obj, storyId = storyId}
    local tf = obj.transform
    tf:SetParent(self.cacheRoot)
    obj:SetActive(true)
    local config = StoryConfig.GetStoryConfig(storyId)
    if config.position then
        local dupId, dupLevelId = mod.WorldMapCtrl:GetDuplicateInfo()
        local tfConfig = mod.WorldMapCtrl:GetMapPositionConfig(dupLevelId, config.position[2], config.position[1])
        if tfConfig then
            UnityUtils.SetPosition(tf, tfConfig.X, tfConfig.Y, tfConfig.Z)
            UnityUtils.SetRotation(tf, tfConfig.rotX, tfConfig.rotY, tfConfig.rotZ, tfConfig.rotW)
        end
    end
    tf:ResetAttr()
    CustomUnityUtils.SetAnimatorStateByTimelineObject(obj, true)
end

function StoryAssetsMgr:GetCameraType(storyId)
    if StoryAssetsMgr.CameraInfo[storyId] then
        return StoryAssetsMgr.CameraInfo[storyId]
    end

    for fileId, value in pairs(self.timelineMap) do
        if value.storyId == storyId and value.obj:GetComponentInChildren(CinemachineVirtualCamera, true) then
            StoryAssetsMgr.CameraInfo[storyId] = StoryConfig.CameraType.Animation
            return StoryConfig.CameraType.Animation
        end
    end

    StoryAssetsMgr.CameraInfo[storyId] = StoryConfig.CameraType.Entity
    return StoryConfig.CameraType.Entity
end

function StoryAssetsMgr:RemoveCacheObj()
    for fileId, value in pairs(self.timelineMap) do
        if fileId == self.curFile then
            self.timelineMap[self.curFile].obj.transform:SetParent(self.cacheRoot)
            self.curFile = nil
        end
    end
    
end

function StoryAssetsMgr:DeleteAsset()
    self.curFile = nil
    for fileId, _ in pairs(self.timelineMap) do
        local path = StoryConfig.GetStoryFilePath(fileId)
        local obj = self.timelineMap[fileId].obj
        if Fight.Instance and Fight.Instance.clientFight.assetsPool:Contain(path) then
            Fight.Instance.clientFight.assetsPool:Cache(path, obj)
        else
            GameObject.DestroyImmediate(obj)
        end
    end
    TableUtils.ClearTable(self.timelineMap)
end

function StoryAssetsMgr:GetTimelineFile(fileId)
    if self.curFile then
        if self.timelineMap[self.curFile] then
            self.timelineMap[self.curFile].obj.transform:SetParent(self.cacheRoot)
        else
            LogErrorf("上一次使用的文件不存在：%s，但尝试控制它, 当前文件：%s", self.curFile, fileId)
        end
    end
    self.curFile = fileId
    if not self.timelineMap[fileId] then
        return LogErrorf("尝试开始剧情%s，但是它未被预加载", fileId)
    end
    return self.timelineMap[fileId].obj
end

function StoryAssetsMgr:LoadRoot()
    local ObjectPath = "Prefabs/UI/Story/AssetCache.prefab"
    local loader = AssetMgrProxy.Instance:GetLoader("StoryAssetsMgr")
    local resList = {{path = ObjectPath, type = AssetType.Prefab}}
    loader:AddListener(function ()
        local gameObject = loader:Pop(ObjectPath)
        self:InitRoot(gameObject)
        AssetMgrProxy.Instance:CacheLoader(loader)
    end)
    loader:LoadAll(resList)
end

function StoryAssetsMgr:InitRoot(gameObject)
    local tf = gameObject.transform
    tf:SetActive(false)
    tf:SetParent(self.story.root.transform)
    self.cacheRoot = tf
    self.objRoot = tf:Find("Other")

    self.originalObjMap = {}
    self.objCacheMap = {}
    for k, v in pairs(StoryConfig.ObjType) do
        self.originalObjMap[v] = self.objRoot:Find(v).gameObject
        self.objCacheMap[v] = {}
    end
end

function StoryAssetsMgr:PopObj(type)
    if next(self.objCacheMap[type]) then
        return table.remove(self.objCacheMap[type], 1)
    end
    local obj = self.originalObjMap[type]
    local objInfo = {}
    objInfo.object = GameObject.Instantiate(obj)
    objInfo.objectTransform = objInfo.object.transform
    if objInfo.object:GetComponent(UIContainer) then
        UtilsUI.GetContainerObject(objInfo.object, objInfo)
    end
    return objInfo
end

function StoryAssetsMgr:PushObj(type, obj)
    obj.objectTransform:SetParent(self.objRoot)
    table.insert(self.objCacheMap[type], obj)
end