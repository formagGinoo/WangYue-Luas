TaskBehavior101102202 = BaseClass("TaskBehavior101102202")
--集装箱附近

function TaskBehavior101102202.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101102202:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil

end

function TaskBehavior101102202:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		if BehaviorFunctions.CheckEntityInArea(self.role,"Task101102202BattleArea01","Task_main_01") then
			local pos = BehaviorFunctions.GetTerrainPositionP("Task101102202TP01",10020005,"Task_main_01")
			BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		end
		self.missionState = 1
		
	elseif self.missionState == 1 then
		if BehaviorFunctions.CheckEntityInArea(self.role,"Task101102202Area01","Task_main_01") then
			BehaviorFunctions.AddLevel(101102202)
			self.missionState = 2
		end
	
	elseif self.missionState == 2 then
		
	elseif self.missionState == 999 then
		--BehaviorFunctions.SendTaskProgress(101102202,1,1)
		self.missionState = 1000
	end
end

function TaskBehavior101102202:RemoveLevel(levelId)
	if levelId == 101102202 then
		self.missionState = 999
	end
end