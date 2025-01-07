TaskBehavior101104302 = BaseClass("TaskBehavior101104302")
--传送点图文提示

function TaskBehavior101104302.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101104302:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.imgGuideId = 10005
	self.levelCam = nil

end

function TaskBehavior101104302:Update()
	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		if BehaviorFunctions.CheckGuideFinish(2205) then
			self.missionState = 1
		end
		
	elseif self.missionState == 1 then		
		BehaviorFunctions.ShowGuideImageTips(self.imgGuideId)
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 2
	end
end
