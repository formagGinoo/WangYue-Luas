PurchaseCommonPackage = BaseClass("PurchaseCommonPackage", Module)

function PurchaseCommonPackage:__init()
    self.parent = nil
    self.packageInfo = nil
    self.object = nil
    self.itemObj = nil
    self.packageInfo = nil
    self.itemConfig = nil
    self.node = {}
    self.isSelect = false
    self.isLoadObject = false
    self.loadDone = false
    self.defaultShow = true
end

function PurchaseCommonPackage:InitPackages(object, packageInfo, disCount, defaultShow)
    -- 获取对应的组件
    self.object = object
    self.node = UtilsUI.GetContainerObject(self.object.transform)

    self.itemObj = self.node.CommonItem
    self.disCount = disCount or 10000
    if defaultShow ~= nil then
        self.defaultShow = defaultShow
    end

    self.loadDone = true

    self:SetPackages(packageInfo)

    self.object:SetActive(false)
    self:Show()
end

function PurchaseCommonPackage:SetPackages(packageInfo)
    self.packageInfo = packageInfo
    if packageInfo then
        self.packageConfig = PurchaseConfig:GetPackageById(self.packageInfo.package_id)
    end
end

function PurchaseCommonPackage:Show()
    if not self.loadDone then
        return
    end
    if self.packageInfo.icon ~= "" then
        SingleIconLoader.Load(self.node.Icon, self.packageInfo.icon)
    end
    self.node.Name_txt.text = self.packageInfo.name
    self:SetCurrency()
    self:SetRedPoint()
    self:SetBuyLimit()
    self:SetReSetTime()
    self:SetTag()

    if self.defaultShow then
        self.object:SetActive(true)
    end
end

function PurchaseCommonPackage:SetCurrency()
    if self.packageInfo.cost_item_num == 0 and self.packageInfo.price == 0 then
        self.node.Currency:SetActive(false)
        self.node.PriceText_txt.text = TI18N("免费")
        UtilsUI.SetActive(self.node.Red, true)
    elseif self.packageInfo.price > 0 then
        self.node.Currency:SetActive(false)
        self.node.PriceText_txt.text = TI18N("￥") .. self.packageInfo.price
    else
        self.node.Currency:SetActive(true)
        SingleIconLoader.Load(self.node.Currency, ItemConfig.GetItemIcon(self.packageInfo.cost_item))
        self.node.PriceText_txt.text = self.packageInfo.cost_item_num
    end
end

function PurchaseCommonPackage:SetRedPoint()
    UtilsUI.SetActive(self.node.Red,false)
    -- 免费道具显示红点
    if self.packageInfo.cost_item_num == 0 
    and self.packageInfo.price == 0 
    and self.packageInfo.buy_limit > mod.PurchaseCtrl:GetPackageBuyRecord(self.packageInfo.id) then
        UtilsUI.SetActive(self.node.Red,true)
    end
end

function PurchaseCommonPackage:SetBuyLimit()
    local buy_count = mod.PurchaseCtrl:GetPackageBuyRecord(self.packageInfo.id)
    if self.packageInfo.buy_limit == 0 then
        self.node.BuyLimit:SetActive(false)
        self.node.SoldOut:SetActive(false)
        --self.node.ExchangeScollItem_canvas.alpha = 1
        return
    elseif self.packageInfo.buy_limit == buy_count then
        self.node.BuyLimit:SetActive(false)
        self.node.SoldOut:SetActive(true)
        --self.node.ExchangeScollItem_canvas.alpha = 0.6
        return
    end
    --self.node.ExchangeScollItem_canvas.alpha = 1
    self.node.BuyLimit:SetActive(true)
    self.node.SoldOut:SetActive(false)
    local limitText = string.format(TI18N("限购%d/%d"), self.packageInfo.buy_limit - buy_count, self.packageInfo.buy_limit)
    self.node.BuyLimit_txt.text = limitText
end

function PurchaseCommonPackage:SetReSetTime()
    if not self.packageInfo.refresh or self.packageInfo.refresh == 0 then
        self.node.Time:SetActive(false)
        return
    end
    self.node.Time:SetActive(true)
    local resettime = TimeUtils.GetRefreshTimeByRefreshId(self.packageInfo.refresh)

    if resettime.days > 0 then
        self.node.TimeText_txt.text = string.format(TI18N("%s天%s时"), resettime.days, resettime.hours)
    else
        self.node.TimeText_txt.text = string.format(TI18N("%s时%s分"), resettime.hours, resettime.minutes)
    end
end

function PurchaseCommonPackage:SetTag()
    if not self.packageInfo.show_tag or self.packageInfo.show_tag == 0 then
        self.node.Tag:SetActive(false)
        return
    end
    self.node.Tag:SetActive(true)

    local tagConfig = PurchaseConfig:GetPackageTag(self.packageInfo.show_tag)
    if tagConfig.bg ~= "" then
        AtlasIconLoader.Load(self.node.Tag, tagConfig.bg)
    end

    if tagConfig.id == 1 then
        --此处仅为显示折扣,因为中文和英文的折扣一个是十位一个是百位，所以本地化时需要修改表格中的折扣值
        self.node.TagText_txt.text = self.packageInfo.show_discount .. TI18N(tagConfig.name)
    else
        self.node.TagText_txt.text = TI18N(tagConfig.name)
    end
end

function PurchaseCommonPackage:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
    --local itemBtn = self.node.Bg
    local itemBtn = self.node.Bg.transform:GetComponent(Button)
    if noShowPanel and not btnFunc then
        itemBtn.enabled = false
    else
        itemBtn.enabled = true
        local onclickFunc = function()
            if btnFunc then
                btnFunc()
                if onClickRefresh then
                    self:Show()
                end
                return
            end
            -- if not noShowPanel then ItemManager.Instance:ShowItemTipsPanel(self.packageInfo) end
        end
        itemBtn.onClick:RemoveAllListeners()
        itemBtn.onClick:AddListener(onclickFunc)
    end
end

function PurchaseCommonPackage:OnReset()

end