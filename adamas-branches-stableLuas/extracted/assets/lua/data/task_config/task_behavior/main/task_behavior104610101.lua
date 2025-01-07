TaskBehavior104610101 = BaseClass("TaskBehavior104610101")
--佩从玉出现+镜头看向佩从玉

function TaskBehavior104610101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior104610101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
	self.levelCam = nil
	self.YupeiEco = 3001002120033
end

function TaskBehavior104610101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
		BehaviorFunctions.ChangeEcoEntityCreateState(self.YupeiEco,true)
		local pos = BehaviorFunctions.GetTerrainPositionP("Trans01",10020001,"MainTask041")
		BehaviorFunctions.InMapTransport(pos.x, pos.y, pos.z)
		self.missionState = 1
		
	elseif self.missionState == 1 then
		--获得玉佩坐标
		local pos1 = BehaviorFunctions.GetTerrainPositionP("TP01",10020001,"MainTask041")
		--获得角色坐标
		local pos2 = BehaviorFunctions.GetPositionP(self.role)
		if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) >= 3 then
			self:LevelLookAtPos("TP01","MainTask041",22002)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		end
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 2
	end
end

function TaskBehavior104610101:LevelLookAtPos(pos,logic,type,bindTransform)
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
