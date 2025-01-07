GoodsInfoTip = BaseClass("GoodsInfoTip",Module)


function GoodsInfoTip:__init(gameObject)
    UtilsUI.GetContainerObject(gameObject.transform, self)
end

function GoodsInfoTip:__delete()
end

function GoodsInfoTip:SetGoodsInfo(goodsId,disConut)
    local goodsInfo = mod.ShopCtrl:GetGoodsInfo(goodsId)
    self.goodsInfo = goodsInfo
    self.disCount = disConut
    self.itemInfo = ItemConfig.GetItemConfig(goodsInfo.item_id)
    self:SetIcon()
    self:SetPrice()
    self:SetDesc()
end

function GoodsInfoTip:SetIcon()
    SingleIconLoader.Load(self.GoodsIcon, self.itemInfo.icon)

    local frontImg, backImg, itemFrontImg = ItemManager.GetItemColorImg(self.itemInfo.quality)
    if not frontImg or not backImg or not itemFrontImg then
        LogError("")
        return
    end

    local frontPath = AssetConfig.GetQualityIcon(itemFrontImg)
    local backPath = AssetConfig.GetQualityIcon(backImg)
    SingleIconLoader.Load(self.Quality, backPath)
end

local colorCanNotBuy = Color(1,0.36,0.36)
local colorCanBuy = Color(1,1,1)
function GoodsInfoTip:SetPrice()
	local currency = self.goodsInfo.consume[1]
	local nowCurrencyCount = BagCtrl:GetItemCountById(currency.key)
	local itemConfig = ItemConfig.GetItemConfig(currency.key)
    SingleIconLoader.Load(self.PriceIcon, itemConfig.icon)
    SingleIconLoader.Load(self.HaveIcon, itemConfig.icon)
    self.PriceTitle_txt.text = TI18N("价格")
    self.HaveCountTitle_txt.text = TI18N("货币拥有量")
    local price = math.floor(currency.value * self.disCount / 10000)
	self.PriceGold_txt.text = price
    self.HaveGold_txt.text = nowCurrencyCount
	if nowCurrencyCount < price then
		self.PriceGold_txt.color = colorCanNotBuy
	else
		self.PriceGold_txt.color = colorCanBuy
	end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Have.transform)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Price.transform)
end

function GoodsInfoTip:SetDesc()
    self.GoodsName_txt.text = TI18N(self.itemInfo.name)
    self.GoodsDesc_txt.text = TI18N(self.itemInfo.desc)
end

function GoodsInfoTip:RefreshCurrency()
    self:SetPrice()
end