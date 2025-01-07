AlchemyConfig = AlchemyConfig or {}
local AlchemyFormulaCfg = Config.DataAlchemyFormula.Find
local AlchemyItemElementCfg = Config.DataAlchemyItemElement.Find
local AlchemyElementCoexistCfg = Config.DataAlchemyElementCoexist.Find

AlchemyConfig.AlchemyState = {
    smelt = 1,
    upgrade = 2
}

AlchemyConfig.FormulaType = {
    Yin = 1,
    Yang = 2,
    Balance = 3,
    UpGrade = 4,
    Defult = 5
}

AlchemyConfig.ElementType ={
    [1] = "Jin",
    [2] = "Mu",
    [3] = "Shui",
    [4] = "Huo",
    [5] = "Tu",
}

AlchemyConfig.TextColor ={
    Yellow = "#FFB141",
    Red = "#FF5C5C",
    White = "#FFFFFF",
}

AlchemyConfig.TypeIcon = {
    Yin = "Textures/Icon/Single/FuncIcon/CorMark_Item_8.png",
    Yang = "Textures/Icon/Single/FuncIcon/CorMark_Item_7.png",
    Banlance = "Textures/Icon/Single/FuncIcon/CorMark_Item_6.png",
}

AlchemyConfig.FormulaTypeText = {
    [AlchemyConfig.FormulaType.Yin] = TI18N("阴盛"),
    [AlchemyConfig.FormulaType.Yang] = TI18N("阳盛"),
    [AlchemyConfig.FormulaType.Balance] = TI18N("阴阳平衡"),
}

function AlchemyConfig.GetAlchemyTeachId()
    for k, v in pairs(AlchemyFormulaCfg) do
        return v.teach_id
    end
end

function AlchemyConfig.GetAlchemyFormulaById(formulaId)
    return AlchemyFormulaCfg[formulaId]
end

function AlchemyConfig.GetFormulaNeedItemNumById(formulaId)
    local cfg = AlchemyFormulaCfg[formulaId]
    local leftNum = 0
    local rightNum = 0
    for k, v in pairs(cfg.right_item) do
        if v ~= 0 then
            rightNum = rightNum + 1
        end
    end
    for k, v in pairs(cfg.left_item) do
        if v ~= 0 then
            leftNum = leftNum + 1
        end
    end
    return {left = leftNum, right = rightNum}
end

function AlchemyConfig.GetEleItemInfoById(itemId)
    return AlchemyItemElementCfg[itemId]
end

--金木水火土
function AlchemyConfig.GetEleItemtypeInfoById(itemId)
    return AlchemyConfig.ElementType[AlchemyItemElementCfg[itemId].element_type]
end
-- 12345
function AlchemyConfig.GetEleItemtypeNumInfoById(itemId)
    return AlchemyItemElementCfg[itemId].element_type
end

-- weight dir:左->右:1 右->左:2
function AlchemyConfig.GetEleWeight(eleType1, eleType2)
    for k, v in pairs(AlchemyElementCoexistCfg) do
        if v.type == eleType1 and v.coexist == eleType2 then
            return {2, 1}
        end
        if v.type == eleType2 and v.coexist == eleType1 then
            return {2, 2}
        end
    end
    return {1,0}
end

-- 左->右:1 右->左:2
function AlchemyConfig.GetEleWeightTextAndDir(eleType1, eleType2)
    for k, v in pairs(AlchemyElementCoexistCfg) do
        if v.type == eleType1 and v.coexist == eleType2 then
            return {v.remark, 1}
        end
        if v.type == eleType2 and v.coexist == eleType1 then
            return {v.remark, 2}
        end
    end
end

function AlchemyConfig.GetTargetItemIdByFormulaId(formulaId, state)
    local cfg = AlchemyConfig.GetAlchemyFormulaById(formulaId)
    if state == AlchemyConfig.FormulaType.Yin then
        return cfg.yin_id
    end
    if state == AlchemyConfig.FormulaType.Yang then
        return cfg.yang_id
    end
    if state == AlchemyConfig.FormulaType.Balance then
        return cfg.balance_id
    end
    if state == AlchemyConfig.FormulaType.Defult then
        return cfg.show_id
    end
end

function AlchemyConfig.Length(t)
    if nil == t then
        print("error:", t," is nil")
        return nil
    end
    local res=0
    for k,v in pairs(t) do
        res=res+1
    end
    return res
end

function AlchemyConfig.StartWith(str, substr)
    if str == nil or substr == nil then  
        return nil
    end  
    if string.find(str, substr) ~= 1 then  
        return false
    else  
        return true  
    end 
end

