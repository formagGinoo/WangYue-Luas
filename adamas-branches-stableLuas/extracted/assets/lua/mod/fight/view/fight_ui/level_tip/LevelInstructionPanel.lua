LevelInstructionPanel = BaseClass("LevelInstructionPanel", BasePanel)

function LevelInstructionPanel:__init()
    self:SetAsset("Prefabs/UI/Fight/LevelTips/LevelInstructionPanel.prefab")
end

function LevelInstructionPanel:__delete()

end

function LevelInstructionPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function LevelInstructionPanel:__BindListener()
    self.BackClose_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function LevelInstructionPanel:__Show(args)
    BehaviorFunctions.Pause()
    self:SetBlurBack()

    self.showId = self.args[1]
    self.config = SystemConfig.GetLevelTipConfig(self.showId)

    if not self.config or not next(self.config) then
        return
    end

    self:ShowContent(self.config.type)
end

function LevelInstructionPanel:__Hide()
    BehaviorFunctions.Resume()
    EventMgr.Instance:Fire(EventName.LevelInstructionComplete, self.showId)
end

function LevelInstructionPanel:ShowContent(type)
    UtilsUI.SetActive(self.Text, type == LevelEnum.InstructionType.Text)
    UtilsUI.SetActive(self.Image, type == LevelEnum.InstructionType.Image)

    if type == LevelEnum.InstructionType.Text then
        self:ShowText()
    elseif type == LevelEnum.InstructionType.Image then
        self:ShowImageInstruction()
    end
end

function LevelInstructionPanel:ShowText()
    self.TextTitle_txt.text = self.config.title
    self.TextDesc_txt.text = self.config.desc
end

function LevelInstructionPanel:ShowImageInstruction()
    self.ImageTitle_txt.text = self.config.title
    self.ImageDesc_txt.text = self.config.desc
    SingleIconLoader.Load(self.ShowImage, self.config.image)
end

function LevelInstructionPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(LevelInstructionPanel)
end