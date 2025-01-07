TaskBehavior101070103 = BaseClass("TaskBehavior101070103")
--任务12 走出Boss场景

function TaskBehavior101070103.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101070103:__init(taskInfo)
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
		[1] = {Id = 101071001,state = self.dialogStateEnum.NotPlaying},--走了一段路之后播
		[2] = {Id = 102200101,state = self.dialogStateEnum.NotPlaying},--上一段播完后播
		[3] = {Id = 101090701,state = self.dialogStateEnum.NotPlaying},--获得配从后
	}

	self.initSetting = false
	self.guideFinish = false
	
	self.moveDazeTime = 8 --玩家移动多久进入昏迷(秒)
	self.totalMoveFrame = 0 --总计移动时间
	self.standDazeTime = 30 --如果玩家不移动多久进入昏迷（秒）
	self.standStartTime = 0 --玩家开始眩晕时间
	
	self.time = BehaviorFunctions.GetFightFrame()
end

function TaskBehavior101070103:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	--初始化设置
	if self.initSetting == false then
		--关闭可攀爬状态
		BehaviorFunctions.SetClimbEnable(false)
		--设置受伤行走和受伤待机
		BehaviorFunctions.SetIdleType(self.role,FightEnum.EntityIdleType.InjuredIdle)
		BehaviorFunctions.SetEntityMoveMode(self.role,FightEnum.EntityMoveMode.InjuredWalk)
		--隐藏按钮
		self:ShowButton(false)
		
		--进度检查
		local taskProgress = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		--玩家走完一段路
		if taskProgress == 1 then
			self.missionState = 4
			--玩家看完timeline1
		elseif taskProgress == 2 then
			self.missionState = 6
		end
		
		BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
		local taskProcess = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		if taskProcess == 1 then
			self.missionState = 4
		end

		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		self.initSetting = true
		
		--如果玩家不处于刚拿完玉佩的位置附近，则传回去
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Jade_Area","Logic10020001_6")
		if not inArea then
			local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_Jade",10020001,"Logic10020001_6")
			BehaviorFunctions.InMapTransport(tp1.x,tp1.y,tp1.z)
		end
	end

	if self.missionState == 0  then
		--看向终点镜头
		local fp1 = BehaviorFunctions.GetTerrainPositionP("BossTreasureBox",10020001,"Logic10020001_6")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		--self.levelCam = BehaviorFunctions.CreateEntity(22003)
		--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"Bip001")
		self.levelCam = BehaviorFunctions.CreateEntity(22002)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		self.standStartTime = BehaviorFunctions.GetFightFrame()
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		--检查仲魔引导是否完成
		if BehaviorFunctions.CheckGuideFinish(1017) == true and self.guideFinish == false then
			BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
			self.guideFinish = true
			self.missionState = 1.5
		end
	end

	if self.missionState == 2 then
		if not BehaviorFunctions.HasBuffKind(self.role,1000009) then
			--屏幕气绝特效
			BehaviorFunctions.AddBuff(self.role,self.role,1000009,1)
		end		
		--如果玩家在移动状态中
		local value = self.totalMoveFrame / (self.moveDazeTime * 30)
		if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Move then
			--local value = self.totalMoveFrame / (self.moveDazeTime * 30)
			BehaviorFunctions.ChangeCurtainAlpha(value)
			self.totalMoveFrame = self.totalMoveFrame + 1
		else
			if value > 0.8  then
				if self.totalMoveFrame < self.moveDazeTime * 30 then
					BehaviorFunctions.ChangeCurtainAlpha(value)
					self.totalMoveFrame = self.totalMoveFrame + 1
				end
			end
		end
		if value == 1 then
			BehaviorFunctions.ChangeCurtainAlpha(0)
			BehaviorFunctions.ShowBlackCurtain(true,0,true)
			self.missionState = 2.5
		end
	end

	if self.missionState == 2.5 then
		if not BehaviorFunctions.CheckEntityState(self.role,FightEnum.EntityState.Move) then
			--BehaviorFunctions.PlayAnimation(self.role,"Death")
			BehaviorFunctions.AddDelayCallByFrame(31,self,self.Assignment,"missionState",4)
			BehaviorFunctions.AddDelayCallByFrame(31,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1,false)
			BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			BehaviorFunctions.SendTaskProgress(101070103,1,1) 
			self.missionState = 3
		end
	end
	
	if self.missionState == 4 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		BehaviorFunctions.SetActiveBGM("FAlSE")--关闭默认BGM
		BehaviorFunctions.StopBgmSound()--停止BGM
		--BehaviorFunctions.PlayBgmSound("Bgm_TL_Jade")
		self.missionState = 5
	end
	
	if self.missionState == 6 then
		BehaviorFunctions.StopBgmSound()--停止玉佩BGM
		BehaviorFunctions.SetActiveBGM("TRUE")--开启默认BGM
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		self.missionState = 7
	end
	
	if 	self.missionState == 8 then
		self:DisablePlayerInput(false,false)
		self:ShowButton(true)
		--恢复可跑步
		BehaviorFunctions.SetIdleType(self.role,FightEnum.EntityIdleType.LeisurelyIdle)
		BehaviorFunctions.SetEntityMoveMode(self.role,FightEnum.EntityMoveMode.Run)
		--恢复可攀爬状态
		BehaviorFunctions.SetClimbEnable(true)
		BehaviorFunctions.SendTaskProgress(101070103,1,1)
		self.missionState = 9
	end

end

--死亡事件
function TaskBehavior101070103:Death(instanceId,isFormationRevive)

end

function TaskBehavior101070103:RemoveTask()

end

--关闭按钮
function TaskBehavior101070103:ShowButton(bool)
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",bool) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"J",bool) --普攻
	BehaviorFunctions.SetFightMainNodeVisible(2,"O",bool) --跳跃
	BehaviorFunctions.SetFightMainNodeVisible(2,"K",bool) --疾跑
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",bool) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"R",bool) --仲魔
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",bool) --核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",bool,1)--隐藏能量条
end

function TaskBehavior101070103:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101070103:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
			if self.dialogList[1].Id == dialogId then
				self.missionState = 6
				BehaviorFunctions.SendTaskProgress(101070103,1,1)
			elseif self.dialogList[2].Id == dialogId then
				self.missionState = 8
			elseif self.dialogList[3].Id == dialogId then
				self.missionState = 2
			end
		end
	end

end

--赋值
function TaskBehavior101070103:Assignment(variable,value)
	self[variable] = value
end

function TaskBehavior101070103:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end