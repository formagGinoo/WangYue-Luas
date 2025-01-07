WeaponUpgradePanel = BaseClass("WeaponUpgradePanel", BasePanel)

local AutoSelectQuality ={
    White = 1,
    Green = 2,
    Blue = 3
}
local ButtonToSelect = 
{
    [1] = AutoSelectQuality.White,
    [2] = AutoSelectQuality.Green,
    [3] = AutoSelectQuality.Blue,
}
local AbstractItem = {
    Weapon = 1,
    Item = 2
}

local curSelectColor = "#17fcb3"

function WeaponUpgradePanel:__init()
    self:SetAsset("Prefabs/UI/Weapon/WeaponUpgradePanel.prefab")
    self.sortType = BagEnum.SortType.Quality
    self.cacheMap = {}
    self.attrList = {}
    self.color1 = Color(0, 0, 0, 1)
    self.color2 = Color(196/255, 201/255, 212/255, 1)
end

function WeaponUpgradePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.WeaponUpgradeComplete, self:ToFunc("WeaponUpgradeComplete"))
end

function WeaponUpgradePanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.WeaponUpgradeComplete, self:ToFunc("WeaponUpgradeComplete"))
end

function WeaponUpgradePanel:__BindListener()
    self.AddButton_btn.onClick:AddListener(self:ToFunc("OpenSelectPanel"))
    self.MoreButton_btn.onClick:AddListener(self:ToFunc("OpenSelectPanel"))
    self.SortButton_btn.onClick:AddListener(self:ToFunc("OpenSort"))
    self.UpgradeButton_btn.onClick:AddListener(self:ToFunc("OnClick_Upgrade"))
    self.MaxLevelButton_btn.onClick:AddListener(self:ToFunc("OnClick_MaxLev"))
    self.ResetButton_btn.onClick:AddListener(self:ToFunc("OnClick_Reset"))
    self.SortGroup_btn.onClick:AddListener(function ()
        UtilsUI.SetActive(self.SortGroup, false)
    end)
    for i = 1, 3, 1 do
        self["SortCase"..i.."Btn_btn"].onClick:AddListener(function ()
                self:SetAutoSelect(i)
            end
        )
    end
    local dragBehaviour = self.LevelSlider:AddComponent(UIDragBehaviour)
    dragBehaviour.onBeginDrag = function(data)
        self.parentWindow:ClosePanel(ItemSelectPanel)
        local content = self.LevelSlider.transform:Find("Viewport/Content")
        if content then
            for i = 0, content.childCount - 1 do
                local cell = content:GetChild(i)
                if cell then
                    local itemObj = UtilsUI.GetContainerObject(cell:GetChild(0))
                    itemObj.Level_txt.fontSize = 86
                    itemObj.Level_txt.color = self.color2
                end
            end
        end
    end
    dragBehaviour.onEndDrag = function (data)
        self:OnLevelSliderDragEnd(data)
    end

end

function WeaponUpgradePanel:__Hide()
    --手动选择列表,暂时只使用一个
    --self.selectList = {}
    --自动选择列表
    self.autoSelectList ={}
    --抽象类型列表
    self.abstractList = {}
end

function WeaponUpgradePanel:__Show()
    --self.selectList = {}
    self.autoSelectList = {}
    self.abstractList = {}
    --TODO 之后统一保存到配置文件
    if PlayerPrefs.GetInt("WeaponUpgrade_AutoSeleteQuality") ~= 0 then
        self:ChangeAutoSelect(PlayerPrefs.GetInt("WeaponUpgrade_AutoSeleteQuality"),true)
    else
        self:ChangeAutoSelect(nil, true)
    end
    self:UpdateItem()
    self:ShowDetail()
end

function WeaponUpgradePanel:WeaponInfoChange()
    self:UpdateItem()
    self:ShowDetail()
end

--#region 界面逻辑
function WeaponUpgradePanel:ShowDetail(uniqueId)
    self:RefreshItemList()
    self:GetMaxLev()

    local weaponData = self:GetWeaponData()
    local limitLev = RoleConfig.GetStageConfig(weaponData.template_id, weaponData.stage).level_limit
    self:jumpToIndex(weaponData.lev + 1, limitLev)
    self:CalculateExp()
    --self.MoneyCost:SetActive(false)
end

function WeaponUpgradePanel:OpenSort()
    local active = self.SortGroup.activeSelf
    if active then
        self.SortGroup:SetActive(false)
        UnityUtils.SetLocalEulerAngles(self.SortArrow_rect, 0, 0, 180)
    else
        self.SortGroup:SetActive(true)
        UnityUtils.SetLocalEulerAngles(self.SortArrow_rect, 0, 0, 0)
    end
end

function WeaponUpgradePanel:RefreshItemList()
    self.LevelSlider_recyceList:ResetList()
    local weaponData =  self:GetWeaponData()
    local limitLev = RoleConfig.GetStageConfig(weaponData.template_id,weaponData.stage).level_limit
    self.LevelSlider_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.LevelSlider_recyceList:SetCellNum(limitLev - weaponData.lev + 1)
    self.LevelSlider_recyceList.onValueChanged:AddListener(self:ToFunc("OnValueChanged_List"))
end

function WeaponUpgradePanel:RefreshItemCell(index, go)
    if not go then
        return
    end
    local tmp = UtilsUI.GetText(go.transform:Find("Level_").gameObject)
    tmp.text = self:GetWeaponData().lev + index -1
end

function WeaponUpgradePanel:UpdateTextStyle()
    local content = self.LevelSlider.transform:Find("Viewport/Content")
    local targetLevel
    if content then
        for i = 0, content.childCount - 1 do
            local cell = content:GetChild(i)
            if cell then
                local itemObj = UtilsUI.GetContainerObject(cell:GetChild(0))
                if math.abs(cell.anchoredPosition.y + content.anchoredPosition.y) < 45 then
                    itemObj.Level_txt.fontSize = 110
                    targetLevel = tonumber(itemObj.Level_txt.text) 
                    itemObj.Level_txt.color = self.color1
                else
                    itemObj.Level_txt.fontSize = 86
                    itemObj.Level_txt.color = self.color2
                end
            end
        end
    end
    return targetLevel
end

function WeaponUpgradePanel:CalculateExp(targetLevel)
    local weaponData = self:GetWeaponData()
    local weaponId = weaponData.template_id
    local limitLev = RoleConfig.GetStageConfig(weaponId,weaponData.stage).level_limit
    targetLevel = self:UpdateTextStyle() or targetLevel
    self.targetLev = targetLevel

    local resrult, selectList, optimumExp, realityLev, selectExp = self:ToTargetLevel(targetLevel)
    self:SetMoneyCost(0)
    --等于当前等级或者超过最大等级
    if not resrult then
        self.needGold, self.allCount, self.selectExp = 0,0,0
        self.notSelect = false
        if weaponData.lev == targetLevel then
            local maxExp = RoleConfig.GetWeaponLevelExp(weaponId, weaponData.lev + 1)
            UnityUtils.SetLocalScale(self.ExploreValue_rect, weaponData.exp / maxExp, 1, 1)
            self:UpdateShowItem()
        else
            UnityUtils.SetLocalScale(self.ExploreValue_rect, 0, 1, 1)
            self:LackItemShow()
        end
        return
    end

    self.notSelect = realityLev >= limitLev
    self.needGold, self.allCount = self:AnalyseSelectData(selectList)
    self:SetMoneyCost(self.needGold)

    if limitLev <= realityLev then
        UnityUtils.SetLocalScale(self.ExploreValue_rect, 0, 1, 1)
    else
        local needExp = RoleConfig.GetWeaponLevelExp(weaponId, realityLev + 1)
        UnityUtils.SetLocalScale(self.ExploreValue_rect, optimumExp / needExp, 1, 1)
    end

    if limitLev < realityLev then
        realityLev = limitLev
    end
    if targetLevel ~= realityLev then
        self:jumpToIndex(realityLev, limitLev)
    end

    self.targetLev = realityLev
    self.selectExp = selectExp
    self:UpdateShowItem()
end

function WeaponUpgradePanel:jumpToIndex(targetLevel, limitLev)
    local curLev = self:GetWeaponData().lev
    local targetIndex = targetLevel - curLev + 1
    local cellIndex = 2
    if targetLevel - curLev  < 2 then
        cellIndex = targetLevel - curLev
    elseif limitLev - targetLevel <= 2 then
        cellIndex =  targetLevel - limitLev + 4
    end
    self.Tip:SetActive(cellIndex < 1)
    self.LevelSlider_recyceList:JumpToIndex(targetIndex, cellIndex)
    self:UpdateTextStyle()
end

function WeaponUpgradePanel:OnValueChanged_List(pos)
    self.Tip:SetActive(pos.y > 0.9)
end

function WeaponUpgradePanel:OnLevelSliderDragEnd(data)
    LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1, 0.9, function()
        if not self.active then
            return
        end
        local content = self.LevelSlider.transform:Find("Viewport/Content")
        local anchorPosition = content.anchoredPosition
        local posY = anchorPosition.y / 90
        local index = posY - math.floor(posY) >= 0.5 and math.ceil(posY) or math.floor(posY)
        local targetPosY = index * 90
        local offset = posY - math.floor(posY) >= 0.5 and 0.05 or -0.05
        content:DOLocalMoveY(targetPosY + offset + 45, 0.1, true)

        LuaTimerManager.Instance:RemoveTimer(self.setNotCalculatingTimer)
        self.setNotCalculatingTimer = LuaTimerManager.Instance:AddTimer(1, 0.2, function()
            if not self.active then
                return
            end
            self:CalculateExp()
        end)
    end)
end

--无法达到目标等级时的选择
function WeaponUpgradePanel:LackItemShow()
    self:ShowAttrChange()
    self.commonItems = self.commonItems or {}
    local showCount = 0
    for i = self.autoSeleteQuality, 1, -1 do
        showCount = showCount + 1
        local itemInfo =
        {
            template_id = RoleConfig.WeaponUpgradeItems[i],
            count = mod.BagCtrl:GetItemCountById(RoleConfig.WeaponUpgradeItems[i]),
            btnFunc = self:ToFunc("OpenSelectPanel"),
            lack = true
        }
        if not self.commonItems[showCount] then
            self.commonItems[showCount] = CommonItem.New()
            self.commonItems[showCount]:InitItem(self["ItemObj"..showCount], nil, true)
        end
        UtilsUI.SetActive(self["ItemObj"..i], true)
        self.commonItems[showCount]:SetItem(itemInfo)
        self.commonItems[showCount]:Show()
    end
    for i = self.autoSeleteQuality + 1, 3, 1 do
        UtilsUI.SetActive(self["ItemObj"..i], false)
    end
    self.AddButton:SetActive(false)
    self.MoreButton:SetActive(false)
end
--显示前3个道具
function WeaponUpgradePanel:UpdateShowItem()
    self:ShowAttrChange()
    local itemList = {}
    local weaponList = {}
    for type, list in pairs(self.autoSelectList) do
        for key, value in pairs(list) do
            if type == BagEnum.BagType.Item then
                table.insert(itemList, {id = key, count = value})
            elseif type == BagEnum.BagType.Weapon then
                table.insert(weaponList, {id = key, count = value})
            end
        end
    end
    table.sort(itemList, function (a, b)
        return ItemConfig.GetItemConfig(a.id).quality > ItemConfig.GetItemConfig(b.id).quality
    end)

    table.sort(weaponList, function (a, b)
        local aConfig = ItemConfig.GetItemConfig(mod.BagCtrl:GetWeaponData(a.id).template_id)
        local bConfig = ItemConfig.GetItemConfig(mod.BagCtrl:GetWeaponData(b.id).template_id)
        if mod.BagCtrl:GetWeaponData(a.id).lev ~= mod.BagCtrl:GetWeaponData(b.id).lev then
            return mod.BagCtrl:GetWeaponData(a.id).lev > mod.BagCtrl:GetWeaponData(b.id).lev
        end
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality > bConfig.quality
        end
        if aConfig.type ~= bConfig.type then
            return aConfig.type > bConfig.type
        end
        return aConfig.order_id > aConfig.order_id
    end)

    local showCount = 0
    self.commonItems = self.commonItems or {}
    for index, value in ipairs(itemList) do
        if showCount == 3 then
           break
        end
        showCount = showCount + 1
        local itemInfo = {template_id = value.id, count = value.count, scale = 0.8, btnFunc = self:ToFunc("OpenSelectPanel")}
        --local item = ItemManager.Instance:GetItem(self.CostList_rect, itemInfo, true)
        if not self.commonItems[showCount] then
            self.commonItems[showCount] = CommonItem.New()
            self.commonItems[showCount]:InitItem(self["ItemObj"..showCount], nil, true)
        end
        UtilsUI.SetActive(self["ItemObj"..showCount], true)
        self.commonItems[showCount]:SetItem(itemInfo)
        self.commonItems[showCount]:Show()
    end

    for index, value in ipairs(weaponList) do
        if showCount == 3 then
            break
        end
        showCount = showCount + 1
        local itemInfo = mod.BagCtrl:GetWeaponData(value.id)
        local copyInfo = UtilsBase.copytab(itemInfo)
        copyInfo.scale = 0.8
        copyInfo.btnFunc = self:ToFunc("OpenSelectPanel")
        --local item = ItemManager.Instance:GetItem(self.CostList_rect, copyInfo, true)
        if not self.commonItems[showCount] then
            self.commonItems[showCount] = CommonItem.New()
            self.commonItems[showCount]:InitItem(self["ItemObj"..showCount], nil, true)
        end
        UtilsUI.SetActive(self["ItemObj"..showCount], true)
        self.commonItems[showCount]:SetItem(copyInfo)
        self.commonItems[showCount]:Show()
    end

    for i = showCount + 1, 3, 1 do
        UtilsUI.SetActive(self["ItemObj"..i], false)
    end
    UtilsUI.SetActive(self.AddButton, showCount ~= 3)
    if self.allCount and self.allCount > 0 then
        self.MoreButton:SetActive(true)
        self.CountText_txt.text = self.allCount
    else
        self.MoreButton:SetActive(false)
    end
end
--预览属性变化
function WeaponUpgradePanel:ShowAttrChange()
    local targetLev = self.targetLev
    local weaponData = self:GetWeaponData()
    self.AttrChanged:SetActive(targetLev ~= weaponData.lev)
    if targetLev == weaponData.lev then
        return
    end
    for i = #self.attrList, 1, -1 do
        local attr = table.remove(self.attrList)
        self:CacheAttrObj(attr)
    end
    local oldAttrTable = RoleConfig.GetWeaponBaseAttrs(weaponData.template_id, weaponData.lev, weaponData.stage)
    local newAttrTable = RoleConfig.GetWeaponBaseAttrs(weaponData.template_id, targetLev, weaponData.stage)
    local count = 0
    for index, value in pairs(newAttrTable) do
        count = count + 1
        local attr, node = self:GetAttrObj()
        node.AttrText_txt.text = RoleConfig.GetAttrConfig(index).name
        local oldValue = oldAttrTable[index] or value
        if RoleConfig.GetAttrConfig(index).value_type == FightEnum.AttrValueType.Percent then
            value = value / 100 .. "%"
            oldValue = oldValue / 100 .."%"
        end
        node.OldValue_txt.text = oldValue
        node.NewValue_txt.text = value
        node.arrow2:SetActive(false)
        node.BG:SetActive(false)
        table.insert(self.attrList, attr)
    end
end

function WeaponUpgradePanel:GetAttrObj()
    local attr
    if next(self.cacheMap) then
        attr = table.remove(self.cacheMap)
    else
        attr = {}
		local obj = self:PopUITmpObject("AttrObject")
        attr.tf = obj.objectTransform
        attr.node = UtilsUI.GetContainerObject(attr.tf)
    end
    attr.tf:SetParent(self.AttrRoot_rect)
    UnityUtils.SetLocalScale(attr.tf, 1, 1, 1)
    return attr, attr.node
end

function WeaponUpgradePanel:CacheAttrObj(attr)
    attr.tf:SetParent(self.Cache_rect)
    local node = attr.node
    node.NewValue:SetActive(true)
    node.arrow1:SetActive(true)
    node.arrow2:SetActive(true)
    table.insert(self.cacheMap, attr)
end

--设置自动选择模式
function WeaponUpgradePanel:SetAutoSelect(Index)
   self:ChangeAutoSelect(ButtonToSelect[Index])
   self:OpenSort()
end

function WeaponUpgradePanel:ChangeAutoSelect(type, isInit)
    if not type then
        --TODO
        self.autoSeleteQuality = self.autoSeleteQuality or AutoSelectQuality.Blue
	else
		self.autoSeleteQuality = type
    end
    PlayerPrefs.SetInt("WeaponUpgrade_AutoSeleteQuality", self.autoSeleteQuality)
    for i = 1, 3, 1 do
        if self.autoSeleteQuality == i then
            UtilsUI.SetTextColor(self["SortCase"..i.."_txt"],curSelectColor)
            self.CurSortName_txt.text = self["SortCase"..i.."_txt"].text
        else
            self["SortCase"..i.."_txt"].color = Color.white
        end
        self["Selecticon" ..i]:SetActive(self.autoSeleteQuality == i)
    end
    self:GetMaxLev()
    if not isInit then
        self:CalculateExp(self.targetLev)
    end
end

function WeaponUpgradePanel:OpenSelectPanel()
    local config ={
        width = 687,
        col = 5,
        bagType = BagEnum.BagType.Weapon,
        additionItem = RoleConfig.WeaponUpgradeItems,
        selectList = self.autoSelectList,
        quality = 4,
        upgradeWeapon = self:GetWeaponData().unique_id,
        selectMode = 2,
        pauseSelect = self.notSelect,
        pauseSelectFunc = function ()
            MsgBoxManager.Instance:ShowTips(TI18N("已达最大经验，无法添加"))
        end,
        onClick = self:ToFunc("AddSelectItem"),
        reduceFunc = self:ToFunc("ReduceSelectItem"),
    }
    self.parentWindow:OpenPanel(ItemSelectPanel,{config = config})
end
--#endregion

--#region 数据管理
function WeaponUpgradePanel:UpdateItem()
    self.itemList = mod.BagCtrl:SortBag(nil, self.sortType, self.isAscending, BagEnum.BagType.Weapon) or {}
	self:BulidAbstractList()
end

--构建抽象物品列表
function WeaponUpgradePanel:BulidAbstractList()
    self.abstractList = {}
    local abstractWeapon = {}
    for index, value in ipairs(self.itemList) do
        if ItemConfig.GetItemType(value.template_id) == BagEnum.BagType.Weapon then
            local quality = ItemConfig.GetItemConfig(value.template_id).quality
            if value.lev == 1 and quality <= 3 and value.hero_id == 0 and not value.is_locked then
                if not abstractWeapon[quality] then
					local config = RoleConfig.GetWeaponQualityConfig(value.template_id)
                    abstractWeapon[quality] = {
                        type = AbstractItem.Weapon,
                        quality = quality,
                        exp = config.add_exp,
                        gold = config.need_gold,
                        maxCount = 0
                    }
                end
                abstractWeapon[quality].maxCount = abstractWeapon[quality].maxCount + 1
            end
        end
    end
    local otherItem = RoleConfig.WeaponUpgradeItems
    for i = 1, #otherItem, 1 do
        local items = mod.BagCtrl:GetItemInBag(otherItem[i])
        if items and next(items) then
            local config = ItemConfig.GetItemConfig(otherItem[i])
            local info = {
                type = AbstractItem.Item,
                template_id = otherItem[i],
                quality = config.quality,
                exp = config.property1,
                gold = config.property2,
                maxCount = 0
            }
            for key, value in pairs(items) do
                info.maxCount = info.maxCount + value.count
            end
            table.insert(self.abstractList, info)
        end
    end

    for index, value in pairs(abstractWeapon) do
        table.insert(self.abstractList, value)
    end
end

--#endregion

--#region 计算到达目标经验的最优情况
function WeaponUpgradePanel:ToTargetLevel(targetLev)
    local weaponData = self:GetWeaponData()
    local weaponId = weaponData.template_id
    self.autoSelectList = {}

    if weaponData.lev >= targetLev then
        return false
    end
    if self:GetMaxLev() < targetLev then
        return false
    end

    local needExp = 0
    for i = weaponData.lev + 1, targetLev, 1 do
        if i == weaponData.lev + 1 then
            needExp = RoleConfig.GetWeaponLevelExp(weaponId, i) - weaponData.exp
        else
            needExp = needExp + RoleConfig.GetWeaponLevelExp(weaponId, i)
        end
    end

    local maxExp = 0
    for index, value in ipairs(self.abstractList) do
        maxExp = value.exp * value.maxCount + maxExp
    end
    if maxExp < needExp then
        return
    end

    --还需要多少经验值
    --历史最少溢出经验
    --历史最佳选择
    --当前的选择情况
    table.sort(self.abstractList, function (a, b)
        return a.exp > b.exp
    end)

    local tempTable = {needExp = needExp, optimumExp = -1, optimumList = nil, curList = {}}
    self:AutoComputeSelete(tempTable)

    --计算溢出经验影响
    local optimumExp,lev = tempTable.optimumExp, targetLev
    while RoleConfig.GetWeaponLevelExp(weaponId, lev + 1) 
	and optimumExp >= RoleConfig.GetWeaponLevelExp(weaponId, lev + 1)
    and lev + 1 <= RoleConfig.GetStageConfig(weaponId, weaponData.stage).level_limit do
        optimumExp = optimumExp - RoleConfig.GetWeaponLevelExp(weaponId, lev + 1)
        lev = lev + 1
    end

    --最佳选择情况，溢出的经验，实际到达的等级， 总共获得的经验
    return true, tempTable.optimumList, optimumExp, lev, optimumExp + needExp
end

--贪心最优，得到最小溢出情况
function WeaponUpgradePanel:AutoComputeSelete(result)
    for index, value in ipairs(self.abstractList) do
        self:AutoSelete(index, result)
    end
    for key, value in pairs(result.optimumList) do
        if value.count == 0 then
            result.optimumList[key] = nil
        end
    end
end
--是否将物品加入选择结构
function WeaponUpgradePanel:AutoSelete(index, result)
    local data = self.abstractList[index]
    if self.autoSeleteQuality < data.quality then
        return
    end
    if not result.curList[index] then
        result.curList[index] = {
            type = data.type,
            template_id = data.template_id,
            quality = data.quality,
            count = 0
        }
    end

    local curList = result.curList[index]

    if curList and curList.count >= data.maxCount then
        return false
    end
    local needCount, overflowCount = math.modf(result.needExp / data.exp)
    if math.ceil(needCount + overflowCount) <= data.maxCount - curList.count then
        local overflowExp = 0
        if overflowCount > 0 then
            overflowExp = data.exp - result.needExp + needCount * data.exp
        end
        --记录历史选择
        if result.optimumExp < 0 or overflowExp < result.optimumExp then
            local list = UtilsBase.copytab(result.curList) or {}
            list[index].count = list[index].count + math.ceil(needCount + overflowCount)
            result.optimumExp = overflowExp
            result.optimumList = list
        end
    end

    if needCount > data.maxCount - curList.count then
        needCount = data.maxCount - curList.count
    end

    curList.count = curList.count + needCount
    result.needExp = result.needExp - needCount * data.exp

end

--将自动选择的数据还原成实际的道具和物品,参数是模拟的选择情况
function WeaponUpgradePanel:AnalyseSelectData(data)
    --记录需要选择的总数以及，每种品质选择的数量
    local dataList = {curCount = 0,allCount = 0, needGold = 0}-- quality, count
    --local weaponList = {}
    for key, value in pairs(data) do
        if value.type == AbstractItem.Item then
            dataList[value.template_id] = {count = 0, maxCount = value.count}
        elseif value.type == AbstractItem.Weapon then
            dataList[value.quality] = {count = 0, maxCount = value.count}
        end
		dataList.allCount = dataList.allCount + value.count
    end

    for index, value in pairs(data) do
		if value.type == BagEnum.BagType.Item then
			self:AutoSelectItem(index, dataList, data)
		end
    end

    for index, value in ipairs(self.itemList) do
        self:AutoSelectWeapon(index, dataList)
        if dataList.curCount >= dataList.allCount then
            break
        end
    end
    return dataList.needGold, dataList.allCount
end

--判断武器是否加入自动选择列表
function WeaponUpgradePanel:AutoSelectWeapon(index, dataList)
    local data = self.itemList[index]
    local quality = ItemConfig.GetItemConfig(data.template_id).quality
    if not dataList[quality] or dataList[quality].count >= dataList[quality].maxCount then
        return
    end
    --这里不需要考虑品质选择范围问题
    if  data.lev == 1 and quality <= 3 and data.hero_id == 0 and not data.is_locked then
        if not self.autoSelectList[BagEnum.BagType.Weapon] then
            self.autoSelectList[BagEnum.BagType.Weapon] = {}
        end
        self.autoSelectList[BagEnum.BagType.Weapon][data.unique_id] = 1
        dataList[quality].count = dataList[quality].count + 1
        dataList.curCount = dataList.curCount + 1
        dataList.needGold = RoleConfig.GetWeaponQualityConfig(data.template_id).need_gold + dataList.needGold
    end
end

--还原物品选择数据
function WeaponUpgradePanel:AutoSelectItem(index, dataList, list)
    local data = list[index]
    if not self.autoSelectList[BagEnum.BagType.Item] then
        self.autoSelectList[BagEnum.BagType.Item] = {}
    end
    self.autoSelectList[BagEnum.BagType.Item][data.template_id] = dataList[data.template_id].maxCount
    dataList[data.template_id].count = dataList[data.template_id].maxCount
    dataList.curCount = dataList.curCount + dataList[data.template_id].maxCount
    dataList.needGold = dataList.needGold + ItemConfig.GetItemConfig(data.template_id).property2 * dataList[data.template_id].maxCount
end

--#endregion

--#region 其他需求计算

function WeaponUpgradePanel:GetMaxLev()
    --self.autoSeleteQuality
    local weaponData = self:GetWeaponData()
    local weaponId = weaponData.template_id
    local limitLev = RoleConfig.GetStageConfig(weaponData.template_id, weaponData.stage).level_limit
    
    --计算自动选择的最大经验值
    local exp = 0
    for key, value in pairs(self.abstractList) do
        if value.quality <= self.autoSeleteQuality then
            exp = exp + value.exp * value.maxCount
        end
    end
    local maxLev = limitLev
    for i = weaponData.lev + 1, limitLev, 1 do
        if i == weaponData.lev + 1 then
            exp = exp - (RoleConfig.GetWeaponLevelExp(weaponId, i) - weaponData.exp)
        else
            exp = exp - RoleConfig.GetWeaponLevelExp(weaponId, i)
        end
        if exp < 0 then
            maxLev = i - 1
			break
        end
    end
    if maxLev > limitLev then
        maxLev = limitLev
    end
    self.MaxLevelText_txt.text = maxLev
    return maxLev
end
--#endregion

function WeaponUpgradePanel:RemoveSelect()
    --self.selectList = {}
    self.autoSelectList = {}
    --self.abstractList = {}
end

--手动选择物品
function WeaponUpgradePanel:AddSelectItem(uniqueId, itemId, type)
    if not self.autoSelectList[type] then
        self.autoSelectList[type] = {}
    end
    local exp, gold = 0, 0
    if type == BagEnum.BagType.Item then
        self.autoSelectList[type][itemId] = self.autoSelectList[type][itemId] or 0
        self.autoSelectList[type][itemId] = self.autoSelectList[type][itemId] + 1
        local itemConfig = ItemConfig.GetItemConfig(itemId)
        exp = itemConfig.property1
        gold = itemConfig.property2
    elseif type == BagEnum.BagType.Weapon then
        self.autoSelectList[type][uniqueId] = 1
        exp, gold = self:GetWeaponExp(uniqueId)
    end
    self.allCount = self.allCount or 0
    self.allCount = self.allCount + 1

    --判断是否可以继续添加
    self:SelectChange(exp, gold, true)
end
--手动移除物品
function WeaponUpgradePanel:ReduceSelectItem(uniqueId, itemId, type)
    if not self.autoSelectList[type] then
        return
    end
    local exp, gold = 0, 0
    if type == BagEnum.BagType.Item then
        self.autoSelectList[type][itemId] = self.autoSelectList[type][itemId] - 1
        if self.autoSelectList[type][itemId] == 0 then
            self.autoSelectList[type][itemId] = nil
        end
		local itemConfig = ItemConfig.GetItemConfig(itemId)
		exp = itemConfig.property1
		gold = itemConfig.property2
    elseif type == BagEnum.BagType.Weapon then
        self.autoSelectList[type][uniqueId] = nil
        exp, gold = self:GetWeaponExp(uniqueId)
    end

    self.allCount = self.allCount or 0
    self.allCount = self.allCount - 1

    --判断是否可以继续添加
    self:SelectChange(exp, gold)
end
--手动操作后数据修改
function WeaponUpgradePanel:SelectChange(exp, gold, isAdd)
    -- self.curLevel
    -- self.selectExp
    self.selectExp = self.selectExp or 0
    self.needGold = self.needGold or 0
    if isAdd then
        self.selectExp = self.selectExp + exp
        self.needGold = self.needGold + gold
    else
        self.selectExp = self.selectExp - exp
        self.needGold = self.needGold - gold
    end
    self:SetMoneyCost(self.needGold)
    local weaponData = self:GetWeaponData()
    local weaponId = weaponData.template_id

    local tempExp = self.selectExp or 0
    local startLev = weaponData.lev
    local limitLev = RoleConfig.GetStageConfig(weaponId, weaponData.stage).level_limit

    local overflow = 0
    local maxExp = 0
    local level = 0

    for i = startLev + 1, limitLev, 1 do
        if i == startLev + 1 then
            if RoleConfig.GetWeaponLevelExp(weaponId,i) - weaponData.exp > tempExp then
                overflow = weaponData.exp + tempExp
                maxExp = RoleConfig.GetWeaponLevelExp(weaponId,i)
                level = i - 1
                break
            end
            tempExp = tempExp - (RoleConfig.GetWeaponLevelExp(weaponId,i) - weaponData.exp)
        else
            if RoleConfig.GetWeaponLevelExp(weaponId,i) > tempExp then
                overflow = tempExp
                maxExp = RoleConfig.GetWeaponLevelExp(weaponId,i)
                level = i - 1
                break
            end
            tempExp = tempExp - RoleConfig.GetWeaponLevelExp(weaponId,i)
        end
		overflow = tempExp
		level = i
    end
    self:jumpToIndex(level, limitLev)
	if level == limitLev then
		UnityUtils.SetLocalScale(self.ExploreValue_rect, 0, 1, 1)
	else
		UnityUtils.SetLocalScale(self.ExploreValue_rect, overflow / maxExp, 1, 1)
	end
    
    if level >= limitLev then
        self.notSelect = true
    end
    if self.parentWindow:GetPanel(ItemSelectPanel) then
        self.parentWindow:GetPanel(ItemSelectPanel):PauseSelect(level == limitLev)
    end
    self.targetLev = level
    self:UpdateShowItem()
end

function WeaponUpgradePanel:SetMoneyCost(needGold)
    local curGold = mod.BagCtrl:GetGoldCount()
    if curGold < needGold then
        self.MoneyCostText_txt.text = string.format("<color=#ff0000>%s</color>/<color=#eb6f00>%s</color>", curGold, needGold)
    else
        self.MoneyCostText_txt.text = string.format("%s/<color=#eb6f00>%s</color>", curGold, needGold)
    end
end

--获取武器能提供多少经验值
function WeaponUpgradePanel:GetWeaponExp(uniqueId)
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId)
    local weaponId = weaponData.template_id
    local exp = 0
    local gold = 0
    if RoleConfig.GetWeaponQualityConfig(weaponId) then
        gold = RoleConfig.GetWeaponQualityConfig(weaponId).need_gold
    end

    if weaponData.lev > 1 then
        for i = 1, weaponData.lev, 1 do
            exp = exp + RoleConfig.GetWeaponLevelExp(weaponId,i)
        end
        exp = math.floor(exp * 0.8)
        
    end
    if RoleConfig.GetWeaponQualityConfig(weaponId) then
        exp = exp + RoleConfig.GetWeaponQualityConfig(weaponId).add_exp
    end
    return exp, gold
end

--最大等级
function WeaponUpgradePanel:OnClick_MaxLev()
    self.parentWindow:ClosePanel(ItemSelectPanel)
    local maxLev = self:GetMaxLev()
    local weaponData = self:GetWeaponData()
    local limitLev = RoleConfig.GetStageConfig(weaponData.template_id, weaponData.stage).level_limit
    self:jumpToIndex(maxLev, limitLev)
    self:CalculateExp(maxLev)
end

--重置
function WeaponUpgradePanel:OnClick_Reset()
    self.parentWindow:ClosePanel(ItemSelectPanel)
    local weaponData = self:GetWeaponData()
    local limitLev = RoleConfig.GetStageConfig(weaponData.template_id, weaponData.stage).level_limit
    self:jumpToIndex(weaponData.lev, limitLev)
    self:CalculateExp()
    self.needGold = 0
    self.selectExp = 0
    self.allCount = 0
    self.notSelect = false
end

--升级
function WeaponUpgradePanel:OnClick_Upgrade()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end

    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end

    if not next(self.autoSelectList) then
        MsgBoxManager.Instance:ShowTips(TI18N("请选择道具或滑动等级列表"))
        return
    end
    if self.needGold > mod.BagCtrl:GetGoldCount() or self.targetLev > self:GetMaxLev() then
        MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
        return
    end

    if self.lockOnClick then
        return
    end
    self.lockOnClick = true

    self.parentWindow:ClosePanel(ItemSelectPanel)
    local weapon_id = self:GetWeaponData().unique_id
    local weapon_id_list = {}
    local item_list = {}
    for type, list in pairs(self.autoSelectList) do
        if type == BagEnum.BagType.Weapon then
            for key, value in pairs(list) do
                table.insert(weapon_id_list, key)
            end
        elseif type == BagEnum.BagType.Item then
            for key, value in pairs(list) do
                table.insert(item_list, {key = key, value = value})
            end
        end
    end
    mod.RoleCtrl:WeaponUpgrade(weapon_id, weapon_id_list, item_list)
end

function WeaponUpgradePanel:WeaponUpgradeComplete()
    self.lockOnClick = false
end

function WeaponUpgradePanel:GetWeaponData()
    return self.parentWindow:GetWeaponData()
end
