AdventureChangedPanel = BaseClass("AdventureChangedPanel", BasePanel)

AdventureChangedPanel.ShowType = {
    RankTips = 1,
    RankUpTips = 2,
    ExpChanged = 3
}

function AdventureChangedPanel:__init()
    self:SetAsset("Prefabs/UI/SystemMenu/RankTipBoxRe.prefab")
end

function AdventureChangedPanel:__BaseShow()
    
end

function AdventureChangedPanel:__BindEvent()

end

function AdventureChangedPanel:__BindListener()
    UtilsUI.SetHideCallBack(self.CloseMark,self:ToFunc("AnimationEnd"))
end

function AdventureChangedPanel:__delete()

end

function AdventureChangedPanel:__Hide()
    if self.tempTimer then
        LuaTimerManager.Instance.RemoveTimer(self.tempTimer)
    end
    if self.callBack then
        self.callBack()
        self.callBack = nil
    end
end

function AdventureChangedPanel:__Show()
    self.callBack = self.args[1]
    self:SetData(self.args[2], self.args[3])
    self:ShowDetail()
end

function AdventureChangedPanel:AnimationEnd()
    self:Hide()
end

function AdventureChangedPanel:ShowDetail()
    local command = self.command
    if not command then return end
    local rankData = mod.WorldLevelCtrl:GetAdventureInfo()
    if not rankData or not next(rankData) then return end
    
    if command.showType == AdventureChangedPanel.ShowType.RankTips then
        self.RankText_txt.text = InformationConfig.GetSpriteRichText(rankData.lev)
        self.RankTipSwich:SetActive(true)
    elseif command.showType == AdventureChangedPanel.ShowType.RankUpTips then
        self.RankText_txt.text = InformationConfig.GetSpriteRichText(command.oldRank)
        self.RankUpText_txt.text = InformationConfig.GetSpriteRichText(rankData.lev)
        self.RankUpTipSwich:SetActive(true)
    elseif command.showType == AdventureChangedPanel.ShowType.ExpChanged then
        self.RankChangedText_txt.text = InformationConfig.GetSpriteRichText(rankData.lev)
        self.AddExpText_txt.text = "+"..command.addExp.." 探索值"
        self.CurExpText_txt.text = rankData.exp.."/"..InformationConfig.AdventureConfig[rankData.lev].limit_exp
        local limitExp = InformationConfig.AdventureConfig[rankData.lev].limit_exp
        local endX = rankData.exp / limitExp
        local startX = (rankData.exp - command.addExp) / limitExp
        endX = math.min(endX, 1)
        startX = math.min(startX, 1)
        UnityUtils.SetLocalScale(self.effect_rect, startX, 1 ,1)
		self.ExpBarValue_img.fillAmount = startX
		self.ExpChangedSwich:SetActive(true)
        self:ExpBarAnimation(startX, endX)
    end
end

function AdventureChangedPanel:SetData(addExp, oldRank)
    local command = {
        addExp = addExp,
        oldRank = oldRank
    }
    if addExp and oldRank then
        command.showType = AdventureChangedPanel.ShowType.RankUpTips
    elseif addExp and not oldRank then
        command.showType = AdventureChangedPanel.ShowType.ExpChanged
    else
        command.showType = AdventureChangedPanel.ShowType.RankTips
    end
    self.command = command
end

function AdventureChangedPanel:ExpBarAnimation(startX, endX)
    if startX == endX then
        return
    end
    local expTimerCount = 0
    local temp = (endX - startX) / 26
	if self.tempTimer then LuaTimerManager.Instance:RemoveTimer(self.tempTimer) end
    self.tempTimer = LuaTimerManager.Instance:AddTimer(126, 0.01, function ()
        expTimerCount = expTimerCount + 0.01
        if expTimerCount > 1 then
            startX = startX + temp
            UnityUtils.SetLocalScale(self.effect_rect, startX, 1 ,1)
            self.ExpBarValue_img.fillAmount = startX
        end
    end)
end