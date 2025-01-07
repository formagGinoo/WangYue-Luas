FindHuntTipPanel = BaseClass("FindHuntTipPanel", BasePanel)

function FindHuntTipPanel:__init()
    self:SetAsset("Prefabs/UI/MercenaryHunt/FindHuntTipPanel.prefab")
end

function FindHuntTipPanel:__CacheObject()
    self.challengeEndNode = UtilsUI.GetContainerObject(self.ChallengeEndPart.transform)
end

function FindHuntTipPanel:__BindListener()
    self.DetailBtn_btn.onClick:AddListener(self:ToFunc("ClickDetailBtn"))
end

function FindHuntTipPanel:ClickDetailBtn()
    
end

function FindHuntTipPanel:__Show()
    self.type = self.args[1]
    self.tipId = self.args[2]
    self.hunterName = self.args[3]

    self.DiscoverContent:SetActive(false)
    self.ChallengeEndPart:SetActive(false)
    self.challengeEndNode.Finish:SetActive(false)

    self:UpdateView()

    local timerFunc = function ()
        if self.timer then
            LuaTimerManager.Instance:RemoveTimer(self.timer)
            self.timer = nil
        end
        PanelManager.Instance:ClosePanel(self)
    end
    self.timer = LuaTimerManager.Instance:AddTimer(1, 5, timerFunc)
end

function FindHuntTipPanel:__Hide()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end

    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        EventMgr.Instance:Fire(EventName.CloseHuntTip)
    end)
end

function FindHuntTipPanel:__delete()
end

function FindHuntTipPanel:UpdateView()
    local tipCfg = MercenaryHuntConfig.GetMercenaryTip(self.tipId)
    if self.type == MercenaryHuntConfig.ShowTipType.Discover then
        self.DiscoverContent:SetActive(true)
        self.TitleTip_txt.text = tipCfg.tip
        self.Name_txt.text = self.hunterName
    elseif self.type == MercenaryHuntConfig.ShowTipType.Fight then
        self.ChallengeEndPart:SetActive(true)
        self.challengeEndNode.DefTip_txt.text = TI18N("击败猎手")
        self.challengeEndNode.Title_txt.text = self.hunterName
    end

end