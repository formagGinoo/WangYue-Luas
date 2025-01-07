TaskBehavior301010202 = BaseClass("TaskBehavior301010202")
--结束骇入巡卫完成任务

function TaskBehavior301010202.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior301010202:__init(taskInfo)
	self.taskState = 0
	self.xunweiNpcId = 8201001
	self.hackNPC = nil
end

function TaskBehavior301010202:Update()
	if self.taskState == 0 then
		self.taskState = 1
	end
end