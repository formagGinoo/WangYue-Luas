TaskBehavior101102501 = BaseClass("TaskBehavior101102501")
--装备真实之裂佩从

function TaskBehavior101102501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101102501:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
end

function TaskBehavior101102501:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		if BehaviorFunctions.CheckGuideFinish(1035) == true then
			BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
			self.missionState = 1
		end
	end
end