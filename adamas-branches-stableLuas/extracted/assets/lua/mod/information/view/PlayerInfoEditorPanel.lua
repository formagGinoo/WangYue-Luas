PlayerInfoEditorPanel = BaseClass("PlayerInfoEditorPanel",BasePanel)

PlayerInfoEditorPanel.EditorView = {
    Name = 1,
    Signature = 2,
    Remark = 3
}

function PlayerInfoEditorPanel:__init(parent, view, txt)
    self.parent = parent
    self.view = view
    self.showTxt = txt
    self:SetAsset("Prefabs/UI/SystemMenu/PlayerInfoEditorPanel.prefab")
end

function PlayerInfoEditorPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Hide"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Hide"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Submit"))
    --self:BindCloseBtn(self.Submit_btn,self:ToFunc("Hide"),self:ToFunc("OnClick_Submit"))
end

function PlayerInfoEditorPanel:__delete()

end

function PlayerInfoEditorPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
    self.nameInputField = self:Find("CommonTipPart/BodyContent/InputBoxNode/NameInputBox_", TMP_InputField)
    self.nameInputField.onValueChanged:AddListener(self:ToFunc("NameInput"))
    self.signatureInputField = self:Find("CommonTipPart/BodyContent/InputBoxNode/SignatureInputBox_", TMP_InputField)
    self.signatureInputField.onValueChanged:AddListener(self:ToFunc("SignatureInput"))
end

function PlayerInfoEditorPanel:__Hide()
    InputManager.Instance:MinusLayerCount("UI")
    PanelManager.Instance:ClosePanel(self)
end

function PlayerInfoEditorPanel:__Show()
    self.view = self.args.view
    self.showTxt = self.args.txt
    InputManager.Instance:AddLayerCount("UI")
    self:SetActive(false)
    local setting = { bindNode = self.BlurNode }
    self:SetBlurBack(setting)
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
    elseif self.view and self.view == PlayerInfoEditorPanel.EditorView.Remark then
        self.TitleText_txt.text = TI18N("修改备注")
        self.nameInputField.text = self.showTxt or ""
        self.NameInputBox:SetActive(true)
        self.SignatureInputBox:SetActive(false)
    end
end

function PlayerInfoEditorPanel:__ShowComplete()
    --  if not self.blurBack then
    --      
    --      self.blurBack = BlurBack.New(self, setting)
    --  end
    -- self.blurBack:Show()
    self.gameObject:SetActive(true)
end

function PlayerInfoEditorPanel:OnClick_Submit()
    local isFWord, newText, logic = false, "", nil

    if self.view and self.view == PlayerInfoEditorPanel.EditorView.Name then
        isFWord, newText = SWBlocking.Query(self.nameInputField.text, newText)
        self.nameInputField.text = UtilsUI.FullWidthToHalfWidth(self.nameInputField.text)
        if isFWord then
            MsgBoxManager.Instance:ShowTips(TI18N("存在敏感内容，请调整后重新输入"))
            return
        end
        local name = string.gsub(self.nameInputField.text," ","")
        if #name == 0 then 
            MsgBoxManager.Instance:ShowTips(TI18N("昵称不能为空"))
            return
        end
        if #name > 0 and name ~= self.curName then
            mod.InformationCtrl:ModifyPlayerName(name)
            EventMgr.Instance:Fire(EventName.ModifyPlayerInfo)
        end
    elseif self.view and self.view == PlayerInfoEditorPanel.EditorView.Signature then
        isFWord, newText = SWBlocking.Query(self.signatureInputField.text, newText)
        if isFWord then
            MsgBoxManager.Instance:ShowTips(TI18N("存在敏感内容，请调整后重新输入"))
            return
        end
        local signature = string.gsub(self.signatureInputField.text," ","")
        if signature ~= self.curSignature then
            mod.InformationCtrl:ModifyPlayerSignature(signature)
            EventMgr.Instance:Fire(EventName.ModifyPlayerInfo)
        end
    elseif self.view and self.view == PlayerInfoEditorPanel.EditorView.Remark then
        isFWord, newText = SWBlocking.Query(self.nameInputField.text, newText)
        if isFWord then
            MsgBoxManager.Instance:ShowTips(TI18N("存在敏感内容，请调整后重新输入"))
            return
        end
        local remark = self.nameInputField.text
        -- if string.len(remark) > 12 then
        --     MsgBoxManager.Instance:ShowTips(TI18N("备注长度不能超过12个字符"))
        --     return
        -- end
        EventMgr.Instance:Fire(EventName.ModifyRemark,remark)
    end
    self:Hide()
    --UtilsUI.SetActive(self.CommonTipPart_Exit,true)
end

function PlayerInfoEditorPanel:NameInput()
    self.nameInputField.text = UtilsUI.FullWidthToHalfWidth(self.nameInputField.text)
    local name = string.gsub(self.nameInputField.text," ","")
    self.nameInputField.text = name
end

function PlayerInfoEditorPanel:SignatureInput()
    self.signatureInputField.text = UtilsUI.FullWidthToHalfWidth(self.signatureInputField.text)
end