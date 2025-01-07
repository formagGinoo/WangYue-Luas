TaskBehavior101102102 = BaseClass("TaskBehavior101102102")
--攀爬教学

function TaskBehavior101102102.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101102102:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.imagTips = false
end

function TaskBehavior101102102:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if BehaviorFunctions.CheckTaskIsFinish(101102103) then
		self.missionState = 999
	end

	if self.missionState == 0 then
		
	elseif self.missionState == 999 then
		--玩家爬墙前补满体力
		BehaviorFunctions.SetPlayerAttr(1642,9999)
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 1000
	end
end

function TaskBehavior101102102:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if logicName == "Task_main_01" then
			if areaName == "Task101102102Area01" then
				if not self.imagTips  then
					BehaviorFunctions.ShowGuideImageTips(20001)
					self.missionState = 999
					self.imagTips = true
				end
			end
		end
	end
end