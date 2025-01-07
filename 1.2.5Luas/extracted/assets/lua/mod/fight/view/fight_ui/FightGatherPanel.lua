FightGatherPanel = BaseClass("FightGatherPanel", BasePanel)

FightGatherPanel.QualityColor = {
    [1] = "#bbbcbd",--#bbbcbd
    [2] = "#32e991",--#32e991
    [3] = "#27b5ff",--#27b5ff
    [4] = "#df74ef",--#df74ef
    [5] = "#ffc35b",--#ffc35b
    [6] = "#f35b47"--#f35b47
}

function FightGatherPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightGatherPanel.prefab")
    self.mainView = mainView
	self.cacheList = {}
	self.itemList = {}
	self.curShowCount = 0
end

function FightGatherPanel:__BindListener()
	EventMgr.Instance:AddListener(EventName.ItemRecv, self:ToFunc("ShowGatherItemTip"))
end

function FightGatherPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightGatherPanel:__CacheObject()
	local spacing = self.TipContent:GetComponent(VerticalLayoutGroup).spacing
	local unitY = self.ItemTips_rect.sizeDelta.y
	self.offsetY = spacing + unitY
end

function FightGatherPanel:__Show()
    for i = 1, self.TipContent.transform.childCount do
		self.TipContent.transform:GetChild(i - 1).gameObject:SetActive(false)
	end
end

function FightGatherPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightGatherPanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.ItemRecv, self:ToFunc("ShowGatherItemTip"))
end

function FightGatherPanel:PopItem()
	self.curShowCount = self.curShowCount + 1
	if #self.cacheList > 0 then
		local itemInfo = table.remove(self.cacheList)
		itemInfo.ItemTips.transform:SetParent(self.TipContent.transform)
		return itemInfo
	end
	local go = GameObject.Instantiate(self.ItemTips,self.TipContent.transform)
	local itemInfo = UtilsUI.GetContainerObject(go)
	UtilsUI.SetHideCallBack(go, function ()
		self:ItemHideEvent(itemInfo)
	end)
	table.insert(self.itemList, itemInfo)
	return itemInfo
end

function FightGatherPanel:PushItem(itemInfo)
	itemInfo.ItemTips_rect:SetParent(self.cache_rect)
	itemInfo.show = false
	table.insert(self.cacheList, itemInfo)
	self.curShowCount = self.curShowCount - 1
end

function FightGatherPanel:ItemHideEvent(itemInfo)
	if not self.active then
		return
	end
	local anchoredPosition  = self.TipContent_rect.anchoredPosition
	UnityUtils.SetAnchoredPosition(self.TipContent_rect, anchoredPosition.x, anchoredPosition.y - self.offsetY)
	self:PushItem(itemInfo)
end

function FightGatherPanel:ShowItemTipsInfo(config, count)
	local itemInfo = self:PopItem()
	itemInfo.show = true
	local path = ItemConfig.GetItemIcon(config.id)

	SingleIconLoader.Load(itemInfo.TipIcon, path)
	local colorData = FightGatherPanel.QualityColor[config.quality]
	UtilsUI.SetImageColor(itemInfo.Quality_img, colorData)
	itemInfo.TipText_txt.text = config.name
	itemInfo.TipCount_txt.text = count
	itemInfo.ItemTips:SetActive(true)
end


--临时拾取道具提示
function FightGatherPanel:ShowGatherItemTip(list)
	for k, v in pairs(list) do
		local itemInfo = {template_id = v.template_id, count = v.count}
		local itemConfig = ItemConfig.GetItemConfig(itemInfo.template_id)
		if itemConfig then
			if self.curShowCount >= 4 then
				for i = 1, #self.itemList do
					if self.itemList[i].show then
						self.itemList[i].ItemTips:SetActive(false)
						break
					end
				end
			end
			self:ShowItemTipsInfo(itemConfig, itemInfo.count)
		else
			LogError("找不到道具配置 id = ", v.template_id)
		end
	end
end