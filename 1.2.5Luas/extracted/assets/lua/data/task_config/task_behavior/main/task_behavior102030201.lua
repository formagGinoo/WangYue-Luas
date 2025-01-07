TaskBehavior102030201 = BaseClass("TaskBehavior102030201")
--大世界任务组2：清除小拒点
--子任务2：到达拒点周围
--完成条件：到达ass1附近,创建关卡


function TaskBehavior102030201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102030601
end
function TaskBehavior102030201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102030201:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "AssTeachOutArea" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			BehaviorFunctions.AddLevel(102030201)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			self.taskState = 1
		end
	end
end