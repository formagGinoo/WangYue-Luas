DebugSystemPanel = BaseClass("DebugSystemPanel", BaseView)

function DebugSystemPanel:__init()
    self:SetAsset("Prefabs/UI/FightDebug/DebugSystemPanel.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
    self.rolePanel = nil
    self.bagpannel = nil
end

function DebugSystemPanel:__BindListener()
    self.GetData_btn.onClick:AddListener(self:ToFunc("GetData"))
    self.OpenRole_btn.onClick:AddListener(self:ToFunc("OpenRolePanel"))
    self.OpenBag_btn.onClick:AddListener(self:ToFunc("OpenBagPannel"))
    self.FormationBtn_btn.onClick:AddListener(self:ToFunc("OpenFormation"))
end

function DebugSystemPanel:__Hide()
    
end

function DebugSystemPanel:__Show()
    
end

function DebugSystemPanel:GetData()

end

function DebugSystemPanel:OpenRolePanel()
    WindowManager.Instance:OpenWindow(RoleMainWindow)
    self:Destroy()
end

function DebugSystemPanel:OpenBagPannel()
    WindowManager.Instance:OpenWindow(BagWindow)
    self:Destroy()
end

function DebugSystemPanel:OpenFormation()
    WindowManager.Instance:OpenWindow(FormationWindow)
    self:Destroy()
end