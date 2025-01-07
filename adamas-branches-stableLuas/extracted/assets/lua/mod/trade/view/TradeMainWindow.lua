TradeMainWindow = BaseClass("TradeMainWindow", BaseWindow)

local DataBagTag = Config.DataBagTag.Find
local DataTradeOrder = Config.DataTradeOrder.Find

function TradeMainWindow:__init()
    self:SetAsset("Prefabs/UI/Trade/TradeMainWindow.prefab")
    self.curCommonItemList = {}
    self.cacheItemContainer = {}
end

function TradeMainWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("OnClickCloseBtn"))
    self.ConsumeBtn_btn.onClick:AddListener(self:ToFunc("OnClickConsumeBtn"))
    self.DevelopBtn_btn.onClick:AddListener(self:ToFunc("OnClickDevelopBtn"))
    self.SellBtn_btn.onClick:AddListener(self:ToFunc("OnClickSellBtn"))
    self.TeachBtn_btn.onClick:AddListener(self:ToFunc("OnClickTeachBtn"))

    self.DebateBtn_btn.onClick:AddListener(self:ToFunc("OnClickDebateBtn"))
    self.NoItemBtn_btn.onClick:AddListener(self:ToFunc("OnClickNoItemBtn"))
    self.DebateSuccessBtn_btn.onClick:AddListener(self:ToFunc("OnClickDebateSuccessBtn"))
    self.DebateFailBtn_btn.onClick:AddListener(self:ToFunc("OnClickDebateFailBtn"))
end

function TradeMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.SetPlacingItem, self:ToFunc("SetPlacingItem"))
    EventMgr.Instance:AddListener(EventName.TradeWindowBargainUpdate, self:ToFunc("UpdateBargainState"))
end

function TradeMainWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function TradeMainWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.SetPlacingItem, self:ToFunc("SetPlacingItem"))
    EventMgr.Instance:RemoveListener(EventName.TradeWindowBargainUpdate, self:ToFunc("UpdateBargainState"))

    if self.rewardCommonItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.rewardCommonItem)
        self.rewardCommonItem = nil
    end

    if self.curCommonItemList then
        for i, v in ipairs(self.curCommonItemList) do
            PoolManager.Instance:Push(PoolType.class, "CommonItem", v)
        end
        self.curCommonItemList = nil
    end

    if self.placingCommonItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.placingCommonItem)
        self.placingCommonItem = nil
    end
end

function TradeMainWindow:__Show()
    self:InitShow()

    self:InitData(self.args.orderId)
end

function TradeMainWindow:__TempShow()
    
end

function TradeMainWindow:InitShow()
    self.Title_txt.text = TI18N("收购")
    
    self.SelectConsumeText_txt.text = DataBagTag[TradeConfig.PageType.Consume.BagPage].name
    self.UnselectConsumeText_txt.text = DataBagTag[TradeConfig.PageType.Consume.BagPage].name
    
    self.SelectDevelopText_txt.text = DataBagTag[TradeConfig.PageType.Develop.BagPage].name
    self.UnselectDevelopText_txt.text = DataBagTag[TradeConfig.PageType.Develop.BagPage].name

    self.RewardTipText_txt.text = TI18N("报酬")
    self.PayTipText_txt.text = TI18N("提供物品")
end

function TradeMainWindow:InitData(orderId)
    if orderId and DataTradeOrder[orderId] then
        local orderInfo = DataTradeOrder[orderId]
        self.orderInfo = orderInfo
        -- 初始化奖励物品
        local rewardId = orderInfo.reward_item_id
        self.rewardCommonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
        local itemInfo = ItemConfig.GetItemConfig(rewardId)
        itemInfo.template_id = rewardId
        self.rewardCommonItem:InitItem(self.RewardCommonItem, itemInfo, true)
        UtilsUI.SetActive(self.rewardCommonItem.node.Num, true)
        self.rewardCommonItem.node.Num_txt.text = itemInfo.name

        local desc = ""

        -- 初始化Tip
        if orderInfo.desc1 then
            desc = desc .. orderInfo.desc1
        end
        if orderInfo.desc2 then
            desc = desc .. "<sprite name=\"start\">"
            desc = desc .. orderInfo.desc2
        end

        self.TalkDesc1_txt.text = desc
        -- 初始化默认列表
        self:SetCurShowScollList(TradeConfig.PageIndex[orderInfo.page])
    else
        LogError("订单为空或者订单在配置表中找不到")
    end

    self:InitCurrencyBar()
    self:UpdateButtons()
end

-- 初始化货币栏
function TradeMainWindow:InitCurrencyBar() 
    local currencyList = TradeConfig.GetCurrencyList()
    for k, v in ipairs(currencyList) do
        
    end
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
    self.currencyBar:init(self.CurrencyBar, 2)
end

function TradeMainWindow:__ShowComplete()
    
end

function TradeMainWindow:OnClickCloseBtn()
    mod.TradeCtrl:ExitTrade()
end

function TradeMainWindow:OnClickConsumeBtn()
    if self.curSelectPage ~= TradeConfig.PageType.Consume then
        self:SetCurShowScollList(TradeConfig.PageType.Consume)
    end
end

function TradeMainWindow:OnClickDevelopBtn()
    if self.curSelectPage ~= TradeConfig.PageType.Develop then
        self:SetCurShowScollList(TradeConfig.PageType.Develop)
    end
end

function TradeMainWindow:SetCurShowScollList(pageType)
    if pageType == TradeConfig.PageType.Consume then
        self:SetConsumePage()
        UtilsUI.SetActive(self.SelectConsumeBtn, true)
        UtilsUI.SetActive(self.UnselectConsumeBtn, false)
        UtilsUI.SetActive(self.SelectDevelopBtn, false)
        UtilsUI.SetActive(self.UnselectDevelopBtn, true)
    elseif pageType == TradeConfig.PageType.Develop then
        self:SetDevelopPage()
        UtilsUI.SetActive(self.SelectConsumeBtn, false)
        UtilsUI.SetActive(self.UnselectConsumeBtn, true)
        UtilsUI.SetActive(self.SelectDevelopBtn, true)
        UtilsUI.SetActive(self.UnselectDevelopBtn, false)
    else
        LogError("收购系统 使用了未配置的字段")
    end

    self.curSelectPage = pageType
end

function TradeMainWindow:SetConsumePage()
    self.curItemList = mod.TradeCtrl:GetBagItemByPageId(TradeConfig.PageType.Consume.BagPage)
    
    local needItemCount = self.orderInfo.need_item_count
    table.sort(self.curItemList, function (a, b)
        if a.count < needItemCount then
            if b.count >= needItemCount then
                return false
            else
                --return a.count < b.count
                return false
            end
        else
            if b.count >= needItemCount then
                --return a.count < b.count
                return false
            else
                return true
            end
        end
        return true
    end)

    self:ReflashScollList()
end

function TradeMainWindow:SetDevelopPage()
    self.curItemList = mod.TradeCtrl:GetBagItemByPageId(TradeConfig.PageType.Develop.BagPage)

    local needItemCount = self.orderInfo.need_item_count
    table.sort(self.curItemList, function (a, b)
        if a.count < needItemCount then
            if b.count >= needItemCount then
                return false
            else
                --return a.count < b.count
                return false
            end
        else
            if b.count >= needItemCount then
                --return a.count < b.count
                return false
            else
                return true
            end
        end
        return true
    end)

    self:ReflashScollList()
end

function TradeMainWindow:ReflashScollList()
    local col = math.floor((self.ItemScollList_rect.rect.width - 20) / 120)
    local row = math.ceil((self.ItemScollList_rect.rect.height - 20) / 120)

    local itemCount = #self.curItemList
    local listNum = itemCount > (col * row) and itemCount or (col * row)

    self.ItemScollList_recyceList:ResetList()
    self.ItemScollList_recyceList:SetLuaCallBack(self:ToFunc("RefreshCell"))
    self.ItemScollList_recyceList:SetCellNum(listNum)
end

function TradeMainWindow:RefreshCell(index, go)
    if not go then
        return
    end

    local itemContainer = UtilsUI.GetContainerObject(go)
    local commonItem
    if self.curCommonItemList[index] then
        commonItem = self.curCommonItemList[index]
    else
        commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
        self.curCommonItemList[index] = commonItem
    end
    
    if index > #self.curItemList then
        commonItem:InitItem(itemContainer.CommonItem, nil)
        UtilsUI.SetActive(itemContainer.SelectItem, false)
        UtilsUI.SetActive(itemContainer.NotEnoughMask, false)
    else
        local itemInstance = self.curItemList[index]
        local itemInfo = ItemConfig.GetItemConfig(itemInstance.template_id)
	    itemInfo.template_id = itemInstance.template_id
        commonItem:InitItem(itemContainer.CommonItem, itemInfo)
        UtilsUI.SetActive(commonItem.node.Num, true)
        commonItem.node.Num_txt.text = itemInstance.count
        if itemInstance.count < self.orderInfo.need_item_count then
            UtilsUI.SetActive(itemContainer.NotEnoughMask, true)
            commonItem:SetBtnEvent(false, function ()
                MsgBoxManager.Instance:ShowTips(TI18N("材料不足"))
            end)
        else
            UtilsUI.SetActive(itemContainer.NotEnoughMask, false)
            commonItem:SetBtnEvent(false, function ()
                mod.TradeCtrl:SetPlacingItem(itemInstance.template_id)
            end)
        end

        -- 判断是否选中
        if self.curSelectItemId and self.curSelectItemId == itemInstance.template_id then
            UtilsUI.SetActive(itemContainer.SelectItem, true)
        else
            UtilsUI.SetActive(itemContainer.SelectItem, false)
        end

        self.cacheItemContainer[itemInstance.template_id] = itemContainer
    end
end

function TradeMainWindow:SetPlacingItem(placingItemId)
    if placingItemId then
        UtilsUI.SetActive(self.PayCommonItem, true)
        UtilsUI.SetActive(self.PayNull, false)

        -- 设置放置的物品
        if not self.placingCommonItem then
            self.placingCommonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
        end
        local itemInfo = ItemConfig.GetItemConfig(placingItemId)
	    itemInfo.template_id = placingItemId
        self.placingCommonItem:InitItem(self.PayCommonItem, itemInfo)
        UtilsUI.SetActive(self.placingCommonItem.node.Num, true)
        self.placingCommonItem.node.Num_txt.text = self.orderInfo.need_item_count
        self.placingCommonItem:SetBtnEvent(false, function ()
            mod.TradeCtrl:SetPlacingItem(nil)
        end)

        -- 选中显示
        local itemContainer
        if self.curSelectItemId then
            itemContainer = self.cacheItemContainer[self.curSelectItemId]
            if itemContainer then
                UtilsUI.SetActive(itemContainer.SelectItem, false)
            end
        end
        self.curSelectItemId = placingItemId
        itemContainer = self.cacheItemContainer[placingItemId]
        if itemContainer then
            UtilsUI.SetActive(itemContainer.SelectItem, true)
        end

        self:SetExtraRewardTips()
    else
        self:SetNullPlacing()
    end

    self:UpdateButtons()
end

function TradeMainWindow:SetNullPlacing()
    UtilsUI.SetActive(self.PayCommonItem, false)
    UtilsUI.SetActive(self.PayNull, true)

    self.rewardCommonItem.node.Num_txt.text = self.rewardCommonItem.itemInfo.name

    UtilsUI.SetActive(self.ExtraRewardTips, false)
    UtilsUI.SetActive(self.ExtraTips, false)

    -- 取消选择显示
    if self.curSelectItemId then
        local itemContainer = self.cacheItemContainer[self.curSelectItemId]
        if itemContainer then
            UtilsUI.SetActive(itemContainer.SelectItem, false)
        end
    end
    self.curSelectItemId = nil

    -- 天平平衡
    self:SetWeightState(TradeEnum.WeightState.Balance)
end

function TradeMainWindow:SetExtraRewardTips()
    local curBasicsRewardNum, curExtraRewardNum, curBargainNum = mod.TradeCtrl:GetCurRewardNum()
    if self.curSelectItemId then
        UtilsUI.SetActive(self.ExtraRewardTips, true)
        if curExtraRewardNum > 0 then
            UtilsUI.SetActive(self.ExtraTips, true)
            self.ExtraTipsText_txt.text = string.format(TI18N("额外+%s"), curExtraRewardNum)
        else
            UtilsUI.SetActive(self.ExtraTips, false)
        end
    else
        UtilsUI.SetActive(self.ExtraRewardTips, false)
    end

    local flag = mod.TradeCtrl:CheckIsBargain()
    if flag then
        if flag == 1 then
            UtilsUI.SetActive(self.BargainSuccessTips, true)
            UtilsUI.SetActive(self.BargainFailTips, false)
            self.BargainSuccessTipsText_txt.text = string.format(TI18N("讲价+%.0f"), curBargainNum)
        else
            UtilsUI.SetActive(self.BargainSuccessTips, false)
            UtilsUI.SetActive(self.BargainFailTips, true)
            self.BargainFailTipsText_txt.text = string.format(TI18N("讲价-%.0f"), -curBargainNum)
        end
    else
        UtilsUI.SetActive(self.BargainSuccessTips, false)
        UtilsUI.SetActive(self.BargainFailTips, false)
    end

    -- 设置天平
    local curRewardSum = curBasicsRewardNum + curExtraRewardNum + curBargainNum
    if self.orderInfo.reward_item_count < curRewardSum then
        self:SetWeightState(TradeEnum.WeightState.Left)
    elseif self.orderInfo.reward_item_count == curRewardSum then
        self:SetWeightState(TradeEnum.WeightState.Balance)
    else
        self:SetWeightState(TradeEnum.WeightState.Right)
    end
    
    self.rewardCommonItem.node.Num_txt.text = math.floor(curRewardSum)
end

function TradeMainWindow:SetWeightState(state)
    if state == TradeEnum.WeightState.Left then
        UtilsUI.SetActive(self.DynamicWeightLeft, true)
        UtilsUI.SetActive(self.DynamicWeightBalance, false)
        UtilsUI.SetActive(self.DynamicWeightRight, false)
    elseif state == TradeEnum.WeightState.Balance then
        UtilsUI.SetActive(self.DynamicWeightLeft, false)
        UtilsUI.SetActive(self.DynamicWeightBalance, true)
        UtilsUI.SetActive(self.DynamicWeightRight, false)
    elseif state == TradeEnum.WeightState.Right then
        UtilsUI.SetActive(self.DynamicWeightLeft, false)
        UtilsUI.SetActive(self.DynamicWeightBalance, false)
        UtilsUI.SetActive(self.DynamicWeightRight, true)
    else
        LogError("设置了错误的秤砣参数")
    end
end

function TradeMainWindow:OnClickSellBtn()
    local curPlacingItemId = mod.TradeCtrl:GetCurPlacingItem()

    if not curPlacingItemId then
        self:ShowTips()
        return
    end

    PanelManager.Instance:OpenPanel(TradeConfirmPanel)
end

function TradeMainWindow:ShowTips()
    MsgBoxManager.Instance:ShowTips(TI18N("未放入材料"))
end

function TradeMainWindow:OnClickTeachBtn()
    BehaviorFunctions.ShowGuideImageTips(TradeConfig.GetTeachId())
end

function TradeMainWindow:UpdateBargainState()
    self:SetExtraRewardTips()

    self:UpdateButtons()
end

function TradeMainWindow:UpdateButtons()
    local flag = mod.TradeCtrl:CheckIsBargain()
    if flag then
        if flag == 1 then
            UtilsUI.SetActive(self.DebateBtn, false)
            UtilsUI.SetActive(self.NoItemBtn, false)
            UtilsUI.SetActive(self.DebateSuccessBtn, true)
            UtilsUI.SetActive(self.DebateFailBtn, false)
        else
            UtilsUI.SetActive(self.DebateBtn, false)
            UtilsUI.SetActive(self.NoItemBtn, false)
            UtilsUI.SetActive(self.DebateSuccessBtn, false)
            UtilsUI.SetActive(self.DebateFailBtn, true)
        end
    else
        if self.curSelectItemId then
            UtilsUI.SetActive(self.DebateBtn, true)
            UtilsUI.SetActive(self.NoItemBtn, false)
            UtilsUI.SetActive(self.DebateSuccessBtn, false)
            UtilsUI.SetActive(self.DebateFailBtn, false)
        else
            UtilsUI.SetActive(self.DebateBtn, false)
            UtilsUI.SetActive(self.NoItemBtn, true)
            UtilsUI.SetActive(self.DebateSuccessBtn, false)
            UtilsUI.SetActive(self.DebateFailBtn, false)
        end
    end

end

function TradeMainWindow:OnClickDebateBtn()
    mod.TradeCtrl:EntryBargain()
end

function TradeMainWindow:OnClickNoItemBtn()
    MsgBoxManager.Instance:ShowTips(TI18N("请放入物品"))
end

function TradeMainWindow:OnClickDebateSuccessBtn()
    MsgBoxManager.Instance:ShowTips(TI18N("讨价已完成"))
end

function TradeMainWindow:OnClickDebateFailBtn()
    MsgBoxManager.Instance:ShowTips(TI18N("讨价已完成"))
end