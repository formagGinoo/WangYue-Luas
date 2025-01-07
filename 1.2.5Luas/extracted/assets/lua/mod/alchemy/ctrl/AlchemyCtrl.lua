AlchemyCtrl = BaseClass("AlchemyCtrl", Controller)

function AlchemyCtrl:__init()
    self.historyFormulaList = {}
    self.formulaIdList = {}
    self.formulaNowNum = {}
end

function AlchemyCtrl:__delete()
    self.historyFormulaList = nil
    self.formulaIdList = nil
    self.formulaNowNum = nil
end

function AlchemyCtrl:UpdateFormulaList(data)
    for _, v in ipairs(data.formula_list) do
        self.historyFormulaList[v.formula_id] = {}
        for _, value in pairs(v.history_balance) do
            value.targetId = AlchemyConfig.GetTargetItemIdByFormulaId(v.formula_id,AlchemyConfig.FormulaType.Balance)
            value.type = AlchemyConfig.FormulaType.Balance
            table.insert(self.historyFormulaList[v.formula_id],value)
        end
        for _, value in pairs(v.history_yang) do
            value.targetId = AlchemyConfig.GetTargetItemIdByFormulaId(v.formula_id,AlchemyConfig.FormulaType.Yang)
            value.type = AlchemyConfig.FormulaType.Yang
            table.insert(self.historyFormulaList[v.formula_id],value)
        end
        for _, value in pairs(v.history_yin) do
            value.targetId = AlchemyConfig.GetTargetItemIdByFormulaId(v.formula_id,AlchemyConfig.FormulaType.Yin)
            value.type = AlchemyConfig.FormulaType.Yin
            table.insert(self.historyFormulaList[v.formula_id],value)
        end
    end
    EventMgr.Instance:Fire(EventName.AlchemyRefreshHistory)
end

function AlchemyCtrl:GetHistoryFormulaListById(id)
    return self.historyFormulaList[id]
end

function AlchemyCtrl:GetFormulaIdList()
    return self.historyFormulaList
end

function AlchemyCtrl:CheckMateriaEnoughByFormulaId(formulaId)
    local formula = AlchemyConfig.GetAlchemyFormulaById(formulaId)
    for _, v in ipairs(formula.left_item) do
        if v ~= 0 then
            local nowNum = mod.BagCtrl:GetItemCountById(v)
            if nowNum <= 0 then  
                return false
            end
        end
    end
    for _, v in ipairs(formula.right_item) do
        if v ~= 0 then
            local nowNum = mod.BagCtrl:GetItemCountById(v)
            if nowNum <= 0 then  
                return false
            end
        end
    end
    return true
end

function AlchemyCtrl:CheckHasHistoryByFormulaId(formulaId)
    if not self.historyFormulaList[formulaId][1] then
        return false
    end
    return true
end

function AlchemyCtrl:SetNumLimitByFormulaId(formulaId, num)
    self.formulaNowNum[formulaId] = num
end

function AlchemyCtrl:InitLimitByFormulaId(formulaId)
    self.formulaNowNum[formulaId] = 0
end

function AlchemyCtrl:InitAllNowLimit()
    for id, formula in pairs(self.formulaNowNum) do
        self.formulaNowNum[id] = 0
    end
end

function AlchemyCtrl:GetNumLimitByFormulaId(formulaId)
    return self.formulaNowNum[formulaId]
end

function AlchemyCtrl:CheckNowNumByFormulaId(formulaId)
    if not self.formulaNowNum[formulaId] then
        self.formulaNowNum[formulaId] = 0
    end
    local formulaCfg = AlchemyConfig.GetAlchemyFormulaById(formulaId)
    if self.formulaNowNum[formulaId] >= formulaCfg.limit or self.formulaNowNum[formulaId] < 0 then
        return false
    else
        return true
    end
end

--合成
function AlchemyCtrl:AlchemyMix(formulaId, solution, count)
    local id, cmd = mod.AlchemyFacade:SendMsg("alchemy", formulaId, solution, count)
    CurtainManager.Instance:EnterWait()
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        CurtainManager.Instance:ExitWait()
        local smSelPanel = PanelManager.Instance:GetPanel(AlchemySmeltSelectItemPanel)
        if smSelPanel then
            smSelPanel:OnClick_ClosePanel()
        end
        local reciUnlockPanel =  PanelManager.Instance:GetPanel(AlchemyRecipeUnlockPanel)
        if reciUnlockPanel then
            reciUnlockPanel:OnClick_CloseBtn()
        end
    end)
end