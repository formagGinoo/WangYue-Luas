TaskBehavior102050501 = BaseClass("TaskBehavior102050501")
--大世界任务组4：教学副本
--子任务5：回城

function TaskBehavior102050501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102050501:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 999
	self.trace = false
	self.dialogId = 102050701
end
function TaskBehavior102050501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end
function TaskBehavior102050501:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end