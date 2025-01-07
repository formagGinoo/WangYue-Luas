TaskBehavior102010401 = BaseClass("TaskBehavior102010401")
--大世界任务组2：清除小拒点
--子任务2：到达拒点周围
--完成条件：刺杀教学


function TaskBehavior102010401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.levelState = 0
end

function TaskBehavior102010401:Update()
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

function TaskBehavior102010401:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "ZhonglouLockArea" and logicName == "LogicWorldTest01" then
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
 		BehaviorFunctions.ShowBlackCurtain(true,0)
		--因为此时有关卡，得用dosetposition不能用inmaptransport
		BehaviorFunctions.DoSetPositionP(self.role,pos)
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	end
end