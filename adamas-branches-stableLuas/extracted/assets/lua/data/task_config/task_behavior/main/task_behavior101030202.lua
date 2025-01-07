TaskBehavior101030202 = BaseClass("TaskBehavior101030202")
--任务4：听到司命正在逼逼

function TaskBehavior101030202.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030202:__init(taskInfo)
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
		[1] = {Id = 101030201,state = self.dialogStateEnum.NotPlaying},
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
	
	self.imageGuideDuration = 0
	self.tipsTimer = 0
	self.taskGuide = nil
end

function TaskBehavior101030202:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--关卡阶段1：叙慕在附近听到了司命的抱怨声
	if self.missionState == 0 then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.missionState = 1
		
	elseif self.missionState == 1 then
		local tutorialArea2 = BehaviorFunctions.CheckEntityInArea(self.role,"Tips_Run","Logic10020001_6")
		if tutorialArea2 and self.weakGuide[2].state == false then
			--弱引导进行疾跑
			self:WeakGuide(self.weakGuide[2].Id)
			
		elseif tutorialArea2 and self.weakGuide[2].state == true then
			local frame = BehaviorFunctions.GetKeyPressFrame(FightEnum.KeyEvent.Dodge)
			if frame >= 30 then
				--隐藏引导
				self:RemoveWeakGuide()
			end
		end

		--叙慕走到了半路
		local inArea2 = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010302Area02","Logic10020001_6")
		if inArea2 then
			--隐藏引导
			self:RemoveWeakGuide()
			self.missionState = 2
		end
		
	elseif self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(101030202,1,1)
		self.missionState = 3
	end

	--攀爬跑墙辅助
	if self.missionState < 3 then
		self.time = BehaviorFunctions.GetFightFrame()
		if self.time > self.tipsTimer then
			self.weakGuide[4].state = false
			self.tipsTimer = 0
		end
		if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Climb then
			--隐藏引导
			self:RemoveWeakGuide()
			if self.weakGuide[4].state == false then
				if self.tipsTimer == 0 then
					self.tipsTimer = BehaviorFunctions.GetFightFrame()+150
					self:WeakGuide(self.weakGuide[4].Id)
				end
			end
		end
	end
	
	--关闭攀爬辅助
	if BehaviorFunctions.GetEntityState(self.role) ~= FightEnum.EntityState.Climb then
		if self.weakGuide[4].state == true then
			--隐藏引导
			self:RemoveWeakGuide()
			self.weakGuide[4].state = false
		end
	end
end

function TaskBehavior101030202:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101030202:WeakGuide(guideId)
	local result = false
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
		if v.Id == guideId then
			v.state = true
			result = true
		end
	end
	if result == true then
		BehaviorFunctions.PlayGuide(guideId,1,1)
	end
end

--关闭所有弱引导
function TaskBehavior101030202:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function TaskBehavior101030202:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101030202:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end