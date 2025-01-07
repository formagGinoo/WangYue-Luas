AwardItem = BaseClass("AwardItem", Module)

function AwardItem:__init()
    self.object = nil
	self.node = {}
    self.curItemData = {}
end

function AwardItem:Destroy()
	PoolManager.Instance:Push(PoolType.class, "CommonItem", self.commonItem)
end

function AwardItem:InitItem(object, template_id, itemCount, unique_id)
	-- 获取对应的组件
	self.object = object
	self:SetItem(template_id, itemCount, unique_id)
    self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.object:SetActive(true)
	self:Show()
end

function AwardItem:SetItem(itemId, itemCount, unique_id)
	self.itemId = itemId
	self.itemCount = itemCount
    self.itemData = ItemConfig.GetItemConfig(self.itemId)
    self.curItemData = {template_id = self.itemId, count = self.itemCount, unique_id = unique_id}
end

function AwardItem:Show()
	self.node.ItemTxt_txt.text = self.itemData.name
	self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
	if not self.commonItem then
		self.commonItem = CommonItem.New()
	end
    self.commonItem:InitItem(self.node.CommonItem, self.curItemData, true)
end

function AwardItem:OnReset()
	
end