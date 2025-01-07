-- Npc Loader,
-- 所有NPC的创建都通过这个方法
-- @huangyq
NpcTposeLoader = BaseClass("NpcTposeLoader")

function NpcTposeLoader:__init(setting, callback)
    self.setting = setting
    self.callback = callback
    self.assetLoader = nil
    -- 是否中途取消
    self.cancel = false
    self.tpose = nil

    -- 这个结构跟以后的分包时取代替资源有关系
    self.resData = {
        skinId = setting.skinId
        ,modelId = setting.modelId
        ,animationId = setting.animationId
        ,animationData = nil

        ,skinPath = ""
        ,modelPath = ""
        ,animationList = {}
    }

    -- @FIX ME: 这里从策划表里读取
    self.resData.animationData = {resId= 71006, list = {"1000", "2000", "move1", "stand1", "idle1"}}
    self.resData.animationName = { stand_id = 1, move_id = 1, idle_id = 1 }
    if self.resData.animationData == nil then
        LogError("缺少AnimationData信息(animation_data表)[animationId:" .. self.resData.animationId .. ", skinId:" .. self.resData.skinId .. " , modelId:" .. self.resData.modelId .. "]")
        return
    end
    self.resData.skinPath = string.format("Unit/Npc/Skin/%s.TGA", self.resData.skinId)
    self.resData.modelPath = string.format("Unit/Npc/Prefab/%s.prefab", self.resData.modelId)
    for _, animationId in ipairs(self.resData.animationData.list) do
        table.insert(self.resData.animationList, string.format("Unit/Npc/Animation/%s/%s.anim", self.resData.animationData.resId, animationId))
    end
end

function NpcTposeLoader:__delete()
    if self.tpose ~= nil then
        GameObject.DestroyImmediate(self.tpose)
        self.tpose = nil
    end
    if self.assetLoader ~= nil then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
end

function NpcTposeLoader:Load()
    local resList = {
        {path = self.resData.modelPath, type = AssetType.Prefab}
        ,{path = self.resData.skinPath, type = AssetType.Object}
    }
    for _, path in ipairs(self.resData.animationList) do
        table.insert(resList, {path = path, type = AssetType.Object})
    end
    local callback = function()
        if self.cancel then
            self.assetLoader:DeleteMe()
            self.assetLoader = nil
        else
            self:BuildTpose()
        end
    end
    self.assetLoader = AssetBatchLoader.New("NpcTposeLoader[" .. self.resData.modelId .. "]");
    self.assetLoader:AddListener(callback)
    self.assetLoader:LoadAll(resList)
end

function NpcTposeLoader:Cancel()
    self.cancel = true
end

function NpcTposeLoader:BuildTpose()
    if self.assetLoader == nil then
        return
    end
    self.tpose = self.assetLoader:Pop(self.resData.modelPath)
    self.tpose:SetActive(false)
    self.tpose.name = "tpose"
    local autoReleaser = self.tpose:GetComponent(AssetAutoReleaser)
    local skin = self.assetLoader:Pop(self.resData.skinPath)
    local meshNode = self.tpose.transform:Find(string.format("Mesh_%s", self.resData.modelId))
    meshNode:GetComponent(Renderer).material.mainTexture = skin;
    autoReleaser:Add(self.resData.skinPath)
    AssetMgrProxy.Instance:IncreaseReferenceCount(self.resData.skinPath)

    local animation = self.tpose:GetComponent(Animation)
    local clip = nil
    local defaultClip = "stand1"
    for _, path in ipairs(self.resData.animationList) do
        clip = self.assetLoader:Pop(path)
        animation:AddClip(clip, clip.name)
        autoReleaser:Add(path)
        AssetMgrProxy.Instance:IncreaseReferenceCount(path)
    end
    self.tpose:SetActive(true)
    animation:Play(defaultClip)
    if self.callback ~= nil then
        self.callback({tpose = self.tpose, animationData = self.resData.animationData, animationName = self.resData.animationName})
    end
    self.assetLoader:DeleteMe()
    self.assetLoader = nil
end

