PurchaseMonthCardPanel = BaseClass("PurchaseMonthCardPanel", BasePanel)

function PurchaseMonthCardPanel:__init()
    self:SetAsset("Prefabs/UI/Purchase/PurchaseMonthCardPanel.prefab")

end

function PurchaseMonthCardPanel:__BindListener()
    self.TipsBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ClickTipsBtn"))
    self.BuyBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ClickBuyBtn"))
    EventMgr.Instance:AddListener(EventName.MonthCardUpdate,self:ToFunc("ShowInfo"))

end

function PurchaseMonthCardPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PurchaseMonthCardPanel:__Create()

end

function PurchaseMonthCardPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.MonthCardUpdate,self:ToFunc("ShowInfo"))
end

function PurchaseMonthCardPanel:__ShowComplete()
    
end

function PurchaseMonthCardPanel:__Hide()

end

function PurchaseMonthCardPanel:__Show()
    self.id = 1
    self:ShowInfo()
end

function PurchaseMonthCardPanel:ShowInfo()
    self.monthCardInfo = mod.PurchaseCtrl:GetCardListById(self.id)
    -- 策划说先不读表了
    -- self.Name_txt.text = PurchaseConfig.DataMonthcard[self.id].name
    self.Desc_txt.text = PurchaseConfig.DataMonthcard[self.id].desc
    self:ShowAward(PurchaseConfig.DataMonthcard[self.id].normal_rewardid, "First")
    self:ShowAward(PurchaseConfig.DataMonthcard[self.id].daily_rewardid, "Daily")
    self.RefreshTime_txt.text = self:ShowRefreshDay()
    self.RefreshTip_txt.text = self:ShowRefreshTips()
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Refresh.transform)
end

function PurchaseMonthCardPanel:ShowRefreshDay()
    if self.monthCardInfo and next(self.monthCardInfo) then
        return self.monthCardInfo.rest_day
    else
        return 0
    end
end

function PurchaseMonthCardPanel:ShowRefreshTips()
    if self.monthCardInfo and next(self.monthCardInfo) then
        if self.monthCardInfo.is_reward == 0 then
            return TI18N("(本日未领取)")
        else
            return TI18N("(本日已领取)")
        end
    else
        return TI18N("(未生效)")
    end
end

function PurchaseMonthCardPanel:ShowAward(rewardId, name)
    local list = ItemConfig.GetReward2(rewardId)
    SingleIconLoader.Load(self[name .. "AwardImg"], ItemConfig.GetItemIcon(list[1][1]))
    self[name .. "AwardText_txt"].text = list[self.id][2]
end

function PurchaseMonthCardPanel:OnClick_ClickBuyBtn()
    mod.PurchaseCtrl:BuyMonthCard(self.id)
end

function PurchaseMonthCardPanel:OnClick_ClickTipsBtn()
    PanelManager.Instance:OpenPanel(MonthCardTipsPanel)
end