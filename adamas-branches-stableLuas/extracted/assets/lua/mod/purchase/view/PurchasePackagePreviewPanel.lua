PurchasePackagePreviewPanel = BaseClass("PurchasePackagePreviewPanel", BasePanel)

function PurchasePackagePreviewPanel:__init()
    self:SetAsset("Prefabs/UI/Purchase/PurchasePackagePreviewPanel.prefab")
    self.itemObjList = {}
end

function PurchasePackagePreviewPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Close_HideCallBack"))
    self.Buy_btn.onClick:AddListener(self:ToFunc("OnClick_BuyPackage"))
end

function PurchasePackagePreviewPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PurchasePackagePreviewPanel:__Create()

end

function PurchasePackagePreviewPanel:__delete()
    if self.currencyBarClass then
        self.currencyBarClass:OnCache()
        self.currencyBarClass = nil
    end
end

function PurchasePackagePreviewPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function PurchasePackagePreviewPanel:__Hide()

end

function PurchasePackagePreviewPanel:OnClick_BuyPackage()
    --付费道具到时候要接SDK 现在付费的道具就当免费的可以直接买
    if self.data.price == 0 then
        if mod.BagCtrl:GetItemCountById(self.data.cost_item) < self.data.cost_item_num then
            MsgBoxManager.Instance:ShowTips(string.format(TI18N("%s不足"),ItemConfig.GetItemConfig(self.data.cost_item).name))
            return
        end
    end
    mod.PurchaseCtrl:BuyPackage(self.data.id)
    PanelManager.Instance:ClosePanel(self)
end

function PurchasePackagePreviewPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end

function PurchasePackagePreviewPanel:__Show()
    self.data = self.args.data
    self.packagePageId = self.args.packagePageId
    self.data.buy_count = mod.PurchaseCtrl:GetPackageBuyRecord(self.data.id)
    self:ShowInfo(self.data)
end

function PurchasePackagePreviewPanel:ShowInfo(data)
    self:SetTag(data)
    self.PackageName_txt.text = data.name
    SingleIconLoader.Load(self.PackageIcon, data.icon)
    self:SetBuyLimit(data)
    self:SetCurrencyBtn(data)
    self:SetReSetTime(data)
    self:SetCurrencyBar(data.cost_item)
    self:SetItemsInfo(data)
end

function PurchasePackagePreviewPanel:SetBuyLimit(data)
    if data.buy_limit == 0 then
        self.BuyLimit:SetActive(false)
        return
    elseif data.buy_limit == data.buy_count then
        self.BuyLimit:SetActive(false)
        return
    end
    self.BuyLimit:SetActive(true)
    local limitText = string.format(TI18N("限购%d/%d"), data.buy_limit - data.buy_count, data.buy_limit)
    self.BuyLimit_txt.text = limitText
end

function PurchasePackagePreviewPanel:SetTag(data)
    if not data.show_tag or data.show_tag == 0 then
        self.Tag:SetActive(false)
        return
    end
    self.Tag:SetActive(true)
    local tagConfig = PurchaseConfig:GetPackageTag(data.show_tag)
    SingleIconLoader.Load(self.Tag, tagConfig.bgmir)
    if tagConfig.id == 1 then
        --此处仅为显示折扣,因为中文和英文的折扣一个是十位一个是百位，所以本地化时需要修改表格中的折扣值
        self.TagText_txt.text = data.show_discount .. TI18N(tagConfig.name)
    else
        self.TagText_txt.text = TI18N(tagConfig.name)
    end
end

function PurchasePackagePreviewPanel:SetReSetTime(data)
    if data.refresh == 0 then
        self.Time:SetActive(false)
        return
    end
    self.Time:SetActive(true)
    local resettime = TimeUtils.GetRefreshTimeByRefreshId(data.refresh)

    if resettime.days > 0 then
        self.TimeText_txt.text = string.format(TI18N("%s天%s时后下架"), resettime.days, resettime.hours)
    else
        self.TimeText_txt.text = string.format(TI18N("%s时%s分后下架"), resettime.hours, resettime.minutes)
    end
end

function PurchasePackagePreviewPanel:SetCurrencyBtn(data)
    if data.cost_item_num == 0 and data.price == 0 then
        self.PriceIcon:SetActive(false)
        self.PriceText_txt.text = TI18N("免费")
    elseif data.price > 0 then
        self.PriceIcon:SetActive(false)
        self.PriceText_txt.text = TI18N("￥") .. data.price
    else
        self.PriceIcon:SetActive(true)
        SingleIconLoader.Load(self.PriceIcon, ItemConfig.GetItemIcon(data.cost_item))
        self.PriceText_txt.text = data.cost_item_num
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Buy.transform)
end

function PurchasePackagePreviewPanel:SetCurrencyBar(curId)
    if curId == 0 then
        UtilsUI.SetActive(self.CurrencyBar, false)
        return
    end
    self.currencyBarClass = Fight.Instance.objectPool:Get(CurrencyBar)
	self.currencyBarClass:init(self.CurrencyBar, curId)
end

function PurchasePackagePreviewPanel:SetItemsInfo(info)
    local data = PurchaseConfig.GetRewardList(info.reward_id)
    for i, singleItemData in ipairs(data) do
        local itemObj = self:GetItemObj()
        local singleItem = PurchasePackageSingleReward.New()
        singleItem:InitItem(itemObj, singleItemData[1], singleItemData[2], singleItemData[1])
        self.itemObjList[i] = itemObj
    end
end

function PurchasePackagePreviewPanel:GetItemObj()
    local obj = self:PopUITmpObject("PackageSingleReward")
    obj.objectTransform:SetParent(self.CommonRewardList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetActive(true)
    return obj
end