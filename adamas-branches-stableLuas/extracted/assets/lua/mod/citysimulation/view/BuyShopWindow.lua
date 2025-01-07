BuyShopWindow = BaseClass("BuyShopWindow", BaseWindow)
BuyShopWindow.active = true

function BuyShopWindow:__init()
	self:SetAsset("Prefabs/UI/CitySimulation/BuyShopWindow.prefab")
	
	self.cardItemList = {}
end

function BuyShopWindow:__BindListener()
	self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
	self.ConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClick_SendConfirmMsg"))
end

function BuyShopWindow:__Show()
	self:InitBar()

	self.shopId = self.args.shopId
	self.shopLevelData = CitySimulationConfig:GetCityOperateUpData(self.shopId, 1)
	self.IncomeText_txt.text = TI18N("每日营业额")
	self.TipsText_txt.text = TI18N("购买后将解锁业务")
	self.CostText_txt.text = TI18N("需要") .. ":"
	local shopName = CitySimulationConfig:GetCityOperateMainData(self.shopId).store_name
	self.ShopName_txt.text = TI18N(shopName)
	self.IncomeValue_txt.text = self.shopLevelData.store_revenue
	self.CostValue_txt.text = self.shopLevelData.store_up
	self.CostValue_txt.color = not self:CanBuyShop() and Color(181/255, 46/255, 32/255, 1) or Color(1, 1, 1, 1)

	self:RefreshCardArea()
end

function BuyShopWindow:__ShowComplete()
	if not self.blurBack then
		local setting = { bindNode = self.BlurNode }
		self.blurBack = BlurBack.New(self, setting)
	end

	local cb = function ()
		self:BlurShowCb()
	end
	self.blurBack:Show({cb})
end

function BuyShopWindow:BlurShowCb()
	if self.args and self.args.showCallback then
		self.args.showCallback()
	end
end

function BuyShopWindow:__Hide()
	self:CacheBar()
end

function BuyShopWindow:__delete()
	self:DeleteCardItem()
end

-- 刷新展示卡片
function BuyShopWindow:RefreshCardArea()
	local cardIdArr = self.shopLevelData.store_up_show_id
	for i = 1, #cardIdArr do
		local go = self:PopUITmpObject("SingleCardItem", self.CardArea_rect)
		go.object:SetActive(true)
		
		-- todo 设置高亮和内容
		
		table.insert(self.cardItemList, go)
	end
end

function BuyShopWindow:DeleteCardItem()
	if self.cardItemList then
		for i = 1, #self.cardItemList do
			GameObject.Destroy(self.cardItemList[i])
		end
	end

	self.cardItemList = nil
end

function BuyShopWindow:OnClick_SendConfirmMsg()
	if not self:CanBuyShop() then
		MsgBoxManager.Instance:ShowTips(TI18N("城市币不足, 请通过店铺经营获取更多城市币"), 1)
		return
	end
	
	print("向后端发送信息")
end

function BuyShopWindow:CanBuyShop()
	local currCurrency = mod.BagCtrl:GetItemCountById(CitySimulationConfig:GetGoldIconID())
	local needCurrency = self.shopLevelData.store_up
	
	return currCurrency >= needCurrency
end

-- 初始化货币和体力栏
function BuyShopWindow:InitBar()
	local goldID = CitySimulationConfig:GetGoldIconID()
	self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
	self.currencyBar:init(self.CurrencyBar, goldID)
end

-- 移除货币栏和体力栏
function BuyShopWindow:CacheBar()
	self.currencyBar:OnCache()
end

function BuyShopWindow:__AfterExitAnim()
	WindowManager.Instance:CloseWindow(self)
end