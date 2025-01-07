PrisonCountDownPanel = BaseClass("PrisonCountDownPanel", BasePanel)

function PrisonCountDownPanel:__init()
    self:SetAsset("Prefabs/UI/Crime/PrisonCountDownPanel.prefab")
end

function PrisonCountDownPanel:__BindListener()
    -- EventMgr.Instance:AddListener(EventName.OnBountyValueChange,self:ToFunc("ShowDetail"))
    EventMgr.Instance:AddListener(EventName.OutPrison,self:ToFunc("OnClose"))
end

function PrisonCountDownPanel:__Hide()
end

function PrisonCountDownPanel:__Show()
    self.time = mod.CrimeCtrl:GetPrisonTime()
    self:ShowDetail()
    self:StartTimer()
end

function PrisonCountDownPanel:ShowDetail()
    if self.time == 0 then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
        UtilsUI.SetActiveByScale(self.CountDown,false)
    else
        UtilsUI.SetActiveByScale(self.CountDown,true)
    end
    local minute = math.floor(self.time/60)
    local second = math.floor(self.time%60)
    self.CountDownValue_txt.text = string.format("%02d:%02d",minute,second)
    self.time = self.time - 1
end

function PrisonCountDownPanel:StartTimer()
    self.timer = LuaTimerManager.Instance:AddTimer(0, 1, function ()
        self:ShowDetail()
    end)
end

function PrisonCountDownPanel:OnClose()
    PanelManager.Instance:ClosePanel(self)
end