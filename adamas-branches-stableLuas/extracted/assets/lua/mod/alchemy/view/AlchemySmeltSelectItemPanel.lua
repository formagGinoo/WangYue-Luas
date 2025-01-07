AlchemySmeltSelectItemPanel = BaseClass("AlchemySmeltSelectItemPanel", BasePanel)

function AlchemySmeltSelectItemPanel:__init()
    self:SetAsset("Prefabs/UI/Alchemy/AlchemySmeltSelectItemPanel.prefab")
    self.formulaPartObjList = {}
end

function AlchemySmeltSelectItemPanel:__BindEvent()

end

function AlchemySmeltSelectItemPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClick_ClosePanel"))
    self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ClosePanel"))
end

function AlchemySmeltSelectItemPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AlchemySmeltSelectItemPanel:__Show()
    self.formulaInfo = self.args.formulaInfo
    self.alchemyItemsInfo = self.args.alchemyItemsInfo
    self.alchemyWindow = WindowManager.Instance:GetWindow("AlchemyMainWindow")
    self.alchemyWindow.AlchemyLeftTab_canvas.alpha = 0
end

function AlchemySmeltSelectItemPanel:__delete()
    for k, v in pairs(self.formulaPartObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end
end

function AlchemySmeltSelectItemPanel:__Hide()

end

function AlchemySmeltSelectItemPanel:__ShowComplete()
    self:UpdateData()
end

function AlchemySmeltSelectItemPanel:OnClick_ClosePanel()
    self.alchemyWindow.AlchemyLeftTab_canvas.alpha = 1
    PanelManager.Instance:ClosePanel(self)
end

function AlchemySmeltSelectItemPanel:UpdateData()
    self:UpdateInfo()
    self:RefreshScroll()
    for index = 1, #self.itemsInfo, 1 do
        if self.itemsInfo[index].num > 0 then
            local selectCommonItem = self.formulaPartObjList[index].awardItem
            local onClickReduceFunc = function()
                self:OnClickReduce(selectCommonItem, index)
            end
            selectCommonItem:SetReduceBtnEvent(onClickReduceFunc)
        end
    end
end

function AlchemySmeltSelectItemPanel:UpdateInfo()
    self.formulaId = self.formulaInfo.formula_id
    self.leftItem = self.formulaInfo.left_item
    self.rightItem = self.formulaInfo.right_item
    self.itemsInfo = {}
    for k, itemId in pairs(self.leftItem) do
        if itemId ~= 0 then
            for k, item in pairs(self.alchemyItemsInfo[1]) do
                if item.id == itemId  then
                    table.insert(self.itemsInfo , {id = item.id, num = item.num})
                end
            end
        end
    end

    for k, itemId in pairs(self.rightItem) do
        if itemId ~= 0 then
            for k, item in pairs(self.alchemyItemsInfo[2]) do
                if item.id == itemId  then
                    table.insert(self.itemsInfo , {id = item.id, num = item.num})
                end
            end
        end
    end
end

function AlchemySmeltSelectItemPanel:RefreshScroll()
    local col = math.floor((self.AlchemyItemsScollList_rect.rect.width - 20) / 120)
    local row = math.ceil((self.AlchemyItemsScollList_rect.rect.height) / 120)

    local AwardCount = #self.itemsInfo
    local listNum = AwardCount > (col * row) and AwardCount or (col * row)
    self.AlchemyItemsScollList_recyceList:SetLuaCallBack(self:ToFunc("RefreshCell"))
    self.AlchemyItemsScollList_recyceList:SetCellNum(listNum)
end
function AlchemySmeltSelectItemPanel:RefreshCell(index, go)
	if not go then
        return 
    end
    local awardItem
    local awardObj
    if self.formulaPartObjList[index] then
        awardItem = self.formulaPartObjList[index].awardItem
        awardObj = self.formulaPartObjList[index].awardObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
		awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
		if not awardItem then
			awardItem = CommonItem.New()
		end
        awardObj = uiContainer.CommonItem
        self.formulaPartObjList[index] = {}
        self.formulaPartObjList[index].awardItem = awardItem
        self.formulaPartObjList[index].awardObj = awardObj
        self.formulaPartObjList[index].containerItem = uiContainer
    end
	local awardItemInfo = {}
    local onClickFunc = function()
		self:OnSelectItem(self.formulaPartObjList[index].awardObj, self.formulaPartObjList[index].containerItem, self.formulaInfo, self.formulaPartObjList[index].awardItem, index)
	end
    if index <= #self.itemsInfo then
        awardItemInfo = ItemConfig.GetItemConfig(self.itemsInfo[index].id)
	    awardItemInfo.template_id = self.itemsInfo[index].id
        awardItem:InitItem(awardObj, awardItemInfo)
        UtilsUI.SetActive(awardItem.node.Num, true)
        local itemCount = mod.BagCtrl:GetItemCountById(self.itemsInfo[index].id)
        if itemCount <= 0 then
            awardItem.node.Num_txt.text = string.format("<color=%s>%s</color>/<color=%s>%s</color>", AlchemyConfig.TextColor.Red, itemCount, AlchemyConfig.TextColor.Yellow, self.itemsInfo[index].num)
        else
            awardItem.node.Num_txt.text = string.format("<color=%s>%s</color>/<color=%s>%s</color>", AlchemyConfig.TextColor.White, itemCount, AlchemyConfig.TextColor.Yellow, self.itemsInfo[index].num)
        end

        local itemInfo = AlchemyConfig.GetEleItemInfoById(self.itemsInfo[index].id)
        self:SetSelectItem(self.formulaPartObjList[index].containerItem, self.itemsInfo[index].id)
        UtilsUI.SetActive(self.formulaPartObjList[index].containerItem.SelectItem, true)
        UtilsUI.SetActive(self.formulaPartObjList[index].containerItem.SelectItemInfo, true)
        self.formulaPartObjList[index].containerItem.ElementAmount_txt.text = itemInfo.element_amount
        
        awardItem:SetBtnEvent(false, onClickFunc)
    else
        awardItem:InitItem(awardObj, nil)
    end
end

function AlchemySmeltSelectItemPanel:OnSelectItem(itemObj, selectItem, formulaData, selectCommonItem, index)
    local itemCount = mod.BagCtrl:GetItemCountById(self.itemsInfo[index].id)
    if itemCount <= 0 then
        ItemManager.Instance:ShowItemTipsPanel(ItemConfig.GetItemConfig(self.itemsInfo[index].id))
        return
    end

    if mod.AlchemyCtrl:CheckNowNumByFormulaId(self.formulaId) == false then
        MsgBoxManager.Instance:ShowTips(TI18N("材料已达到放置上限"))
        return
    end
    
    if self.itemsInfo[index].num == 0 then
        local onClickReduceFunc = function()
            self:OnClickReduce(selectCommonItem, index)
        end
        selectCommonItem:SetReduceBtnEvent(onClickReduceFunc)
    end
    if itemCount > self.itemsInfo[index].num then
        self.itemsInfo[index].num = self.itemsInfo[index].num + 1
        local sum = self:GetItemInfoSumNum()
        mod.AlchemyCtrl:SetNumLimitByFormulaId(self.formulaId, sum)
        EventMgr.Instance:Fire(EventName.AlchemySetItemNum, self.itemsInfo[index].id, self.itemsInfo[index].num)
        selectCommonItem.node.Num_txt.text = string.format("%s/<color=#FFAE3A>%s</color>", itemCount, self.itemsInfo[index].num)
    end
end

function AlchemySmeltSelectItemPanel:SetSelectItem(selectItem, itemId)
    local elementType = AlchemyConfig.GetEleItemtypeInfoById(itemId)
	for i = 1, selectItem.SelectEle.transform.childCount do
		UtilsUI.SetActive(selectItem.SelectEle.transform:GetChild(i - 1), false)
	end
	UtilsUI.SetActive(selectItem[elementType], true)
end

function AlchemySmeltSelectItemPanel:GetItemInfoSumNum()
    local sum = 0
    for i, v in ipairs(self.itemsInfo) do
        sum = sum + v.num
    end
    return sum
end

function AlchemySmeltSelectItemPanel:OnClickReduce(selectCommonItem, index)
    local itemCount = mod.BagCtrl:GetItemCountById(self.itemsInfo[index].id)
    if self.itemsInfo[index].num > 0 then
        self.itemsInfo[index].num = self.itemsInfo[index].num - 1
        local sum = self:GetItemInfoSumNum()
        mod.AlchemyCtrl:SetNumLimitByFormulaId(self.formulaId, sum)
        EventMgr.Instance:Fire(EventName.AlchemySetItemNum, self.itemsInfo[index].id, self.itemsInfo[index].num)
        selectCommonItem.node.Num_txt.text = string.format("<color=%s>%s</color>/<color=%s>%s</color>", AlchemyConfig.TextColor.White, itemCount, AlchemyConfig.TextColor.Yellow, self.itemsInfo[index].num)
    end
    if self.itemsInfo[index].num <= 0 then
        self.itemsInfo[index].num = 0
        selectCommonItem:SetReduceBtnEvent(nil)
    end
end