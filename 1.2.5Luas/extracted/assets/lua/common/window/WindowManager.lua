---@class WindowManager
WindowManager = SingleClass("WindowManager")

function WindowManager:__init()
    self.windows = {}
    self.orderLayer = 10
    self.curWindow = nil
    self.readyOpenWin = nil
    self.readyCloseWin = nil
    self.windowList = {}
    self.pauseCount = 0

    self.updateWindows = {}
    self.lowUpdateWindows = {}
end

--此方法禁止外部直接调用
function WindowManager:RemoveWindow(windowName)
    self.windows[windowName] = nil
    self.updateWindows[windowName] = nil
    self.lowUpdateWindows[windowName] = nil
end

--通过窗口Id打开窗口
function WindowManager:OpenWindowById(id,args)
    if WindowDefine.OpenFunc[id] then
        WindowDefine.OpenFunc[id](args)
    elseif WindowDefine.WinIDToName[id] then
        self:OpenWindowByName(WindowDefine.WinIDToName[id],args)
    else
        assert(facade,string.format("打开窗口异常,无法找到映射信息[id:%s]",id))
    end
end

--打开窗口
function WindowManager:OpenWindow(win,args,isCache,ignorePause)
    local winName = win.__className
    self:OpenWindowByName(winName,args,isCache,ignorePause)
end

--通过窗口名字打开创建
function WindowManager:OpenWindowByName(winName,args,isCache,ignorePause)
    local windowClass = _G[winName]
    assert(windowClass,string.format("没有对应的窗口类[win:%s]",tostring(winName)))

    if not self:CanOpenWindow(windowClass,args) then
        return false
    end

    local win = self.windows[windowClass.__className] or self:CreateWindow(windowClass)
    self.windows[winName] = win

    if win.Update then 
        self.updateWindows[winName] = win
    end

    if win.LowUpdate then
        self.lowUpdateWindows[winName] = win
    end

    if isCache then
        win:CreateCache()
        return true
    end

    local alreadyPause = false
    for _, window in pairs(self.windows) do
        if not WindowDefine.IgnorePauseWindow[window.__className] then
            if window.active or window.assetLoader then
                alreadyPause = true
            end
        end
    end

    self.readyOpenWin = winName

    win:Show(args)

	if not alreadyPause then
        if not WindowDefine.IgnorePauseWindow[winName] then
            EventMgr.Instance:Fire(EventName.PauseByOpenWindow)
            BehaviorFunctions.Pause()
            BehaviorFunctions.CancelJoystick()
            if InputManager.Instance then
                InputManager.Instance:AddLayerCount(InputManager.Instance.actionMapName, "UI")
            end
        end
	end
    return true
end

function WindowManager:CanOpenWindow(windowClass,args)
    if not windowClass.IsOpen then 
        return true
    else
        return windowClass.IsOpen(args)
    end
end

function WindowManager:CacheWindow(windowName)
    self:OpenWindow(windowName,nil,true)
end

function WindowManager:CreateWindow(windowClass)
    local window = windowClass.New()
    window:SetParent(UIDefine.canvasRoot.transform)
    return window
end

function WindowManager:OpenComplete(window)
    local winName = window.__className
    if self:CloseMissWindow(winName) then 
        return
    end
    self:RemoveWindowList(winName)
    table.insert(self.windowList,winName)

    if self.curWindow~=winName then 
        self:TempHideWindow(window) 
    end
    if not self.windows[winName] then 
        self.windows[winName] = window 
    end
    --self.curWindow = winName
    self.readyOpenWin = nil
    --window:TempShowWindow()
	self:TempShowWindow()
end

function WindowManager:CloseComplete(windowName)
    if not self.readyCloseWin or self.readyCloseWin ~= windowName then 
        return 
    end
    self.curWindow = nil
    self.readyCloseWin = nil
    self:RemoveWindowList(windowName)
    self:TempShowWindow()
end

function WindowManager:TempHideWindow(openWindow)
    if self.curWindow == nil or openWindow.notTempHide then 
        return 
    end
    local win = self.windows[self.curWindow]
    if win then 
        win:TempHideWindow() 
    end
end

function WindowManager:TempShowWindow()
    local len = #self.windowList
    if len <= 0 then 
        return 
    end

    local win = self.windows[self.windowList[len]]
    if win == nil then 
        return 
    end

    win:TempShowWindow()
    self.curWindow = win.__className
	EventMgr.Instance:Fire(EventName.OnWindowOpen, self.curWindow)
end

function WindowManager:GetCurWindow()
   return self.curWindow
end

function WindowManager:CloseMissWindow(windowName)
    if self.readyOpenWin == windowName or self.curWindow == windowName then
        return false 
    end
    local win = self.windows[windowName]
    if win then 
        win:CloseWindow(true) 
    end
    return true
end

--关闭窗口
function WindowManager:CloseWindow(win)
    local winName = win.__className
    self:CloseWindowByName(winName)
end

function WindowManager:CloseWindowByName(winName)
    local win = self.windows[winName]
    if not win then
        return 
    end

    local isCurWindow = self.curWindow == winName
    if isCurWindow then
        self.readyCloseWin = winName
    else
        self:RemoveWindowList(winName)
    end

    win:CloseWindow(not isCurWindow)
    for _, window in pairs(self.windows) do
        if not WindowDefine.IgnorePauseWindow[window.__className] then
            if window.active then
                return
            end
        end
    end
    if not WindowDefine.IgnorePauseWindow[winName] then
        EventMgr.Instance:Fire(EventName.ResumeByCloseWindow)
        BehaviorFunctions.Resume()
        if InputManager.Instance then
            InputManager.Instance:MinusLayerCount()
        end
    end
end

function WindowManager:RemoveWindowList(windowName)
    local len = #self.windowList
    if len <= 0 then 
        return 
    end

    local index = nil
    for i=len,1,-1 do 
        if self.windowList[i] == windowName then 
            index = i 
            break 
        end
    end

    if index then
        table.remove(self.windowList,index)
    end
end

function WindowManager:GetWindow(windowName)
    return self.windows[windowName]
end

function WindowManager:GetWindowCount()
    return #self.windowList
end

function WindowManager:IsOpenWindow(windowName)
    local window = self.windows[windowName]
    return window and window:Active()
end

function WindowManager:GetMaxOrderLayer()
    self.orderLayer = self.orderLayer + 10
    return self:GetCurOrderLayer()
end

function WindowManager:GetCurOrderLayer()
    return self.orderLayer
end

function WindowManager:IsExistWindow()
end

function WindowManager:AddOrderLayer(val)
    self.orderLayer = self.orderLayer + val
end

function WindowManager:CloseAllWindow(isDestroy)
    for k,v in pairs(self.windows) do
        v.cacheMode = (v.cacheMode == UIDefine.CacheMode.hide and isDestroy) and UIDefine.CacheMode.destroy or v.cacheMode
		v:CloseWindow(true)
		self:RemoveWindowList(v.__className)
	end
    self.windowList = {}
    self.curWindow = nil
    self.readyOpenWin = nil
    self.readyCloseWin = nil
    self.orderLayer = 10
    EventMgr.Instance:Fire(EventName.ResumeByCloseWindow)
    BehaviorFunctions.Resume()
    if InputManager.Instance then
        InputManager.Instance:MinusLayerCount()
    end
end

function WindowManager:SetWindowVisible(windowName, visible, args, isCache, ignorePause)
    if visible then
        self:OpenWindowByName(windowName, args, isCache, ignorePause)
    elseif self.windows[windowName] then
        self.windows[windowName]:Hide()
    end
end

function WindowManager:Update()
    for k, v in pairs(self.updateWindows) do
        v:Update()
    end
end

function WindowManager:LowUpdate()
    for k, v in pairs(self.lowUpdateWindows) do
        v:LowUpdate()
    end
end

function WindowManager:BeforeLogicUpdate()
    for k, v in pairs(self.windows) do
        if v.BeforeLogicUpdate then
            v:BeforeLogicUpdate()
        end
    end
end

function WindowManager:LogicUpdate()
    for k, v in pairs(self.windows) do
        if v.LogicUpdate then
            v:LogicUpdate()
        end
    end
end

function WindowManager:AfterLogicUpdate()
    for k, v in pairs(self.windows) do
        if v.AfterLogicUpdate then
            v:AfterLogicUpdate()
        end
    end
end