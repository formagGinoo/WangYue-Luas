FormationNameEditorPanel = BaseClass("FormationNameEditorPanel", BasePanel)

function FormationNameEditorPanel:__init()
    self:SetAsset("Prefabs/UI/SystemMenu/PlayerInfoEditorPanel.prefab")
end

function FormationNameEditorPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
    self.nameInputField = self.NameInputBox:GetComponent(TMP_InputField)
end

function FormationNameEditorPanel:__BindListener()
     
    self.CommonGrid_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.Cancel_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Submit"))
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
        self.nameInputField.text = string.format(TI18N("编队%d"), self.formationId)
    else
        self.nameInputField.text = curInfo.name
    end
end

function FormationNameEditorPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end

function FormationNameEditorPanel:OnClick_Submit()
    local name = self.nameInputField.text
    if #name > 0 then
        mod.FormationCtrl:ReqUpdateFormationName(self.formationId,name)
        self:PlayExitAnim()
    end
end