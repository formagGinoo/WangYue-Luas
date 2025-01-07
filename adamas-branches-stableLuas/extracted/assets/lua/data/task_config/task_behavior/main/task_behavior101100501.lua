TaskBehavior101100501 = BaseClass("TaskBehavior101100501")
--看向茶馆

function TaskBehavior101100501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101100501:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.dialogList =
	{
		[1] = {Id = 101100501},--茶馆拉人timeline
	}
end

function TaskBehavior101100501:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		
	elseif self.missionState == 1 then
		--BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 2
	end
end

function TaskBehavior101100501:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if self.missionState == 0 then
			if logicName == "Task_main_01" then
				if areaName == "Task101100501Area01" then
					self.missionState = 1
				end
			end
		end
	end
end

function TaskBehavior101100501:StoryStartEvent(dialogId)

end

function TaskBehavior101100501:StoryEndEvent(dialogId)

end