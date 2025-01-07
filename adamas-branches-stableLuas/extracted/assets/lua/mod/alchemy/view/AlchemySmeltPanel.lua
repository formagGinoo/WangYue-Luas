AlchemySmeltPanel = BaseClass("AlchemySmeltPanel", BasePanel)

function AlchemySmeltPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Alchemy/AlchemySmeltPanel.prefab")
    self.parent = parent
end

function AlchemySmeltPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.AlchemySetItemNum, self:ToFunc("SetItemNum"))
    EventMgr.Instance:AddListener(EventName.AlchemyRefreshHistory, self:ToFunc("SetHistoryBtnActive"))

end

function AlchemySmeltPanel:__BindListener()
    self.MixBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MixItem"))
    self.HistoryBtn_btn.onClick:AddListener(self:ToFunc("OnClick_HistoryBtn"))
end

function AlchemySmeltPanel:__CacheObject()
    
end

function AlchemySmeltPanel:__Show()
    if not self.args or not self.args.formulaInfo then
        return
    end
    self.formulaInfo = self.args.formulaInfo
    self:SetEffectLayer()
    self:UpdateData(self.formulaInfo)
end

function AlchemySmeltPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.AlchemySetItemNum, self:ToFunc("SetItemNum"))
    EventMgr.Instance:RemoveListener(EventName.AlchemyRefreshHistory, self:ToFunc("SetHistoryBtnActive"))
end

function AlchemySmeltPanel:__Hide()

end

function AlchemySmeltPanel:__ShowComplete()
    
end

function AlchemySmeltPanel:UpdateData(data)
    self.formulaInfo = data
    self.leftNode = UtilsUI.GetContainerObject(self.ItemsLeft.transform)
    self.rightNode = UtilsUI.GetContainerObject(self.ItemsRight.transform)
    self.formulaCfg = AlchemyConfig.GetAlchemyFormulaById(self.formulaInfo.formula_id)
    self.limitNum = self.formulaCfg.limit
    self.targetItemType = AlchemyConfig.FormulaType.Defult
    self:UpdateInit()
    self:SetLeftRightItem()
    self:SetItems()
    self:UpdateNums()
    self:SetHistoryBtnActive()
    self:SetItemsEleData()
    self:SetToalNumItem()
end

-- 更新当前为0
function AlchemySmeltPanel:UpdateNums()
    for i, v in ipairs(self.alchemyItemsInfo) do
        for i, info in ipairs(v) do
            info.item:SetItemNum(0)
            info.num = 0
        end
    end
    self:SetItemsEleData()
    self:SetToalNumItem()
end

function AlchemySmeltPanel:UpdateInit()
    UtilsUI.SetActive(self.LeftTipsText, false)
    UtilsUI.SetActive(self.RightTipsText, false)
    self.nodeInfo = {}
    self.addNum ={0, 0}
    self.AllelopathyNode = {}
    self.alchemyItemsInfo = {}
    mod.AlchemyCtrl:InitLimitByFormulaId(self.formulaInfo.formula_id)
end


function AlchemySmeltPanel:SetLeftRightItem()
    self:SetAllelopathyNode()
    self.itemNum =  AlchemyConfig.GetFormulaNeedItemNumById(self.formulaCfg.id)
    for k, v in pairs(self.itemNum) do
        if v == 1 then
            if k == "left" then
                UtilsUI.SetActive(self.leftNode.Item_1, true)
                UtilsUI.SetActive(self.leftNode.Item_2, false)
                local itemNode = UtilsUI.GetContainerObject(self.leftNode.Item_1.transform)
                self.nodeInfo["left"..self.leftNode.Item_1.name] = {[1] = {[self.formulaCfg.left_item[1]] = itemNode.Item}}
            end
            if k == "right" then
                UtilsUI.SetActive(self.rightNode.Item_1, true)
                UtilsUI.SetActive(self.rightNode.Item_2, false)
                local itemNode = UtilsUI.GetContainerObject(self.rightNode.Item_1.transform)
                self.nodeInfo["right"..self.rightNode.Item_1.name] = {[1] = {[self.formulaCfg.right_item[1]] = itemNode.Item}}
            end
        elseif v == 2 then
            if k == "left" then
                UtilsUI.SetActive(self.leftNode.Item_2, true)
                UtilsUI.SetActive(self.leftNode.Item_1, false)
                local itemNode = UtilsUI.GetContainerObject(self.leftNode.Item_2.transform)
                self.nodeInfo["left"..self.leftNode.Item_2.name] = 
                {
                    [1] = {[self.formulaCfg.left_item[1]] = itemNode.Item1},
                    [2] = {[self.formulaCfg.left_item[2]] = itemNode.Item2,}
                }
            end
            if k == "right" then
                UtilsUI.SetActive(self.rightNode.Item_2, true)
                UtilsUI.SetActive(self.rightNode.Item_1, false)
                local itemNode = UtilsUI.GetContainerObject(self.rightNode.Item_2.transform)
                self.nodeInfo["right"..self.rightNode.Item_2.name] = 
                {
                    [1] = {[self.formulaCfg.right_item[1]] = itemNode.Item1},
                    [2] = {[self.formulaCfg.right_item[2]] = itemNode.Item2,}
                }
            end
        end
    end
end

function AlchemySmeltPanel:SetAllelopathyNode()
    local itemNode = UtilsUI.GetContainerObject(self.rightNode.Item_2.transform)
    self.AllelopathyNode["right"] = itemNode

    itemNode = UtilsUI.GetContainerObject(self.leftNode.Item_2.transform)
    self.AllelopathyNode["left"] = itemNode
end

function AlchemySmeltPanel:SetItems()
    for k, items in pairs(self.nodeInfo) do
        local dir = self:RetKeyDir(k)
        for i, v in ipairs(items) do
            for id, item in pairs(v) do
                local itemInfo = {}
                itemInfo = ItemConfig.GetItemConfig(id)
                itemInfo.template_id = id
                local alchemyItem = AlchemyItem.New()
                alchemyItem:InitAlchemyItem(item.transform, itemInfo, self.formulaInfo, self, true)
                local eleItemInfo = AlchemyConfig.GetEleItemInfoById(id)
                if not self.alchemyItemsInfo[dir] then
                    self.alchemyItemsInfo[dir] = {}
                end
                table.insert(self.alchemyItemsInfo[dir],{item = alchemyItem, num = 0, elementAmount = eleItemInfo.element_amount, id = id})
            end
        end
    end
end

function AlchemySmeltPanel:SetItemNum(itemId, num)
    for i, v in ipairs(self.alchemyItemsInfo) do
        for i, info in ipairs(v) do
            if info.id == itemId then
                info.item:SetItemNum(num)
                info.item:UpdateEffectState(true)
                info.num = num
            end
        end
    end
    if num >= 0 then
        self:SetItemsEleData()
        self:SetToalNumItem()
    end
end

function AlchemySmeltPanel:SetItemsEleData()
    for keyDir, items in pairs(self.nodeInfo) do
        local elements ={}
        local j = 1
        for i, v in ipairs(items) do
            for id, items in pairs(v) do
                elements[j] = id
                j = j + 1
            end
        end
        self:SetItemEleNum(elements, keyDir)
        
        if AlchemyConfig.Length(items) > 1 then
            self:SetItemEleWeightNum(elements, keyDir)
            local type1 = AlchemyConfig.GetEleItemtypeNumInfoById(elements[1])
            local type2 = AlchemyConfig.GetEleItemtypeNumInfoById(elements[2])
            local textAndDir = AlchemyConfig.GetEleWeightTextAndDir(type1, type2)
            if textAndDir then
                self:SetAllelopathyActiveState(textAndDir,"left", keyDir)
                self:SetAllelopathyActiveState(textAndDir, "right", keyDir)
                self:SetTipsText(textAndDir, keyDir)
            else
                UtilsUI.SetActive(self.AllelopathyNode["left"].Allelopathy, false)
                UtilsUI.SetActive(self.AllelopathyNode["right"].Allelopathy, false)
            end
        end
        self:SetTotalSum(keyDir)
    end
end

function AlchemySmeltPanel:SetItemEleWeightNum(elements, keyDir)
    local dir = self:RetKeyDir(keyDir)

    local type1 = AlchemyConfig.GetEleItemtypeNumInfoById(elements[1])
    local type2 = AlchemyConfig.GetEleItemtypeNumInfoById(elements[2])
    local weight = AlchemyConfig.GetEleWeight(type1, type2)
    if weight[1] == 2 then
        if weight[2] == 1 then
            local eleAmount = self.alchemyItemsInfo[dir][1].elementAmount
            local num = self.alchemyItemsInfo[dir][1].num
            self:CalAddNum(dir, eleAmount * num)
        elseif weight[2] == 2 then
            local eleAmount = self.alchemyItemsInfo[dir][2].elementAmount
            local num = self.alchemyItemsInfo[dir][2].num
            self:CalAddNum(dir, eleAmount * num)
        end
    end
end

function AlchemySmeltPanel:RetKeyDir(keyDir)
    local dir = 0
    if AlchemyConfig.StartWith(keyDir, "left") then
        dir = 1
    elseif  AlchemyConfig.StartWith(keyDir, "right") then
        dir = 2
    end
    return dir
end

function AlchemySmeltPanel:SetItemEleNum(elements, keyDir)
    local dir = self:RetKeyDir(keyDir)
    for k, v in pairs(elements) do
        local eleAmount = self.alchemyItemsInfo[dir][k].elementAmount
        local num = self.alchemyItemsInfo[dir][k].num
        self.alchemyItemsInfo[dir][k].item:SetItemElementNum(num * eleAmount)
    end
end

function AlchemySmeltPanel:SetTipsText(textAndDir,dir)
    UtilsUI.SetActive(self.LeftTipsText, false)
    UtilsUI.SetActive(self.RightTipsText, false)
    local numDir = self:RetKeyDir(dir)
    if numDir == 1 and self.addNum[1] ~= 0 then
        UtilsUI.SetActive(self.LeftTipsText, true)
        self.LeftTipsText_txt.text = string.format("(%s+%s)",textAndDir[1], self.addNum[1])

    end
    if numDir == 2 and self.addNum[2] ~= 0 then
        UtilsUI.SetActive(self.RightTipsText, true)
        self.RightTipsText_txt.text = string.format("(%s+%s)",textAndDir[1], self.addNum[2])
    end
end

function AlchemySmeltPanel:SetTotalSum(keyDir)
    local numDir = self:RetKeyDir(keyDir)
    local totalSum = 0
    for k, v in pairs(self.alchemyItemsInfo[numDir]) do
        totalSum = totalSum + v.num * v.elementAmount
    end
    if numDir == 1 then
        totalSum = totalSum + self.addNum[1]
        self.LeftSumText_txt.text = string.format(TI18N("阳元素总量：%s"), totalSum)
    end
    if numDir == 2 then
        totalSum = totalSum + self.addNum[2]
        self.RightSumText_txt.text = string.format(TI18N("阴元素总量：%s"), totalSum)
    end
    if not self.totalNum then
        self.totalNum = {0, 0}
    end
    self.totalNum[numDir] = totalSum
end

function AlchemySmeltPanel:CalAddNum(dir,num)
    if not self.addNum then
        self.addNum ={0, 0}
    end
    self.addNum[dir] = num
end

function AlchemySmeltPanel:SetAllelopathyActiveState(textAndDir,dir, keyDir)
    if AlchemyConfig.StartWith(keyDir,dir) then
        UtilsUI.SetActive(self.AllelopathyNode[dir].Left2Right, false)
        UtilsUI.SetActive(self.AllelopathyNode[dir].Right2Left, false)
        if textAndDir[1] then
            UtilsUI.SetActive(self.AllelopathyNode[dir].Allelopathy, true)
            self.AllelopathyNode[dir].AllelopathyText_txt.text = textAndDir[1]
            if textAndDir[2]  == 1 then
                UtilsUI.SetActive(self.AllelopathyNode[dir].Left2Right, true)
            elseif textAndDir[2]  == 2 then
                UtilsUI.SetActive(self.AllelopathyNode[dir].Right2Left, true)
            end
        else
            UtilsUI.SetActive(self.AllelopathyNode[dir].Allelopathy, false)
        end
    end
end

function AlchemySmeltPanel:SetToalNumItem()
    if not self.totalNum then
        return
    end
    UtilsUI.SetActive(self.BigBalance, false)
    UtilsUI.SetActive(self.BigYang, false)
    UtilsUI.SetActive(self.BigYin, false)
    UtilsUI.SetActive(self.UnCompositingBg, true)

    local commonObj = self.TargetItem
    self.targetItem = CommonItem.New()

    if self:CanMix() == false then
        UtilsUI.SetActive(self.UnCompositingBg, true)
        self:InitTargetItem(AlchemyConfig.FormulaType.Defult, commonObj)
        self.targetItemType = AlchemyConfig.FormulaType.Defult
    elseif self:CanMix() == true then
        --平衡
        if self.totalNum[1] == self.totalNum[2] then
            self:SetEffectState(AlchemyConfig.FormulaType.Balance)
            UtilsUI.SetActive(self.BigBalance, true)
            self:InitTargetItem(AlchemyConfig.FormulaType.Balance, commonObj)
            self.targetItemType = AlchemyConfig.FormulaType.Balance
        -- 阳
        elseif self.totalNum[1] > self.totalNum[2] then
            self:SetEffectState(AlchemyConfig.FormulaType.Yang)
            UtilsUI.SetActive(self.BigYang, true)
            self:InitTargetItem(AlchemyConfig.FormulaType.Yang, commonObj)
            self.targetItemType = AlchemyConfig.FormulaType.Yang
        --阴
        elseif self.totalNum[1] < self.totalNum[2] then
            self:SetEffectState(AlchemyConfig.FormulaType.Yin)
            UtilsUI.SetActive(self.BigYin, true)
            self:InitTargetItem(AlchemyConfig.FormulaType.Yin, commonObj)
            self.targetItemType = AlchemyConfig.FormulaType.Yin
        end
    end
    self:SetLitmitText()
    self:SetTargetItemInfo()
end

function AlchemySmeltPanel:InitTargetItem(state, commonObj)
    local itemInfo = self:InitTargetItemInfo(state)
    self.targetItem:InitItem(commonObj, itemInfo)
    UtilsUI.SetActive(self.targetItem.node.Num, true)
    self.targetItem.node.Num_txt.text = 1
end

function AlchemySmeltPanel:InitTargetItemInfo(state)
    local itemInfo = {}
    local id = AlchemyConfig.GetTargetItemIdByFormulaId(self.formulaInfo.formula_id, state)
    itemInfo = ItemConfig.GetItemConfig(id)
    itemInfo.template_id = id
    return itemInfo
end

function AlchemySmeltPanel:SetLitmitText()
    local nowNum = mod.AlchemyCtrl:GetNumLimitByFormulaId(self.formulaInfo.formula_id)
    self.HasItemRuleText_txt.text = string.format(TI18N("可放置材料上限：<color=%s>%s</color>/%s"), AlchemyConfig.TextColor.Yellow, nowNum, self.limitNum)
end

function AlchemySmeltPanel:SetTargetItemInfo()
    if self:CanMix() == false then
        self.CompositingPreviewText_txt.text = TI18N("合成预览")
        self.CompositingDescText_txt.text = TI18N("根据阴阳元素改变效果")
        UtilsUI.SetActive(self.UnCompositingBg, true)
    else
        self.CompositingPreviewText_txt.text = AlchemyConfig.FormulaTypeText[self.targetItemType]
        local itemInfo = self:InitTargetItemInfo(self.targetItemType)
        self.CompositingDescText_txt.text = itemInfo.desc
        UtilsUI.SetActive(self.UnCompositingBg, false)
    end
end

-- 当前是否可以合成
function AlchemySmeltPanel:CanMix()
    for i, v in ipairs(self.alchemyItemsInfo) do
        for i, item in ipairs(v) do
            if item.num < 1 then
                return false
            end
        end
    end
    return true
end

function AlchemySmeltPanel:OnClick_MixItem()
    if self:CanMix() == false then
        if PanelManager.Instance:GetPanel(AlchemySmeltSelectItemPanel) then
            MsgBoxManager.Instance:ShowTips(TI18N("每种材料至少放入一种才可以进行冶炼"))
        else
            PanelManager.Instance:OpenPanel(AlchemySmeltSelectItemPanel, {formulaInfo = self.formulaInfo, alchemyItemsInfo = self.alchemyItemsInfo})
        end
    elseif self:CanMix() == true then
        
        local solution = {}
        solution["left"] = {}
        solution["right"] = {}
        for k, v in pairs(self.alchemyItemsInfo[1]) do
            table.insert(solution["left"], {key = v.id, value = v.num})
        end
        for k, v in pairs(self.alchemyItemsInfo[2]) do
            table.insert(solution["right"], {key = v.id, value = v.num})
        end
        
        mod.AlchemyCtrl:AlchemyMix(self.formulaInfo.formula_id, solution, 1)
    end
end

function AlchemySmeltPanel:OnClick_HistoryBtn()
    local hasHistory = mod.AlchemyCtrl:CheckHasHistoryByFormulaId(self.formulaInfo.formula_id)
    if hasHistory == false then
        return
    end
    PanelManager.Instance:OpenPanel(AlchemyRecipeUnlockPanel, {formulaId = self.formulaInfo.formula_id})
end

function AlchemySmeltPanel:SetHistoryBtnActive()
    mod.AlchemyCtrl:InitLimitByFormulaId(self.formulaInfo.formula_id)
    local hasHistory = mod.AlchemyCtrl:CheckHasHistoryByFormulaId(self.formulaInfo.formula_id)
    if hasHistory == false then
        self:SetHistoryBtnActiveState(true)
    elseif hasHistory == true then
        self:SetHistoryBtnActiveState(false)
    end
end

function AlchemySmeltPanel:SetHistoryBtnActiveState(state)
    UtilsUI.SetActive(self.DontHasHistory, state)
    UtilsUI.SetActive(self.HasHistory, not state)
end

function AlchemySmeltPanel:SetEffectLayer()
    local layer = WindowManager.Instance:GetCurOrderLayer()
    UtilsUI.SetEffectSortingOrder(self["22137"], layer + 1)
    UtilsUI.SetEffectSortingOrder(self["22138"], layer + 1)
    UtilsUI.SetEffectSortingOrder(self["22139"], layer + 1)
end

function AlchemySmeltPanel:SetEffectState(state)
    if state == self.targetItemType then
        return
    end
    if state == AlchemyConfig.FormulaType.Balance then
        UtilsUI.SetActive(self["22139"], true)
        UtilsUI.SetActive(self["22138"], false)
        UtilsUI.SetActive(self["22137"], false)
    elseif state == AlchemyConfig.FormulaType.Yin then
        UtilsUI.SetActive(self["22139"], false)
        UtilsUI.SetActive(self["22138"], true)
        UtilsUI.SetActive(self["22137"], false)
    elseif state == AlchemyConfig.FormulaType.Yang then
        UtilsUI.SetActive(self["22139"], false)
        UtilsUI.SetActive(self["22138"], false)
        UtilsUI.SetActive(self["22137"], true)
    end
end
