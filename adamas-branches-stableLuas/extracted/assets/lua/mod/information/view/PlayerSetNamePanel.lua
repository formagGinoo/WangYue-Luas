PlayerSetNamePanel = BaseClass("PlayerSetNamePanel",BasePanel)

function PlayerSetNamePanel:__init(parent, view, txt)
    self.parent = parent
    self.view = view
    self.showTxt = txt
    self:SetAsset("Prefabs/UI/SystemMenu/PlayerSetNamePanel.prefab")
end

function PlayerSetNamePanel:__BindListener()
    self.ConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Confirm"))
end

function PlayerSetNamePanel:__delete()

end

function PlayerSetNamePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
    self.nameInputField = self:Find("Input_", TMP_InputField)
    self.nameInputField.onValueChanged:AddListener(self:ToFunc("NameInput"))
end

function PlayerSetNamePanel:__Hide()
    self:BackCamera()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function PlayerSetNamePanel:__Show()
    self:ChangeCamera()
    self.nameInputField.text = ""
    self.CoutTips_txt.text = "0/8"
end

function PlayerSetNamePanel:__ShowComplete()
     if not self.blurBack then
         local setting = {passEvent = UIDefine.BlurBackCaptureType.UI, bindNode = self.BlurNode }
         self.blurBack = BlurBack.New(self, setting)
     end
    self.blurBack:Show()
end


function PlayerSetNamePanel:ChangeCamera()
    local uiCamera = ctx.UICamera
    uiCamera.orthographic = false
    uiCamera.fieldOfView  = 8
    uiCamera.nearClipPlane = 0.01
end

function PlayerSetNamePanel:BackCamera()
    local uiCamera = ctx.UICamera
    uiCamera.orthographic = true
    uiCamera.nearClipPlane = -10
end

function PlayerSetNamePanel:OnClick_Confirm()
    local isFWord, newText, logic = false, "", nil
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
    if #name > 0 then
        mod.InformationCtrl:ModifyPlayerName(name)
        EventMgr.Instance:Fire(EventName.ModifyPlayerInfo)
    end
    self:PlayExitAnim()
end

function PlayerSetNamePanel:NameInput()
    self.nameInputField.text = UtilsUI.FullWidthToHalfWidth(self.nameInputField.text)
    local name = string.gsub(self.nameInputField.text," ","")
    self.nameInputField.text = name
    local str = self.nameInputField.text
    local _, count = string.gsub(str, "[^\128-\193]", "")
    self.CoutTips_txt.text = count .. "/8"
end

function PlayerSetNamePanel:__AfterExitAnim()
    StoryController.Instance:SetSpeed(1)
    Story.Instance:SkipStory(Config.DataCommonCfg.Find["RenameTimeline"].int_val)
    PanelManager.Instance:ClosePanel(self)
end