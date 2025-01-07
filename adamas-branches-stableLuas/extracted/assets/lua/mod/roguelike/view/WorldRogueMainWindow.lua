WorldRogueMainWindow = BaseClass("WorldRogueMainWindow", BaseWindow)

local _insert = table.insert
local maxX = 600
local maxY = 412
local changeY = 90

function WorldRogueMainWindow:__init()
    self:SetAsset("Prefabs/UI/WorldRogue/WorldRogueMainWindow.prefab")
    self.cardItems = {} --左侧赐福卡
    self.cardsId = {}
end

function WorldRogueMainWindow:__CacheObject()
    
end

function WorldRogueMainWindow:__ShowComplete()

end

function WorldRogueMainWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClickClose"))
    self.ruleBtn_btn.onClick:AddListener(self:ToFunc("OnClickRuleBtn"))
    self.shopBtn_btn.onClick:AddListener(self:ToFunc("OnClickShopBtn"))
    self.pulseBtn_btn.onClick:AddListener(self:ToFunc("OnClickPulseBtn"))
    self.rewardBtn_btn.onClick:AddListener(self:ToFunc("OnClickRewardBtn"))
    self.evolutionBtn_btn.onClick:AddListener(self:ToFunc("OnClickEvolutionBtn"))
    
    self:BindRedPoint(RedPointName.RoGueReward,self.rewardRedPoint)
    self:BindRedPoint(RedPointName.RoGueEvolution,self.evolutionRedPoint)
    self:BindRedPoint(RedPointName.RoGueBless,self.pulseRedPoint)
    EventMgr.Instance:AddListener(EventName.EquipCardUpdate, self:ToFunc("UpdateByEquipCard"))
end

function WorldRogueMainWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end

function WorldRogueMainWindow:__Show()
    self.bigTitleIcon:SetActive(false)
    self.mainId = mod.RoguelikeCtrl:GetMainId()
    self.mainConfig = RoguelikeConfig.GetRoguelikeMainConfig(self.mainId)
    self:UpdateSeasonData()
    self:UpdateUI()
end

function WorldRogueMainWindow:__Hide()

end

function WorldRogueMainWindow:__delete()
    self:ResetLeftScrollView()
    if self.rogueCard then
        self.rogueCard:DeleteMe()
        self.rogueCard = nil
    end
    EventMgr.Instance:RemoveListener(EventName.EquipCardUpdate, self:ToFunc("UpdateByEquipCard"))
end

function WorldRogueMainWindow:UpdateByEquipCard()
    self:ResetLeftScrollView()
    self:UpdateLeft()
end

function WorldRogueMainWindow:UpdateUI()
    self:UpdateLeft()
    self:UpdateCenter()
    self:UpdateRight()
end

function WorldRogueMainWindow:UpdateSeasonData()
    self.seasonConfig = RoguelikeConfig.GetSeasonData(mod.RoguelikeCtrl:GetSeasonVersionId())
end

------------
function WorldRogueMainWindow:ResetLeftScrollView()
    for i, v in pairs(self.cardItems) do
        if v.class then
            v.class:DeleteMe()
        end
    end
    self.cardItems = {}
    self.leftTab_recyceList:CleanAllCell()
end

function WorldRogueMainWindow:UpdateLeft()
    local cardEquip = mod.RoguelikeCtrl:GetCardEquip() --已经装备的
    self.cardsId = {}
    for cardId, count in pairs(cardEquip) do
        _insert(self.cardsId, {CardId = cardId, Count = count})
    end
    local num = #self.cardsId

    self:UpdateLeftTop(num)
    if num > 0 then
        self.noCard:SetActive(false)
        self.leftTab_recyceList:SetLuaCallBack(self:ToFunc("RefreshRankItem"))
        self.leftTab_recyceList:SetCellNum(num)
    else
        self.noCard:SetActive(true)
    end
end

function WorldRogueMainWindow:UpdateCenter()
    
end

function WorldRogueMainWindow:UpdateRight()
    self:UpdateRightTop()
    self:UpdateRightBtn()
end

function WorldRogueMainWindow:UpdateLeftTop(num)
    local nowNum = num
    local maxNum = self.seasonConfig.card_buff_max
    self.pulsetxt_txt.text = nowNum..'/'..maxNum
end

function WorldRogueMainWindow:UpdateRightBtn()
   --刷新城市衍化进度
    local logicMap = mod.RoguelikeCtrl:GetAreaLogicMaps()
    local allprogressNum = 0 --目前总进度值
    for i, v in pairs(logicMap) do
        --进度值
        local progressAmount = mod.RoguelikeCtrl:GetAreaEventProgress(v.area_logic_id)
        if progressAmount >= 1 then
            allprogressNum = allprogressNum + 1
        end
    end
    self.progress_txt.text = TI18N("进度   ")..allprogressNum ..'/'..TableUtils.GetTabelLen(logicMap)
end

function WorldRogueMainWindow:UpdateRightTop()
    if self.seasonConfig.icon ~= "" then
        SingleIconLoader.Load(self.bigTitleIcon, self.seasonConfig.icon, function() self.bigTitleIcon:SetActive(true) end)
    end
    self.bigTitleTxt_txt.text = self.seasonConfig.name --赛季名字
    self.seasonTime_txt.text = self.seasonConfig.time --赛季时间
	self.derivationLv_txt.text = mod.RoguelikeCtrl:GetSeasonSchedule() --衍化等级
end

function WorldRogueMainWindow:CreateSlideItem(idx)
    local itemInfo = {
        id = self.cardsId[idx].CardId,
        index = idx, --第几个，方便索引
        num = self.cardsId[idx].Count,
        isCanDrag = false,
        onPointerEnter = self:ToFunc("OnPointerEnter"),
        onPointerExit = self:ToFunc("OnPointerExit")
    }
    return itemInfo
end

--刷新滑动列表
function WorldRogueMainWindow:RefreshRankItem(idx, item)
    if not item then
        return
    end
   
    if not self.cardItems[idx] then
        self.cardItems[idx] = {}
    end
    
    self.cardItems[idx].obj = item
    if not self.cardItems[idx].class then
        self.cardItems[idx].itemInfo = self:CreateSlideItem(idx)
        self.cardItems[idx].class = RogueSlideItem.New(self.cardItems[idx].itemInfo, item)
    else
        self.cardItems[idx].class:UpdateUI(self.cardItems[idx].itemInfo.id)
    end
end

--规则按钮
function WorldRogueMainWindow:OnClickRuleBtn()
    BehaviorFunctions.ShowGuideImageTips(self.mainConfig.teach_id)
end

--肉鸽商店
function WorldRogueMainWindow:OnClickShopBtn()
    
end

--气脉赐福
function WorldRogueMainWindow:OnClickPulseBtn()
    PanelManager.Instance:OpenPanel(RogueBlessedPanel, {})
end

--衍化奖励
function WorldRogueMainWindow:OnClickRewardBtn()
    self.roguePulseRewardPanel = self:OpenPanel(RoguePulseRewardPanel)
end

--城市衍化
function WorldRogueMainWindow:OnClickEvolutionBtn()
    PanelManager.Instance:OpenPanel(RogueCityEvolutionPanel)
end

function WorldRogueMainWindow:OnPointerEnter(data, cardId, index)
    local itemInfo = {
        id = cardId,
        num = mod.RoguelikeCtrl:GetCardBagById(cardId),
        parent = self.cache,
        isCanDrag = false
    }
    if not self.rogueCard then
        self.rogueCard = RogueCardItem.New(itemInfo)
    else
        self.rogueCard:UpdateUI(itemInfo)
    end
    
    self.cache:SetActive(true)
    if self.cardItems[index] then
        self.cardItems[index].class:SelectItem(true)
    end
    
    local maxIndex = index < 8 and index or 8 
    --位置摆在左侧item旁边
    UnityUtils.SetLocalPosition(self.cache.transform, maxX, maxY - (maxIndex * changeY), 0)
end

function WorldRogueMainWindow:OnPointerExit(data, cardId, index)
    self.cache:SetActive(false)
    if self.cardItems[index] then
        self.cardItems[index].class:SelectItem(false)
    end
end