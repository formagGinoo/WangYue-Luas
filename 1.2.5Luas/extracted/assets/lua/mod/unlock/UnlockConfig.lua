UnlockConfig = UnlockConfig or {}

local DataUnlockSkill = Config.DataUnlockSkill.Find
local DataUnlockEntity = Config.DataUnlockEntity.Find
local DataUnlockInfo = Config.DataUnlockInfo.Find

UnlockConfig.LockLvColor = {
    [1] = Color(68/255, 165/255, 82/255, 1), -- 绿
    [2] = Color(230/255, 159/255, 76/255, 1), -- 黄
    [3] = Color(202/255, 88/255, 88/255, 1), -- 红

}

UnlockConfig.LockResultColor = {
    [1] = Color(1, 1, 1, 1), -- 默认
    [2] = Color(96/255, 96/255, 99/255, 1), -- 成功
    [3] = Color(203/255, 91/255, 91/255, 1), -- 失败
}

UnlockConfig.SelectPartnerColor = {
    [1] = Color(63/255, 72/255, 84/255, 1), -- 选中
    [2] = Color(160/255, 168/255, 181/255, 1), -- 未选中
}

function UnlockConfig.GetUnlockSkillLevelCfg(skillId, lv)
    local key = UtilsBase.GetDoubleKeys(skillId, lv, 32)
    return DataUnlockSkill[key]
end

-- ecoId：生态id
function UnlockConfig.GetUnlockInitCfg(ecoId)
    return DataUnlockEntity[ecoId]
end

function UnlockConfig.GetlockInfoCfg(lockId)
    return DataUnlockInfo[lockId]
end

function UnlockConfig.GetTimeDesc(seconds)
    seconds = math.floor(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds - (hours * 3600)) / 60)
    if hours > 0 and minutes > 0 then
        return string.format("%02d:%02d", hours, minutes)
    end
    local seconds = seconds - (hours * 3600) - (minutes * 60)
    if hours <= 0 and minutes >= 0 and seconds >= 0 then
        return string.format("%02d:%02d", minutes, seconds)
    end
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end