NewRoleWindow = BaseClass("NewRoleWindow",BaseWindow)

local DataHeroMain = Config.DataHeroMain.Find
local DataHeroElement = Config.DataHeroElement.Find

function NewRoleWindow:__init()
    self:SetAsset("Prefabs/UI/Notice/NewRoleWindow.prefab")
end

function NewRoleWindow:__delete()

end

function NewRoleWindow:__CacheObject()
end

function NewRoleWindow:__BindListener()
    self.MaskBtn_btn.onClick:AddListener(self:ToFunc("ClickMaskBtn"))
    self.NewRoleWindow_Exit_hcb.HideAction:AddListener(self:ToFunc("HideWindow"))
end

function NewRoleWindow:ClickMaskBtn()
    self.NewRoleWindow_Exit:SetActive(true)
end

function NewRoleWindow:HideWindow()
    self.NewRoleWindow_Exit:SetActive(false)
    WindowManager.Instance:CloseWindow(NewRoleWindow)
end

function NewRoleWindow:__Create()

end

function NewRoleWindow:__Show(args)
    self.roleId = self.args.roleId
    self.RoleIcon:SetActive(false)
    self.ElementIcon:SetActive(false)

    self:UpdateView()
    self:RemoveTimer()
    self.ArrowTip:SetActive(false)
    self.MaskBtn:SetActive(false)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1, 2, function ()
        self.ArrowTip:SetActive(true)
        self.MaskBtn:SetActive(true)
    end)
end

function NewRoleWindow:__Hide()
    self:RemoveTimer()
    EventMgr.Instance:Fire(EventName.CloseNoticePnl)
end

function NewRoleWindow:UpdateView()
    local roleCfg = DataHeroMain[self.roleId]

    self.RoleName_txt.text = roleCfg.name
    self.RoleDesc_txt.text = roleCfg.detail_desc

    local elmentIcon = self.ElementIcon
    local elementCfg = DataHeroElement[roleCfg.element]

    local elementCb = function()
        elmentIcon:SetActive(true)
    end
    SingleIconLoader.Load(elmentIcon, elementCfg.element_icon_big, elementCb)

    local roleIcon = self.RoleIcon
    local cb = function()
        roleIcon:SetActive(true)
    end
    SingleIconLoader.Load(roleIcon, roleCfg.shead_icon, cb)
end

function NewRoleWindow:RemoveTimer()
	if self.delayTimer then
		LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
	end

	self.delayTimer = nil
end
