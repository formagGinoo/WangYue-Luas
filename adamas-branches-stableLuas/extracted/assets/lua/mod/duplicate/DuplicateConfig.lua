DuplicateConfig = DuplicateConfig or {}


DuplicateConfig.DataDuplicate = Config.DataDuplicate.data_duplicate --副本配置表
DuplicateConfig.SystemDuplicateMain = Config.DataSystemDuplicateMain.Find --系统副本表
DuplicateConfig.ResDuplicateMain = Config.DataResourceDuplicateMain.Find -- 资源副本表
DuplicateConfig.TaskDuplicateMain = Config.DataTaskDuplicateMain.Find  -- 任务副本表

DuplicateConfig.DataFightEvent = Config.DataFightEvent.Find

--编队类型
DuplicateConfig.formationType = {
    robotType = 1, --机器人类型 (只用机器人，无编队界面，采用副本编队，不带入任何buff)
    limitHeroType = 2, --角色强限制类 (固定位置限制角色，采用副本编队，不带入任何butf)
    heroType = 3, --角色限制类 (必须上阵限制角色，采用副本编队，不带入任何buff)
    freeType = 4, --自由选择类 (无机器人，不打开编队界面，采用副本编队，不带入任何buff且进入后日月相、大招点数回满)
}

--规定该类型属于副本编队（副本编队会有特殊化处理：包括但不限于某些buff不带入副本， 副本队伍进入副本时，会根据编队类型配置决定各类资源的初始量）
DuplicateConfig.dupFormation = {
    [DuplicateConfig.formationType.robotType] = 1,
    [DuplicateConfig.formationType.limitHeroType] = 2,
    [DuplicateConfig.formationType.heroType] = 3,
    [DuplicateConfig.formationType.freeType] = 4,
}

--获取副本配置
function DuplicateConfig.GetDuplicateConfigById(duplicateId)
    return DuplicateConfig.DataDuplicate[duplicateId]
end

--获取系统副本配置
function DuplicateConfig.GetSystemDuplicateConfigById(duplicateId)
    return DuplicateConfig.SystemDuplicateMain[duplicateId]
end

function DuplicateConfig.GetFightEvent(fightEventId)
    return DuplicateConfig.DataFightEvent[fightEventId]
end

function DuplicateConfig.GetTaskFightEventList(taskDuplicateId)
    return DuplicateConfig.TaskDuplicateMain[taskDuplicateId].fight_event_id
end

function DuplicateConfig.GetResFightEventList(resDuplicateId)
    return {} --DuplicateConfig.ResDuplicateMain[resDuplicateId].fight_event_id
end





