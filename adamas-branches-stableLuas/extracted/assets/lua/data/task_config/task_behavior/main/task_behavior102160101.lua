TaskBehavior102160101 = BaseClass("TaskBehavior102160101")
--大世界任务组4：教学副本
--子任务3：进入副本，副本结束后完成

function TaskBehavior102160101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102160101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 999
	self.trace = false
end
function TaskBehavior102160101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end