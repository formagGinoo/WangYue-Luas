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
		[1] = {Id = 101090601,state = self.dialogStateEnum.NotPlaying},--战斗结束后
		--[2] = {Id = 101090701,state = self.dialogStateEnum.NotPlaying},--获得配从后
	}

	self.initSetting = false
	self.guideFinish = false
end

function TaskBehavior101070102:Update()

	self.role = BehaviorFunctions.GetCtrlEntity()

	--初始化设置
	if self.initSetting == false then
		--离歌玉佩掉落生态实体创建状态
		BehaviorFunctions.ChangeEcoEntityCreateState(3001000010001,true)
		--关闭可攀爬状态
		BehaviorFunctions.SetClimbEnable(false)
		--设置受伤行走和受伤待机
		BehaviorFunctions.SetIdleType(self.role,FightEnum.EntityIdleType.InjuredIdle)
		BehaviorFunctions.SetEntityMoveMode(self.role,FightEnum.EntityMoveMode.InjuredWalk)
		--关闭按钮
		self:ShowButton(false)
		BehaviorFunctions.CancelJoystick()
		
		BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
		BehaviorFunctions.StopBgmSound()
		BehaviorFunctions.PlayBgmSound("Bgm_story_strings")
		local taskProcess = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		if taskProcess == 1 then
			self.missionState = 5
		end

		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		self.initSetting = true
	end

	if self.missionState == 0  then
		BehaviorFunctions.ShowBlackCurtain(false,1,false)
		--将玩家传送至战场中间
		local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_Jade",10020001,"Logic10020001_6")
		BehaviorFunctions.InMapTransport(tp1.x,tp1.y,tp1.z)
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		--屏蔽玩家除了移动外的按键
		--看向终点镜头
		if not self.empty then
			local fp1 = BehaviorFunctions.GetTerrainPositionP("BossTreasureBox",10020001,"Logic10020001_6")
			self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		end
		if not self.levelCam then
			self.levelCam = BehaviorFunctions.CreateEntity(22002)
		end
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		self.missionState = 1
	end

	if self.missionState == 1 then
		--如果玩家已经不在战斗区域内则让玩家回来
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Jade_Area2","Logic10020001_6")
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
		--关闭可攀爬状态
		BehaviorFunctions.SetClimbEnable(false)
		--设置受伤行走和受伤待机
		BehaviorFunctions.SetIdleType(self.role,FightEnum.EntityIdleType.InjuredIdle)
		BehaviorFunctions.SetEntityMoveMode(self.role,FightEnum.EntityMoveMode.InjuredWalk)
		BehaviorFunctions.ShowPartnerTips(3003015)--离歌仲魔tips
		BehaviorFunctions.SendTaskProgress(101070102,1,1)
		self.missionState = 5
	end
end

function TaskBehavior101070102:WorldInteractClick(uniqueId,instanceId)
	local ins = BehaviorFunctions.GetEcoEntityByEcoId(3001000010001)
	if BehaviorFunctions.CheckEntity(ins) then
		if instanceId == ins then
			if BehaviorFunctions.CheckEntity(self.levelCam) then
				BehaviorFunctions.RemoveEntity(self.levelCam)
			end
			if BehaviorFunctions.CheckEntity(self.empty) then
				BehaviorFunctions.RemoveEntity(self.empty)
			end
		end
	end
end

function TaskBehavior101070102:CatchPartnerEnd()
	--重置受伤动画状态
	BehaviorFunctions.PlayAnimation(self.role,"InjuredStand")
	----移除镜头
	--BehaviorFunctions.RemoveEntity(self.levelCam)
	--BehaviorFunctions.RemoveEntity(self.empty)
	self.missionState = 4
	BehaviorFunctions.SendTaskProgress(101070102,1,1)
end

--死亡事件
function TaskBehavior101070102:Death(instanceId,isFormationRevive)

end

function TaskBehavior101070102:RemoveTask()

end

--关闭按钮
function TaskBehavior101070102:ShowButton(bool)
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",bool) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"J",bool) --普攻
	BehaviorFunctions.SetFightMainNodeVisible(2,"O",bool) --跳跃
	BehaviorFunctions.SetFightMainNodeVisible(2,"K",bool) --疾跑
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",bool) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"R",bool) --仲魔
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",bool) --核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",bool,1)--隐藏能量条
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
		end
	end

end

--赋值
function TaskBehavior101070102:Assignment(variable,value)
	self[variable] = value
end