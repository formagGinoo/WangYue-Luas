--local DataWeapon = Config.DataWeapon.data_weapon
--local DataWeaponAsset = Config.DataWeapon.data_weapon_asset
local DataHeroMain = Config.DataHeroMain.Find
local DataHeroModel = Config.DataUiModel.data_ui_model
local ModelCount = 0
local previewLayer = 19
local ModelViewPrefab = "Prefabs/UI/Common/Model3DView.prefab"
local DefaultScene = "Prefabs/UI/Common/DefaultModelScene.prefab"

local LoaderEnum = {
    Scene = 1,
    Character = 2,
    Weapon = 3,
    Asset = 4
}

---@class Model3DView
Model3DView = BaseClass("Model3DView")

function Model3DView:__init(parent, dragImage, scenePath, callBack)
    self.parent = parent
    self.dragImage = dragImage
    self.scenePath = scenePath
    self.cameraMap = {}
    self.loaderMap = {}
    self:LoadView(callBack)
end

function Model3DView:LoadView(callBack)
    if self.loaderMap[LoaderEnum.Asset] then
        return
    end

    local onLoad = function()
        ModelCount = ModelCount + 1
        self:Create()
        if callBack then
            callBack()
        end
    end

    self.loaderMap[LoaderEnum.Asset] = AssetBatchLoader.New("Model3DView"..ModelCount)
    self.loaderMap[LoaderEnum.Asset]:AddListener(onLoad)
    self.loaderMap[LoaderEnum.Asset]:LoadAll({
        {path = ModelViewPrefab, type = AssetType.Prefab},
        {path = self.scenePath or DefaultScene, type = AssetType.Prefab}
    })
end

function Model3DView:Create()
    self.modelRoot = self.loaderMap[LoaderEnum.Asset]:Pop(ModelViewPrefab)
    GameObject.DontDestroyOnLoad(self.modelRoot)
    self.sceneRoot = self.modelRoot.transform:Find("SceneRoot")
    self.sceneObj = self.loaderMap[LoaderEnum.Asset]:Pop(self.scenePath or DefaultScene)
    self.sceneObj.transform:SetParent(self.sceneRoot)
    if self.rootPosition then
        self.modelRoot.transform:SetPosition(self.rootPosition.x, self.rootPosition.y, self.rootPosition.z)
    else
        self.modelRoot.transform:SetPosition(1000 + (ModelCount * 10) % 1000, 1000, 0)
    end

    self.roleRoot = self.sceneObj.transform:GetChild(0):Find("RoleRoot")
	self.cameraRoot = self.modelRoot.transform:Find("CameraRoot")
    self.defaultCamera = self.cameraRoot:Find("RolePreviewCamera").gameObject
    if self.dragImage then
        local dragBehaviour = self.dragImage:AddComponent(UIDragBehaviour)
        dragBehaviour.onDrag = function(data)
            self.roleRoot.transform:Rotate(0, -0.45 * data.delta.x, 0)
        end
    end

    if self.showModel then
        self:InitModelPosition(self.showModel)
    end

    if self.settings then
        local tf = self.defaultCamera.transform
        local settings = self.settings
        UnityUtils.SetLocalPosition(tf, settings.px or 0, settings.py or 0, settings.pz or 0)
        UnityUtils.SetLocalEulerAngles(tf, settings.rx or 0, settings.ry or 0, settings.rz or 0)
        if settings.fov then
            local cam = self.defaultCamera:GetComponent(Cinemachine.CinemachineVirtualCamera)
            local lens = cam.m_Lens
            lens.FieldOfView = settings.fov
            cam.m_Lens = lens
        end
    end
    if self.sceneSetPosition then
        UnityUtils.SetLocalPosition(self.sceneRoot, self.sceneSetPosition.x,self.sceneSetPosition.y,self.sceneSetPosition.z)
    end
end

---comment 加载角色/武器/敌人/NPC模型,根据id段区分
---@param id number 角色/武器/敌人/NPC ID
---@param callBack function 加载完成回调
function Model3DView:ShowCharacter(id, callBack)
    if self.showModel then
        GameObject.Destroy(self.showModel)
        self.showModel = nil
    end

    if self.loaderMap[LoaderEnum.Character] then
        self.loaderMap[LoaderEnum.Character]:DeleteMe()
        self.loaderMap[LoaderEnum.Character] = nil
    end
    local path = DataHeroModel[DataHeroMain[id].ui_model].model_path
    local ctlPath = DataHeroModel[DataHeroMain[id].ui_model].ui_controller_path
    local onLoad = function()
        self.showModel = self.loaderMap[LoaderEnum.Character]:Pop(path)
        local bindTransform = self.showModel:GetComponent(BindTransform)
        --TODO 临时写死武器节点
        if bindTransform then
            if bindTransform:GetTransform("Bip001Prop1") then
                bindTransform:GetTransform("Bip001Prop1"):SetActive(false)
            end
            if bindTransform:GetTransform("Bip001Prop2") then
                bindTransform:GetTransform("Bip001Prop2"):SetActive(false)
            elseif bindTransform:GetTransform("Root") then
                bindTransform:GetTransform("Root"):SetActive(false)
            end
        end
        CustomUnityUtils.SetLayerRecursively(self.showModel, previewLayer)
        if self.roleRoot then
            self:InitModelPosition(self.showModel)
        end
        if callBack then
            callBack()
        end
    end
    local resList = {
        {path = path, type = AssetType.Prefab},
        {path = ctlPath, type = AssetType.Prefab},
    }   

    self.loaderMap[LoaderEnum.Character] = AssetBatchLoader.New("Model3DView"..id)
    self.loaderMap[LoaderEnum.Character]:AddListener(onLoad)
    self.loaderMap[LoaderEnum.Character]:LoadAll(resList)
end

function Model3DView:BindWeapon(weaponId, isDelete, callBack)
    if self.showModel then
        local bindTransform = self.showModel:GetComponent(BindTransform)
        --local bindConfig = DataWeaponAsset[DataWeapon[weaponId].asset_id]
        local resList = {}
        if bindTransform and bindConfig then
            for key, value in pairs(bindConfig) do
                local tf = bindTransform.GetTransform(value[1])
                if tf.childCount > 0 then
                    for i = tf.childCount, 1, -1 do
                        GameObject.Destroy(tf.GetChild(i).gameObject)
                    end
                end
                table.insert(resList, value[2])
            end
        end
        local onLoad = function ()
            for key, value in pairs(bindConfig) do
                local tf = bindTransform.GetTransform(value[1])
                local go = self.loaderMap[LoaderEnum.Weapon]:Pop(value[2])
                go.transform:SetParent(tf)
                go.transform:ResetAttr()
            end
            if callBack then
                callBack()
            end
        end

        if next(resList) and not isDelete then
            if self.loaderMap[LoaderEnum.Weapon] then
                self.loaderMap[LoaderEnum.Weapon]:DeleteMe()
                self.loaderMap[LoaderEnum.Weapon] = nil
            end
            self.loaderMap[LoaderEnum.Weapon] = AssetBatchLoader.New("Model3DView"..weaponId)
            self.loaderMap[LoaderEnum.Weapon]:AddListener(onLoad)
            self.loaderMap[LoaderEnum.Weapon]:LoadAll(resList)
        elseif callBack then
            callBack()
        end
    else
        LogError(string.format("当前没有展示的模型"))
    end
    
end

function Model3DView:LoadSence(path, callBack)
    if self.loaderMap[LoaderEnum.Scene] then
        self.loaderMap[LoaderEnum.Scene]:DeleteMe()
        self.loaderMap[LoaderEnum.Scene] = nil
    end
    local onLoad = function ()
        local obj = self.loaderMap[LoaderEnum.Scene]:Pop(path)
        if self.sceneRoot then
            obj.transform:SetParent(self.sceneRoot)
            obj.transform:ResetAttr()
            self.roleRoot = obj.transform:GetChild(0):Find("RoleRoot")
            if self.showModel then
                self:InitModelPosition(self.showModel, obj)
            end
            if self.sceneObj then
                GameObject.DestroyImmediate(self.sceneObj)
            end
            self.sceneObj = obj
        end
        if callBack then
            callBack()
        end
    end

    self.loaderMap[LoaderEnum.Scene] = AssetBatchLoader.New("Model3DView"..path)
    self.loaderMap[LoaderEnum.Scene]:AddListener(onLoad)
    self.loaderMap[LoaderEnum.Scene]:LoadAll({{path = path, type = AssetType.Prefab}})
end

function Model3DView:InitModelPosition(model, parent)
    self.roleRoot:ResetAttr()
    --TODO 目前只有角色预览需要这个方法
    CustomUnityUtils.ResetLightMovementTarget(parent or self.sceneObj.transform)
    model.transform:SetParent(self.roleRoot)
    model.transform:ResetAttr()
    if self.roleAnimName then
        local animator = model:GetComponentInChildren(Animator)
        animator:Play(self.roleAnimName)
    end
end

function Model3DView:SetCameraSetings(px,py,pz,rx,ry,rz,fov)
    if not self.settings then
        self.settings = {px = px, py = py, pz = pz, rx = rx,ry = ry,rz = rz, fov = fov}
    end
    if self.defaultCamera then
        UnityUtils.SetLocalPosition(self.defaultCamera.transform, px or 0,py or 0,pz or 0)
        UnityUtils.SetLocalEulerAngles(self.defaultCamera.transform, rx or 0,ry or 0,rz or 0)
        if fov then
            local cam = self.defaultCamera:GetComponent(Cinemachine.CinemachineVirtualCamera)
            local lens = cam.m_Lens
            lens.FieldOfView = fov
            cam.m_Lens = lens
        end
    end
end

function Model3DView:SetCustomCameraSettings(index,px,py,pz,rx,ry,rz,fov)
    if self.cameraRoot then
        if not self.cameraMap[index] then
            Log(string.format("索引为%s的相机还未创建,已自动创建", index))
            self:ShowCustomCamera(index)
        end
        local pos = self.cameraMap[index].transform.localPosition
        local tf = self.cameraMap[index].transform
        UnityUtils.SetLocalPosition(tf, px or pos.x, py or pos.y, pz or pos.z)
        UnityUtils.SetLocalEulerAngles(tf, rx or 0, ry or 0, rz or 0)
        if fov then
            local cam = self.cameraMap[index]:GetComponent(Cinemachine.CinemachineVirtualCamera)
            local lens = cam.m_Lens
            lens.FieldOfView = fov
            cam.m_Lens = lens
        end
    end
end

function Model3DView:ShowCustomCamera(index, isShow)
    if self.cameraRoot then
        if not self.cameraMap[index] then
            local obj = GameObject.Instantiate(self.defaultCamera)
            obj.name = "CustomCamera_"..index
            obj.transform:SetParent(self.cameraRoot)
            obj.transform.position = self.defaultCamera.transform.position
            obj.transform.rotation = self.defaultCamera.transform.rotation
            self.cameraMap[index] = obj
        end
        for k, v in pairs(self.cameraMap) do
            self.cameraMap[k]:SetActive(false)
        end
        self.cameraMap[index]:SetActive(isShow or false)
        self.defaultCamera:SetActive(not isShow)
    end
end

function Model3DView:SetRootPosition(x,y,z)
    self.rootPosition = Vec3.New(x or 0,y or 0,z or 0)
    if self.modelRoot then
        self.modelRoot.transform:SetPosition(x or 0,y or 0,z or 0)
    end
end

function Model3DView:SetScenePosition(x,y,z)
    if not self.sceneSetPosition then
        self.sceneSetPosition = Vec3.New(x, y, z)
    end
    if self.sceneRoot then
        UnityUtils.SetLocalPosition(self.sceneRoot, x,y,z)
    end
end

function Model3DView:PlayRoleAnim(animName)
    self.roleAnimName = animName or self.roleAnimName

    if self.roleRoot then
        local animator = self.roleRoot:GetComponentInChildren(Animator)
        if not animator and not UtilsBase.IsNull(animator) then
            animator:Play(self.roleAnimName)
        end
    end
end

function Model3DView:__delete()

    if self.showModel then
        GameObject.Destroy(self.showModel)
    end

    for key, value in pairs(self.loaderMap) do
        self.loaderMap[key]:DeleteMe()
        self.loaderMap[key] = nil
    end
    
    if self.modelRoot then
        GameObject.Destroy(self.modelRoot)
    end
end
