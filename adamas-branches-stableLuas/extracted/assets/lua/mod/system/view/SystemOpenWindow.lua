SystemOpenWindow = BaseClass("SystemOpenWindow",BaseWindow)
local DataSystemOpen = Config.DataSystemOpen.data_system_open

function SystemOpenWindow:__init()
    self:SetAsset("Prefabs/UI/Notice/SystemOpenWindow.prefab")
end

function SystemOpenWindow:__delete()
end

function SystemOpenWindow:__CacheObject()
end

function SystemOpenWindow:__BindListener()
    self:SetHideNode("SystemOpenWindow_Exit")
    self:BindCloseBtn(self.MaskBtn_btn, self:ToFunc("HideWindow"))
end

function SystemOpenWindow:ClickMaskBtn()
    self.SystemOpenWindow_Exit:SetActive(true)
end

function SystemOpenWindow:HideWindow()
    self.SystemOpenWindow_Exit:SetActive(false)
    WindowManager.Instance:CloseWindow(SystemOpenWindow)
end

function SystemOpenWindow:__Create()

end

function SystemOpenWindow:__Show(args)
    self:SetBlurBack()
    self.systemId = self.args.systemId
    self:UpdateView()
    
    self.ArrowTip:SetActive(false)
    self.MaskBtn:SetActive(false)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1, 2, function ()
        self.ArrowTip:SetActive(true)
        self.MaskBtn:SetActive(true)
        self:RemoveTimer()
    end)
end

function SystemOpenWindow:UpdateView()
    local cfg = DataSystemOpen[self.systemId]
    self.TitleName_txt.text = cfg.name

    for i = 1, 2 do
        local desc = cfg["notice_desc"..i]
        local isNull = desc == ""
        self["Tip"..i]:SetActive(not isNull)
        if not isNull then
            self["Tip"..i.."_txt"].text = desc
        end
    end

    SingleIconLoader.Load(self.SystemIcon, cfg.notice_icon)
end

function SystemOpenWindow:__Hide()
    self:RemoveTimer()
end

function SystemOpenWindow:RemoveTimer()
	if self.delayTimer then
		LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
	end
	
	self.delayTimer = nil
end
