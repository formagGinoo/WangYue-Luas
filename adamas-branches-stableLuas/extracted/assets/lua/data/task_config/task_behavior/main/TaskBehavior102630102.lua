TaskBehavior102630102 = BaseClass("TaskBehavior102630102")
--佩从玉出现+镜头看向佩从玉

function TaskBehavior102630102.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102630102:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
end

function TaskBehavior102630102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		--LogError("shilongguide")
		--BehaviorFunctions.PlayGuide(2212)
		self.missionState = 1
	end
end