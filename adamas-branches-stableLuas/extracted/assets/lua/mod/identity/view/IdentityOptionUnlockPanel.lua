IdentityOptionUnlockPanel = BaseClass("IdentityOptionUnlockPanel", BasePanel)

function IdentityOptionUnlockPanel:__init()
    self:SetAsset("Prefabs/UI/Identity/IdentityOptionUnlockPanel.prefab")
end

function IdentityOptionUnlockPanel:__BindListener()

end

function IdentityOptionUnlockPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function IdentityOptionUnlockPanel:__Hide()
end

function IdentityOptionUnlockPanel:__Show()
    SoundManager.Instance:PlaySound("UIDialogUnlock")
    LuaTimerManager.Instance:AddTimer(1,Config.DataCommonCfg.Find["DialogUnlockShowTime"].int_val,self:ToFunc("OnClose"))
end

function IdentityOptionUnlockPanel:ShowDetail()
    
end

function IdentityOptionUnlockPanel:OnClose()
    self:PlayExitAnim()
end

function IdentityOptionUnlockPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end