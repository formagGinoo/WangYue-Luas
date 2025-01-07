TaskBehavior102020201 = BaseClass("TaskBehavior102020201")
--大世界任务组2：清除小拒点
--子任务1：在往据点去的中途
--完成条件：离开钟楼区域

--到达遇见刻刻区域完成任务

function TaskBehavior102020201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102020201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogState = 0
	self.dialogId = 102210201 --前往枪声位置途中播
end

function TaskBehavior102020201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.dialogState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		self.dialogState = 1
	end
end

function TaskBehavior102020201:EnterArea(triggerInstanceId,areaName,logicName)
	if triggerInstanceId == self.role and areaName == "KekeArea1" and logicName == "LogicWorldTest01" then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end