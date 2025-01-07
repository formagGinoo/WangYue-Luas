PlayerInfoWindow = BaseClass("PlayerInfoWindow", BaseWindow)

function PlayerInfoWindow:__init()  
    self:SetAsset("Prefabs/UI/Friend/PlayerInfoWindow.prefab")
end

function PlayerInfoWindow:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
end

function PlayerInfoWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.PlayerInfoUpdate, self:ToFunc("UpdatePlayerInfo"))
    EventMgr.Instance:AddListener(EventName.ModifyPlayerInfo, self:ToFunc("UpdatePlayerInfo"))
    EventMgr.Instance:AddListener(EventName.SetBirthday,self:ToFunc("SetBirthday"))
    EventMgr.Instance:AddListener(EventName.SetBirthdayFinish,self:ToFunc("SetBirthdayFinish"))
    EventMgr.Instance:AddListener(EventName.InformationRoleSubmit, self:ToFunc("SubmitFormation"))
end

function PlayerInfoWindow:__Create()

end

function PlayerInfoWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.PlayerInfoUpdate, self:ToFunc("UpdatePlayerInfo"))
    EventMgr.Instance:RemoveListener(EventName.ModifyPlayerInfo, self:ToFunc("UpdatePlayerInfo"))
    EventMgr.Instance:RemoveListener(EventName.SetBirthday,self:ToFunc("SetBirthday"))
    PoolManager.Instance:Push(PoolType.class, "PlayerInfoItem", self.playerInfoItem)


end

function PlayerInfoWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

function PlayerInfoWindow:__Hide()

end

function PlayerInfoWindow:__Show()
    self.uid = self.args.uid
    self.animator = self.gameObject:GetComponent(Animator)
    local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 2, bindNode = self.BlurNode }
    self:SetBlurBack(setting)
end


function PlayerInfoWindow:__ShowComplete()
    self.playerInfoItem = PoolManager.Instance:Pop(PoolType.class, "PlayerInfoItem")
	if not self.playerInfoItem then
		self.playerInfoItem = PlayerInfoItem.New()
	end
    self.playerInfoItem:InitItem(self.PlayerInfoItem, self, self.uid)
    --self:UpdataPlayerInfo(self.id)
end

function PlayerInfoWindow:UpdatePlayerInfo()
    self.playerInfoItem:UpdataPlayerInfo(self.uid)
end

function PlayerInfoWindow:OnClick_Close()
    self.PlayerInfoItem_anim:Play("UI_PlayerInfoItem_out")
    self.animator:Play("UI_PlayerInfoWindow_out")
end

function PlayerInfoWindow:SubmitFormation(roleList)
    local id, cmd = mod.InformationFacade:SendMsg("information_hero_list",roleList)
    self:ClosePanel(RoleListPanel)
end

function PlayerInfoWindow:SetBirthday(month,day)
    mod.InformationFacade:SendMsg("information_birthday",month,day)
end

function PlayerInfoWindow:SetBirthdayFinish()
    self:ClosePanel(SetBirthdayPanel)
end

function PlayerInfoWindow:UpdateRoleList(...)
    self:CallPanelFunc("UpdateRoleList", ...)
end

function PlayerInfoWindow:RefreshItemList(...)
    self:CallPanelFunc("RefreshItemList", ...)
end