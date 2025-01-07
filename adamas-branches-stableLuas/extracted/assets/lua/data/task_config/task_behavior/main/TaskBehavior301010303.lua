TaskBehavior301010303 = BaseClass("TaskBehavior301010303")
--结束骇入巡卫完成任务

function TaskBehavior301010303.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior301010303:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskState = 0
	self.xunweiNpcId = 8201001
	self.hackNPC = nil
	
	self.hackMail = false
end


function TaskBehavior301010303:Update()
	self.hackNPC = BehaviorFunctions.GetNpcEntity(8201001)
	if self.hackNPC ~= nil then
		BehaviorFunctions.SetNpcMailState(self.hackNPC.instanceId, true)
	end
	
	if self.taskState == 0 then
		BehaviorFunctions.PlayAnimation(self.hackNPC.instanceId,"TextStand_loop")
		self.taskState = 1
	end
end


function TaskBehavior301010303:HackingClickUp(instanceId)
	if instanceId == self.hackNPC.instanceId then
		self.hackMail = true
	end
end


function TaskBehavior301010303:ExitHacking()
	if self.hackMail == true then
		BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
	end
end