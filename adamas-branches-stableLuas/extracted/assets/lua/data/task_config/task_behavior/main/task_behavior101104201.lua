TaskBehavior101104201 = BaseClass("TaskBehavior101104201")
--传送点图文提示

function TaskBehavior101104201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101104201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.imgGuideId = 10005
	self.levelCam = nil

end

function TaskBehavior101104201:Update()
	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		
	elseif self.missionState == 1 then		
		--BehaviorFunctions.ShowGuideImageTips(self.imgGuideId)
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 2
	end
end

function TaskBehavior101104201:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if self.missionState == 0 then
			if logicName == "Task_main_01" then
				if areaName == "Task101104201Area01" then
					self.missionState = 1
				end
			end
		end
	end
end
