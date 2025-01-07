LevelTipPanel = BaseClass("LevelTipPanel",BasePanel)

function LevelTipPanel:__init()
    self.levelTipManager = Fight.Instance.clientFight.levelTipManager
    self:SetAsset("Prefabs/UI/Fight/LevelTipPanel.prefab")
end

function LevelTipPanel:__BindListener()
    self.CloseButton_btn.onClick:AddListener(self:ToFunc("OnClick_Next"))
    UtilsUI.SetHideCallBack(self.LevelTipPanel_Open, self:ToFunc("OpenEnd"))
    UtilsUI.SetHideCallBack(self.LevelTipPanel_Exit, self:ToFunc("ExitEnd"))
end

function LevelTipPanel:__Show()
    self.showFinish = true
    self.ignoreAlpha = true
    self.LevelTipPanel_Open:SetActive(true)
    self.groupId = self.args
    self:ShowContent(LevelTipConfig.GetInitId(self.groupId))
end

function LevelTipPanel:__Hide()
    self.showFinish = false
    if self.hideUI then
        EventMgr.Instance:Fire(EventName.ShowFightDisplay, true)
        self.hideUI = nil
    end

    self.levelTipManager:BackGroundEnd(self.groupId)
end

function LevelTipPanel:Update()
    if not self.showFinish then
        return
    end
    self.time = self.time - Global.deltaTime

    if self.state == LevelTipConfig.State.Fadein and not self.ignoreAlpha then
        if self.time <= 0 then
            self.state = LevelTipConfig.State.Show
            self:SetAlpha(1)
            self.time = self.data.time
            return
        end
        self:SetAlpha(1 - self.time / LevelTipConfig.FadeTime)
    elseif self.state == LevelTipConfig.State.Show then
        if self.time <= 0 then
            local data, id = LevelTipConfig.GetNextData(self.curId)
            if id then
                self.time = LevelTipConfig.FadeTime
                self.state = LevelTipConfig.State.FadeOut
            else
                self.ignoreAlpha = true
                self.LevelTipPanel_Exit:SetActive(true)
            end
            return
        end
    elseif self.state == LevelTipConfig.State.FadeOut and not self.ignoreAlpha then
        if self.time <= 0 then
            self.time = self.data.wait_time or 0
            self.state = LevelTipConfig.State.Wait
            self:SetAlpha(0)
            return
        end
        self:SetAlpha(self.time / LevelTipConfig.FadeTime)
    elseif self.state == LevelTipConfig.State.Wait then
        if self.time <= 0 then
            local data, id = LevelTipConfig.GetNextData(self.curId)
            self:ShowContent(id)
        end
    end
end

function LevelTipPanel:ShowContent(id)
    self.state = LevelTipConfig.State.Fadein

    self.curId = id;
    local data = LevelTipConfig.GetTipData(id)
    self.data = data
    self.time = LevelTipConfig.FadeTime
    self.Content_txt.text = data.content
    self.CloseButton:SetActive(data.skip_allowed)
    if self.hideUI == nil or self.hideUI ~= data.hide_fight_ui then
        self.hideUI = data.hide_fight_ui
        EventMgr.Instance:Fire(EventName.ShowFightDisplay, not data.hide_fight_ui)
    end
end

function LevelTipPanel:SetAlpha(value)
    --LogError(value)
    self.Content_canvas.alpha = value
end

function LevelTipPanel:OnClick_Next()
    local data = self.data
    if not data.skip_allowed then
        return
    end
    if self.ignoreAlpha then
        return
    end
    if self.state == LevelTipConfig.State.Fadein then
        self.LevelTipPanel_Open:SetActive(false)
        self.ignoreAlpha = false
        self.state = LevelTipConfig.State.Show
        self.time = self.data.time
        self:SetAlpha(1)
    else
        local data, id = LevelTipConfig.GetNextData(self.curId)
        if id then
            self:ShowContent(id)
        else
            self.ignoreAlpha = true
            self.LevelTipPanel_Exit:SetActive(true)
        end
    end
end

function LevelTipPanel:OpenEnd()
    self.ignoreAlpha = false
    self.state = LevelTipConfig.State.Show
    self.time = self.data.time
end

function LevelTipPanel:ExitEnd()
    self:Hide()
end