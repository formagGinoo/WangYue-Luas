TaskBehavior102050201 = BaseClass("TaskBehavior102050201")
--大世界任务组4：教学副本
--子任务2：去教学副本附近

function TaskBehavior102050201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102050201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102050201
end
function TaskBehavior102050201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end
function TaskBehavior102050201:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end

function TaskBehavior102050201:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "TeachDupArea" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			self.taskState = 1
		end
	end
end