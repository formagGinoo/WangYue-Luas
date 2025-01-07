TaskBehavior102040201 = BaseClass("TaskBehavior102040201")
--大世界任务组3：去城镇
--子任务2：进城
--完成条件：到达城镇

function TaskBehavior102040201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102040201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102040201
end
function TaskBehavior102040201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30

end

function TaskBehavior102040201:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "TownArea" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end