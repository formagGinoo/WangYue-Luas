TaskBehavior101030301 = BaseClass("TaskBehavior101030301")
--任务5：青乌看到困在花墙上的司命

function TaskBehavior101030301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030301:__init(taskInfo)
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
	self.dialogList =
	{
		[1] = {Id = 101030301,state = self.dialogStateEnum.NotPlaying},
	}
	
	self.imageGuideDuration = 0
	self.tipsTimer = 0
	self.trace = false
end

function TaskBehavior101030301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.trace == false then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	--叙慕在附近找到了司命
	if self.missionState == 0 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010303Area01","Logic10020001_6")
		if inArea then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.missionState = 1
		end
	end
		
	if self.missionState == 2  then
		----图片引导爬清除淤脉
		--BehaviorFunctions.ShowGuideImageTips(20003)
		BehaviorFunctions.SendTaskProgress(101030301,1,1)
		self.missionState = 3
	end
end

function TaskBehavior101030301:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end


--开启弱引导，并且关闭其他弱引导
function TaskBehavior101030301:WeakGuide(guideId)
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
function TaskBehavior101030301:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function TaskBehavior101030301:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101030301:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 1 and dialogId == self.dialogList[1].Id then
				self.missionState = 2
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end