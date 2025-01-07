TaskBehavior101070101 = BaseClass("TaskBehavior101070101")
--任务12 二人遭遇了巴西利克斯

function TaskBehavior101070101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101070101:__init(taskInfo)
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
	--玩家复活点
	self.currentCheckPoint = "checkPoint13"
	--玩家下个目标点
	self.nextTargetPos = "checkPoint14"
	
	self.trace = false
	self.initSetting = false
	
	self.dialogList =
	{
		[1] = {Id = 101070801,state = self.dialogStateEnum.NotPlaying},
		--[2] = {Id = 101071001,state = self.dialogStateEnum.NotPlaying},
	}
end

function TaskBehavior101070101:Update()
	
	--初始化设置
	if self.initSetting == false then
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--进度检查
		local taskProgress = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		--玩家完成副本
		if taskProgress == 1 then
			self.missionState = 3
		--玩家看完timeline
		elseif taskProgress == 2 then
			self.missionState = 5
		end
		self.initSetting = true
	end
	
	if self.trace == false then
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0 then
		--如果玩家已经在战斗区域内则让玩家出去
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BossArea","Logic10020001_6")
		if inArea then
			local targetPos = BehaviorFunctions.GetTerrainPositionP(self.currentCheckPoint,10020001,"Logic10020001_6")
			--BehaviorFunctions.DoSetPosition(self.role,targetPos.x,targetPos.y,targetPos.z)
			--BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
			BehaviorFunctions.InMapTransport(targetPos.x,targetPos.y,targetPos.z)
		end
		self.missionState = 1
	end

	if self.missionState == 1 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010701Area01","Logic10020001_6")
		if inArea then
			BehaviorFunctions.AddLevel(101070101)
			BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
			self.missionState = 2
		end
	end
	
	--如果处于副本战斗中
	if self.missionState == 2 then
		--进度检查
		local taskProgress = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		--玩家完成副本
		if taskProgress == 1 then
			self.missionState = 3
		end
	end
	
	--如果副本已完成
	if self.missionState == 3 then
		--播放timeline
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 4
	end
	
	--播放完timeline
	if self.missionState == 5 then
		--隐藏任务追踪
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		BehaviorFunctions.ShowBlackCurtain(true,0)
		--将玩家传送至战场中间
		local tp1 = BehaviorFunctions.GetTerrainPositionP("Boss1",10020001,"Logic10020001_6")
		BehaviorFunctions.InMapTransport(tp1.x,tp1.y,tp1.z)
		--看向终点镜头
		local fp1 = BehaviorFunctions.GetTerrainPositionP("BossTreasureBox",10020001,"Logic10020001_6")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		----隐藏战斗UI
		--BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
		----延迟显示战斗UI
		--BehaviorFunctions.AddDelayCallByFrame(140,BehaviorFunctions,BehaviorFunctions.SetFightMainNodeVisible,2,"PanelParent",true)
		----展示击败标签
		--BehaviorFunctions.ShowCommonTitle(6,"巴西利克斯",true)
		BehaviorFunctions.AddDelayCallByFrame(90,self,self.Assignment,"missionState",6)
		self.missionState = 5.5
	end
	
	if self.missionState == 6 then
		--移除黑幕
		BehaviorFunctions.ShowBlackCurtain(false,1)
		--移除目标和镜头
		BehaviorFunctions.RemoveEntity(self.levelCam)
		BehaviorFunctions.RemoveEntity(self.empty)
		--完成任务
		BehaviorFunctions.SendTaskProgress(101070101,1,1)
		--BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.SendTaskProgress,101070101,1,1)
		self.missionState = 7
	end
end

function TaskBehavior101070101:Die(attackInstanceId,dieInstanceId)
	--玩家死亡重来
	if dieInstanceId == self.role then
		--如果玩家已经在战斗区域内则让玩家出去
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BossArea","Logic10020001_6")
		if inArea then
			local targetPos = BehaviorFunctions.GetTerrainPositionP(self.currentCheckPoint,10020001,"Logic10020001_6")
			--BehaviorFunctions.DoSetPosition(self.role,targetPos.x,targetPos.y,targetPos.z)
			--BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
			--BehaviorFunctions.InMapTransport(targetPos.x,targetPos.y,targetPos.z)
		end
	end
end

--死亡事件
function TaskBehavior101070101:Revive(instanceId, entityId)
	--玩家死亡重来
	if instanceId == self.role then
		if self.missionState == 2 then
			self.trace = false
			self.missionState = 0
		end
	end
end

function TaskBehavior101070101:RemoveTask()

end

--赋值
function TaskBehavior101070101:Assignment(variable,value)
	self[variable] = value
end

function TaskBehavior101070101:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101070101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 4 then
				if dialogId == self.dialogList[1].Id then
					----发送第二次任务进度，代表看完了timeline
					--BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
				--elseif dialogId == self.dialogList[2].Id then
					BehaviorFunctions.SendTaskProgress(101070101,1,1)
					self.missionState = 5
				end
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end