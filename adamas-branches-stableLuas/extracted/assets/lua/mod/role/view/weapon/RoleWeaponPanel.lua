RoleWeaponPanel = BaseClass("RoleWeaponPanel", BasePanel)

local roleIndex = "RoleRoot"

local ButtonState = 
{
    Replace = 1,
    Equip = 2,
    Cur = 3,
}

function RoleWeaponPanel:__init()
    self:SetAsset("Prefabs/UI/Role/RoleWeaponPanel.prefab")
end

function RoleWeaponPanel:__delete()
    self.curWeapon:OnCache()
    self.previewCurWeapon:OnCache()
    self.previewTargetWeapon:OnCache()

    EventMgr.Instance:RemoveListener(EventName.RoleWeaponChange, self:ToFunc("WeaponChanged"))
    EventMgr.Instance:RemoveListener(EventName.WeaponInfoChange, self:ToFunc("WeaponInfoChange"))
    EventMgr.Instance:RemoveListener(EventName.ShowRoleModelLoad, self:ToFunc("ChangeRoleModel"))
    EventMgr.Instance:RemoveListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
end

function RoleWeaponPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.RoleWeaponChange, self:ToFunc("WeaponChanged"))
    EventMgr.Instance:AddListener(EventName.WeaponInfoChange, self:ToFunc("WeaponInfoChange"))
    EventMgr.Instance:AddListener(EventName.ShowRoleModelLoad, self:ToFunc("ChangeRoleModel"))
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
    
end

function RoleWeaponPanel:__BindListener()
    self.PowerUpButton_btn.onClick:AddListener(self:ToFunc("OpenWeaponWindow"))
    self.ReplaceBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ReplaceButton"))

    self.PreviewPowerUpButton_btn.onClick:AddListener(self:ToFunc("OpenWeaponWindow"))
    self.PreviewReplaceBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ReplaceButton"))

    self.ComparisonButton_btn.onClick:AddListener(function ()
        if self.showComparison then
            self:HideComparisonWeapon()
        else
            self:ShowComparisonWeapon()
        end
    end)
end

function RoleWeaponPanel:__Create()
    self.curWeapon = Fight.Instance.objectPool:Get(CommonWeaponInfo)
    self.previewCurWeapon = Fight.Instance.objectPool:Get(CommonWeaponInfo)
    self.previewTargetWeapon = Fight.Instance.objectPool:Get(CommonWeaponInfo)
    self.ComparisonAnim = self.BlurBG:GetComponent(UIAnimationSetting)
    UtilsUI.SetHideCallBack(self.ComparisonAnim.HideNode, self:ToFunc("ComparisonHideCallBack"))
    self.curWeapon:Init(self.CurWeaponInfo,self.args.uid)
    self.previewCurWeapon:Init(self.PreviewCurWeapon)
    self.previewTargetWeapon:Init(self.TargetWeapon)
end

function RoleWeaponPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end

function RoleWeaponPanel:__Show()
    self.uid = self.args.uid
    self:SetButtonState(ButtonState.Replace)
	--初始化显示
	if self:GetCurRole() then
        self:ChangeShowRole(self:GetCurRole())
		self:ChangeRoleModel(self:GetCurRole())
	end

    if self.uid then 
        UtilsUI.SetActiveByScale(self.ReplaceButton,false)
        UtilsUI.SetActiveByScale(self.PowerUpButton,false)
        UtilsUI.SetActiveByScale(self.PreviewButton,false)
        UtilsUI.SetActive(self.CenterLockButton,false)
    end
end

function RoleWeaponPanel:__ShowComplete()
    if self.args.uniqueId then
        self:OpenWeaponSelect(self.args.uniqueId)
    end
end

function RoleWeaponPanel:__Hide()
    local uniqueId = mod.RoleCtrl:GetRoleWeapon(self:GetCurRole(),self.uid)
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId, self:GetCurRole(),self.uid)
    --移除武器模型
    self:GetModelView():BindWeapon(roleIndex, weaponData.template_id, true)
    --恢复镜头
end

function RoleWeaponPanel:ChangeShowRole(roleId)
    if not self.active then
        return
    end
    self.cutMark = true
    --self.parentWindow:ClosePanel(ItemSelectPanel)
    -- local selectpanel = self.parentWindow:GetPanel(ItemSelectPanel)
    -- if selectpanel then
    --     selectpanel:PlayExitAnim()
    -- end
    self.cutMark = false
    self:SetButtonState(ButtonState.Replace)
    local uniqueId = mod.RoleCtrl:GetRoleWeapon(roleId,self.uid)
    self.curWeapon:ChangeUIDetail(uniqueId, roleId)

    self:UpdateCenterInfo(uniqueId, roleId)
end

function RoleWeaponPanel:UpdateCenterInfo(uniqueId, roleId)
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId,roleId,self.uid)
    local weaponId = weaponData.template_id
    local baseConfig = ItemConfig.GetItemConfig(weaponId)
    local typeConfig = RoleConfig.GetWeaponTypeConfig(baseConfig.type)

    self.CenterLockButton_btn.onClick:RemoveAllListeners()
    self.CenterLockButton_btn.onClick:AddListener(function ()
        mod.BagCtrl:SetItemLockState(uniqueId, not weaponData.is_locked, BagEnum.BagType.Weapon)
    end)

    self.CenterWeaponName_txt.text = baseConfig.name
    self.CenterTypeName_txt.text = typeConfig.type_name
    for i = 1, 5, 1 do
        if i == baseConfig.quality then
            UtilsUI.SetActiveByScale(self["CenterQuality"..i],true)
        else
            UtilsUI.SetActiveByScale(self["CenterQuality"..i],false)
        end
    end

    self.CenterUnLock:SetActive(not weaponData.is_locked)
    self.CenterIsLock:SetActive(weaponData.is_locked)

    if self.weaponSelectPanel then
        self.weaponSelectPanel:RefreshList()
    end
end



function RoleWeaponPanel:ChangeRoleModel(roleId)
    if not self.active then
        return
    end
    local uniqueId = mod.RoleCtrl:GetRoleWeapon(roleId,self.uid)
    self:ChangeModelDetail(uniqueId)
    local blurConfig = RoleConfig.GetRoleBlurConfig(self:GetCurRole(), RoleConfig.PageBlurType.Weapon)
    self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

function RoleWeaponPanel:ChangeModelDetail(uniqueId)
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId, self:GetCurRole(),self.uid)
        --设置镜头
        local callback = function ()
            local roleId = self:GetCurRole()
            self:SetCameraView(roleId, RoleConfig.PageCameraType.Weapon)
        end
    self:GetModelView():BindWeapon(roleIndex, weaponData.template_id, false, callback)
end

--交换复合按钮
function RoleWeaponPanel:OnClick_ReplaceButton()
    if self.buttonState == ButtonState.Replace then
        self:OpenWeaponSelect()
    elseif self.buttonState == ButtonState.Equip then
        self:ReplaceWeapon(self.curSelect)
    elseif self.buttonState == ButtonState.Cur then
        
    end
end
--打开武器选择
function RoleWeaponPanel:OpenWeaponSelect(uniqueId)
    self.ComparisonButton:SetActive(true)
    self.sortType = BagEnum.SortType.Quality
    local roleId = self:GetCurRole()
    local type = RoleConfig.GetRoleConfig(roleId).weapon_type
    local config =
    {
        width = 575,
        col = 3,
        bagType = BagEnum.BagType.Weapon,
        additionItem = {},
        secondType = type,
        onClick = self:ToFunc("SelectWeapon"),
        hideFunc = self:ToFunc("HideSelectFunc"),
        defaultSelect = uniqueId or mod.RoleCtrl:GetRoleWeapon(self:GetCurRole())
    }
    self.weaponSelectPanel = self.parentWindow:OpenPanel(ItemSelectPanel,{config = config})
    self:GetModelView():RecordCamera()
    self:SetCameraView(roleId, RoleConfig.PageCameraType.WeaponSelect)
end

function RoleWeaponPanel:SetCameraView(roleId, case)
    local cameraConfig = RoleConfig.GetRoleCameraConfig(roleId, case)
    self:GetModelView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    self:GetModelView():PlayModelAnim(roleIndex, cameraConfig.anim, 0.5)
    self:GetModelView():SetModelRotation(roleIndex,  cameraConfig.model_rotation)
end

--预览选择武器
function RoleWeaponPanel:SelectWeapon(uniqueId)
    if self.curSelect and self.curSelect == uniqueId then
        return
    end
    self.curSelect = uniqueId
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId)
    if uniqueId == mod.RoleCtrl:GetRoleWeapon(self:GetCurRole()) then
        self:SetButtonState(ButtonState.Cur)
        self.Equiped:SetActive(false)
    else
        self:SetButtonState(ButtonState.Equip)
        if weaponData.hero_id ~= 0 then
            self.Equiped:SetActive(true)
            self.EquipedTips_txt.text = string.format(TI18N("%s已装备"),RoleConfig.GetRoleConfig(weaponData.hero_id).name)
            local icon = RoleConfig.GetRoleConfig(weaponData.hero_id).rhead_icon
            SingleIconLoader.Load(self.Belong, icon)
        else
            UtilsUI.SetActive(self.Equiped,false)
        end
    end
    self.curWeapon:ChangeUIDetail(uniqueId)
    self:UpdateCenterInfo(uniqueId)
    LuaTimerManager.Instance:AddTimer(1,0, function ()
        self:GetModelView():BindWeapon(roleIndex, weaponData.template_id)
    end)
    self:ComparisonWeapon(uniqueId)
end

--关闭选择界面
function RoleWeaponPanel:HideSelectFunc()
    self:HideComparisonWeapon()
    local curSelect = self.curSelect
    self.curSelect = nil
    if self.cutMark then
        return
    end
    self.ComparisonButton:SetActive(false)
    self:SetButtonState(ButtonState.Replace)
    self:GetModelView():RecoverCamera()
    local uniqueId = mod.RoleCtrl:GetRoleWeapon(self:GetCurRole())
    if curSelect and curSelect == uniqueId then
        return
    end
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId, self:GetCurRole())
	
    LuaTimerManager.Instance:AddTimer(1,0, function ()
        self:GetModelView():BindWeapon(roleIndex, weaponData.template_id)
    end)

    if uniqueId == mod.RoleCtrl:GetRoleWeapon(self:GetCurRole()) then
        self.Equiped:SetActive(false)
    else
        if weaponData.hero_id ~= 0 then
            self.Equiped:SetActive(true)
            self.EquipedTips_txt.text = string.format(TI18N("%s已装备"),RoleConfig.GetRoleConfig(weaponData.hero_id).name)
            local icon = RoleConfig.GetRoleConfig(weaponData.hero_id).rhead_icon
            SingleIconLoader.Load(self.Belong, icon)
        else
            UtilsUI.SetActive(self.Equiped,false)
        end
    end
    self.curWeapon:ChangeUIDetail(uniqueId)
    self:UpdateCenterInfo(uniqueId)
end

--替换武器
function RoleWeaponPanel:ReplaceWeapon(uniqueId)
    if not uniqueId then
        return
    end

    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end

    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end

    local roleId = self:GetCurRole()
    mod.RoleCtrl:ReplaceWeapon(roleId, uniqueId)
end

--收到服务器修改武器
function RoleWeaponPanel:WeaponChanged(roleId, oldWeapon, newWeapon)
    if roleId ~= self:GetCurRole() then
        return
    end
    MsgBoxManager.Instance:ShowTips(TI18N("武器替换成功"))
    if self.buttonState == ButtonState.Equip then
        local curWeapon = mod.RoleCtrl:GetRoleWeapon(self:GetCurRole())
        if newWeapon == curWeapon then
            self:SetButtonState(ButtonState.Cur)
            self.Equiped:SetActive(false)
            self:UpdateWeaponTips(curWeapon)
        end
    end
    
end

function RoleWeaponPanel:WeaponInfoChange(oldItem, newItem)
    if self.curSelect and newItem.unique_id == self.curSelect then
        self:UpdateWeaponTips(self.curSelect)
    elseif mod.RoleCtrl:GetRoleWeapon(self:GetCurRole()) == newItem.unique_id then
        self:UpdateWeaponTips(newItem.unique_id)
    end
end

function RoleWeaponPanel:SetButtonState(state)
    self.buttonState = state
    UtilsUI.SetActive(self.ReplaceBtn, state ~= ButtonState.Cur)
    UtilsUI.SetActive(self.CurReplaceBtn, state == ButtonState.Cur)

    UtilsUI.SetActive(self.PreviewReplaceBtn, state ~= ButtonState.Cur)
    UtilsUI.SetActive(self.CurPreviewReplaceBtn, state == ButtonState.Cur)
    
    --如果是机器人的话，隐藏掉一系列按钮
    local roleId = self:GetCurRole()
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        UtilsUI.SetActive(self.ReplaceButton,false)
        UtilsUI.SetActive(self.PowerUpButton,false)
    else
        UtilsUI.SetActive(self.ReplaceButton,true)
        UtilsUI.SetActive(self.PowerUpButton,true)
    end
end

function RoleWeaponPanel:ShowComparisonWeapon()
    UtilsUI.SetActive(self.BlurBG,true)
    self.ComparisonAnim:PlayEnterAnimator()
    local img = self.BlurBG:GetComponent(RawImage)
    local onLoad = function (rt)
        img.enabled = true
        img.texture = rt
    end
    CustomUnityUtils.GetBlurScreenShot(onLoad, 1,  UIDefine.BlurBackCaptureType.Scene)
    self.showComparison = true
    self.ComparisonText_txt.text = TI18N("收起")
    if self.curSelect then
        self:ComparisonWeapon(self.curSelect)
    end
end

function RoleWeaponPanel:HideComparisonWeapon()
    self.ComparisonAnim:PlayExitAnimator()
    --UtilsUI.SetActive(self.BlurBG,false)
    local img = self.BlurBG:GetComponent(RawImage)
    img.enabled = false
    self.showComparison = false
    -- self.PreviewCurWeapon:SetActive(false)
    -- self.TargetWeapon:SetActive(false)
    -- self.PreviewButtonGroup:SetActive(false)
    self.ComparisonText_txt.text = TI18N("对比")
end

function RoleWeaponPanel:ComparisonHideCallBack()
    UtilsUI.SetActive(self.BlurBG,false)
end

function RoleWeaponPanel:ComparisonWeapon(uniqueId)
    if not self.showComparison then
        return
    end
    local curUniqueId = mod.RoleCtrl:GetRoleWeapon(self:GetCurRole())
    self.PreviewCurWeapon:SetActive(true)
    self.TargetWeapon:SetActive(true)
    self.PreviewButtonGroup:SetActive(true)
    self.previewCurWeapon:ChangeUIDetail(curUniqueId)
    self.previewTargetWeapon:ChangeUIDetail(uniqueId)
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId)
    if weaponData.hero_id ~= 0 then
        self.TargetEquiped:SetActive(true)
        self.TargetEquipedTips_txt.text = string.format(TI18N("%s已装备"),RoleConfig.GetRoleConfig(weaponData.hero_id).name)
        local icon = RoleConfig.GetRoleConfig(weaponData.hero_id).rhead_icon
        SingleIconLoader.Load(self.TargetBelong, icon)
    else
        self.TargetEquiped:SetActive(false)
    end
end

function RoleWeaponPanel:UpdateWeaponTips(uniqueId)
    self.curWeapon:ChangeUIDetail(uniqueId)
    self:UpdateCenterInfo(uniqueId)
    if self.showComparison then
        self.previewCurWeapon:ChangeUIDetail(mod.RoleCtrl:GetRoleWeapon(self:GetCurRole()))
        if self.curSelect then
            self.previewTargetWeapon:ChangeUIDetail(self.curSelect)
        end
    end
end

function RoleWeaponPanel:OpenWeaponWindow()
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.WeaponUpgrade)
    if not isOpen then
        MsgBoxManager.Instance:ShowTips(failDesc)
        return
    end
    local uniqueId = self.curSelect or mod.RoleCtrl:GetRoleWeapon(self:GetCurRole())
    local blurConfig = RoleConfig.GetRoleBlurConfig(self:GetCurRole(), RoleConfig.PageBlurType.WeaponUp)
    self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
    WeaponMainWindow.OpenWindow({uniqueId = uniqueId, powerUp = true})
end

function RoleWeaponPanel:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function RoleWeaponPanel:GetModelView()
    return Fight.Instance.modelViewMgr:GetView()
end

function RoleWeaponPanel:OnClose()
end