TaskBehavior101200101 = BaseClass("TaskBehavior101200101")
--传送至仿古街

function TaskBehavior101200101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101200101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
end

function TaskBehavior101200101:Update()	
	if self.missionState == 0 then
		BehaviorFunctions.SetActiveBGM("FALSE")
		BehaviorFunctions.SetBgmState("BgmType","GamePlay")
		BehaviorFunctions.SetBgmState("GamePlayType","Explore")
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 1
	end
end


