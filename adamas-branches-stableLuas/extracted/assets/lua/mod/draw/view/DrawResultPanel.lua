DrawResultPanel = BaseClass("DrawResultPanel", BasePanel)

function DrawResultPanel:__init()
    self:SetAsset("Prefabs/UI/Draw/DrawResultPanel.prefab")
    self.newMap = {}
end

function DrawResultPanel:__delete()
    
end

function DrawResultPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DrawResultPanel:__Create()
end

function DrawResultPanel:__BindListener()

end

function DrawResultPanel:__BindEvent()
    self.NextButton_btn.onClick:AddListener(self:ToFunc("OnClickNextButton"))
end

function DrawResultPanel:__Show()
    self.historyInfoList = self.args.historyNumList
    self.curShowIndex = 0

    local num = #self.historyInfoList
    if num > 1 then
        self.JumpButton_btn.onClick:AddListener(self:ToFunc("OnClickCloseButton"))
        self.drawType = DrawEnum.DrawType.Multi
    else
        self.JumpButton_btn.onClick:AddListener(self:ToFunc("OnClickJumpButton"))
        self.drawType = DrawEnum.DrawType.Single
    end

    self.AdditionalItemsTipsText_txt.text = TI18N("额外获得")
    self.TransformItemsTipsText_txt.text = TI18N("转化获得")
    self.TransformItemsNum_txt.text = "X1"
end

function DrawResultPanel:__Hide()
    EventMgr.Instance:Fire(EventName.NoticeQueueActive, false)
    mod.DrawCtrl:SetWaitReward(false)
end

function DrawResultPanel:__ShowComplete()
    self:NextShow()
end

function DrawResultPanel:NextShow()
    self.curShowIndex = self.curShowIndex + 1
    if self.curShowIndex > #self.historyInfoList then
        if self.drawType == DrawEnum.DrawType.Single then
            -- 单抽出
        elseif self.drawType == DrawEnum.DrawType.Multi then
            -- 十连出
            PanelManager.Instance:OpenPanel(DrawResultSummaryPanel, {itemList = self.historyInfoList, newMap = self.newMap})
        end
        -- 结束
        PanelManager.Instance:ClosePanel(self)
        return
    end

    self.curShowInfo = DrawConfig.GetItemInfo(self.historyInfoList[self.curShowIndex].itemId)

    UtilsUI.SetActive(self.ItemInfo, false)
    self.ItemName_txt.text = self.curShowInfo.name
    if self.curShowInfo.type == DrawEnum.DrawItemType.Hero then
        SingleIconLoader.Load(self.AttributeIcon,  self.curShowInfo.elementIconPath, self:ToFunc("ShowAttributeIcon"))
    else
        UtilsUI.SetActive(self.AttributeIcon, false)
    end
    SingleIconLoader.Load(self.ItemVerticalDrawing, self.curShowInfo.stand_icon, self:ToFunc("StartShow"))
    self.canNext = false
end

function DrawResultPanel:StartShow()
    UtilsUI.SetActive(self.ItemVerticalDrawing, true)
    if self.qualityNode then
        UtilsUI.SetActive(self.qualityNode, false)
    end

    self.qualityNode = self["Quality" .. tostring(self.curShowInfo.quality)]
    self.qualityNodeContainer = UtilsUI.GetContainerObject(self.qualityNode)
    self:JumpFirstShow()
end

function DrawResultPanel:OnClickCloseButton()
    if self.showTimer then
        LuaTimerManager.Instance:RemoveTimer(self.showTimer)
        self.showTimer = nil
    end
    self.newMap = {}
    for i = 1, #self.historyInfoList do
        local historyInfo = self.historyInfoList[i]
        if historyInfo.historyNum == 1 then
            self.newMap[historyInfo.itemId] = true
        end
    end

    self.curShowIndex = #self.historyInfoList
    self:NextShow()
end

function DrawResultPanel:OnClickJumpButton()
    if self.state == 1 then
        if self.showTimer then
            LuaTimerManager.Instance:RemoveTimer(self.showTimer)
            self.showTimer = nil
        end
        self:JumpSecondShow()
    elseif self.state == 2 then
        self:NextShow()
    end
end

function DrawResultPanel:OnClickNextButton()
    if self.state == 1 then
        if self.showTimer then
            LuaTimerManager.Instance:RemoveTimer(self.showTimer)
            self.showTimer = nil
        end
        self:JumpSecondShow()
    elseif self.state == 2 then
        if self.canNext then
            if self.showTimer then
                LuaTimerManager.Instance:RemoveTimer(self.showTimer)
                self.showTimer = nil
            end
            self:NextShow()
        end
    end
end

function DrawResultPanel:ShowAttributeIcon()
    UtilsUI.SetActive(self.AttributeIcon, true)
end

function DrawResultPanel:JumpFirstShow()
    self.state = 1
    UtilsUI.SetActive(self.qualityNode, true)
    UtilsUI.SetActive(self.qualityNodeContainer.Start, true)
    UtilsUI.SetActive(self.qualityNodeContainer.End, false)
    self.ItemVerticalDrawing_img.color = Color.black
    UtilsUI.SetActive(self.ItemVerticalDrawing, true)
    UtilsUI.SetActive(self.AdditionalItems, false)
    UtilsUI.SetActive(self.TransformItems, false)

    self.showTimer = LuaTimerManager.Instance:AddTimer(1, 0.7, function ()
        self.showTimer = nil
        self:JumpSecondShow()
    end)
end

function DrawResultPanel:JumpSecondShow()
    self.state = 2
    UtilsUI.SetActive(self.ItemInfo, true)
    UtilsUI.SetActive(self.qualityNodeContainer.Start, false)
    UtilsUI.SetActive(self.qualityNodeContainer.End, true)
    self.ItemVerticalDrawing_img.color = Color.white
    
    local historyInfo = self.historyInfoList[self.curShowIndex]
    if historyInfo.historyNum == 1 then
        UtilsUI.SetActive(self.NewIcon, true)
        self.newMap[historyInfo.itemId] = true
    else
        UtilsUI.SetActive(self.NewIcon, false)
    end

    --LogInfo(string.format("id:%d, 在此之前获得过%d次", historyInfo.itemId, historyInfo.historyNum))

    local extraInfo = historyInfo.extraInfo

    if extraInfo then
        UtilsUI.SetActive(self.AdditionalItems, true)
        local itemInfo = DrawConfig.GetItemInfo(extraInfo.extra_id)
        SingleIconLoader.Load(self.AdditionalItemsIcon, itemInfo.stand_icon)
        self.AdditionalItemsNum_txt.text = "X" .. extraInfo.extra_num
        self.AdditionalItemsName_txt.text = TI18N(itemInfo.name)
    else
        UtilsUI.SetActive(self.AdditionalItems, false)
    end

    local itemInfo = DrawConfig.GetItemInfo(historyInfo.itemId)

    if itemInfo.type == DrawEnum.DrawItemType.Hero and historyInfo.historyNum > 1 and historyInfo.historyNum <= 7 then
        -- 加载挂脉
        UtilsUI.SetActive(self.TransformItems, true)
        local periodItemId = RoleConfig.GetRolePeriodInfo(itemInfo.id, historyInfo.historyNum - 1).item
        local periodItemInfo = DrawConfig.GetItemInfo(periodItemId)
        SingleIconLoader.Load(self.TransformItemsIcon, periodItemInfo.stand_icon)
        self.TransformItemsName_txt.text = TI18N(periodItemInfo.name)
    else
        UtilsUI.SetActive(self.TransformItems, false)
    end

    self.showTimer = LuaTimerManager.Instance:AddTimer(1, 1, function ()
        self.canNext = true
        self.showTimer = nil
    end)
end