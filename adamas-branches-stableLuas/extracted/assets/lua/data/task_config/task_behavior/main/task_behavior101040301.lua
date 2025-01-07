TaskBehavior101040301 = BaseClass("TaskBehavior101040301")
--任务7：青乌遭遇了敌人，学习日相的使用方法

function TaskBehavior101040301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101040301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0
	self.currentDialog = nil
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{
		[1] = {Id = 101041101,state = self.dialogStateEnum.NotPlaying},--继续前进，往悬空路走
	}
	
	self.trace = false
	
	self.guideFinish = false
end

function TaskBehavior101040301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.trace == false then		
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	--司命让叙慕穿过前面的山道
	if self.dialogList[1].state == self.dialogStateEnum.NotPlaying then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101040301","Logic10020001_6")
		if inArea then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.dialogList[1].state = self.dialogStateEnum.Playing
		end
	end
	
	if self.missionState == 0 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010403Area01","Logic10020001_6")
		if inArea then
			BehaviorFunctions.SendTaskProgress(101040301,1,1)
			self.missionState = 1
		end
	end
end

function TaskBehavior101040301:LevelLookAtPos()
	--看向下一个目标点镜头
	local fp1 = BehaviorFunctions.GetTerrainPositionP(self.nextTargetPos,10020001,"Logic10020001_6")
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam2 = BehaviorFunctions.CreateEntity(22002)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam2, false)
	BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
	BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
end

function TaskBehavior101040301:HideButton()
	--BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
end

--死亡事件
function TaskBehavior101040301:Death(instanceId,isFormationRevive)

end

function TaskBehavior101040301:RemoveTask()

end

function TaskBehavior101040301:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101040301:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end