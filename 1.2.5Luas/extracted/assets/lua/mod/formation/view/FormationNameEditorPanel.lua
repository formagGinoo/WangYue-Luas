FormationNameEditorPanel = BaseClass("FormationNameEditorPanel", BasePanel)

function FormationNameEditorPanel:__init()
    self:SetAsset("Prefabs/UI/SystemMenu/PlayerInfoEditorPanel.prefab")
end

function FormationNameEditorPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
    self.nameInputField = self:Find("WindowBody/InputBoxNode/NameInputBox_", TMP_InputField)
    self.signatureInputField = self:Find("WindowBody/InputBoxNode/SignatureInputBox_", TMP_InputField)
end

function FormationNameEditorPanel:__BindListener()
    self.BGButton_btn.onClick:AddListener(self:ToFunc("OnClick_ClosePanel"))
    self.CloseButton_btn.onClick:AddListener(self:ToFunc("OnClick_ClosePanel"))
    self.CancalButton_btn.onClick:AddListener(self:ToFunc("OnClick_ClosePanel"))
    self.SubmitButton_btn.onClick:AddListener(self:ToFunc("OnClick_Submit"))
end

function FormationNameEditorPanel:__Show()
    self:SetActive(false)
    self.TitleText_txt.text = TI18N("修改名称")
    self.NameInputBox:SetActive(true)
    self.SignatureInputBox:SetActive(false)
    
    self.formationId = self.args.formationId
    self:ShowDetail()
end

function FormationNameEditorPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
   self.blurBack:Show()
   self.gameObject:SetActive(true)
end

function FormationNameEditorPanel:ShowDetail()
    local curInfo = mod.FormationCtrl:GetFormationInfo(self.formationId)
    if curInfo.name == "" or not curInfo.name then
        self.nameInputField.text = TI18N("编队")..self.formationId
    else
        self.nameInputField.text = curInfo.name
    end
end

function FormationNameEditorPanel:OnClick_ClosePanel()
    self.CloseSwitch:SetActive(true)
    local hideAction = self.CloseSwitch:GetComponent(HideCallBack).HideAction
    hideAction:RemoveAllListeners()
    hideAction:AddListener(function ()
        PanelManager.Instance:ClosePanel(self)
    end)
end

function FormationNameEditorPanel:OnClick_Submit()
    local name = self.nameInputField.text
    if #name > 0 then
        mod.FormationCtrl:ReqUpdateFormationName(self.formationId,name)
        self:OnClick_ClosePanel()
    end
end