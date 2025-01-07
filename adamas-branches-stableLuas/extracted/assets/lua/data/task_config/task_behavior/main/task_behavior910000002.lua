TaskBehavior910000002 = BaseClass("TaskBehavior910000002")
--新手流程车辆控制

function TaskBehavior910000002.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior910000002:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	
	self.xumuCarEcoId = 2003001010001
	self.xumuCarIns = nil
	self.init = false
	
	self.taskState = false
end

function TaskBehavior910000002:Update()
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	local xumuCarIns = BehaviorFunctions.GetEcoEntityByEcoId(self.xumuCarEcoId)

	if not self.xumuCarIns and xumuCarIns then
		self.xumuCarIns = xumuCarIns
		BehaviorFunctions.SetCarBroken(self.xumuCarIns,true)
	elseif self.xumuCarIns and not xumuCarIns then
		self.xumuCarIns = nil
	end
end
