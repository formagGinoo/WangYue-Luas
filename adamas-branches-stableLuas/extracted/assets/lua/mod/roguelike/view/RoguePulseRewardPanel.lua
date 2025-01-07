RoguePulseRewardPanel = BaseClass("RoguePulseRewardPanel", BasePanel)
--衍化奖励界面

local _insert = table.insert
local RewardConfig = Config.DataReward.Find

local Active = Color(246 / 255, 246 / 255, 246 / 255, 1)
local NoActive = Color(57 / 255, 63 / 255, 74 / 255, 1)
local ItemWidth = 220

function RoguePulseRewardPanel:__init(parent)
    self:SetAsset("Prefabs/UI/WorldRogue/RoguePulseRewardPanel.prefab")
    self.parent = parent
   
    self.curSelectToggle = 1
    self.allEventList = {}
    self.eventItemList = {}--事件item
    self.eventRewardIcon = {} --事假奖励icon
    
    --reward
    self.rewardItemList = {}
    self.curSpecialRewardPage = 1 --特殊奖励的页签
    self.specialRewardTb = {}--特殊奖励表
    self.rewardIconListUI = {} --reward奖励icon
end

function RoguePulseRewardPanel:__CacheObject()

end

function RoguePulseRewardPanel:__ShowComplete()

end

function RoguePulseRewardPanel:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("OnClickClose"))
    self.toggleBtn1_tog.onValueChanged:RemoveAllListeners()
    self.toggleBtn2_tog.onValueChanged:RemoveAllListeners()
    self.toggleBtn1_tog.onValueChanged:AddListener(function(isOn)
        self:OnToggleFunc(1, isOn)
    end)
    self.toggleBtn2_tog.onValueChanged:AddListener(function(isOn)
        self:OnToggleFunc(2, isOn)
    end)
    self.rewardTabBtn_btn.onClick:AddListener(self:ToFunc("OnClickRewardTabBtn"))
    self.rewardNextBtn_btn.onClick:AddListener(self:ToFunc("OnClickRewardNextBtn"))
    self.rewardFrontBtn_btn.onClick:AddListener(self:ToFunc("OnClickRewardFrontBtn"))
    EventMgr.Instance:AddListener(EventName.GetSeasonReward, self:ToFunc("UpdateRewardBottom"))
end

function RoguePulseRewardPanel:OnClickClose()
    self.parentWindow:ClosePanel(self)
end

function RoguePulseRewardPanel:__Create()
    
end

function RoguePulseRewardPanel:__Show()
    self.season_version_id = mod.RoguelikeCtrl:GetSeasonVersionId()
    self.seasonConfig = RoguelikeConfig.GetSeasonData(self.season_version_id) --赛季配置
    self.seasonSchedule = mod.RoguelikeCtrl:GetSeasonSchedule() --衍化等级
	self.EventRight:SetActive(false)
    self:OnToggleFunc(self.curSelectToggle, true)
end

function RoguePulseRewardPanel:__Hide()
    self.isFirst = false
end

function RoguePulseRewardPanel:__delete()
    for i, v in pairs(self.rewardIconListUI) do
        ItemManager.Instance:PushItemToPool(v)
    end
    self.rewardIconListUI = {}
    
    self.rewardItemList = {}
    if self.recycleRewardScroll_recyceList then
        self.recycleRewardScroll_recyceList:CleanAllCell()
    end
    self:ResetEventRewardIcon()
    EventMgr.Instance:RemoveListener(EventName.GetSeasonReward, self:ToFunc("UpdateRewardBottom"))
end

--更新奖励界面
function RoguePulseRewardPanel:UpdateRewardPanel()
    self.seasonScheduleRewardGroup = RoguelikeConfig.GetRogueSeasonScheduleRewardGroup(self.season_version_id)
    --获取整个赛季的奖励
    self.rewardTb = {}
    --这里把特殊奖励筛选进特殊奖励表中
    local page = 1
    for i, rewardId in pairs(self.seasonScheduleRewardGroup) do
        local rewardConfig = RoguelikeConfig.GetRogueSeasonScheduleReward(rewardId)
        _insert(self.rewardTb, rewardConfig)
        
        if rewardConfig.special == 1 then
            self.specialRewardTb[page] = rewardConfig
            page = page + 1
        end
    end
    --按衍化等级排序world_change_level
    table.sort(self.rewardTb, function(a, b)
        return a.world_change_level < b.world_change_level
    end)
    
    table.sort(self.specialRewardTb, function(a, b)
        return a.world_change_level < b.world_change_level
    end)
    
    
    self:UpdateBtnState()
    self:UpdateRewardTop()
    self:UpdateRewardCenter()
    self:UpdateRewardBottom()
end

function RoguePulseRewardPanel:UpdateRewardTop()
    self.rewardTitleText_txt.text = self.seasonSchedule
end

function RoguePulseRewardPanel:UpdateRewardCenter()
    local config = self.specialRewardTb[self.curSpecialRewardPage]
    if not config then 
        self.rewardCenter:SetActive(false)
        self.noSpecialReward:SetActive(true)
        return 
    end
    self.rewardCenter:SetActive(true)
    self.noSpecialReward:SetActive(false)
    
    local rewardCfg = RewardConfig[config.reward_id]
    --衍化等级 
    self.rewardLevel_txt.text = TI18N("Lv")..config.world_change_level
    --特殊奖励描述
    self.specialDesText_txt.text = config.dec
    
    for i, v in ipairs(rewardCfg.reward_list) do
        local itemConfig = ItemConfig.GetItemConfig(v[1])
        --奖励名字
        self.rewardName_txt.text = itemConfig.name
        --奖励描述
        self.rewardDesText_txt.text = itemConfig.desc
        --奖励icon 
        local iconPath = ItemConfig.GetItemIcon(v[1])
        if iconPath and iconPath ~= "" then
            SingleIconLoader.Load(self.rewardIcon, iconPath)
        end
        
        break
    end
end

function RoguePulseRewardPanel:UpdateRewardBottom()
    if self.recycleRewardScroll_recyceList then
        local num = #self.rewardTb
        self.recycleRewardScroll_recyceList:SetLuaCallBack(self:ToFunc("OnRewardScroll"))
        self.recycleRewardScroll_recyceList:SetCellNum(num)
    end
end

function RoguePulseRewardPanel:OnRewardScroll(index, go)
    if not go then
        return
    end
    if not self.rewardItemList[index] then
        self.rewardItemList[index] = {}
    end
    self.rewardItemList[index].go = go

    local config = self.rewardTb[index]
    if not config then
        return
    end
    
    self:UpdateRewardItemByScroll(index, go, config)
end

function RoguePulseRewardPanel:UpdateRewardItemByScroll(index, go, config)
    local rewardItem = UtilsUI.GetContainerObject(go)
    local insId = go:GetInstanceID()
    --衍化等级
    rewardItem.level_txt.text = config.world_change_level
    --判断是否领取过
    local isDone = mod.RoguelikeCtrl:CheckGetSeasonScheduleReward(config.world_change_level)
    local isCanGet = mod.RoguelikeCtrl:CheckIsSeasonScheduleRewardCanGet(config.world_change_level)
    rewardItem.select:SetActive(isDone)
    rewardItem.progressBar:SetActive(config.world_change_level <= self.seasonSchedule)
    --当前奖励能领取的最大显示箭头
    rewardItem.jiantou:SetActive(not isDone and isCanGet and config.world_change_level == self.seasonSchedule)

    local rewardList = ItemConfig.GetReward(config.reward_id)
    for i, v in ipairs(rewardList) do
        local itemInfo = {
            template_id = v[1],
            count = v[2],
            acquired = isDone,
            acquiredScale = 0.9
        }
        --还没领取， 但是可以领取的时候
        if not isDone and isCanGet then
            itemInfo.btnFunc = function ()
                self:OnClickGetReward(config.world_change_level)
            end
            --显示特效
            rewardItem.effect:SetActive(true)
            self:RefreshEffectIn(rewardItem.effect)
        else
            rewardItem.effect:SetActive(false)
        end
        
        if not self.rewardIconListUI[insId] then
            self.rewardIconListUI[insId] = ItemManager.Instance:GetItem(rewardItem.iconParent, itemInfo)
        else
            self.rewardIconListUI[insId]:SetItem(itemInfo)
            self.rewardIconListUI[insId]:Show()
        end
        
        break
    end
end


--刷新特效
function RoguePulseRewardPanel:RefreshEffectIn(obj)
    local layer = WindowManager.Instance:GetCurOrderLayer()
    UtilsUI.SetEffectSortingOrder(obj, layer + 1)
end

--更新事件界面
function RoguePulseRewardPanel:UpdateEventPanel()
    self:UpdateEventLeft()
    self:UpdateEventTop()
end

function RoguePulseRewardPanel:UpdateEventLeft()
    --获取当前赛季被玩家发现的事件
    self.allEventList = mod.RoguelikeCtrl:GetSeasonEventMaps()
    self.eventList = {}
    for _, v in pairs(self.allEventList) do
        if v.is_discovered then --只展示已经发现的事件
            _insert(self.eventList, {eventId = v.event_id, isDiscovered = v.is_discovered, time = v.finish_ts})
        end
    end

    table.sort(self.eventList, function(a, b)
        return a.eventId < b.eventId
    end)

    self.eventScrollView_recyceList:SetLuaCallBack(self:ToFunc("RefreshRankItem"))
    self.eventScrollView_recyceList:SetCellNum(#self.eventList)
    
    if not self.isFirst and self.eventList[1] then
        self:OnClickEventItem(1)
        self.isFirst = true
    end
end

function RoguePulseRewardPanel:UpdateEventTop()
    local num = #self.eventList
    local maxNum = self.seasonConfig.event_max
    self.eventTitle_txt.text = num..'/'..maxNum
end

function RoguePulseRewardPanel:RefreshRankItem(idx, item)
    local insId = item:GetInstanceID()
    if not self.eventItemList[insId] then
        self.eventItemList[insId] = {}
        self.eventItemList[insId].obj = item
        self.eventItemList[insId].node = UtilsUI.GetContainerObject(self.eventItemList[insId].obj)
        self.eventItemList[insId].eventId = self.eventList[idx].eventId
    end
    self.eventItemList[insId].node.eventBg_btn.onClick:RemoveAllListeners()
    self.eventItemList[insId].node.eventBg_btn.onClick:AddListener(function()
        self:OnClickEventItem(idx)
    end)
    self:UpdateEventItem(idx, insId)
end

function RoguePulseRewardPanel:UpdateEventItem(idx, insId)
    local eventItem = self.eventItemList[insId].node
    self.eventItemList[insId].eventId = self.eventList[idx].eventId

    if self.selectEventId == self.eventItemList[insId].eventId then
        eventItem.select:SetActive(true)
        eventItem.noSelect:SetActive(false)
        eventItem.eventName_txt.color = Active
    else
        eventItem.select:SetActive(false)
        eventItem.noSelect:SetActive(true)
        eventItem.eventName_txt.color = NoActive
    end
    --刷新item
    local eventConfig = RoguelikeConfig.GetRougelikeEventConfig(self.eventList[idx].eventId)
    --类型
    local eventTypeConfig = RoguelikeConfig.GetRougelikeEventTypeConfig(eventConfig.event_type)
    --名字
    eventItem.eventName_txt.text = eventConfig.name
    --icon
    if eventTypeConfig.icon ~= "" then
        SingleIconLoader.Load(eventItem.noSelectIcon, eventTypeConfig.icon)
    end
    if eventTypeConfig.select_icon ~= "" then
        SingleIconLoader.Load(eventItem.selectIcon, eventTypeConfig.select_icon)
    end
end

function RoguePulseRewardPanel:OnClickEventItem(idx)
    self.EventRight:SetActive(true)
    self.selectEventId = self.eventList[idx].eventId
    for i, v in pairs(self.eventItemList) do
        if v.eventId == self.eventList[idx].eventId then
            v.node.select:SetActive(true)
            v.node.noSelect:SetActive(false)
            v.node.eventName_txt.color = Active
        else
            v.node.select:SetActive(false)
            v.node.noSelect:SetActive(true)
            v.node.eventName_txt.color = NoActive
        end
    end
    --更新右侧事件信息和奖励预览
    self:UpdateEventReward(self.eventList[idx].eventId)
    self:UpdateEventDesc(self.eventList[idx].eventId)
end

function RoguePulseRewardPanel:UpdateEventReward(eventId)
    local eventConfig = RoguelikeConfig.GetRougelikeEventConfig(eventId)
    local rewardCfg = RewardConfig[eventConfig.reward_id]
    --先回收原item
    self:ResetEventRewardIcon()
    
    for i, v in ipairs(rewardCfg.reward_list) do
        local itemInfo = {
            template_id = v[1], 
            count = v[2]
        }
        local item = ItemManager.Instance:GetItem(self.eventContent, itemInfo)
        _insert(self.eventRewardIcon, {item = item})
    end
end

function RoguePulseRewardPanel:UpdateEventDesc(eventId)
    local eventConfig = RoguelikeConfig.GetRougelikeEventConfig(eventId)
    self.eventDes_txt.text = eventConfig.des
    --判断是否是首次完成
    local event = mod.RoguelikeCtrl:GetSeasonEventCompleteTime(eventId)
    if event and event.finish_ts ~= 0 then
        self.firstCompleteTime:SetActive(true)
        local des = string.format(TI18N("第%s次诏令"), mod.RoguelikeCtrl:GetGameRoundId() - 1)
        self.completeTime_txt.text = des..'\n'..os.date("%Y-%m-%d", event.finish_ts)
    else
        self.firstCompleteTime:SetActive(false)
    end
end

function RoguePulseRewardPanel:ResetEventRewardIcon()
    for i, v in pairs(self.eventRewardIcon) do
        if v.item then
            ItemManager.Instance:PushItemToPool(v.item)
        end
    end
    self.eventRewardIcon = {}
end

function RoguePulseRewardPanel:UpdateBtnState()
    --是否有数据
    self.rewardNextBtn:SetActive(self.specialRewardTb[self.curSpecialRewardPage + 1] ~= nil)
    self.rewardFrontBtn:SetActive(self.specialRewardTb[self.curSpecialRewardPage -1] ~= nil)
end

function RoguePulseRewardPanel:OnToggleFunc(selectIndex, isOn)
    self.curSelectToggle = selectIndex
    if self.curSelectToggle == 1 and isOn then
        self.reward:SetActive(true)
        self.event:SetActive(false)
        self:UpdateRewardPanel()
    elseif self.curSelectToggle == 2 and isOn then
        self.reward:SetActive(false)
        self.event:SetActive(true)
        self:UpdateEventPanel()
    end
end

--列表查看
function RoguePulseRewardPanel:OnClickRewardTabBtn()
    --锁定到中间
    local index = self.specialRewardTb[self.curSpecialRewardPage].world_change_level
    if self.recycleRewardScroll_recyceList then
        self.recycleRewardScroll_recyceList:JumpToIndex(index, 5)
    end
end

--往前
function RoguePulseRewardPanel:OnClickRewardFrontBtn()
    self.curSpecialRewardPage = self.curSpecialRewardPage - 1
    self:UpdateBtnState()
    self:UpdateRewardCenter()
end

--往后
function RoguePulseRewardPanel:OnClickRewardNextBtn()
    self.curSpecialRewardPage = self.curSpecialRewardPage + 1
    self:UpdateBtnState()
    self:UpdateRewardCenter()
end

--点击领取赛季奖励
function RoguePulseRewardPanel:OnClickGetReward(level)
    --支持一键领取
    mod.RoguelikeCtrl:GetRoguelikeLvReward(level)
end






