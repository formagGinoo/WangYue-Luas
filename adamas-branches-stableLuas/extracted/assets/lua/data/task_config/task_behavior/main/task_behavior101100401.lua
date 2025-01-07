TaskBehavior101100401 = BaseClass("TaskBehavior101100401")
--看向茶馆

function TaskBehavior101100401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101100401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.dialogList =
	{
		[1] = {Id = 101100401},--茶馆吆喝timeline
	}
end

function TaskBehavior101100401:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.5)
		self.missionState = 1
		
	elseif self.missionState == 2 then
		self:LevelLookAtPos("Task101100401Lookat01","Task_main_01",22001,15,"CameraTarget")
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 3
	end
end

function TaskBehavior101100401:LevelLookAtPos(pos,logic,type,frame,bindTransform)
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
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam, false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

function TaskBehavior101100401:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if self.missionState == 1 then
			if logicName == "Task_main_01" then
				if areaName == "Task101100401Area01" then
					self.missionState = 2
				end
			end
		end
	end
end

function TaskBehavior101100401:StoryStartEvent(dialogId)

end

function TaskBehavior101100401:StoryEndEvent(dialogId)

end