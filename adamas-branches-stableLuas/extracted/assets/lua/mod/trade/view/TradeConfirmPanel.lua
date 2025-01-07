TradeConfirmPanel = BaseClass("TradeConfirmPanel", BasePanel)

local DataTradeOrder = Config.DataTradeOrder.Find

function TradeConfirmPanel:__init()
    self:SetAsset("Prefabs/UI/Trade/TradeConfirmPanel.prefab")
    self.blurBack = nil
end

function TradeConfirmPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonBack1_btn, self:ToFunc("OnClickCloseBtn"))
    self:BindCloseBtn(self.Cancel_btn, self:ToFunc("OnClickCloseBtn"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClickSellBtn"))
end

function TradeConfirmPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.TradeWindowBargainUpdate, self:ToFunc("InitData"))
end

function TradeConfirmPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function TradeConfirmPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.TradeWindowBargainUpdate, self:ToFunc("InitData"))

    if self.rewardCommonItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.rewardCommonItem)
        self.rewardCommonItem = nil
    end

    if self.rewardExtraCommonItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.rewardExtraCommonItem)
        self.rewardExtraCommonItem = nil
    end
end

function TradeConfirmPanel:__Show()
    self.curPlacingItemId = mod.TradeCtrl:GetCurPlacingItem()
    self.curOrderId = mod.TradeCtrl:GetCurOrderId()

    self:InitData()
end

function TradeConfirmPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function TradeConfirmPanel:OnClickCloseBtn()
    PanelManager.Instance:ClosePanel(TradeConfirmPanel)
end

function TradeConfirmPanel:InitData()
    self.ShowTips_txt.text = TI18N("确认出售该道具吗?")
    self.TitleText_txt.text = TI18N("出售")
    local orderInfo = DataTradeOrder[self.curOrderId]

    -- 放入的道具
    UtilsUI.SetActive(self.NeedItem, true)
    self.needCommonItem = self:LoadCommonItem(self.curPlacingItemId, self.NeedCommonItem)
    UtilsUI.SetActive(self.needCommonItem.node.Num, true)
    self.needCommonItem.node.Num_txt.text = orderInfo.need_item_count

    -- 判断是否有额外奖励
    local extraNum = nil
    for _, v in ipairs(orderInfo.expect_item) do
        if v[1] == self.curPlacingItemId then
            if v[2] then
                extraNum = v[2]
            else
                extraNum = 0
            end
        end
    end

    -- 得到的道具
    UtilsUI.SetActive(self.RewardItem, true)
    self.rewardCommonItem = self:LoadCommonItem(orderInfo.reward_item_id, self.RewardCommonItem)
    UtilsUI.SetActive(self.rewardCommonItem.node.Num, true)
    if not extraNum then
        self.rewardCommonItem.node.Num_txt.text = 0
    else
        self.rewardCommonItem.node.Num_txt.text = orderInfo.reward_item_count
    end

    if extraNum and extraNum > 0 then
        UtilsUI.SetActive(self.RewardExtraItem, true)
        self.rewardExtraCommonItem = self:LoadCommonItem(orderInfo.reward_item_id, self.RewardExtraCommonItem)
        UtilsUI.SetActive(self.rewardExtraCommonItem.node.Num, true)
        self.rewardExtraCommonItem.node.Num_txt.text = extraNum
        self.RewardExtraText_txt.text = TI18N("额外")
    end

    -- 判断是否讲价
    local flag = mod.TradeCtrl:CheckIsBargain()
    if flag then
        UtilsUI.SetActive(self.RewardDargainItem, true)
        local curBasicsRewardNum, curExtraRewardNum, curBargainNum = mod.TradeCtrl:GetCurRewardNum()
        self.rewardDargainCommonItem = self:LoadCommonItem(orderInfo.reward_item_id, self.RewardDargainCommonItem)
        if flag == 1 then
            UtilsUI.SetActive(self.RewardDargainSuccess, true)
            UtilsUI.SetActive(self.RewardDargainFail, false)
            self.RewardDargainSuccessText_txt.text = TI18N("讲价成功")
        else
            UtilsUI.SetActive(self.RewardDargainSuccess, false)
            UtilsUI.SetActive(self.RewardDargainFail, true)
            self.RewardDargainFailText_txt.text = TI18N("讲价失败")
        end
        UtilsUI.SetActive(self.rewardDargainCommonItem.node.Num, true)
        
        self.rewardDargainCommonItem.node.Num_txt.text = string.format("%.0f", curBargainNum)
        
    else
        UtilsUI.SetActive(self.RewardDargainItem, false)
    end
end

function TradeConfirmPanel:LoadCommonItem(itemId, go)
    local commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
    local itemInfo = ItemConfig.GetItemConfig(itemId)
    itemInfo.template_id = itemId
    commonItem:InitItem(go, itemInfo, true)

    return commonItem
end

function TradeConfirmPanel:OnClickSellBtn()
    mod.TradeCtrl:SellItem()
end