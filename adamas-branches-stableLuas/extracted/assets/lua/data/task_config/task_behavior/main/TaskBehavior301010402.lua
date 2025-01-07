TaskBehavior301010402 = BaseClass("TaskBehavior301010402")
--结束骇入巡卫完成任务

function TaskBehavior301010402.GetGenerates()
	local generates = {}
	return generates
end


function TaskBehavior301010402:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskState = 0
	self.taskLevelId = 301010402
end


function TaskBehavior301010402:Update()
	if self.taskState == 0 then
		BehaviorFunctions.AddLevel(self.taskLevelId)
		self.taskState = 1
	end
end