DrawMainWindow = BaseClass("DrawMainWindow", BaseWindow)

local _tinsert = table.insert

function DrawMainWindow:__init()
    self:SetAsset("Prefabs/UI/Draw/DrawMainWindow.prefab")
    self.curOpenPage = {bigTag = nil, tag = nil}
    self.curPoolContatiner = DrawContainer.New(self)
end

function DrawMainWindow:__delete()
    self.curPoolContatiner:DeleteMe()
    self.curPoolContatiner = nil
    self.curOpenPage = nil

    self.drawItemBarItem:OnCache()
    self.valuableDrawItemBarItem:OnCache()

    self.drawItemBarItem = nil
    self.valuableDrawItemBarItem = nil

    EventMgr.Instance:RemoveListener(EventName.UpdateDraw, self:ToFunc("UpdatePool"))
end

function DrawMainWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DrawMainWindow:__Create()
end

function DrawMainWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("OnClickCloseBtn"))
end

function DrawMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.UpdateDraw, self:ToFunc("UpdatePool"))
end

function DrawMainWindow:__Show()
    self.curPoolContatiner:PreInit()
    self:Init()
end

function DrawMainWindow:__Hide()
end

function DrawMainWindow:__ShowComplete()
    self:InitComplete()
end

function DrawMainWindow:OnClickCloseBtn()
    mod.DrawCtrl:CloseDrawWindow()
end

function DrawMainWindow:Init()
    self.curPools = mod.DrawCtrl:GetCurPoolList()
    self.curTagList = {}
    self.curPoolMapTagList = {}
    local bigTagLen = 1
    local leftPoolTagListContentTransform = self.LeftPoolTagListContent.transform
    local leftPoolTagListContentTransformChildCount = leftPoolTagListContentTransform.childCount
    for bigTagIndex = 1, #self.curPools do
        local group = self.curPools[bigTagIndex]
        -- 依次初始化大Tag
        local bigTag = nil
        if bigTagIndex > leftPoolTagListContentTransformChildCount then
            bigTag = GameObject.Instantiate(self.PoolTagObjectContainer, leftPoolTagListContentTransform)
        else
            bigTag = leftPoolTagListContentTransform:GetChild(bigTagIndex - 1).gameObject
        end
        local bigTagCont = UtilsUI.GetContainerObject(bigTag)
        bigTagCont.gameObject = bigTag
        UnityUtils.SetLocalScale(bigTag.transform, 1, 1, 1)

        -- 大Tag设置信息
        local bigTagInfo = DrawConfig.GetPageInfo(group.tagId)
        bigTagCont.SelectStateText_txt.text = TI18N(bigTagInfo.name)
        bigTagCont.UnSelectStateText_txt.text = TI18N(bigTagInfo.name)
        local curBigTagIndex = bigTagLen

        bigTagCont.SelectStateButton_btn.onClick:RemoveAllListeners()
        bigTagCont.SelectStateButton_btn.onClick:AddListener(function ()
            self:OnClickBigTagButton(curBigTagIndex, false)
        end)
        bigTagCont.UnSelectStateButton_btn.onClick:RemoveAllListeners()
        bigTagCont.UnSelectStateButton_btn.onClick:AddListener(function ()
            self:OnClickBigTagButton(curBigTagIndex, true)
        end)

        UtilsUI.SetActive(bigTag, true)
        
        local poolTagListTransform = bigTagCont.PoolTagList.transform
        local poolTagListTransformChildCount = poolTagListTransform.childCount
        local bigTagObj = { bigTagCont = bigTagCont, tagList = {}, isOpen = false }
        for tagIndex = 1, #group.tagPoolList do
            local pool = group.tagPoolList[tagIndex]

            -- 依次初始化大Tag下的小tag
            local tag = nil
            if tagIndex > poolTagListTransformChildCount then
                tag = GameObject.Instantiate(self.PoolTag, poolTagListTransform)
            else
                tag = poolTagListTransform:GetChild(tagIndex - 1).gameObject
            end
            local tagCont = UtilsUI.GetContainerObject(tag)
            tagCont.gameObject = tag
            UnityUtils.SetLocalScale(tag.transform, 1, 1, 1)

            -- 设置小tag信息
            local groupInfo = DrawConfig.GetGroupInfoByPoolId(pool.id)
            local poolShowInfo = DrawConfig.GetPoolShowInfo(pool.id)

            tagCont.PoolObjectSelectText_txt.text = TI18N(groupInfo.name)
            tagCont.PoolObjectUnSelectText_txt.text = TI18N(groupInfo.name)
            SingleIconLoader.Load(tagCont.PoolObjectSelectIcon, poolShowInfo.tab_icon2)
            SingleIconLoader.Load(tagCont.PoolObjectUnSelectIcon, poolShowInfo.tab_icon1)

            local curTagIndex = tagIndex
            tagCont.PoolTagUnSelectButton_btn.onClick:RemoveAllListeners()
            tagCont.PoolTagUnSelectButton_btn.onClick:AddListener(function()
                self:OnClickTagButton(curBigTagIndex, curTagIndex)
            end)

            UtilsUI.SetActive(tagCont.PoolTagSelectButton, false)
            UtilsUI.SetActive(tagCont.PoolTagUnSelectButton, true)

            UtilsUI.SetActive(tag, true)
            _tinsert(bigTagObj.tagList, { tagCont = tagCont, poolId = pool.id})

            self.curPoolMapTagList[pool.id] = { bigTagIndex = bigTagIndex, tagIndex = tagIndex}
        end

        local poolTagListTransformChildCount = poolTagListTransform.childCount - 1
        for i = #group.tagPoolList, poolTagListTransformChildCount do
            UtilsUI.SetActive(poolTagListTransform:GetChild(i), false)
        end
        
        UtilsUI.SetActive(bigTagCont.SelectState, false)
        UtilsUI.SetActive(bigTagCont.UnSelectState, true)

        _tinsert(self.curTagList, bigTagObj)
        bigTagLen = bigTagLen + 1
    end

    leftPoolTagListContentTransformChildCount = leftPoolTagListContentTransform.childCount - 1
    for i = #self.curPools, leftPoolTagListContentTransformChildCount do
        UtilsUI.SetActive(leftPoolTagListContentTransformChildCount:GetChild(i), false)
    end

    UtilsUI.SetActive(self.LeftPoolTagList, true)
    if #self.curTagList > 0 and #self.curTagList[1].tagList > 0 then
        self.canDraw = true
    else
        self.canDraw = false
    end
end

function DrawMainWindow:OnClickBigTagButton(bigTagIndex, isOpen)
    local bigTagObj = self.curTagList[bigTagIndex]
    if bigTagObj.isOpen == isOpen then
        LogError("[抽卡] 逻辑错误")
        return
    end
    if isOpen then
        UtilsUI.SetActive(bigTagObj.bigTagCont.UnSelectState, false)
        UtilsUI.SetActive(bigTagObj.bigTagCont.SelectState, true)
        
        for _, tag in ipairs(bigTagObj.tagList) do
            UtilsUI.SetActive(tag.tagCont.PoolTagSelectButton, false)
            UtilsUI.SetActive(tag.tagCont.PoolTagUnSelectButton, true)
        end

    else
        UtilsUI.SetActive(bigTagObj.bigTagCont.SelectState, false)
        UtilsUI.SetActive(bigTagObj.bigTagCont.UnSelectState, true)

    end

    bigTagObj.isOpen = isOpen

    if self.curOpenPage and self.curOpenPage.bigTag == bigTagIndex then
        self:OnClickTagButton(bigTagIndex, self.curOpenPage.tag)
    end
    
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.LeftPoolTagListContent.transform)
end

function DrawMainWindow:OnClickTagButton(bigTagIndex, tagIndex)
    local bigTagObj = self.curTagList[bigTagIndex]
    if not bigTagObj.isOpen then
        LogError("大页签还没有打开")
        return
    end
    if self.curOpenPage then
        if self.curOpenPage.bigTag and self.curOpenPage.tag then
            self.curPoolContatiner:UnLoadObj()
            local lastBigTagObj = self.curTagList[self.curOpenPage.bigTag]
            local tagObj = lastBigTagObj.tagList[self.curOpenPage.tag]
            UtilsUI.SetActive(tagObj.tagCont.PoolTagSelectButton, false)
            UtilsUI.SetActive(tagObj.tagCont.PoolTagUnSelectButton, true)
        end
    else
        self.curOpenPage = {}
    end
    local tag = bigTagObj.tagList[tagIndex]
    self.curPoolContatiner:LoadObj(tag.poolId)
    self.curOpenPage.bigTag = bigTagIndex
    self.curOpenPage.tag = tagIndex
    self.curOpenPage.poolId = tag.poolId

    UtilsUI.SetActive(tag.tagCont.PoolTagUnSelectButton, false)
    UtilsUI.SetActive(tag.tagCont.PoolTagSelectButton, true)    

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.LeftPoolTagListContent.transform)

    self:ReflashCurrencyBar()
end

function DrawMainWindow:ReflashCurrencyBar()
    if self.valuableDrawItemBarItem then
        self.valuableDrawItemBarItem:UpdateCurrencyCount()
    else
        self.valuableDrawItemBarItem = Fight.Instance.objectPool:Get(CurrencyBar)
        self.valuableDrawItemBarItem:init(self.ValuableDrawItemBar, DrawConfig.ValuableDrawItemId)
        UtilsUI.SetActive(self.ValuableDrawItemBar, true)
    end

    if self.drawItemBarItem then
        local bigTagObj = self.curTagList[self.curOpenPage.bigTag]
        if not bigTagObj then
            UtilsUI.SetActive(self.ValuableDrawItemBar, false)
        end
        local tagObj = bigTagObj.tagList[self.curOpenPage.tag]
        if not tagObj then
            UtilsUI.SetActive(self.ValuableDrawItemBar, false)
        end
        
        self.drawItemBarItem:ChangeCurrencyId(DrawConfig.GetPoolCostItem(tagObj.poolId))
    else
        self.drawItemBarItem = Fight.Instance.objectPool:Get(CurrencyBar)
        local bigTagObj = self.curTagList[self.curOpenPage.bigTag]
        local tagObj = bigTagObj.tagList[self.curOpenPage.tag]

        self.drawItemBarItem:init(self.DrawItemBar, DrawConfig.GetPoolCostItem(tagObj.poolId))
        UtilsUI.SetActive(self.ValuableDrawItemBar, true)
    end
end

function DrawMainWindow:InitComplete()
    if self.canDraw then
        self:OnClickBigTagButton(1, true)
        self:OnClickTagButton(1, 1)
    end
end

function DrawMainWindow:UpdatePool()
    if self.curPoolContatiner then
        self.curPoolContatiner:UnLoadObj()
    end

    self:Init()

    if self.curOpenPage then
        local poolId = self.curOpenPage.poolId
        self.curOpenPage = nil
        local tagInfo = self.curPoolMapTagList[poolId]
        if tagInfo then
            self:OnClickBigTagButton(tagInfo.bigTagIndex, true)
            self:OnClickTagButton(tagInfo.bigTagIndex, tagInfo.tagIndex)
        else
            self:InitComplete()
        end
    else
        self:InitComplete()
    end
end