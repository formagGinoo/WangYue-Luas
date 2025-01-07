DuplicateSuccessWindow = BaseClass("DuplicateSuccessWindow", BaseWindow)
local colorVal = {
    [1] = Color(0, 0, 0, 1),
    [2] = Color(203/255, 90/255, 90/255, 1),
}

--初始化
function DuplicateSuccessWindow:__init(parent)
    self:SetAsset("Prefabs/UI/Duplicate/DuplicateSuccessWindow.prefab")
    self.itemList = {}
    self.dupTime = 30
end

--添加监听器
function DuplicateSuccessWindow:__BindListener()
    --self:BindCloseBtn(self.CloseButton_btn, self:ToFunc("PlayExitAnim"))
    self.Cancel_btn.onClick:AddListener(self:ToFunc("ClickCancleBtn"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("ClickSubBtn"))
end

--缓存对象
function DuplicateSuccessWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DuplicateSuccessWindow:__Create()

end

function DuplicateSuccessWindow:__BindEvent()
end

function DuplicateSuccessWindow:__delete()
    if self.awardItemList and next(self.awardItemList)then
        for key, value in pairs(self.awardItemList) do
            value:Destroy()
            PoolManager.Instance:Push(PoolType.class, "AwardItem", value)
        end
    end
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

function DuplicateSuccessWindow:SetEffectLayer()
    local layer = WindowManager.Instance:GetCurOrderLayer()
    -- UtilsUI.SetEffectSortingOrder(self["22101"], layer + 1)
    -- self.ItemScroll.transform:GetComponent(Canvas).sortingOrder = layer + 2
end

function DuplicateSuccessWindow:__Show(args)
    self.awardItemList = {}
    self.itemList = self.args.reward_list
    self.cost = self.args.cost
    self.systemDuplicateId = mod.DuplicateCtrl:GetSystemDuplicateId()
    
    self:UpdateBtnView()
    self:OpenTimer()
    self.itemScrollComp = self.ItemScroll.transform:GetComponent(ScrollRect)
    self:UpdateData(self.itemList)
    --self:SetEffectLayer()
    self:SetItemScroll()
end

function DuplicateSuccessWindow:__Hide()

end

function DuplicateSuccessWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function DuplicateSuccessWindow:InitBar()
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
    self.currencyBar:init(self.CurrencyBar, ItemConfig.StrengthId)
    self.CurrencyBar:SetActive(true)
end

function DuplicateSuccessWindow:SetItemScroll()
    if #self.itemList > 5 then
        UnityUtils.SetAnchoredPosition(self.ItemScroll.transform, 0,-15)
    end
    if #self.itemList > 10 then
        self.itemScrollComp.movementType = 1
    else
        self.itemScrollComp.movementType = 2
    end
end

function DuplicateSuccessWindow:UpdateData(itemList)
    for key, value in pairs(itemList) do
        local itemConfig = ItemConfig.GetItemConfig(value.template_id)
        if not itemConfig then
            LogError("找不到配置 id = ".. value.template_id)
            return
        end

        local itemCell = GameObject.Instantiate(self.AwardItem, self.Items_rect)
        self.awardItemList[key] = PoolManager.Instance:Pop(PoolType.class, "AwardItem")
        if not self.awardItemList[key] then
            self.awardItemList[key] = AwardItem.New()
        end
        self.awardItemList[key]:InitItem(itemCell, value.template_id, value.count, value.unique_id)
    end
end

function DuplicateSuccessWindow:__AfterExitAnim()
    UtilsUI.SetActiveByScale(self.Items,false)
    WindowManager.Instance:CloseWindow(self)
end

function DuplicateSuccessWindow:UpdateBtnView()
    self:SetDefultBtn()
    --获取目前副本的类型，根据结算成功类型展示不同的按钮
    local systemDuplicateConfig = DuplicateConfig.GetSystemDuplicateConfigById(self.systemDuplicateId)

    local completeType = systemDuplicateConfig.complete_type
    if completeType == 1 then --代表可以重复挑战为0就不可重复挑战
        self.CancelBtn:SetActive(true)
        self.SubmitBtn:SetActive(true)
    end
    --再判断是否有消耗
    local cost = self.cost and self.cost or systemDuplicateConfig.cost
    if cost > 0 then
        self:UpdateCostInfo(cost)
        self:InitBar()
    end
end

function DuplicateSuccessWindow:SetDefultBtn()
    self.CancelBtn:SetActive(true)
    self.SubmitBtn:SetActive(false)
    self.CostInfo:SetActive(false)
end

function DuplicateSuccessWindow:OpenTimer()
    self.ContinueText_txt.text = string.format("%s秒后自动退出副本", math.floor(self.dupTime))
    self.timer = LuaTimerManager.Instance:AddTimer(self.dupTime, 1, function()
        self:DupTimerRun()
    end)
end

function DuplicateSuccessWindow:StopTimer()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end

function DuplicateSuccessWindow:DupTimerRun()
    self.dupTime = self.dupTime - 1
    self.ContinueText_txt.text = string.format("%s秒后自动退出副本", math.floor(self.dupTime))
    if self.dupTime <= 0 then
        self:ClickCancleBtn()
    end
end

function DuplicateSuccessWindow:UpdateCostInfo(cost)
    self.LastVal_txt.color = colorVal[1]
    self.LastVal_txt.text = cost
    local itemIcon = ItemConfig.GetItemIcon(ItemConfig.StrengthId)
    SingleIconLoader.Load(self.CostIcon, itemIcon, function ()
        self.CostInfo:SetActive(true)
    end)
end

function DuplicateSuccessWindow:ClickCancleBtn()
    if Fight.Instance then
        Fight.Instance.duplicateManager:ExitDuplicate()
    end
    WindowManager.Instance:CloseWindow(self)
    --self:PlayExitAnim()
end

function DuplicateSuccessWindow:ClickSubBtn()
    if mod.DuplicateCtrl:IsCanEnterDupByCost(self.systemDuplicateId, self.cost) then
        if Fight.Instance then
            Fight.Instance.duplicateManager:AgainDuplicateLevel()
        end
        WindowManager.Instance:CloseWindow(self)
        --self:PlayExitAnim()
    end
end