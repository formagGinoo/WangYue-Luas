RogueNowRoundBlessPanel = BaseClass("RogueNowRoundBlessPanel", BasePanel)

local _inseter = table.insert

function RogueNowRoundBlessPanel:__init(parent)
    self:SetAsset("Prefabs/UI/WorldRogue/RogueNowRoundBlessPanel.prefab")
    self.currentRoundCardBag = {}
    self.cardsItem = {}
end

function RogueNowRoundBlessPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RogueNowRoundBlessPanel:__BindEvent()

end

function RogueNowRoundBlessPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))
end

function RogueNowRoundBlessPanel:__Create()

end

function RogueNowRoundBlessPanel:__Show()
    self:UpdateUI()
end

function RogueNowRoundBlessPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 3, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show()
end

function RogueNowRoundBlessPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function RogueNowRoundBlessPanel:__delete()
    for i, v in pairs(self.cardsItem) do
        if v.class then
            v.class:DeleteMe()
        end
    end
    self.cardsItem = {}
    self.ScrollContent_recyceList:CleanAllCell()
end

function RogueNowRoundBlessPanel:UpdateUI()
    self:UpdateScrollView()
    self:UpdateTips()
end

function RogueNowRoundBlessPanel:UpdateScrollView()
    local roundCards = mod.RoguelikeCtrl:GetCurrentRoundCardBag()--本轮卡牌
    self.currentRoundCardBag = {}
    for cardId, count in pairs(roundCards) do
        for i = 1, count do
            _inseter(self.currentRoundCardBag, cardId)
        end
    end
    --刷新
    self.ScrollContent_recyceList:SetLuaCallBack(self:ToFunc("RefreshRankItem"))
    self.ScrollContent_recyceList:SetCellNum(#self.currentRoundCardBag)
end

function RogueNowRoundBlessPanel:RefreshRankItem(idx, item)
    if not item then 
        return 
    end

    if not self.cardsItem[idx] then
        self.cardsItem[idx] = {}
    end

    local itemInfo = {
        id = self.currentRoundCardBag[idx],
        isCanDrag = false
    }
    self.cardsItem[idx].item = item
    if not self.cardsItem[idx].class then
        self.cardsItem[idx].class = RogueCardItem.New(itemInfo, item)
    else
        self.cardsItem[idx].class:UpdateUI(itemInfo)
    end
end

function RogueNowRoundBlessPanel:UpdateTips()
    local maxNum = 0 --所有区域有多少个进度节点就有多少个卡牌
    
    local allLogicArea = mod.RoguelikeCtrl:GetAreaLogicMaps()
    for i, v in pairs(allLogicArea) do
        local logicCfg = RoguelikeConfig.GetWorldRougeAreaLogic(v.area_logic_id)
        local scheduleRewardConfig = RoguelikeConfig:GetRogueScheduleCardReward(logicCfg.schedule_card_reward_id) --区域奖励配置
        maxNum = maxNum + #scheduleRewardConfig.schedule
    end
    
    self.currentRoundText_txt.text = TI18N("本轮脉符：")..#self.currentRoundCardBag..'/'..maxNum
    --本轮要丢弃的卡牌
    local season_version_id = mod.RoguelikeCtrl:GetSeasonVersionId()
    local seasonData = RoguelikeConfig.GetSeasonData(season_version_id)
    local gameRound = mod.RoguelikeCtrl:GetGameRoundId()
    local reserveNum = RoguelikeConfig.GetCardLoseNumByRestartNum(seasonData.card_reserve_rule, gameRound)
    self.tipsText_txt.text = string.format(TI18N("领取新诏令时需要移除%s张脉符"), reserveNum)
end

function RogueNowRoundBlessPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end
