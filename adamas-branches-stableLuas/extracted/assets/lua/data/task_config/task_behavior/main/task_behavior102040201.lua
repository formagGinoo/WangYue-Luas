TaskBehavior102040201 = BaseClass("TaskBehavior102040201")
--记录讨价还价成功

function TaskBehavior102040201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102040201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.taskState = 0
	self.dialogId = nil
	self.taskState = 0
end

function TaskBehavior102040201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1)         --先直接完成
end
