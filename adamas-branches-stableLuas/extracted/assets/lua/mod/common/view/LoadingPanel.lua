LoadingPanel = BaseClass("LoadingPanel", BaseView)

function LoadingPanel:__init()
    self:SetAsset("Prefabs/UI/Common/LoadingPanel.prefab")
    self:SetParent(UIDefine.canvasRoot.transform)
end

function LoadingPanel:__CacheObject()
    --self:SetCacheMode(UIDefine.CacheMode.hide)
    self.canvas = self:Find(nil, Canvas)
end

function LoadingPanel:__BindListener()
    -- self.Dark_btn.onClick:AddListener(self:ToFunc("ChangeContent"))
    self.Light_btn.onClick:AddListener(self:ToFunc("ChangeContent"))
end

function LoadingPanel:__Show()
    local random = math.random(100)
    -- self.isLight = random % 2 == 0
    self.isLight = true
    self.Light:SetActive(self.isLight)
    -- self.Dark:SetActive(not self.isLight)

    -- 做一些特效的layer修改
    --UtilsUI.SetEffectSortingOrder(self["21023"], self.canvas.sortingOrder + 1)
    --UtilsUI.SetEffectSortingOrder(self["21026"], self.canvas.sortingOrder + 1)

	collectgarbage("collect")
    self:ChangeContent()
    if not self.updateTimer then
        self.updateTimer = LuaTimerManager.Instance:AddTimer(0, 0.1, self:ToFunc("Update"))
    end
end

function LoadingPanel:Progress(percentage)
    if not self.active then return end
    self.LLoading_img.fillAmount = percentage / 100
    self.DLoading_img.fillAmount = percentage / 100
    self.LLoading2_img.fillAmount = percentage / 100
    self.DLoading2_img.fillAmount = percentage / 100
    
end

function LoadingPanel:__AfterExitAnim()
    self:Hide()
end

function LoadingPanel:__Hide()
	collectgarbage("collect")
    self.LLoading_img.fillAmount = 0
    self.DLoading_img.fillAmount = 0
    self.LLoading2_img.fillAmount = 0
    self.DLoading2_img.fillAmount = 0
    if self.updateTimer then
        LuaTimerManager.Instance:RemoveTimer(self.updateTimer)
        self.updateTimer = nil
    end
end

function LoadingPanel:__delete()
    self.LLoading_img.fillAmount = 0
    self.DLoading_img.fillAmount = 0
    self.LLoading2_img.fillAmount = 0
    self.DLoading2_img.fillAmount = 0
end

function LoadingPanel:ChangeContent()
    self.changeTimer = self.changeTimer or SystemConfig.AutoChangeTime()
    if self.changeTimer < 1 then
        return
    end
    self.changeTimer = 0

    local random = math.random(100)
    random = random % 2 == 0 and 101 or 102
    local data = SystemConfig.GetRandomText(random, self.lastTextId)
    self.lastTextId = data.id

    --self.DTips_txt.text = data.content
    --self.DTips_txt.text = data.content
end

function LoadingPanel:Update()
    self.changeTimer = self.changeTimer + 0.1
    if self.changeTimer >= SystemConfig.AutoChangeTime() then
        self:ChangeContent()
    end
end