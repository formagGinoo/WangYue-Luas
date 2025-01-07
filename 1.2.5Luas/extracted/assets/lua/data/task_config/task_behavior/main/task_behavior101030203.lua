TaskBehavior101030203 = BaseClass("TaskBehavior101030203")
--任务4：听到司命正在逼逼

function TaskBehavior101030203.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030203:__init(taskInfo)
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
end

function TaskBehavior101030203:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--关卡阶段1：叙慕在附近听到了司命的抱怨声
	if self.missionState == 0 then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		----弱引导推动摇杆
		--self:WeakGuide(self.weakGuide[1].Id)
		self.missionState = 1
		
	elseif self.missionState == 1 then
		
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Tips_Climb","Logic10020001_6")
		if inArea and self.imageGuideDuration < 1 then
			--图片引导爬墙教学
			BehaviorFunctions.ShowGuideImageTips(20001)
			self.imageGuideDuration = 1
		end
		
		--叙慕听到了司命的逼逼声
		local inArea2 = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010302Area03","Logic10020001_6")
		if inArea2 then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.missionState = 2
		end
		
	elseif self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(101030203,1,1)
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
			----隐藏疾跑弱引导
			--BehaviorFunctions.ShowWeakGuide(self.weakGuide[2].Id,true)
			----隐藏二段跳弱引导
			--BehaviorFunctions.ShowWeakGuide(self.weakGuide[3].Id,true)
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
			--BehaviorFunctions.ShowWeakGuide(self.weakGuide[4].Id,true)
			self.weakGuide[4].state = false
		end
	end
end

function TaskBehavior101030203:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101030203:WeakGuide(guideId)
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
function TaskBehavior101030203:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function TaskBehavior101030203:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101030203:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end