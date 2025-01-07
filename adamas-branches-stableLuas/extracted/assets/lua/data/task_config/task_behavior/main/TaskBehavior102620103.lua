TaskBehavior102620103 = BaseClass("TaskBehavior102620103")
--佩从玉出现+镜头看向佩从玉

function TaskBehavior102620103.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102620103:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.YupeiEco = 3005001030021
	self.YupeiInstance = nil
	self.lookAtPos = nil
end

function TaskBehavior102620103:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
		BehaviorFunctions.ChangeEcoEntityCreateState(self.YupeiEco,true)
		self.missionState = 1

	elseif self.missionState == 1 then

		local pos1 = BehaviorFunctions.GetTerrainPositionP("YuPeiPos1",10020005,"Task_Main_1020_6_10")
		local pos2 = BehaviorFunctions.GetPositionP(self.role)
		if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) >= 3 then
			self:LevelLookAtPos("YuPeiPos1","Task_Main_1020_6_10",22002)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		end
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 2
	end
end

function TaskBehavior102620103:LevelLookAtPos(pos,logic,type,bindTransform)
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
