TaskBehavior200100105 = BaseClass("TaskBehavior200100105")
--任务1:跨过大树
function TaskBehavior200100105:__init(taskInfo)
	self.taskInfo = taskInfo
end

function TaskBehavior200100105:Update()
	--LogError("在跑UPDATE"..self.taskInfo.taskId)
end