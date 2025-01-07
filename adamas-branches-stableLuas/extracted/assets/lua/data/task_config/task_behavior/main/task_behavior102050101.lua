TaskBehavior102050101 = BaseClass("TaskBehavior102050101")
--大世界任务组4：大世界任务组4：教学副本
--子任务1：离开警察局

function TaskBehavior102050101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102050101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102050101
end
function TaskBehavior102050101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102050101:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "OutPoliceOffice" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end