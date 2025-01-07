TaskBehavior101070102 = BaseClass("TaskBehavior101070102")
--任务12 捡起玉佩

function TaskBehavior101070102.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101070102:__init(taskInfo)
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
		[1] = {Id = 102040401,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101071001,state = self.dialogStateEnum.NotPlaying},
	}

	self.trace = false
	self.initSetting = false
	self.guideFinish = false
	self.time = 0
	self.timeStart = 0
end

function TaskBehavior101070102:Update()

	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)

	if self.trace == false then
		----更新任务追踪
		--BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	--初始化设置
	if self.initSetting == false then
		BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
		local taskProcess = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		if taskProcess == 1 then
			self.missionState = 4
		end

		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--离歌玉佩掉落生态实体创建状态
		BehaviorFunctions.ChangeEcoEntityCreateState(3000010001,true)
		self.initSetting = true
	end

	if self.missionState == 0  then
		--将玩家传送至战场中间
		--local tp1 = BehaviorFunctions.GetTerrainPositionP("Boss1",10020001,"Logic10020001_6")
		BehaviorFunctions.InMapTransport(739.29,162.3695,907.506)
		local dialog = BehaviorFunctions.GetNowPlayingId()
		if not dialog then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		end
		--看向终点镜头
		local fp1 = BehaviorFunctions.GetTerrainPositionP("BossTreasureBox",10020001,"Logic10020001_6")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		self.missionState = 1
	end

	if self.missionState == 1 then
		--如果玩家已经在战斗区域内则让玩家出去
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BossArea","Logic10020001_6")
		if not inArea then
			self.missionState = 2
		end
	end

	if self.missionState == 2 then
		BehaviorFunctions.ShowBlackCurtain(true,0,false)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1,false)
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",0)
		self.missionState = 3
	end
	
	if self.missionState == 4 then
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,true,1,true)
		BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0,true)
		BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,self.dialogList[2].Id)
		--BehaviorFunctions.PlayBgmSound("Bgm_TL_Jadei")--玉佩bgm
		BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.PlayBgmSound,"Bgm_TL_Jadei")
		--BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		self.missionState = 5
	end

end

function TaskBehavior101070102:CatchPartnerEnd()
	self.missionState = 4
	BehaviorFunctions.SendTaskProgress(101070102,1,1)
end

--死亡事件
function TaskBehavior101070102:Death(instanceId,isFormationRevive)

end

function TaskBehavior101070102:RemoveTask()

end

function TaskBehavior101070102:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101070102:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
			if self.dialogList[2].Id == dialogId then
				BehaviorFunctions.StopBgmSound()--停止玉佩BGM
				BehaviorFunctions.SetActiveBGM("TRUE")--开启默认BGM
				BehaviorFunctions.ShowPartnerTips(3003015)--离歌仲魔tips
				BehaviorFunctions.SendTaskProgress(101070102,1,1)
			end
		end
	end

end

--赋值
function TaskBehavior101070102:Assignment(variable,value)
	self[variable] = value
end