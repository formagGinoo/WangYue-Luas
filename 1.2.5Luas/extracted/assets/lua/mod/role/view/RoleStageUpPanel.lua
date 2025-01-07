RoleStageUpPanel = BaseClass("RoleStageUpPanel", BasePanel)

local DataHeroStageAttr = Config.DataHeroStageAttr.Find
local DataItem = Config.DataItem.data_item

function RoleStageUpPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleStageUpPanel.prefab")
    self.attrItemList = {}
    self.costItemList = {}
end
function RoleStageUpPanel:__BindEvent()

end

function RoleStageUpPanel:__BindListener()
    self.StageUpButton_1_btn.onClick:AddListener(self:ToFunc("OnClick_Confirm"))
end

function RoleStageUpPanel:__Create()
    self:initCurrencyBar()
end

function RoleStageUpPanel:__delete()
    self:CacheCurrencyBar()
end

function RoleStageUpPanel:__Show()
    self.heroId = self.args.heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.args.heroId)
    self:ShowInfo()
end

function RoleStageUpPanel:__ShowComplete()
    local config = RoleConfig.GetRoleCameraConfig(self.heroId, RoleConfig.PageCameraType.StageUp)
    Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
    Fight.Instance.modelViewMgr:GetView():PlayModelAnim("RoleRoot", config.anim)
end

function RoleStageUpPanel:ShowInfo()
    local curAttr = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curRoleInfo.lev)
    local curStageAttr = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.curRoleInfo.stage)
    local nextStageAttr = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.curRoleInfo.stage + 1)
    local stageUpInfo = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage + 1)]
    if not nextStageAttr or not stageUpInfo then
        return
    end
    self.isCanUpStage = true
    SingleIconLoader.Load(self.StageIcon, "Textures/Icon/Single/StageIcon/" .. self.curRoleInfo.stage .. ".png")
    self.LevelLimitTip_txt.text = "等级上限提升至" .. stageUpInfo.limit_hero_lev .. "级"

    self.CurLevel_txt.text = self.curRoleInfo.lev .. "/"
    self.CurLevelLimit_txt.text = self.curRoleInfo.lev
    self.NextLevel_txt.text = self.curRoleInfo.lev .. "/"
    self.NextLevelLimit_txt.text = stageUpInfo.limit_hero_lev
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.CurLevel.transform.parent)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.NextLevel.transform.parent)
    if stageUpInfo.deblock_skill_id ~= 0 then
        self.SkillUnlock:SetActive(true)
        local skill = RoleConfig.GetSkillConfig(stageUpInfo.deblock_skill_id)
        self.SkillName_txt.text = skill.name
    else
        self.SkillUnlock:SetActive(false)
    end
    ---放到缓存节点下，避免被delayShow显示出来
    for k, v in pairs(self.CostList.transform) do
        v.objectTransform:SetParent(self.Cache.transform)
    end

    local showAttrList = DataHeroStageAttr[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage + 1)]
    for index, attr_id in pairs(showAttrList.ui_show_attr) do
        local item = self.attrItemList[index] or self:getAttributeItem()
        item.Bg:SetActive(index % 2 ~= 0)
        item.Name_txt.text = Config.DataAttrsDefine.Find[attr_id].name
        local curValue = curAttr[attr_id] + curStageAttr[attr_id] or 0
        local nextValue = curAttr[attr_id] + nextStageAttr[attr_id] or 0
        if EntityAttrsConfig.AttrPercent2Attr[attr_id] then
            curValue = curValue * 0.01 .. "%"
            nextValue = nextValue * 0.01 .. "%"
        end
        item.CurValue_txt.text = curValue
        item.NextValue_txt.text = nextValue
        item.UpArrow:SetActive(nextStageAttr[attr_id] and nextStageAttr[attr_id] > 0)
        item.objectTransform:SetParent(self.AttributeList.transform)
        self.attrItemList[index] = item
    end
    for _, item in pairs(self.costItemList) do
        item.object:SetActive(false)
    end

    for index, item in pairs(stageUpInfo.need_item) do
        if item[1] ~= 0 then
            local costItem = self.costItemList[index] or self:getCostItem()
            local icon = ItemConfig.GetItemIcon(item[1])
            SingleIconLoader.Load(costItem.Icon, icon)
            local haveCount = mod.BagCtrl:GetItemCountById(item[1])
            local needCount = item[2]
            self:SetQuality(costItem, DataItem[item[1]].quality)
            costItem.object:SetActive(true)
            local onClickFunc = function()
                local itemInfo = {template_id = item[1]}
                ItemManager.Instance:ShowItemTipsPanel(itemInfo)
            end
            costItem.Icon_btn.onClick:RemoveAllListeners()
            costItem.Icon_btn.onClick:AddListener(onClickFunc)
            if haveCount < needCount then
                costItem.Count_txt.text = string.format("<color=#ff0000>%s</color>/<color=#ffffff>%s</color>", haveCount, needCount)
                self.isCanUpStage = false
            else
                costItem.Count_txt.text = string.format("<color=#ffffff>%s/%s</color>", haveCount, needCount)
            end
            self.costItemList[index] = costItem
        end
    end
    local currency = mod.BagCtrl:GetBagByType(BagEnum.BagType.Currency)
    local haveGold = 0
    for k, info in pairs(currency) do
        if info.template_id == 2 then
            haveGold = info.count
            break
        end
    end
    if stageUpInfo.need_gold > haveGold then
        self.MoneyCostText_txt.text = string.format("<color=#eb6f00>%s</color>", stageUpInfo.need_gold)
    else
        self.MoneyCostText_txt.text = string.format("<color=#9b9fad>%s</color>", stageUpInfo.need_gold)
    end
    if haveGold < stageUpInfo.need_gold then
        self.isCanUpStage = false
    end

    local isPass, desc
    if stageUpInfo.condition ~= 0 then
        isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(stageUpInfo.condition)
        if not isPass then
            self.LimitTipText_txt.text = Fight.Instance.conditionManager:GetConditionDesc(stageUpInfo.condition)
        end
    else
        isPass = true
    end
    self.Button:SetActive(isPass)
    self.LimitTip:SetActive(not isPass)
end

-- 初始化货币栏
function RoleStageUpPanel:initCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.GoldCurrencyBar, 2)
end

-- 移除货币栏
function RoleStageUpPanel:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end

function RoleStageUpPanel:getAttributeItem()
    local obj = self:PopUITmpObject("AttributeUp")
    obj.objectTransform:SetParent(self.AttributeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetActive(false)
    return obj
end

function RoleStageUpPanel:getCostItem()
    local obj = self:PopUITmpObject("CostItem")
    obj.objectTransform:SetParent(self.CostList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

--设置材料品质
function RoleStageUpPanel:SetQuality(itemObj, quality)
    local frontImg, backImg = ItemManager.GetItemColorImg(quality)
    if not frontImg or not backImg then
        return
    end

    local frontPath = AssetConfig.GetQualityIcon(frontImg)
    local backPath = AssetConfig.GetQualityIcon(backImg)
    SingleIconLoader.Load(itemObj.QualityFront, frontPath)
    SingleIconLoader.Load(itemObj.QualityBack, backPath)
end

function RoleStageUpPanel:OpenTipsPanel()

end

function RoleStageUpPanel:OnClose()
    self.RoleStageUpPanel_Exit:SetActive(true)
end

function RoleStageUpPanel:OnClick_Confirm()
    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end
    if not self.isCanUpStage then
        MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
    end

    mod.RoleCtrl:RoleStageUp(self.args.heroId)
end
