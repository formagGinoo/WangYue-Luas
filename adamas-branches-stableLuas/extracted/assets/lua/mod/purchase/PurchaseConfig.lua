PurchaseConfig = PurchaseConfig or {}

PurchaseConfig.DataShop = Config.DataShop.Find
PurchaseConfig.DataMonthcard = Config.DataMonthcard.Find
PurchaseConfig.DataReward = Config.DataReward.Find
PurchaseConfig.PackagePage = Config.DataPackagePage.Find
PurchaseConfig.DataPurchase = Config.DataPurchase.Find
PurchaseConfig.Package = Config.DataPackage.Find
PurchaseConfig.DataPackageTag = Config.DataPackageTag.Find

PurchaseConfig.PageType = {
    Recommend = 1, --推荐商品
    Package = 2, --礼包商城
    Skin = 3, --装扮
    Exchange = 4, --兑换商店
    Recharge = 5, --充值
}

PurchaseConfig.PagePanel = {
	[1] = PurchaseRecommendPanel,
	[2] = PurchasePackagePanel,
	[4] = PurchaseExchangePanel,
	[5] = PurchaseRechargePanel,
}

-- 主页签
PurchaseConfig.PageTypeRedPoint = {
    [PurchaseConfig.PageType.Recommend] = RedPointName.PurchaseRecommend,
    [PurchaseConfig.PageType.Package] = RedPointName.PurchasePackage,
    [PurchaseConfig.PageType.Skin] = RedPointName.PurchaseSkin,
    [PurchaseConfig.PageType.Exchange] = RedPointName.PurchaseExchange,
    [PurchaseConfig.PageType.Recharge] = RedPointName.PurchaseRecharge,
}

-- 礼包商城红点
PurchaseConfig.PackageTypeRedPoint = {
    [PurchaseConfig.PackagePage[1].id] = RedPointName.PurchasePackagePageRMB,
    [PurchaseConfig.PackagePage[2].id] = RedPointName.PurchasePackagePageDaily,
    [PurchaseConfig.PackagePage[3].id] = RedPointName.PurchasePackagePageLevel,
}

PurchaseConfig.RecommendPageType = {
    MonthCard = 1,
}


function PurchaseConfig.GetRewardList(rewardId)
	local reward = PurchaseConfig.DataReward[rewardId]
	if reward then
		return reward.reward_list
	end
end

PurchaseConfig.PurchaseToggleInfo = {
    {
        type = PurchaseConfig.PageType.Recommend,
        icon = { "Textures/Icon/Atlas/PurchaseIcon/s_month_card.png", "Textures/Icon/Atlas/PurchaseIcon/u_month_card.png" },
        name = TI18N("推荐商品"),
        currencyList = {3,4},
        systemId = SystemConfig.SystemOpenId.Monthcard,
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PurchaseRecommendPanel)
            else
                parent:ClosePanel(PurchaseRecommendPanel)
            end
        end
    },
    {
        type = PurchaseConfig.PageType.Package,
        icon = { "Textures/Icon/Atlas/PurchaseIcon/s_package.png", "Textures/Icon/Atlas/PurchaseIcon/u_package.png" },
        name = TI18N("礼包商城"),
        currencyList = {3,4},
        systemId = SystemConfig.SystemOpenId.LiBao,
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PurchasePackagePanel)
            else
                parent:ClosePanel(PurchasePackagePanel)
            end
        end
    },
    {
        type = PurchaseConfig.PageType.Exchange,
        icon = { "Textures/Icon/Atlas/PurchaseIcon/s_exchange.png", "Textures/Icon/Atlas/PurchaseIcon/u_exchange.png" },
        name = TI18N("兑换商店"),
        currencyList = nil,
        systemId = SystemConfig.SystemOpenId.Exchanage,
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PurchaseExchangePanel)
            else
                parent:ClosePanel(PurchaseExchangePanel)
            end
        end
    },
    {
        type = PurchaseConfig.PageType.Recharge,
        icon = { "Textures/Icon/Atlas/PurchaseIcon/s_recharge.png", "Textures/Icon/Atlas/PurchaseIcon/u_recharge.png" },
        name = TI18N("充值"),
        currencyList = {4},
        systemId = SystemConfig.SystemOpenId.ChongZhi,
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(PurchaseRechargePanel)
            else
                parent:ClosePanel(PurchaseRechargePanel)
            end
        end
    },
}

PurchaseConfig.PurchaseRecommendToggleInfo = {
    {
        type = PurchaseConfig.RecommendPageType.MonthCard,
        name = TI18N("月卡"),
        currencyList = {3,4},
        callback = function(parent, isSelect)
            if isSelect then
                local panel = PanelManager.Instance:GetPanel(PurchaseMonthCardPanel)
                if not panel then
                    PanelManager.Instance:OpenPanel(PurchaseMonthCardPanel)
                end
            else
                PanelManager.Instance:ClosePanel(PurchaseMonthCardPanel)
            end
        end
    },
}


function PurchaseConfig:GetPurchaseRechargeList()
    local data = TableUtils.CopyTable(self.DataPurchase)
    table.sort(data, function(a, b)
        return a.priority > b.priority
    end)
    return data
end


function PurchaseConfig:GetPackagePage()
    local data = TableUtils.CopyTable(self.PackagePage)
    table.sort(data, function(a, b)
        return a.priority > b.priority
    end)
    return data
end


function PurchaseConfig:GetPackage()
    local data = TableUtils.CopyTable(self.Package)
    table.sort(data, function(a, b)
        return a.priority > b.priority
    end)
    return data
end

function PurchaseConfig:GetPackageById(packageId)
    return self.Package[packageId]
end

function PurchaseConfig:GetPackageTag(id)
    return self.DataPackageTag[id]
end