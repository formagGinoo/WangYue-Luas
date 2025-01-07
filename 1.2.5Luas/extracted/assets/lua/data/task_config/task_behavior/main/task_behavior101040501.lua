TaskBehavior101040501 = BaseClass("TaskBehavior101040501")
--任务8：青乌朝前走遇到了更多的敌人，学习月相的使用方法

function TaskBehavior101040501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101040501:__init(taskInfo)
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
		[1] = {Id = 101040501,state = self.dialogStateEnum.NotPlaying},
	}
	
	self.trace = false
	
	self.guideFinish = false
	
	--玩家复活点
	self.currentCheckPoint = "checkPoint8"
	--玩家下个目标点
	self.nextTargetPos = "Task1010405Target01"
end

function TaskBehavior101040501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.trace == false then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	if self.missionState == 0 then
		--如果玩家已经在战斗区域内则让玩家出去
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BattleArea1010405","Logic10020001_6")
		if inArea then
			local targetPos = BehaviorFunctions.GetTerrainPositionP(self.currentCheckPoint,10020001,"Logic10020001_6")
			--BehaviorFunctions.DoSetPosition(self.role,targetPos.x,targetPos.y,targetPos.z)
			--BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
			BehaviorFunctions.InMapTransport(targetPos.x,targetPos.y,targetPos.z)
			self:LevelLookAtPos(22001,10)
		end
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BattleArea1010405","Logic10020001_6")
		if not inArea then
			self.missionState = 2
		end
	end
	
	if self.missionState == 2 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010405Area01","Logic10020001_6")
		if inArea then
			--BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能开启
			BehaviorFunctions.AddLevel(101040501)
			BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
			self.missionState = 3
		end
	end
	
	--if self.missionState == 3 then
		--local hasLevel = BehaviorFunctions.CheckLevelIsCreate(101040501)
		--if not hasLevel then
			--self.missionState = 0
		--end
	--end
end

function TaskBehavior101040501:LevelLookAtPos(type,frame)
	--看向下一个目标点镜头
	local fp1 = BehaviorFunctions.GetTerrainPositionP(self.nextTargetPos,10020001,"Logic10020001_6")
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam2 = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role,"CameraTarget")
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
end

function TaskBehavior101040501:HideButton()
	--BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
end

--死亡事件
function TaskBehavior101040501:Revive(instanceId, entityId)
	--玩家死亡重来
	if instanceId == self.role then
		if self.missionState == 3 then
			self.trace = false
			self.missionState = 0
		end
	end
end

function TaskBehavior101040501:RemoveTask()

end

function TaskBehavior101040501:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101040501:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end