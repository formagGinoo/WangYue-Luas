MercenaryTaskPanel = BaseClass("MercenaryTaskPanel", BasePanel)


function MercenaryTaskPanel:__init()
	self.DailyHunterAwardObjList = {}
	self.HunterAwardObjList = {}
	self.HunterObjList = {}
	self:SetAsset("Prefabs/UI/MercenaryHunt/MercenaryTaskPanel.prefab")
end

function MercenaryTaskPanel:__BindListener()
	self:BindRedPoint(RedPointName.MercenaryRankReward, self.RedPoint)
	
	UtilsUI.SetHideCallBack(self.MercenaryTaskPanel_Exit, self:ToFunc("Close_CallBack"))
    self.GradeButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenRankRewardPanel"))
	self.DetailsBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenDetailsPanel"))
end

function MercenaryTaskPanel:__BindEvent()
	EventMgr.Instance:AddListener(EventName.UpdateMercenaryRankVal, self:ToFunc("UpdateExpAndLev"))
end

function MercenaryTaskPanel:__CacheObject()
	self.delayShow = self.HunterScroll:GetComponent(LayoutDelayShow)
	--self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function MercenaryTaskPanel:__Create()
    
end

function MercenaryTaskPanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.UpdateMercenaryRankVal, self:ToFunc("UpdateExpAndLev"))
	for k, v in pairs(self.DailyHunterAwardObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end
	for k, v in pairs(self.HunterAwardObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end
	for k, v in pairs(self.HunterObjList) do
		PoolManager.Instance:Push(PoolType.class, "HunterItem", v.hunterItem)
	end
end

function MercenaryTaskPanel:__ShowComplete()
	self:RefreshAwardScroll()
	self:RefreshHunterListScroll()
	-- self.HunterScroll:SetActive(false)
    -- self.HunterScroll:SetActive(true)
end

function MercenaryTaskPanel:__Hide()
end

function MercenaryTaskPanel:__Show()
    self.mainId = mod.MercenaryHuntCtrl:GetMainId()
    self.mainConfig = MercenaryHuntConfig.GetMercenaryHuntMainConfig(self.mainId)
    self.rewardTime = mod.MercenaryHuntCtrl:GetRewardTime()
	self.teachId = self.mainConfig.teach_id
	self.showReward1Id = self.mainConfig.show_reward1
	self.showReward2Id = self.mainConfig.show_reward2
	self.showReward1List = MercenaryHuntConfig.GetItemListByRewardId(self.showReward1Id)
	self.showReward2List = MercenaryHuntConfig.GetItemListByRewardId(self.showReward2Id)
	self.mercenaryData = self:GetMercenaryData()
	--SingleIconLoader.Load(self.GradeButton, self.curRewardData[self.rankLv].icon_path)
    self:UpdateData()
end

function MercenaryTaskPanel:GetMercenaryData()
	self.mercenaryData = {}
	local data = mod.MercenaryHuntCtrl:GetCurCreateMercenaryMap()
	local i = 1
	for k, v in pairs(data) do
		self.mercenaryData[i] = v
		i = i + 1
	end
	return self.mercenaryData
end

function MercenaryTaskPanel:UpdateExpAndLev(lev, exp)
	self.rankExp = exp
	self.rankLev = lev
	self.hasExpToNextLv = MercenaryHuntConfig.GetHasExpToNextLv(self.rankExp)
	self.expToNextLv = MercenaryHuntConfig.GetExpToNextLv(self.rankExp)
end

function MercenaryTaskPanel:GetRewardTime()
    self.rewardTime = mod.MercenaryHuntCtrl:GetRewardTime()
    return self.rewardTime
end

function MercenaryTaskPanel:UpdateData()
	MercenaryTaskPanel:UpdateExpAndLev(mod.MercenaryHuntCtrl.rankLev, mod.MercenaryHuntCtrl.rankExpVal)
	self:UpdateProgress()
	self:UpdateGrade()
end

function MercenaryTaskPanel:UpdateProgress()
	self.ProgressNum_txt.text = self:GetRewardTime() .. "/" .. self.mainConfig.reward_count
	if self.progressList then return end
	self.progressList = {}
	for i = 1, self.mainConfig.reward_count do
		self.progressList[i] = GameObject.Instantiate(self.ProgressIcon,self.Progress.transform)
		self.progressList[i]:SetActive(true)
		self.progressList[i] = UtilsUI.GetContainerObject(self.progressList[i].transform)
	end
	for i = 1, self:GetRewardTime() do
		self.progressList[i].IsComplete:SetActive(true)
	end
end

function MercenaryTaskPanel:UpdateGrade()
	self.LevelText_txt.text = self.rankLev
	if self.expToNextLv == 0 then
		self.ExpText_txt.text = MercenaryHuntConfig.MaxLvText
	else
		self.ExpText_txt.text =  self.hasExpToNextLv .. "/" .. self.expToNextLv
	end
	self.GradeProgressHandle_img.fillAmount = self.expToNextLv ~= 0 and (self.hasExpToNextLv / self.expToNextLv) or 1
end

function MercenaryTaskPanel:RefreshAwardScroll()
    local col = math.ceil((self.DailyAwardScroll_rect.rect.height - 25) / 145)
    local row = 1
    local AwardCount = #self.showReward1List
    local listNum = AwardCount > (col * row) and AwardCount or (col * row)
    self.DailyAwardScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshDailyAwardCell"))
    self.DailyAwardScroll_recyceList:SetCellNum(listNum)

	col = math.ceil((self.HunterAwardScroll_rect.rect.height - 25) / 145)
    AwardCount = #self.showReward2List
    listNum = AwardCount > (col * row) and AwardCount or (col * row)
    self.HunterAwardScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshHunterAwardCell"))
    self.HunterAwardScroll_recyceList:SetCellNum(listNum)
end

function MercenaryTaskPanel:RefreshHunterListScroll()
	-- local col = 1
    -- local row = math.ceil((self.HunterScroll_rect.rect.height - 25) / 145)
	local count = 0
	for k, v in pairs(self.mercenaryData) do
		count = count + 1
	end
    local listNum = count

	if listNum == 0 then 
		UtilsUI.SetActiveByScale(self.Empty,true)
	else
		UtilsUI.SetActiveByScale(self.Empty,false)
	end

    self.HunterScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshHunterCell"))
    self.HunterScroll_recyceList:SetCellNum(listNum)
end

function MercenaryTaskPanel:RefreshDailyAwardCell(index,go)
	MercenaryHuntConfig.RefreshCell(index, go, self.DailyHunterAwardObjList, self.showReward1List)
end

function MercenaryTaskPanel:RefreshHunterAwardCell(index,go)
	MercenaryHuntConfig.RefreshCell(index, go, self.HunterAwardObjList, self.showReward2List)
end

function MercenaryTaskPanel:RefreshHunterCell(index,go)
	if not go or not self.mercenaryData[index] then
        return 
    end

    local hunterItem
    local hunterObj
    if self.HunterObjList[index] then
        hunterItem = self.HunterObjList[index].hunterItem
        hunterObj = self.HunterObjList[index].hunterObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
		hunterItem = PoolManager.Instance:Pop(PoolType.class, "HunterItem")
		if not hunterItem then
			hunterItem = HunterItem.New()
		end
        hunterObj = uiContainer.HunterItem
        self.HunterObjList[index] = {}
        self.HunterObjList[index].hunterItem = hunterItem
        self.HunterObjList[index].hunterObj = hunterObj
    end
	hunterItem:InitHunter(hunterObj, self.mercenaryData[index], true)
end

function MercenaryTaskPanel:OnClick_OpenRankRewardPanel()
	PanelManager.Instance:OpenPanel(RankRewardPanel, {exp = self.rankExp})
end

function MercenaryTaskPanel:OnClick_OpenDetailsPanel()
	BehaviorFunctions.ShowGuideImageTips(self.teachId)
end

function MercenaryTaskPanel:ShowCloseNode()
    self.MercenaryTaskPanel_Exit:SetActive(true)
end

function MercenaryTaskPanel:Close_CallBack()
    self:Hide()
end