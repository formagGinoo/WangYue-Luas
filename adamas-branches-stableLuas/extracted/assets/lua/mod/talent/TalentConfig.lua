TalentConfig = TalentConfig or {}

local DataTalentType = Config.DataTalentType.Find
local DataTalent = Config.DataTalent.Find 
local DataTalentLevelUp = Config.DataTalentLevelUp.Find

TalentConfig.LvUpType = 
{
    lvUp = {TI18N("升级"), "shenji"},
    unLock = {TI18N("解锁"), "jiesuo"},
    maxLv = {TI18N("已满级"), "yimanji"}
}

TalentConfig.CurrencyBarType = 20501

TalentConfig.talentDict = {}
TalentConfig.talentMaxLevDict = {}

function TalentConfig.GetTalentListByType(type)
    if not TalentConfig.talentDict[type] then
        TalentConfig.talentDict[type] = {}
        for k, v in pairs(DataTalent) do
            if type == v.type then
                TalentConfig.talentDict[type][k] = v
            end
        end
    end
    return TalentConfig.talentDict[type]
end 

function TalentConfig.GetTalentInfoById(talentId)
    return DataTalent[talentId]
end

function TalentConfig.GetTalentMaxLvById(talentId)
    if not TalentConfig.talentMaxLevDict[talentId] then
        for k, v in pairs(DataTalentLevelUp) do
            if v.talent_id == talentId then
                if not TalentConfig.talentMaxLevDict[talentId] or TalentConfig.talentMaxLevDict[talentId] < v.level then
                    TalentConfig.talentMaxLevDict[talentId] = {}
                    TalentConfig.talentMaxLevDict[talentId] = v.level
                end
            end
        end
    end
    return TalentConfig.talentMaxLevDict[talentId]
end

function TalentConfig.GetUpgradeConfig(talentId, lv)
    local info = DataTalentLevelUp[talentId.."_"..lv]
    if info then
        return info 
    end
end

function TalentConfig.GetTalentTypeNameByType(type)
    return DataTalentType[type].name
end

function TalentConfig.GetTalentTypeInfo()
    return DataTalentType
end
function TalentConfig.GetTalentTypeLength()
    return Config.DataTalentType.FindLength
end
function TalentConfig.GetTalentTypeId()
    local idList = {}
    for k, v in pairs(DataTalentType) do
        table.insert(idList, v.type_id)
    end
    return idList
end

function TalentConfig.GetConditionInfoById(conditionId)
    if not conditionId then
        return
    end
    return Config.DataCondition.data_condition[conditionId]
end

function TalentConfig.CheckConditionIsDone(conditionId)
    if not conditionId then
        return true
    end
    local isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(conditionId)
    return isPass
end

function TalentConfig.GetAdventureLevel()
    local adventureInfo = mod.WorldLevelCtrl:GetAdventureInfo()
    if not adventureInfo or not next(adventureInfo) then
        return
    end
    return adventureInfo.lev
end

function TalentConfig.CheckAdventureLevel(level)
    local adventureLev = TalentConfig.GetAdventureLevel(level)
    if not adventureLev then
        return
    end
    return adventureLev >= tonumber(level)
end

-- 获取全部已点天赋
function TalentConfig.GetAllLevelNum()
    local idList = TalentConfig.GetTalentTypeId()
    local num = 0
    for k, v in pairs(idList) do
       num = num + mod.TalentCtrl:GetTalentLvByType(v) 
    end
    return num
end

-- 最大等级
function TalentConfig.GetTalentMaxLvByType(type)
    local list = TalentConfig.GetTalentListByType(type)
    local num = 0
    for id, info in pairs(list) do
        num = num + TalentConfig.GetTalentMaxLvById(id)
    end
    return num
end