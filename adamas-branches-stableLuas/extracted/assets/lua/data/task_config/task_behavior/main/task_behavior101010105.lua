TaskBehavior101010105 = BaseClass("TaskBehavior101010105")
--首次获得箴石之劣佩从弹窗

function TaskBehavior101010105.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101010105:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
end

function TaskBehavior101010105:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.ShowPartnerTips(3001042)--箴石之劣仲魔tips
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 1
	end
end
