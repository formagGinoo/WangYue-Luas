TaskBehavior198010101 = BaseClass("TaskBehavior198010101")
--五月版本演示任务：出生提示

function TaskBehavior198010101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior198010101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.missionState = 0	
end

function TaskBehavior198010101:Update()	
	--文字提示
	if self.missionState == 0 then
		BehaviorFunctions.PlayBackGroundText(8001)
		self.missionState = 1
	end
end


function TaskBehavior198010101:BackGroundEnd(GroupID)
	if GroupID == 8001 then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1)
	end
end