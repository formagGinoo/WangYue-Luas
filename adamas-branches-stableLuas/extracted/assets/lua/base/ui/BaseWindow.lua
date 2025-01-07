---@class BaseWindow : BaseView
BaseWindow = BaseClass("BaseWindow",BaseView)

function BaseWindow:__init()
    self:SetViewType(UIDefine.ViewType.window)
    self.cacheMode = UIDefine.CacheMode.destroy
    self.panelList = {}
    self.panelsActive = {}
	self.panelStack = {}
end

function BaseWindow:__delete()
	self.panelStack = {}
	
    for k, v in pairs(self.panelList) do
        v:Destroy()
    end
    TableUtils.ClearTable(self.panelList)
    TableUtils.ClearTable(self.panelsActive)
end

function BaseWindow:OpenPanel(panel, args, cacheMode)
    if not self.panelList[panel.__className] then
        local tempPanel
        local className = panel.__className
        if UtilsUI.CheckPCPlatform() then
            tempPanel = WindowDefine.PCLogic[panel.__className]
        end 
        self.panelList[className] = tempPanel and tempPanel.New(self) or panel.New(self)
        self.panelList[className].parentWindow = self
        self.panelList[className]:SetCacheMode(cacheMode or UIDefine.CacheMode.hide)
    end
    self.panelList[panel.__className]:Show(args)
	self:OnPanelChange(panel, true)
    return self.panelList[panel.__className]
end

function BaseWindow:OpenPanelByName(panelName, args, cacheMode)
    local panelClass = _G[panelName]
    if not panelClass then
        return
    end
    return self:OpenPanel(panelClass,args,cacheMode)
end

function BaseWindow:ClosePanel(panel)
    if self.panelList[panel.__className] then
        if self.panelList[panel.__className].cacheMode == UIDefine.CacheMode.hide then
            self.panelList[panel.__className]:Hide()
        else
            self.panelList[panel.__className]:Destroy()
            self.panelList[panel.__className] = nil
        end
		self:OnPanelChange(panel, false)
    end
end

function BaseWindow:CloseAllPanel()
    for key, value in pairs(self.panelList) do
        value:Destroy()
    end
    TableUtils.ClearTable(self.panelList)
    TableUtils.ClearTable(self.panelsActive)
end

function BaseWindow:OnPanelChange(panel, push)
	if push then
		table.insert(self.panelStack, panel.__className)
	else
		local idx = 0
		for i = #self.panelStack, 1, -1 do
			if self.panelStack[i] == panel.__className then
				idx = i
				break
			end
		end
		if idx ~= 0 then
			table.remove(self.panelStack, idx)
		end
	end
	
	if #self.panelStack > 0 then
		EventMgr.Instance:Fire(EventName.OnPanelOpen, self.panelStack[#self.panelStack])
	end
end
function BaseWindow:GetPanel(panel)
    return self.panelList[panel.__className]
end

function BaseWindow:GetPanelByName(name)
    return self.panelList[name]
end

function BaseWindow:CallPanelFunc(funName, ...)
    for key, panel in pairs(self.panelList) do
        if panel[funName] then
            panel[funName](panel,...)
        end
    end
end

function BaseWindow:CallActivePanelFunc(funName, ...)
    for key, panel in pairs(self.panelList) do
        if panel[funName] and panel.active then
            panel[funName](panel,...)
        end
    end
end

function BaseWindow:__BeforeExitAnim()
    self:CallActivePanelFunc("PlayExitAnim")
    local pauseCameraSetting = WindowDefine.IgnorPauseCameraWindow[self.__className]
    if not pauseCameraSetting and CameraManager.Instance and self.isEnter then
        CameraManager.Instance:GetCamera(FightEnum.CameraState.Pause):OnLeave()
        self.isEnter = false
    end
end

function BaseWindow:SetCacheMode(mode)
    self.cacheMode = mode
end

function BaseWindow:CloseWindow(imm)
    self.isDeleteWindow = true
    if self:LoadAsseting() then
        self:Destroy()
        WindowManager.Instance:RemoveWindow(self.__className)
    elseif imm then
        self:CloseComplete()
    else
        self:Hide()
    end
end

function BaseWindow:TempHideWindow(openWindow)
    if not self:Active() then return end
    self.active = false
    self:SetActive(false)
    self:__TempHide(openWindow)
end

function BaseWindow:TempShowWindow()
    if self:Active() then return end
    self.active = true
    -- TODO 曲线救国 修复动效有一帧的画面闪现
    self:SetActive(true)
    UtilsUI.SetActiveByPosition(self.gameObject, false)
    LuaTimerManager.Instance:AddTimer(1, 0, function ()
        UtilsUI.SetActiveByPosition(self.gameObject, true)
    end)
    self:__TempShow()
end

--动效等完成
function BaseWindow:CloseComplete()
    if self.cacheMode == UIDefine.CacheMode.hide then
        self:HideHandle()
    elseif self.cacheMode == UIDefine.CacheMode.destroy then
        self:Destroy()
        WindowManager.Instance:RemoveWindow(self.__className)
    end
    WindowManager.Instance:CloseComplete(self.__className)
end

function BaseWindow:__BaseCreate()
    self:InitCreate()
    self:SetUIAdapt()
end

function BaseWindow:InitCreate()
    self.canvas = self:Find(nil,Canvas)
    self.canvas.overrideSorting = true
    self.canvas.sortingOrder = UIDefine.FixedLayer[self.__className] or WindowManager.Instance:GetMaxOrderLayer()
end

-- 偏移数值后面改成可以调整的
function BaseWindow:SetUIAdapt()
    -- if Application.platform ~= RuntimePlatform.Android and Application.platform ~= RuntimePlatform.IPhonePlayer then
    --     return
    -- end

    -- local container = self.transform:Find("Content")
    -- if not container then
    --     container = self.transform
    -- end

    -- local uiAdaptor = self.transform:GetComponent(UIAdaptor)
    -- if not uiAdaptor then
    --     UnityUtils.SetSizeDelata(container, container.sizeDelta.x - 80, container.sizeDelta.y)
    --     return
    -- else
    --     UnityUtils.SetSizeDelata(container, container.sizeDelta.x - 80 - (uiAdaptor.ExtraOffset * 2), container.sizeDelta.y)
    -- end

    -- if uiAdaptor.AdaptorObjList then
    --     for k, v in pairs(uiAdaptor.AdaptorObjList) do
    --         UnityUtils.SetSizeDelata(v, v.sizeDelta.x + 80 + (uiAdaptor.ExtraOffset * 2), v.sizeDelta.y)
    --     end
    -- end

    -- if uiAdaptor.LeftObjList then
    --     for k, v in pairs(uiAdaptor.LeftObjList) do
    --         UnityUtils.SetSizeDelata(v, v.sizeDelta.x + 80 + (uiAdaptor.ExtraOffset * 2), v.sizeDelta.y)
    --         UnityUtils.SetLocalPosition(v, v.localPosition.x - 40 - uiAdaptor.ExtraOffset, v.localPosition.y, v.localPosition.z)
    --     end
    -- end

    -- if uiAdaptor.RightObjList then
    --     for k, v in pairs(uiAdaptor.RightObjList) do
    --         UnityUtils.SetSizeDelata(v, v.sizeDelta.x + 80 + (uiAdaptor.ExtraOffset * 2), v.sizeDelta.y)
    --         UnityUtils.SetLocalPosition(v, v.localPosition.x + 40 + uiAdaptor.ExtraOffset, v.localPosition.y, v.localPosition.z)
    --     end
    -- end
end

function BaseWindow:__BaseShow()

end

function BaseWindow:__BaseHide()
    --assert(self.isDeleteWindow,string.format("window对象禁止直接调用Hide方法! ==> 改用(WindowManager.Instance:CloseWindow)",tostring(self.__className)))
	self.panelsActive = {}
	if self.panelList and next(self.panelList) then
		for k, v in pairs(self.panelList) do
			self.panelsActive[k] = v.active
			if v.active then
				self:ClosePanel(v)
			end
		end
	end
end

function BaseWindow:__ShowComplete()
    WindowManager.Instance:OpenComplete(self)
    if self.panelList and next(self.panelList) and next(self.panelsActive) then
        for k, v in pairs(self.panelsActive) do
            if v and self.panelList[k] and self.panelList[k].gameObject then
                self.panelList[k]:Show()
            end
        end
    end
    local pauseCameraSetting = WindowDefine.IgnorPauseCameraWindow[self.__className]
    if not pauseCameraSetting and CameraManager.Instance and not self.isEnter then
        self.isEnter = true
        CameraManager.Instance:GetCamera(FightEnum.CameraState.Pause):OnEnter()
    end
end


function BaseWindow:__Hide()
    local pauseCameraSetting = WindowDefine.IgnorPauseCameraWindow[self.__className]
    if not pauseCameraSetting and CameraManager.Instance and self.isEnter then
        CameraManager.Instance:GetCamera(FightEnum.CameraState.Pause):OnLeave()
        self.isEnter = false
    end
end

function BaseWindow:SetWindowSize(width,height)
    UnityUtils.SetSizeDelata(self.transform,width,height)
end

function BaseWindow:__TempHide()end
function BaseWindow:__TempShow()end
