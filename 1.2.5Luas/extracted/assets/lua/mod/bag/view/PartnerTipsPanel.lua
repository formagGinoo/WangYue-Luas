PartnerTipsPanel = BaseClass("PartnerTipsPanel", BasePanel)

function PartnerTipsPanel:__init(parent, unique_id)
    self:SetAsset("Prefabs/UI/Common/PartnerTipsPanel.prefab")
    self.parent = parent
    
end

function PartnerTipsPanel:__Create()
    self.commonInfo = Fight.Instance.objectPool:Get(CommonPartnerInfo)
    self.commonInfo:Init(self.PartnerTips)
end

function PartnerTipsPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function PartnerTipsPanel:__delete()
    self.commonInfo:OnCache()
    if self.blurBack then
        self.blurBack:Destroy()
    end
end

function PartnerTipsPanel:__BindListener()
    self:SetHideNode("PartnerTipsPanel_Exit")
    self:BindCloseBtn(self.BackBtn_btn, self:ToFunc("OnClick_Back"))
end

function PartnerTipsPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    InputManager.Instance:MinusLayerCount()
end

function PartnerTipsPanel:__Show()
    InputManager.Instance:AddLayerCount(InputManager.Instance.actionMapName, "UI")
    self.unique_id = self.args.unique_id
    self:PartnerInfoChange()
end

function PartnerTipsPanel:PartnerInfoChange()
    self.commonInfo:UpdateShow(self.unique_id)
end

function PartnerTipsPanel:GetPartnerData()
    return self.parentWindow:GetPartnerData()
end

function PartnerTipsPanel:OnClick_Back()
    PanelManager.Instance:ClosePanel(self)
end