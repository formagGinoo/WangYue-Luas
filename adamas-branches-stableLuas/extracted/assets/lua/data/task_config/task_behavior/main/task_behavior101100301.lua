TaskBehavior101100301 = BaseClass("TaskBehavior101100301")
--玩家移动教学

function TaskBehavior101100301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101100301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0	
	
	self.weakGuide =
	{
		[1] = {Id = 2011,state = false,Describe ="推动摇杆进行移动"},
	}
	
	self.dialogList =
	{
		[1] = {Id = 101100301,isPlayed = false},--青乌随便逛逛timeline
	}

	self.levelCam = nil

end

function TaskBehavior101100301:Update()
	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		self:LevelLookAtPos("Task101100301Lookat01","Task_main_01",22002,30)
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 1
		
	elseif self.missionState == 1 then
		--如果玩家处于移动中，则关掉引导
		if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Move then
			BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.FinishGuide,2011,1)
			BehaviorFunctions.SendTaskProgress(101100301,1,1)
			self.missionState = 2
		end	
	end
end

function TaskBehavior101100301:LevelLookAtPos(pos,logic,type,frame,bindTransform)
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


--开启弱引导，并且关闭其他弱引导
function TaskBehavior101100301:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.PlayGuide(guideId,1,1)
			v.state = true
		elseif v.Id ~= guideId then
			BehaviorFunctions.FinishGuide(v.Id,1)
		end
	end
end

--关闭所有弱引导
function TaskBehavior101100301:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function TaskBehavior101100301:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		--弱引导推动摇杆
		self:WeakGuide(self.weakGuide[1].Id)
	end
end