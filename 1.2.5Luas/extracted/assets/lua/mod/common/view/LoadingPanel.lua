LoadingPanel = BaseClass("LoadingPanel", BaseView)

function LoadingPanel:__init()
    self:SetAsset("Prefabs/UI/Common/LoadingPanel.prefab")
    self:SetParent(UIDefine.canvasRoot.transform)
end

function LoadingPanel:__CacheObject()
    --self:SetCacheMode(UIDefine.CacheMode.hide)
    self.canvas = self:Find(nil, Canvas)
end

function LoadingPanel:__Show()
    self.canShow = true
    local random = math.random(100)
    self.isLight = random % 2 == 0
    self.Light:SetActive(self.isLight)
    self.Dark:SetActive(not self.isLight)

    -- 做一些特效的layer修改
    UtilsUI.SetEffectSortingOrder(self["21023"], self.canvas.sortingOrder + 1)
    UtilsUI.SetEffectSortingOrder(self["21026"], self.canvas.sortingOrder + 1)

    -- if self.fakeTimer then
    --     LuaTimerManager.Instance:RemoveTimer(self.fakeTimer)
    --     self.fakeTimer = nil
    -- end

    -- self.fakeDuration = 0
    -- self.fakeTimer = LuaTimerManager.Instance:AddTimer(25, 0.06, self:ToFunc("FakeLoading"))
end

function LoadingPanel:FakeLoading()
    self.fakeDuration = self.fakeDuration + 1
    if self.isLight then
        self.LLoading_img.fillAmount = 0.04 * self.fakeDuration
    else
        self.DLoading_img.fillAmount = 0.04 * self.fakeDuration
    end

    if self.fakeDuration == 25 then
        self:Hide()
    end
end

function LoadingPanel:Progress(percentage)
    if not self.canShow then return end
    self.LLoading_img.fillAmount = percentage / 100
    self.DLoading_img.fillAmount = percentage / 100
end

function LoadingPanel:__Hide()
    self.LLoading_img.fillAmount = 0
    self.DLoading_img.fillAmount = 0
end

function LoadingPanel:__delete()
    self.LLoading_img.fillAmount = 0
    self.DLoading_img.fillAmount = 0
end