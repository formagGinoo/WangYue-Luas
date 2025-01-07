TaskBehavior102050301 = BaseClass("TaskBehavior102050301")
--大世界任务组4：教学副本
--子任务3：进入副本，副本结束后完成

function TaskBehavior102050301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102050301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 999
	self.trace = false
	self.dialogId = 102050301
end
function TaskBehavior102050301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end