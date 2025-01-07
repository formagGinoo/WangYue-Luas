TaskBehavior501010501 = BaseClass("TaskBehavior501010501")
--新手流程按键开放

function TaskBehavior501010501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior501010501:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil	
	self.init = false
end

function TaskBehavior501010501:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()	
	if self.init == false then
		--关闭攀爬
		BehaviorFunctions.SetClimbEnable(false)
		self.init = true
	end
end