WeaponMainWindow = BaseClass("WeaponMainWindow", BaseWindow)

local previewScene = "Prefabs/Scene/SceneUI_01/SceneUI_01.prefab"
local weaponIndex = "WeaponRoot"

WeaponMainWindow.FuncIndex =
{
    WeapInfo = 1,
    PowerUp = 2,
    Refine = 3,
}


function WeaponMainWindow:__init()
    self:SetAsset("Prefabs/UI/Role/CommonMainWindow.prefab")
end

function WeaponMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.WeaponInfoChange, self:ToFunc("WeaponInfoChange"))
end

function WeaponMainWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn)
end

function WeaponMainWindow:__Create()
    Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Role)
end

function WeaponMainWindow:__delete()
    self:CacheCurrencyBar()
    EventMgr.Instance:RemoveListener(EventName.WeaponInfoChange, self:ToFunc("WeaponInfoChange"))
end

function WeaponMainWindow:__Hide()
    self.gameObject:SetActive(false)
    if self.hideView then
        Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Role)
    end
    if self.animTimer then
        LuaTimerManager.Instance:RemoveTimer(self.animTimer)
        self.animTimer = nil
    end
end

function WeaponMainWindow:__Show()
    self.gameObject:SetActive(true)
    self.uniqueId = self.args.uniqueId
    self.hideView = self.args.hideView
    if self.args.powerUp then
        if self:IsBreak(self.uniqueId) then
            self.curTag = RoleConfig.WeaponPowerUpType.Stage
        elseif self:IsUpgrade(self.uniqueId) then
            self.curTag = RoleConfig.WeaponPowerUpType.Level
        end
    end
    self:CreateModelView(self.uniqueId)
    self:CreatePanel()
    self:initCurrencyBar()
    if self.hideView then
        local blurConfig = RoleConfig.GetRoleBlurConfig(0, RoleConfig.PageBlurType.WeaponUp)
        self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture, 0)
    end
    
end

function WeaponMainWindow:CreateModelView(uniqueId)
    local weaponData = self:GetWeaponData(uniqueId)
    self:GetModelView():LoadScene(previewScene)
    self:GetModelView():LoadModel(weaponIndex, weaponData.template_id, function ()
        self:GetModelView():RecordCamera()
        --local defalutCamera = RoleConfig.GetWeaponCameraConfig(0)
        self:GetModelView():BlendToNewCamera({ x = -3.177, y = 1.15, z = 10.364 }, { x = 4, y = 175, z = 0 })
        local weaponCamera = RoleConfig.GetWeaponCameraConfig(weaponData.template_id)
        if weaponCamera then
            if weaponCamera.model_scale and next(weaponCamera.model_scale) then
                local config = weaponCamera.model_scale
                self:GetModelView():SetModelScale(weaponIndex, config[1], config[2], config[3])
            end
        end
        
        --加载完成开始旋转
        local modelRotation =  { x = 0, y = 0, z = 0 }
        self.animTimer = LuaTimerManager.Instance:AddTimer(0, 0.02, function ()
            local rotation = self:GetModelView():GetModelRotation(weaponIndex)
            if rotation then
                self.modelInitAngles = rotation.eulerAngles
                modelRotation.x = rotation.eulerAngles.x
                modelRotation.y = rotation.eulerAngles.y - 0.5
                modelRotation.z = rotation.eulerAngles.z
                self:GetModelView():SetModelRotation(weaponIndex, modelRotation)
            end
        end)
    end)
end

function WeaponMainWindow:WeaponInfoChange(oldWeapon, newWeapon)
    if oldWeapon.unique_id == self.uniqueId then
        if oldWeapon.stage ~= newWeapon.stage then
            local config =
            {
                oldStage = oldWeapon.stage,
                newStage = newWeapon.stage,
                oldLev = RoleConfig.GetStageConfig(oldWeapon.template_id, oldWeapon.stage).level_limit,
                newLev = RoleConfig.GetStageConfig(newWeapon.template_id, newWeapon.stage).level_limit,
                oldAttrTable = RoleConfig.GetWeaponBaseAttrs(oldWeapon.template_id, oldWeapon.lev, oldWeapon.stage),
                newAttrTable = RoleConfig.GetWeaponBaseAttrs(newWeapon.template_id, newWeapon.lev, newWeapon.stage)
            }
            EventMgr.Instance:Fire(EventName.AddSystemContent, BaseStageChangeTipPanel, {args = config})
            self.curTag = RoleConfig.WeaponPowerUpType.Level
            self:InitTag()
        elseif oldWeapon.lev ~= newWeapon.lev then
            local config =
            {
                oldLev = oldWeapon.lev,
                newLev = newWeapon.lev,
                oldAttrTable = RoleConfig.GetWeaponBaseAttrs(oldWeapon.template_id, oldWeapon.lev, oldWeapon.stage),
                newAttrTable = RoleConfig.GetWeaponBaseAttrs(newWeapon.template_id, newWeapon.lev, newWeapon.stage)
            }
            EventMgr.Instance:Fire(EventName.AddSystemContent, BaseLevChangeTipPanel, {args = config})
            if self:IsBreak(newWeapon.unique_id) then
                self.curTag = RoleConfig.WeaponPowerUpType.Stage
                self:InitTag()
            end
        elseif oldWeapon.refine ~= newWeapon.refine then
            local config =
            {
                id = newWeapon.template_id,
                refine = newWeapon.refine
            }
            PanelManager.Instance:OpenPanel(WeaponRefineTipPanel, config)
        end
        
        for key, value in pairs(self.panelList) do
            if value.active and value.WeaponInfoChange then
                value:WeaponInfoChange()
            end
        end
    end
end

function WeaponMainWindow:CreatePanel()
    local uniqueId = self.uniqueId
    local callback = function ()
        self:InitTag(uniqueId)
    end
    self:OpenPanel(CommonLeftTabPanel, {name = TI18N("武器"), name2 = "w u q i", tabList = RoleConfig.WeaponPowerUpToggleInfo, callback = callback, notDelay = true})
end

function WeaponMainWindow:InitTag(uniqueId)
    uniqueId = uniqueId or self.uniqueId
    self:GetPanel(CommonLeftTabPanel):ShowOption(RoleConfig.WeaponPowerUpType.Refine, self:CanRefine(uniqueId))
    self:GetPanel(CommonLeftTabPanel):ShowOption(RoleConfig.WeaponPowerUpType.Level, self:IsUpgrade(uniqueId))
    self:GetPanel(CommonLeftTabPanel):ShowOption(RoleConfig.WeaponPowerUpType.Stage, self:IsBreak(uniqueId))
    self:GetPanel(CommonLeftTabPanel):SelectType(self.curTag or RoleConfig.WeaponPowerUpType.Info)
    
end

function WeaponMainWindow:IsUpgrade(uniqueId)
    local weaponData = self:GetWeaponData(uniqueId)
    local levelLimit = self:GetWeaponlevelLimit(weaponData.template_id, weaponData.stage)
    if weaponData.lev < levelLimit then
        return true
    else
        return false
    end
end

function WeaponMainWindow:IsBreak(uniqueId)
    local weaponData = self:GetWeaponData(uniqueId)
    local levelLimit = self:GetWeaponlevelLimit(weaponData.template_id, weaponData.stage)
    if weaponData.lev == levelLimit then
        return true
    else
        return false
    end
end

function WeaponMainWindow:CanRefine(uniqueId)
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId)
    local refineConfig = RoleConfig.GetWeaponRefineConfig(weaponData.template_id, weaponData.refine)
    if refineConfig then
        return true
    else
        return false
    end
end

-- 初始化货币栏
function WeaponMainWindow:initCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.GoldCurrencyBar, 2)
end

-- 移除货币栏
function WeaponMainWindow:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end


function WeaponMainWindow:GetWeaponData(uniqueId)
    uniqueId = uniqueId or self.uniqueId
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId)
    return weaponData
end

function WeaponMainWindow:GetWeaponlevelLimit(weaponId, stage)
    return RoleConfig.GetStageConfig(weaponId, stage).level_limit
end

function WeaponMainWindow:GetModelView()
    return Fight.Instance.modelViewMgr:GetView()
end

function WeaponMainWindow:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function WeaponMainWindow:OnClick_Close()
    --WindowManager.Instance:CloseWindow(self)
    local blurConfig = RoleConfig.GetRoleBlurConfig(self:GetCurRole(), RoleConfig.PageBlurType.Weapon)
    self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
    self:GetModelView():RecoverCamera()
    self:GetModelView():ShowModel(weaponIndex, false)
    --self.CommonMainWindow_Exit:SetActive(true)
    for key, value in pairs(self.panelList) do
        if value.active and value.HideAnim then
            value:HideAnim()
        end
    end
end

function WeaponMainWindow:HideCallback()
    WindowManager.Instance:CloseWindow(self)
end

function WeaponMainWindow:__BeforeExitAnim()
    self:OnClick_Close()
end

function WeaponMainWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

function WeaponMainWindow.OpenWindow(args)
    Fight.Instance.modelViewMgr:GetView():LoadScene(previewScene,function ()
        WindowManager.Instance:OpenWindow(WeaponMainWindow,args)
    end)
end