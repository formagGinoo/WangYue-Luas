---@class TipQueueManger
TipQueueManger = BaseClass("TipQueueManger")

function TipQueueManger:__init(fight)
    self.fight = fight
    self.tipQueue = {}
    self.centerQueue = {}
    self.waitTimer = nil
    self.delayTimer = nil
    self.isPause = false
    self:_BindEvent()
end

TipQueueManger.TipPriority = {
    Default = 1,
    CommonTip = 2,
    MapTitle = 9,
    Adventure = 10,
    DefaultWorldTitle = 20,
}

function TipQueueManger:_BindEvent()
    EventMgr.Instance:AddListener(EventName.AddCenterContent, self:ToFunc("AddCenterContent"))
    EventMgr.Instance:AddListener(EventName.ShowCommonTitle, self:ToFunc("ShowCommonTitle"))
    EventMgr.Instance:AddListener(EventName.AdventureChange, self:ToFunc("AdventureChange"))
    EventMgr.Instance:AddListener(EventName.PauseByOpenWindow, self:ToFunc("Pause"))
    EventMgr.Instance:AddListener(EventName.ResumeByCloseWindow, self:ToFunc("Resume"))
end

function TipQueueManger:_RemoveEvent()
    EventMgr.Instance:RemoveListener(EventName.AddCenterContent, self:ToFunc("AddCenterContent"))
    EventMgr.Instance:RemoveListener(EventName.ShowCommonTitle, self:ToFunc("ShowCommonTitle"))
    EventMgr.Instance:RemoveListener(EventName.AdventureChange, self:ToFunc("AdventureChange"))
    EventMgr.Instance:RemoveListener(EventName.PauseByOpenWindow, self:ToFunc("Pause"))
    EventMgr.Instance:RemoveListener(EventName.ResumeByCloseWindow, self:ToFunc("Resume"))
end

function TipQueueManger:__delete()
    if self.waitTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitTimer)
        self.waitTimer = nil
    end

    self:ClearDelayTimer()

    self.tipQueue = nil
    self:_RemoveEvent()
end

function TipQueueManger:Pause()
    if self.isPause == true then
        return
    end
    self.isPause = true
    self:ClearDelayTimer()
    if self.curPanel then
        self.curPanel:Hide()
    end
end

function TipQueueManger:Resume()
    if self.isPause == false then
        return
    end
    self.isPause = false
    self:ShowTopContent()
end

function TipQueueManger:ClearDelayTimer()
    if self.delayTimer then
        LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
        self.delayTimer = nil
    end
end

function TipQueueManger:IsPause()
    return self.isPause or false
end

function TipQueueManger:ShowCommonTitle(type, title, default, icon)
    local priority = TipQueueManger.TipPriority.DefaultWorldTitle
    if type == WorldTitlePanel.TitleType.Map then
        priority = TipQueueManger.TipPriority.MapTitle
    end
    self:AddTopContent(WorldTitlePanel, priority, type, title, default, icon)
end

function TipQueueManger:AdventureChange(addExp, oldRank)
     for index, value in ipairs(self.tipQueue) do
         if value.panelType == AdventureChangedPanel then
            if addExp then
                value.config[2] = value.config[2] or addExp
                value.config[2] = value.config[2] + addExp
            end
             value.config[3] = value.config[3] or oldRank
             return
         end
    end
    local priority = TipQueueManger.TipPriority.Adventure
    self:AddTopContent(AdventureChangedPanel, priority, addExp, oldRank)
end

function TipQueueManger:AddTopContent(panelType,priority, ...)
    local callBack = self:ToFunc("TopHideCallBack")
	local data = {panelType = panelType, priority = priority, config = {callBack, ...}}
	table.insert(self.tipQueue, data)
    table.sort(self.tipQueue, function (a, b)
        return a.priority > b.priority
    end)

    if not self.isDisplay and not self.delayTimer and not self:IsPause() then
        self.delayTimer = LuaTimerManager.Instance:AddTimer(1, 0.5, function ()
            self:ShowTopContent()
            self:ClearDelayTimer()
        end)
    end
end

function TipQueueManger:ShowTopContent()
    if self.tipQueue and next(self.tipQueue) then
        self.isDisplay = true
        local data = table.remove(self.tipQueue, 1)
        self.curPanel = PanelManager.Instance:OpenPanel(data.panelType, data.config)
    end
end

function TipQueueManger:TopHideCallBack()
    if self.waitTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitTimer)
        self.waitTimer = nil
    end
    if self.tipQueue and next(self.tipQueue) and not self:IsPause() then
        self.waitTimer = LuaTimerManager.Instance:AddTimer(1, 0, function ()
            self:ShowTopContent()
        end)
    else
        self.isDisplay = false
    end
end

--不受窗口暂停影响
function TipQueueManger:AddCenterContent(panelType, priority, config)
    config = config or {}
    local callback = self:ToFunc("CenterHideCallBack")
    config.callback = callback
	local data = {panelType = panelType, priority = priority, config = config}
	table.insert(self.centerQueue, data)
    table.sort(self.centerQueue, function (a, b)
        return a.priority > b.priority
    end)
    if not self.isCenterDisplay then
        self:ShowCenterContent()
    end
end

function TipQueueManger:ShowCenterContent()
    if self.centerQueue and next(self.centerQueue) then
        self.isCenterDisplay = true
        local data = table.remove(self.centerQueue, 1)
        self.curPanel = PanelManager.Instance:OpenPanel(data.panelType, data.config)
    end
end

function TipQueueManger:CenterHideCallBack()
    self.isCenterDisplay = false
    self:ShowCenterContent()
end
