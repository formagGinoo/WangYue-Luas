ItemSelectPanelV2 = BaseClass("ItemSelectPanelV2", BasePanel)

--[[
    width panel宽度
    col  显示物品列数


    bagType 物品类型
    secondType 物品二级类型
    additionItem 附加物品
    quality 物品品质限制
    pauseSelect --暂停多选添加
    pauseSelectFunc  --暂停多选时的点击回调
    已选的对象列表 用于多选
    selectList
    {
        [Item] = 
        {
            template_id
            count
        }
        [Weapon] = 
        {
            unique_id
            count
        }
    }
    
    defaultSelect 默认触发选择
    upgradeItem 升级的对象（不显示有装备者的武器和该武器）

    selectMode 选择模式
    onClick 点击物品发送事件名称
    reduceFunc 点击减少按钮发送事件名称
    batchSelectionFunc 批量选择事件
    hideFunc 关闭回调
]]

local SelectMode = {
    Single = 1,
    Plural = 2
}

ItemSelectPanelV2.ShowSortType = {
    Quality = 1,
    Level = 2,
}

function ItemSelectPanelV2:__init()
    self:SetAsset("Prefabs/UI/Weapon/ItemSelectPanelV2.prefab")
    self.sourceObjList = {}
    self.batchSelectMap = {}
end

function ItemSelectPanelV2:__delete()
    EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("ItemUpdate"))
    self.itemTips:DeleteMe()
end

function ItemSelectPanelV2:__Create()
    self.itemTips = CommonItemTip.New(self.CommonTips)
end

function ItemSelectPanelV2:__CacheObject()
    --self:SetCacheMode(UIDefine.CacheMode.destroy)
end


function ItemSelectPanelV2:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("ItemUpdate"))
end

function ItemSelectPanelV2:__BindListener()
    --self:SetHideNode("ItemSelectPanel_Eixt")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close"))
    
    self.BGButton_btn.onClick:AddListener(self:ToFunc("HideItemTips"))
    for index = 1, 4, 1 do
        self["Toggle" ..index.. "_tog"].onValueChanged:AddListener(function (isEnter)
			if isEnter then
				self:SortToggle(index)
                self:ChangeToggle(index)
            else
                UtilsUI.SetTextColor(self["SortText"..index.."_txt"], "#D0D0D0")
			end
        end)
        if index <= 3 then
            self["QulityBtn"..index.."_btn"].onClick:AddListener(function ()
                local isSelect = not self["Selected"..index].activeSelf
                self["Selected"..index]:SetActive(isSelect)
                self:UpdateBatchSelection()
                --self:BatchSelection(index, isSelect)
            end)
        end
    end
end

function ItemSelectPanelV2:ChangeToggle(index)
    for i = 1, 4, 1 do
        if i == index then
            self["Select"..i]:SetActive(true)
        else
            self["Select"..i]:SetActive(false)
        end
    end
    
end

function ItemSelectPanelV2:__Hide()
    self.curIndex = nil
    self.curUniqueId = nil
    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end
    if self.hideFunc then
        self.hideFunc()
    end
    self:HideItemTips()
end

function ItemSelectPanelV2:__Show()
    self:SetAcceptInput(true)
    self.itemObjList = {}
    self.firstShow = true
    local config = self.args.config

    -- if config.bagType == BagEnum.BagType.Partner then
    --     local item = self.PartnerItem_rect
    --     self.ItemScroll_recyceList:SetItem(item)
    -- else
    --     local item = self.SingleItem_rect
    --     self.ItemScroll_recyceList:SetItem(item)
    -- end
    local item = self.SingleItem_rect
    self.ItemScroll_recyceList:SetItem(item)
    self:AnalyseConfig(config)
    self:RefreshItemList()
end

function ItemSelectPanelV2:__ShowComplete()
    self.firstShow = false
end

function ItemSelectPanelV2:AnalyseConfig(config)

    self.onClick = config.onClick
    self.reduceFunc = config.reduceFunc
    self.hideFunc = config.hideFunc
    self.batchSelectionFunc = config.batchSelectionFunc
    self.defaultSelect = self.curUniqueId or config.defaultSelect
    self.selectMode = config.selectMode or SelectMode.Single
    self.pauseSelect = config.pauseSelect
    self.pauseSelectFunc = config.pauseSelectFunc
    self.bagType = config.bagType

    --用于本地排序
    self.showSortType = self.showSortType or ItemSelectPanelV2.ShowSortType.Quality
    self.isAscending = false
    self.PanelName_txt.text = config.name or TI18N("武器选择")

    if config.width then
        self.PanelBody_rect.sizeDelta = Vector2(config.width, 0)
    end

    if config.col then
        self.ItemScroll_recyceList.Col = config.col
    end

    local bagData = {}
    if config.bagType or config.secondType then
        local data = mod.BagCtrl:SortBag(config.secondType, BagEnum.SortType.Quality, nil, config.bagType) or {}
        for key, value in pairs(data) do
            --锁住的不参与排序
            if value.is_locked == true then
                goto continue
            end
            if config.quality then
                local quality = ItemConfig.GetItemConfig(value.template_id).quality
                if quality > config.quality then
                    goto continue
                end
            end
            if config.upgradeItem then
                if (value.hero_id and value.hero_id ~= 0) or value.unique_id == config.upgradeItem then
                    goto continue
                end
            end
            table.insert(bagData, value)
            ::continue::
        end
    end

    if config.additionItem then
        for i = 1, #config.additionItem, 1 do
            local items = mod.BagCtrl:GetItemInBag(config.additionItem[i])
            if items and next(items) then
                if ItemConfig.GetItemType(config.additionItem[i]) == BagEnum.BagType.Item then
                    local itemInfo = {template_id = config.additionItem[i], count = 0}
                    for key, value in pairs(items) do
                        itemInfo.count = itemInfo.count + value.count
                    end
                    table.insert(bagData, 1 ,itemInfo)
                elseif ItemConfig.GetItemType(config.additionItem[i]) == BagEnum.BagType.Weapon then
                    for key, value in pairs(items) do
                        if (not config.upgradeItem or (config.upgradeItem ~= value.unique_id and value.hero_id == 0)) then
                            local itemInfo = UtilsBase.copytab(value)
                            table.insert(bagData, 1, itemInfo)
                        end
                    end
                end
            end
        end
    end
    self.curBagData = bagData
    self:SortItem(nil, self.showSortType, self.isAscending)
    self:AnalyseSelectData(config.selectList)
end

function ItemSelectPanelV2:SortToggle(index)
    UtilsUI.SetTextColor(self["SortText"..index.."_txt"], "#191818")
    local sortType, isAscending
    if index <= 2 then
        sortType = ItemSelectPanelV2.ShowSortType.Quality
    else
        sortType = ItemSelectPanelV2.ShowSortType.Level
    end
    local result = math.fmod(index, 2)
    isAscending = (result == 0)
    self:ChangeSort(sortType, isAscending)
end

function ItemSelectPanelV2:ChangeSort(sortType,isAscending)
    if self.showSortType ~= sortType or self.isAscending ~= isAscending then
        self.showSortType = sortType or self.showSortType
		self.isAscending = isAscending
        self:SortItem(nil, sortType, isAscending)
        self:RefreshItemList()
    end
end

function ItemSelectPanelV2:SortItem(bagData, sortType, isAscending)
    bagData = bagData or self.curBagData
    isAscending = isAscending or false
    if sortType == ItemSelectPanelV2.ShowSortType.Quality then
        if not isAscending then
            table.sort(bagData, self:ToFunc("SortBayQuality"))
        else
            table.sort(bagData, self:ToFunc("SortBayQualityAscending"))
        end
    elseif sortType == ItemSelectPanelV2.ShowSortType.Level then
        if not isAscending then
            table.sort(bagData, self:ToFunc("SortBayLevel"))
        else
            table.sort(bagData, self:ToFunc("SortBayLevelAscending"))
        end
    end
end

function ItemSelectPanelV2:SortBayQuality(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aType = ItemConfig.GetItemType(a.template_id)
    local bType = ItemConfig.GetItemType(b.template_id)

    if aType ~= bType then
        if aType == BagEnum.BagType.Item then
            return true
        elseif bType == BagEnum.BagType.Item then
            return false
        else
            return aType > bType
        end
    end
    if aType == BagEnum.BagType.Item then
        return aConfig.quality > bConfig.quality
    else
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality > bConfig.quality
        end
        if a.lev ~= b.lev then
            return a.lev > b.lev
        end
        if a.template_id ~= b.template_id then
            return a.template_id > b.template_id
        end
        return aConfig.order_id > bConfig.order_id
    end
end

function ItemSelectPanelV2:SortBayQualityAscending(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aType = ItemConfig.GetItemType(a.template_id)
    local bType = ItemConfig.GetItemType(b.template_id)
    if aType ~= bType then
        if aType == BagEnum.BagType.Item then
            return true
        elseif bType == BagEnum.BagType.Item then
            return false
        else
            return aType > bType
        end
    end
    if aType == BagEnum.BagType.Item then
        return aConfig.quality < bConfig.quality
    else
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality < bConfig.quality
        end
        if a.lev ~= b.lev then
            return a.lev > b.lev
        end
        if a.template_id ~= b.template_id then
            return a.template_id > b.template_id
        end
        return aConfig.order_id > bConfig.order_id
    end
end

function ItemSelectPanelV2:SortBayLevel(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aType = ItemConfig.GetItemType(a.template_id)
    local bType = ItemConfig.GetItemType(b.template_id)
    if aType ~= bType then
        if aType == BagEnum.BagType.Item then
            return true
        elseif bType == BagEnum.BagType.Item then
            return false
        else
            return aType > bType
        end
    end
    if aType == BagEnum.BagType.Item then
        return aConfig.quality > bConfig.quality
    else
        if a.lev ~= b.lev then
            return a.lev > b.lev
        end
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality > bConfig.quality
        end
        if a.template_id ~= b.template_id then
            return a.template_id > b.template_id
        end
        return aConfig.order_id > bConfig.order_id
    end
end

function ItemSelectPanelV2:SortBayLevelAscending(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aType = ItemConfig.GetItemType(a.template_id)
    local bType = ItemConfig.GetItemType(b.template_id)
    if aType ~= bType then
        if aType == BagEnum.BagType.Item then
            return true
        elseif bType == BagEnum.BagType.Item then
            return false
        else
            return aType > bType
        end
    end
    if aType == BagEnum.BagType.Item then
        return aConfig.quality > bConfig.quality
    else
        if a.lev ~= b.lev then
            return a.lev < b.lev
        end
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality > bConfig.quality
        end
        if a.template_id ~= b.template_id then
            return a.template_id > b.template_id
        end
        return aConfig.order_id > bConfig.order_id
    end
end

--目前只有多选
function ItemSelectPanelV2:AnalyseSelectData(selectConfig)
    if not selectConfig then
        return
    end
    local bagData = self.curBagData
    for index, value in ipairs(bagData) do
        local type = ItemConfig.GetItemType(value.template_id)
        if selectConfig[type] and type == BagEnum.BagType.Item then
            if selectConfig[type][value.template_id] then
                value.yellowSelectedBox = true
                value.selectCount = selectConfig[type][value.template_id]
            end
        elseif selectConfig[type] and selectConfig[type][value.unique_id] then
            if selectConfig[type][value.unique_id] then
                value.yellowSelectedBox = true
                value.selectedMark = true
            end
        end
    end
end

function ItemSelectPanelV2:UpdateCommonItem(index)
    if self.ItemScroll_recyceList:CheckIndexState(index) and self.itemObjList[index] then
        local itemInfo = self.curBagData[index]
        self.itemObjList[index].commonItem:SetItem(itemInfo)
        self.itemObjList[index].commonItem:Show()
    end
end

function ItemSelectPanelV2:ItemUpdate()
    if not self.active then
        return
    end
    --TODO 先用全更试试
    self.curIndex = nil
    self:AnalyseConfig(self.args.config)
    self:RefreshItemList()
end

function ItemSelectPanelV2:RefreshItemList()
    self.NullPanel:SetActive(#self.curBagData == 0)
    if not self.firstRefresh then
        self.firstRefresh = true
        self.ItemScroll_recyceList:ResetList()
    end
    local bagCount = #self.curBagData
    self.ItemScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.ItemScroll_recyceList:SetCellNum(bagCount)

end

function ItemSelectPanelV2:RefreshItemCell(index, go)
    if not go then
        return
    end

    local commonItem
    local itemObj

    -- if self.bagType == BagEnum.BagType.Partner then
    --     itemObj = go.transform:Find("PartnerItem").gameObject
    -- else
    --     itemObj = go.transform:Find("SingleItem").gameObject
    -- end
    itemObj = go.transform:Find("SingleItem").gameObject
    if self.itemObjList[index] then
        commonItem = self.itemObjList[index].commonItem
    else
        commonItem = CommonItem.New()
        self.itemObjList[index] = {}
        self.itemObjList[index].commonItem = commonItem
    end

    self.itemObjList[index].itemObj = itemObj

    if self.selectMode == SelectMode.Single then
        self:SingleSelect(index,commonItem)
    elseif self.selectMode == SelectMode.Plural then
        self:PluralSelect(index,commonItem)
    end

    local itemInfo = self.curBagData[index]
    if not itemInfo or not next(itemInfo) then
        commonItem:InitItem(itemObj, self.curBagData[index], false,2)
        --commonItem:Show()
        return
    else
        commonItem:InitItem(itemObj, self.curBagData[index], true,2)
        --commonItem:Show()
    end

    if self.defaultSelect and self.defaultSelect == itemInfo.unique_id then
        self.defaultSelect = nil
        itemInfo.btnFunc()
    end
end

function ItemSelectPanelV2:SingleSelect(index, commonItem)
    local itemInfo = self.curBagData[index]
    if not itemInfo then
        return
    end
    itemInfo.btnFunc = function ()
        itemInfo.selectedNormal = true
        if self.curIndex and self.curIndex ~= index then
            local lastItem = self.curBagData[self.curIndex]
            lastItem.selectedNormal = false
            self.itemObjList[self.curIndex].commonItem:SetSelected_Normal()
        end
        self.curIndex = index
        self.curUniqueId = itemInfo.unique_id
        if self.onClick then
            local type = ItemConfig.GetItemType(itemInfo.template_id)
            self.onClick(itemInfo.unique_id, itemInfo.template_id, type)
        end
        commonItem:SetItem(itemInfo)
		commonItem:Show()
    end
end

function ItemSelectPanelV2:PluralSelect(index, commonItem)
    local itemInfo = self.curBagData[index]
    if not itemInfo then
        return
    end

    local reduceFunc = function ()
        local type = ItemConfig.GetItemType(itemInfo.template_id)
        if type == BagEnum.BagType.Item then
            itemInfo.selectCount = itemInfo.selectCount - 1
            if itemInfo.selectCount == 0 then
                itemInfo.yellowSelectedBox = false
                itemInfo.reduceFunc = nil
            end
        else
            itemInfo.selectedMark = false
            itemInfo.yellowSelectedBox = false
            itemInfo.reduceFunc = nil
        end

        if self.reduceFunc then
            self.reduceFunc(itemInfo.unique_id, itemInfo.template_id, type, self.onlyChangeData)
        end

        if not self.onlyChangeData then
            if not self.pauseSelect then
                local itemConfig = ItemConfig.GetItemConfig(itemInfo.template_id)
                if itemConfig.quality <= 3 then
                    self["Selected"..itemConfig.quality]:SetActive(false)
                end

            end
            commonItem:SetItem(itemInfo)
            commonItem:Show()
            self:HideItemTips()
        end
    end

    itemInfo.btnFunc = function ()
        if not self.onlyChangeData then
            --self:ShowItemTips(itemInfo)
        end
        
        if self.pauseSelect then
            if self.pauseSelectFunc then
                self.pauseSelectFunc()
            end
            return
        end
        if itemInfo.is_locked then
            return
        end
        local type = ItemConfig.GetItemType(itemInfo.template_id)
        if type == BagEnum.BagType.Item then
            itemInfo.selectCount = itemInfo.selectCount or 0
            if itemInfo.selectCount + 1 > itemInfo.count then
                return
            end
            itemInfo.selectCount = itemInfo.selectCount + 1
            itemInfo.yellowSelectedBox = true
        else
            if itemInfo.selectedMark == true then
                return
            end
            itemInfo.selectedMark = true
            itemInfo.yellowSelectedBox = true
        end

        itemInfo.reduceFunc = reduceFunc
        if self.onClick then
            self.onClick(itemInfo.unique_id, itemInfo.template_id, type, self.onlyChangeData)
        end
        if not self.onlyChangeData then
            commonItem:SetItem(itemInfo)
            commonItem:Show()
        end
    end
    if itemInfo.selectCount and itemInfo.selectCount > 0 then
        itemInfo.reduceFunc = reduceFunc
    end
    if itemInfo.selectedMark then
        itemInfo.reduceFunc = reduceFunc
    end
end

function ItemSelectPanelV2:UpdateBatchSelection()
    local qualitys = {}
    local count = 0
    for i = 1, 3, 1 do
        local select =  self["Selected"..i].activeSelf
        qualitys[i] = select
        if select then
            count = count + 1
        end
    end
    self.onlyChangeData = true
    for k, itemInfo in pairs(self.batchSelectMap) do
        local itemType = ItemConfig.GetItemType(itemInfo.template_id)
        self:SelectData(itemInfo, itemType, false)
        self:UpdateCommonItem(k)
    end
    TableUtils.ClearTable(self.batchSelectMap)

    if count > 0 then
        self:BatchSelection(qualitys)
    end

    self:HideItemTips()
    if self.batchSelectionFunc then
        self.batchSelectionFunc()
    end
    self.onlyChangeData = false
end

function ItemSelectPanelV2:BatchSelection(qualitys)
    local curData = self.curBagData

    for i = 1, #curData, 1 do
        if self.pauseSelect then
            break
        end
        local itemInfo = curData[i]
        local itemType = ItemConfig.GetItemType(itemInfo.template_id)
        local itemConfig = ItemConfig.GetItemConfig(itemInfo.template_id)
        if qualitys[itemConfig.quality] then
            if itemType == BagEnum.BagType.Weapon then
                if itemInfo.lev > 1 or itemInfo.stage > 1 then
                    goto continue
                end
            elseif itemType == BagEnum.BagType.Partner then
                if itemInfo.lev > 1 then
                    goto continue
                end
            end
            self.batchSelectMap[i] = itemInfo
            self:SelectData(itemInfo, itemType, true)
            self:UpdateCommonItem(i)
        end
        ::continue::
    end
end

function ItemSelectPanelV2:SelectData(itemInfo, itemType, isSelect)
    if itemType == BagEnum.BagType.Item then
        itemInfo.selectCount = itemInfo.selectCount or 0
        if isSelect then
            for i = itemInfo.selectCount + 1, itemInfo.count, 1 do
                if self.pauseSelect then
                    break
                end
                if itemInfo.btnFunc then
                    itemInfo.btnFunc()
                end
            end
        else
            for i = itemInfo.selectCount, 1, -1 do
                if itemInfo.reduceFunc then
                    itemInfo.reduceFunc()
                end
            end
        end
    else
        if not isSelect and itemInfo.reduceFunc then
            itemInfo.reduceFunc()
        end
        if isSelect and itemInfo.btnFunc then
            itemInfo.btnFunc()
        end
    end
end

function ItemSelectPanelV2:ResetBatchSelection()
    for i = 1, 3, 1 do
        self["Selected"..i]:SetActive(false)
    end
    --self:UpdateBatchSelection()
end

function ItemSelectPanelV2:ShowItemTips(itemInfo)
    self.BGButton:SetActive(true)
    self.CommonTips:SetActive(true)
    self.itemTips:SetItemInfo(itemInfo)
end

function ItemSelectPanelV2:HideItemTips()
    self.BGButton:SetActive(false)
    self.CommonTips:SetActive(false)
end

function ItemSelectPanelV2:PauseSelect(isPause)
    self.pauseSelect = isPause
end

function ItemSelectPanelV2:Close()
    self:Hide()
end