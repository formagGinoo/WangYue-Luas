RoleAttributePanel = BaseClass("RoleAttributePanel", BasePanel)

local AttrType = EntityAttrsConfig.AttrType
local Attr2AttrPercent = EntityAttrsConfig.Attr2AttrPercent
local AttrPercent2Attr = EntityAttrsConfig.AttrPercent2Attr
local AttrGroupType = FightEnum.AttrGroupType
local AttrType2MaxType = EntityAttrsConfig.AttrType2MaxType

local DataItem = Config.DataItem.data_item
local DataAttrsDefine = Config.DataAttrsDefine.Find
local DataHeroAttrShow = Config.DataHeroAttrShow.Find
local DataHeroMain = Config.DataHeroMain.Find
local DataHeroLevUpgrade = Config.DataHeroLevUpgrade.Find

--初始化
function RoleAttributePanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleAttributePanel.prefab")
    self.BeforeData = nil
    self.curRoleInfo = nil
    self.StageLvObjList = {}
end

--添加监听器
function RoleAttributePanel:__BindListener()
    self.PreviewButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenStageUpPreviewPanel"))
    self.AttributeDetailButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenRoleAttributeDetailPanel"))
    self.FashionButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenFashionPanel"))
    self.LevelUpButton_1_btn.onClick:AddListener(self:ToFunc("OnClick_OpenRoleUpgradeWindow"))
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("UpdateData"))
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("onRoleInfoUpdate"))
    EventMgr.Instance:AddListener(EventName.ShowRoleModelLoad, self:ToFunc("OnRoleModelLoad"))
end

--缓存对象
function RoleAttributePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end
--
function RoleAttributePanel:__Create()

end

function RoleAttributePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeShowRole, self:ToFunc("UpdateData"))
    EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("onRoleInfoUpdate"))
    EventMgr.Instance:RemoveListener(EventName.ShowRoleModelLoad, self:ToFunc("OnRoleModelLoad"))
end

function RoleAttributePanel:__Hide()
    self.parentWindow:ShieldDrag(false)
end

function RoleAttributePanel:__ShowComplete()
    self.parentWindow:ShieldDrag(true)
    self:UpdateData(mod.RoleCtrl:GetCurUISelectRole())
    self:OnRoleModelLoad(self.heroId)
    Fight.Instance.modelViewMgr:GetView():SetDepthOfFieldBoken(true, 5, 100, 4)
    
end

function RoleAttributePanel:ShowUpDateTip()

end

function RoleAttributePanel:UpdateData(heroId)
    if self.heroId ~= heroId then
        self.heroId = heroId
        self.curRoleInfo = mod.RoleCtrl:GetRoleData(heroId)
        self.curLevelLimit = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)].limit_hero_lev
        self:UpdateShow()
    end
end

function RoleAttributePanel:onRoleInfoUpdate(idx, roleData)
    if self.heroId ~= roleData.id then
        return
    end
    self.curRoleInfo = roleData
    self.curLevelLimit = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)].limit_hero_lev
    self:UpdateShow()
end

function RoleAttributePanel:UpdateShow()
    ---@type Entity
    local roleEntity
    local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
    for _, entity in pairs(entityList) do
        if entity.masterId == self.heroId then
            roleEntity = entity
            break
        end
    end
    ---角色名
    self.RoleName_txt.text = DataHeroMain[self.heroId].name
    self.ADAMASName_txt.text = DataHeroMain[self.heroId].pinyin
    ---突破和经验
    SingleIconLoader.Load(self.Mai, "Textures/Icon/Single/StageIcon/" .. self.curRoleInfo.stage .. ".png")
    self.CurLevel_txt.text = self.curRoleInfo.lev
    self.curLimitLevel = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)].limit_hero_lev
    self.LevelLimit_txt.text = "/" .. self.curLimitLevel
    local nextLevelConfig = DataHeroLevUpgrade[self.curRoleInfo.lev + 1]
    local explorePercent = nextLevelConfig and self.curRoleInfo.exp / nextLevelConfig.need_exp or 1
    UnityUtils.SetSizeDelata(self.ExploreValueBar.transform, explorePercent * 233, 8)
    self.ExploreLight:SetActive(explorePercent > 0.1)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.CurLevel.transform.parent)

    local baseAttrs = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curRoleInfo.lev)
    local stageAttrs = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.curRoleInfo.stage)
    ---展示属性
    local roleIndex = 1
    for i, attrInfo in ipairs(DataHeroAttrShow) do
        if attrInfo.is_show_out == 1 then
            local nodes = UtilsUI.GetContainerObject(self["Attribute" .. roleIndex])
            SingleIconLoader.Load(nodes.Icon, attrInfo.sum_icon or "")
            ---区分在编队中的角色， 不在编队中的角色
            nodes.Name_txt.text = attrInfo.is_show_process == 1 and attrInfo.sum_name or DataAttrsDefine[attrInfo.attr_id].name
            ---详细属性才需要
            local value
            if roleEntity then
                value = roleEntity.attrComponent:GetValue(attrInfo.attr_id)
            else
                value = baseAttrs[attrInfo.attr_id] + (stageAttrs[attrInfo.attr_id] or 0)
            end
            if DataAttrsDefine[attrInfo.attr_id] and DataAttrsDefine[attrInfo.attr_id].value_type == FightEnum.AttrValueType.Percent then
                if not roleEntity then
                    value = value * 0.0001
                end
                nodes.Value_txt.text = (value * 100) .. "%"
            else
                nodes.Value_txt.text = value
            end
            roleIndex = roleIndex + 1
            if roleIndex > 4 then
                break
            end
        end
    end
    ---好感度和介绍
    self.WorldDescText_txt.text = DataHeroMain[self.heroId].world_desc

    self.LevelUpButton:SetActive(true)
    ---升级/突破按钮
    if self.curRoleInfo.lev < self.curLimitLevel then
        self.LevelUpButtonText_txt.text = TI18N("升级")
        self:CalculateMaxTargetLevel() 
        local lv = self.maxTargetLevel
        if lv >= self.curLimitLevel and Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.RoleUpgrade) then 
            UtilsUI.SetActive(self.LvRedPoint,true) 
        else
            UtilsUI.SetActive(self.LvRedPoint,false)
        end
    else
        self.LevelUpButtonText_txt.text = TI18N("突破")
        local stage = Config.DataHeroStageAttr.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage + 1)]
        self.LevelUpButton:SetActive(stage)
        local stageUpInfo = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage + 1)]
        local isPass, desc
        if stageUpInfo.condition ~= 0 then
            isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(stageUpInfo.condition)
        else
            isPass = true
        end
        for index, item in pairs(stageUpInfo.need_item) do
            local haveCount = mod.BagCtrl:GetItemCountById(item[1])
            local needCount = item[2]
            if haveCount < needCount then
                isPass = false
                goto continue
            end
        end
        ::continue::
        self.LvRedPoint:SetActive(isPass)
    end
end

--计算最大可升级等级，受金币和经验限制
function RoleAttributePanel:CalculateMaxTargetLevel()
    local curLevel = self.curRoleInfo.lev
    local needExp = -self.curRoleInfo.exp
    local haveGold = 0
    local currency = mod.BagCtrl:GetBagByType(BagEnum.BagType.Currency)
    for k, info in pairs(currency) do
        if info.template_id == 2 then
            haveGold = info.count
        end
    end
    for i = curLevel + 1, self.curLevelLimit do
        needExp = needExp + DataHeroLevUpgrade[i].need_exp
    end
    local selectItemList = {}
    local item = { 20103, 20102, 20101 }

    for _, itemId in ipairs(item) do
        local count = mod.BagCtrl:GetItemCountById(itemId)
        selectItemList[itemId] = math.ceil(needExp / DataItem[itemId].property1)
        selectItemList[itemId] = selectItemList[itemId] > count and count or selectItemList[itemId]
        if selectItemList[itemId] * (DataItem[itemId].property2 or 0) > haveGold then
            selectItemList[itemId] = math.floor(haveGold / DataItem[itemId].property2)
        end
        haveGold = haveGold - selectItemList[itemId] * (DataItem[itemId].property2 or 0)
        needExp = needExp - selectItemList[itemId] * DataItem[itemId].property1
    end

    local targetLevel, explore, cost = self:CalculateTargetLevel(selectItemList)
    self.maxTargetLevel = targetLevel
    return selectItemList
end

function RoleAttributePanel:CalculateTargetLevel(itemList)
    local cost, explore = self:CalculateCostAndExplore(itemList)
    local curLevel = self.curRoleInfo.lev
    local curExp = self.curRoleInfo.exp
    explore = explore + curExp
    local targetLevel = curLevel
    if curLevel >= self.curLevelLimit then
        return curLevel, curExp, cost
    end

    local needExp = DataHeroLevUpgrade[targetLevel + 1].need_exp
    while targetLevel < self.curLevelLimit and explore - needExp >= 0 do
        explore = explore - needExp
        targetLevel = targetLevel + 1
        if targetLevel == self.curLevelLimit then
            break
        end
        needExp = DataHeroLevUpgrade[targetLevel + 1].need_exp
    end

    if targetLevel == self.curLevelLimit then
        explore = needExp
    end

    return targetLevel, explore, cost
end

function RoleAttributePanel:CalculateCostAndExplore(itemList)
    local cost = 0
    local explore = 0
    for itemId, count in pairs(itemList) do
        cost = cost + count * (DataItem[itemId].property2 or 0)
        explore = explore + count * (DataItem[itemId].property1 or 0)
    end
    return cost, explore
end

function RoleAttributePanel:OnClick_OpenRoleUpgradeWindow()
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.RoleUpgrade)
    if not isOpen then
        MsgBoxManager.Instance:ShowTips(failDesc)
        return
    end
    WindowManager.Instance:OpenWindow(RoleUpgradeWindow, { heroId = self.heroId })
end

function RoleAttributePanel:OnClick_OpenStageUpPreviewPanel()
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.RoleUpgrade)
    if not isOpen then
        MsgBoxManager.Instance:ShowTips(failDesc)
        return
    end
    self.parentWindow:OpenPanel(RoleStageUpPreviewPanel, { heroId = self.heroId })
end

function RoleAttributePanel:OnClick_OpenRoleAttributeDetailPanel()
    self.parentWindow:OpenPanel(RoleAttributeDetailPanel, { heroId = self.heroId })
end

function RoleAttributePanel:OnClick_OpenFashionPanel()
    MsgBoxManager.Instance:ShowTips(TI18N("敬请期待"))
end

function RoleAttributePanel:OnRoleModelLoad(roleId)
    if not self.active then
        return
    end
    local config = RoleConfig.GetRoleCameraConfig(roleId, RoleConfig.PageCameraType.Attr)
    Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
    Fight.Instance.modelViewMgr:GetView():RecordCamera()
    Fight.Instance.modelViewMgr:GetView():SetModelRotation("RoleRoot", config.model_rotation)
    Fight.Instance.modelViewMgr:GetView():PlayModelAnim("RoleRoot", config.anim, 0.5)
    self:UpdateData(roleId)
end

function RoleAttributePanel:OnClose()
    self.RoleAttribute_exit:SetActive(true)
end