TaskBehavior200100101 = BaseClass("TaskBehavior200100101")
--任务1:跨过大树
function TaskBehavior200100101:__init(taskInfo)
	self.taskInfo = taskInfo	
end

function TaskBehavior200100101:Update()
	--LogError("在跑UPDATE"..self.taskInfo.taskId)
end