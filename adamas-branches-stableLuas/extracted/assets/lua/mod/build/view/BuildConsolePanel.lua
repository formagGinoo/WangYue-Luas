BuildConsolePanel = BaseClass("BuildConsolePanel", BasePanel)

function BuildConsolePanel:__init(parent)
    self:SetAsset("Prefabs/UI/Build/BuildConsolePanel.prefab")
    self.parentUI = parent
end

function BuildConsolePanel:__BindEvent()

end

function BuildConsolePanel:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("ClosePanel"))
    EventMgr.Instance:AddListener(EventName.BuildConsoleOffLimit, self:ToFunc("ClosePanel"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function BuildConsolePanel:__Show()
end

function BuildConsolePanel:__ShowComplete()
    self.consoleId = self.args.ConsoleId
end

function BuildConsolePanel:__Hide()
end

function BuildConsolePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.BuildConsoleOffLimit, self:ToFunc("ClosePanel"))
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function BuildConsolePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BuildConsolePanel:ClosePanel()
	Fight.Instance.clientFight.buildManager:CloseBuildConsolePanel(self.consoleId)
    self.parentUI:ClosePanel(self)
end

function BuildConsolePanel:OnActionInput(key, value)
    if key == FightEnum.KeyEvent.QuitFly then
        self:ClosePanel()
    elseif key == FightEnum.KeyEvent.Drone_Down then
        EventMgr.Instance:Fire(EventName.BuildConsoleActive, self.consoleId)
    end
end

function BuildConsolePanel:Update()
end