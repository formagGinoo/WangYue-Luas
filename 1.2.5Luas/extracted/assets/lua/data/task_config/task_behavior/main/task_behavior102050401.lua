TaskBehavior102050401 = BaseClass("TaskBehavior102050401")
--大世界任务组4：教学副本
--子任务4：退出副本

function TaskBehavior102050401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102050401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 999
	self.trace = false
	self.dialogId = 102050601
	self.dialogState = 0
end
function TaskBehavior102050401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.dialogState == 0  then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		self.dialogState = 1
	end
end

function TaskBehavior102050401:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end