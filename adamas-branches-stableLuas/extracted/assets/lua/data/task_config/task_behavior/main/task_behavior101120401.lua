TaskBehavior101120401 = BaseClass("TaskBehavior101120401")
--签罚单（流程改动，直接完成任务）


function TaskBehavior101120401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101120401:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.carEcoId = 2003001010001
    self.dialogId = {
        101110801  --路上被拦截签罚单
    }
    self.dialogState = 0
end

function TaskBehavior101120401:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
	if self.taskState == 0 then
		BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
		self.taskState = 1
	end
end