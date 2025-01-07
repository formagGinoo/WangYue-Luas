RankAwardItem = BaseClass("RankAwardItem", Module)

function RankAwardItem:__init()
	self.AwardObjList = {}
end

function RankAwardItem:Destory()
    for k, v in pairs(self.AwardObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end
	self.AwardObjList = {}
end

function RankAwardItem:InitAward(object, awardInfo, defaultShow)
	-- 获取对应的组件
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	
	if defaultShow ~= nil then self.defaultShow = defaultShow end

	self.loadDone = true

	self.awardInfo = awardInfo

	self.object:SetActive(false)
    
	self:Show()
end

function RankAwardItem:AddEvent()
    EventMgr.Instance:AddListener(EventName.GetRankReward, self:ToFunc("UpdateReceiveInfo"))
end

function RankAwardItem:AddClickListener()
    self.node.GetBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ReceiveReward"))
end
function RankAwardItem:Show()
	if not self.loadDone then 
        return 
    end
    self:AddClickListener()
    self:AddEvent()
    self.rankLev = mod.MercenaryHuntCtrl.rankLev
	self:SetRank()
	self:SetAwardItem()
    self:UpdateReceiveInfo()
	if self.defaultShow then
		self.object:SetActive(true)
	end
end
function RankAwardItem:UpdateReceiveInfo()
    self.rankRewardMap = mod.MercenaryHuntCtrl:GetRankRewardMap()
    if self.rankRewardMap[self.awardInfo.rank_lv] == true then
        self.node.UnCompleteText:SetActive(false)
        self.node.Received:SetActive(true)
        self.node.GetBtn:SetActive(false)
    elseif self.rankLev >= self.awardInfo.rank_lv then
        self.node.UnCompleteText:SetActive(false)
        self.node.GetBtn:SetActive(true)
        self.node.Received:SetActive(false)
    else
        self.node.UnCompleteText:SetActive(true)
        self.node.GetBtn:SetActive(false)
        self.node.Received:SetActive(false)
    end
    EventMgr.Instance:RemoveListener(EventName.GetRankReward, self:ToFunc("UpdateReceiveInfo"))
end
function RankAwardItem:SetRank()
	self.node.RankLv_txt.text = self.awardInfo.rank_lv
end

function RankAwardItem:SetAwardItem()
	self.awardList = MercenaryHuntConfig.GetItemListByRewardId(self.awardInfo.reward_id)
	self:RefreshAwardScroll()
end

function RankAwardItem:RefreshAwardScroll()
    local col = 1
    local row = math.ceil((self.node.AwardScroll_rect.rect.height - 25) / 145)
    local AwardCount = #self.awardList

    local listNum = AwardCount > (col * row) and AwardCount or (col * row)
    self.node.AwardScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshAwardCell"))
    self.node.AwardScroll_recyceList:SetCellNum(listNum)
end

function RankAwardItem:RefreshAwardCell(index,go)
    if not go then
        return 
    end
    local awardItem
    local awardObj
    if self.AwardObjList[index] then
        awardItem = self.AwardObjList[index].awardItem
        awardObj = self.AwardObjList[index].awardObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not awardItem then
            awardItem = CommonItem.New()
        end 
        awardObj = uiContainer.CommonItem
        self.AwardObjList[index] = {}
        self.AwardObjList[index].awardItem = awardItem
        self.AwardObjList[index].awardObj = awardObj
    end
	local awardItemInfo = ItemConfig.GetItemConfig(self.awardList[index][1])
	awardItemInfo.template_id = self.awardList[index][1]
    awardItem:InitItem(awardObj,awardItemInfo,true)
	self:SetItemCount(awardItem,self.awardList[index][2])
end

function RankAwardItem:SetItemCount(item,count)
	item.node.Level:SetActive(true)
	item.node.Level_txt.text = "x" .. count
end

function RankAwardItem:OnClick_ReceiveReward()
    if self.rankLev >= self.awardInfo.rank_lv then
        self:AddEvent()
        mod.MercenaryHuntFacade:SendMsg("mercenary_reward_list", self.awardInfo.rank_lv)
    end
end

function RankAwardItem:OnReset()

end