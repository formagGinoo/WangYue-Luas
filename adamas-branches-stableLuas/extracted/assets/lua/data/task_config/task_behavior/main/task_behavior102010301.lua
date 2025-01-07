TaskBehavior102010301 = BaseClass("TaskBehavior102010301")
--大世界任务组2：清除小拒点
--子任务2：到达拒点周围
--完成条件：到达ass1附近,创建关卡


function TaskBehavior102010301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.levelState = 0
	self.trace = false
end
function TaskBehavior102010301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--重创关卡
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102010301) then
			BehaviorFunctions.AddLevel(102010301)
		end
		self.levelState = 1
	end
end

function TaskBehavior102010301:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "AssTeachOutArea" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			--看向终点镜头
			local fp1 = BehaviorFunctions.GetTerrainPositionP("Monster3",10020001,"LogicWorldTest01")
			self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
			self.levelCam = BehaviorFunctions.CreateEntity(22002)
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
			--延时移除目标和镜头
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end

function TaskBehavior102010301:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "ZhonglouLockArea" and logicName == "LogicWorldTest01" then
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
		BehaviorFunctions.ShowBlackCurtain(true,0)
		--因为此时有关卡，得用dosetposition不能用inmaptransport
		BehaviorFunctions.DoSetPositionP(self.role,pos)
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	end
end