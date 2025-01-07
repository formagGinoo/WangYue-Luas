RoleStageUpPreviewPanel = BaseClass("RoleStageUpPreviewPanel", BasePanel)

local DataItem = Config.DataItem.data_item

function RoleStageUpPreviewPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleStageUpPreviewPanel.prefab")
    self.costItemList = {}
end
function RoleStageUpPreviewPanel:__BindEvent()

end

function RoleStageUpPreviewPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))

    self.LeftArrowButton_btn.onClick:AddListener(self:ToFunc("OnClick_Left"))
    self.RightArrowButton_btn.onClick:AddListener(self:ToFunc("OnClick_Right"))
    self:SetAcceptInput(true)
end

function RoleStageUpPreviewPanel:__Create()

end

function RoleStageUpPreviewPanel:__Show()
    self.heroId = self.args.heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.args.heroId)
    self.curStage = self.curRoleInfo.stage
    self.showStage = self.curStage
    if Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage + 1)] then
        self.showStage = self.curStage + 1
    end
    self:ShowInfo()
end

function RoleStageUpPreviewPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function RoleStageUpPreviewPanel:BlurComplete()
    self:SetActive(true)
end
function RoleStageUpPreviewPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function RoleStageUpPreviewPanel:ShowInfo()
    local stageUpInfo = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.showStage)]
    local nextStage = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.showStage + 1)]
    local upStage = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.showStage - 1)]

    self.RightArrowButton:SetActive(nextStage ~= nil)
    self.LeftArrowButton:SetActive(self.showStage > 1)
    if not stageUpInfo then
        return
    end
    --SingleIconLoader.Load(self.Mai, "Textures/Icon/Single/StageIcon/" .. self.curRoleInfo.stage .. ".png")
    SingleIconLoader.Load(self.StageIcon, "Textures/Icon/Single/StageIcon/" .. self.showStage .. ".png")
    if self.curStage < self.showStage then
        self.LevelTip_txt.text = "角色达到" .. upStage.limit_hero_lev.."级可突破"
    else
        self.LevelTip_txt.text = TI18N("已突破")
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
            if self.curStage >= self.showStage then
                costItem.Count_txt.text = needCount
            else
                if haveCount < needCount then
                    costItem.Count_txt.text = string.format("<color=#ff0000>%s</color>/<color=#ffffff>%s</color>", haveCount, needCount)
                else
                    costItem.Count_txt.text = string.format("<color=#ffffff>%s/%s</color>", haveCount, needCount)
                end
            end
            self:SetQuality(costItem, DataItem[item[1]].quality)
            costItem.object:SetActive(true)
            self.costItemList[index] = costItem
        end
    end
    if self.curStage < self.showStage then
        local currency = mod.BagCtrl:GetBagByType(BagEnum.BagType.Currency)
        local haveGold = 0
        for k, info in pairs(currency) do
            if info.template_id == 2 then
                haveGold = info.count
                break
            end
        end
        if stageUpInfo.need_gold > haveGold then
            self.MoneyCostText_txt.text = string.format("<color=#ff0000>%s</color>/<color=#9b9fad>%s</color>", haveGold, stageUpInfo.need_gold)
        else
            self.MoneyCostText_txt.text = string.format("<color=#9b9fad>%s/%s</color>", haveGold, stageUpInfo.need_gold)
        end
    end
end

function RoleStageUpPreviewPanel:getCostItem()
    local obj = self:PopUITmpObject("CostItem")
    obj.objectTransform:SetParent(self.CostList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

--设置材料品质
function RoleStageUpPreviewPanel:SetQuality(itemObj, quality)
    local frontImg, backImg = ItemManager.GetItemColorImg(quality)
    if not frontImg or not backImg then
        return
    end

    local frontPath = AssetConfig.GetQualityIcon(frontImg)
    local backPath = AssetConfig.GetQualityIcon(backImg)
    SingleIconLoader.Load(itemObj.QualityFront, frontPath)
    SingleIconLoader.Load(itemObj.QualityBack, backPath)
end

function RoleStageUpPreviewPanel:OnClick_Left()
    self.showStage = self.showStage - 1
    self:ShowInfo()
end

function RoleStageUpPreviewPanel:OnClick_Right()
    self.showStage = self.showStage + 1
    self:ShowInfo()
end