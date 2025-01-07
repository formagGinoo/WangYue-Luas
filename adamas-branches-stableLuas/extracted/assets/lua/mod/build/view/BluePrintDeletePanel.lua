BluePrintDeletePanel = BaseClass("BluePrintDeletePanel", BasePanel)

function BluePrintDeletePanel:__init(parent)
    self:SetAsset("Prefabs/UI/Build/BluePrintDeletePanel.prefab")
    self.parentUI = parent
end

function BluePrintDeletePanel:__BindEvent()

end

function BluePrintDeletePanel:__BindListener()
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("ClosePanel"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("ClosePanel"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("ClosePanel"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmUse"))
end

function BluePrintDeletePanel:__Show()
end

function BluePrintDeletePanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    --self:SetActive(false)

    local func = function()
        self.blurBack:Show()
    end

    --SingleIconLoader.Load(self.BuildIcon, data.icon, function()
    --    self.BuildIcon:SetActive(true)
    --end)

    self.deleteId = self.args.deleteId
end

function BluePrintDeletePanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function BluePrintDeletePanel:__delete()

end

function BluePrintDeletePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BluePrintDeletePanel:OnClick_ConfirmUse()
    mod.BuildCtrl:DeleteBluePrint(self.deleteId, function()
        self.parentUI:OnBuildListUpdate()
        self:ClosePanel()
    end)
end

function BluePrintDeletePanel:ClosePanel()
    self.parentUI:ClosePanel(self)
end
