DrawContainer = BaseClass("DrawContainer")

function DrawContainer:__init(view)
    self.view = view
    self.cont = {}
    EventMgr.Instance:AddListener(EventName.UpdateDrawGuarantee, self:ToFunc("UpdateDrawGuarantee"))

    self.waitTimer = nil
end

function DrawContainer:__delete()
    self.view = nil
    EventMgr.Instance:RemoveListener(EventName.UpdateDrawGuarantee, self:ToFunc("UpdateDrawGuarantee"))
end

function DrawContainer:PreInit()
    self.viewTransform = self.view.transform
end

function DrawContainer:LoadObj(poolId)
    self.curPoolInfo = DrawConfig.GetPoolInfo(poolId)
    self.curPoolRule = DrawConfig.GetPoolBaseRuleInfo(self.curPoolInfo.group)
    if self.cont[poolId] then
        self.curShowTransform = self.cont[poolId]
        UtilsUI.SetActive(self.curShowTransform, true)
    else
        self.curShowTransform = self.view:GetObject(DrawConfig.GetDrawPrefabPathByPoolId(poolId), self.view.PoolContainer.transform).transform
        self.cont[poolId] = self.curShowTransform
    end
    self.curShowCont = UtilsUI.GetContainerObject(self.curShowTransform)

    self:InitInformation()
    
    self:BindListener()
end

function DrawContainer:UnLoadObj()
    if self.curShowTransform then
        UtilsUI.SetActive(self.curShowTransform, false)
        self:UnLoadListener()
    else
        LogError("还没有加载抽卡内容")
    end
    self.curShowTransform = nil
end

function DrawContainer:BindListener()
    if self.curShowCont.DrawButton1_btn then
        self.curShowCont.DrawButton1_btn.onClick:AddListener(self:ToFunc("OnClickDrawButton1"))
    end
    if self.curShowCont.DrawButton2_btn then
        self.curShowCont.DrawButton2_btn.onClick:AddListener(self:ToFunc("OnClickDrawButton2"))
    end
    if self.curShowCont.CurrencyExchangeButton_btn then
        self.curShowCont.CurrencyExchangeButton_btn.onClick:AddListener(self:ToFunc("OnClickCurrencyExchangeButton"))
    end
    if self.curShowCont.DetailPagesButton_btn then
        self.curShowCont.DetailPagesButton_btn.onClick:AddListener(self:ToFunc("OnClickDetailPagesButton"))
    end
end

function DrawContainer:UnLoadListener()
    if self.curShowCont.DrawButton1_btn then
        self.curShowCont.DrawButton1_btn.onClick:RemoveAllListeners()
    end
    if self.curShowCont.DrawButton2_btn then
        self.curShowCont.DrawButton2_btn.onClick:RemoveAllListeners()
    end
    if self.curShowCont.CurrencyExchangeButton_btn then
        self.curShowCont.CurrencyExchangeButton_btn.onClick:RemoveAllListeners()
    end
    if self.curShowCont.DetailPagesButton_btn then
        self.curShowCont.DetailPagesButton_btn.onClick:RemoveAllListeners()
    end
end

function DrawContainer:OnClickDrawButton1()
    local result, needCount = mod.DrawCtrl:CheckCanDraw(self.curPoolInfo.id, DrawEnum.DrawButton.Draw1)
    if result then
        mod.DrawCtrl:RunDraw(self.curPoolInfo.id, DrawEnum.DrawButton.Draw1)
    elseif needCount then
        PanelManager.Instance:OpenPanel(DrawCurrencyExchangePanel, {drawItemId = self.curPoolInfo.cost_id, drawItemNeedNum = needCount, groupId = self.curPoolInfo.group})
    end
end

function DrawContainer:OnClickDrawButton2()
    local result, needCount = mod.DrawCtrl:CheckCanDraw(self.curPoolInfo.id, DrawEnum.DrawButton.Draw2)
    if result then
        mod.DrawCtrl:RunDraw(self.curPoolInfo.id, DrawEnum.DrawButton.Draw2)
    elseif needCount then
        PanelManager.Instance:OpenPanel(DrawCurrencyExchangePanel, {drawItemId = self.curPoolInfo.cost_id, drawItemNeedNum = needCount, groupId = self.curPoolInfo.group})
    end
end

function DrawContainer:OnClickCurrencyExchangeButton()
    local groupInfo = DrawConfig.GetGroupInfo(self.curPoolInfo.group)
    JumpToConfig.DoJump(groupInfo.jump_id)
end

function DrawContainer:OnClickDetailPagesButton()
    PanelManager.Instance:OpenPanel(DrawDetailPagePanel, {openPage = DrawEnum.DrawDetailPage.BaseRule, poolId = self.curPoolInfo.id})
end

function DrawContainer:UpdateDrawGuarantee(drawGroupId, currentCount, maxCount)
    LuaTimerManager.Instance:AddTimer(1, 0.5, function ()
        if drawGroupId == DrawConfig.GetPoolGroupIdByPoolId(self.curPoolInfo.id) then
            self.curShowCont.ExtractingInformationNumberText_txt.text = string.format("%d/%d", currentCount, maxCount)
        end
    end)
end

function DrawContainer:InitInformation()
    UtilsUI.SetActive(self.curShowCont.ExtractingInformation, true)
    local poolCountInfo = mod.DrawCtrl:GetPoolDrawCount(self.curPoolInfo.id)

    if self.curPoolInfo.type == DrawEnum.DrawPoolType.Normal or self.curPoolInfo.type == DrawEnum.DrawPoolType.LimitTime then
        local currentCount, maxCount = mod.DrawCtrl:GetPoolGroupGuarantee(self.curPoolInfo.group)
        self.curShowCont.ExtractingInformationNormalText_txt.text = TI18N(self.curPoolRule.record_txt)
        if currentCount then
            self.curShowCont.ExtractingInformationNumberText_txt.text = string.format("%d/%d", currentCount, maxCount)
        end
    elseif self.curPoolInfo.type == DrawEnum.DrawPoolType.Novice then
        local maxCount = self.curPoolInfo.count
        self.curShowCont.ExtractingInformationNormalText_txt.text = TI18N("剩余次数")
        self.curShowCont.ExtractingInformationNumberText_txt.text = string.format("%d/%d", poolCountInfo.accumulateCount, maxCount)
    else
        UtilsUI.SetActive(self.curShowCont.ExtractingInformation, false)
    end

    if self.curPoolInfo.daily_limit_count and self.curPoolInfo.daily_limit_count > 0 then
        self.curShowCont.DrawLimitInformationNormalText_txt.text = TI18N("每日限次")
        self.curShowCont.DrawLimitInformationNumberText_txt.text = string.format("%d/%d", poolCountInfo.dailyCount, self.curPoolInfo.daily_limit_count)
        UtilsUI.SetActive(self.curShowCont.DrawLimitInformation, true)
    else
        UtilsUI.SetActive(self.curShowCont.DrawLimitInformation, false)
    end

    self:InitButtons()

    self:InitLine()
end

function DrawContainer:InitLine()
    if self.curPoolRule.short_desc2 then
        UtilsUI.SetActive(self.curShowCont.TwoLine, true)
        UtilsUI.SetActive(self.curShowCont.OneLine, false)
        self.curShowCont.TwoLineText1_txt.text = TI18N(self.curPoolRule.short_desc1)
        self.curShowCont.TwoLineText2_txt.text = TI18N(self.curPoolRule.short_desc2)
    elseif self.curPoolRule.short_desc1 then
        UtilsUI.SetActive(self.curShowCont.TwoLine, false)
        UtilsUI.SetActive(self.curShowCont.OneLine, true)
        self.curShowCont.OneLineText_txt.text = TI18N(self.curPoolRule.short_desc1)
    else
        UtilsUI.SetActive(self.curShowCont.TwoLine, false)
        UtilsUI.SetActive(self.curShowCont.OneLine, false)
    end
end

function DrawContainer:InitButtons()
    local itemInfo = DrawConfig.GetItemInfo(self.curPoolInfo.cost_id)
    if self.curPoolInfo.draw_cnt1 and self.curPoolInfo.draw_cnt1 > 0 then
        self.curShowCont.DrawButton1DrawItemNum_txt.text = string.format("x%d", self.curPoolInfo.draw_cnt1)
        SingleIconLoader.Load(self.curShowCont.DrawButton1Icon, itemInfo.stand_icon, function ()
            UtilsUI.SetActive(self.curShowCont.DrawButton1, true)
        end)
    else
        UtilsUI.SetActive(self.curShowCont.DrawButton1, false)
    end

    if self.curPoolInfo.draw_cnt2 and self.curPoolInfo.draw_cnt2 > 0 then
        self.curShowCont.DrawButton2DrawItemNum_txt.text = string.format("x%d", self.curPoolInfo.draw_cnt2)
        SingleIconLoader.Load(self.curShowCont.DrawButton2Icon, itemInfo.stand_icon, function ()
            UtilsUI.SetActive(self.curShowCont.DrawButton2, true)
        end)
    else
        UtilsUI.SetActive(self.curShowCont.DrawButton2, false)
    end
end