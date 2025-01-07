RankRewardPanel = BaseClass("RankRewardPanel", BasePanel)

function RankRewardPanel:__init()  
    self:SetAsset("Prefabs/UI/MercenaryHunt/RankRewardPanel.prefab")
    self.RewardObjList = {}
    self.curRewardData = {}
end

function RankRewardPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")

    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Back"))
end

function RankRewardPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.GetRankReward, self:ToFunc("RefreshRewardScroll"))
end

function RankRewardPanel:__Create()

end

function RankRewardPanel:__delete()
    for k, v in pairs(self.RewardObjList) do
        v.awardItem:Destory()
		PoolManager.Instance:Push(PoolType.class, "RankAwardItem", v.awardItem)
	end
    self.curRewardData = nil
    EventMgr.Instance:RemoveListener(EventName.GetRankReward, self:ToFunc("RefreshRewardScroll"))
end

function RankRewardPanel:__Hide()

end

function RankRewardPanel:__Show()
    self.curRewardData = Config.DataMercenaryRankLv.Find
    self.rankLv = MercenaryHuntConfig.GetRankLvByExp(self.args.exp)
    self:SetBadgeIcon()
    self:SetRankLv()
    self:SetProgress()
end

function RankRewardPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({self:ToFunc("RefreshRewardScroll")})
end

function RankRewardPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RankRewardPanel:RefreshRewardScroll()
    local col = 1
    local row = math.ceil((self.RewardScroll_rect.rect.height - 25) / 145)
    local RewardCount = #self.curRewardData

    local listNum = RewardCount > (col * row) and RewardCount or (col * row)
    self.RewardScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshRewardCell"))
    self.RewardScroll_recyceList:SetCellNum(listNum)
end

function RankRewardPanel:RefreshRewardCell(index,go)
    if not go then
        return 
    end
    local awardItem
    local awardObj
    if self.RewardObjList[index] then
        awardItem = self.RewardObjList[index].awardItem
        awardObj = self.RewardObjList[index].awardObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)

        awardItem = PoolManager.Instance:Pop(PoolType.class, "RankAwardItem")
        if not awardItem then
            awardItem = RankAwardItem.New()
        end
        awardObj = uiContainer.RewardItem
        self.RewardObjList[index] = {}
        self.RewardObjList[index].awardItem = awardItem
        self.RewardObjList[index].awardObj = awardObj
    end

    awardItem:InitAward(awardObj,self.curRewardData[index],true)
end

function RankRewardPanel:SetBadgeIcon()
    --SingleIconLoader.Load(self.BadgeIcon, self.curRewardData[self.rankLv].icon_path)
end

function RankRewardPanel:SetRankLv()
    self.RankLv_txt.text = self.rankLv
end

function RankRewardPanel:SetProgress()
    local nowExp = MercenaryHuntConfig.GetHasExpToNextLv(self.args.exp)
    local maxExp = MercenaryHuntConfig.GetExpToNextLv(self.args.exp)
    if 0 == maxExp then
        self.ProgressNum_txt.text = MercenaryHuntConfig.MaxLvText
        self.Progress_img.fillAmount = 1
        return
    end

    self.ProgressNum_txt.text = nowExp .. "/" .. maxExp
    self.Progress_img.fillAmount = nowExp / maxExp
end

function RankRewardPanel:Back()
    PanelManager.Instance:ClosePanel(self)
end