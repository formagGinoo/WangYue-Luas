-- 佩丛背包属性界面
PartnerBagAttrPanel = BaseClass("PartnerBagAttrPanel", BasePanel)


local UnActiveAlpha = Color(1, 1, 1, 0.3)
local ActiveAlpha = Color(1, 1, 1, 1)
local TextUnActiveAlpha = Color(0.92941, 0.92941,0.92941, 0.5)
local TextActiveAlpha = Color(0.92941, 0.92941,0.92941, 1)

function PartnerBagAttrPanel:__init(parent)
    self:SetAsset("Prefabs/UI/PartnerBag/PartnerBagAttrPanel.prefab")
    
    --ui 
    self.attrObjList = {}
end

--添加监听器
function PartnerBagAttrPanel:__BindListener()
    self.LockButton_btn.onClick:AddListener(self:ToFunc("OnClickLockBtn"))
    self.EquipButton_btn.onClick:AddListener(self:ToFunc("OnClick_ReplaceButton"))
    self.LevelUpButton_btn.onClick:AddListener(self:ToFunc("OnClick_Upgrade"))
    self.PreviewButton_btn.onClick:AddListener(self:ToFunc("UnlockSkillPreView"))
    self.AttributeDetailButton_btn.onClick:AddListener(self:ToFunc("OnClick_AttributeDetail"))
    
end

--缓存对象
function PartnerBagAttrPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function PartnerBagAttrPanel:__Create()
    
end

function PartnerBagAttrPanel:__delete()
    for i, v in pairs(self.attrObjList) do
        self:PushUITmpObject("AttrItem", v)
    end
    TableUtils.ClearTable(self.attrObjList)
end

function PartnerBagAttrPanel:__Hide()
    self.parentWindow:ClosePanel(self)
    self:SetActive(false)
end

function PartnerBagAttrPanel:__Show(args)
    --从父窗口获取当前选中的月灵的uniqueId
    self.uniqueId = args and args.uniqueId or self.args.uniqueId
    self:UpdateShow(self.uniqueId)
end

function PartnerBagAttrPanel:__ShowComplete()

end

--月灵信息变化
function PartnerBagAttrPanel:PartnerInfoChange(oldData, newData)
    if not self.active then
        return
    end
    if newData.unique_id ~= self.uniqueId then
        return
    end
    --更新右侧显示 
    self:UpdateShow(self.uniqueId)
end

-- roleList关闭
function PartnerBagAttrPanel:TipHideEvent(className)
    if className == "RoleListPanel" then
        -- 显示按钮
        UtilsUI.SetActive(self.EquipButton, true)
        UtilsUI.SetActive(self.LevelUpButton, true)
    end
end

function PartnerBagAttrPanel:UpdateShow(uniqueId)
    self:ShowUpdateTip(uniqueId)
    self:ShowAttrPage(uniqueId)
    self:ShowWorkState(uniqueId)
end

function PartnerBagAttrPanel:SetRedPoint(uniqueId)
    if uniqueId == 0 and mod.RoleCtrl:CheckPartnerRedPoint() then
        UtilsUI.SetActive(self.PartnerRedPoint,true)
    else
        UtilsUI.SetActive(self.PartnerRedPoint,false)
    end
end

function PartnerBagAttrPanel:ShowUpdateTip(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = ItemConfig.GetItemConfig(partnerId)
    local qualityConfig = RoleConfig.GetPartnerQualityConfig(partnerId)
    self.Name_txt.text = baseConfig.name
    self.CurLevel_txt.text = partnerData.lev

    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerData.template_id)
    self.LevelLimit_txt.text = maxLev
    if partnerData.lev == maxLev then
        if RoleConfig.GetPartnerLevelExp(partnerData.template_id, partnerData.lev + 1) then
            self.ProgressValue_img.fillAmount = 0
        else
            self.ProgressValue_img.fillAmount = 1
        end
    else
        local curExp = partnerData.exp
        local maxExp = RoleConfig.GetPartnerLevelExp(partnerData.template_id, partnerData.lev + 1)
        self.ProgressValue_img.fillAmount = curExp / maxExp
    end
    SingleIconLoader.Load(self.QualityBg, qualityConfig.icon)
    
    UtilsUI.SetActive(self.Locked, partnerData.is_locked)
    UtilsUI.SetActive(self.UnLock, not partnerData.is_locked)
end

function PartnerBagAttrPanel:GetAttrItemObj()
    local obj = self:PopUITmpObject("AttrItem")
    obj.objectTransform:SetParent(self.AttrContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

function PartnerBagAttrPanel:ShowAttrPage(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = RoleConfig.GetPartnerConfig(partnerId)
    local levelUp = RoleConfig.GetPartnerLevPlan(partnerId).plan
    local attrTable = RoleConfig.PartnerAttrShowList(self:GetCurRole()) or {}
    local showCount = #attrTable
    
    local bgActiveNum = 1
    local attrRes = RoleConfig.GetPartnerPlateAttr(partnerData)
    attrRes = RoleConfig.GetPartnerPassiveSkillAttr(partnerData, attrRes)
    local roleEntity
    local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
    for _, entity in pairs(entityList) do
        if entity.masterId == self:GetCurRole() then
            roleEntity = entity
            break
        end
    end
    
    for i = 1, showCount, 1 do
        local obj
        if not self.attrObjList[i] then
            obj = self:GetAttrItemObj()
            self.attrObjList[i] = obj
        else
            obj = self.attrObjList[i]
        end
        
        local attr = attrTable[i]
        local attrValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr) + (attrRes[attr] or 0)
        if attr >= 1 and attr <= 3 and roleEntity then
            local baseAttr = roleEntity.attrComponent:GetBaseValue(attr)
            local attrPercentValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr + 20) + (attrRes[attr + 20] or 0) / 10000
            attrValue = attrValue +  math.floor(baseAttr * attrPercentValue)
        end
        local isPerfectAttr  = RoleConfig.CheckPartnerPerfectAttr(self:GetCurRole(), attr)
        
        UtilsUI.SetActive(obj.NiceIcon, isPerfectAttr)
        local name, value = RoleConfig.GetShowAttr(attr, attrValue)
        obj.AttrValue_txt.text = value
        if attrValue == 0 then
            obj.AttrValue_txt.color = TextUnActiveAlpha
            obj.AttrIcon_img.color = UnActiveAlpha
        else
            obj.AttrValue_txt.color = TextActiveAlpha
            obj.AttrIcon_img.color = ActiveAlpha
        end
        UtilsUI.SetActive(obj.AttrIcon, false)
        SingleIconLoader.Load(obj.AttrIcon, RoleConfig.GetAttrConfig(attr).icon2,function()
            UtilsUI.SetActive(obj.AttrIcon, true)
        end)
        --self.AttrScroll_scroll.verticalScrollbar.value = 0
        UtilsUI.SetActive(obj.Bg, i == 4 * (bgActiveNum - 1) + 1)
        if i == 4 * (bgActiveNum - 1) + 1 then
            bgActiveNum = bgActiveNum + 1
        end
    end
end

function PartnerBagAttrPanel:ShowWorkState(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    --是否在工作 --todo
    local isWorked = false
    --是否已装备
    local isEquiped = partnerData.hero_id ~= 0
    if isWorked then

    end

    if isEquiped then
        local roleCfg = RoleConfig.GetRoleConfig(partnerData.hero_id)
        if roleCfg and roleCfg.rhead_icon ~= "" then
            SingleIconLoader.Load(self.equipedIcon, roleCfg.rhead_icon)
        end
        self.equipedDes_txt.text = roleCfg.name..TI18N("已装备")
    end
    UtilsUI.SetActive(self.worked, isWorked)
    UtilsUI.SetActive(self.equiped, isEquiped)
end

function PartnerBagAttrPanel:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function PartnerBagAttrPanel:GetRolePartner()
    local roleId = mod.RoleCtrl:GetCurUISelectRole()
    return mod.RoleCtrl:GetRolePartner(roleId,self.uid)
end

function PartnerBagAttrPanel:OnClick_Upgrade()
    WindowManager.Instance:OpenWindow(PartnerMainWindow, {noLoadScene = true, uniqueId = self.uniqueId, initTag = RoleConfig.PartnerPanelType.Level })
end

function PartnerBagAttrPanel:OnClick_AttributeDetail()
    PanelManager.Instance:OpenPanel(PartnerAttributeDetailPanel, {
        heroId = self:GetCurRole() ,
        uniqueId = self.uniqueId,
        uid = self.uid})
end

function PartnerBagAttrPanel:OnClick_OpenList()
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    local index
    if partnerData.hero_id ~= 0 then
        index = mod.RoleCtrl:GetIdIndex(partnerData.hero_id)
    end
   
    local config = {
        hideCurRole = true,
        submitBtnText = TI18N("前往替换"),
        curIndex = index,
        roleList = mod.RoleCtrl:GetRoleIdList(),
    }
    self.parentWindow:OpenPanel(RoleListPanel, config)
end

function PartnerBagAttrPanel:OnClickLockBtn()
    mod.PartnerBagCtrl:LockPartner(self.uniqueId)
end

function PartnerBagAttrPanel:OnClick_ReplaceButton()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end
    
    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end
    --打开 roleListPanel 
    self:OnClick_OpenList()
    -- 隐藏按钮
    UtilsUI.SetActive(self.EquipButton, false)
    UtilsUI.SetActive(self.LevelUpButton, false)
end

function PartnerBagAttrPanel:UnlockSkillPreView()
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    PanelManager.Instance:OpenPanel(PartnerSkillPreviewPanel, {
        uniqueId = self.uniqueId,
        partnerId = partnerData.template_id,
    })
end

function PartnerBagAttrPanel:OnClose()
    
end

function PartnerBagAttrPanel:GetModelView()
    return Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)
end

function PartnerBagAttrPanel:__BeforeExitAnim()
    
end

function PartnerBagAttrPanel:__AfterExitAnim()
    
end