TaskBehavior101104301 = BaseClass("TaskBehavior101104301")
--传送点激活任务

function TaskBehavior101104301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101104301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.dialogList =
	{
		[1] = {Id = 101104301,isPlayed = false},--激活地图后timeline
	}
	
	self.transPortEco = 1003001010001
	self.transPortIns = nil
end

function TaskBehavior101104301:Update()
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--检查和获取传送点状态
	local transIns = BehaviorFunctions.GetEcoEntityByEcoId(self.transPortEco)
	if not self.transPortIns and transIns then
		self.transPortIns = transIns
	elseif self.transPortIns and not transIns then
		self.transPortIns = nil
	end

	if self.missionState == 0 then
		if self.transPortIns then
			local result = BehaviorFunctions.CheckEntityEcoState(self.transPortIns)
			if result == true then
				self.missionState = 1
			end
		end
		
	elseif self.missionState == 1 then		
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 2
	end
end
