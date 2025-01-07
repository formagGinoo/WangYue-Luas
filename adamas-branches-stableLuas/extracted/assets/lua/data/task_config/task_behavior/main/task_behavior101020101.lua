TaskBehavior101020101 = BaseClass("TaskBehavior101020101")
--佩从玉出现+镜头看向佩从玉

function TaskBehavior101020101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101020101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
end

function TaskBehavior101020101:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
		self.missionState = 1
		
	elseif self.missionState == 1 then
		
		local pos1 = BehaviorFunctions.GetTerrainPositionP("Task101020101Lookat01",10020005,"Task_main_00")
		local pos2 = BehaviorFunctions.GetPositionP(self.role)
		if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) >= 3 then
			self:LevelLookAtPos("Task101020101Lookat01","Task_main_00",22002)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		end
		self.missionState = 2
	end
end

function TaskBehavior101020101:LevelLookAtPos(pos,logic,type,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId,logic)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
end
