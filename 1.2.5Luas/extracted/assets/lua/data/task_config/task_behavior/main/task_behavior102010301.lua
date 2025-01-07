TaskBehavior102010301 = BaseClass("TaskBehavior102010301")
--大世界任务组1：激活传送点
--子任务3：飞行途中
--完成条件：再过1s

function TaskBehavior102010301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102010301
end

function TaskBehavior102010301:Update()
	BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 0  then
		self.timeStart = self.time
		self.taskState = 1 
	end
	if self.taskState == 1 and self.time - self.timeStart > 1 then
		--看向终点镜头
		local fp1 = BehaviorFunctions.GetTerrainPositionP("Zhonglou",10020001,"LogicWorldTest01")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22002)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.taskState = 2
	end
end

function TaskBehavior102010301:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "ZhonglouLockArea" and logicName == "LogicWorldTest01" then
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	end
end