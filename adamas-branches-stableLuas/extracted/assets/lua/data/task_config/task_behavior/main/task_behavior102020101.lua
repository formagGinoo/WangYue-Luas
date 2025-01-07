TaskBehavior102020101 = BaseClass("TaskBehavior102020101")
--大世界任务组2：清除中据点
--子任务1：在往据点去的中途
--完成条件：离开钟楼区域

--地图指引完成后加黑幕和传送，黑幕结束取消摇杆，加关卡相机和旁白，结束后发送任务进度
--离开钟楼区域才会完成任务，飞行途中播旁白（任务表）

function TaskBehavior102020101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102020101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogState = 0
	self.dialogId2 = 102210101 --听到枪声的旁白
end

function TaskBehavior102020101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 0 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("MonsterS1",10020001,"LogicWorldTest01")
		--BehaviorFunctions.ShowBlackCurtain(true,0)
		--BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		--BehaviorFunctions.CancelJoystick()
		--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
		BehaviorFunctions.AddDelayCallByFrame(60,self,self.Assignment,"taskState",2)
		self.taskState = 1
	
	elseif self.taskState == 2 then
		--BehaviorFunctions.CancelJoystick()
		if  self.dialogState == 0 then
			--看向终点镜头
			local pos = BehaviorFunctions.GetTerrainPositionP("KekeMon1",10020001,"LogicWorldTest01")
			self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z)
			self.levelCam = BehaviorFunctions.CreateEntity(22002)
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
			--延时移除目标和镜头
			BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			BehaviorFunctions.StartStoryDialog(self.dialogId2)
			BehaviorFunctions.AddDelayCallByFrame(60,self,self.Assignment,"taskState",3)
			self.dialogState = 1
		end
	elseif self.taskState == 3 then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.taskState = 4
	end
end

function TaskBehavior102020101:StoryEndEvent(dialogId)
	if dialogId == self.dialogId1 then

	end
	
	if  dialogId == self.dialogId2 then
		
	end
end

--赋值
function TaskBehavior102020101:Assignment(variable,value)
	self[variable] = value
end
