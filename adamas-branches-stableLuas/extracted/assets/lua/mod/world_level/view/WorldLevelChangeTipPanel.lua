WorldLevelChangeTipPanel = BaseClass("WorldLevelChangeTipPanel", BasePanel)

function WorldLevelChangeTipPanel:__init()
    self:SetAsset("Prefabs/UI/WorldLevel/WorldLevelChangeTipPanel.prefab")
end

function WorldLevelChangeTipPanel:__BindListener()
    self:SetHideNode("WorldLevelChangeTipPanel_Exit")
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("OnClick_Close"))
end

function WorldLevelChangeTipPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    if self.callback then
        self.callback()
    end
    InputManager.Instance:MinusLayerCount("UI")
end

function WorldLevelChangeTipPanel:__Show()
    InputManager.Instance:AddLayerCount("UI")
    self.level = self.args.level
    self.callback = self.args.callback
    self.Level_txt.text = self.level - 1
    self.OldLevel_txt.text = self.level
    self.Title_txt.text = TI18N("世界等级")
    self:ShowDetail()

    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
        self.blurBack:Show()
    end
end

function WorldLevelChangeTipPanel:ShowDetail()
    local descs = WorldLevelConfig.GetLevelDesc(self.level)
    for i = 1, #descs, 1 do
        local obj = self:PopUITmpObject("DescObj", self.DescRoot_rect)
        obj.Bg:SetActive(math.fmod(i, 1) == 1)
        obj.Text_txt.text = descs[i]
    end
end

function WorldLevelChangeTipPanel:OnClick_Close()
    PanelManager.Instance:ClosePanel(self)
end