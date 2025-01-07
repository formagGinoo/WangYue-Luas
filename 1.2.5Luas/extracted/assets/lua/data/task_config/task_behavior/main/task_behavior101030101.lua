TaskBehavior101030101 = BaseClass("TaskBehavior101030101")
--任务3：叙慕跌落崖底timeline

function TaskBehavior101030101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030101:__init(taskInfo)
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
		[1] = {Id = 101030101,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101031001,state = self.dialogStateEnum.NotPlaying},
	}
	
	self.levelCam = nil
end

function TaskBehavior101030101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		--创建叙慕
		local pb1 = BehaviorFunctions.GetTerrainPositionP("pb1",10020001,"Logic10020001_6")
		local fp1 = BehaviorFunctions.GetTerrainPositionP("fp1",10020001,"Logic10020001_6")
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)
		--初始朝向镜头
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		----给叙慕扣血
		--local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001)
		--if currentLifeRatio > 5000 then
			--local currentLife = BehaviorFunctions.GetEntityAttrVal(self.role,1001)
			--local remainLife = currentLife * 0.5
			--BehaviorFunctions.SetEntityAttr(self.role,1001,remainLife)
		--end
		--关闭可攀爬状态
		BehaviorFunctions.SetClimbEnable(false)
		--设置受伤行走和受伤待机
		BehaviorFunctions.SetIdleType(self.role,FightEnum.EntityIdleType.InjuredIdle)
		BehaviorFunctions.SetEntityMoveMode(self.role,FightEnum.EntityMoveMode.InjuredWalk)
		self.missionState = 1
		
	elseif self.missionState == 1 then
		local result = BehaviorFunctions.CheckEntity(self.levelCam)
		if result == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
			local result = BehaviorFunctions.CheckEntity(self.levelCam)
			if result == true then
				BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			end
			self.missionState = 2
		end
		
	elseif self.missionState == 4 then
		--local result = BehaviorFunctions.CheckEntity(self.levelCam)
		--if result == true then
			--BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		--end
		--BehaviorFunctions.SendTaskProgress(101030101,1,1)
		self.missionState = 5
	end
end

function TaskBehavior101030101:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --普攻
	BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
	BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --疾跑
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end

function TaskBehavior101030101:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101030101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 2 and dialogId == self.dialogList[2].Id then
				BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
				self.missionState = 3
			elseif self.missionState == 3 and dialogId == self.dialogList[1].Id then
				self.missionState = 4
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end