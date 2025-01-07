TaskBehavior200100103 = BaseClass("TaskBehavior200100103")
--任务1:跨过大树
function TaskBehavior200100103:__init(taskInfo)
	self.taskInfo = taskInfo
end

function TaskBehavior200100103:Update()
	--LogError("在跑UPDATE"..self.taskInfo.taskId)
end