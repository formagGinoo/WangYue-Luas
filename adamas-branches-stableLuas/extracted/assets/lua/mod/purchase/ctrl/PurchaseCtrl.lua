---@class PurchaseCtrl : Controller
PurchaseCtrl = BaseClass("PurchaseCtrl", Controller)

function PurchaseCtrl:__init()
    EventMgr.Instance:AddListener(EventName.PurchaseOpen, self:ToFunc("OpenPurchase"))
    --充值配置
    self.PurchaseCache = {}
    self.PurchaseCfg = {}
    self.PurchaseRecord = {}
    --礼包配置
    self.PackageCache = {}
    self.PackageCfg = {}
    self.PackageRecord = {}
    --月卡信息
    self.MonthCardInfo = {}
    --兑换配置
    self.ExchangeCfg = {}
    
    -- 商品累计购买记录
    self.historyGoodsPurchaseData = {}
end

--打开商城指定页面，选中指定tab页的指定商品
function PurchaseCtrl:OpenPurchase(purchaseId, tabIndex, itemId)

end

function PurchaseCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.PurchaseOpen, self:ToFunc("OpenPurchase"))
end

-- 充值配置返回
function PurchaseCtrl:UpdatePurchaseCfg(data)
    for _, v in pairs(data.cfg_list) do
        self.PurchaseCache[v.id] = v
    end
    self.PurchaseCfg = TableUtils.CopyTable(self.PurchaseCache)
    table.sort(self.PurchaseCfg, function(a, b) return a.priority > b.priority end)
end

function PurchaseCtrl:UpdateHistoryPurchaseData(_data)
    if not _data then
        return
    end
    
    local itemList = _data.next

    for i = 1, #itemList do
        local goodsCfg = Config.DataGoods.Find[itemList[i].key]
        local quality = Config.DataItem.Find[goodsCfg.obtain_id].quality
        local shopType = Config.DataShop.Find[goodsCfg.shop_id].shop_type
        local itemType = Config.DataItem.Find[goodsCfg.obtain_id].type

        if not self.historyGoodsPurchaseData[shopType] then
            self.historyGoodsPurchaseData[shopType] = {}
        end
        
        table.insert(self.historyGoodsPurchaseData[shopType], {id = itemList[i].key, quality = quality, itemType = itemType, num = itemList[i].value})
    end
end

function PurchaseCtrl:GetHistoryPurchaseData(_shopType)
    if self.historyGoodsPurchaseData[_shopType] then
        return self.historyGoodsPurchaseData[_shopType]
    end
    
    return nil
end

-- 充值次数返回
function PurchaseCtrl:UpdatePurchaseRecord(data)
    for _, v in pairs(data.buy_count_list) do
        self.PurchaseRecord[v.key] = v.value
    end
    EventMgr.Instance:Fire(EventName.OnPurchaseRecord)
end

-- 买礼包
function PurchaseCtrl:DoRecharge(rechargeId)
    local id, cmd = mod.PurchaseFacade:SendMsg("purchase_buy", rechargeId)
    CurtainManager.Instance:EnterWait()
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        CurtainManager.Instance:ExitWait()
    end)
end

function PurchaseCtrl:UpdatePackageCfg(data)
    for _, cfg in pairs(data.cfg_list) do
        if not self.PackageCache[cfg.page] then
            self.PackageCache[cfg.page] = {}
        end
        for i, info in ipairs(self.PackageCache[cfg.page]) do
            if cfg.id == info.id then
                goto continue
            end
        end
        table.insert(self.PackageCache[cfg.page], cfg)
        ::continue::
        --self.PackageCache[cfg.page][cfg.id] = cfg
    end

    self.PackageCfg = TableUtils.CopyTable(self.PackageCache)
    for k, pageCfg in pairs(self.PackageCfg) do
        table.sort(pageCfg, function(a, b) return a.priority > b.priority end)
        self.PackageCfg[k] = pageCfg
    end
end

-- 礼包购买次数
function PurchaseCtrl:UpdatePackageRecord(data)
    for _, v in pairs(data.buy_count_list) do
        self.PackageRecord[v.key] = v.value
    end
    EventMgr.Instance:Fire(EventName.GetPurchasePackage)
end

function PurchaseCtrl:GetPackageBuyRecord(packageId)
    return self.PackageRecord[packageId] or 0
end

function PurchaseCtrl:GetPackageList(pageId)
    return self.PackageCfg[pageId] or {}
end


function PurchaseCtrl:UpdateMonthInfo(data)
    self.MonthCardInfo = data.card_list
    -- 跨天推送
    if Fight.Instance and Fight.Instance.clientFight then
        self:GetDailyMonthcardReward()
    end
    EventMgr.Instance:Fire(EventName.MonthCardUpdate)
end

function PurchaseCtrl:GetCardListById(id)
    return self.MonthCardInfo[id]
end


function PurchaseCtrl:UpdateExchangeCfg(data)
    for k, v in pairs(data) do

    end
end

function PurchaseCtrl:BuyPackage(packageId)
    local id, cmd = mod.PurchaseFacade:SendMsg("purchase_package_buy", packageId)
    -- CurtainManager.Instance:EnterWait()
    -- mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
    --     CurtainManager.Instance:ExitWait()
    -- end)
end

function PurchaseCtrl:BuyMonthCard(cardId)
    local cardInfo = PurchaseConfig.DataMonthcard[cardId]
    if self.MonthCardInfo[cardId] and cardInfo.duration + self.MonthCardInfo[cardId].rest_day > cardInfo.limit then
        MsgBoxManager.Instance:ShowTips(TI18N("剩余天数已达上限"))
        return
    end
    local id, cmd = mod.PurchaseFacade:SendMsg("monthcard_buy", cardId)
    CurtainManager.Instance:EnterWait()
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        CurtainManager.Instance:ExitWait()
    end)
end

function PurchaseCtrl:GetDailyMonthcardReward()
    local cardInfo = self.MonthCardInfo[PurchaseConfig.RecommendPageType.MonthCard]
    if cardInfo and cardInfo.is_reward == 0 and cardInfo.rest_day > 0 then
        mod.PurchaseFacade:SendMsg("monthcard_reward", PurchaseConfig.RecommendPageType.MonthCard)
    end
end

function PurchaseCtrl:CheckRedPointByPage(page)
    local packages = self:GetPackageList(page)
    for k, v in pairs(packages) do
        if v.cost_item_num == 0 and v.price == 0 and v.buy_limit > self:GetPackageBuyRecord(v.id)then
            return true
        end
    end
    return false
end

--是否有可见物品
function PurchaseCtrl:CheckCanSeeItemByPage(page)
    local packages = self:GetPackageList(page)
    for k, v in pairs(packages) do
        if v.soldout_show == true then
            return true
        end
        if v.buy_limit > self:GetPackageBuyRecord(v.id) then
            return true
        end
    end
    return false
end