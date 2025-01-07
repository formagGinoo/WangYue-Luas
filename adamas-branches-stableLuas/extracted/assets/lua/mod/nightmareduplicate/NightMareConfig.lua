--梦魇终战玩法配置表
NightMareConfig = NightMareConfig or {}

NightMareConfig.DataNightmareMain = Config.DataNightmareMain.Find --总控表
NightMareConfig.DataNightmareLayer = Config.DataNightmareLayer.Find --层级表
NightMareConfig.DataNightmareLayerFindbyType = Config.DataNightmareLayer.FindbyType --层级表(分类型)
NightMareConfig.DataNightmareDuplicate = Config.DataNightmareDuplicate.Find --梦魇副本表
NightMareConfig.DataNightmareDuplicateFindbyLayer = Config.DataNightmareDuplicate.FindbyLayer --梦魇副本表(分层级)
NightMareConfig.DataNightmareDuplicateFindbyDuplicateGroup = Config.DataNightmareDuplicate.FindbyDuplicateGroup--梦魇副本表(分副本组)
NightMareConfig.DataNightmareDuplicateRefresh = Config.DataNightmareDuplicateRefresh.Find--(梦魇终战信息刷新表)
NightMareConfig.DataSystemBuff = Config.DataSystemBuff.Find --系统buff表
NightMareConfig.DataNightmareTag = Config.DataNightmareTag.Find --梦魇挑战标签组表
NightMareConfig.DataNightmareTagFindById = Config.DataNightmareTag.FindbyFinalFightId --梦魇挑战标签组表(按标签组划分)
NightMareConfig.DataNightmareBuff = Config.DataNightmareBuff.Find --梦魇buff表 
NightMareConfig.DataNightmarePointRule = Config.DataNightmarePointRule.Find --分数表
NightMareConfig.DataNightmarePart = Config.DataNightmarePart.Find --分区表
NightMareConfig.DataNightmarePointRewardFindbyPointReward = Config.DataNightmarePointReward.FindbyPointReward --奖励表(byPointReward)
NightMareConfig.DataNightmarePointReward = Config.DataNightmarePointReward.Find --奖励表

NightMareConfig.Nightmaretranspoint = Config.DataNightmareCommon.Find.NightmareTranspoint --跳转功能
NightMareConfig.Nightmaretaggroup = Config.DataNightmareCommon.Find.Nightmaretaggroup --词缀名字

NightMareConfig.MainId = {
    normal = 1, --初难度
    final = 2  --终难度
}

function NightMareConfig.GetDataNightmareMain()
    return NightMareConfig.DataNightmareMain
end

function NightMareConfig.GetDataNightmareMainById(id)
    return NightMareConfig.DataNightmareMain[id]
end

function NightMareConfig.GetDataNightmareLayer(layer)
    return NightMareConfig.DataNightmareLayer[layer]
end

function NightMareConfig.GetDataNightmareLayerFindbyType(type)
    return NightMareConfig.DataNightmareLayerFindbyType[type]
end

function NightMareConfig.GetDataNightmareDuplicate(systemDuplicateId)
    return NightMareConfig.DataNightmareDuplicate[systemDuplicateId]
end

function NightMareConfig.GetDataNightmareDuplicateFindbyLayer(layer)
    return NightMareConfig.DataNightmareDuplicateFindbyLayer[layer]
end

function NightMareConfig.GetDataNightmareDuplicateFindbyDuplicateGroup(groupId)
    return NightMareConfig.DataNightmareDuplicateFindbyDuplicateGroup[groupId]
end

function NightMareConfig.GetDataNightmareCommonConfigByTranspoint()
    return NightMareConfig.Nightmaretranspoint
end

function NightMareConfig.GetDataNightmareCommonConfigByTaggroup()
    return NightMareConfig.Nightmaretaggroup
end

function NightMareConfig.GetDataNightmareDuplicateRefresh(order, duplicateRule)
    local key = UtilsBase.GetDoubleKeys(order, duplicateRule)
    return NightMareConfig.DataNightmareDuplicateRefresh[key]
end

function NightMareConfig.GetDataSystemBuff(buffId)
    return NightMareConfig.DataSystemBuff[buffId]
end

function NightMareConfig.GetDataNightmareTagFindById(final_fight_id)
    return NightMareConfig.DataNightmareTagFindById[final_fight_id]
end

function NightMareConfig.GetDataNightmareTag(key)
    return NightMareConfig.DataNightmareTag[key]
end

function NightMareConfig.GetDataNightmareBuff(fight_base_id)
    return NightMareConfig.DataNightmareBuff[fight_base_id]
end

function NightMareConfig.GetDataNightmarePointRule(pointRuleId)
    return NightMareConfig.DataNightmarePointRule[pointRuleId]
end

function NightMareConfig.GetDataNightmarePart()
    return NightMareConfig.DataNightmarePart
end

function NightMareConfig.GetDataNightmarePartByLayer(layer)
    return NightMareConfig.DataNightmarePart[layer]
end

function NightMareConfig.GetDataNightmareByPointReward(point_reward)
    return NightMareConfig.DataNightmarePointRewardFindbyPointReward[point_reward]
end

function NightMareConfig.GetDataNightmarePointReward(key)
    return NightMareConfig.DataNightmarePointReward[key]
end

