BaseStagePreviewPanel = BaseClass("BaseStagePreviewPanel", BasePanel)

BaseStagePreviewPanel.CaseType = 
{
    Weapon = TI18N("武器提升至LV.%s可以突破")
}

function BaseStagePreviewPanel:__init()
    self:SetAsset("Prefabs/UI/Role/RoleStageUpPreviewPanel.prefab")
end

function BaseStagePreviewPanel:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClick_ClosePanel"))
    self.LeftArrowButton_btn.onClick:AddListener(self:ToFunc("OnClick_Left"))
    self.RightArrowButton_btn.onClick:AddListener(self:ToFunc("OnClick_Right"))
end

function BaseStagePreviewPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BaseStagePreviewPanel:__ShowComplete()
    self.TitleText_txt.text = TI18N("突破预览")
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 3, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function BaseStagePreviewPanel:BlurComplete()
    self:SetActive(true)
end

function BaseStagePreviewPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    if self.itemObjs and next(self.itemObjs) then
        for key, value in pairs(self.itemObjs) do
            ItemManager.Instance:PushItemToPool(value)
        end
    end
    self.itemObjs = {}
end

--[[
    caseType
    id
    startStage
]]

function BaseStagePreviewPanel:__Show()
    self.caseType = self.args.caseType
    self.id = self.args.id
    self.startStage = self.args.startStage
    self.maxLev = self:GetMaxStageLev()
    self.curStage = self.startStage + 1
    if self.curStage > self.maxLev then
        self.curStage = self.maxLev
    end
    self:PreViewStageInfo()
end

function BaseStagePreviewPanel:GetMaxStageLev()
    local maxLev = 0
    local i = maxLev + 1
    while RoleConfig.GetStageConfig(self.id, i) do
        i = i + 1
    end
    maxLev = i - 1
    return maxLev
end

function BaseStagePreviewPanel:PreViewStageInfo(stage)
    local id = self.id
    stage = stage or self.curStage
    if self.itemObjs and next(self.itemObjs) then
        for key, value in pairs(self.itemObjs) do
            ItemManager.Instance:PushItemToPool(value)
        end
    end
    self.LeftArrowButton:SetActive(stage > 1)
    self.RightArrowButton:SetActive(stage < self.maxLev)

    self.itemObjs = {}
    local config = RoleConfig.GetStageConfig(id, stage)
    for i = 1, #config.need_item, 1 do
        local curCount = mod.BagCtrl:GetItemCountById(config.need_item[i][1])
        local needCount = config.need_item[i][2]
        local count
        if self.startStage < stage then
            if curCount < needCount then
                count = string.format("<color=#ff0000>%s</color>/<color=#ffffff>%s</color>",  curCount, needCount)
            else
                count = string.format("<color=#ffffff>%s/%s</color>",  curCount, needCount)
            end
        else
            count = string.format("<color=#ffffff>%s</color>", needCount)
        end

        local itemInfo =
        {
            template_id = config.need_item[i][1],
            scale = 0.8,
            count = count,
        }
        local item = ItemManager.Instance:GetItem(self.CostList_rect, itemInfo, true)
        table.insert(self.itemObjs, item)
    end
    local curGold = mod.BagCtrl:GetGoldCount()
    if curGold < config.need_gold then
        self.MoneyCostText_txt.text = string.format("<color=#ff0000>%s</color>/<color=#9b9fad>%s</color>", curGold, config.need_gold)
    else
        self.MoneyCostText_txt.text = string.format("<color=#000000>%s/%s</color>", curGold, config.need_gold)
    end
    if self.startStage < stage then
        self.LevelTip_txt.text = string.format(self.caseType, RoleConfig.GetStageConfig(id, stage - 1).level_limit)
    else
        self.LevelTip_txt.text = TI18N("已突破")
    end
    SingleIconLoader.Load(self.StageIcon, "Textures/Icon/Single/StageIcon/" .. stage .. ".png")
end

function BaseStagePreviewPanel:OnClick_ClosePanel()
    PanelManager.Instance:ClosePanel(BaseStagePreviewPanel)
end

function BaseStagePreviewPanel:OnClick_Left()
    self.curStage = self.curStage - 1
    self:PreViewStageInfo()
end

function BaseStagePreviewPanel:OnClick_Right()
    self.curStage = self.curStage + 1
    self:PreViewStageInfo()
end