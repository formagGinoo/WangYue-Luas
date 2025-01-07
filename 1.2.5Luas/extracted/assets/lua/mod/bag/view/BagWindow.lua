BagWindow = BaseClass("BagWindow", BaseWindow)

local MAX_DEL_VOLUME = 99
local sortTypeName = {
    [BagEnum.SortType.Quality] = { name = "品质排序" },
    [BagEnum.SortType.Lvl] = { name = "等级排序" },
}

function BagWindow:__init()
    -- 设置预设资源
    self:SetAsset("Prefabs/UI/Bag/BagWindow.prefab")
    self:SetCacheMode(UIDefine.CacheMode.hide)

    -- 初始化
    self.bagTypeObjList = {}
    self.itemObjList = {}

    -- datas
    self.forceBagType = nil
    self.curBagType = nil
    self.curBagData = nil
    self.curSelectItem = nil
    self.sourceObjList = {}
    self.sourceObjPool = {}
    self.sortTypeObjList = nil
    self.delList = {}
    self.inDelMode = false
    self.sortType = BagEnum.SortType.Quality
    self.isAscending = false

    self.firstShow = true
end

function BagWindow:__BindListener()
    self:SetHideNode("BagWindowHideNode")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("HideWindow"), self:ToFunc("ClickBack"))

    self.DelBtn_btn.onClick:AddListener(self:ToFunc("ShowDelNode"))
    self.AddBtn_btn.onClick:AddListener(self:ToFunc("AddDelNum"))
    self.MaxBtn_btn.onClick:AddListener(self:ToFunc("MaxDelNum"))
    self.MinusBtn_btn.onClick:AddListener(self:ToFunc("MinusDelNum"))
    self.DelConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpendestroyWindow"))
    self.DelBackBtn_btn.onClick:AddListener(self:ToFunc("OnClick_HideDelNode"))
    self.SortBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeAscending"))
    self.ShowSortBtn_btn.onClick:AddListener(self:ToFunc("ShowSortTypeList"))
    self.SortBackBtn_btn.onClick:AddListener(self:ToFunc("OnClick_HideSortTypeList"))
    self.Node_Lock_btn.onClick:AddListener(self:ToFunc("OnClick_ItemLock"))
    self.OperaBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OperaBtn"))

    -- 绑定节点隐藏响应
    self.DelPart_HideNode_hcb.HideAction:AddListener(self:ToFunc("HideDelNode"))
    self.SortList_HideNode_hcb.HideAction:AddListener(self:ToFunc("HideSortTypeList"))

    -- 绑定广播响应
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("ItemUpdate"))
end

function BagWindow:__Create()
    self:CreateBagTypeList()
end

function BagWindow:__delete()
    self.bagTypeObjList = {}
    self.itemObjList = {}

    self.forceBagType = nil
    self.curBagType = nil
    self.curBagData = nil
    self.curSelectItem = nil
    self.sourceObjList = {}
    self.sourceObjPool = {}
    self.delList = {}
    self.inDelMode = false

    -- TODO 测试逻辑 延迟修改Tips大小
    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end

    EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("ItemUpdate"))
end

function BagWindow:__Hide()
    -- TODO 测试逻辑 延迟修改Tips大小
    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end

    -- 隐藏选项 方便组件做下一次动效
    for k, v in pairs(self.bagTypeObjList) do
        v.object:SetActive(false)
    end

    self.firstShow = true
end

function BagWindow:__Show()
	local args = self.args or {}
	local tagId = args._jump and args._jump[1] or 1
	if tagId then
		tagId = tonumber(tagId) + 100
	end
    self.tabPanel = self:OpenPanel(CommonLeftTabPanel,{ name = "背包", name2 = "beibao", tabList = self.BagMainToggleInfo, defaultSelect = tagId})
    self:SetBottomLayer()
end

function BagWindow:HideWindow()
    WindowManager.Instance:CloseWindow(self)
end

function BagWindow:ClickBack()
    UtilsUI.SetActive(self.tabPanel.CommonLeftTab_exit, true)
end

--#region 背包切页部分

function BagWindow:CreateBagTypeList()
    self.bagTypeObjList = {}
    local bagTypeList = {}
    local priorityList = {}
    for k, v in ipairs(Config.DataItem.data_bag_tag) do
        if v.priority ~= 0 then
            table.insert(priorityList, v)
        end
    end

    local sortFunc = function (a, b)
        return a.priority >= b.priority
    end
    table.sort(priorityList, sortFunc)

    for k, v in ipairs(Config.DataItem.data_bag_tag) do
        if v.priority == 0 then
            table.insert(bagTypeList, v)
        elseif priorityList then
            for _, tag in ipairs(priorityList) do
                table.insert(bagTypeList, tag)
            end
            priorityList = nil
        end
    end
    self.BagMainToggleInfo = {}
    for k, bagTypeInfo in pairs(bagTypeList) do
        self.BagMainToggleInfo[bagTypeInfo.id] = {type = tonumber("10"..bagTypeInfo.id), icon = bagTypeInfo.icon, name = bagTypeInfo.name, callback = function(parent, isSelect)
            if isSelect then
                self:OnToggle_BagType(bagTypeInfo.id)
            end
        end}
    end
end

function BagWindow:GetBagTypeObj()
    local obj = self:PopUITmpObject("SingleType")
    obj.objectTransform:SetParent(self.BagTypeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end

function BagWindow:SetBagType()
    if self.forceBagType then
        self.curBagType = self.forceBagType
        self.forceBagType = nil
    end

    if self.curSelectItem and next(self.curSelectItem) then
        self.curSelectItem.isSelect = false
        self.curSelectItem.commonItem:SetSelected_Normal(false)
        self.curSelectItem = nil
    end

    if self.delList and next(self.delList) then
        for k, v in pairs(self.delList) do
            v.singleItem.isDel = false
            v.singleItem.delIndex = 0
            v.singleItem.commonItem:SetSelected_Red(false)
        end
        self.delList = {}
    end

    self.SortTypeName_txt.text = sortTypeName[self.sortType].name
    self:RefreshItemList()
end

function BagWindow:OnToggle_BagType(bagTypeId)
    self.curBagType = bagTypeId
    self:SetBagType()
end
--#endregion

--#region 背包列表
function BagWindow:RefreshItemList()
    self.curBagData = {}
    --TODO 武器类型为1
    local bagData
    if self.curBagType == 1 then
        bagData = mod.BagCtrl:SortBag(nil, self.sortType, self.isAscending, BagEnum.BagType.Weapon) or {}
    else
        bagData = mod.BagCtrl:SortBag(self.curBagType, self.sortType, self.isAscending) or {}
    end

    if self.ItemScroll_recyceList then
        local col = math.floor((self.ItemScroll_rect.rect.width - 16) / 122)
        local row = math.ceil((self.ItemScroll_rect.rect.height - 25) / 138)
        local bagCount = 0
        for k, v in pairs(bagData) do
            bagCount = bagCount + 1
            table.insert(self.curBagData, v)
        end

        local listNum = bagCount > (col * row) and bagCount or (col * row)
        self.ItemScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
        self.ItemScroll_recyceList:SetCellNum(listNum)

        if bagCount == 0 then
            self:UpdateTips(true)
        end
    end
end

function BagWindow:RefreshItemCell(index, go)
    if not go then
        return
    end

    local commonItem
    local itemObj
    if self.itemObjList[index] then
        commonItem = self.itemObjList[index].commonItem
        itemObj = self.itemObjList[index].itemObj
    else
        commonItem = CommonItem.New()
        itemObj = go.transform:Find("SingleItem").gameObject
        self.itemObjList[index] = {}
        self.itemObjList[index].commonItem = commonItem
        self.itemObjList[index].itemObj = itemObj
        self.itemObjList[index].isSelect = false
    end

    if self.firstShow then
        commonItem.showNode = go.transform:Find("ItemRefreshNode_").gameObject
        go.transform:Find("ItemShowNode_").gameObject:SetActive(true)
    else
        -- commonItem.showNode:SetActive(true)
    end

    commonItem:InitItem(itemObj, self.curBagData[index], true)
    --commonItem:Show()
    local onClickFunc = function()
        self:OnClick_SingleItem(self.itemObjList[index])
    end
    commonItem:SetBtnEvent(false, onClickFunc)

    if not self.curBagData[index] or not next(self.curBagData[index]) then
        return
    end

    if self.inDelMode then
        commonItem:SetSelected_Red(self.itemObjList[index].isDel)
    elseif self.curSelectItem and next(self.curSelectItem) then
        local curUniqueId = self.curSelectItem.commonItem.itemInfo.unique_id
        commonItem:SetSelected_Normal(self.curBagData[index].unique_id == curUniqueId)
    elseif not self.curSelectItem or not next(self.curSelectItem) then
        self:OnClick_SingleItem(self.itemObjList[index], self.inDelMode, true)
    end
end

function BagWindow:OnClick_SingleItem(singleItem, ingoreDelMode, ingoreEffect)
    if not singleItem.commonItem.itemInfo or not next(singleItem.commonItem.itemInfo) then
        return
    end

    if self.inDelMode and self.delList and #self.delList >= MAX_DEL_VOLUME then
        return
    end

    local isItemCanDel = singleItem.commonItem.itemConfig.can_sell and not singleItem.commonItem.itemInfo.is_locked
    if self.inDelMode and not ingoreDelMode and isItemCanDel then
        local uinqueId = singleItem.commonItem.itemInfo.unique_id
        singleItem.isDel = not singleItem.isDel
        if singleItem.isDel then
            table.insert(self.delList, { singleItem = singleItem, unique_id = uinqueId, count = 1 })
            singleItem.delIndex = #self.delList
            singleItem.commonItem:SetSelected_Red(true)
        else
            local count = 0
            for k, v in pairs(self.delList) do
                count = count + 1
                if v.unique_id == uinqueId then
                    break
                end
            end

            if count ~= 0 then
                table.remove(self.delList, count)
                singleItem.delIndex = 0
                singleItem.commonItem:SetSelected_Red(false)
            end
        end
    elseif not self.inDelMode then
        if singleItem.isSelect then
            self:UpdateTips()
            return
        end

        if self.curSelectItem and next(self.curSelectItem) then
            self.curSelectItem.isSelect = false
            self.curSelectItem.commonItem:SetSelected_Normal(false)
        end

		singleItem.isSelect = not singleItem.isSelect
    end

    singleItem.commonItem:SetSelected_Normal(singleItem.isSelect and not self.inDelMode, not ingoreEffect)
    self.curSelectItem = singleItem
    self:UpdateTips()
    if self.inDelMode then
        self:UpdateDelMode()
    end
end

--#endregion

--#region 详情列表

function BagWindow:UpdateTips(forceHide)
    local hide = forceHide or (not self.curSelectItem or not next(self.curSelectItem))
    self.Tips:SetActive(not hide)
    -- self.TipsRefreshNode:SetActive(not hide)
    self.ItemScrollList:SetActive(not hide)
    self.Empty:SetActive(hide)
    if not hide then
        self:SetTipsBaseInfo()
        self:SetTipsDetailInfo()
        self:UpdateOperaBtn()
    end
end
function BagWindow:__TempShow()
    self.tabPanel:ReSelectType()
end

function BagWindow:SetTipsBaseInfo()
    local itemConfig = self.curSelectItem.commonItem.itemConfig
    local itemInfo = self.curSelectItem.commonItem.itemInfo
    local itemType = ItemConfig.GetItemType(itemInfo.template_id)

    -- 设置Quality
    local qualityData = ItemManager.GetItemColorData(itemConfig.quality)
    SingleIconLoader.Load(self.QualityLine, AssetConfig.GetQualityIcon(qualityData.front))
    SingleIconLoader.Load(self.QualityBack, AssetConfig.GetQualityIcon(qualityData.tipsFront))

    -- 设置Icon
    local path = ItemConfig.GetItemIcon(itemInfo.template_id)
    SingleIconLoader.Load(self.ItemIcon, path)

    -- 设置名字
    self.ItemName_txt.text = itemConfig.name

    -- 设置状态Icon
    self:UpdateStateIcon(itemConfig)

    -- 设置基础信息或者类别
    self.Weapon:SetActive(itemType == BagEnum.BagType.Weapon)
    self.TypeName:SetActive(itemType ~= BagEnum.BagType.Weapon)
    if itemType == BagEnum.BagType.Weapon then
        self.HaveAttr:SetActive(false)
        self.NoAttr:SetActive(false)
        SingleIconLoader.Load(self.Stage, "Textures/Icon/Single/StageIcon/" .. itemInfo.stage .. ".png")
        self.WeaponTypeName_txt.text = RoleConfig.GetWeaponTypeConfig(itemConfig.type).type_name
        self.CurLevel_txt.text = itemInfo.lev or 1
        self.MaxLevel_txt.text = RoleConfig.GetStageConfig(itemInfo.template_id, itemInfo.stage or 0).level_limit
    else
        self.HaveAttr:SetActive(false)
        self.NoAttr:SetActive(true)
        local typeConfig = ItemConfig.GetItemTypeConfig(itemConfig.type)
        self.TypeName_txt.text = typeConfig.type_name
    end
end

function BagWindow:UpdateStateIcon(itemConfig)
    
    self:UpdateYingYangIcon(itemConfig)
    self:UpdateAdditionIcon(itemConfig)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.StateIcon.transform)
end

function BagWindow:UpdateYingYangIcon(itemConfig)
    local yinyangIcon = itemConfig.yinyang_icon
    if yinyangIcon == "" or not yinyangIcon then
        if self.YingYangIcon then
            self.YingYangIcon:SetActive(false)
        end
        return
	end
	self.YingYangIcon:SetActive(true)
	SingleIconLoader.Load(self.YingYangIcon, yinyangIcon)
end

function BagWindow:UpdateAdditionIcon(itemConfig)
    local additionIcon = itemConfig.add_icon
    if additionIcon == "" or not additionIcon then
        if self.AdditionIcon then
            self.AdditionIcon:SetActive(false)
        end
        return
	end
	self.AdditionIcon:SetActive(true)
	SingleIconLoader.Load(self.AdditionIcon, additionIcon)
end

function BagWindow:SetTipsDetailInfo()
    local itemInfo = self.curSelectItem.commonItem.itemInfo
    local itemConfig = self.curSelectItem.commonItem.itemConfig
    local itemType = ItemConfig.GetItemType(itemConfig.id)
    local showLock = itemType == BagEnum.BagType.Weapon
    local showStrength = false
    -- TODO 临时处理 后续需要跟随培养系统修改
    self.Node_Grow:SetActive(showLock)
    self.Node_GrowTop:SetActive(showLock or showStrength)
    self.Node_Lock:SetActive(showLock)

    self.Unlock:SetActive(not itemInfo.is_locked)
    self.HaveLock:SetActive(itemInfo.is_locked)

    -- 武器属性
    self.Node_Attr:SetActive(itemType == BagEnum.BagType.Weapon)
    if itemType == BagEnum.BagType.Weapon then
        local attrTable = RoleConfig.GetWeaponBaseAttrs(itemInfo.template_id, itemInfo.lev or 1, itemInfo.stage or 0)
        local curCount = 0
        for key, value in pairs(attrTable) do
            curCount = curCount + 1
            if curCount > 2 then
				curCount = curCount - 1
                break
            end
            self["Attr"..curCount]:SetActive(true)
            SingleIconLoader.Load(self["AttrIcon"..curCount], RoleConfig.GetAttrConfig(key).icon)
            self["AttrName"..curCount.."_txt"].text = RoleConfig.GetAttrConfig(key).name
            if RoleConfig.GetAttrConfig(key).value_type == FightEnum.AttrValueType.Percent then
                value = value /100 .."%"
            end
            self["AttrValue"..curCount.."_txt"].text = value
        end
        for i = curCount + 1, 2, 1 do
            self["Attr"..i]:SetActive(false)
        end
    end

    -- 培养线没有出来之前暂时先只显示描述和来源
    -- 精炼信息
    if itemInfo.refine then
        self.Node_Refine:SetActive(true)
        self.RefineLvl_txt.text = itemInfo.refine
        self.RefineName_txt.text = string.format("精炼%s阶", itemInfo.refine)
    else
        self.Node_Refine:SetActive(false)
    end
    -- 显示描述
    if itemType == BagEnum.BagType.Item then
        self.Node_Desc:SetActive(itemConfig.desc ~= nil and itemConfig.desc ~= "")
        self.MainDesc_txt.text = itemConfig.desc
        --TODO 暂时没有内容
        self.SubDesc_txt.text = ""
    elseif itemType == BagEnum.BagType.Weapon then
        local refineConfig = RoleConfig.GetWeaponRefineConfig(itemInfo.template_id,itemInfo.refine or 0)
        self.Node_Desc:SetActive(true)
        if not refineConfig then
            self.MainDesc_txt.text = ""
        else
            self.MainDesc_txt.text = refineConfig.desc
        end
        self.SubDesc_txt.text = itemConfig.desc
    end
    --装备者
    if itemInfo.hero_id and itemInfo.hero_id ~= 0 then
        self.Equiped:SetActive(true)
        self.EquipedTips_txt.text = RoleConfig.GetRoleConfig(itemInfo.hero_id).name..TI18N("已装备")
        local icon = RoleConfig.GetRoleConfig(itemInfo.hero_id).rhead_icon
        SingleIconLoader.Load(self.Belong, icon)
    else
        self.Equiped:SetActive(false)
    end

    for i = #self.sourceObjList, 1, -1 do
        self.sourceObjList[i].object:SetActive(false)
        table.insert(self.sourceObjPool, table.remove(self.sourceObjList))
    end
    self.Node_Source:SetActive(itemConfig.jump_ids and next(itemConfig.jump_ids))
    if itemConfig.jump_ids and next(itemConfig.jump_ids) then
        for i = 1, #itemConfig.jump_ids do
            local sourceObj = self:GetSourceObj()

			local jumpId = itemConfig.jump_ids[i]
			local title = JumpToConfig.GetTitle(jumpId)
            sourceObj.USourceDesc_txt.text = title
            sourceObj.ASourceDesc_txt.text = title

            --#region 测试逻辑
            sourceObj.ASource:SetActive(true)
            sourceObj.USource:SetActive(false)
            --#endregion

			if JumpToConfig.HasJumpEvent(jumpId) then
	            local onclickFunc = function()
	                self:OnClick_Source(jumpId)
	            end
	            sourceObj.SingleSource_btn.onClick:RemoveAllListeners()
	            sourceObj.SingleSource_btn.onClick:AddListener(onclickFunc)
			end
            sourceObj.object:SetActive(true)

            self.sourceObjList[i] = sourceObj
        end
    end

    --#region 测试逻辑 延迟修改Tips大小
    local delayFunc = function ()
        local detailHeight = Mathf.Clamp(self.TipsDContent_rect.rect.height, 200, 320)
        UnityUtils.SetSizeDelata(self.TipsDetail.transform, self.TipsDetail_rect.rect.width, detailHeight)
    end

    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end
    self.testTimer = LuaTimerManager.Instance:AddTimer(0, 0.03, delayFunc)
    --#endregion
end

function BagWindow:GetSourceObj()
    if next(self.sourceObjPool) then
        return table.remove(self.sourceObjPool)
    end

    local sourceObj = self:PopUITmpObject("SingleSource")
    sourceObj.objectTransform:SetParent(self.Node_Source.transform)
    UtilsUI.GetContainerObject(sourceObj.objectTransform, sourceObj)
    UnityUtils.SetLocalScale(sourceObj.objectTransform, 1, 1, 1)

    return sourceObj
end

function BagWindow:OnClick_Source(jumpId)
    JumpToConfig.DoJump(jumpId)
end

function BagWindow:OnClick_ItemLock()
    local unique_id = self.curSelectItem.commonItem.itemInfo.unique_id
    local is_lock = not self.curSelectItem.commonItem.itemInfo.is_locked
    local itemType = ItemConfig.GetItemType(self.curSelectItem.commonItem.itemInfo.template_id)

    mod.BagCtrl:SetItemLockState(unique_id, is_lock, itemType)
end

--#endregion

--#region 道具操作按钮

function BagWindow:UpdateOperaBtn()
    local itemInfo = self.curSelectItem.commonItem.itemInfo
    local type = self.curSelectItem.commonItem.itemConfig.type
    if ItemConfig.GetItemType(itemInfo.template_id) == BagEnum.BagType.Item then
        local itemTypeConfig = ItemConfig.GetItemTypeConfig(type)
        local operaType = itemTypeConfig.button_type

        self.Opera:SetActive(operaType ~= BagEnum.OperaType.None)
        self.OperaText_txt.text = BagEnum.OperaDesc[operaType]
    elseif ItemConfig.GetItemType(itemInfo.template_id) == BagEnum.BagType.Weapon then
        self.Opera:SetActive(true)
        self.OperaText_txt.text = TI18N("详情")
    end
end

function BagWindow:OnClick_OperaBtn()
    local itemInfo = self.curSelectItem.commonItem.itemInfo
    local type = self.curSelectItem.commonItem.itemConfig.type
    if ItemConfig.GetItemType(itemInfo.template_id) == BagEnum.BagType.Item then
        local itemTypeConfig = ItemConfig.GetItemTypeConfig(type)
        local operaType = itemTypeConfig.button_type
    
        if operaType == BagEnum.OperaType.None then
            return
        elseif operaType == BagEnum.OperaType.Use then
			PanelManager.Instance:OpenPanel(UseCureItemPanel, self.curSelectItem.commonItem.itemInfo)
        elseif operaType == BagEnum.OperaType.Jump then
            JumpToConfig.DoJump(itemTypeConfig.jump_id)
        elseif operaType == BagEnum.OperaType.Formula then
            local itemCfg = ItemConfig.GetItemConfig(self.curSelectItem.commonItem.itemInfo.template_id)
            MsgBoxManager.Instance:ShowTips(string.format("已学习配方%s", itemCfg.name))
            mod.BagCtrl:UseItem({ unique_id = self.curSelectItem.commonItem.itemInfo.unique_id, count = 1 })
        end
    elseif ItemConfig.GetItemType(itemInfo.template_id) == BagEnum.BagType.Weapon then
        WindowManager.Instance:OpenWindow(WeaponMainWindow,{uniqueId = itemInfo.unique_id, hideView = true})
    end

end

--#endregion

--#region 删除道具

function BagWindow:ShowDelNode()
    self.inDelMode = true
    self.DelPart:SetActive(true)
    self.DelPart_ShowNode:SetActive(true)
    self:UpdateDelMode()

    if self.curSelectItem then
        self.curSelectItem.commonItem:SetSelected_Normal(false)
        self.curSelectItem.isSelect = false
        self.Node_Lock:SetActive(false)
    end

    for k, v in pairs(self.itemObjList) do
        if v.commonItem.itemConfig and v.commonItem.itemInfo then
            v.commonItem:SetIsDisable(not v.commonItem.itemConfig.can_sell or v.commonItem.itemInfo.is_locked)
        else
            break
        end
    end
end

function BagWindow:OnClick_HideDelNode()
    self.DelPart_HideNode:SetActive(true)
end

function BagWindow:HideDelNode()
    self.DelPart:SetActive(false)
    self.inDelMode = false
    self.delList = {}
    for k, v in pairs(self.itemObjList) do
        v.commonItem:SetIsDisable(false)
        if v.isDel then
            v.isDel = false
            v.delIndex = 0
            v.commonItem:SetSelected_Red(false)
        end
    end

    if self.curSelectItem and next(self.curSelectItem) then
        self.curSelectItem.commonItem:SetSelected_Normal(true, false)
		self.curSelectItem.isSelect = true
    end

    self.Node_Lock:SetActive(false)
end

function BagWindow:UpdateDelMode()
    local isHaveSelect = self.curSelectItem and next(self.curSelectItem)
    local isCurDel = isHaveSelect and self.curSelectItem.isDel and self.curSelectItem.delIndex and self.curSelectItem.delIndex ~= 0
    local isCanDel = isHaveSelect and not self.curSelectItem.commonItem.itemInfo.is_locked and self.curSelectItem.commonItem.itemConfig.can_sell
    local showDesc = not isCurDel or not isCanDel
    self.Node_DelEmpty:SetActive(showDesc)
    self.Node_DelNum:SetActive(not showDesc) 
    self.SelectedDesc_txt.text = string.format("已选  <color=#ff4c34>%s</color>/%s", #self.delList, MAX_DEL_VOLUME)
    if not showDesc then
        local index = self.curSelectItem.delIndex
        local curItemNum = self.delList[index].singleItem.commonItem.itemInfo.count
        self.SelectedNum_txt.text = self.delList[index].count
        self.AddBtn_btn.interactable = self.delList[index].count < curItemNum
        self.MinusBtn_btn.interactable = self.delList[index].count > 1
    else
        if not isCanDel then
            self.EmptyDesc_txt.text = TI18N("当前物品无法删除")
        elseif not isCurDel then
            self.EmptyDesc_txt.text = TI18N("请选择需要删除的物品")
        end 
    end
end

function BagWindow:AddDelNum(isMax)
    local index = self.curSelectItem.delIndex
    local curItemNum = self.delList[index].singleItem.commonItem.itemInfo.count
    if self.delList[index].count >= curItemNum then
        return
    end
    self.delList[index].count = self.delList[index].count + 1
    self.SelectedNum_txt.text = self.delList[index].count

    if self.delList[index].count == curItemNum then
        self.AddBtn_btn.interactable = false
    elseif self.delList[index].count > 1 then
        self.MinusBtn_btn.interactable = true
    end
end

function BagWindow:MaxDelNum()
    local index = self.curSelectItem.delIndex
    local curItemNum = self.delList[index].singleItem.commonItem.itemInfo.count
    self.delList[index].count = curItemNum
    self.AddBtn_btn.interactable = false
    self.SelectedNum_txt.text = self.delList[index].count
end

function BagWindow:MinusDelNum()
    local index = self.curSelectItem.delIndex
    if self.delList[index].count <= 1 then
        return
    end

    local curItemNum = self.delList[index].singleItem.commonItem.itemInfo.count
    self.delList[index].count = self.delList[index].count - 1
    self.SelectedNum_txt.text = self.delList[index].count

    if self.delList[index].count < curItemNum then
        self.AddBtn_btn.interactable = true
    elseif self.delList[index].count <= 1 then
        self.MinusBtn_btn.interactable = false
    end
end

function BagWindow:OnClick_OpendestroyWindow()
    if not self.delList or not next(self.delList) then
        return
    end

    self:OpenPanel(BagDestroyPanel, {itemList = self.delList}, UIDefine.CacheMode.hide)
end

function BagWindow:ConfirmDel()
    local delDatas = {}
    for k, v in pairs(self.delList) do
        table.insert(delDatas, {unique_id = v.unique_id, count = v.count})
    end

    mod.BagCtrl:RemoveItem(delDatas)
    self.delList = nil
    self.curSelectItem = nil
    self:OnClick_HideDelNode()
end

--#endregion

--#region 排序

function BagWindow:ShowSortTypeList()
    if self.SortList.gameObject.activeSelf then
        self:OnClick_HideSortTypeList()
        return
    end

    self.SortList:SetActive(true)
    self.SortList_ShowNode:SetActive(true)
    self.SortBackBtn:SetActive(true)

    if not self.sortTypeObjList or not next(self.sortTypeObjList) then
        self:CreateSortTypeList()
    else
        self:UpdateSortTypeList()
    end
end

function BagWindow:OnClick_HideSortTypeList()
    self.SortList_HideNode:SetActive(true)
end

function BagWindow:HideSortTypeList()
    self.SortList:SetActive(false)
    self.SortBackBtn:SetActive(false)
end

function BagWindow:CreateSortTypeList()
    self.sortTypeObjList = {}
    for k, v in pairs(sortTypeName) do
        local singleSortType, new = self:PopUITmpObject("SortType")
        if new then
            singleSortType.typeUNameObj = singleSortType.objectTransform:Find("SortTypeUName")
            singleSortType.typeSNameObj = singleSortType.objectTransform:Find("SortTypeSName")
            singleSortType.mark = singleSortType.objectTransform:Find("SortTypeSMark")
            singleSortType.toggle = singleSortType.objectTransform:GetComponent(Toggle)
        else

        end

        UtilsUI.GetText(singleSortType.typeSNameObj.transform).text = v.name
        UtilsUI.GetText(singleSortType.typeUNameObj.transform).text = v.name
        singleSortType.sortType = k

        local onToggleFunc = function()
            self:OnToggle_SortType(singleSortType)
        end
        singleSortType.toggle.onValueChanged:RemoveAllListeners()
        singleSortType.toggle.onValueChanged:AddListener(onToggleFunc)
        if k == self.sortType then
            if singleSortType.toggle.isOn then
                onToggleFunc()
            else
                singleSortType.toggle.isOn = true
            end
        end

        local prefabRect = singleSortType.object:GetComponent(RectTransform)
        singleSortType.rect = prefabRect
        prefabRect:SetParent(self.SortTypeList_rect)
        singleSortType.object.transform.localScale = Vector3.one
        singleSortType.object:SetActive(true)
        self.sortTypeObjList[singleSortType.sortType] = singleSortType
    end
end

function BagWindow:UpdateSortTypeList()

end

function BagWindow:OnToggle_SortType(singleSortType)
    singleSortType.typeSNameObj.gameObject:SetActive(singleSortType.toggle.isOn)
    singleSortType.mark.gameObject:SetActive(singleSortType.toggle.isOn)
    singleSortType.typeUNameObj.gameObject:SetActive(not singleSortType.toggle.isOn)

    if not singleSortType.toggle.isOn then
        return
    end

    if self.sortType ~= singleSortType.sortType then
        self.sortType = singleSortType.sortType
        self.SortTypeName_txt.text = sortTypeName[self.sortType].name

        self:RefreshItemList()
        self:OnClick_HideSortTypeList()
    end
end

function BagWindow:OnClick_ChangeAscending()
    self.isAscending = not self.isAscending
    self:RefreshItemList()
end

--#endregion

--#region 监听

function BagWindow:RegisterListener(event, view, callBack, ...)
    if not self.events[event] then
        self.events[event] = {}
    end

    if not self.events[event][view] then
        self.events[event][view] = {}
    end

    local info = { view = view, callBack = callBack, param = ... }
    table.insert(self.events[event][view], info)
end

function BagWindow:RemoveListener(event, view)
    self.events[event][view] = {}
end

function BagWindow:ItemUpdate(data)
    -- for k, v in pairs(self.events[BagWindow.Event.ItemUpdate]) do
    --     if k:IsVisible() then
    --         for m, n in pairs(v) do
    --             n.callBack(data, n.param)
    --         end
    --     end
    -- end

    if not self.active then
        return
    end

    if self.firstShow then
        self.firstShow = false
    end
    self:OnToggle_BagType(self.curBagType)
end

--#endregion

function BagWindow:SetBottomLayer()
    if not self.bottomlayer then
        self.bottomlayer = WindowManager.Instance:GetCurOrderLayer()
    end
    
    self.Bottom.transform:GetComponent(Canvas).sortingOrder = self.bottomlayer + 1
end
