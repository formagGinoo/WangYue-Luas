RankItem = BaseClass("RankItem", Module)

function RankItem:__init()
	self.rewardObjMap = {}
end

function RankItem:Destory()
    for k, v in pairs(self.rewardObjMap) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end
	self.rewardObjMap = {}

	PoolManager.Instance:Push(PoolType.class, "CommonItem", self.dailyAwardItem)
    self.dailyAwardItem = nil
end

function RankItem:InitAward(object, rankCfg)
	-- 获取对应的组件
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.loadDone = true

	self.rankCfg = rankCfg
	self.object:SetActive(false)

    self:AddEvent()
    self:AddClickListener()
	self:Show()
end

function RankItem:AddEvent()
    EventMgr.Instance:AddListener(EventName.GetRankReward, self:ToFunc("MsgUpdateReceiveState"))
end

function RankItem:AddClickListener()
    self.node.GetBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ReceiveReward"))
end

function RankItem:Show()
	if not self.loadDone then
        return
    end
	self.object:SetActive(true)
    self.mercenaryHuntCtrl = mod.MercenaryHuntCtrl

    self:UpdateRankInfo()
    self:UpdateAwardView()
    self:UpdateDailyReward()
    self:UpdateRankRewardReceiveState()
end

function RankItem:UpdateRankInfo()
    local rankIcon = self.rankCfg.icon_path1
    SingleIconLoader.Load(self.node.RankIcon, rankIcon)
    self.node.RankLv_txt.text = self.rankCfg.icon_num
end

function RankItem:UpdateAwardView()
    local rankRewadId = self.rankCfg.reward_id
    local rewardList = ItemConfig.GetReward2(rankRewadId)
    self.rewardList = rewardList
    self.node.AwardScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshAwardCell"))
    self.node.AwardScroll_recyceList:SetCellNum(#rewardList)
end

function RankItem:UpdateDailyReward()
    local curRank = self.rankCfg.rank_lv
    local rewardId = self.rankCfg.daily_reward_id
    local rewardList = ItemConfig.GetReward(rewardId)
    local reward = rewardList[1]
    local itemId = reward[1]

    local awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not awardItem then
        awardItem = CommonItem.New()
    end

    local num = reward[2]
    local itemInfo = {template_id = itemId, count = num}
    awardItem:InitItem(self.node.DailyItem, itemInfo, true)
    self.dailyAwardItem = awardItem
end

function RankItem:RefreshAwardCell(index,go)
    if not go then
        return 
    end
    local awardItem
    local awardObj
    if self.rewardObjMap[index] then
        awardItem = self.rewardObjMap[index].awardItem
        awardObj = self.rewardObjMap[index].awardObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not awardItem then
            awardItem = CommonItem.New()
        end 
        awardObj = uiContainer.CommonItem
        self.rewardObjMap[index] = {}
        self.rewardObjMap[index].awardItem = awardItem
        self.rewardObjMap[index].awardObj = awardObj
    end

    local itemId = self.rewardList[index][1]
    local num = self.rewardList[index][2]
    local itemInfo = {template_id = itemId, count = num}
    awardItem:InitItem(awardObj, itemInfo, true)
end

function RankItem:UpdateRankRewardReceiveState()
    local rankId = self.rankCfg.rank_lv
    local isReceive = self.mercenaryHuntCtrl:CheckGetRankRewardByRankId(rankId)
    -- 是否可领取
    local isCanGet = self.mercenaryHuntCtrl:ISGetRankReward(rankId)

    self.node.NoComplete:SetActive(not isReceive and not isCanGet)
    self.node.Complete:SetActive(isReceive)
    self.node.GetBtn:SetActive(isCanGet)
end

function RankItem:MsgUpdateReceiveState(refreshMap)
    local rankId = self.rankCfg.rank_lv
    if not refreshMap[rankId] then return end
    self:UpdateRankRewardReceiveState()
end

function RankItem:OnClick_ReceiveReward()
    local rankId = self.rankCfg.rank_lv
    mod.MercenaryHuntFacade:SendMsg("mercenary_reward_list", rankId)
end

function RankItem:OnReset()
end