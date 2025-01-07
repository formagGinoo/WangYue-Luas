TaskBehavior102010501 = BaseClass("TaskBehavior102010501")
--大世界任务组1：激活传送点
--子任务5：激活传送点
--完成条件：传送点激活

function TaskBehavior102010501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010501:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102010501
	self.taskFinish = false
	self.transport = nil
end
function TaskBehavior102010501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.transport = BehaviorFunctions.GetEcoEntityByEcoId(1002020001)
	if self.transport then
		self.isActive = BehaviorFunctions.CheckEntityEcoState(self.transport)
	end
	if self.isActive == true and self.taskFinish == false then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.taskFinish = true
	end
end

function TaskBehavior102010501:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "ZhonglouLockArea" and logicName == "LogicWorldTest01" then
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	end
end
