PlayerInfoEditorPanel = BaseClass("PlayerInfoEditorPanel",BasePanel)

PlayerInfoEditorPanel.EditorView = {
    Name = 1,
    Signature = 2
}

function PlayerInfoEditorPanel:__init(parent, view)
    self.parent = parent
    self.view = view
    self:SetAsset("Prefabs/UI/SystemMenu/PlayerInfoEditorPanel.prefab")
end

function PlayerInfoEditorPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Hide"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Hide"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))
    self:BindCloseBtn(self.Submit_btn,self:ToFunc("Hide"),self:ToFunc("OnClick_Submit"))
end

function PlayerInfoEditorPanel:__delete()
    if self.blurBack then
        self.blurBack:Destroy()
    end
end

function PlayerInfoEditorPanel:__CacheObject()
    self.nameInputField = self:Find("CommonTipPart/BodyContent/InputBoxNode/NameInputBox_", TMP_InputField)
    self.signatureInputField = self:Find("CommonTipPart/BodyContent/InputBoxNode/SignatureInputBox_", TMP_InputField)
end

function PlayerInfoEditorPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function PlayerInfoEditorPanel:__Show()
    self:SetActive(false)
    self.curName = mod.InformationCtrl:GetPlayerInfo().nick_name
    self.nameInputField.text = self.curName
    self.curSignature = mod.InformationCtrl:GetPlayerInfo().signature
    self.signatureInputField.text = self.curSignature
    if self.view and self.view == PlayerInfoEditorPanel.EditorView.Name then
        self.TitleText_txt.text = TI18N("修改昵称")
        self.NameInputBox:SetActive(true)
        self.SignatureInputBox:SetActive(false)
    elseif self.view and self.view == PlayerInfoEditorPanel.EditorView.Signature then
        self.TitleText_txt.text = TI18N("签名")
        self.NameInputBox:SetActive(false)
        self.SignatureInputBox:SetActive(true)
    end
end

function PlayerInfoEditorPanel:__ShowComplete()
     if not self.blurBack then
         local setting = { bindNode = self.BlurNode }
         self.blurBack = BlurBack.New(self, setting)
     end
    self.blurBack:Show()
    self.gameObject:SetActive(true)
end

function PlayerInfoEditorPanel:OnClick_Submit()
    if self.view and self.view == PlayerInfoEditorPanel.EditorView.Name then
        local name = self.nameInputField.text
        if #name > 0 and name ~= self.curName then
            mod.InformationCtrl:ModifyPlayerName(name)
            EventMgr.Instance:Fire(EventName.ModifyPlayerInfo)
        end
    elseif self.view and self.view == PlayerInfoEditorPanel.EditorView.Signature then
        local signature = self.signatureInputField.text
        if signature ~= self.curSignature then
            mod.InformationCtrl:ModifyPlayerSignature(signature)
            EventMgr.Instance:Fire(EventName.ModifyPlayerInfo)
        end
    end
end