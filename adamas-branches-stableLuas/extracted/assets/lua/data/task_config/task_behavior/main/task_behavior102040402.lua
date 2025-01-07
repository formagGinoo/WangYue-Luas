TaskBehavior102040402 = BaseClass("TaskBehavior102040402")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102040402.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102040402:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{
		[1] = {Id = 102230101,state = self.dialogStateEnum.NotPlaying},
	}

end

function TaskBehavior102040402:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102040402:WorldInteractClick(uniqueId,instanceId)
	if instanceId == BehaviorFunctions.GetEcoEntityByEcoId(1001002020012) then
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end