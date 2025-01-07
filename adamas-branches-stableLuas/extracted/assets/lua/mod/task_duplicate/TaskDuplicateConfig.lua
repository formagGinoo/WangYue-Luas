TaskDuplicateConfig = TaskDuplicateConfig or {}

TaskDuplicateConfig.SystemDuplicateMain = Config.DataSystemDuplicateMain.Find --系统副本表
TaskDuplicateConfig.TaskDuplicateMain = Config.DataTaskDuplicateMain.Find --任务副本表
TaskDuplicateConfig.ShowMonster = Config.DataShowMonster.Find --monster展示
TaskDuplicateConfig.ShowElement = Config.DataShowElement.Find --推荐五行的展示图标
--TaskDuplicateConfig.NpcSystemJump = Config.DataNpcSystemJump.Find --npcjump表

TaskDuplicateConfig.UITYPE = {
    UI = 0,
    Camera = 1,
}

--获取任务副本配置
function TaskDuplicateConfig.GetTaskDuplicateConfigById(duplicateId)
    return TaskDuplicateConfig.TaskDuplicateMain[duplicateId]
end

--获取系统副本配置
function TaskDuplicateConfig.GetSystemDuplicateConfigById(duplicateId)
    return TaskDuplicateConfig.SystemDuplicateMain[duplicateId]
end

--获取怪物配置
function TaskDuplicateConfig.GetMonsterConfig(monsterId)
    return TaskDuplicateConfig.ShowMonster[monsterId]
end

--获取五行配置
function TaskDuplicateConfig.GetElementConfigById(id)
    return TaskDuplicateConfig.ShowElement[id]
end







