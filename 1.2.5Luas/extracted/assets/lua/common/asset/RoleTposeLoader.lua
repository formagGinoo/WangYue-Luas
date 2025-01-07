-- Role Loader
-- 所有角色创建使用此方法, 这里只包括身体和头(因为头跟身体不会独立显示)
-- @huangyq
RoleTposeLoader = BaseClass("RoleTposeLoader")

function RoleTposeLoader:__init(setting, callback)
    self.setting = setting
    self.callback = callback
    -- 是否中途取消
    self.cancel = false
    self.classes = setting.classes
    self.sex = setting.sex
    self.sexTxt = (self.sex == 1 and "male" or "female")
    self.looks = setting.looks 

    self.tpose = nil
    self.headTpose = nil

    self.assetLoader = nil

    -- 分包逻辑需要使用的内容
    self.resData = {
        classes = self.classes
        ,sex = self.sex

        ,bodyModelId = nil
        ,headModelId = nil

        ,bodyModelPath = ""
        ,headModelPath = ""

        ,bodySkinPath = ""
        ,headSkinPath = ""

        ,animationData = nil
        ,animationList = {}
    }

    for k, v in pairs(self.looks) do
        if v.looks_type == LooksType.Hair then
            if v.looks_val then
                -- FIX ME
                -- 头模型
                self.resData.headModelId = 50001
                self.resData.headModelPath = string.format("Unit/Role/PrefabHead/%s.prefab", self.resData.headModelId)
            end
            if v.looks_mod ~= 0 then
                -- 头贴图
                self.resData.headSkinPath = string.format("Unit/Role/SkinHead/%s.TGA", 5000101)
            end
        elseif v.looks_type == LooksType.Dress then
            if v.looks_val then
                -- 身体模型
                self.resData.bodyModelId = 51001
                self.resData.bodyModelPath = string.format("Unit/Role/Prefab/%s.prefab", self.resData.bodyModelId)
            end
            if v.looks_mod ~= 0 then
                self.resData.bodySkinPath = string.format("Unit/Role/Skin/%s.TGA", 5100101)
            end
        end
    end
    -- 应该取默认值
    if self.resData.headModelPath == "" then
        self.resData.headModelId = 50001
        self.resData.headModelPath = string.format("Unit/Role/PrefabHead/%s.prefab", self.resData.headModelId)
    end
    if self.resData.headSkinPath == "" then
        self.resData.headSkinPath = string.format("Unit/Role/SkinHead/%s.TGA", 5000101)
    end
    if self.resData.bodyModelPath == "" then
        self.resData.bodyModelId = 51001
        self.resData.bodyModelPath = string.format("Unit/Role/Prefab/%s.prefab", self.resData.bodyModelId)
    end
    if self.resData.bodySkinPath == "" then
        self.resData.bodySkinPath = string.format("Unit/Role/Skin/%s.TGA", 5100101)
    end
    self.resData.animationData = {list = {"stand1", "move1", "idle1", "10010", "10020"}}
    self.resData.animationName = { stand_id = 1, move_id = 1, idle_id = 1 }
    for _, animationId in ipairs(self.resData.animationData.list) do
        table.insert(self.resData.animationList, string.format("Unit/Role/Animation/%s.anim", animationId))
    end
end

function RoleTposeLoader:__delete()
    if self.assetLoader ~= nil then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
end

function RoleTposeLoader:Load()
    local resList = {
        {path = self.resData.bodyModelPath, type = AssetType.Prefab}
        ,{path = self.resData.bodySkinPath, type = AssetType.Object}
        ,{path = self.resData.headModelPath, type = AssetType.Prefab}
        ,{path = self.resData.headSkinPath, type = AssetType.Object}
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
    self.assetLoader = AssetBatchLoader.New("RoleTposeLoader[" .. self.resData.bodyModelId.. "]");
    self.assetLoader:AddListener(callback)
    self.assetLoader:LoadAll(resList)
end

function RoleTposeLoader:Cancel()
    self.cancel = true
end

function RoleTposeLoader:BuildTpose()
    if self.assetLoader == nil then
        return
    end
    self.tpose = self.assetLoader:Pop(self.resData.bodyModelPath)
    self.tpose:SetActive(false)
    self.tpose.name = "tpose"
    local autoReleaser = self.tpose:GetComponent(AssetAutoReleaser)
    local skin = self.assetLoader:Pop(self.resData.bodySkinPath)
    local meshNode = self.tpose.transform:Find(string.format("Mesh_%s", self.resData.bodyModelId))
    meshNode:GetComponent(Renderer).material.mainTexture = skin;
    AssetMgrProxy.Instance:IncreaseReferenceCount(self.resData.bodySkinPath)
    autoReleaser:Add(self.resData.bodySkinPath)

    self.headTpose = self.assetLoader:Pop(self.resData.headModelPath)
    self.headTpose:SetActive(false)
    self.headTpose.name = "HeadTpose"
    local headAutoReleaser = self.headTpose:GetComponent(AssetAutoReleaser)
    local headSkin = self.assetLoader:Pop(self.resData.headSkinPath)
    local headMeshNode = self.headTpose.transform:Find(string.format("Mesh_%s", self.resData.headModelId))
    headMeshNode:GetComponent(Renderer).material.mainTexture = headSkin;
    AssetMgrProxy.Instance:IncreaseReferenceCount(self.resData.headSkinPath)
    headAutoReleaser:Add(self.resData.headSkinPath)

    local animation = self.tpose:GetComponent(Animation)
    local clip = nil
    local defaultClip = "move1"
    for _, path in ipairs(self.resData.animationList) do
        clip = self.assetLoader:Pop(path)
        animation:AddClip(clip, clip.name)
        AssetMgrProxy.Instance:IncreaseReferenceCount(path)
        autoReleaser:Add(path)
    end
    self:bindHead()
    self.tpose:SetActive(true)
    self.headTpose:SetActive(true)
    animation:Play(defaultClip)
    if self.callback ~= nil then
        self.callback({tpose = self.tpose, animationData = self.resData.animationData, animationName = self.resData.animationName})
    end
    self.assetLoader:DeleteMe()
    self.assetLoader = nil
end

function RoleTposeLoader:bindHead()
    local path = UtilsBase.GetChildPath(self.tpose.transform, "Bip_Head")
    local mounter = self.tpose.transform:Find(path)
    local headTran = self.headTpose.transform
    headTran:SetParent(mounter)
    headTran.localPosition = Vector3(0, 0, 0)
    headTran.localScale = Vector3(1, 1, 1)
    headTran.localRotation = Quaternion.identity
    headTran:Rotate(Vector3(90, 0, 0))
end
