RoleUpgradeWindow = BaseClass("RoleUpgradeWindow", BaseWindow)

function RoleUpgradeWindow:__init()
    self:SetAsset("Prefabs/UI/Role/RoleUpgradeWindow.prefab")
    self.curRoleInfo = nil
end

function RoleUpgradeWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("onRoleInfoUpdate"))
end

--缓存对象
function RoleUpgradeWindow:__CacheObject()

end

function RoleUpgradeWindow:__Create()

end

--添加监听器
function RoleUpgradeWindow:__BindListener()
    self:SetHideNode("RoleUpgradeWindowHideNode")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close_HideCallBack"),self:ToFunc("OnClick_Close"))
end

function RoleUpgradeWindow:__delete()

end

function RoleUpgradeWindow:__Hide()
end

function RoleUpgradeWindow:__Show()
    self.heroId = self.args.heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.heroId)
    self.oldHeroLev = self.curRoleInfo.lev
    self.oldHeroStage = self.curRoleInfo.stage
    self.tabPanel = self:OpenPanel(CommonLeftTabPanel, { name = "脉者", name2 = "maizhe", tabList = RoleConfig.RoleUpgradeToggleInfo })
end

function RoleUpgradeWindow:__ShowComplete()
    Fight.Instance.modelViewMgr:GetView():RecordCamera()
end

function RoleUpgradeWindow:UpdateShow()
    self.curLimitLevel = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)].limit_hero_lev
    if self.curRoleInfo.lev < self.curLimitLevel then
        self:OpenPanel(RoleNewUpgradePanel, { heroId = self.heroId })
        self:ClosePanel(RoleStageUpPanel)
    elseif Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage + 1)] then
        self:OpenPanel(RoleStageUpPanel, { heroId = self.heroId })
        self:ClosePanel(RoleNewUpgradePanel)
    else
        WindowManager.Instance:CloseWindow(RoleUpgradeWindow)
    end
end

function RoleUpgradeWindow:onRoleInfoUpdate(idx, roleData)
    if self.heroId ~= roleData.id then
        return
    end
    self.curRoleInfo = roleData
	self:UpdateShow()
	
    if self.oldHeroLev < roleData.lev then
        PanelManager.Instance:OpenPanel(RoleUpgradeTipPanel, { heroId = self.heroId, oldLev = self.oldHeroLev, newLev = roleData.lev, stage = self.curRoleInfo.stage })
        self.oldHeroLev = roleData.lev
    elseif self.oldHeroStage < roleData.stage then
        PanelManager.Instance:OpenPanel(RoleStageUpTipPanel, { heroId = self.heroId, oldStage = self.oldHeroStage, newStage = roleData.stage })
        self.oldHeroStage = roleData.stage
    end

end



--关闭界面
function RoleUpgradeWindow:OnClick_Close()
    self.tabPanel:OnClose()
    if self:GetPanel(RoleNewUpgradePanel) then
        self:GetPanel(RoleNewUpgradePanel):OnClose()
    end
    if self:GetPanel(RoleStageUpPanel) then
        self:GetPanel(RoleStageUpPanel):OnClose()
    end
    Fight.Instance.modelViewMgr:GetView():RecoverCamera()
    local blurConfig = RoleConfig.GetRoleBlurConfig(self.heroId, RoleConfig.PageBlurType.Attr)
    Fight.Instance.modelViewMgr:GetView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

function RoleUpgradeWindow:Close_HideCallBack()
    WindowManager.Instance:CloseWindow(RoleUpgradeWindow)
end