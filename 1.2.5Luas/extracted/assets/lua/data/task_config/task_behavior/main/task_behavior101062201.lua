TaskBehavior101062201 = BaseClass("TaskBehavior101062201")
--任务9.5：青乌陷入了回忆

function TaskBehavior101062201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101062201:__init(taskInfo)
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
		[1] = {Id = 101062201,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101050201,state = self.dialogStateEnum.NotPlaying},
	}
	self.trace = false
	
	--self.guideFinish = false
end

function TaskBehavior101062201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	----检查引导是否完成
	--if BehaviorFunctions.CheckGuideFinish(1012) == true and self.guideFinish == false then
		--self.guideFinish = true
	--end
	
	--if self.trace == false and self.guideFinish == true then
	if self.trace == false then
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		--隐藏按钮
		self:HideButton()
		self.trace = true
		--检查任务进度
		local taskProgress = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		if taskProgress == 1 then
			self.missionState = 2
		end
	end
	
	--叙慕装备完剑进入回忆
	--if self.missionState == 0 and self.guideFinish == true then
	if self.missionState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		--BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 0.5
	end

	if self.missionState == 1  then
		--创建训练关副本
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateDuplicate,2010)
		--BehaviorFunctions.CreateDuplicate(2010)
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		--隐藏任务追踪
		BehaviorFunctions.SetTipsGuideState(false)
		self.missionState = 2
	end
	
	--检查到在副本外就进下个任务
	if self.missionState == 2 then
		local taskProgress = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BattleArea1010601","Logic10020001_6")
		if taskProgress == 1 and inArea then
			BehaviorFunctions.ShowBlackCurtain(true,0)
			--将玩家传送至场地内
			local targetPos = BehaviorFunctions.GetTerrainPositionP("tp_Sword",10020001,"Logic10020001_6")
			--BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
			BehaviorFunctions.InMapTransport(targetPos.x,targetPos.y,targetPos.z)
			--看向前方
			self:LevelLookAtPos("Task1010608Mb1","Logic10020001_6",22001,10,"CameraTarget")
			--去掉黑幕
			BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5)
			--延迟发送任务完成
			BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.SendTaskProgress,101062201,1,1)
			self.missionState = 3
		end
	end
end

function TaskBehavior101062201:HideButton()
	--BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
end

function TaskBehavior101062201:RemoveTask()
	--恢复任务追踪
	BehaviorFunctions.SetTipsGuideState(true)
end

--死亡事件
function TaskBehavior101062201:Death(instanceId,isFormationRevive)

end


function TaskBehavior101062201:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101062201:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 0.5 and dialogId == self.dialogList[2].Id then
				BehaviorFunctions.ShowBlackCurtain(true,0,true)
				----创建训练关副本
				--BehaviorFunctions.CreateDuplicate(2010)
				self.missionState = 1
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end

function TaskBehavior101062201:LevelLookAtPos(pos,logic,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,10020001,logic)
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	self.levelCam2 = BehaviorFunctions.CreateEntity(type,nil,0,0,0,nil,nil,nil,self.levelId)
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