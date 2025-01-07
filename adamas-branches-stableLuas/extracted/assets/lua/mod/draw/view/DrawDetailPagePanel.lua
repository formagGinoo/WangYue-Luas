DrawDetailPagePanel = BaseClass("DrawDetailPagePanel", BasePanel)

local _tinsert = table.insert

function DrawDetailPagePanel:__init()
    self:SetAsset("Prefabs/UI/Draw/DrawDetailPagePanel.prefab")
end

function DrawDetailPagePanel:__delete()
    if self.showListCommonItem then
        for i, v in ipairs(self.showListCommonItem) do
            PoolManager.Instance:Push(PoolType.class, "CommonItem", v)
        end
        self.showListCommonItem = nil
    end

    EventMgr.Instance:RemoveListener(EventName.UpdateDrawHistory, self:ToFunc("UpdateDrawHistory"))
end

function DrawDetailPagePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DrawDetailPagePanel:__Create()
end

function DrawDetailPagePanel:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("OnClickCloseBtn"))

    self.BasicRulesButton_btn.onClick:AddListener(self:ToFunc("OpenBasicRulesPart"))
    self.DropDetailsButton_btn.onClick:AddListener(self:ToFunc("OpenDropDetailsPart"))
    self.DrawHistoryButton_btn.onClick:AddListener(self:ToFunc("OpenDrawHistoryPart"))
end

function DrawDetailPagePanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.UpdateDrawHistory, self:ToFunc("UpdateDrawHistory"))
end

function DrawDetailPagePanel:__Show()
    self.poolInfo = DrawConfig.GetPoolInfo(self.args.poolId)

    self.BasicRulesButtonSelectText_txt.text = TI18N("基础规则")
    self.BasicRulesButtonUnSelectText_txt.text = TI18N("基础规则")
    self.DropDetailsButtonSelectText_txt.text = TI18N("掉落详情")
    self.DropDetailsButtonUnSelectText_txt.text = TI18N("掉落详情")
    self.DrawHistoryButtonSelectText_txt.text = TI18N("抽取记录")
    self.DrawHistoryButtonUnSelectText_txt.text = TI18N("抽取记录")
end

function DrawDetailPagePanel:__Hide()
end

function DrawDetailPagePanel:__ShowComplete()
    local page = self.args.openPage
    if page == DrawEnum.DrawDetailPage.BaseRule then
        self:OpenBasicRulesPart()
    elseif page == DrawEnum.DrawDetailPage.DropDetails then
        self:OpenDropDetailsPart()
    elseif page == DrawEnum.DrawDetailPage.DrawHistory then
        self:OpenDrawHistoryPart()
    end
end

function DrawDetailPagePanel:OnClickCloseBtn()
    PanelManager.Instance:ClosePanel(self)
end

function DrawDetailPagePanel:OpenBasicRulesPart()
    if self.curPage == DrawEnum.DrawDetailPage.BaseRule then
        return
    end
    self:ClosePart()

    if not self.basicRulesPartIsInit then
        self:InitBasicRulesPart()
    end

    UnityUtils.SetAnchoredPosition(self.BasicRulesPartContent_rect, 0, 0)

    UtilsUI.SetActive(self.BasicRulesPart, true)
    UtilsUI.SetActive(self.BasicRulesButtonSelect, true)
    UtilsUI.SetActive(self.BasicRulesButtonUnSelect, false)
    self.curPage = DrawEnum.DrawDetailPage.BaseRule
end

function DrawDetailPagePanel:InitBasicRulesPart()
    local roleInfo = DrawConfig.GetPoolBaseRuleInfo(self.poolInfo.group)
    self.BasicRulesPartTitleText_txt.text = TI18N("基础规则")
    if roleInfo then
        for _, txt in pairs(roleInfo.text) do
            local go = GameObject.Instantiate(self.BasicRulesPartSection, self.BasicRulesPartContent.transform)
            local cont = UtilsUI.GetContainerObject(go)
            cont.Title_txt.text = txt[1]
            cont.Content_txt.text = txt[2]
            UtilsUI.SetActive(go, true)
        end
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.BasicRulesPartContent.transform)
    UtilsUI.SetActive(self.BasicRulesPartContent, true)
    self.basicRulesPartIsInit = true
end

function DrawDetailPagePanel:OpenDropDetailsPart()
    if self.curPage == DrawEnum.DrawDetailPage.DropDetails then
        return
    end
    self:ClosePart()

    if not self.dropDetailsPartIsInit then
        self:InitDropDetailsPart()
    end

    UnityUtils.SetAnchoredPosition(self.DropDetailsPartContent_rect, 0, 0)
    UtilsUI.SetActive(self.DropDetailsPart, true)
    UtilsUI.SetActive(self.DropDetailsButtonSelect, true)
    UtilsUI.SetActive(self.DropDetailsButtonUnSelect, false)
    self.curPage = DrawEnum.DrawDetailPage.DropDetails
end

function DrawDetailPagePanel:InitDropDetailsPart()
    self.DropShowTitle_txt.text = TI18N("掉落一览")
    local showInfo = DrawConfig.GetPoolShowInfo(self.poolInfo.id)
    local parentTransform = self.DropShowIconGrid.transform
    self.showListCommonItem = {}
    for index, itemId in ipairs(showInfo.show_thing) do
        local go = GameObject.Instantiate(self.DropDetailsPartContentDropIconGridSingleIcon, parentTransform)
        local commonItem = self:LoadCommonItem(itemId, go)
        UtilsUI.SetActive(go, true)        
        _tinsert(self.showListCommonItem, commonItem)
    end

    self.ProbabilityShowTitle_txt.text = TI18N("概率公示")
    local probabilityList = DrawConfig.GetGroupProbability(self.poolInfo.id)
    if probabilityList then
        for index, info in ipairs(probabilityList) do
            local go = GameObject.Instantiate(self.ProbabilityShowListSingle, self.ProbabilityShowList.transform)
            local cont = UtilsUI.GetContainerObject(go)
            cont.ProbabilityShowLeft_txt.text = TI18N(info.name)
            cont.ProbabilityShowRight_txt.text = info.rate_str
            UtilsUI.SetActive(go, true)
        end
    end
    UtilsUI.SetActive(self.DropDetailsPartContent, true)

    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.DropDetailsPartContent.transform)
    end)
    
    self.dropDetailsPartIsInit = true
end

function DrawDetailPagePanel:LoadCommonItem(itemId, go)
    local commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
    local itemInfo = {template_id = itemId, count = 0, scale = 1}
    commonItem:InitItem(go, itemInfo, true)
    UtilsUI.SetActive(commonItem.node.QualityFront, false) 
    return commonItem
end

function DrawDetailPagePanel:OpenDrawHistoryPart()
    if self.curPage == DrawEnum.DrawDetailPage.DrawHistory then
        return
    end
    self:ClosePart()

    if not self.drawHistoryPartIsInit then
        self:InitDrawHistoryPart()
    end

    UtilsUI.SetActive(self.DrawHistoryPart, true)
    UtilsUI.SetActive(self.DrawHistoryButtonSelect, true)
    UtilsUI.SetActive(self.DrawHistoryButtonUnSelect, false)
    self.curPage = DrawEnum.DrawDetailPage.DrawHistory
end

function DrawDetailPagePanel:InitDrawHistoryPart()
    self.DrawHistoryPartTitle_txt.text = TI18N("抽取记录")
    local roleInfo = DrawConfig.GetPoolBaseRuleInfo(self.poolInfo.group)
    self.DrawGuaranteeText1_txt.text = TI18N(roleInfo.record_txt)
    local currentCount, maxCount = mod.DrawCtrl:GetDrawGuarantee(self.poolInfo.group)
    if currentCount and maxCount then
        self.DrawGuaranteeText2_txt.text = string.format("%d/%d", currentCount, maxCount)
    else
        UtilsUI.SetActive(self.DrawGuaranteeText1, false)
        UtilsUI.SetActive(self.DrawGuaranteeText2, false)
    end

    self.historyObjList = {}
    for i = 1, 10 do
        local go = GameObject.Instantiate(self.DrawHistoryPartContentSingle, self.DrawHistoryPartContent.transform)
        local goCont = UtilsUI.GetContainerObject(go)
        _tinsert(self.historyObjList, goCont)
        UtilsUI.SetActive(go, true)
    end
    mod.DrawCtrl:RequestDrawHistory(self.poolInfo.group)

    self.drawHistoryPartIsInit = true
    LogInfo("历史记录初始化")
end

function DrawDetailPagePanel:UpdateDrawHistory(drawGroupId, historyList)
    if self.curPage ~= DrawEnum.DrawDetailPage.DrawHistory then
        return
    end

    if self.poolInfo.group ~= drawGroupId then
        return
    end
    local listLen = #historyList
    local index = 1
    for i = listLen, 1, -1 do
        local history = historyList[i]
        local historyObj = self.historyObjList[index]
        local info = DrawConfig.GetItemInfo(history.item_id)
        string.format("<color=%s>%s</color>", DrawEnum.QualityColor[info.quality], TI18N(info.name))
        historyObj.NameText_txt.text = string.format("<color=%s>%s</color>", DrawEnum.QualityColor[info.quality], TI18N(info.name))
        historyObj.TypeText_txt.text = string.format("<color=%s>%s</color>", DrawEnum.QualityColor[info.quality], TI18N(DrawEnum.DrawItemTypeName[info.type]))
        historyObj.TimeText_txt.text = string.format("<color=%s>%s</color>", DrawEnum.QualityColor[info.quality], self:GetTimeByStamp(history.timestamp))
        index = index + 1
    end
    for i = index, 10, 1 do
        local historyObj = self.historyObjList[i]
        historyObj.NameText_txt.text = ""
        historyObj.TypeText_txt.text = ""
        historyObj.TimeText_txt.text = ""
    end
    LogInfo("历史记录初始化完成")
end

function DrawDetailPagePanel:GetTimeByStamp(timestamp)
    return os.date("%Y-%m-%d %H:%M:%S", timestamp)
end

function DrawDetailPagePanel:ClosePart()
    if self.curPage == DrawEnum.DrawDetailPage.BaseRule then
        UtilsUI.SetActive(self.BasicRulesPart, false)
        UtilsUI.SetActive(self.BasicRulesButtonSelect, false)
        UtilsUI.SetActive(self.BasicRulesButtonUnSelect, true)
    elseif self.curPage == DrawEnum.DrawDetailPage.DropDetails then
        UtilsUI.SetActive(self.DropDetailsPart, false)
        UtilsUI.SetActive(self.DropDetailsButtonSelect, false)
        UtilsUI.SetActive(self.DropDetailsButtonUnSelect, true)
    elseif self.curPage == DrawEnum.DrawDetailPage.DrawHistory then
        UtilsUI.SetActive(self.DrawHistoryPart, false)
        UtilsUI.SetActive(self.DrawHistoryButtonSelect, false)
        UtilsUI.SetActive(self.DrawHistoryButtonUnSelect, true)
    end
end