TaskBehavior102010201 = BaseClass("TaskBehavior102010201")
--大世界任务组1：激活传送点
--子任务2：起飞之后
--完成条件：起飞1s
function TaskBehavior102010201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogId = 102010201
	self.teachState = 0
	self.isClose = false
	self.insure = false
	self.levelState = 0
end

function TaskBehavior102010201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	
	--判断滑翔
	if self.taskState == 0 and BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Glide then
		self.timeStart = self.time
		self.taskState = 1
	end
	if self.taskState == 1 and BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Glide 
		and self.time - self.timeStart > 0.3 then
		BehaviorFunctions.FinishGuide(2201,1)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.taskState = 2
	end
	
	--重创关卡
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102010301) then
			BehaviorFunctions.AddLevel(102010301)
		end
		self.levelState = 1
	end
end

function TaskBehavior102010201:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "FlyTeachOutArea" and logicName == "LogicWorldTest01" then
		if self.insure == false and self.taskState ~= 1 then
			BehaviorFunctions.FinishGuide(2201,1)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.insure = true
		end
	end
	
	if triggerInstanceId == self.role and areaName == "ZhonglouLockArea" and logicName == "LogicWorldTest01" then
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
		BehaviorFunctions.ShowBlackCurtain(true,0)
		--因为此时有关卡，得用dosetposition不能用inmaptransport
		BehaviorFunctions.DoSetPositionP(self.role,pos)
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	end
end