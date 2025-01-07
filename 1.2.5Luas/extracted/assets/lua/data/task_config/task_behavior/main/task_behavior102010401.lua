TaskBehavior102010401 = BaseClass("TaskBehavior102010401")
--大世界任务组1：激活传送点
--子任务4：到达传送点平台上
--完成条件：钟楼区域
function TaskBehavior102010401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102010401
end

function TaskBehavior102010401:Update()
	BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 0 then
		local rolepos = BehaviorFunctions.GetPositionP(self.role)
		local targetpos = BehaviorFunctions.GetTerrainPositionP("Zhonglou",10020001,"LogicWorldTest01")
		local distance = BehaviorFunctions.GetDistanceFromPos(rolepos,targetpos)
		if distance <=10 then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end	
	end
end


function TaskBehavior102010401:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "ZhonglouLockArea" and logicName == "LogicWorldTest01" then
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	end
end