TaskBehavior910000001 = BaseClass("TaskBehavior910000001")
--新手流程按键开放

function TaskBehavior910000001.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior910000001:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil	
	self.init = false
end

function TaskBehavior910000001:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()	
	if self.init == false then
		--关闭按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
		self.init = true
	end
end