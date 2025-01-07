TaskBehavior102050601 = BaseClass("TaskBehavior102050601")
--大世界任务组4：教学副本
--子任务6：教学完成

function TaskBehavior102050601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102050601:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102050801
end
function TaskBehavior102050601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 0 and BehaviorFunctions.CheckGuideFinish(1020) then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		self.taskState = 1
		
	end
end
function TaskBehavior102050601:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end