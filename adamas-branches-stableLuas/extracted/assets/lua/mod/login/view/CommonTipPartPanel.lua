CommonTipPartPanel = BaseClass("CommonTipPartPanel", BasePanel)
--梦魇冒险入口显示详细信息

function CommonTipPartPanel:__init()
    self:SetAsset("Prefabs/UI/Common/CommonTipPart.prefab")
    self.evBuffItem = {}
    self.monsterItemList = {}
end
function CommonTipPartPanel:__BindEvent()

end

function CommonTipPartPanel:__BindListener()
    --self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))
end

function CommonTipPartPanel:__Create()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function CommonTipPartPanel:__delete()

end

function CommonTipPartPanel:__Show()
    
end

function CommonTipPartPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function CommonTipPartPanel:BlurComplete()
    self:SetActive(true)
end
function CommonTipPartPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    PanelManager.Instance:ClosePanel(self)
end

function CommonTipPartPanel:UpdateView()

end
