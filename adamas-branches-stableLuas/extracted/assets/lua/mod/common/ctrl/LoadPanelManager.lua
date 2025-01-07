LoadPanelManager = SingleClass("LoadPanelManager")

function LoadPanelManager:__init()
    self.panelList = {}
end

function LoadPanelManager:__delete()
    if self.loadTimer then
        LuaTimerManager.Instance:RemoveTimer(self.loadTimer)
        self.loadTimer = nil
    end
end

--LoadPanelManager.Instance:Show(1)LoadPanelManager.Instance:Hide()
function LoadPanelManager:Show(type)
    self.curType = type or SystemConfig.LoadingPageType.Normal
    if WorldSwitchTimeLine.Instance.switchStart then
        return
    end

    AssetManager.UnloadUnusedAssets(true)
    local panel = self:GetPanel(type)
	self.loading = true
    panel:Show()
end

function LoadPanelManager:Hide()
	self.loading = false
    for key, panel in pairs(self.panelList) do
        panel:PlayExitAnim()
    end
    AssetManager.UnloadUnusedAssets(false)
end

function LoadPanelManager:GetPanel(type)
    type = type or self.curType
    if self.panelList[type] == nil then
        if type == SystemConfig.LoadingPageType.Login then
            self.panelList[type] = LoadingPanel.New()
        elseif type == SystemConfig.LoadingPageType.Normal then
            self.panelList[type] = NormalLoadingPanel.New()
        end
    end

    return self.panelList[type]
end

function LoadPanelManager:IsLoading()
	return self.loading
end
--LoadPanelManager.Instance:Progress(0.5, 1)
function LoadPanelManager:Progress(percentage)
    self:GetPanel():Progress(percentage)
end

function LoadPanelManager:FakeLoading(duration, type)
    local time, count = 0, 0
    if self.loadTimer then
        LuaTimerManager.Instance:RemoveTimer(self.loadTimer)
        self.loadTimer = nil
    end
    self:Show(type)
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
