TaskBehavior101104001 = BaseClass("TaskBehavior101104001")
--派传单隐藏任务

function TaskBehavior101104001.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101104001:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	
	self.dialogList =
	{
		[1] = {Id = 101104001},--派传单timeline
	}
end

function TaskBehavior101104001:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if BehaviorFunctions.CheckTaskIsFinish(101101101) then
		self.missionState = 999
	end

	if self.missionState == 0 then
		
	elseif self.missionState == 999 then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 1000
	end
end

function TaskBehavior101104001:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		self.missionState = 999
	end
end

