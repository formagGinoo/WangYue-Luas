TaskBehavior101100901 = BaseClass("TaskBehavior101100901")
--看向茶馆

function TaskBehavior101100901.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101100901:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.dialogList =
	{
		[1] = {Id = 101100801,isPlayed = false},--劫匪道途timeline
	}

end

function TaskBehavior101100901:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		local daotuResult = BehaviorFunctions.CheckSaveDialog(1011008)
		if not daotuResult then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.missionState = 1
		else
			self.missionState = 2
		end
		
	elseif self.missionState == 2 then
		local pos = BehaviorFunctions.GetTerrainPositionP("Task101100502Target02",10020005,"Task_main_01")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		self:LevelLookAtPos("Task101100901Lookat01","Task_main_01",22001,10,"CameraTarget")
		BehaviorFunctions.AddLevel(101100901)
		self.missionState = 3

		
	elseif self.missionState == 999 then
		--BehaviorFunctions.SendTaskProgress(101100901,1,1)
		self.missionState = 1000
	end
end

function TaskBehavior101100901:RemoveLevel(levelId)

end

function TaskBehavior101100901:LevelLookAtPos(pos,logic,type,frame,bindTransform)
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

function TaskBehavior101100901:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		self.missionState = 2
	end
end