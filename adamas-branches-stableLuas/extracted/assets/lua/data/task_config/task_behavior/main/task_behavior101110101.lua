TaskBehavior101110101 = BaseClass("TaskBehavior101110101")
--因改timeline配置，直接完成任务


function TaskBehavior101110101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101110101:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.carEcoId = 2003001010001
    self.dialogId = {
        
    }
    self.dialogState = 0
end

function TaskBehavior101110101:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
	BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
end