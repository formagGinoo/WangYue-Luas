AlchemyFormulaItem = BaseClass("AlchemyFormulaItem", Module)

function AlchemyFormulaItem:__init()
    self.MateriaObjList = {}
end

function AlchemyFormulaItem:Destory()
end

-- formulaInfo = {formulaId = id, Type  = yin/yang/balance ,  left = {{key = itemid,value = count},{itemid,count}} , right = {{key = itemid,value = count},{itemid,count}}}
function AlchemyFormulaItem:InitFotmula(object, formulaInfo, count)
    self.object = object
    self.count = count or 15
    self.maxMixCount = math.huge
    self.nodes = UtilsUI.GetContainerObject(self.object.transform)
    self.solution = {}
    self.solution.left = formulaInfo.left
    self.solution.right = formulaInfo.right
    if self.materiaList then
        TableUtils.ClearTable(self.materiaList)
    else
        self.materiaList = {}
    end
    for _, v in ipairs(formulaInfo.left) do
        if v.key ~= 0 then 
            table.insert(self.materiaList,v)
        end
    end
    for _, v in ipairs(formulaInfo.right) do
        if v.key ~= 0 then 
            table.insert(self.materiaList,v)
        end
    end
    self.type = formulaInfo.type
    self.awardId = formulaInfo.targetId
    self:Show()
end

function AlchemyFormulaItem:SetSelect(isSelect)
    if self.isSelect ~= isSelect then
        self.isSelect = isSelect
        if self.isSelect then
            UtilsUI.SetActive(self.nodes.Selected,true)
            UtilsUI.SetActive(self.nodes.UnSelected,false)
        else
            UtilsUI.SetActive(self.nodes.Selected,false)
            UtilsUI.SetActive(self.nodes.UnSelected,true)
        end
    end
end

function AlchemyFormulaItem:AddEvent()
    
end

function AlchemyFormulaItem:AddClickListener()
    
end

function AlchemyFormulaItem:Show()
    self:RefreshMateriaScroll()
	self:SetTypeIcon()
    self:SetAwardItem()
end

function AlchemyFormulaItem:SetTypeIcon()
    if self.type == AlchemyConfig.FormulaType.Yin then
        UtilsUI.SetActiveByScale(self.nodes.Yin,true)
        UtilsUI.SetActiveByScale(self.nodes.Yang,false)
        UtilsUI.SetActiveByScale(self.nodes.Balance,false)
    elseif self.type == AlchemyConfig.FormulaType.Yang then
        UtilsUI.SetActiveByScale(self.nodes.Yin,false)
        UtilsUI.SetActiveByScale(self.nodes.Yang,true)
        UtilsUI.SetActiveByScale(self.nodes.Balance,false)
    elseif self.type == AlchemyConfig.FormulaType.Balance then
        UtilsUI.SetActiveByScale(self.nodes.Yin,false)
        UtilsUI.SetActiveByScale(self.nodes.Yang,false)
        UtilsUI.SetActiveByScale(self.nodes.Balance,true)
    end
    self.nodes.USelectedStateType_txt.text = AlchemyConfig.FormulaTypeText[self.type]
    self.nodes.SelectedStateType_txt.text = AlchemyConfig.FormulaTypeText[self.type]
end

function AlchemyFormulaItem:SetAwardItem()
    if not self.awardItem then 
        self.awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not self.awardItem then
            self.awardItem = CommonItem.New()
        end
    end
    local awardItemInfo = ItemConfig.GetItemConfig(self.awardId)
	awardItemInfo.template_id = self.awardId
    if not self.CommonItem then
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(self.nodes.TargetItem.transform, uiContainer)
        self.CommonItem = uiContainer.CommonItem
    end
    self.awardItem:InitItem(self.CommonItem,awardItemInfo,true)
    self:SetAwardCount()
end

function AlchemyFormulaItem:SetAwardCount()
    self.awardItem.node.Level:SetActive(true)
	self.awardItem.node.Level_txt.text = "<color=#ffb141>" .. self.count .. "</color>"
end

function AlchemyFormulaItem:RefreshMateriaScroll()
    local col = 1
    local row = math.ceil((self.nodes.MateriaScroll_rect.rect.height - 25) / 145)
    local MateriaCount = #self.materiaList

    local listNum = MateriaCount > (col * row) and MateriaCount or (col * row)
    self.nodes.MateriaScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshMateriaCell"))
    self.nodes.MateriaScroll_recyceList:SetCellNum(listNum)
    if MateriaCount <= 4 then
        self.nodes.MateriaScroll_recyceList.movementType = 2
    else
        self.nodes.MateriaScroll_recyceList.movementType = 1
    end
end

function AlchemyFormulaItem:RefreshMateriaCell(index,go)
    if not go then
        return
    end
    local materiaItem
    local materiaObj
    if self.MateriaObjList[index] then
        materiaItem = self.MateriaObjList[index].materiaItem
        materiaObj = self.MateriaObjList[index].materiaObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        materiaItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not materiaItem then
            materiaItem = CommonItem.New()
        end
        materiaObj = uiContainer.CommonItem
        self.MateriaObjList[index] = {}
        self.MateriaObjList[index].materiaItem = materiaItem
        self.MateriaObjList[index].materiaObj = materiaObj
    end
	local materiaItemInfo = ItemConfig.GetItemConfig(self.materiaList[index].key)
	materiaItemInfo.template_id = self.materiaList[index].key
    materiaItem:InitItem(materiaObj,materiaItemInfo,true)
	self:SetItemCount(materiaItem,self.materiaList[index])
end

function AlchemyFormulaItem:SetItemCount(item, materiaInfo)
    local bagCount = mod.BagCtrl:GetItemCountById(materiaInfo.key)
	item.node.Level:SetActive(true)
    if bagCount < self.count * materiaInfo.value then 
        item.node.Level_txt.text = "<color=#ff6d6d>" .. bagCount .. "</color>" .. "/" .. "<color=#ffb141>" .. self.count * materiaInfo.value .."</color>"
        self.isEnough = false
    else 
        self.isEnough = true
	    item.node.Level_txt.text = bagCount .. "/" .. "<color=#ffb141>" .. self.count * materiaInfo.value .."</color>"
    end
    self.maxMixCount = math.min(self.maxMixCount,bagCount/materiaInfo.value)
end

function AlchemyFormulaItem:CheckmateriaIsEnough()
    return self.isEnough
end


function AlchemyFormulaItem:SetCount(count)
    if self.count == count then
        return 
    end
    self.count = count 
    for i, v in ipairs(self.MateriaObjList) do
        self:SetItemCount(v.materiaItem,self.materiaList[i])
    end
    self:SetAwardCount()
end

function AlchemyFormulaItem:GetMaxMixCount()
    return math.floor(self.maxMixCount)
end

function AlchemyFormulaItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.nodes.FormulaItem_btn
	if noShowPanel and not btnFunc then
		itemBtn.enabled = false
	else
		itemBtn.enabled = true
		local onclickFunc = function()
			if btnFunc then
				btnFunc()
				if onClickRefresh then
					self:Show()
				end
				return
			end
		end
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(onclickFunc)
	end
end

function AlchemyFormulaItem:OnReset()
    TableUtils.ClearTable(self.MateriaObjList)
    self.isSelect = false
    self.awardItem = nil
    self.CommonItem = nil
end