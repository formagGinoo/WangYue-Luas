RankRewardNewPanel = BaseClass("RankRewardNewPanel", BasePanel)

local TempHight = 101

function RankRewardNewPanel:__init()
	self:SetAsset("Prefabs/UI/MercenaryHunt/RankRewardNewPanel.prefab")
end

function RankRewardNewPanel:__BindListener()
    -- self.MainBackBtn_btn.onClick:AddListener(self:ToFunc("ClickBackBtn"))
    -- self.CommonBack_btn.onClick:AddListener(self:ToFunc("ClickBackBtn"))


    self:BindCloseBtn(self.MainBackBtn_btn,self:ToFunc("ClickBackBtn"))
    self:BindCloseBtn(self.CommonBack_btn,self:ToFunc("ClickBackBtn"))


    self.GetDailyBtn_btn.onClick:AddListener(self:ToFunc("ClickGetDailyBtn"))
end

function RankRewardNewPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.UpdateDailyRewardInfo, self:ToFunc("UpdateDailyBtnInfo"))
end

function RankRewardNewPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RankRewardNewPanel:__ShowComplete()

end

function RankRewardNewPanel:__Hide()
    EventMgr.Instance:RemoveListener(EventName.UpdateDailyRewardInfo, self:ToFunc("UpdateDailyBtnInfo"))
    for k, v in pairs(self.rankItemMap) do
        v:Destory()
		PoolManager.Instance:Push(PoolType.class, "RankItem", v)
	end
    self.rankItemMap = {}

	PoolManager.Instance:Push(PoolType.class, "CommonItem", self.dailyAwardItem)
    
    self.blurBack = nil
end

function RankRewardNewPanel:ClickBackBtn()
    PanelManager.Instance:ClosePanel(self)
end

function RankRewardNewPanel:ClickGetDailyBtn()
    mod.MercenaryHuntFacade:SendMsg("mercenary_daily_reward")
end

function RankRewardNewPanel:CreateBlurBack()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show()
end

function RankRewardNewPanel:__Show()
    self.mercenaryHuntCtrl = mod.MercenaryHuntCtrl
    self.rankItemMap = {}
    self:CreateBlurBack()

    self:UpdateDailyBtnInfo()
    self:UpdateRankView()
    self:ShowDailyReward()
    self:InitScrollView()
end

function RankRewardNewPanel:UpdateDailyBtnInfo()
    local isGetDailyReward = self.mercenaryHuntCtrl:CheckGetDailyReward()
    self.GetDailyBtn:SetActive(isGetDailyReward)
end

function RankRewardNewPanel:UpdateRankView()
    local rankId, _ = self.mercenaryHuntCtrl:GetCurRankInfo()
    local rankCfg = MercenaryHuntConfig.GetMercenaryHuntRankLvConfig(rankId)
    if not rankCfg then return end
    SingleIconLoader.Load(self.CurRankIcon, rankCfg.icon_path1)

    -- local lvDesc = MercenaryHuntConfig.RankLvToDesc[rankLv]
    self.CurRankLv_txt.text = rankCfg.icon_num
end

function RankRewardNewPanel:InitScrollView()
    local rankListCfg = MercenaryHuntConfig.GetMercenaryHuntRankLvConfig()
    local sizeDelta = self.RankScroll_rect.sizeDelta
    local num = #rankListCfg
    local height = num * TempHight + (num - 1) * 5
    UnityUtils.SetSizeDelata(self.RankScroll_rect, sizeDelta.x, height)

    local component = self.RankScroll.transform:GetComponent(RecyclableScrollRect)
    component.enabled = true

    self.RankScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshRankItem"))
    self.RankScroll_recyceList:SetCellNum(num)

    component.enabled = false
end

function RankRewardNewPanel:ShowDailyReward()
    local curRank = self.mercenaryHuntCtrl:GetCurRankInfo()
    local rankCfg = MercenaryHuntConfig.GetMercenaryHuntRankLvConfig(curRank)
    if not rankCfg then
        LogError("缺少段位配置，段位id = ".. curRank)
        return
    end
    local rewardId = rankCfg.daily_reward_id
    local rewardList = ItemConfig.GetReward(rewardId)
    local reward = rewardList[1]
    local itemId = reward[1]

    local awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not awardItem then
        awardItem = CommonItem.New()
    end

    local num = reward[2]
    local itemInfo = {template_id = itemId, count = num}
    awardItem:InitItem(self.CurDailyItem, itemInfo, true)
    self.dailyAwardItem = awardItem
end

function RankRewardNewPanel:RefreshRankItem(idx, item)
    local rankCfg = MercenaryHuntConfig.GetMercenaryHuntRankLvConfig(idx)
    if not rankCfg then return end
    local rect = item:GetComponent(RectTransform)
    UnityUtils.SetAnchoredPosition(rect, 0, 0)
    local rankItem = PoolManager.Instance:Pop(PoolType.class, "RankItem")
    if not rankItem then
        rankItem = RankItem.New()
    end
    rankItem:InitAward(item, rankCfg)
    self.rankItemMap[idx] = rankItem
end