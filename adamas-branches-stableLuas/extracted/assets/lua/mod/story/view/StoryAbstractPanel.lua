StoryAbstractPanel = BaseClass("StoryAbstractPanel", BasePanel)

function StoryAbstractPanel:__init()
    self:SetAsset("Prefabs/UI/Story/StoryAbstractPanel.prefab")
end

function StoryAbstractPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function StoryAbstractPanel:__BindListener()
    self.Cancel2_btn.onClick:AddListener(function ()
        self:PlayExitAnim()
    end)
    self.CommonGrid_btn.onClick:AddListener(function ()
        self:PlayExitAnim()
    end)
    self.Submit2_btn.onClick:AddListener(function ()
        self.submit = true
        self:PlayExitAnim()
    end)
end

function StoryAbstractPanel:__Show()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    self:SetActive(false)
    self.blurBack:Show({function ()
        self:SetActive(true)
    end})

    self.groupId = self.args.groupId
    self.TitleText_txt.text = TI18N("跳过剧情") 
    self:ShowDetail()
end

function StoryAbstractPanel:__Hide()
    if self.submit then
        Story.Instance:ExitStory(true)
    else
        StoryController.Instance:SetSpeed(1)
    end
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function StoryAbstractPanel:ShowDetail()
    local config = StoryConfig.GetGroupAbstract(self.groupId)
    if config.title ~= "" then
        self.Title:SetActive(true)
        self.Title_txt.text = config.title
    else
        self.Title:SetActive(false)
    end
    self.Desc_txt.text = config.desc
end

function StoryAbstractPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end