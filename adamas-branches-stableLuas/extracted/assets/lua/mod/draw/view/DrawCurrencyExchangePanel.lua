DrawCurrencyExchangePanel = BaseClass("DrawCurrencyExchangePanel", BasePanel)

function DrawCurrencyExchangePanel:__init()
    self:SetAsset("Prefabs/UI/Draw/DrawCurrencyExchangePanel.prefab")
end

function DrawCurrencyExchangePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("Init"))

    if self.valuableDrawItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.valuableDrawItem)
        self.valuableDrawItem = nil
    end
    if self.valuableCurrencyItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.valuableCurrencyItem)
        self.valuableCurrencyItem = nil
    end
    if self.drawItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.drawItem)
        self.drawItem = nil
    end    

    if self.valuableDrawBar then
        self.valuableDrawBar:OnCache()
        self.valuableDrawBar = nil
    end
    if self.valuableCurrencyBar then
        self.valuableCurrencyBar:OnCache()
        self.valuableCurrencyBar = nil
    end

end

function DrawCurrencyExchangePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DrawCurrencyExchangePanel:__Create()
end

function DrawCurrencyExchangePanel:__BindListener()
    self:BindCloseBtn(self.Cancel_btn, self:ToFunc("OnClickCloseBtn"))
    self:BindCloseBtn(self.CommonBack1_btn, self:ToFunc("OnClickCloseBtn"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClickSubmitBtn"))
end

function DrawCurrencyExchangePanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("Init"))
end

function DrawCurrencyExchangePanel:__Show()
    self.TitleText_txt.text = TI18N("提示")
    self.targetId = self.args.drawItemId
    self.targetNum = self.args.drawItemNeedNum
end

function DrawCurrencyExchangePanel:__Hide()
end

function DrawCurrencyExchangePanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({self:ToFunc("Init")})
end

function DrawCurrencyExchangePanel:Init()
    --先用弱海
    self.firstExchangeInfo = DrawConfig.GetExchangeInfo(DrawConfig.ValuableDrawItemId, self.targetId)
    if not self.firstExchangeInfo then
        LogError(string.format("%d 兑换不到 %d", DrawConfig.ValuableDrawItemId, self.targetId))
        return
    end
    --换这些兑换券需要的弱海
    self.needValuableDrawNum = math.ceil(self.targetNum / self.firstExchangeInfo.toNum) * self.firstExchangeInfo.fromNum
    self.exchangeTargetCount = self.needValuableDrawNum / self.firstExchangeInfo.fromNum

    --背包中有的弱海
    self.valuableDrawNum = mod.BagCtrl:GetItemCountById(DrawConfig.ValuableDrawItemId)

    --判断弱海是否足够
    if self.valuableDrawNum < self.needValuableDrawNum then
        --弱海不够 用归一换弱海
        self.valuableDrawExchangeInfo = DrawConfig.GetExchangeInfo(DrawConfig.ValuableCurrencyItemId, DrawConfig.ValuableDrawItemId)
        --需要的归一数
        self.needValuableCurrencyNum = math.ceil((self.needValuableDrawNum - self.valuableDrawNum) / self.valuableDrawExchangeInfo.toNum) * self.valuableDrawExchangeInfo.fromNum
        --背包中有的归一
        self.valuableCurrencyNum = mod.BagCtrl:GetItemCountById(DrawConfig.ValuableCurrencyItemId)
        self.exchangeValuableDrawCount = self.needValuableCurrencyNum / self.valuableDrawExchangeInfo.fromNum
    else
        self.needValuableCurrencyNum = nil
        self.valuableCurrencyNum = nil
        self.exchangeValuableDrawCount = nil
        self.valuableDrawExchangeInfo = nil
    end

    self:InitItem()
end

function DrawCurrencyExchangePanel:InitItem()
    if self.needValuableDrawNum and self.valuableDrawNum > 0 then
        if not self.valuableDrawItem then
            self.valuableDrawItem = self:LoadCommonItem(DrawConfig.ValuableDrawItemId, self.ValuableDrawItem)
        end
        
        UtilsUI.SetActive(self.valuableDrawItem.node.Num, true)
        self.valuableDrawItem.node.Num_txt.text = math.min(self.valuableDrawNum, self.needValuableDrawNum)
        UtilsUI.SetActive(self.ValuableDrawItem, true)
    else
        UtilsUI.SetActive(self.ValuableDrawItem, false)
    end

    if self.needValuableCurrencyNum then
        if not self.valuableCurrencyItem then
            self.valuableCurrencyItem = self:LoadCommonItem(DrawConfig.ValuableCurrencyItemId, self.ValuableCurrencyItem)
        end
        UtilsUI.SetActive(self.valuableCurrencyItem.node.Num, true)
        self.valuableCurrencyItem.node.Num_txt.text = self.needValuableCurrencyNum
        UtilsUI.SetActive(self.ValuableCurrencyItem, true)
    else
        UtilsUI.SetActive(self.ValuableCurrencyItem, false)
    end

    if not self.drawItem then
        self.drawItem = self:LoadCommonItem(self.targetId, self.DrawItem)
    end
    
    UtilsUI.SetActive(self.drawItem.node.Num, true)
    self.drawItem.node.Num_txt.text = self.targetNum
    UtilsUI.SetActive(self.DrawItem, true)

    self:InitCurrencyBar()
end

function DrawCurrencyExchangePanel:InitCurrencyBar()
    if not self.valuableDrawBar then
        self.valuableDrawBar = Fight.Instance.objectPool:Get(CurrencyBar)
        self.valuableDrawBar:init(self.ValuableDrawBar, DrawConfig.ValuableDrawItemId)
    else
        self.valuableDrawBar:UpdateCurrencyCount()
    end

    if not self.valuableCurrencyBar then
        self.valuableCurrencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
        self.valuableCurrencyBar:init(self.ValuableCurrencyBar, DrawConfig.ValuableCurrencyItemId)
    else
        self.valuableCurrencyBar:UpdateCurrencyCount()
    end
end

function DrawCurrencyExchangePanel:OnClickCloseBtn()
    PanelManager.Instance:ClosePanel(self)
end

function DrawCurrencyExchangePanel:OnClickSubmitBtn()
    local tb = {}
    if self.needValuableCurrencyNum then
        if self.valuableCurrencyNum >= self.needValuableCurrencyNum then
            mod.DrawCtrl:DrawItemExchange(self.valuableDrawExchangeInfo.key, self.exchangeValuableDrawCount, false)
        else
            local groupInfo = DrawConfig.GetGroupInfo(self.args.groupId)
            PanelManager.Instance:OpenPanel(DrawJumpPurchaseTipsPanel, { itemId = DrawConfig.ValuableCurrencyItemId })
            self:OnClickCloseBtn()
            return
        end
    end
    
    mod.DrawCtrl:DrawItemExchange(self.firstExchangeInfo.key, self.exchangeTargetCount)
    self:OnClickCloseBtn()
end

function DrawCurrencyExchangePanel:LoadCommonItem(itemId, go)
    local commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
    local itemInfo = ItemConfig.GetItemConfig(itemId)
    itemInfo.template_id = itemId
    commonItem:InitItem(go, itemInfo, true)

    return commonItem
end