TaskBehavior101010002 = BaseClass("TaskBehavior101010002")
--创角判断

function TaskBehavior101010002.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101010002:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.missionState = 0	
end

function TaskBehavior101010002:Update()	
	--如果没完成创角
	if not BehaviorFunctions.CheckChooseGenderFinish() then
		if self.missionState == 0 then
			BehaviorFunctions.ChooseGender()
			self.missionState = 1
		elseif self.missionState == 1 then
			--如果完成创角
			if BehaviorFunctions.CheckChooseGenderFinish() then
				self.missionState = 2
			end
		end
	--如果完成了创角
	else
		if self.missionState < 3 then
			self.missionState = 2
		end
	end
	
	if self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 3
	end
end
