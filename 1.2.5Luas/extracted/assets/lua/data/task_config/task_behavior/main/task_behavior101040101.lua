TaskBehavior101040101 = BaseClass("TaskBehavior101040101")
--任务7：青乌遭遇了敌人，学习日相的使用方法

function TaskBehavior101040101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101040101:__init(taskInfo)
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
		[1] = {Id = 101030801,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101030901,state = self.dialogStateEnum.NotPlaying},
	}
	--玩家复活点
	self.currentCheckPoint = "checkPoint5"
	--玩家下个目标点
	self.nextTargetPos = "checkPoint6"
	
	self.trace = false
	
	self.guideFinish = false
end

function TaskBehavior101040101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.trace == false then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	--司命引导青乌前往山顶
	if self.dialogList[1].state == self.dialogStateEnum.NotPlaying then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101030801","Logic10020001_6")
		if inArea then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			--BehaviorFunctions.AddDelayCallByFrame(10,self,self.LevelLookAtPos,"Task1010401Target01","Logic10020001_6",22001,90,"CameraTarget")
			self.dialogList[1].state = self.dialogStateEnum.Playing
		end
	--如果离开区域内则移除镜头
	elseif self.dialogList[1].state == self.dialogStateEnum.Playing then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101030801","Logic10020001_6")
		if not inArea then
			if BehaviorFunctions.CheckEntity(self.levelCam2) == true then
				BehaviorFunctions.RemoveEntity(self.levelCam2)
			end
		end
	end
	
	--司命提示青乌别掉下去了
	if self.dialogList[2].state == self.dialogStateEnum.NotPlaying then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101030901","Logic10020001_6")
		if inArea then
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
			self.dialogList[2].state = self.dialogStateEnum.Playing
		end
	end
	
	if self.missionState == 0 then
		--如果玩家已经在战斗区域内则让玩家出去
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BattleArea1010401","Logic10020001_6")
		if inArea then
			local targetPos = BehaviorFunctions.GetTerrainPositionP(self.currentCheckPoint,10020001,"Logic10020001_6")
			BehaviorFunctions.InMapTransport(targetPos.x,targetPos.y,targetPos.z)
			--BehaviorFunctions.DoSetPosition(self.role,targetPos.x,targetPos.y,targetPos.z)
			--BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
		end
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BattleArea1010401","Logic10020001_6")
		if not inArea then
			--加载关卡
			BehaviorFunctions.AddLevel(101040101)
			--self:LevelLookAtPos(self.nextTargetPos,"Logic10020001_6",22001,10,"CameraTarget")
			self.missionState = 2
		end
	end
	
	if self.missionState == 2 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010401Area01","Logic10020001_6")
		if inArea then
			--BehaviorFunctions.AddLevel(101040101)
			BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
			self.missionState = 3
		end
	end
	
	--if self.missionState == 3 then
		--local hasLevel = BehaviorFunctions.CheckLevelIsCreate(101040101)
		--if not hasLevel then
			--self.missionState = 0
		--end
	--end
end

function TaskBehavior101040101:LevelLookAtPos(pos,logic,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,10020001,logic)
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam2 = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
end

function TaskBehavior101040101:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end

--死亡事件
function TaskBehavior101040101:Revive(instanceId, entityId)
	--玩家死亡重来
	if instanceId == self.role then
		self.trace = false
		self.missionState = 0
	end
end

function TaskBehavior101040101:RemoveTask()

end

function TaskBehavior101040101:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101040101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end