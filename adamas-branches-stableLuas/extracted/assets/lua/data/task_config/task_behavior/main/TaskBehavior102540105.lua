TaskBehavior102540105 = BaseClass("TaskBehavior102540105")
--相机配置教学

function TaskBehavior102540105.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102540105:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
end

function TaskBehavior102540105:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
		self.missionState = 1

	elseif self.missionState == 1 then

		local pos1 = BehaviorFunctions.GetTerrainPositionP("buidOneLookPos1",10020005,"Task_Main_1020_6_10")
		local pos2 = BehaviorFunctions.GetPositionP(self.role)
		if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) >= 3 then
			self:LevelLookAtPos("buidOneLookPos1","Task_Main_1020_6_10",22002)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		end
		--BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 2
	end
	
	if self.missionState == 2 then
		BehaviorFunctions.PlayGuide(2213,1,1)
		self.missionState = 3
		--elseif self.missionState == 1 then
		--if BehaviorFunctions.CheckGuideFinish(1017) then
		--BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		--self.missionState = 2
		--end
	end
end


function TaskBehavior102540105:LevelLookAtPos(pos,logic,type,bindTransform)
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
