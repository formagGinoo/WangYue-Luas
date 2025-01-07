TaskBehavior102620105 = BaseClass("TaskBehavior102620105")
--佩从玉出现+镜头看向佩从玉

function TaskBehavior102620105.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102620105:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
end

function TaskBehavior102620105:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		--LogError("guidePlayed")
		BehaviorFunctions.PlayGuide(2211)
		--BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 1
	end
end