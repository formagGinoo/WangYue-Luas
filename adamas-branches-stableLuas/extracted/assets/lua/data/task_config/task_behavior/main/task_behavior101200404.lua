TaskBehavior101200404 = BaseClass("TaskBehavior101200404")
--佩从玉装备检查

function TaskBehavior101200404.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101200404:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
end

function TaskBehavior101200404:Update()	
	if self.missionState == 0 then
		BehaviorFunctions.PlayGuide(2210,1,1)
		self.missionState = 1
	--elseif self.missionState == 1 then
		--if BehaviorFunctions.CheckGuideFinish(1017) then
			--BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
			--self.missionState = 2
		--end
	end
end

