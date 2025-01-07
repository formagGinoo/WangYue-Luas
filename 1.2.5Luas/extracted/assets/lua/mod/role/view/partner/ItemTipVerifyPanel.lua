ItemTipVerifyPanel = BaseClass("ItemTipVerifyPanel", BasePanel)

function ItemTipVerifyPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/ItemTipVerifyPanel.prefab")
end

function ItemTipVerifyPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ItemTipVerifyPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    if self.isSubmit and self.submitEvent then
        self.submitEvent()
    end
    for key, value in pairs(self.itemList) do
        ItemManager.Instance:PushItemToPool(value)
    end
end

function ItemTipVerifyPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.Submit_btn,self:ToFunc("Close_HideCallBack"),self:ToFunc("OnClick_Submit"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Close_HideCallBack"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))
end

function ItemTipVerifyPanel:__Show()
    self.itemList = {}
    self.itemMap = self.args.itemMap
    self.submitEvent = self.args.submitEvent
    self:ShowItems()
end

function ItemTipVerifyPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 3, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function ItemTipVerifyPanel:ShowItems()
    for itemId, count in pairs(self.itemMap) do
        local itemInfo = {
            template_id = itemId,
            count = count,
            scale = 0.8,
        }
        table.insert(self.itemList, ItemManager.Instance:GetItem(self.ItemRoot_rect, itemInfo, true))
    end
end

function ItemTipVerifyPanel:BlurComplete()
    self:SetActive(true)
end

function ItemTipVerifyPanel:OnClick_Submit()
    self.isSubmit = true
end

function ItemTipVerifyPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end