TaskBehavior101102701 = BaseClass("TaskBehavior101102701")
--抵达工地最顶层

function TaskBehavior101102701.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101102701:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil

end

function TaskBehavior101102701:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		if BehaviorFunctions.CheckEntityInArea(self.role,"Task101102701BattleArea01","Task_main_01") then
			local pos = BehaviorFunctions.GetTerrainPositionP("Task101102701TP01",10020005,"Task_main_01")
			BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		end
		self.missionState = 1
		
	elseif self.missionState == 1 then
		if BehaviorFunctions.CheckEntityInArea(self.role,"Task101102701Area01","Task_main_01") then
			BehaviorFunctions.AddLevel(101102701)
			self.missionState = 2
		end
	
	elseif self.missionState == 2 then
		
	elseif self.missionState == 999 then
		--BehaviorFunctions.SendTaskProgress(101102701,1,1)
		self.missionState = 1000
	end
end

function TaskBehavior101102701:RemoveLevel(levelId)
	if levelId == 101102701 then
		self.missionState = 999
	end
end