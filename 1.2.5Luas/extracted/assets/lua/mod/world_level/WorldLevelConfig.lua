WorldLevelConfig = WorldLevelConfig or {}

DataWorldLevel = Config.DataWorldLevel.Find

function WorldLevelConfig.GetMaxLev()
    return Config.DataWorldLevel.FindLength - 1
end

function WorldLevelConfig.GetWorldLevelReward(lev)
    if DataWorldLevel[lev].completion_reward == 0 then
        return
    end
    return ItemConfig.GetReward(DataWorldLevel[lev].completion_reward)
end

function WorldLevelConfig.GetWorldLevelTask(lev)
    if not DataWorldLevel[lev].system_task_group then
        return
    end
    return SystemTaskConfig.GetTaskByGroup(DataWorldLevel[lev].system_task_group)
end

function WorldLevelConfig.GetWorldLevelTaskMap(lev)
    if not DataWorldLevel[lev].system_task_group then
        return {}
    end
    return SystemTaskConfig.GetTaskMapByGroup(DataWorldLevel[lev].system_task_group)
end

function WorldLevelConfig.GetLevelDesc(lev)
    return DataWorldLevel[lev].desc
end

function WorldLevelConfig.GetEcoLev(lev,type)
    type = type or FightEnum.EntityNpcTag.Monster
    local config = DataWorldLevel[lev]
    if type == FightEnum.EntityNpcTag.Monster then
        return config.monster_level
    elseif type == FightEnum.EntityNpcTag.Elite then
        return config.ex_monster_level
    elseif type == FightEnum.EntityNpcTag.Boss then
        return config.boss_level
    end
end

function WorldLevelConfig.GetChangeDesc(index, lev, isDegrade)
    if index == 1 then
        return string.format(TI18N("确认后，世界等级调整到<color=#ffb865>Lv.%s</color>"), lev)
    elseif index == 2 then
        if isDegrade then
            return TI18N("世界上的敌人等级<color=#ffb865>降低</color>")
        else
            return TI18N("世界上的敌人等级<color=#ffb865>提升</color>")
        end
    elseif index == 3 then
        if isDegrade then
            return TI18N("世界上的敌人掉落等级<color=#ffb865>降低</color>")
        else
            return TI18N("世界上的敌人掉落等级<color=#ffb865>提升</color>")
        end
    end
end

function WorldLevelConfig.GetTeachId()
    return DataWorldLevel[0].teach_id
end

local DataAdventure = Config.DataAdventure.data_adventure_lev

function WorldLevelConfig.GetAdvLevConfig(lev)
    return DataAdventure[lev]
end