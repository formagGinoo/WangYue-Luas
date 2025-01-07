GetPartnerPanel = BaseClass("GetPartnerPanel", BasePanel)
function GetPartnerPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/GetPartnerPanel.prefab")
end

function GetPartnerPanel:__CacheObject()
end

function GetPartnerPanel:__BindListener()
end

function GetPartnerPanel:__Show()
    self.partnerId = self.args[1]
    self:SetActive(true)
	self:UpdateShowPartnerView()
end

function GetPartnerPanel:ClosePanel()
    PanelManager.Instance:ClosePanel(self)
end

function GetPartnerPanel:UpdateShowPartnerView()
    local id = self.partnerId
    local qualityCfg = RoleConfig.GetPartnerQualityConfig(id)
    if not qualityCfg then return end

    SingleIconLoader.Load(self.Icon, qualityCfg.jade_icon)
    SingleIconLoader.Load(self.Quality, qualityCfg.jade_quality)
    self.AllContent:SetActive(true)

    self:RemoveTimer()
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1, 2, function ()
        self.AllContent:SetActive(false)
        self:ClosePanel()
    end)
end

function GetPartnerPanel:RemoveTimer()
    if self.delayTimer then
		LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
	end
	
	self.delayTimer = nil
end

function GetPartnerPanel:__Hide()
    self:RemoveTimer()
    LuaTimerManager.Instance:AddTimer(1, 0.5, function ()
        EventMgr.Instance:Fire(EventName.CloseNoticePnl)
    end)
end

function GetPartnerPanel:__delete()

end