SetOtherPanel = BaseClass("SetOtherPanel", BasePanel)

function SetOtherPanel:__init()
    self:SetAsset("Prefabs/UI/GameSet/SetOtherPanel.prefab")
end

function SetOtherPanel:__Create()

end

function SetOtherPanel:__BindListener()
    self.GotoLogin_btn.onClick:AddListener(self:ToFunc("OnGotoLogin"))
end

function SetOtherPanel:OnGotoLogin()
	local callBack = function ()
		ModuleManager.Instance:GotoLogin()
	end
	MsgBoxManager.Instance:ShowTextMsgBox(TI18N("是否返回登录界面"), callBack)
end

function SetOtherPanel:__Show()

end
