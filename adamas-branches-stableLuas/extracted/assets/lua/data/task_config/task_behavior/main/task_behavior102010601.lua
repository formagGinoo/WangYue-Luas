TaskBehavior102010601 = BaseClass("TaskBehavior102010601")
--大世界任务组1：激活传送点
--子任务5：激活传送点
--完成条件：传送点激活

--地图指引完毕后完成任务

function TaskBehavior102010601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010601:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogState = 0
	--self.dialogId = 102010201
	self.guideId = 2205 --判断地图指引是否完成
end

function TaskBehavior102010601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if BehaviorFunctions.CheckGuideFinish(self.guideId) == true then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end

function TaskBehavior102010601:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "ZhonglouLockArea" and logicName == "LogicWorldTest01" then
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	end
end