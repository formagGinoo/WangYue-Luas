local previewLayer = 19
local ModelViewPrefab = "Prefabs/UI/Common/Model3DView.prefab"

local LoaderEnum = {
    Scene = 1,
    Model = 2,
    Weapon = 3,
    Asset = 4
}

---@class PluralModelView
PluralModelView = BaseClass("PluralModelView")

function PluralModelView:__init(fight)
    self.fight = fight
    self.loaderMap = {}
    self.modelMap = {}
    self.modelPathMap = {}
    self.ctrlMap = {}
    self.curScenePath = ""
    self.cameraInfo = {}
    self.curCameraConfig = nil
    self.DefaultMixTime = 0.5
end

function PluralModelView:LoadView(type,callBack)
    self.type = type
    if self.loaderMap[LoaderEnum.Asset] then
        if callBack then
            callBack()
        end
        return
    end

    local onLoad = function()
        self.modelRoot = self.loaderMap[LoaderEnum.Asset]:Pop(ModelViewPrefab)
        GameObject.DontDestroyOnLoad(self.modelRoot)
        self.sceneRoot = self.modelRoot.transform:Find("SceneRoot")
        self.cameraRoot = self.modelRoot.transform:Find("CameraRoot")
        self.camera_1 = self.cameraRoot:Find("RolePreviewCamera_1").gameObject
        self.camera_2 = self.cameraRoot:Find("RolePreviewCamera_2").gameObject

        local position = self.rootPosition
        if position then
            self.modelRoot.transform:SetPosition(position.x, position.y, position.z)
        else
            self.modelRoot.transform:SetPosition(1000, 1000 + self.type * 100, 0)
        end
        if callBack then
            callBack()
        end
    end

    self.loaderMap[LoaderEnum.Asset] = AssetBatchLoader.New("PluralModelView_Asset")
    self.loaderMap[LoaderEnum.Asset]:AddListener(onLoad)
    self.loaderMap[LoaderEnum.Asset]:LoadAll({
        { path = ModelViewPrefab, type = AssetType.Prefab },
    })
end

---comment 加载角色/武器/敌人/NPC模型,根据id段区分
---@param index any 模型索引(挂点)
---@param id number 角色/武器/敌人/NPC ID
---@param callBack function 加载完成回调
function PluralModelView:LoadModel(index, id, callBack)
    --LogError(id)
    index = index or "ModelRoot"

    if not self.loaderMap[LoaderEnum.Model] then
        self.loaderMap[LoaderEnum.Model] = {}
    end

    local resList = {}
    --武器角色都能用
    local path, ctrlPath, hideNodes = ItemConfig:GetPreviewModel(id)
    local type = ItemConfig.GetItemType(id)
    table.insert(resList, {path = path, type = AssetType.Prefab})
    if ctrlPath and ctrlPath ~= "" then
        --TODO 先多缓存一段时间
        table.insert(resList, {path = ctrlPath, type = AssetType.Object, holdTime = 99999999})
    end

    local onLoad = function()
        self.modelMap[index] = self.fight.clientFight.assetsPool:Get(path)
        self.modelPathMap[index] = self.modelPathMap[index] or {}
        self.modelPathMap[index].path = path
        CustomUnityUtils.SetLayerRecursively(self.modelMap[index], previewLayer)
        if type == BagEnum.BagType.Role then
            CustomUnityUtils.SetShadowRenderers(self.modelMap[index])
        end

        if ctrlPath and ctrlPath ~= "" then
            local animatorController = self.fight.clientFight.assetsPool:Get(ctrlPath)
            local animator = self.modelMap[index]:GetComponentInChildren(Animator)
            animator.applyRootMotion = false
            animator.runtimeAnimatorController = animatorController
            self.modelPathMap[index].ctrlPath = ctrlPath
        else
            self.modelPathMap[index].ctrlPath = nil
        end

        local tf = self:GetTargetTransform(index)
        if tf then
            self:InitModelPosition(self.modelMap[index], tf)
        end
        if type == BagEnum.BagType.Partner then
            local config = ItemConfig.GetItemConfig(id)
            UnityUtils.SetLocalScale(self.modelMap[index].transform, config.model_scale,config.model_scale,config.model_scale)
        end

        self.hideNodes = hideNodes
        if hideNodes and next(hideNodes) then
            for _, value in pairs(hideNodes) do
                local weapon = self.modelMap[index].transform:Find(value)
                if weapon then
                    weapon:SetActive(false)
                end
            end
        end

        if callBack then
            callBack()
        end
        CurtainManager.Instance:ExitWait()
    end

    if self.modelMap[index] then
        if self.modelPathMap[index].ctrlPath then
            local animator = self.modelMap[index]:GetComponentInChildren(Animator)
            local animatorController = animator.runtimeAnimatorController
            self:CacheObj(self.modelPathMap[index].ctrlPath, animatorController)
        end
        self:CacheObj(self.modelPathMap[index].path, self.modelMap[index], true)
        self.modelPathMap[index] = nil
        self.modelMap[index] = nil
    end

    if self.loaderMap[LoaderEnum.Model][index] then
		self.fight.clientFight.assetsNodeManager:UnLoadOther(self.loaderMap[LoaderEnum.Model][index])
    end
    self.loaderMap[LoaderEnum.Model][index] = string.format("PluralModelView_Model_%s_%s", index,self:GetUniqueId())
    CurtainManager.Instance:EnterWait()
	self.fight.clientFight.assetsNodeManager:LoadOther(self.loaderMap[LoaderEnum.Model][index], resList, onLoad)
end

function PluralModelView:ShowModel(index, isShow)
    index = index or "ModelRoot"
    if self.modelMap[index] then
        self.modelMap[index]:SetActive(isShow or false)
    end
end

function PluralModelView:ShowModelRoot(index, isShow)
    index = index or "ModelRoot"
    local tf = self:GetTargetTransform(index)
    tf:SetActive(isShow or false)
end

function PluralModelView:LoadScene(path, callBack)
    if self.curScenePath == path then
        if callBack then
            callBack()
        end
		return
    end
	self.curScenePath = path
    local onLoad = function()
        local obj = self.fight.clientFight.assetsPool:Get(path)
        obj.name = path
        if self.sceneRoot then
            obj.transform:SetParent(self.sceneRoot)
            obj.transform:ResetAttr()
            if self.sceneObj then
                self:CacheObj(self.sceneObj.name, self.sceneObj, true)
            end
            self.sceneObj = obj
        end
        if callBack then
            callBack()
        end
    end
    local resList = {{path = path, type = AssetType.Prefab}}
    if self.loaderMap[LoaderEnum.Scene] then
		self.fight.clientFight.assetsNodeManager:UnLoadOther(self.loaderMap[LoaderEnum.Scene])
    end
    self.loaderMap[LoaderEnum.Scene] = string.format("PluralModelView_Scene_%s", self:GetUniqueId())
	self.fight.clientFight.assetsNodeManager:LoadOther(self.loaderMap[LoaderEnum.Scene], resList, onLoad)
end

function PluralModelView:BindWeapon(index, weaponId, isHide, callBack)
    if self.modelMap[index] and weaponId then
        local bindTransform = self.modelMap[index]:GetComponent(BindTransform)
        local bindConfig = RoleConfig.GetWeaponAsset(weaponId)
        local resList = {}
		local resMap = {}
        for i = 1 , #bindConfig do
        local tf = bindTransform:GetTransform(bindConfig[i][1])
            local hideNodes = self.hideNodes or {}
            if hideNodes and next(hideNodes) then
                for _, value in pairs(hideNodes) do
                    local weapon = self.modelMap[index].transform:Find(value)
                    if weapon then
                        weapon:SetActive(not isHide)
                    end
                end
            end

            if tf.childCount > 0 then
                for j = tf.childCount, 1, -1 do
                    local go = tf:GetChild(j - 1).gameObject
                    if self.fight.clientFight.assetsPool:Contain(go.name) then
                        self:CacheObj(go.name, go, true)
                    else
                        GameObject.Destroy(go)
                    end
                end
            end
			local path = bindConfig[i][2]
			if not isHide and not resMap[path] then
				resMap[path] = true
				table.insert(resList, {path = path, type = AssetType.Prefab})
			end
        end

        if isHide then
			CustomUnityUtils.SetShadowRenderers(self.modelMap[index])

            if callBack then
                callBack()
            end
            return
        end

        local onLoad = function ()
            for i = 1, #bindConfig do
                local tf = bindTransform:GetTransform(bindConfig[i][1])
                tf.parent:SetActive(true)
                local go = self.fight.clientFight.assetsPool:Get(bindConfig[i][2])
                go.name = bindConfig[i][2]
                go.transform:SetParent(tf)
                go.transform:ResetAttr()
            end
            CustomUnityUtils.SetShadowRenderers(self.modelMap[index])
            if callBack then
                callBack()
            end
            CurtainManager.Instance:ExitWait()
        end

        if self.loaderMap[LoaderEnum.Weapon] then
			self.fight.clientFight.assetsNodeManager:UnLoadOther(self.loaderMap[LoaderEnum.Weapon])
        end
        self.loaderMap[LoaderEnum.Weapon] = string.format("PluralModelView_Weapon_%s_%s", index, self:GetUniqueId())
        CurtainManager.Instance:EnterWait()
		self.fight.clientFight.assetsNodeManager:LoadOther(self.loaderMap[LoaderEnum.Weapon], resList, onLoad)
    else
        Log(string.format("索引[%s]没有展示的模型或者已被删除", index))
    end
end

function PluralModelView:InitModelPosition(model, parent)
    parent = parent or self.sceneRoot
    --UnityUtils.SetLocalEulerAngles(parent, 0,0,0)
    --parent:ResetAttr()
    --TODO 目前只有角色预览需要这个方法
    CustomUnityUtils.ResetLightMovementTarget(parent or self.sceneObj.transform)
    --Log("InitModelPosition")
    model.transform:SetParent(parent)
    model.transform:ResetAttr()
end

function PluralModelView:SetCameraSettings(position, rotation, fov)
    local curCamera = self.camera_1.activeSelf and self.camera_1 or self.camera_2
    local pos = curCamera.transform.localPosition
    UnityUtils.SetLocalPosition(curCamera.transform, position.x or pos.x, position.y or pos.y, position.z or pos.z)
    UnityUtils.SetLocalEulerAngles(curCamera.transform, rotation.x or 0, rotation.y or 0, rotation.z or 0)
    if fov then
        local cam = curCamera:GetComponent(Cinemachine.CinemachineVirtualCamera)
        local lens = cam.m_Lens
        lens.FieldOfView = fov
        cam.m_Lens = lens
    end
end

function PluralModelView:BlendToNewCamera(position, rotation, fov)
    self.curCameraConfig = {px = position.x, py = position.y, pz = position.z, rx = rotation.x, ry = rotation.y, rz = rotation.z, fov = fov}
    local curCamera
    local readyCamera
    if self.camera_1.activeSelf then
        curCamera = self.camera_1
        readyCamera = self.camera_2
    else
        curCamera = self.camera_2
        readyCamera = self.camera_1
    end

    local pos = curCamera.transform.localPosition
    local tf = readyCamera.transform
    UnityUtils.SetLocalPosition(tf, position.x or pos.x, position.y or pos.y, position.z or pos.z)
    UnityUtils.SetLocalEulerAngles(tf, rotation.x or 0, rotation.y or 0, rotation.z or 0)
    if fov then
        local cam = readyCamera:GetComponent(Cinemachine.CinemachineVirtualCamera)
        local lens = cam.m_Lens
        lens.FieldOfView = fov
        cam.m_Lens = lens
    end

    readyCamera:SetActive(true)
    curCamera:SetActive(false)
end

--记录相机设置
function PluralModelView:RecordCamera()
    if self.curCameraConfig and next(self.curCameraConfig) then
        local config = self.curCameraConfig
        table.insert(self.cameraInfo, config)
    end
end
--还原相机配置
function PluralModelView:RecoverCamera()
    if self.cameraInfo and next(self.cameraInfo) then
        local config = table.remove(self.cameraInfo)
        self:BlendToNewCamera(Vec3.New(config.px, config.py, config.pz), Vec3.New(config.rx, config.ry, config.rz), config.fov)
    end
end
--重置相机栈
function PluralModelView:ResetCameraStack()
    self.cameraInfo = {}
end

function PluralModelView:HideView(onlyHide)
    self.isActive = false
    self.modelRoot:SetActive(false)
    if onlyHide then
        return
    end
    if Fight.Instance then
        local player = Fight.Instance.playerManager:GetPlayer()
        local entity = player:GetCtrlEntityObject()
        if entity then
            CustomUnityUtils.SetCameraVolumeTrigger(entity.clientEntity.clientTransformComponent.transform, FightEnum.CameraTriggerLayer)
        end
    end
    for key, value in pairs(self.modelMap) do
        if self.modelPathMap[key].ctrlPath then
            local animator = self.modelMap[key]:GetComponentInChildren(Animator)
            local animatorController = animator.runtimeAnimatorController
            self:CacheObj(self.modelPathMap[key].ctrlPath, animatorController)
        end
        self:CacheObj(self.modelPathMap[key].path, self.modelMap[key], true)
    end
    for index, value in pairs(self.loaderMap[LoaderEnum.Model]) do
        if self.loaderMap[LoaderEnum.Model][index] then
            self.fight.clientFight.assetsNodeManager:UnLoadOther(self.loaderMap[LoaderEnum.Model][index])
        end
    end

    TableUtils.ClearTable(self.loaderMap[LoaderEnum.Model])
    TableUtils.ClearTable(self.modelPathMap)
    TableUtils.ClearTable(self.modelMap)
    self:ResetCameraStack()
    --主动刷新相机,不然会有一帧闪烁
    CameraManager.Instance.cinemachineBrain:ManualUpdate()
    
    self.CameraSettingTimer = LuaTimerManager.Instance:AddTimer(1, 0.5, function()
        CameraManager.Instance:SetInheritPosition(FightEnum.CameraState.Operating, true)
    end)
end

function PluralModelView:ShowView()
    if self.CameraSettingTimer then
        LuaTimerManager.Instance:RemoveTimer(self.CameraSettingTimer)
    end
    CameraManager.Instance:SetInheritPosition(FightEnum.CameraState.Operating, false)
    self.isActive = true
    self.modelRoot:SetActive(true)

    if Fight.Instance then
        CustomUnityUtils.SetCameraVolumeTrigger(self.modelRoot.transform, FightEnum.CameraTriggerLayer)
    end
end

function PluralModelView:SetRootPosition(x, y, z)
    self.rootPosition = {x = x, y = y, z = z}
    if self.modelRoot then
        self.modelRoot.transform:SetPosition(x or 0, y or 0, z or 0)
    end
end

function PluralModelView:SetScenePosition(x, y, z)
    if self.sceneRoot then
        UnityUtils.SetLocalPosition(self.sceneRoot, x, y, z)
    end
end

function PluralModelView:PlayModelAnim(index, animName, mixTime)
    local tf = self.modelMap[index]
    mixTime = mixTime or self.DefaultMixTime
    if tf then
        local animator = tf:GetComponentInChildren(Animator)
        if animator and not UtilsBase.IsNull(animator) then
            animator:CrossFadeInFixedTime(animName, mixTime, -1, 0)
        end
    end
end

function PluralModelView:SetDepthOfFieldBoken(isOpen, focusDistance, focalLength, aperture, duration)
    if self.sceneObj then
        CustomUnityUtils.SetDepthOfFieldBoken(self.sceneObj, isOpen, focusDistance, focalLength, aperture, duration or 0.4)
    end
end

function PluralModelView:SetDepthOfFieldGaussian(isOpen)
    if self.sceneObj then
        CustomUnityUtils.SetDepthOfFieldGaussian(self.sceneObj, isOpen)
    end
end

function PluralModelView:GetTargetTransform(index)
    if self.sceneObj then
        local tf = self.sceneObj.transform:GetChild(0):Find(index)
        return tf
    end
end

function PluralModelView:__delete()
    for key, value in pairs(self.modelMap) do
        if self.modelPathMap[key].ctrlPath then
            local animator = self.modelMap[key]:GetComponentInChildren(Animator)
            local animatorController = animator.runtimeAnimatorController
            self:CacheObj(self.modelPathMap[key].ctrlPath, animatorController)
        end
        self:CacheObj(self.modelPathMap[key], self.modelMap[key], true)
        self.modelMap[key] = nil
    end

    for index, value in pairs(self.loaderMap) do
        if index == LoaderEnum.Asset then
            value:DeleteMe()
        end
    end

    if self.modelRoot then
        GameObject.Destroy(self.modelRoot)
    end
end


---@param index any 模型索引(挂点)
function PluralModelView:SetModelRotation(index, rotation)
    index = index or "ModelRoot"
    if self.modelMap[index] then
        UnityUtils.SetLocalEulerAngles(self.modelMap[index].transform, rotation.x or 0, rotation.y or 0, rotation.z or 0)
    end
end

function PluralModelView:SetModelRootRotation(index, rotation)
    index = index or "ModelRoot"
    local tf = self:GetTargetTransform(index)
    UnityUtils.SetLocalEulerAngles(tf, rotation.x or 0, rotation.y or 0, rotation.z or 0)
end

---@param index any 模型索引(挂点)
function PluralModelView:GetModelRotation(index)
    index = index or "ModelRoot"
    if self.modelMap[index] then
        return self.modelMap[index].transform.rotation
    end
end

function PluralModelView:SetModelScale(index, x, y, z)
    if self.modelMap[index] then
        UnityUtils.SetLocalScale(self.modelMap[index].transform, x or 0, y or 0, z or 0)
    end
end

local uniqueId = 1
function PluralModelView:GetUniqueId()
    uniqueId = uniqueId + 1
    return uniqueId
end

function PluralModelView:CacheObj(path, obj, isObj)
    if isObj then
        UnityUtils.SetLocalScale(obj.transform, 1, 1, 1)
    end
    self.fight.clientFight.assetsPool:Cache(path, obj)
end