AlchemyMainWindow = BaseClass("AlchemyMainWindow", BaseWindow)

function AlchemyMainWindow:__init()
    self:SetAsset("Prefabs/UI/Alchemy/AlchemyMainWindow.prefab")
    self.formulaObjList = {}
end

function AlchemyMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.AlchemyRefreshHistory, self:ToFunc("OnRefreshAlchemyHistory"))
    EventMgr.Instance:AddListener(EventName.GetAlchemyAward, self:ToFunc("OnRefreshAlchemyHistory"))
end

function AlchemyMainWindow:__BindListener()
    --self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClick_ClosePanel"))

    self.TeachBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenTeachPanel"))
    self.Smelte_btn.onClick:AddListener(self:ToFunc("OnClick_Smelte"))
    self.Upgraded_btn.onClick:AddListener(self:ToFunc("OnClick_Upgraded"))
end

function AlchemyMainWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AlchemyMainWindow:__Show()
    self.teachId = AlchemyConfig.GetAlchemyTeachId()
    self.nowState = AlchemyConfig.AlchemyState.smelt
    self.nowSelect = {item = nil, nowIndex = 1, formulaInfo = nil}
    self:InitFormulaInfo()
end

function AlchemyMainWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.AlchemyRefreshHistory, self:ToFunc("OnRefreshAlchemyHistory"))
    EventMgr.Instance:RemoveListener(EventName.GetAlchemyAward, self:ToFunc("OnRefreshAlchemyHistory"))
    if self.blurBack then
        self.blurBack:Destroy()
    end

    for k, v in pairs(self.formulaObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end
end

function AlchemyMainWindow:__Hide()

end

function AlchemyMainWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({self:ToFunc("BlurBackCallBack")})
end

function AlchemyMainWindow:BlurBackCallBack()
    self:RefreshScroll()
    self:OnSelectItem(self.formulaObjList[1].awardObj, self.formulaObjList[1].containerItem, self.formulaInfo[1], self.formulaObjList[1].awardItem, 1) 
end

function AlchemyMainWindow:InitFormulaInfo()
    self.formulaIdList = mod.AlchemyCtrl:GetFormulaIdList()
    self:UpdateFormulaInfo()
    -- i  材料足够>材料不足
    -- ii 高品质 < 低品质
    -- iii 根据排序ID排序
    local sortFunc = function(a, b)
        if a.is_enough and not b.is_enough then
            return true
        elseif not a.is_enough and b.is_enough then
            return false
        else
            if a.quality < b.quality then
                return true
            elseif a.quality > b.quality then
                return false
            else
                return a.order > b.order
            end
        end
    end
    table.sort(self.formulaInfo, sortFunc)
end

function AlchemyMainWindow:UpdateFormulaInfo()
    self.formulaInfo = {}
    for id, v in pairs(self.formulaIdList) do
        local isEnough = mod.AlchemyCtrl:CheckMateriaEnoughByFormulaId(id)
        local formulaCfg = AlchemyConfig.GetAlchemyFormulaById(id)
        local itemInfo = ItemConfig.GetItemConfig(formulaCfg.show_id)
        table.insert(self.formulaInfo, 
        {
            formula_id = id, 
            is_enough = isEnough, 
            show_id = formulaCfg.show_id,
            left_item = formulaCfg.left_item,
            right_item = formulaCfg.right_item,
            quality = itemInfo.quality,
            order = formulaCfg.order,
        })
    end
end

function AlchemyMainWindow:OnClick_OpenTeachPanel()
    if not self.teachId then
        return
    end
    BehaviorFunctions.ShowGuideImageTips(self.teachId)
end

function AlchemyMainWindow:OnClick_ClosePanel()
    WindowManager.Instance:CloseWindow(AlchemyMainWindow)
end

function AlchemyMainWindow:OnClick_Upgraded()
    if self.nowState == AlchemyConfig.AlchemyState.upgrade then
        return
    end
    MsgBoxManager.Instance:ShowTips("敬请期待")
    -- self.nowState = AlchemyConfig.AlchemyState.upgrade
    -- self:SetLeftTabByState(self.nowState)
    
    -- self:ClosePanel(AlchemySmeltPanel)
    -- self.smeltPanel = nil
end

function AlchemyMainWindow:OnClick_Smelte()
    if self.nowState == AlchemyConfig.AlchemyState.smelt then
        return
    end
    self.nowState = AlchemyConfig.AlchemyState.smelt
    self:SetLeftTabByState(self.nowState)
    self.nowSelect = {item = nil, nowIndex = 1, formulaInfo = nil}
    self:RefreshScroll()
    self:OnSelectItem(self.formulaObjList[1].awardObj, self.formulaObjList[1].containerItem, self.formulaInfo[1], self.formulaObjList[1].awardItem, 1) 
end


function AlchemyMainWindow:RefreshScroll()
    local col = math.floor((self.AlchemyItemsScollList_rect.rect.width - 20) / 120)
    local row = math.ceil((self.AlchemyItemsScollList_rect.rect.height - 20) / 120)

    local AwardCount = #self.formulaInfo
    local listNum = AwardCount > (col * row) and AwardCount or (col * row)
    self.AlchemyItemsScollList_recyceList:SetLuaCallBack(self:ToFunc("RefreshCell"))
    self.AlchemyItemsScollList_recyceList:SetCellNum(listNum)
end

function AlchemyMainWindow:RefreshCell(index, go)
	if not go then
        return 
    end
    local awardItem
    local awardObj
    local containerItem
    if self.formulaObjList[index] then
        awardItem = self.formulaObjList[index].awardItem
        awardObj = self.formulaObjList[index].awardObj
        containerItem = self.formulaObjList[index].containerItem
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
		awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
		if not awardItem then
			awardItem = CommonItem.New()
		end
        -- awardItem = CommonItem.New()
        awardObj = uiContainer.CommonItem
        self.formulaObjList[index] = {}
        self.formulaObjList[index].awardItem = awardItem
        self.formulaObjList[index].awardObj = awardObj
        self.formulaObjList[index].containerItem = uiContainer
    end

    --初始化commonitemitem表现
	local awardItemInfo = {}
    local onClickFunc = function()
		self:OnSelectItem(self.formulaObjList[index].awardObj, self.formulaObjList[index].containerItem, self.formulaInfo[index], self.formulaObjList[index].awardItem, index)
	end
    if index <= #self.formulaInfo then
        awardItemInfo = ItemConfig.GetItemConfig(self.formulaInfo[index].show_id)
	    awardItemInfo.template_id = self.formulaInfo[index].show_id
        awardItem:InitItem(awardObj, awardItemInfo)
        UtilsUI.SetActive(awardItem.node.Num, true)
        awardItem.node.Num_txt.text = awardItemInfo.name
        awardItem:SetBtnEvent(false, onClickFunc)
        self:SetItemEnoughActive(index)
    else
        awardItem:InitItem(awardObj, nil)
    end

    -- 初始化按下的表现
    if self.nowSelect.item ~= nil then
        if self.nowSelect.nowIndex ~= index and self.nowSelect.item.AlchemySelectItem:GetInstanceID() == self.formulaObjList[index].containerItem.AlchemySelectItem:GetInstanceID() then
            self:SetSelectItemActive(false)
        elseif self.formulaObjList[index].containerItem == self.nowSelect.item then
            self:SetSelectItemActive(true)
        end
    end
end

function AlchemyMainWindow:SetItemEnoughActive(index)
    local item = self.formulaObjList[index].containerItem
    if self.formulaInfo[index].is_enough == false then
        UtilsUI.SetActive(item.NotEnoughMask, true)
    elseif self.formulaInfo[index].is_enough == true then
        UtilsUI.SetActive(item.NotEnoughMask, false)
    end
end

function AlchemyMainWindow:OnSelectItem(itemObj, selectItem, formulaData, selectCommonItem, index)
    if self.nowSelect.item == selectItem then
        return
    end
    self:SetSelectItemActive(false)
    self.nowSelect = {item = selectItem, nowIndex = index, formulaInfo = formulaData}
    self.nowSelectCommonItem = selectCommonItem
    self:SetSelectItemActive(true)
    if not self.smeltPanel then
        self.smeltPanel = self:OpenPanel(AlchemySmeltPanel,{ formulaInfo = formulaData})
    else
        self.smeltPanel:UpdateData(formulaData)
    end
end

function AlchemyMainWindow:SetSelectItemActive(state)
    if not self.nowSelect.item or not self.nowSelectCommonItem then
        return
    end
    UtilsUI.SetActive(self.nowSelect.item.SelectItem, state)
    UtilsUI.SetActive(self.nowSelectCommonItem.node.SelectedItemBack, state)
end

function AlchemyMainWindow:OnRefreshAlchemyHistory()
    self:UpdataFormulaState()
    if self.smeltPanel then
        self.smeltPanel:UpdateNums()
    end
end

function AlchemyMainWindow:UpdataFormulaState()
    for i, info in ipairs(self.formulaInfo) do
        local isEnough = mod.AlchemyCtrl:CheckMateriaEnoughByFormulaId(info.formula_id)
        info.is_enough = isEnough
    end

    for i, v in ipairs(self.formulaInfo) do
        self:SetItemEnoughActive(i)
    end
end

function AlchemyMainWindow:GetFormulaInfoIndex()
    if not self.nowSelect or not self.formulaInfo then
        return
    end
    for i, info in ipairs(self.formulaInfo) do
        if info.formula_id == self.nowSelect.formulaInfo.formula_id then
            return i
        end
    end
end

function AlchemyMainWindow:SetLeftTabByState(state)
    if state == AlchemyConfig.AlchemyState.smelt then
        self:SetLeftTabActive(true)
    elseif state == AlchemyConfig.AlchemyState.upgrade then
        self:SetLeftTabActive(false)
    end
end

function AlchemyMainWindow:SetLeftTabActive(state)
    UtilsUI.SetActive(self.UpgradedUnSelect, state)
    UtilsUI.SetActive(self.UpgradedSelect, not state)
    UtilsUI.SetActive(self.SmelteSelect, state)
    UtilsUI.SetActive(self.SmelteUnSelect, not state)
end
