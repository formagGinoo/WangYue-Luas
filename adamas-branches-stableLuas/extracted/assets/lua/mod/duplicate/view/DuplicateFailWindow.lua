DuplicateFailWindow = BaseClass("DuplicateFailWindow", BaseWindow)
local colorVal = {
    [1] = Color(0, 0, 0, 1),
    [2] = Color(203/255, 90/255, 90/255, 1),
}

--初始化
function DuplicateFailWindow:__init(parent)
    self:SetAsset("Prefabs/UI/Duplicate/DuplicateFailWindow.prefab")
    self.dupTime = 10
end

--添加监听器
function DuplicateFailWindow:__BindListener()
    --self:BindCloseBtn(self.CloseButton_btn, self:ToFunc("PlayExitAnim"))
    self.Cancel_btn.onClick:AddListener(self:ToFunc("ClickCancleBtn"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("ClickSubBtn"))
end

--缓存对象
function DuplicateFailWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DuplicateFailWindow:__Create()

end

function DuplicateFailWindow:__BindEvent()
end

function DuplicateFailWindow:__delete()
    self:StopTimer()
    if self.currencyBar then
        self.currencyBar:OnCache()
    end
    --关掉该界面的时候判断下是否打开了StrengthExchangePanel
    local strengthExchangePanel = PanelManager.Instance:GetPanel(StrengthExchangePanel)
    if strengthExchangePanel then
        PanelManager.Instance:ClosePanel(StrengthExchangePanel)
    end
end

function DuplicateFailWindow:__Show(args)
    self.systemDuplicateId = mod.DuplicateCtrl:GetSystemDuplicateId()
    self.cost = self.args.cost
    self:UpdateBtnView()
    self:OpenTimer()
end

function DuplicateFailWindow:__Hide()

end

function DuplicateFailWindow:__ShowComplete()
    --if not self.blurBack then
    --    local setting = { bindNode = self.BlurNode }
    --    self.blurBack = BlurBack.New(self, setting)
    --end
    --self:SetActive(false)
    --self.blurBack:Show()
end

function DuplicateFailWindow:InitBar()
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
    self.currencyBar:init(self.CurrencyBar, ItemConfig.StrengthId)
    self.CurrencyBar:SetActive(true)
end

function DuplicateFailWindow:UpdateBtnView()
    self:SetDefultBtn()
    --获取目前副本的类型，根据结算成功类型展示不同的按钮
    local systemDuplicateConfig = DuplicateConfig.GetSystemDuplicateConfigById(self.systemDuplicateId)

    local completeType = systemDuplicateConfig.revive_type
    if completeType == 1 then --代表可以重复挑战为0就不可重复挑战
        self.CancelBtn:SetActive(true)
        self.SubmitBtn:SetActive(false)
    end
    --再判断是否有消耗
    local cost = self.cost and self.cost or systemDuplicateConfig.cost
    if cost > 0 then
        self:UpdateCostInfo(cost)
        self:InitBar()
    end
end

function DuplicateFailWindow:SetDefultBtn()
    self.CancelBtn:SetActive(true)
    self.SubmitBtn:SetActive(true)
    self.CostInfo:SetActive(false)
end

function DuplicateFailWindow:OpenTimer()
    self:UpdateCountDownText()
    self.timer = LuaTimerManager.Instance:AddTimer(self.dupTime, 1, function()
        self:DupTimerRun()
    end)
end

function DuplicateFailWindow:StopTimer()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end

function DuplicateFailWindow:UpdateCountDownText()
    self.ContinueText_txt.text = string.format("%s秒后自动退出副本", math.floor(self.dupTime))
end

function DuplicateFailWindow:DupTimerRun()
    self.dupTime = self.dupTime - 1
    self:UpdateCountDownText()
    if self.dupTime <= 0 then
        self:ClickCancleBtn()
    end
end

function DuplicateFailWindow:UpdateCostInfo(cost)
    --self.LastVal_txt.color = colorVal[1]
    self.LastVal_txt.text = cost
    local itemIcon = ItemConfig.GetItemIcon(ItemConfig.StrengthId)
    SingleIconLoader.Load(self.CostIcon, itemIcon, function ()
        self.CostInfo:SetActive(true)
    end)
end

function DuplicateFailWindow:ClickCancleBtn()
    if Fight.Instance then
        Fight.Instance.duplicateManager:ExitDuplicate()
    end
    WindowManager.Instance:CloseWindow(self)
    --self:PlayExitAnim()
end

function DuplicateFailWindow:ClickSubBtn()
    if mod.DuplicateCtrl:IsCanEnterDupByCost(self.systemDuplicateId, self.cost) then
        if Fight.Instance then
            Fight.Instance.duplicateManager:AgainDuplicateLevel()
        end
        WindowManager.Instance:CloseWindow(self)
        --self:PlayExitAnim()
    end
end