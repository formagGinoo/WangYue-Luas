TaskBehavior101230301 = BaseClass("TaskBehavior101230301")
--吃药引导扣血

function TaskBehavior101230301.GetGenerates()
	local generates = {}
	return generates

end

function TaskBehavior101230301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil	

	self.init = false
end

function TaskBehavior101230301:LateInit()
	
end

function TaskBehavior101230301:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.init then
		if BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001) >= 8000 then
			local life = BehaviorFunctions.GetEntityAttrVal(self.role,1001)
			life = life*0.8
			BehaviorFunctions.SetEntityAttr(self.role,1001,life)
		end
		self.init = true
	end
end
