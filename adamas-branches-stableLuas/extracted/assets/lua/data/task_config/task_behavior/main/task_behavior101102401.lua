TaskBehavior101102401 = BaseClass("TaskBehavior101102401")
--拾取佩从玉

function TaskBehavior101102401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101102401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil

	self.dialogList =
	{
		[1] = {Id = 101102401},--战斗开始timeline
	}
	
	self.YupeiEco = 3003001010001
end

function TaskBehavior101102401:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		--传送玩家
		local pos = BehaviorFunctions.GetTerrainPositionP("Task101102401TP01",10020005,"Task_main_01")
		local rotate = BehaviorFunctions.GetTerrainRotationP("Task101102401TP01",10020005,"Task_main_01")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SetEntityEuler(self.role,rotate.x,rotate.y,rotate.z)
		--传送黑幕
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.ChangeEcoEntityCreateState(self.YupeiEco,true)
		BehaviorFunctions.AddDelayCallByFrame(20,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.8)
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",2)
		self.missionState = 1
		
	elseif self.missionState == 2 then
		if BehaviorFunctions.CheckEntityInArea(self.role,"Task101102401Area01","Task_main_01") then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self:LevelLookAtPos("Task101102401Lookat01","Task_main_01",22002)
			----相机回正
			--BehaviorFunctions.CameraPosReduction(0)
			self.missionState = 3
		end
	end
end

function TaskBehavior101102401:CatchPartnerEnd()
	BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
end

function TaskBehavior101102401:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		BehaviorFunctions.RemoveEntity(self.levelCam)
		BehaviorFunctions.RemoveEntity(self.empty)
	end
end

--赋值
function TaskBehavior101102401:Assignment(variable,value)
	self[variable] = value
end

function TaskBehavior101102401:LevelLookAtPos(pos,logic,type,bindTransform)
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
