StrengthExchangePanel = BaseClass("StrengthExchangePanel", BasePanel)

local DataReward = Config.DataReward.Find
local DataItem = Config.DataItem.Find
local DataItemExchange = Config.DataItemExchange.Find

local StrengthItemType = 1055 --体力药类型
local ExchangeKey = 1 --弱海通宝兑换体力的Key
local StrengthItemId = 5 --体力id

local _min = math.min
local _max = math.max

local DefaultStrengthItemName = TI18N("体力")
local DefaultFreeCurrencyItemName = TI18N("弱海通宝")

--初始化
function StrengthExchangePanel:__init(parent)
	self:SetAsset("Prefabs/UI/Common/StrengthExchangePanel.prefab")
	
	self.selectedItems = {}
	self.exchangeType = 0
	self.exchangeConfig = DataItemExchange[ExchangeKey]
	if not self.exchangeConfig then
		LogError("获取不到兑换配置："..ExchangeKey)
	end
	
	self.itemIdList = {}
	self.itemObjList = {}
	self.fromItemObj = nil
	self.toItemObj = nil
	
	self.loadDone = false
end

--添加监听器
function StrengthExchangePanel:__BindListener()
	--EventMgr.Instance:AddListener(EventName.ItemRecv, self:ToFunc("ItemRecv"))
	EventMgr.Instance:AddListener(EventName.StrengthUpdate, self:ToFunc("StrengthUpdate"))
	EventMgr.Instance:AddListener(EventName.ExchangeDataUpdate, self:ToFunc("UpdateFreeCurrencyExchange"))
	
	self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnBack"))
	self:BindCloseBtn(self.Cancel_btn,self:ToFunc("OnBack"))
	--self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnBack"))
	-- self.Cancel_btn.onClick:AddListener(self:ToFunc("OnBack"))
	self.Submit_btn.onClick:AddListener(self:ToFunc("OnSubmit"))
	
	self.ToggleBtn1_btn.onClick:AddListener(self:ToFunc("OnUseItemExchange"))
	self.ToggleBtn2_btn.onClick:AddListener(self:ToFunc("OnUseFreeCurrencyExchange"))
end

--缓存对象
function StrengthExchangePanel:__CacheObject()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
end

local TitleTipsText = TI18N("%s兑换")
function StrengthExchangePanel:__Create()
	self.itemIdList = ItemConfig.GetItemIds_ItemType(StrengthItemType)
	
	if self.CostItemGroup_recyceList then
		self.CostItemGroup_recyceList:SetLuaCallBack(self:ToFunc("OnCostItemScroll"))
		self.CostItemGroup_recyceList:SetCellNum(#self.itemIdList)
	end
	
	self:InitCurrencyBar()
	self:UpdateFreeCurrencyExchange()
	
	local strengthItemName = DefaultStrengthItemName
	local config = ItemConfig.GetItemConfig(StrengthItemId)
	if config then
		strengthItemName = config.name
	end
	self.TitleText_txt.text = string.format(TitleTipsText, strengthItemName)
end

function StrengthExchangePanel:__BindEvent()
end

function StrengthExchangePanel:__delete()
	--EventMgr.Instance:RemoveListener(EventName.ItemRecv, self:ToFunc("ItemRecv"))
	EventMgr.Instance:RemoveListener(EventName.StrengthUpdate, self:ToFunc("StrengthUpdate"))
	EventMgr.Instance:RemoveListener(EventName.ExchangeDataUpdate, self:ToFunc("UpdateFreeCurrencyExchange"))
	
	self.currencyBarClass:OnCache()
	self.currencyBarClass = nil
	
	self.strengthBarClass:OnCache()
	self.strengthBarClass = nil
end

function StrengthExchangePanel:__Show(args)
	local hasItem = false
	for _, v in pairs(self.itemIdList) do
		local count = mod.BagCtrl:GetItemCountById(v)
		if count ~= 0 then
			hasItem = true
		end
	end
	
	if hasItem then
		self:OnUseItemExchange()
	else
		self:OnUseFreeCurrencyExchange()
	end
end

function StrengthExchangePanel:__Hide()

end

function StrengthExchangePanel:__ShowComplete()
	if not self.blurBack then
		local setting = { bindNode = self.BlurNode }
		self.blurBack = BlurBack.New(self, setting)
	end
	self:SetActive(false)
	self.blurBack:Show()
	
	self.loadDone = true
end

function StrengthExchangePanel:Update()
	if not self.loadDone then
		return
	end
	
	local val, maxVal, nextTimeStamp = mod.BagCtrl:GetStrengthData()
	self:StrengthUpdate(val, maxVal, nextTimeStamp)
end


function StrengthExchangePanel:InitCurrencyBar()
	self.currencyBarClass = Fight.Instance.objectPool:Get(CurrencyBar)
	self.currencyBarClass:init(self.CurrencyBar, 3)
	
	self.strengthBarClass = Fight.Instance.objectPool:Get(CurrencyBar)
	self.strengthBarClass:init(self.StrengthBar, 5)
	self.strengthBarClass.nodes.BgButton_btn.enabled = false
end

function StrengthExchangePanel:SetQuality(item, quality)
	local frontImg, backImg = ItemManager.GetItemColorImg(quality)
	if not frontImg or not backImg then
		return
	end

	local frontPath = AssetConfig.GetQualityIcon(frontImg)
	local backPath = AssetConfig.GetQualityIcon(backImg)
	SingleIconLoader.Load(item.node.QualityFront, frontPath)
	SingleIconLoader.Load(item.node.QualityBack, backPath)
end

function StrengthExchangePanel:InitItem(item, cantClick, defaultCount)
	local icon = ItemConfig.GetItemIcon(item.id)
	SingleIconLoader.Load(item.node.Icon, icon)
	
	local count = defaultCount or mod.BagCtrl:GetItemCountById(item.id)
	item.node.Count_txt.text = count
	item.count = count
	
	self:SetQuality(item, DataItem[item.id].quality)
	
	item.node.Icon_btn.onClick:RemoveAllListeners()
	item.node.Sub_btn.onClick:RemoveAllListeners()
	if not cantClick then
		---点击加材料
		local onClickAddFunc = function()
			self:OnSelectItem(item, true)
		end
		item.node.Icon_btn.onClick:AddListener(onClickAddFunc)
		---减少材料
		local onClickSubFunc = function()
			self:OnSelectItem(item, false)
		end
		item.node.Sub_btn.onClick:AddListener(onClickSubFunc)
	end
end

function StrengthExchangePanel:CreateItem(id, gb)
	local item = {}
	
	item.id = id
	item.config = ItemConfig.GetItemConfig(id)
	
	item.gameObject = gb
	item.transform = gb.transform
	item.node = UtilsUI.GetContainerObject(item.transform)
	
	return item
end

function StrengthExchangePanel:OnCostItemScroll(index, gb)
	local id = self.itemIdList[index]
	if not id then
		return 
	end
	
	local item = self.itemObjList[index]
	if not item then
		item = self:CreateItem(id, gb)
		self:InitItem(item)
		
		self.itemObjList[index] = item
	end

	if not item.gameObject or item.gameObject ~= gb then
		item.gameObject = gb
		item.transform = gb.transform
		item.node = UtilsUI.GetContainerObject(item.transform)
		self:InitItem(item)
	end
end

function StrengthExchangePanel:UpdateFreeCurrencyExchange()
	if not self.exchangeConfig then
		return 
	end
	
	local times = mod.BagCtrl:GetExchangeTimes(ExchangeKey)
	local consume = self.exchangeConfig.consume[_min(times + 1, self.exchangeConfig.daily_limit)]
	
	self.fromItemObj = self:CreateItem(consume[1], self.FromItem)
	self:InitItem(self.fromItemObj, true, consume[2])

	self.toItemObj = self:CreateItem(self.exchangeConfig.target_id, self.ToItem)
	self:InitItem(self.toItemObj, true, self.exchangeConfig.target_num)
	
	self:UpdateCostTips2()
end

function StrengthExchangePanel:OnBack()
	PanelManager.Instance:ClosePanel(StrengthExchangePanel)
end

local ExchangeFailTipsText = TI18N("%s不足")
function StrengthExchangePanel:OnSubmit()
	local exchange = false
	if self.exchangeType == 1 then
		local sendList = {}
		for k, v in pairs(self.selectedItems) do
			if v.num ~= 0 then
				exchange = true
				table.insert(sendList, {key = k, value = v.num})
			end
		end
		
		if #sendList ~= 0 then
			mod.BagFacade:SendMsg("item_use_energy", sendList)
		end
		
		self.selectedItems = {}
		for i = 1, #self.itemObjList do
			self:InitItem(self.itemObjList[i])
			self:OnSelectItem(self.itemObjList[i], false)
		end
		
	elseif self.exchangeType == 2 then
		local count = mod.BagCtrl:GetItemCountById(self.fromItemObj.id)
		if count >= self.fromItemObj.count then
			exchange = true
			mod.BagCtrl:ExchangeItem({{key = ExchangeKey, value = 1}})
		else
			local config = ItemConfig.GetItemConfig(self.fromItemObj.id)
			local name = config and string.format(ExchangeFailTipsText, config.name) or ExchangeFailTipsText
			MsgBoxManager.Instance:ShowTips(name)
		end
	end
	
	
	if exchange then
		self:OnBack()
	end
end

function StrengthExchangePanel:ItemRecv(itemList, src)
end

local RefreshTipsText = TI18N("%d分%d秒后恢复一点")
function StrengthExchangePanel:StrengthUpdate(val, maxVal, nextTimeStamp)
	
	UtilsUI.SetActive(self.RefreshTipsText, val < maxVal)
	
	if val < maxVal then
		local curTimeStamp = TimeUtils.GetCurTimestamp()
		local seconds = nextTimeStamp * 0.001 - curTimeStamp
		local showMin, showSecond = 0, 0
		if seconds > 0 then
			local remainTime = TimeUtils.SecondsToMinutesSeconds(seconds)
			showMin = _max(remainTime.minutes, 0)
			showSecond = _max(remainTime.seconds, 0)
		end
		
		self.RefreshTipsText_txt.text = string.format(RefreshTipsText, showMin, showSecond)
	end
end

local Type1Str = TI18N("确认")
local Type2Str = TI18N("兑换")
function StrengthExchangePanel:UpdateSelectedShow(type)
	local type1 = type == 1
	
	UtilsUI.SetActive(self.Select2, not type1)
	UtilsUI.SetActive(self.UnSelect2, type1)
	UtilsUI.SetActive(self.Select1, type1)
	UtilsUI.SetActive(self.UnSelect1, not type1)

	UtilsUI.SetActive(self.FreeCurrencyExchange, not type1)
	UtilsUI.SetActive(self.ItemExchange, type1)
	
	self.SubmitText_txt.text = type1 and Type1Str or Type2Str
end

function StrengthExchangePanel:OnUseItemExchange()
	if self.exchangeType == 1 then
		return 
	end
	
	self.selectedItems = {}
	for i = 1, #self.itemObjList do
		self:OnSelectItem(self.itemObjList[i], false)
	end
	
	self.exchangeType = 1
	self:UpdateSelectedShow(self.exchangeType)
	self:UpdateCostTips()
	
	self.Submit_btn.interactable = true
end

function StrengthExchangePanel:OnUseFreeCurrencyExchange()
	if self.exchangeType == 2 then
		return
	end

	self.exchangeType = 2
	self:UpdateSelectedShow(self.exchangeType)
	self:UpdateCostTips2()
	
	local times = mod.BagCtrl:GetExchangeTimes(ExchangeKey)
	self.Submit_btn.interactable = times ~= self.exchangeConfig.daily_limit
end

function StrengthExchangePanel:GetItemStrength(itemId)
	local config = ItemConfig.GetItemConfig(itemId)
	if not config then
		LogError("错误的体力道具："..itemId)
		return
	end

	local rewardConfig = DataReward[config.property1]
	if not rewardConfig then
		LogError("错误的奖励配置："..config.property1)
		return
	end
	
	return rewardConfig.reward_list[1][2]
end

function StrengthExchangePanel:OnSelectItem(item, add)
	local itemId = item.id
	if not self.selectedItems[itemId] then
		if add then
			local strength = self:GetItemStrength(itemId)
			self.selectedItems[itemId] = {num = _min(1, item.count), strength = strength}
		end
	else
		if add then
			self.selectedItems[itemId].num = _min(self.selectedItems[itemId].num + 1, item.count)
		else
			self.selectedItems[itemId].num = _max(self.selectedItems[itemId].num - 1, 0)
		end
	end
	
	local selectCount = self.selectedItems[itemId] and self.selectedItems[itemId].num or 0
	UtilsUI.SetActive(item.node.Select, selectCount > 0)
	UtilsUI.SetActive(item.node.Sub, selectCount > 0)
	item.node.SelectCount_txt.text = selectCount
	
	self:UpdateCostTips()
end

local CostTips1 = TI18N("是否花费以上道具恢复<color=#f39c0e>%d</color>%s？")
local CostTips2 = TI18N("是否花费<color=#f39c0e>%d</color>%s增加<color=#f39c0e>%d</color>%s？（%d/%d）")
function StrengthExchangePanel:UpdateCostTips()
	local cost = 0
	for k, v in pairs(self.selectedItems) do
		cost = cost + v.strength * v.num
	end
	
	local strengthItemName = DefaultStrengthItemName
	local config = ItemConfig.GetItemConfig(StrengthItemId)
	if config then
		strengthItemName = config.name
	end

	local text = string.format(CostTips1, cost, strengthItemName)
	self.CostTipText1_txt.text = text
end

local ZeroCountTipsText = TI18N("今日次数已用完(%d/%d)")
function StrengthExchangePanel:UpdateCostTips2()
	local times = mod.BagCtrl:GetExchangeTimes(ExchangeKey)
	local limit = self.exchangeConfig.daily_limit
	local consume = self.exchangeConfig.consume[_min(times + 1, limit)]
	
	local strengthItemName = DefaultStrengthItemName
	local config = ItemConfig.GetItemConfig(StrengthItemId)
	if config then
		strengthItemName = config.name
	end

	local freeCurrencyItemName = DefaultFreeCurrencyItemName
	local config2 = ItemConfig.GetItemConfig(consume[1])
	if config2 then
		freeCurrencyItemName = config2.name
	end
	
	local text
	if times < limit then
		text = string.format(CostTips2, consume[2], freeCurrencyItemName, self.exchangeConfig.target_num, strengthItemName,
			limit - times, limit)
	else
		text = string.format(ZeroCountTipsText, 0, limit)
	end
	self.CostTipText2_txt.text = text or " "
end