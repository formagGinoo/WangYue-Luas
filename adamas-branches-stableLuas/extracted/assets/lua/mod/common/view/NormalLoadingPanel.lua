NormalLoadingPanel = BaseClass("NormalLoadingPanel", BaseView)

function NormalLoadingPanel:__init()
    self:SetAsset("Prefabs/UI/Common/NormalLoadingPanel.prefab")
    self:SetParent(UIDefine.canvasRoot.transform)
end

function NormalLoadingPanel:__CacheObject()

end

function NormalLoadingPanel:__BindListener()
    self.ContentImg_btn.onClick:AddListener(self:ToFunc("ChangeContent"))
end

function NormalLoadingPanel:__AfterExitAnim()
    self:Hide()
end

function NormalLoadingPanel:__Show()
    self.LoadingBar_img.fillAmount = 0
    self.LoadingTxt_txt.text = "0%"
    self:ChangeContent()
    if not self.updateTimer then
        self.updateTimer = LuaTimerManager.Instance:AddTimer(0, 0.1, self:ToFunc("Update"))
    end
end

function NormalLoadingPanel:__Hide()
    self.LoadingBar_img.fillAmount = 0
    self.LoadingTxt_txt.text = "0"
    if self.updateTimer then
        LuaTimerManager.Instance:RemoveTimer(self.updateTimer)
        self.updateTimer = nil
    end
end

function NormalLoadingPanel:Progress(percentage)
    if not self.active then return end
    self.LoadingBar_img.fillAmount = percentage / 100
    self.LoadingTxt_txt.text = math.floor(percentage)
end

function NormalLoadingPanel:ChangeContent()
    self.changeTimer = self.changeTimer or SystemConfig.AutoChangeTime()
    if self.changeTimer < 1 then
        return
    end
    self.changeTimer = 0

    local info = SystemConfig.GetRandomInfo(self.lastInfoId)
    local data = SystemConfig.GetRandomText(info.id, self.lastTextId)
    self.lastTextId = data.id
    self.lastInfoId = info.id
    SingleIconLoader.Load(self.ContentImg, info.img)
    self.Title_txt.text = data.title
    self.ContentText_txt.text = data.content
    --self.SubTitle_txt.text = data.pinyin
end

function NormalLoadingPanel:Update()
    self.changeTimer = self.changeTimer + 0.1
    if self.changeTimer >= SystemConfig.AutoChangeTime() then
        self:ChangeContent()
    end
end