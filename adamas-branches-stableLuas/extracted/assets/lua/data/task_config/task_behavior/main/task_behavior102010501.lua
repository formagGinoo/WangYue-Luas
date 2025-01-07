TaskBehavior102010501 = BaseClass("TaskBehavior102010501")
--大世界任务组1：激活传送点
--子任务4：到达传送点平台上
--完成条件：钟楼区域

--敲钟后播timeline，播完播介绍气脉和悬钟的对话，对话播完任务完成。任务完成后解锁地图功能，播地图指引（配表）

function TaskBehavior102010501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010501:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogId0 = 102200501 --刺杀教学怪死完后对话
	self.dialogId1 = 102010201 --敲钟timeline
	self.dialogId2 = 102200601 --敲钟后对话介绍气脉和悬钟
	self.dialogState = 0
	self.transport = nil
end

function TaskBehavior102010501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	self.transport = BehaviorFunctions.GetEcoEntityByEcoId(1001002020001)
	
	if self.dialogState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogId0)
		BehaviorFunctions.SetEntityWorldInteractState(self.transport,true)
		self.dialogState = 1
	end
	
	if self.transport then
		self.isActive = BehaviorFunctions.CheckEntityEcoState(self.transport)
	end
	
	if self.isActive == true and self.dialogState == 1 then
		BehaviorFunctions.StartStoryDialog(self.dialogId2)
		self.dialogState = 2
	end
end

function TaskBehavior102010501:StoryEndEvent(dialogId)
	if dialogId == self.dialogId2 then
		local pos = BehaviorFunctions.GetTerrainPositionP("MonsterS1",10020001,"LogicWorldTest01")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
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