MercenaryTipsPanel = BaseClass("MercenaryTipsPanel", BasePanel)
function MercenaryTipsPanel:__init()
    self:SetAsset("Prefabs/UI/MercenaryHunt/MercenaryTipsPanel.prefab")
	self.TaskHunterAwardObjList = {}
	self.MapHunterAwardObjList = {}
end

function MercenaryTipsPanel:__delete()
	for k, v in pairs(self.TaskHunterAwardObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end

    for k, v in pairs(self.MapHunterAwardObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end
end

function MercenaryTipsPanel:__CacheObject()
    -- self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function MercenaryTipsPanel:__BindListener()
    self:SetHideNode("MercenaryTipsPanel_Exit")
    self:BindCloseBtn(self.BgBtn_btn,self:ToFunc("OnClick_CloseBtn"))
    self:BindCloseBtn(self.BackBg_btn,self:ToFunc("OnClick_CloseBtn"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClick_CloseBtn"))
end

function MercenaryTipsPanel:__Show()
    self:SetCavansLayer(2)
    self.hunterInfo = self.args.hunterInfo
    self.ecoId = self.hunterInfo.ecosystem_id
    self.ecoInfo = MercenaryHuntConfig:GetMercenaryEcoConfig(self.ecoId)
    self.hunterNameList = self.hunterInfo.name_list
    self.hunterLevel = self.hunterInfo.level
    self.mainId = mod.MercenaryHuntCtrl:GetMainId()
    self.mainConfig = MercenaryHuntConfig.GetMercenaryHuntMainConfig(self.mainId)
    self.rewardTime = mod.MercenaryHuntCtrl:GetRewardTime()
    self.isDiscover = self.hunterInfo.discover_state
    self.isChase = self.hunterInfo.chase_state
    self.rewardList = MercenaryHuntConfig.GetItemListByRewardId(self.ecoInfo.reward_id)

    UtilsUI.SetActiveByScale(self.TaskTips, self.args.openType == 0)
    UtilsUI.SetActiveByScale(self.MapTips, self.args.openType == 1)

    self:SetMark()
    self:UpdateData(self.args.openType)
end

function MercenaryTipsPanel:SetMark()
    local hasTime = self.mainConfig.reward_count > self.rewardTime
    self.TaskMark:SetActive(hasTime)
    self.MapMark:SetActive(hasTime)
end

function MercenaryTipsPanel:UpdateData(type)
    if type == 0 then
        self.TaskLevText_txt.text = self.hunterLevel
        self.TaskNameText_txt.text = MercenaryHuntConfig.GetHunterFullName(self.ecoInfo.name_prefix_id, self.ecoInfo.name_id, self.hunterNameList[1], self.hunterNameList[2])
        SingleIconLoader.Load(self.TaskIcon, self.ecoInfo.head_icon)
        self.TaskHunterDesc_txt.text = self.ecoInfo.detail_desc
    elseif type == 1 then
        self.MapLevText_txt.text = self.hunterLevel
        self.MapNameText_txt.text = MercenaryHuntConfig.GetHunterFullName(self.ecoInfo.name_prefix_id, self.ecoInfo.name_id, self.hunterNameList[1], self.hunterNameList[2])
        SingleIconLoader.Load(self.MapIcon, self.ecoInfo.head_icon)
        self.MapHunterDesc_txt.text = self.ecoInfo.detail_desc
    end
end

function MercenaryTipsPanel:RefreshAwardScroll()
    local row = 1
    local AwardCount = #self.rewardList
    if self.args.openType == 0 then
        local col = math.ceil((self.TaskHunterScroll_rect.rect.height - 25) / 145)
        local listNum = AwardCount > (col * row) and AwardCount or (col * row)
        self.TaskHunterScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshTaskAwardCell"))
        self.TaskHunterScroll_recyceList:SetCellNum(listNum)
    elseif self.args.openType == 1 then
        local col = math.ceil((self.MapHunterScroll_rect.rect.height - 25) / 145)
        local listNum = AwardCount > (col * row) and AwardCount or (col * row)
        self.MapHunterScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshMapAwardCell"))
        self.MapHunterScroll_recyceList:SetCellNum(listNum)
    end
end

function MercenaryTipsPanel:__ShowComplete()
    if self.args.openType == 0 then
        if not self.blurBack then
            local setting = { bindNode = self.BlurNode }
            self.blurBack = BlurBack.New(self, setting)
        end
        self:SetActive(false)
        self.blurBack:Show({self:ToFunc("RefreshAwardScroll")})
    elseif self.args.openType == 1 then
        self:RefreshAwardScroll()
    end
end

function MercenaryTipsPanel:RefreshTaskAwardCell(index,go)
	MercenaryHuntConfig.RefreshCell(index, go, self.TaskHunterAwardObjList, self.rewardList)
end

function MercenaryTipsPanel:RefreshMapAwardCell(index,go)
	MercenaryHuntConfig.RefreshCell(index, go, self.MapHunterAwardObjList, self.rewardList)
end

function MercenaryTipsPanel:__Hide()

end

function MercenaryTipsPanel:OnClick_CloseBtn()
    self:Hide()
end
