MailingExchangeWindow = BaseClass("MailingExchangeWindow", BaseWindow)

local MailingMood = 
{
	Wait = 1,
	Expectation = 2,
	Exciting = 3,
	Disappointed = 4,
	HappyEnd = 5,
}

local MoodToAnimName = 
{
	[MailingMood.Wait] = "Stand1",
	[MailingMood.Expectation] = "ExceptionLoop",
	[MailingMood.Exciting] = "HappyEat",
	[MailingMood.Disappointed] = "DisapointLoop",
	[MailingMood.HappyEnd] = "ByeBye",
}

local MoodToEffectId =
{
	[MailingMood.Expectation] = 801200103,
	[MailingMood.Exciting] = 801200106,
	[MailingMood.Disappointed] = 801200105,
	[MailingMood.HappyEnd] = 801200107,
}

function MailingExchangeWindow:__init()
	self:SetAsset("Prefabs/UI/Mailing/MailingExchangeWindow.prefab")
	
	self.selectedItem = nil
	self.selectedItemNum = 0
	self.id = nil
	self.config = nil
	self.rewardList = nil
	
	self.justClear = false
	self.finishExchange = false
	self.waitForShowReward = false
	self.curBagData = {}
	self.itemObjList = {}
	self.selectedShowItem = nil
end

function MailingExchangeWindow:__BindListener()
	--self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClose"))

	self.DeliverDoBtn_btn.onClick:AddListener(self:ToFunc("OnDeliverItem"))
	
	UtilsUI.SetHideCallBack(self.MailingExchangeWindow_Exit, self:ToFunc("Close_HideCallBack"))
	
	EventMgr.Instance:AddListener(EventName.MailingExchangeResult, self:ToFunc("OnGetExchangeResult"))
	EventMgr.Instance:AddListener(EventName.OnCloseGetItemPanel, self:ToFunc("OnCloseGetItemPanel"))
	EventMgr.Instance:AddListener(EventName.ItemRecv, self:ToFunc("ItemRecv"))
end

function MailingExchangeWindow:__CacheObject()

end

function MailingExchangeWindow:__Create()

end

function MailingExchangeWindow:__delete()
end

function MailingExchangeWindow:__ShowComplete()
end

function MailingExchangeWindow:__Hide()
	self.selectedItem = nil
	self.selectedShowItem = nil
	self.config = nil
	self.rewardList = nil
	self.curBagData = {}
	self.itemObjList = {}
	
	EventMgr.Instance:RemoveListener(EventName.MailingExchangeResult, self:ToFunc("OnGetExchangeResult"))
	EventMgr.Instance:RemoveListener(EventName.OnCloseGetItemPanel, self:ToFunc("OnCloseGetItemPanel"))
	EventMgr.Instance:RemoveListener(EventName.ItemRecv, self:ToFunc("ItemRecv"))
	InputManager.Instance:MinusLayerCount()
end

function MailingExchangeWindow:__Show()
	InputManager.Instance:AddLayerCount(InputManager.Instance.actionMapName, "UI")
	if not self.args.id then
		LogError("未获取到脉灵数据")
		return 
	end
	self.selectedItem = nil
	self.selectedItemNum = 0
	self.id = self.args.id
	self.instanceId = self.args.instanceId
	self.config = self.args.config
	
	self:InitUI()
	self:PlayMoodAnim(MailingMood.Wait)
end

function MailingExchangeWindow:InitUI()
	self.BubbleDialogText_txt.text = self.config.feed_desc
	
	self:InitItemList()
	self:UpdateSelectedShowItem()
end

function MailingExchangeWindow:GetBagData()
	TableUtils.ClearTable(self.curBagData)
	
	local bagData = mod.BagCtrl:GetBagByType()
	if bagData then
		for _, itemList in pairs(bagData) do
			for k, v in pairs(itemList) do
				local config = ItemConfig.GetItemConfig(v.template_id)
				if config and config.is_feed then
					table.insert(self.curBagData, v)
				end
			end
		end
	end
	return self.curBagData
end

function MailingExchangeWindow:InitItemList()
	self:GetBagData()
	
	if self.ItemScroll_recyceList then
		local col = math.floor((self.ItemScroll_rect.rect.width - 16) / 122)
		local row = math.ceil((self.ItemScroll_rect.rect.height - 25) / 138)
		local bagCount = #self.curBagData

		local listNum = bagCount > (col * row) and bagCount or (col * row)
		self.ItemScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
		self.ItemScroll_recyceList:SetCellNum(listNum)
	end
end

function MailingExchangeWindow:RefreshItemCell(index, itemGb)
	if not itemGb then
		return
	end

	local commonItem
	local itemObj
	if self.itemObjList[index] then
		commonItem = self.itemObjList[index].commonItem
		itemObj = self.itemObjList[index].itemObj
	else
		commonItem = CommonItem.New()
		itemObj = itemGb.transform:Find("SingleItem").gameObject
		self.itemObjList[index] = {}
		self.itemObjList[index].commonItem = commonItem
		self.itemObjList[index].itemObj = itemObj
	end
	
	local onClickFunc = function()
		self:OnSelectItem(self.itemObjList[index])
	end
	
	self:InitItem(self.itemObjList[index], self.curBagData[index], onClickFunc)
	if self.curBagData and self.curBagData[index] then 
		commonItem:SetLongPressEvent(false, nil, 1)
	end
end

local notFullTextStr = "<color=#FF6E6E>%d</color>/%d"
local fullTextStr = "%d/%d"
local UndoBtnTextColor = Color(138/255, 140/255, 150/255)
local DoBtnTextColor = Color(70/255, 71/255, 81/255)

function MailingExchangeWindow:UpdateSelectedShowItem()
	if self.selectedItem then
		local onClickFunc = function()
			self:OnClearItem()
		end
		
		if not self.selectedShowItem then
			local commonItem = CommonItem.New()
			local itemObj = self.SelectedShowItem.transform:Find("SingleItem").gameObject
			self.selectedShowItem = {}
			self.selectedShowItem.commonItem = commonItem
			self.selectedShowItem.itemObj = itemObj
			
			self:InitItem(self.selectedShowItem, self.selectedItem.commonItem.itemInfo, onClickFunc)
		end
		
		if self.selectedShowItem.itemId ~= self.selectedItem.itemId then
			self:InitItem(self.selectedShowItem, self.selectedItem.commonItem.itemInfo, onClickFunc)
		end

		local selectedEffect = self.selectedShowItem.commonItem.node["22117"]
		if selectedEffect then
			UnityUtils.SetActive(selectedEffect, false)
			UnityUtils.SetActive(selectedEffect, true)
		end
	end
	
	self.SelectedShowItem:SetActive(self.selectedItem ~= nil)
	local showStr = self.selectedItemNum == self.config.feed_num and fullTextStr or notFullTextStr
	self.SelectedNumText_txt.text = string.format(showStr, self.selectedItemNum, self.config.feed_num)
	self.DeliverDoBtn:SetActive(self.selectedItemNum == self.config.feed_num)
	
	local color = self.selectedItemNum == self.config.feed_num and DoBtnTextColor or UndoBtnTextColor
	self.DeliverText_txt.color = color
end

function MailingExchangeWindow:InitItem(item, itemConfig, callBackFunc)
	item.commonItem:InitItem(item.itemObj, itemConfig, true)
	--item.commonItem:Show()
	item.itemId = -1
	
	if itemConfig then
		item.itemId = itemConfig.template_id
		item.commonItem:SetBtnEvent(false, callBackFunc)
	end
end

function MailingExchangeWindow:OnClose()
	self.MailingExchangeWindow_Exit:SetActive(true)
end

function MailingExchangeWindow:Close_HideCallBack()
	if self.finishExchange then
		self:PlayMoodAnim(MailingMood.HappyEnd)
		mod.MailingCtrl:CloseExchangeWindow(self, self.id, true)
	else
		self:PlayMoodAnim(MailingMood.Wait)
		mod.MailingCtrl:CloseExchangeWindow(self)
	end
end

function MailingExchangeWindow:OnSelectItem(itemObj)
	self.justClear = false
	if self.selectedItem == itemObj then
		if self.selectedItemNum < self.config.feed_num then
			if self.selectedItem.commonItem.itemInfo.count <= self.selectedItemNum then
				MsgBoxManager.Instance:ShowTips(TI18N("物品数量不足"))
				return
			end
			
			self.selectedItemNum = self.selectedItemNum + 1
			self:UpdateSelectedShowItem()
		end
		return 
	end
	
	if self.selectedItem then
		self.selectedItem.commonItem:SetSelected_Normal(false)
	end
	
	self.selectedItem = itemObj
	self.selectedItemNum = 1
	self.selectedItem.commonItem:SetSelected_Normal(true)
	self:UpdateSelectedShowItem()

	local mood = itemObj.itemId == self.config.feed_item_id and MailingMood.Expectation or MailingMood.Disappointed
	self:PlayMoodAnim(mood)
end

function MailingExchangeWindow:OnClearItem()
	if self.selectedItem then
		self.selectedItem.commonItem:SetSelected_Normal(false)
	end
	
	self.selectedItem = nil
	self.selectedItemNum = 0
	self.justClear = true
	self:UpdateSelectedShowItem()
	self:PlayMoodAnim(MailingMood.Disappointed)
end

function MailingExchangeWindow:OnDeliverItem()
	if self.selectedItemNum ~= self.config.feed_num then
		return 
	end
	
	if self.config.feed_item_id ~= self.selectedItem.itemId then
		self:OnGetExchangeResult(self.id, false)
		return
	end
	
	mod.MailingCtrl:CommitExchangeItem(self.id, self.selectedItem.itemId, self.selectedItemNum)
end

function MailingExchangeWindow:OnGetExchangeResult(id, success)
	success = success == 1
	
	if success then
		self.finishExchange = true
		self:PlayMoodAnim(MailingMood.Exciting)
		
		local delayFunc = function()
			if self.waitForShowReward then
				PanelManager.Instance:OpenPanel(GetItemPanel, {reward_list = self.rewardList})
			else
				self:OnCloseGetItemPanel()
			end
		end
		
		LuaTimerManager.Instance:AddTimer(1, 3, delayFunc)
	else
		--打开失败弹窗
		self.justClear = false
		self.selectedItem = nil
		self.selectedItemNum = 0
		self:UpdateSelectedShowItem()
		self:PlayMoodAnim(MailingMood.Wait)
		
		self:OpenPanel(MailingExchangeFailPanel, self)
	end
end

function MailingExchangeWindow:GetFoodEntityId()
	if not self.selectedItem then
		return 0
	end
	
	local data = ItemConfig.GetItemConfig(self.selectedItem.itemId)
	if data then
		return data.drop_entity_id or 0
	end
end

function MailingExchangeWindow:PlayMoodAnim(mood)
	local anim = MoodToAnimName[mood]
	local effectId = MoodToEffectId[mood]
	local dropEntityId = 0
	if mood == MailingMood.Exciting then
		dropEntityId = self:GetFoodEntityId()
	end
	
	mod.MailingCtrl:PlayMailingAnim(self.instanceId, anim, effectId, dropEntityId)
end

function MailingExchangeWindow:OnCloseGetItemPanel()
	if self.finishExchange then
		self:OnClose()
	end
end

function MailingExchangeWindow:ItemRecv(rewardList, src)
	if src ~= 36 then return end --不是脉灵的奖励不监听
	self.rewardList = rewardList
	self.waitForShowReward = true
end