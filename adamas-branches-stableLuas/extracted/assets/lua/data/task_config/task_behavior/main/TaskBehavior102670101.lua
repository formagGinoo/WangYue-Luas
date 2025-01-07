TaskBehavior102670101 = BaseClass("TaskBehavior102670101")
--传送至仿古街

function TaskBehavior102670101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102670101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
end

function TaskBehavior102670101:Update()
	if self.missionState == 0 then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 1
	end
end


