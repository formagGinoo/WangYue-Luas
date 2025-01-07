RogueBlessedPanel = BaseClass("RogueBlessedPanel", BasePanel)
--气脉赐福界面

local _insert = table.insert 
local nowPageNum = 8 --当前页签最大8个
local leftRectPos = {minX = 100, maxX = 500, minY = 100, maxY = 800}  --移动卡牌时的位置范围判定
local rightRectPos = {minX = 600, maxX = 1500, minY = 110, maxY = 900}

function RogueBlessedPanel:__init(parent)
    self:SetAsset("Prefabs/UI/WorldRogue/RogueBlessedPanel.prefab")
    self.parent = parent
   
    self.cloneCard = nil --克隆卡牌体
    self.cloneLeftItem = nil --克隆左侧卡牌体
    self.rightCardItems = {}
    self.leftSlideItems = {}

    --右侧 
    self.curPage = 1 --默认打开第一页的卡牌
    self.rightCards = {}--右侧卡牌数据(不带页签结构)
    self.rightItemInfo = {} --右侧的卡牌数据(带页签的结构)
    
    --左侧 
    self.equipCardList = {}--准备要装备的卡牌
    self.leftItemInfo = {} --左侧的卡牌数据
    
    --筛选品质
    self.sortQuality = nil
end

function RogueBlessedPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RogueBlessedPanel:__ShowComplete()

end

function RogueBlessedPanel:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClickClose"))
    self.frontBtn_btn.onClick:AddListener(self:ToFunc("OnClickFrontBtn"))
    self.nextBtn_btn.onClick:AddListener(self:ToFunc("OnClickNextBtn"))
    self.sortBtn_btn.onClick:AddListener(self:ToFunc("OnClickSortPanel"))
    self.nowRoundBtn_btn.onClick:AddListener(self:ToFunc("OnClickNowRound"))
    self.changedBtn_btn.onClick:AddListener(self:ToFunc("OnClickChangedBtn"))
    self.RestartBtn_btn.onClick:AddListener(self:ToFunc("OnClickRestartBtn"))
    EventMgr.Instance:AddListener(EventName.RefreshBySort, self:ToFunc("RefreshBySort"))
end

function RogueBlessedPanel:OnClickClose()
    PanelManager.Instance:ClosePanel(self)
end

function RogueBlessedPanel:__Show()
    self.isRestart = self.args.isRestart
    self.seasonConfig = RoguelikeConfig.GetSeasonData(mod.RoguelikeCtrl:GetSeasonVersionId())
    local equipCards = mod.RoguelikeCtrl:GetCardEquip()
    self.equipCardList = TableUtils.CopyTable(equipCards)

    self.ChangedContent:SetActive(not self.isRestart)
    self.RestartContent:SetActive(self.isRestart)

    self.disCardBlessedMap = {}

    --获取到该事件对应的卡牌组
    self:UpdateUI()
end

function RogueBlessedPanel:__Hide()
    self.equipCardList = {}
end

function RogueBlessedPanel:__delete()
    mod.RoguelikeCtrl:ClearNewCardRed()--清空本地红点逻辑
    EventMgr.Instance:Fire(EventName.CheckRogueRed)
    --销毁克隆体
    self:DeleteCloneCard()
    self:DeleteLeftSlideItem()
    --清理左侧循环列表
    self:ResetLeftScrollView()
    --清理右侧面板
    self:ResetRightPanel()
    EventMgr.Instance:RemoveListener(EventName.RefreshBySort, self:ToFunc("RefreshBySort"))
end

function RogueBlessedPanel:DeleteCloneCard()
    --销毁克隆体
    if self.cloneCard then
        self.cloneCard:DeleteMe()
        self.cloneCard = nil
    end
end

function RogueBlessedPanel:DeleteLeftSlideItem()
    --销毁克隆体
    if self.cloneLeftItem then
        self.cloneLeftItem:DeleteMe()
        self.cloneLeftItem = nil
    end
end

function RogueBlessedPanel:UpdateUI()
    self:UpdateLeft()
    self:UpdateRight()
end

function RogueBlessedPanel:UpdateLeft()
    self.leftItemInfo = {}
    for cardId, count in pairs(self.equipCardList) do
        _insert(self.leftItemInfo, {CardId = cardId, Count = count})
    end
    local num = #self.leftItemInfo
    self:UpdateLeftTitle()
    self:UpdateLeftTop(num)
    self:UpdateLeftScrollView(num)
end

function RogueBlessedPanel:UpdateLeftTitle()
    if self.isRestart then
        self.titleText_txt.text = TI18N("获取新诏令")
    else
        self.titleText_txt.text = TI18N("天工脉符")
    end
end

function RogueBlessedPanel:UpdateLeftTop(num)
    local nowNum = num
    local maxNum = self.seasonConfig.card_buff_max
    self.pulsetxt_txt.text = nowNum..'/'..maxNum
end

function RogueBlessedPanel:UpdateLeftScrollView(num)
    self:ResetLeftScrollView()
    if num > 0 then
        self.noCard:SetActive(false)
        self.leftTab_recyceList:SetLuaCallBack(self:ToFunc("RefreshRankItem"))
        self.leftTab_recyceList:SetCellNum(num)
    else
        self.noCard:SetActive(true)
    end
end

function RogueBlessedPanel:ResetLeftScrollView()
    for i, v in pairs(self.leftSlideItems) do
        if v.class then
            v.class:DeleteMe()
        end
    end
    self.leftSlideItems = {}
    self.leftTab_recyceList:CleanAllCell()
end

--刷新滑动列表
function RogueBlessedPanel:RefreshRankItem(idx, item)
    if not item then
        return
    end

    local card = self.leftItemInfo[idx]
    if not self.leftSlideItems[card.CardId] then
        self.leftSlideItems[card.CardId] = {}
        self.leftSlideItems[card.CardId].obj = item
        local itemInfo = {
            parent = self.cache,
            id = card.CardId,
            num = card.Count,
            isCanDrag = true,
            BeginDragCallBack = self:ToFunc("BeginDragCallBack"),
            OnDragCallBack = self:ToFunc("OnDragCallBack"),
            EndDragCallBack = self:ToFunc("EndDragCallBack"),
        }
        if self.isRestart then
            itemInfo.isCanDrag = false
        end
        self.leftSlideItems[card.CardId].itemInfo = itemInfo
        self.leftSlideItems[card.CardId].class = RogueSlideItem.New(itemInfo, item)
        self.leftSlideItems[card.CardId].node = UtilsUI.GetContainerObject(item)
        self.leftSlideItems[card.CardId].idx = idx
    else
        self.leftSlideItems[card.CardId].class:UpdateUI(card.CardId)
    end
    
end

function RogueBlessedPanel:AmendCardList()
    --先拿卡牌库的数据
    local cardsBag = mod.RoguelikeCtrl:GetCardBag()
    self.rightCards = {}

    if not self.isRestart then
        ----拿卡牌库的所有卡牌 
        for cardId, count in pairs(cardsBag) do
            table.insert(self.rightCards, {cardId = cardId, count = count})
        end
        return
    end

    --重启状态获取本轮的卡牌
    cardsBag = mod.RoguelikeCtrl:GetCurrentRoundCardBag()
    -- 重启状态下把数量全部分开
    for cardId, count in pairs(cardsBag) do
        for i = 1, count do
            -- 只有重启的才需要idx
            table.insert(self.rightCards, {cardId = cardId, count = 1, idx = i})
         end
    end
end

function RogueBlessedPanel:UpdateRight()

    -- 修正卡牌数据
    self:AmendCardList()

    self:UpdateCardsData()
    --更新左侧和右侧按钮
    self:UpdateBtnState()
    --刷新右侧顶部信息
    self:UpdateRightTop()
    --刷新卡牌
    self:UpdateCards()
end

function RogueBlessedPanel:UpdateCardsData()
    self.rightItemInfo = {}
    --做页签筛选
    local index = 0
    local page = 1
    for _, data in pairs(self.rightCards) do
        local cardId = data.cardId
        local count = data.count
        if self.sortQuality then
            local cardConfig = RoguelikeConfig.GetWorldRougeCardConfigById(cardId)
            if cardConfig.quality ~= self.sortQuality then
                goto continue
            end
        end
        
        index = index + 1
        if not self.rightItemInfo[page] then
            self.rightItemInfo[page] = {}
        end
        _insert(self.rightItemInfo[page], {CardId = cardId, Count = count, idx = data.idx or 0})

        if index % nowPageNum == 0 then
            page = page + 1
        end
        
        ::continue::
    end
end

function RogueBlessedPanel:UpdateBtnState()
    --是否有右侧数据
    self.nextBtn:SetActive(self.rightItemInfo[self.curPage + 1] ~= nil)
    self.frontBtn:SetActive(self.rightItemInfo[self.curPage - 1] ~= nil)
    if self.isRestart then
        self:CheckDiscardBlessedUp()
    end
end

function RogueBlessedPanel:UpdateRightTop()
    self.nomarl:SetActive(not self.isRestart)
    self.restart:SetActive(self.isRestart)
    
    if not self.isRestart then
        local num = TableUtils.GetTabelLen(self.rightCards)
        self.totalText_txt.text = TI18N("脉符总览：")..num..'/'..self.seasonConfig.card_show_max
    else
        local maxNum = mod.RoguelikeCtrl:GetDiscardBlessedUp()
        local curNum = TableUtils.GetTabelLen(self.disCardBlessedMap)
        local roundNum = mod.RoguelikeCtrl:GetGameRoundId() - 1
        self.restartTips_txt.text = string.format(TI18N("已获取<#E6FF16>%s</color>次诏令，请选择要【丢失】的脉符<#E6FF16>%s</color>"), roundNum, curNum.."/"..maxNum)
    end
end

function RogueBlessedPanel:UpdateCards()
    if not self.rightItemInfo[self.curPage] then
        self.noCards:SetActive(true)
        return
    end
    self.noCards:SetActive(false)
    for i, v in pairs(self.rightCardItems) do
        if v.class and v.class.object then
            UtilsUI.SetActive(v.class.object, false)
        end
    end
    
    for i, cardInfo in pairs(self.rightItemInfo[self.curPage]) do
        local key = cardInfo.CardId
        local cardNum = cardInfo.Count
        if self.isRestart then
            key = cardInfo.CardId * 10 + cardInfo.idx
            cardNum = 1
        end
        local itemInfo = self:GetRogueCardItemInfo(cardInfo.CardId, cardNum, key)
        
        if not self.rightCardItems[i] then
            self.rightCardItems[i] = {}
            self.rightCardItems[i].itemInfo = itemInfo
            self.rightCardItems[i].class = RogueCardItem.New(self.rightCardItems[i].itemInfo)
        else
            self.rightCardItems[i].itemInfo = itemInfo
            self.rightCardItems[i].class:UpdateUI(itemInfo)
            UtilsUI.SetActive(self.rightCardItems[i].class.object, true)
        end
    end
end

function RogueBlessedPanel:GetRogueCardItemInfo(cardId, num, key)
    local isCardCanDrag = (not self.isRestart) and (not self.equipCardList[cardId])
    
    local itemInfo = {
        parent = self.cardsPanel,
        parentClass = self,
        id = cardId,
        InsKey = key,--重启用
        num = num,
        isCanDrag = isCardCanDrag,
        isEquip = self.equipCardList[cardId] or false,
        clickCallback = self:ToFunc("SelectCardCallback"),
        BeginDragCallBack = self:ToFunc("BeginDragCallBack"),
        OnDragCallBack = self:ToFunc("OnDragCallBack"),
        EndDragCallBack = self:ToFunc("EndDragCallBack"),
    }
    return itemInfo
end

function RogueBlessedPanel:ResetRightPanel()
    for i, v in pairs(self.rightCardItems) do
        if v.class then
            v.class:DeleteMe()
        end
    end
    self.rightCardItems = {}
end

--排序面板调过来的
function RogueBlessedPanel:RefreshBySort(quality)
    --对当前的卡牌库，做筛选
    self.sortQuality = quality
    self.curPage = 1
    self.sortText_txt.text = self.sortQuality and RogueSortPanel.QualityLevel[self.sortQuality] or TI18N("默认排序")
    --刷新当前界面
    self:UpdateRight()
end

function RogueBlessedPanel:CheckDiscardBlessedUp()
    local maxNum = mod.RoguelikeCtrl:GetDiscardBlessedUp()
    local curNum = TableUtils.GetTabelLen(self.disCardBlessedMap)
    local isCanBlessUp = curNum >= maxNum
    if isCanBlessUp then
        self.RestartBtn:SetActive(true)
        self.UnRestartBtn:SetActive(false)
    else
        self.RestartBtn:SetActive(false)
        self.UnRestartBtn:SetActive(true)
    end
    
    return isCanBlessUp
end

function RogueBlessedPanel:CheckSelectCard(insKey)
    local cardId = self.disCardBlessedMap[insKey]
    if cardId then
        return true
    end
    return false
end

function RogueBlessedPanel:SelectCardCallback(cardId, isSelect, insKey)
    if self.isRestart then
        self.disCardBlessedMap[insKey] = isSelect and cardId or nil
        self:UpdateRightTop()
        self:CheckDiscardBlessedUp()
    else
        --(如果是已经加持的)左侧列表锁定到该卡牌的地方 todo  
    end
end

--创建一个slideItem
function RogueBlessedPanel:CreateRogueSlideItem(cardId, isCanDrag)
    local itemInfo = {
        id = cardId,
        num = mod.RoguelikeCtrl:GetCardBagById(cardId),
        parent = self.cache,
        isCanDrag = isCanDrag or false
    }
    
    if self.cloneLeftItem then
        self.cloneLeftItem:UpdateUI(cardId)
        self:ShowRogueItem(self.cloneLeftItem, true) 
        return 
    end
    self.cloneLeftItem = RogueSlideItem.New(itemInfo)
end

--创建一个cardItem
function RogueBlessedPanel:CreateRogueCardItem(cardId, isCanDrag)
    local itemInfo = {
        id = cardId,
        num = mod.RoguelikeCtrl:GetCardBagById(cardId),
        parent = self.cache,
        isCanDrag = isCanDrag or false,
        isEquip = self.equipCardList[cardId] or false
    }
    
    if self.cloneCard then
        self.cloneCard:UpdateUI(itemInfo)
        self:ShowRogueItem(self.cloneCard, true)
        return 
    end
    
    self.cloneCard = RogueCardItem.New(itemInfo)
end

--显影Item
function RogueBlessedPanel:ShowRogueItem(item, isShow)
    if item and item.object then
        UtilsUI.SetActive(item.object, isShow)
    end
end

--设置item的锚点，和位置
function RogueBlessedPanel:SetItemPivotAndPos(object, position)
    --UnityUtils.SetAnchorMinAndMax(object.transform, 0.5, 0.5, 0.5, 0.5)
    --UnityUtils.SetPivot(object.transform, 0.5, 0.5)
    
    local posX, posY = CustomUnityUtils.ScreenPointToLocalPointInRectangle(object.transform, position.x, position.y, ctx.UICamera)
    local acnx = object.transform.localPosition.x + posX
    local acny = object.transform.localPosition.y + posY

    UnityUtils.SetLocalPosition(object.transform, acnx, acny, 0)
end

function RogueBlessedPanel:BeginDragCallBack(data, cardId)
    if not data.pointerCurrentRaycast.gameObject then
        return
    end
    --究竟是clone谁，取决于，开始拖拽的位置
    --如果是在左侧拖，则clone左侧的
    if data.pointerCurrentRaycast.gameObject.name == "slideItemBack_" then
        
        self:CreateRogueSlideItem(cardId)
        self.isDragToLeft = true
    elseif data.pointerCurrentRaycast.gameObject.name == "cardItemBack_" then
        self:CreateRogueCardItem(cardId)
        self.isDragToLeft = false
    end
    --self:SetItemPivotAndPos(self.cache, data.position)
end

function RogueBlessedPanel:OnDragCallBack(data, cardId)
    --drag卡牌的过程中，1.如果检测拖动到左侧，变成左侧的item， 2.如果检测拖动到右侧，变成右侧的card
    --print("拖拽位置", data.position.x, data.position.y)
    if self.cloneCard and self.cloneCard.object then
        if self:IsDragToLeft(data.position) and not self.isDragToLeft then
            --隐藏卡牌
            self:ShowRogueItem(self.cloneCard, false)
            --更新slideItem
            self:CreateRogueSlideItem(cardId)
            --加个标记 -- 0
            self.isDragToLeft = true
        end
    end

    if self.cloneLeftItem and self.cloneLeftItem.object then
        if self:IsDragToRight(data.position) and self.isDragToLeft then
            --隐藏slideItem
            self:ShowRogueItem(self.cloneLeftItem, false)
            --更新cardItem
            self:CreateRogueCardItem(cardId)
            self.isDragToLeft = false
        end
    end
    self:SetItemPivotAndPos(self.cache, data.position)
end

function RogueBlessedPanel:EndDragCallBack(data, cardId)
    --把该卡牌放回池子里
    self:ShowRogueItem(self.cloneLeftItem, false)
    self:ShowRogueItem(self.cloneCard, false)
    
    --获取最后的位置（判断是否在左侧）是->装载卡牌 ，否->不做操作
    if self:IsDragToLeft(data.position) then
        --没有装备过的才去刷新
        if self.equipCardList[cardId] then
            return
        end
        --判断当前是否装载数量超出最大限制
        if self:IsEquipMaxNum() then
            return
        end
        --从卡牌库拿数据
        self.equipCardList[cardId] = mod.RoguelikeCtrl:GetCardBagById(cardId)
        --更新UI
        self:UpdateUIByDrag(cardId)
    elseif self:IsDragToRight(data.position) then
        --从左侧滑到右侧
        if not self.equipCardList[cardId] then
            return 
        end
        self.equipCardList[cardId] = nil
        --更新UI
        self:UpdateUIByDrag(cardId)
    end
    --加个保底，防止显示异常
    UnityUtils.SetLocalPosition(self.cache.transform, 0, -2000, 0)
end

function RogueBlessedPanel:UpdateUIByDrag(cardId)
    self:UpdateLeft()
    self:UpdateCardEquip(cardId)
end

--更新某一个卡牌的Equip
function RogueBlessedPanel:UpdateCardEquip(cardId)
    local isEquip = self.equipCardList[cardId] and true or false
    for i, v in pairs(self.rightCardItems) do  
        if v.itemInfo.id == cardId then
            if self.rightCardItems[i] then
                self.rightCardItems[i].class:SetEquip(isEquip)
                --已经装备的不允许拖拽
                self.rightCardItems[i].class:UpdateDrag(not isEquip)
                return
            end
        end
    end
end

--是否超出最大装载卡牌的数量
function RogueBlessedPanel:IsEquipMaxNum()
    local nowNum = TableUtils.GetTabelLen(self.equipCardList)
    local maxNum = self.seasonConfig.card_buff_max
    if nowNum >= maxNum then
        MsgBoxManager.Instance:ShowTips(TI18N("当前脉符加持已达到上限"))
        return true
    end
    return false
end

--是否移动到左边
function RogueBlessedPanel:IsDragToLeft(pos)
    --这里比较的是屏幕坐标
    local posX = pos.x
    local posY = pos.y
    if posX >= leftRectPos.minX and posX <= leftRectPos.maxX and posY >= leftRectPos.minY and posY <= Screen.height then
        return true
    end
    return false
end

--是否移动到右边
function RogueBlessedPanel:IsDragToRight(pos)
    --这里做了转换，屏幕坐标转localPosition
    local posX, posY = CustomUnityUtils.ScreenPointToLocalPointInRectangle(self.rightBg_rect, pos.x, pos.y, ctx.UICamera)
    local tabPos = self.rightBg_rect.localPosition
    local sizeDelta = self.rightBg.transform.sizeDelta
   
    if posX >= tabPos.x - sizeDelta.x/2 and posX <= tabPos.x + sizeDelta.x/2 and posY >= tabPos.y - sizeDelta.y/2 and posY <= tabPos.y + sizeDelta.y/2 then
        return true
    end
    return false
end

--上一页按钮
function RogueBlessedPanel:OnClickFrontBtn()
    self.curPage = self.curPage - 1
    self:UpdateBtnState()
    self:UpdateCards()
end

--下一页按钮
function RogueBlessedPanel:OnClickNextBtn()
    self.curPage = self.curPage + 1
    self:UpdateBtnState()
    self:UpdateCards()
end

--排序按钮
function RogueBlessedPanel:OnClickSortPanel()
    PanelManager.Instance:OpenPanel(RogueSortPanel)
end

--本轮赐福按钮
function RogueBlessedPanel:OnClickNowRound()
    PanelManager.Instance:OpenPanel(RogueNowRoundBlessPanel)
end

--调整完毕按钮
function RogueBlessedPanel:OnClickChangedBtn()
    if not self.equipCardList then
        return
    end
    
    mod.RoguelikeCtrl:EquipCardList(self.equipCardList)
    
    self:OnClickClose()
end

-- 重启
function RogueBlessedPanel:OnClickRestartBtn()
    mod.RoguelikeCtrl:RoguelikeRestart(self.disCardBlessedMap)
    self:OnClickClose()
    PanelManager.Instance:ClosePanel(RogueCityEvolutionPanel)
    WindowManager.Instance:CloseWindow(WorldRogueMainWindow)
end

