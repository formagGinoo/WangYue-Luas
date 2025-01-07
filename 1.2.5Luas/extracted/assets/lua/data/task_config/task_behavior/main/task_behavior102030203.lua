TaskBehavior102030203 = BaseClass("TaskBehavior102030203")
--大世界任务组2：清除小拒点
--子任务2：到达拒点周围
--完成条件：前往据点


function TaskBehavior102030203.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030203:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102030801
	self.dialogState = 0
end
function TaskBehavior102030203:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.dialogState == 0  then
		BehaviorFunctions.StartStoryDialog(102030901)
		self.dialogState = 1
		
	end
end

function TaskBehavior102030203:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "SmallArea" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
	if triggerInstanceId == self.role and areaName == "LookSmallArea" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end