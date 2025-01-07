ItemSelectPanel = BaseClass("ItemSelectPanel", BasePanel)

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
    upgradeWeapon 升级的武器（不显示有装备者的武器和该武器）

    selectMode 选择模式
    onClick 点击物品发送事件名称
    reduceFunc 点击减少按钮发送事件名称
    hideFunc 关闭回调
]]

local SelectMode = {
    Single = 1,
    Plural = 2
}

local curSelectColor = "#17fcb3"

ItemSelectPanel.ShowSortType = {
    Quality = 1,
    Level = 2,
}

local ButtonToSort =
{
    [1] = ItemSelectPanel.ShowSortType.Quality,
    [2] = ItemSelectPanel.ShowSortType.Level,
}

function ItemSelectPanel:__init()
    self:SetAsset("Prefabs/UI/Weapon/ItemSelectPanel.prefab")
    self.sourceObjList = {}
    self.updateMap = {}
end

function ItemSelectPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("ItemUpdate"))
    EventMgr.Instance:RemoveListener(EventName.ItemChange, self:ToFunc("ItemChange"))
    EventMgr.Instance:RemoveListener(EventName.ItemDelete, self:ToFunc("RefreshList")) 
    EventMgr.Instance:RemoveListener(EventName.BagItemChange, self:ToFunc("OnBagItemChange")) 
    self.itemTips:DeleteMe()
end

function ItemSelectPanel:__Create()
    self.itemTips = CommonItemTip.New(self.CommonTips)
end

function ItemSelectPanel:__CacheObject()
    --self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ItemSelectPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("ItemUpdate"))
    EventMgr.Instance:AddListener(EventName.ItemChange, self:ToFunc("ItemChange"))
    EventMgr.Instance:AddListener(EventName.ItemDelete, self:ToFunc("RefreshList"))
    EventMgr.Instance:AddListener(EventName.BagItemChange, self:ToFunc("OnBagItemChange"))
end

function ItemSelectPanel:__BindListener()
    --self:SetHideNode("ItemSelectPanel_Eixt")

    self.SortButton_btn.onClick:AddListener(self:ToFunc("OpenSort"))
    self.ChangeSort_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeAscending"))
    self.BGButton_btn.onClick:AddListener(self:ToFunc("HideItemTips"))
    for i = 1, 2, 1 do
        self["SortCaseBtn"..i.."_btn"].onClick:AddListener(function ()
                self:OnClick_SetSort(i)
            end
        )
    end
end

function ItemSelectPanel:__Hide()
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

function ItemSelectPanel:__Show()
    self:SetAcceptInput(true)
    self.itemObjList = {}
    self.firstShow = true
    local config = self.args.config
    local item = self.Template.transform:Find("SingleItem_")
    self.ItemScroll_recyceList:SetItem(item)
    self:AnalyseConfig(config)
    self:RefreshItemList()
end

function ItemSelectPanel:__ShowComplete()
    self.firstShow = false
end

function ItemSelectPanel:RefreshList()
    self:AnalyseBag(self.args.config)
    self:RefreshItemList()
end

function ItemSelectPanel:AnalyseConfig(config)

    self.onClick = config.onClick
    self.reduceFunc = config.reduceFunc
    self.hideFunc = config.hideFunc
    self.defaultSelect = self.curUniqueId or config.defaultSelect
    self.selectMode = config.selectMode or SelectMode.Single
    self.pauseSelect = config.pauseSelect
    self.pauseSelectFunc = config.pauseSelectFunc
    self.bagType = config.bagType
    self.btnType = config.btnType or 1

    if self.btnType == 1 then
        UtilsUI.SetActive(self.CommonBack1,true)
        UtilsUI.SetActive(self.CommonBack2,false)
        self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close"))
    elseif self.btnType == 2 then
        UtilsUI.SetActive(self.CommonBack2,true)
        UtilsUI.SetActive(self.CommonBack1,false)
        self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close"))
    end

    --用于本地排序
    self.showSortType = self.showSortType or ItemSelectPanel.ShowSortType.Quality
    self.isAscending = false
    self.PanelName_txt.text = config.name or TI18N("武器选择")

    if config.width then
        self.PanelBody_rect.sizeDelta = Vector2(config.width, 0)
    end

    if config.col then
        self.ItemScroll_recyceList.Col = config.col
    end
    self:AnalyseBag(config)
end

function ItemSelectPanel:AnalyseBag(config)
    local bagData = {}
    if config.bagType or config.secondType then
        local data = mod.BagCtrl:SortBag(config.secondType, BagEnum.SortType.Quality, nil, config.bagType) or {}
        for key, value in pairs(data) do
            if config.quality then
                local quality = ItemConfig.GetItemConfig(value.template_id).quality
                if quality > config.quality then
                    goto continue
                end
            end
            if config.upgradeWeapon then
                if (value.hero_id and value.hero_id ~= 0) or value.unique_id == config.upgradeWeapon then
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
                        if (not config.upgradeWeapon or (config.upgradeWeapon ~= value.unique_id and value.hero_id == 0)) then
                            local itemInfo = UtilsBase.copytab(value)
                            table.insert(bagData, 1, itemInfo)
                        end
                    end
                end
            end
        end
    end
    self:SortItem(bagData, self.showSortType, self.isAscending)
    self.curBagData = bagData or {}
    self:AnalyseSelectData(config.selectList)
    self:OnClick_SetSort(self.showSortType, true)
end

function ItemSelectPanel:OnClick_SetSort(index, onlyUi)
    self.SortText_txt.text = self["SortText"..index.."_txt"].text
    for i = 1, 2, 1 do
        if i ~= index then
            self["SortText"..i.."_txt"].color = Color.white
        else
            UtilsUI.SetTextColor(self["SortText"..i.."_txt"], curSelectColor)
        end
    end
    if onlyUi then
        return
    end
    self:ChangeAutoSelect(ButtonToSort[index])
    self:OpenSort()
end

function ItemSelectPanel:OnClick_ChangeAscending()
    local isAscending = not self.isAscending
    self:ChangeAutoSelect(self.showSortType, isAscending)
end

function ItemSelectPanel:ChangeAutoSelect(sortType,isAscending)
    if self.showSortType ~= sortType or self.isAscending ~= isAscending then
        self.showSortType = sortType or self.showSortType
		self.isAscending = isAscending
        self:SortItem(nil, sortType, isAscending)
        self:RefreshItemList()
    end
end

function ItemSelectPanel:SortItem(bagData, sortType, isAscending)
    bagData = bagData or self.curBagData
    isAscending = isAscending or false
    if sortType == ItemSelectPanel.ShowSortType.Quality then
        if not isAscending then
            table.sort(bagData, self:ToFunc("SortBayQuality"))
        else
            table.sort(bagData, self:ToFunc("SortBayQualityAscending"))
        end
    elseif sortType == ItemSelectPanel.ShowSortType.Level then
        if not isAscending then
            table.sort(bagData, self:ToFunc("SortBayLevel"))
        else
            table.sort(bagData, self:ToFunc("SortBayLevelAscending"))
        end
    end
end

function ItemSelectPanel:SortBayQuality(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aType = ItemConfig.GetItemType(a.template_id)
    local bType = ItemConfig.GetItemType(b.template_id)
    if aType ~= bType then
        return aType > bType
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

function ItemSelectPanel:SortBayQualityAscending(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aType = ItemConfig.GetItemType(a.template_id)
    local bType = ItemConfig.GetItemType(b.template_id)
    if aType ~= bType then
        return aType > bType
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

function ItemSelectPanel:SortBayLevel(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aType = ItemConfig.GetItemType(a.template_id)
    local bType = ItemConfig.GetItemType(b.template_id)
    if aType ~= bType then
        return aType > bType
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

function ItemSelectPanel:SortBayLevelAscending(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aType = ItemConfig.GetItemType(a.template_id)
    local bType = ItemConfig.GetItemType(b.template_id)
    if aType ~= bType then
        return aType > bType
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
function ItemSelectPanel:AnalyseSelectData(selectConfig)
    if not selectConfig then
        return
    end
    local bagData = self.curBagData
    for index, value in ipairs(bagData) do
        local type = ItemConfig.GetItemType(value.template_id)
        if selectConfig[type] and type == BagEnum.BagType.Weapon then
            if selectConfig[type][value.unique_id] then
                value.yellowSelectedBox = true
                value.selectedMark = true
            end
        elseif selectConfig[type] and type == BagEnum.BagType.Item then
            if selectConfig[type][value.template_id] then
                value.yellowSelectedBox = true
                value.selectCount = selectConfig[type][value.template_id]
            end
        end
    end
end

function ItemSelectPanel:UpdateCommonItem(index)
	local itemInfo = self.curBagData[index]
	self.itemObjList[index].commonItem:SetItem(itemInfo)
    if self.ItemScroll_recyceList:CheckIndexState(index) then
        self.itemObjList[index].commonItem:Show()
    end
end

function ItemSelectPanel:ItemUpdate()
    if not self.active then
        return
    end
    local topIndex = self.ItemScroll_recyceList:GetTopDataIndex()
    local botIndex = self.ItemScroll_recyceList:GetBotDataIndex()

    for i = topIndex, botIndex, 1 do
        local data = self.curBagData[i]
        if data and self.updateMap[data.unique_id] then
            local type = ItemConfig.GetItemType(data.template_id)
            local newData = mod.BagCtrl:GetItemByUniqueId(data.unique_id, type)
            if newData and next(newData) then
                for k, v in pairs(newData) do
                    data[k] = newData[k]
                end
            end
            self:UpdateCommonItem(i)
        end
    end

    TableUtils.ClearTable(self.updateMap)
end

function ItemSelectPanel:OnBagItemChange(iteminfo)
    if self.tipsShowItemInfo and self.tipsShowItemInfo.unique_id == iteminfo.unique_id then
        self.itemTips:SetItemInfo(iteminfo)
    end
end

function ItemSelectPanel:ItemChange(uniqueKey, type)
    if not self.active then
        return
    end
    self.updateMap[uniqueKey] = true
    self:ItemUpdate()
end

function ItemSelectPanel:RefreshItemList()
    self.NullPanel:SetActive(#self.curBagData == 0)
    if not self.firstRefresh then
        self.firstRefresh = true
        self.ItemScroll_recyceList:ResetList()
    end

    local bagCount = #self.curBagData
    self.ItemScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.ItemScroll_recyceList:SetCellNum(bagCount, true)
end

function ItemSelectPanel:RefreshItemCell(index, go)
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
        commonItem:InitItem(itemObj, self.curBagData[index], false)
        --commonItem:Show()
        return
    else
        commonItem:InitItem(itemObj, self.curBagData[index], true)
        --commonItem:Show()
    end

    if self.defaultSelect and self.defaultSelect == itemInfo.unique_id then
        self.defaultSelect = nil
        itemInfo.btnFunc()
    end
end

function ItemSelectPanel:SingleSelect(index, commonItem)
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
            local curBotContentPosition = - self.ItemScroll_rect.rect.height
            local curTopContentPosition = 0
            local cellTrans = commonItem.object.transform.parent.parent
            local ItemBotPos = cellTrans.anchoredPosition.y - cellTrans.rect.height + self.Content_rect.anchoredPosition.y
            local ItemTopPos = cellTrans.anchoredPosition.y + self.Content_rect.anchoredPosition.y
            
            if curTopContentPosition < ItemTopPos then
                UnityUtils.SetAnchoredPosition(self.Content_rect, 0, self.Content_rect.anchoredPosition.y - ItemTopPos + curTopContentPosition)
            elseif curBotContentPosition > ItemBotPos then
                UnityUtils.SetAnchoredPosition(self.Content_rect, 0, self.Content_rect.anchoredPosition.y + curBotContentPosition - ItemBotPos)
            end
        end
        commonItem:SetItem(itemInfo)
        commonItem:Show()
    end
end

function ItemSelectPanel:PluralSelect(index, commonItem)
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
            self.reduceFunc(itemInfo.unique_id, itemInfo.template_id, type)
        end
        commonItem:SetItem(itemInfo)
		commonItem:Show()
        self:HideItemTips()
    end

    itemInfo.btnFunc = function ()
        self:ShowItemTips(itemInfo)
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
            self.onClick(itemInfo.unique_id, itemInfo.template_id, type)
        end
        commonItem:SetItem(itemInfo)
		commonItem:Show()
    end
    if itemInfo.selectCount and itemInfo.selectCount > 0 then
        itemInfo.reduceFunc = reduceFunc
    end
    if itemInfo.selectedMark then
        itemInfo.reduceFunc = reduceFunc
    end
end

function ItemSelectPanel:ShowItemTips(itemInfo)
    self.BGButton:SetActive(true)
    self.CommonTips:SetActive(true)
    self.itemTips:SetItemInfo(itemInfo)
    self.tipsShowItemInfo = itemInfo
end

function ItemSelectPanel:HideItemTips()
    self.BGButton:SetActive(false)
    self.CommonTips:SetActive(false)
    self.tipsShowItemInfo = nil
end

function ItemSelectPanel:PauseSelect(isPause)
    self.pauseSelect = isPause
end

function ItemSelectPanel:OpenSort()
    self.SortGroup:SetActive(not self.SortGroup.activeSelf)
end

function ItemSelectPanel:Close()

end

function ItemSelectPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end