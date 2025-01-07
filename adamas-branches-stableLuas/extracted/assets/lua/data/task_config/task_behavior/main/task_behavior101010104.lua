TaskBehavior101010104 = BaseClass("TaskBehavior101010104")
--佩从玉出现+镜头看向佩从玉

function TaskBehavior101010104.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101010104:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.YupeiEco = 3003001000001
	
	self.YupeiIns = nil
end

function TaskBehavior101010104:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		--local pos1 = BehaviorFunctions.GetTerrainPositionP("Task101200401Lookat01",10020005,"Task_main_00")
		self.YupeiIns = BehaviorFunctions.GetEcoEntityByEcoId(self.YupeiEco)
		if self.YupeiIns then
			BehaviorFunctions.AddDelayCallByFrame(10,self,self.Test)
			--local pos1 = BehaviorFunctions.GetPositionP(ins)
			--local pos2 = BehaviorFunctions.GetPositionP(self.role)
			--if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) >= 3 then
				--BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
				--self:LevelLookAtPos("Task101200401Lookat01","Task_main_00",22002)
				--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
				--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			--else
				--BehaviorFunctions.DoLookAtPositionImmediately(self.role,pos1.x,pos1.y,pos1.z,true)
				----视角回正
				--BehaviorFunctions.CameraPosReduction(0.3)
			--end
			self.missionState = 1
		end
	end
end

function TaskBehavior101010104:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.YupeiEco then
		if BehaviorFunctions.CheckEntity(self.levelCam) then
			BehaviorFunctions.RemoveEntity(self.levelCam)
		end
		if BehaviorFunctions.CheckEntity(self.empty) then
			BehaviorFunctions.RemoveEntity(self.empty)
		end
	end
end

function TaskBehavior101010104:LevelLookAtPos(pos,logic,type,bindTransform)
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

function TaskBehavior101010104:Test()
	local pos1 = BehaviorFunctions.GetPositionP(self.YupeiIns)
	local pos2 = BehaviorFunctions.GetPositionP(self.role)
	if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) >= 3 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
		
		self.levelCam = BehaviorFunctions.CreateEntity(22002)
		--立刻朝向目标点
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.YupeiIns)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.YupeiIns)
		
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	else
		BehaviorFunctions.DoLookAtPositionImmediately(self.role,pos1.x,pos1.y,pos1.z,true)
		--视角回正
		BehaviorFunctions.CameraPosReduction(0.3)
	end
end
