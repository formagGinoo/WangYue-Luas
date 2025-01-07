TaskBehavior101030501 = BaseClass("TaskBehavior101030501")
--任务3.1：叙慕摔伤需要采集草药

function TaskBehavior101030501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030501:__init(taskInfo)
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
		--[1] = {Id = 101030501,state = self.dialogStateEnum.NotPlaying},--青乌扭到脚timeline
		
		[1] = {Id = 101031201,state = self.dialogStateEnum.NotPlaying},--版署包青乌扭到脚timeline
	}
	
	
	self.weakGuide =
	{
		[1] = {Id = 2011,state = false,Describe ="推动摇杆进行移动"},
		[2] = {Id = 2012,state = false,Describe ="长按进入跑步状态"},
		[3] = {Id = 2013,state = false,Describe ="连续点击2次跳跃可二段跳"},
		[4] = {Id = 2014,state = false,Describe ="长按在墙面上奔跑"},
		[5] = {Id = 2015,state = false,Describe ="点击按钮使用普通攻击"},
		[6] = {Id = 2016,state = false,Describe ="普攻积攒日相能量"},
		[7] = {Id = 2017,state = false,Describe ="消耗日相能量释放技能"},
		[8] = {Id = 2018,state = false,Describe ="点击按钮释放绝技"},
		[9] = {Id = 2019,state = false,Describe ="消耗日相能量释放技能"},
	}
	
	self.seaWeed = 
	{
		[1] = {Id = 3001001010001},
		[2] = {Id = 3001001010002},
		[3] = {Id = 3001001010003},
		[4] = {Id = 3001001010004},
		[5] = {Id = 3001001010005},
		[6] = {Id = 3001001010006},
		[7] = {Id = 3001001010007},
	}
	
	self.seaWeedEntityID = 2010208
	self.levelCam = nil

end

function TaskBehavior101030501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		----模拟叙慕摔伤腿的情况
		----给叙慕扣血
		--local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001)
		--if currentLifeRatio > 5000 then
			--local currentLife = BehaviorFunctions.GetEntityAttrVal(self.role,1001)
			--local remainLife = currentLife * 0.5
			--BehaviorFunctions.SetEntityAttr(self.role,1001,remainLife)
		--end
		--看向目标相机
		local fp1 = BehaviorFunctions.GetTerrainPositionP("fp1",10020001,"Logic10020001_6")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.empty)
		if distance > 10 then
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		end
		--关闭可攀爬状态
		BehaviorFunctions.SetClimbEnable(false)
		--设置受伤行走和受伤待机
		BehaviorFunctions.SetIdleType(self.role,FightEnum.EntityIdleType.InjuredIdle)
		BehaviorFunctions.SetEntityMoveMode(self.role,FightEnum.EntityMoveMode.InjuredWalk)
		--播放叙慕喊疼timeline
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 1
	end
	
	--timeline播放结束
	if self.missionState == 2 then
		--移除看向目标相机
		local result = BehaviorFunctions.CheckEntity(self.levelCam)
		if result == true then
			BehaviorFunctions.RemoveEntity(self.levelCam)
		end
		--弱引导推动摇杆
		self:WeakGuide(self.weakGuide[1].Id)
		self.missionState = 3
	end
	
	--药草还没有被采摘
	if self.missionState == 3 then

	end
	
	--	如果药草被采摘
	if self.missionState == 4 then
		--BehaviorFunctions.SendTaskProgress(101030501,1,1)
		self.missionState = 5
	end
end

function TaskBehavior101030501:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerEntityId == self.seaWeedEntityID then
			self:RemoveWeakGuide()
		end
	end
end

function TaskBehavior101030501:RemoveEntity(instanceId)
	--采集到草就可以通过任务了了
	for i,v in ipairs (self.seaWeed) do
		local result = BehaviorFunctions.CheckEcoEntityState(v.Id)
		if result == false then
			--隐藏推动摇杆弱引导
			self:RemoveWeakGuide()
			self.missionState = 4
		end
	end
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101030501:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.PlayGuide(guideId,1,1)
			v.state = true
		elseif v.Id ~= guideId then
			BehaviorFunctions.FinishGuide(v.Id,1)
		end
	end
end

--关闭所有弱引导
function TaskBehavior101030501:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function TaskBehavior101030501:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --普攻
	BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
	BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --疾跑
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end

function TaskBehavior101030501:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101030501:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[1].Id then
				self.missionState = 2
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end