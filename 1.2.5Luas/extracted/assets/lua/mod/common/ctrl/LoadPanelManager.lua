LoadPanelManager = SingleClass("LoadPanelManager")

function LoadPanelManager:__init()

end

function LoadPanelManager:__delete()
    if self.loadTimer then
        LuaTimerManager.Instance:RemoveTimer(self.loadTimer)
        self.loadTimer = nil
    end
end

function LoadPanelManager:Show()
    if self.panel == nil then
        self.panel = LoadingPanel.New()
    end
	self.loading = true
    self.panel:Show()
end

function LoadPanelManager:Hide()
	self.loading = false
    self.panel:Hide()
end

function LoadPanelManager:IsLoading()
	--return false
	return self.loading
end

function LoadPanelManager:Progress(percentage)
    if not self.panel then
        self.panel = LoadingPanel.New()
        self.panel:Show()
    end
    self.panel:Progress(percentage)
end

function LoadPanelManager:FakeLoading(duration)
    local time, count = 0, 0
    if self.loadTimer then
        LuaTimerManager.Instance:RemoveTimer(self.loadTimer)
        self.loadTimer = nil
    end
    self:Show()
    self.loadTimer =  LuaTimerManager.Instance:AddTimer(50, duration / 50, function()
        time = time + 100 / 50
        count = count + 1
        self:Progress(time)
        if count == 50 then
            self:Hide()
            EventMgr.Instance:Fire(EventName.PlayReviveMusic)
        end
    end)
end
