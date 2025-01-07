BuildLimitTipPanel = BaseClass("BuildLimitTipPanel", BasePanel)

function BuildLimitTipPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Hacking/BuildLimitTipPanel.prefab")
    self.mainView = mainView
    self.blurBack = nil
end

function BuildLimitTipPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Back"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmUse"))
    self.CancelToggle_tog.onValueChanged:AddListener(self:ToFunc("OnClick_Toggle"))
end

function BuildLimitTipPanel:__Show()
    self.TitleText_txt.text = TI18N("提示")
end

function BuildLimitTipPanel:__ShowComplete()
     if not self.blurBack then
         local setting = { bindNode = self.BlurNode }
         self.blurBack = BlurBack.New(self, setting)
     end
     self:SetActive(false)
     self.blurBack:Show()
end

function BuildLimitTipPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function BuildLimitTipPanel:__delete()

end

function BuildLimitTipPanel:OnClick_ConfirmUse()
    self.args.callback()
    self.mainView:ClosePanel(self)
end

function BuildLimitTipPanel:OnClick_Toggle(isSelect)
    mod.HackingCtrl.needBuildLimitTip = not isSelect
end

function BuildLimitTipPanel:Back()
    self.mainView:ClosePanel(self)
end