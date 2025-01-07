TaskBehavior301010404 = BaseClass("TaskBehavior301010404")
--和车交互完成任务


function TaskBehavior301010404.GetGenerates()
	local generates = {200000101}
	return generates
end

function TaskBehavior301010404:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.carEcoId = 2003001030002
	self.taskLevelId = 301010404
	
	self.button = nil
end

function TaskBehavior301010404:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.taskState == 0 then
		BehaviorFunctions.AddLevel(self.taskLevelId)
		self.taskState = 1
	end
	
end
