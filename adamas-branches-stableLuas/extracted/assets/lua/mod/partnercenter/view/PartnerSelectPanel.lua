PartnerSelectPanel = BaseClass("PartnerSelectPanel", BasePanel)
local _tinsert = table.insert
--初始化
function PartnerSelectPanel:__init(parent)
    self:SetAsset("Prefabs/UI/PartnerCenter/PartnerSelectPanel.prefab")
    self.curOriginData = {}
    self.curBagData = {}

    self.curIndex = nil 
    self.curUniqueId = nil
    
    --ui 
    self.itemObjList = {}

    --sortRule
    self.sortRule = {
        sortType = PartnerBagConfig.SortType.SortByQuality,
        element = {},
        quality = {},
    }
    self.isAscending = false --默认降序
end

--添加监听器
function PartnerSelectPanel:__BindListener()
    self.SortButton_btn.onClick:AddListener(self:ToFunc("OpenSortPanel"))
    self.ChangeSort_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeAscending"))

end

function PartnerSelectPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
    EventMgr.Instance:AddListener(EventName.PartnerBagSortSubmit, self:ToFunc("UpdatePartnerList"))
end

--缓存对象
function PartnerSelectPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerSelectPanel:__Create()
    
end

function PartnerSelectPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
    TableUtils.ClearTable(self.curBagData)
    for i, v in pairs(self.itemObjList) do
        if v.commonItem then
            v.commonItem:DeleteMe()
        end
    end
    TableUtils.ClearTable(self.itemObjList)
    if self.ItemScroll_recyceList then
        self.ItemScroll_recyceList:CleanAllCell()
    end
end

function PartnerSelectPanel:__Hide()
end

function PartnerSelectPanel:__ShowComplete()

end

function PartnerSelectPanel:__Show(args)
    if self.args then
        self.selectPartnerFunc = self.args.selectPartnerFunc
        self.showPartnerFunc = self.args.showPartnerFunc
        self.defaultSelect = self.args.defaultSelectUniqueId
        self.selectYellow = self.args.selectYellow          --黄色选中框,不填就是默认
        self.markIndexMap = self.args.markIndexMap --设置角标显示数据
    end
    self.defaultSelectItem = nil

    local partnerData = mod.BagCtrl:GetBagByType(BagEnum.BagType.Partner)

    for i, v in pairs(partnerData) do
        _tinsert(self.curOriginData, v)
    end
    self.curBagData = TableUtils.CopyTable(self.curOriginData)
    self:OpenLeftPanel(self.curBagData)
end

function PartnerSelectPanel:PartnerInfoChange(oldData, newData)
    local index = self:UpdatePartnerData(oldData, newData)
    if index then
        self.curBagData[index] = TableUtils.CopyTable(newData)
        self:RefreshItem(index)
    end
end

function PartnerSelectPanel:UpdatePartnerData(oldData, newData)
    --按需更新
    local index 
    for i, v in pairs(self.curBagData) do
        if v.unique_id == newData.unique_id then
            index = i
            break
        end
    end
    return index
end

function PartnerSelectPanel:OpenLeftPanel(partnerData)
    --按钮更新
    self:ChangeSortAscendingBtn()
    --默认按品质排序 
    self:SortItem(partnerData, self.sortRule.sortType, self.isAscending)
    --更新UI
    self:RefreshItemList()
end


function PartnerSelectPanel:ChangeSortAscendingBtn()
    UtilsUI.SetActive(self.sortDown, not self.isAscending)
    UtilsUI.SetActive(self.sortUp,  self.isAscending)
end

function PartnerSelectPanel:RefreshSortText()
    self.SortText_txt.text = PartnerBagConfig.GetSortTypeName(self.sortRule.sortType)
end

--排序
function PartnerSelectPanel:SortItem(bagData, sortType, isAscending)
    bagData = bagData or {}
    isAscending = isAscending or false
    if sortType == PartnerBagConfig.SortType.SortByQuality then
        if not isAscending then
            table.sort(bagData, self:ToFunc("SortBayQuality"))
        else
            table.sort(bagData, self:ToFunc("SortBayQualityAscending"))
        end
    elseif sortType == PartnerBagConfig.SortType.SortByLevel then
        if not isAscending then
            table.sort(bagData, self:ToFunc("SortBayLevel"))
        else
            table.sort(bagData, self:ToFunc("SortBayLevelAscending"))
        end
    elseif sortType == PartnerBagConfig.SortType.SortByCareerLevel then
        if not isAscending then
            table.sort(bagData, self:ToFunc("SortByCareerLevel"))
        else
            table.sort(bagData, self:ToFunc("SortByCareerLevelAscending"))
        end
    end
end

function PartnerSelectPanel:SortBayQuality(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aIsEquip = a.hero_id ~= 0
    local bIsEquip = b.hero_id ~= 0
    local aIsWork = a.work_info and a.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    local bIsWork = b.work_info and b.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    
    if aConfig.quality ~= bConfig.quality then
        return aConfig.quality > bConfig.quality
    end
    --正在被佩戴的>正在工作的>其他
    if aIsEquip and not bIsEquip then
        return true
    elseif bIsEquip and not aIsEquip then
        return false
    end

    if aIsWork and not bIsWork then
        return true
    elseif not aIsWork and bIsWork then
        return false
    end
    
    if a.lev ~= b.lev then
        return a.lev > b.lev
    end
    
    if a.template_id ~= b.template_id then
        return a.template_id > b.template_id
    end
    
    return aConfig.order_id > bConfig.order_id
end

function PartnerSelectPanel:SortBayQualityAscending(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aIsEquip = a.hero_id ~= 0
    local bIsEquip = b.hero_id ~= 0
    local aIsWork = a.work_info and a.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    local bIsWork = b.work_info and b.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    
    if aConfig.quality ~= bConfig.quality then
        return aConfig.quality < bConfig.quality
    end

    if aIsWork and not bIsWork then
        return false
    elseif not aIsWork and bIsWork then
        return true
    end
    
    --其他>正在工作的>正在被佩戴的
    if aIsEquip and not bIsEquip then
        return false
    elseif bIsEquip and not aIsEquip then
        return true
    end
    
    if a.lev ~= b.lev then
        return a.lev < b.lev
    end
    
    if a.template_id ~= b.template_id then
        return a.template_id < b.template_id
    end
    
    return aConfig.order_id < bConfig.order_id
end

function PartnerSelectPanel:SortBayLevel(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aIsEquip = a.hero_id ~= 0
    local bIsEquip = b.hero_id ~= 0
    local aIsWork = a.work_info and a.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    local bIsWork = b.work_info and b.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    
    if a.lev ~= b.lev then
        return a.lev > b.lev
    end

    --正在被佩戴的>正在工作的>其他
    if aIsEquip and not bIsEquip then
        return true
    elseif bIsEquip and not aIsEquip then
        return false
    end

    if aIsWork and not bIsWork then
        return true
    elseif not aIsWork and bIsWork then
        return false
    end
    
    if aConfig.quality ~= bConfig.quality then
        return aConfig.quality > bConfig.quality
    end
    
    if a.template_id ~= b.template_id then
        return a.template_id > b.template_id
    end
    
    return aConfig.order_id > bConfig.order_id
end

function PartnerSelectPanel:SortBayLevelAscending(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aIsEquip = a.hero_id ~= 0
    local bIsEquip = b.hero_id ~= 0
    local aIsWork = a.work_info and a.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    local bIsWork = b.work_info and b.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    
    if a.lev ~= b.lev then
        return a.lev < b.lev
    end

    if aIsWork and not bIsWork then
        return false
    elseif not aIsWork and bIsWork then
        return true
    end

    --其他>正在工作的>正在被佩戴的
    if aIsEquip and not bIsEquip then
        return false
    elseif bIsEquip and not aIsEquip then
        return true
    end
    
    if aConfig.quality ~= bConfig.quality then
        return aConfig.quality < bConfig.quality
    end
    
    if a.template_id ~= b.template_id then
        return a.template_id < b.template_id
    end
    
    return aConfig.order_id < bConfig.order_id
end

--按职业等级排序，选择职业等级最高的排
function PartnerSelectPanel:SortByCareerLevel(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aIsEquip = a.hero_id ~= 0
    local bIsEquip = b.hero_id ~= 0
    local aIsWork = a.work_info and a.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    local bIsWork = b.work_info and b.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    local aMaxCareerLevel = PartnerBagConfig.GetPartnerMaxCareerLv(a.template_id)
    local bMaxCareerLevel = PartnerBagConfig.GetPartnerMaxCareerLv(b.template_id)

    if aMaxCareerLevel ~= bMaxCareerLevel then
        return aMaxCareerLevel > bMaxCareerLevel
    end

    if aConfig.quality ~= bConfig.quality then
        return aConfig.quality > bConfig.quality
    end

    --正在被佩戴的>正在工作的>其他
    if aIsEquip and not bIsEquip then
        return true
    elseif bIsEquip and not aIsEquip then
        return false
    end

    if aIsWork and not bIsWork then
        return true
    elseif not aIsWork and bIsWork then
        return false
    end

    if a.lev ~= b.lev then
        return a.lev > b.lev
    end
    
    if a.template_id ~= b.template_id then
        return a.template_id > b.template_id
    end
    
    return aConfig.order_id > bConfig.order_id
end

function PartnerSelectPanel:SortByCareerLevelAscending(a,b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    local aIsEquip = a.hero_id ~= 0
    local bIsEquip = b.hero_id ~= 0
    local aIsWork = a.work_info and a.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    local bIsWork = b.work_info and b.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work or false
    local aMaxCareerLevel = PartnerBagConfig.GetPartnerMaxCareerLv(a.template_id)
    local bMaxCareerLevel = PartnerBagConfig.GetPartnerMaxCareerLv(b.template_id)

    if aMaxCareerLevel ~= bMaxCareerLevel then
        return aMaxCareerLevel < bMaxCareerLevel
    end

    if aConfig.quality ~= bConfig.quality then
        return aConfig.quality < bConfig.quality
    end

    if aIsWork and not bIsWork then
        return false
    elseif not aIsWork and bIsWork then
        return true
    end

    --其他>正在工作的>正在被佩戴的
    if aIsEquip and not bIsEquip then
        return false
    elseif bIsEquip and not aIsEquip then
        return true
    end
    
    if a.lev ~= b.lev then
        return a.lev < b.lev
    end
    
    if a.template_id ~= b.template_id then
        return a.template_id < b.template_id
    end
    
    return aConfig.order_id < bConfig.order_id
end

function PartnerSelectPanel:OpenSortPanel()
    PanelManager.Instance:OpenPanel(PartnerBagSortPanel)
end

function PartnerSelectPanel:OnClick_ChangeAscending()
	self.isAscending = not self.isAscending
    self:ChangeSortAscendingBtn()
    self:ResetCurValue()
    --筛选
    self.curBagData = self:PickItem(self.curOriginData, self.sortRule)
    --排序 
    self:SortItem(self.curBagData, self.sortRule.sortType, self.isAscending)
    self:RefreshItemList()
end


function PartnerSelectPanel:RefreshItemList()
    local bagCount = #self.curBagData
    if bagCount == 0 then
        --隐藏掉面板，卸载模型
        self.NullPanel:SetActive(true)
        self.ItemScroll_recyceList:CleanAllCell()

        if self.showPartnerFunc then
            self.showPartnerFunc(false)
        end
        return
    end

    self.NullPanel:SetActive(false)
    if self.showPartnerFunc then
        self.showPartnerFunc(true)
    end
    
    if not self.firstRefresh and not self.defaultSelect then
        self.defaultSelect = self.curBagData[1].unique_id
        self.firstRefresh = true
    end
    
    self.ItemScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.ItemScroll_recyceList:SetCellNum(bagCount, true)
end

function PartnerSelectPanel:RefreshItemCell(index, go)
    if not go then
        return
    end

    local commonItem
    local itemObj
    
    itemObj = go.transform:Find("SingleItem").gameObject

    if self.itemObjList[index] then
        commonItem = self.itemObjList[index].commonItem
    else
        commonItem = CommonItem.New()
        self.itemObjList[index] = {}
        self.itemObjList[index].commonItem = commonItem
    end

    self.itemObjList[index].itemObj = itemObj

    self:SingleSelect(index,commonItem)

    
    local itemInfo = self.curBagData[index]
    if not itemInfo or not next(itemInfo) then
        commonItem:InitItem(itemObj, self.curBagData[index], false)
        return
    else
        commonItem:InitItem(itemObj, self.curBagData[index], true)
    end

    if self.markIndexMap and self.markIndexMap[itemInfo.unique_id] then
        commonItem:SetSelectedCount(self.markIndexMap[itemInfo.unique_id])
    end

    if self.defaultSelect and self.defaultSelect == itemInfo.unique_id then
        self.defaultSelect = nil
        itemInfo.btnFunc()
    end
end

function PartnerSelectPanel:SingleSelect(index, commonItem)
    local itemInfo = self.curBagData[index]
    if not itemInfo then
        return
    end
    itemInfo.btnFunc = function ()

        itemInfo.selectedNormal = true
        if self.curIndex and self.curIndex ~= index then
            local lastItem = self.curBagData[self.curIndex]
            lastItem.selectedNormal = false
            self:SetSelectedItem(self.itemObjList[self.curIndex].commonItem, false)
        end
        self.curIndex = index
        self.curUniqueId = itemInfo.unique_id
        if self.selectPartnerFunc then
            self.selectPartnerFunc(self.curUniqueId)
        end
        self:SetSelectedItem(commonItem, true)
    end
end


function PartnerSelectPanel:SetSelectedItem(commonItem, select)
    if not self.selectYellow then
        commonItem:SetSelected_Normal(select)
    else
        commonItem:SetYellowSelectedBox(select)
    end
end


--筛选
function PartnerSelectPanel:PickItem(bagData, sortRule)
    local pickQuality = sortRule.quality
    local pickCareer = sortRule.element
    local pickTb = {}
    for i, v in pairs(bagData) do
        local res = true
        local partnerConfig = ItemConfig.GetItemConfig(v.template_id)
        local partnerWorkConfig = PartnerBagConfig.GetPartnerWorkConfig(v.template_id)
        --筛选了品质
        if next(pickQuality) and not pickQuality[partnerConfig.quality] then
            res = false
        end
        --筛选了职业
        if next(pickCareer) then
            local carRes = false
            if partnerWorkConfig then
                for index, data in pairs(partnerWorkConfig.career) do
                    local careerId = data[1]
                    if pickCareer[careerId] then
                        carRes = true
                        break
                    end
                end
            end
            res = carRes
        end
        
        if res then
            _tinsert(pickTb, TableUtils.CopyTable(v))
        end
    end
    
    return pickTb
end

--PartnerBagSortPanel调用接口
---@param sortRule --筛选后的规则
function PartnerSelectPanel:UpdatePartnerList(sortRule)
    self.sortRule = sortRule
    --刷新文本
    self:RefreshSortText()
    --还原选中
    self:ResetCurValue()
    --筛选
    self.curBagData = self:PickItem(self.curOriginData, self.sortRule)
    --排序
    self:SortItem(self.curBagData, self.sortRule.sortType, self.isAscending)
    --更新UI
    self:RefreshItemList()
end

function PartnerSelectPanel:ResetCurValue()
    if self.curIndex then
        local lastItem = self.curBagData[self.curIndex]
        lastItem.selectedNormal = false
        self.curIndex = nil
    end
    self.firstRefresh = false
end

function PartnerSelectPanel:RefreshItem(index)
    local data = self.curBagData[index]
    --更新item
    if self.curUniqueId == data.unique_id then
        data.selectedNormal = true
    end
    self:SingleSelect(index, self.itemObjList[index].commonItem)
    self.itemObjList[index].commonItem:InitItem(self.itemObjList[index].itemObj, self.curBagData[index], true)
    if self.markIndexMap and self.markIndexMap[data.unique_id] then
        self.itemObjList[index].commonItem:SetSelectedCount(self.markIndexMap[data.unique_id])
    end
    --更新右侧信息
    if self.parentWindow and self.parentWindow.UpdateUI then
        self.parentWindow:UpdateUI(data)
    end
end