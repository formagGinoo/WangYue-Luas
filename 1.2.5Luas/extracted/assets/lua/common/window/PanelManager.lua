---@class PanelManager
PanelManager = SingleClass("PanelManager")

function PanelManager:__init()
    self.panelList = {}

    self.updatePanel = {}
    self.lowUpdatePanel = {}
end

function PanelManager:OpenPanel(panel, args, cacheMode, preloadAssets)
    if not self.panelList[panel.__className] then
        self.panelList[panel.__className] = panel.New()
        self.panelList[panel.__className]:SetParent(UIDefine.canvasRoot.transform)
        self.panelList[panel.__className]:SetCacheMode(cacheMode or UIDefine.CacheMode.hide)
    end
    if preloadAssets then
        for _, value in pairs(preloadAssets) do
            self.panelList[panel.__className]:AddAsset(value.path,value.type)
        end
    end
    self.panelList[panel.__className]:Show(args)

    self:CheckPanelUpdate(panel.__className)

    EventMgr.Instance:Fire(EventName.OnPanelOpen, panel.__className)
    return self.panelList[panel.__className]
end

function PanelManager:OpenPanelByName(panelName, args, cacheMode)
    local panelClass = _G[panelName]
    if not panelClass then
        return
    end

    if not self.panelList[panelClass.__className] then
        local panel = self.panelList[panelClass.__className] or self:OpenPanel(panelClass, args, cacheMode)
        self.panelList[panelClass.__className] = panel
    else
        self.panelList[panelClass.__className]:Show(args)
    end
    self:CheckPanelUpdate(panelClass.__className)
    EventMgr.Instance:Fire(EventName.OnPanelOpen, panelClass.__className)
    return true
end

function PanelManager:CheckPanelUpdate(className)
    local panel = self.panelList[className]
    if not panel or (not panel.Update and not panel.LowUpdate ) then
        return
    end

    if panel.Update then
        self.updatePanel[className] = panel
    end

    if panel.LowUpdate then
        self.lowUpdatePanel[className] = panel
    end
end

function PanelManager:ClosePanel(panel, isDestroy)
    if self.panelList[panel.__className] and not isDestroy then
        if self.panelList[panel.__className].cacheMode == UIDefine.CacheMode.hide then
            self.panelList[panel.__className]:Hide()
        else
            self.panelList[panel.__className]:Destroy()
            self.panelList[panel.__className] = nil
        end
    end

    self.updatePanel[panel.__className] = nil
    self.lowUpdatePanel[panel.__className] = nil
end

function PanelManager:GetPanel(panel)
    if self.panelList[panel.__className] then
        return self.panelList[panel.__className]
    end
end

function PanelManager:GetPanelByName(name)
    if self.panelList[name] then
        return self.panelList[name]
    end
end

function PanelManager:CloseAllPanel(isDestroy)
    for k, v in pairs(self.panelList) do
        v.cacheMode = (v.cacheMode == UIDefine.CacheMode.hide and isDestroy) and UIDefine.CacheMode.destroy or v.cacheMode
        v:Destroy()
        self.updatePanel[k] = nil
        self.lowUpdatePanel[k] = nil
    end
    self.panelList = {}
end

function PanelManager:Update()
    for _, pnl in pairs(self.updatePanel) do
        pnl:Update()
    end
end

function PanelManager:LowUpdate()
    for _, pnl in pairs(self.lowUpdatePanel) do
        pnl:LowUpdate()
    end
end

