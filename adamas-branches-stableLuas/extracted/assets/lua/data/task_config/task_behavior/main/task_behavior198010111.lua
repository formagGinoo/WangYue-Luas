TaskBehavior198010111 = BaseClass("TaskBehavior198010111")
--五月版本演示任务：出生提示

function TaskBehavior198010111.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior198010111:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.missionState = 0	
end

function TaskBehavior198010111:Update()	
	--资产升到2级
	if self.missionState == 0 and  BehaviorFunctions.CheckCondition(3021002) then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1)
		self.missionState = 1
	end
end