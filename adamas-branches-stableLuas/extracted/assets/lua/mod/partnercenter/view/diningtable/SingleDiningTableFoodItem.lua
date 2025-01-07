SingleDiningTableFoodItem = BaseClass("SingleDiningTableFoodItem")

function SingleDiningTableFoodItem:UpdateData(data)
    self.object = data.obj
    self.index = data.index
    self.itemId = data.itemId
    self.currNum = data.currNum
    self.maxNum = data.maxNum
    self.transform = self.object.transform
    self.isSelect = false
    UtilsUI.GetContainerObject(self.transform, self)

    -- 更新CommonItem
    self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not self.commonItem then
        self.commonItem = CommonItem.New()
    end
    
    local itemInfo = {template_id = self.itemId, count = self.maxNum or 0, numColor = {1,1,1,0}}
    self.commonItem:InitItem(self.CurrFoodIconItem, itemInfo, true)
    
    -- 更新描述和数量
    local itemData = ItemConfig.GetItemConfig(self.itemId)
    self.CurrFoodItemName_txt.text = string.format("<color=#393F4A>%s</color> <color=#e68900>(%d/%d)</color>", itemData.name, self.currNum, self.maxNum)
    self.CurrFoodItemDesc_txt.text = TI18N(string.format("<color=#888A96>%s</color>", itemData.desc))
    
    -- 注册点击事件
    self._btn.onClick:RemoveAllListeners()
    self._btn.onClick:AddListener(function()
        EventMgr.Instance:Fire(EventName.UpdateSelectedFoodItem, self.itemId)
    end)
end

function SingleDiningTableFoodItem:UpdateSelectedState(isSelect)
    self.Selected.transform:SetActive(isSelect)
end

function SingleDiningTableFoodItem:UpdateNum(num)
    self.currNum = num
    local itemData = ItemConfig.GetItemConfig(self.itemId)
    self.CurrFoodItemName_txt.text = string.format("<color=#393F4A>%s</color> <color=#e68900>(%d/%d)</color>", itemData.name, num, self.maxNum)
end

