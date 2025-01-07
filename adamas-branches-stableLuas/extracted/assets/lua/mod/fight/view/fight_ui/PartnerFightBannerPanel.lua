PartnerFightBannerPanel = BaseClass("PartnerFightBannerPanel", BasePanel)

local DataPartnerInfo = Config.DataPartnerMain.Find

function PartnerFightBannerPanel:__init()
	self:SetAsset("Prefabs/UI/Fight/PartnerFightBannerPanel.prefab")
end

function PartnerFightBannerPanel:__delete()

end

function PartnerFightBannerPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function PartnerFightBannerPanel:__Create()
    self.canvas = self.transform:GetComponent(Canvas)
end

function PartnerFightBannerPanel:__BindEvent()

end

function PartnerFightBannerPanel:__BindListener()
    self:SetHideNode("EffectHideCallback")
    self.EffectHideCallback_hcb.HideAction:AddListener(self:ToFunc("CloseCallBack"))
end

function PartnerFightBannerPanel:__Show()
    PartnerFightBannerPanel.isShow = true
    self.fightMainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    self.fightMainUI:ShortShutdownInBannerShow()

    UtilsUI.SetEffectSortingOrder(self.UI_PartnerFightBannerPanel_in, self.canvas.sortingOrder + 1)

    UtilsUI.SetActive(self.PartnerIcon, false)
    self.showPartnerId = self.args.partnerId
    self.showPartnerInfo = DataPartnerInfo[self.showPartnerId]
    if not self.showPartnerInfo then
        LogError(string.format("配从横幅战斗弹窗打开失败, 配从id:%d, 找不到对应的配从信息", self.showPartnerId))
        self:CloseCallBack()
        return
    end
    self.PartnerText_txt.text = string.format("%s", self.showPartnerInfo.name)
    SingleIconLoader.Load(self.PartnerIcon, self.showPartnerInfo.shead_icon, function ()
        UtilsUI.SetActive(self.PartnerIcon, true)
    end)
    --LogInfo(string.format("配从展示 %s", self.showPartnerInfo.name))
end

function PartnerFightBannerPanel:__Hide()
    PartnerFightBannerPanel.isShow = false
end

function PartnerFightBannerPanel:CloseCallBack()
    self.fightMainUI:ReplyShutdownInBannerShow()
    PanelManager.Instance:ClosePanel(self)
end