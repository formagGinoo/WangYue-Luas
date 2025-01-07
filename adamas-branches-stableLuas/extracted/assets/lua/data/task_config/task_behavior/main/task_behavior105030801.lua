TaskBehavior105030801 = BaseClass("TaskBehavior105030801")
--创建交互点，交互后播对话
--完成：播完对话后完成任务

function TaskBehavior105030801.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105030801:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.JiaohudianId = 2020202
    self.dialogId = {
        102320601
    }
    self.dialogState = 0
end

function TaskBehavior105030801:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 then
        local pos = BehaviorFunctions.GetTerrainPositionP("Panjudian", 10020004, "MainTask04")
        self.Jiaohudian = BehaviorFunctions.CreateEntity(self.JiaohudianId, nil, pos.x, pos.y, pos.z)
        self.taskState = 1
    end
end

function TaskBehavior105030801:WorldInteractClick(uniqueId,instanceId)
    if instanceId == self.Jiaohudian and self.dialogState == 0 then
        BehaviorFunctions.StartStoryDialog(self.dialogId[1])
        BehaviorFunctions.RemoveEntity(self.Jiaohudian)
        self.dialogState = 1
    end
end