PartnerCareerTipsPanel = BaseClass("PartnerCareerTipsPanel", BasePanel)

PartnerCareerTipsPanel.ShowType = {
    Career = 1,
    CareerAffix = 2
}

function PartnerCareerTipsPanel:__init()
    self:SetAsset("Prefabs/UI/PartnerBag/PartnerCareerTipsPanel.prefab")
end

function PartnerCareerTipsPanel:__Create()

end

function PartnerCareerTipsPanel:__delete()

end

function PartnerCareerTipsPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerCareerTipsPanel:__BindListener()
    self.BackBg_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
end

function PartnerCareerTipsPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function PartnerCareerTipsPanel:OnClick_Close()
    PanelManager.Instance:ClosePanel(self)
end

function PartnerCareerTipsPanel:__Show()
    self.type = self.args.type or PartnerCareerTipsPanel.ShowType.Career
    self:SetLayOut()
    self:ShowDetail()
end

function PartnerCareerTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function PartnerCareerTipsPanel:SetLayOut()
    UnityUtils.SetAnchoredPosition(self.Tips.transform, self.args.tipsPosX or 0, self.args.tipsPosY or 0)
end

function PartnerCareerTipsPanel:ShowDetail()
    local partnerCareerCfg 
    if self.type == PartnerCareerTipsPanel.ShowType.Career then
        partnerCareerCfg = PartnerBagConfig.GetPartnerWorkCareerCfgById(self.args.id)
    else
        partnerCareerCfg = PartnerBagConfig.GetPartnerWorkAffixCfg(self.args.id, self.args.lv)
    end

    self.tipsTitle_txt.text = partnerCareerCfg.name
    self.desc_txt.text = partnerCareerCfg.desc
end

function PartnerCareerTipsPanel:ShowTipsItem(cfg, lv)
    self.tipsItemName_txt.text = cfg.name
    self.tipsItemLevel_txt.text = string.format("Lv.%d", lv)
    if cfg.icon ~= "" then
        SingleIconLoader.Load(self.tipsItemIcon, cfg.icon)
    end
end