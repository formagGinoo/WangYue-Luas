TaskBehavior102180201 = BaseClass("TaskBehavior102180201")
--大世界任务组4：教学副本
--子任务6：教学完成

function TaskBehavior102180201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102180201:__init(taskInfo)
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
		[1] = {Id = 102180201,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 102180301,state = self.dialogStateEnum.NotPlaying},
	}
end
function TaskBehavior102180201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 0 and BehaviorFunctions.CheckGuideFinish(1020) then
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.taskState = 1
		
	end
end
function TaskBehavior102180201:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogList[1].Id then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
	elseif dialogId ==  self.dialogList[2].Id then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end