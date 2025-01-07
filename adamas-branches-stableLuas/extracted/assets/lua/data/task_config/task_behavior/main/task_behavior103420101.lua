TaskBehavior103420101 = BaseClass("TaskBehavior103420101")
--招店员

function TaskBehavior103420101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior103420101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
end

function TaskBehavior103420101:Update()

end

function TaskBehavior103420101:Hacking(instanceId)
	if self.taskState == 0 and BehaviorFunctions.GetNpcId(instanceId) == 5005 then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,self.taskInfo.stepId,1)
		self.taskState = 1
	end
end