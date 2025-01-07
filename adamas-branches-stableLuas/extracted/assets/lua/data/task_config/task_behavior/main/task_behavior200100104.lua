TaskBehavior200100104 = BaseClass("TaskBehavior200100104")
--任务1:跨过大树
function TaskBehavior200100104:__init(taskInfo)
	self.taskInfo = taskInfo
end

function TaskBehavior200100104:Update()
	--LogError("在跑UPDATE"..self.taskInfo.taskId)
end