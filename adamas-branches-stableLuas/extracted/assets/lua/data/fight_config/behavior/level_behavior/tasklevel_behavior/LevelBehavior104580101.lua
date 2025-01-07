LevelBehavior104580101 = BaseClass("LevelBehavior104580101",LevelBehaviorBase)
--任务13 见到大世界

function LevelBehavior104580101.GetGenerates()
	local generates = {}
	return generates
end

function LevelBehavior104580101:__init(taskInfo)
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
		--[1] = {Id = 102200201,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 102200301,state = self.dialogStateEnum.NotPlaying},
		[3] = {Id = 102200401,state = self.dialogStateEnum.NotPlaying},
	}
	--玩家复活点
	self.currentCheckPoint = "checkPoint11"
	--玩家下个目标点
	self.nextTargetPos = "checkPoint12"

	self.trace = false
	self.initSetting = false
	self.guideFinish = false
	self.time = 0
	self.timeStart = 0
end

function LevelBehavior104580101:Update()

	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)


	--if self.trace == false then
		------更新任务追踪
		----BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		--self.trace = true
	--end

	--初始化设置
	if self.initSetting == false then
		self:ShowButton(true)
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--隐藏任务追踪
		BehaviorFunctions.SetGuideShowState(4,false)
		BehaviorFunctions.SetTipsGuideState(false)
		self.initSetting = true
	end

	--发现大世界，出门
	if self.missionState == 0 then
		if self.time - self.timeStart >= 30 then
			--看向终点镜头
			local fp1 = BehaviorFunctions.GetTerrainPositionP("BossTreasureBox",10020001,"Logic104580101")
			self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
			self.levelCam = BehaviorFunctions.CreateEntity(22001)
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
			--延迟移除目标和镜头
			BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			--将玩家传送至战场中间
			--local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_BossCenter",10020001,"Logic104580101")
			--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
			--BehaviorFunctions.InMapTransport(tp1.x,tp1.y,tp1.z)
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
			self.missionState = 1
		end
	end

	if self.missionState == 1 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Level104580101Area01","Logic104580101")
		if inArea then
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
			self.missionState = 2
		end
	end

	if self.missionState == 2  then
	end

	if self.missionState == 3 then
		BehaviorFunctions.FinishLevel(104580101)
		self.missionState = 4
	end
end

--死亡事件
function LevelBehavior104580101:Death(instanceId,isFormationRevive)

end

function LevelBehavior104580101:RemoveTask()

end

function LevelBehavior104580101:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function LevelBehavior104580101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
	--if dialogId == self.dialogList[1].Id then
		--BehaviorFunctions.ShowPartnerTips(3003015)--离歌仲魔tips
		----显示任务追踪
		--BehaviorFunctions.SetGuideShowState(4,true)
		--BehaviorFunctions.SetTipsGuideState(true)
		------看向终点镜头
		----local fp1 = BehaviorFunctions.GetTerrainPositionP("fp3",10020001,"Logic10020001_6")
		----self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		----self.levelCam2 = BehaviorFunctions.CreateEntity(22002)
		----BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
		----BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
		------延迟移除目标和镜头
		----BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
		----BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
		--self:ShowButton(true)
	--end
	if dialogId == self.dialogList[2].Id then
		if self.dialogList[3].state ~= self.dialogStateEnum.Playing then
			local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
			BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
			BehaviorFunctions.AddLevel(102010301)
			BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
			self.dialogList[3].state = self.dialogStateEnum.Playing
		end
	end
	if dialogId == self.dialogList[3].Id then
		self.missionState = 3
	end
end

--关闭按钮
function LevelBehavior104580101:ShowButton(bool)
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",bool) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"J",bool) --普攻
	BehaviorFunctions.SetFightMainNodeVisible(2,"O",bool) --跳跃
	BehaviorFunctions.SetFightMainNodeVisible(2,"K",bool) --疾跑
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",bool) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"R",bool) --仲魔
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",bool) --核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",bool,1)--隐藏能量条
end