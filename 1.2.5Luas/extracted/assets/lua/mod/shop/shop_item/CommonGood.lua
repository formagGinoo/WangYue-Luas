CommonGood = BaseClass("CommonGood", Module)

function CommonGood:__init()
	self.parent = nil
	self.goodInfo = nil
	self.object = nil
	self.itemObj = nil
	self.itemInfo = nil
	self.itemConfig = nil
	self.node = {}
	self.isSelect = false
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function CommonGood:InitGood(object, goodInfo, defaultShow)
	-- 获取对应的组件
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	
	self.itemObj = self.node.CommonItem
	if defaultShow ~= nil then self.defaultShow = defaultShow end
	
	self.loadDone = true

	self:SetGood(goodInfo)

	self.object:SetActive(false)
	self:Show()
end

function CommonGood:SetGood(itemInfo)
	self.goodInfo = itemInfo
	self.itemInfo = ItemConfig.GetItemConfig(self.goodInfo.item_id)
	self.itemInfo.template_id = self.goodInfo.item_id
    if itemInfo and next(itemInfo) then
		local type = ItemConfig.GetItemType(self.itemInfo.id)
		if type == BagEnum.BagType.Partner then
			self.itemConfig = RoleConfig.GetPartnerConfig(self.itemInfo.id)
		elseif type == BagEnum.BagType.Item then
			self.itemConfig = ItemConfig.GetItemConfig(self.itemInfo.id)
		elseif type == BagEnum.BagType.Weapon then
			self.itemConfig = ShopConfig.GetWeaponInfoById(self.itemInfo.id)
		end
    else
        self.itemConfig = nil
    end
end

function CommonGood:Show()
	if not self.loadDone then return end
	self:SetName()
	self:SetCurrency()
	self:SetBuyLimit()
	self:SetCheckBox()
	self:SetReSetTime()

	self.commonItem = CommonItem.New()
	self.commonItem:InitItem(self.itemObj,self.itemInfo,true)

	self:SetCommonItemCount(self.goodInfo.item_count)

	if self.defaultShow then
		self.object:SetActive(true)
	end
end

function CommonGood:SetName()
	local goodName = self.itemInfo.name .. "x" .. self.goodInfo.item_count
	self.node.ItemName_txt.text = goodName
end

local colorCanNotBuy = Color(1,0.36,0.36)
local colorCanBuy = Color(0.41,0.43,0.50 )
function CommonGood:SetCurrency()
	local currency = self.goodInfo.consume[1]
	local nowCurrencyCount = BagCtrl:GetItemCountById(currency.key)
	local itemConfig = ItemConfig.GetItemConfig(currency.key)
    SingleIconLoader.Load(self.node.Currency, ItemConfig.GetItemIcon(itemConfig.id))
	self.node.PriceText_txt.text = currency.value
	if nowCurrencyCount < currency.value then
		self.node.PriceText_txt.color = colorCanNotBuy
	else
		self.node.PriceText_txt.color = colorCanBuy
	end
end

function CommonGood:SetBuyLimit()
	if self.goodInfo.buy_limit == 0 then
		self.node.BuyLimit:SetActive(false)
		self.node.SoldOut:SetActive(false)
		self.node.SingleItem_canvas.alpha = 1
		return
	elseif self.goodInfo.buy_limit == self.goodInfo.buy_count then 
		self.node.BuyLimit:SetActive(false)
		self.node.SoldOut:SetActive(true)
		self.node.SingleItem_canvas.alpha = 0.6
		return
	end
	self.node.SingleItem_canvas.alpha = 1
	self.node.BuyLimit:SetActive(true)
	self.node.SoldOut:SetActive(false)
	local limitText = "限购" .. self.goodInfo.buy_limit - self.goodInfo.buy_count .. "/" .. self.goodInfo.buy_limit
	self.node.BuyLimitText_txt.text = limitText
end

function CommonGood:SetCheckBox()
	if not self.isSelect then 
		self.node.SingleItem_click_fanhui:SetActive(true)
	else
		self.node.SingleItem_Eixt:SetActive(true)
	end
	self.node.CheckBox:SetActive(self.isSelect)
end

function CommonGood:ReSetGoods()
	self.node.SingleItem_click_fanhui:SetActive(true)
end

function CommonGood:OnClick()
	self.node.SingleItem_Eixt:SetActive(true)
end

function CommonGood:SetReSetTime()
	if self.goodInfo.refresh_id == 0 then
		self.node.Time:SetActive(false)
		return 
	end
	self.node.Time:SetActive(true)
	local resettime = TimeUtils.GetRefreshTimeByRefreshId(self.goodInfo.refresh_id)
	if resettime.days > 0 then
		self.node.TimeText_txt.text = resettime.days .. "天" .. resettime.hours .. "时"
	else
		self.node.TimeText_txt.text = resettime.hours .. "时" .. resettime.minutes .. "分"	
	end
end

function CommonGood:SetCommonItemCount(count)
	self.commonItem.node.Level:SetActive(true)
	self.commonItem.node.Level_txt.text = "x" .. count
end

function CommonGood:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.InfoBtn_btn
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
			if not noShowPanel then ItemManager.Instance:ShowItemTipsPanel(self.itemInfo) end
		end
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(onclickFunc)
	end
end

function CommonGood:OnReset()

end