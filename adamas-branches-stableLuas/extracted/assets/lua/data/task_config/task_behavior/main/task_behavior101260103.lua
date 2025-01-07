TaskBehavior101260103 = BaseClass("TaskBehavior101260103")
--天台追踪临时脚本

function TaskBehavior101260103.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101260103:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	
	self.missionState = 0
end

function TaskBehavior101260103:LateInit()

end

function TaskBehavior101260103:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		if not BehaviorFunctions.GetPartnerInstanceId(self.role) then
			BehaviorFunctions.PlayGuide(1035,1,1)
		else
			BehaviorFunctions.PlayGuide(1037,1,1)
		end
		self.missionState = 1
	end
end
