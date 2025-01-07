TaskBehavior103090107 = BaseClass("TaskBehavior103090107")
--浮空岛旁边的注视相机

function TaskBehavior103090107.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior103090107:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
end

function TaskBehavior103090107:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0 then
		local Pos = BehaviorFunctions.GetTerrainPositionP("fukong1",10020005,"Main_003_01")
		self.empty = BehaviorFunctions.CreateEntity(2001, nil, Pos.x, Pos.y, Pos.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		--看向目标
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		--延时移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.SendTaskProgress,self.taskId,self.taskStepId,1)
		self.missionState = 1
	end

end