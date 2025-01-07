TaskBehavior102660101 = BaseClass("TaskBehavior102660101")
--完成传送

function TaskBehavior102660101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102660101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
end

function TaskBehavior102660101:Update()
	if self.missionState == 0 then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 1
	end
end