ResDuplicateConfig = ResDuplicateConfig or {}

ResDuplicateConfig.ResourceDuplicateMain = Config.DataResourceDuplicateMain.Find
ResDuplicateConfig.ResourceDuplicateMainFindById = Config.DataResourceDuplicateMain.FindbyId
ResDuplicateConfig.ResourceDuplicateTag = Config.DataResourceDuplicateTag.Find
ResDuplicateConfig.SystemDuplicateMain = Config.DataSystemDuplicateMain.Find
ResDuplicateConfig.ResourceDuplicateType = Config.DataResourceDuplicateType.Find
ResDuplicateConfig.ShowMonster = Config.DataShowMonster.Find
ResDuplicateConfig.CommonConfig = Config.DataResourceCommon.Find
ResDuplicateConfig.ResourceBossLink = Config.DataResourceBossLink.Find
ResDuplicateConfig.ResDupEcoIdToResId = Config.DataResourceDuplicateType.FindEcoIdInfo
ResDuplicateConfig.ResourceEcoHitCost = Config.DataResourceBossLink.FindRewardEcoIdInfo

ResDuplicateConfig.FightCostResId = ResDuplicateConfig.CommonConfig.FightDupCostResId.int_val

ResDuplicateConfig.TagResDuplicateConfig = {}

ResDuplicateConfig.ResType = {
    defRes = 1,
    bossRes = 2,
}

function ResDuplicateConfig.GetResDuplicateTagList()
    return ResDuplicateConfig.ResourceDuplicateTag
end

function ResDuplicateConfig.GetResDuplicateList(tagId)
    if ResDuplicateConfig.TagResDuplicateConfig[tagId] then
        return ResDuplicateConfig.TagResDuplicateConfig[tagId]
    end
    ResDuplicateConfig.TagResDuplicateConfig[tagId] = {}
    for _, data in pairs(ResDuplicateConfig.ResourceDuplicateMain) do
        local tag = data.tag
        if not ResDuplicateConfig.TagResDuplicateConfig[tag] then
            ResDuplicateConfig.TagResDuplicateConfig[tag] = {}
        end
        ResDuplicateConfig.TagResDuplicateConfig[tag][data.id] = true
    end
    return ResDuplicateConfig.TagResDuplicateConfig[tagId]
end

function ResDuplicateConfig.GetResDuplicateMainInfo(resId)
    return ResDuplicateConfig.ResourceDuplicateMain[resId]
end

function ResDuplicateConfig.GetResDuplicateTagInfo(tagId)
    return ResDuplicateConfig.ResourceDuplicateTag[tagId]
end

function ResDuplicateConfig.GetDuplicateInfo(duplicateId)
    return ResDuplicateConfig.SystemDuplicateMain[duplicateId]
end

function ResDuplicateConfig.GetResourceDuplicateType(resDuplicateId)
    return ResDuplicateConfig.ResourceDuplicateType[resDuplicateId]
end

function ResDuplicateConfig.GetResourceDuplicateMainById(resDuplicateId)
    return ResDuplicateConfig.ResourceDuplicateMainFindById[resDuplicateId]
end

function ResDuplicateConfig.GetShowMonsterInfo(showId)
    return ResDuplicateConfig.ShowMonster[showId]
end

function ResDuplicateConfig.GetBossDupLinkConfig(ecoId)
    return ResDuplicateConfig.ResourceBossLink[ecoId]
end

function ResDuplicateConfig.GetResDupLinkEcoId(ecoId)
    if ResDuplicateConfig.ResourceEcoHitCost[ecoId] then
        return ResDuplicateConfig.ResourceEcoHitCost[ecoId].id
    end
end

function ResDuplicateConfig.GetResourceEcoHitCost(ecoId)
    return ResDuplicateConfig.ResourceEcoHitCost[ecoId]
end

function ResDuplicateConfig.GetResDupIdByEcoId(ecoId)
    return ResDuplicateConfig.ResDupEcoIdToResId[ecoId]
end

function ResDuplicateConfig.GetDuplicateConfig(dupId)
    local dupCfg = Config.DataDuplicate.data_duplicate[dupId]
    return dupCfg
end