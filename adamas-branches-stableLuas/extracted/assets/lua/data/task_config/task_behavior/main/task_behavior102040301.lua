TaskBehavior102040301 = BaseClass("TaskBehavior102040301")
--通电警报器

function TaskBehavior102040301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102040301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.taskState = 0
	self.dialogId = nil
	self.taskState = 0
end

function TaskBehavior102040301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 0 then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1)         --先直接完成
		self.taskState = 1
	end
end
