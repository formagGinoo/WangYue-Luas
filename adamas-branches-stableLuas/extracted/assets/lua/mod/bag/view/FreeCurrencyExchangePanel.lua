FreeCurrencyExchangePanel = BaseClass("FreeCurrencyExchangePanel", BasePanel)

--TODO：这个界面理应是通用的

local DataReward = Config.DataReward.Find
local DataItem = Config.DataItem.Find
local DataItemExchange = Config.DataItemExchange.Find

local ExchangeKey = 2 --归一通宝兑换弱海通宝的Key，这个应该是传进来的

local _min = math.min
local _max = math.max

local DefaultTitleName = TI18N("道具")

--初始化
function FreeCurrencyExchangePanel:__init(parent)
	self:SetAsset("Prefabs/UI/Common/FreeCurrencyExchangePanel.prefab")

	self.exchangeConfig = DataItemExchange[ExchangeKey]
	if not self.exchangeConfig then
		LogError("获取不到兑换配置："..ExchangeKey)
	end

	self.fromItemObj = nil
	self.toItemObj = nil
end

--添加监听器
function FreeCurrencyExchangePanel:__BindListener()
	EventMgr.Instance:AddListener(EventName.ExchangeDataUpdate, self:ToFunc("InitExchange"))
	
	self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnBack"))
	self.Cancel_btn.onClick:AddListener(self:ToFunc("OnBack"))
	self.Submit_btn.onClick:AddListener(self:ToFunc("OnSubmit"))
	
	self.AddBtn_btn.onClick:AddListener(function()
			self.ExchangeSlider_sld.value = self.ExchangeSlider_sld.value + 1
		end)
	
	self.SubBtn_btn.onClick:AddListener(function()
			self.ExchangeSlider_sld.value = self.ExchangeSlider_sld.value - 1
		end)
	
	self.ExchangeSlider_sld.onValueChanged:AddListener(function(step) 
			self:UpdateExchange(math.floor(step)) 
		end)
end

--缓存对象
function FreeCurrencyExchangePanel:__CacheObject()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
	
	self.ExchangeSlider_sld = self.ExchangeSlider:GetComponent(Slider)
end

local TitleTipsText = TI18N("%s兑换")
function FreeCurrencyExchangePanel:__Create()
	self:InitInfo()
	self:InitExchange()
	self:InitCurrencyBar()
	
	local freeCurrencyItemName = DefaultTitleName
	local config = ItemConfig.GetItemConfig(self.toItemObj.id)
	if config then
		freeCurrencyItemName = config.name
	end
	self.TitleText_txt.text = string.format(TitleTipsText, freeCurrencyItemName)
end

function FreeCurrencyExchangePanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.ExchangeDataUpdate, self:ToFunc("InitExchange"))
	
	self.currencyBarClass:OnCache()
	self.currencyBarClass = nil

	self.payCurrencyBarClass:OnCache()
	self.payCurrencyBarClass = nil
	
end

function FreeCurrencyExchangePanel:__Show(args)
end

function FreeCurrencyExchangePanel:__ShowComplete()
	if not self.blurBack then
		local setting = { bindNode = self.BlurNode }
		self.blurBack = BlurBack.New(self, setting)
	end
	self:SetActive(false)
	self.blurBack:Show()
end

function FreeCurrencyExchangePanel:InitCurrencyBar()
	self.currencyBarClass = Fight.Instance.objectPool:Get(CurrencyBar)
	self.currencyBarClass:init(self.CurrencyBar, 3)
	self.currencyBarClass.nodes.BgButton_btn.enabled = false

	self.payCurrencyBarClass = Fight.Instance.objectPool:Get(CurrencyBar)
	self.payCurrencyBarClass:init(self.PayCurrencyBar, 4)
end

function FreeCurrencyExchangePanel:InitInfo()
	if not self.exchangeConfig then
		return
	end

	local consume = self.exchangeConfig.consume[1]

	self.fromItemObj = self:CreateItem(consume[1], self.FromItem)
	self:InitItem(self.fromItemObj, true)

	self.toItemObj = self:CreateItem(self.exchangeConfig.target_id, self.ToItem)
	self:InitItem(self.toItemObj, true)
	
	self.costStep = consume[2]
	self.getStep = self.exchangeConfig.target_num
end

function FreeCurrencyExchangePanel:InitExchange()
	self.ExchangeSlider_sld.minValue = 0
	
	local count = mod.BagCtrl:GetItemCountById(self.fromItemObj.id)
	local maxValue = math.floor(count / self.costStep)
	self.ExchangeSlider_sld.maxValue = maxValue
	
	self.ExchangeSlider_sld.value = 0
	self:UpdateExchange(0)
end

local ExchangeTipsText = TI18N("兑换数量：%d/%d")
function FreeCurrencyExchangePanel:UpdateExchange(step)
	self.fromItemObj.node.Count_txt.text = step * self.costStep
	self.toItemObj.node.Count_txt.text = step * self.getStep

	self.CostTipText_txt.text = string.format(ExchangeTipsText, step * self.getStep, self.ExchangeSlider_sld.maxValue * self.getStep)
end

function FreeCurrencyExchangePanel:SetQuality(item, quality)
	local frontImg, backImg = ItemManager.GetItemColorImg(quality)
	if not frontImg or not backImg then
		return
	end

	local frontPath = AssetConfig.GetQualityIcon(frontImg)
	local backPath = AssetConfig.GetQualityIcon(backImg)
	SingleIconLoader.Load(item.node.QualityFront, frontPath)
	SingleIconLoader.Load(item.node.QualityBack, backPath)
end

function FreeCurrencyExchangePanel:InitItem(item, cantClick, defaultCount)
	local icon = ItemConfig.GetItemIcon(item.id)
	SingleIconLoader.Load(item.node.Icon, icon)

	local count = defaultCount or mod.BagCtrl:GetItemCountById(item.id)
	item.node.Count_txt.text = count
	item.count = count

	self:SetQuality(item, DataItem[item.id].quality)

	item.node.Icon_btn.onClick:RemoveAllListeners()
	item.node.Sub_btn.onClick:RemoveAllListeners()
end

function FreeCurrencyExchangePanel:CreateItem(id, gb)
	local item = {}

	item.id = id
	item.config = ItemConfig.GetItemConfig(id)

	item.gameObject = gb
	item.transform = gb.transform
	item.node = UtilsUI.GetContainerObject(item.transform)

	return item
end

function FreeCurrencyExchangePanel:OnBack()
	PanelManager.Instance:ClosePanel(FreeCurrencyExchangePanel)
end

function FreeCurrencyExchangePanel:OnSubmit()
	if self.ExchangeSlider_sld.value == 0 then
		return 
	end
	
	mod.BagCtrl:ExchangeItem({{key = ExchangeKey, value = math.floor(self.ExchangeSlider_sld.value)}})
	self:OnBack()
end