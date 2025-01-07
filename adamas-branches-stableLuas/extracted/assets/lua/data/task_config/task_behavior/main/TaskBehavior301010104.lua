TaskBehavior301010104 = BaseClass("TaskBehavior301010104")
--结束骇入巡卫完成任务

function TaskBehavior301010104.GetGenerates()
	local generates = {}
	return generates
end


function TaskBehavior301010104:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskState = 0
	self.taskLevelId = 301010402
	self.carEcoId = 2003001030001
	self.car = nil
end


function TaskBehavior301010104:Update()
	
	if not self.car then
		self.car = BehaviorFunctions.GetEcoEntityByEcoId(self.carEcoId)
	end
	
	if self.taskState == 1 then
		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
		self.taskState = 999
	end
end


function TaskBehavior301010104:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.car then
		self.taskState = 1
	end
end