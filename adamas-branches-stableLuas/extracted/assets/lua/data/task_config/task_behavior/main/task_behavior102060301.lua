TaskBehavior102060301 = BaseClass("TaskBehavior102060301")
--大世界任务组5：清除中拒点
--子任务3：消灭据点

function TaskBehavior102060301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102060301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102060401
end
function TaskBehavior102060301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end
function TaskBehavior102060301:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end