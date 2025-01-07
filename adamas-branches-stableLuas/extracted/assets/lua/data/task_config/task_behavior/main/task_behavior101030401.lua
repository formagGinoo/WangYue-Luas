TaskBehavior101030401 = BaseClass("TaskBehavior101030401")
--任务6：青乌需要解救司命

function TaskBehavior101030401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030401:__init(taskInfo)
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
		--[1] = {Id = 101030401,state = self.dialogStateEnum.NotPlaying},
		--[2] = {Id = 101030701,state = self.dialogStateEnum.NotPlaying},
	}
	
	self.imageGuideDuration = 0
	self.tipsTimer = 0
	self.flower1 = nil
	self.flower1die = false
	
	self.trace = false
	self.currentProgress = 0
end

function TaskBehavior101030401:Update()
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.flower1 = BehaviorFunctions.GetEcoEntityByEcoId(2001001010001)
	
	if self.trace == false then
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		--更新任务进度
		self.currentProgress = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		--如果花墙已经死亡则直接进入timeline
		if self.currentProgress == 1 then
			self.missionState = 2
		end
		--隐藏按钮
		self:HideButton()
		self.trace = true
	end
	
	if self.missionState == 0 then
		self.flower1 = BehaviorFunctions.GetEcoEntityByEcoId(2001001010001)
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		if BehaviorFunctions.CheckEntity(self.flower1) then
			local dis = BehaviorFunctions.GetDistanceFromTarget(self.role,self.flower1,false)
			--弱引导普攻
			if self.weakGuide[5].state == false then
				if dis <= 8 then
					self:WeakGuide(self.weakGuide[5].Id)
					self.weakGuide[5].state = true
				end
			else
				if dis > 8 then
					self:RemoveWeakGuide()
					self.weakGuide[5].state = false
				end
			end
		end
	end
	
	--花死了播timeline
	if self.missionState == 2 then
		--BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 3
	end
	
	--播放timeline结束
	if self.missionState == 4 then
		--BehaviorFunctions.SendTaskProgress(101030401,1,1)
		self.missionState = 5
	end
end

function TaskBehavior101030401:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end

function TaskBehavior101030401:Die(attackInstanceId,dieInstanceId)
	if self.flower1 ~= nil and dieInstanceId == self.flower1 then
		if self.weakGuide[5].state == true then
			self:RemoveWeakGuide()
			self.weakGuide[5].state = false
		end
	end
end


function TaskBehavior101030401:Death(dieinstanceId,isFormationRevive)
	if self.flower1 ~= nil and dieinstanceId == self.flower1 then
		if self.missionState == 1 then
			--BehaviorFunctions.SendTaskProgress(101030401,1,1)
			self.missionState = 2
		end
	end
end


--开启弱引导，并且关闭其他弱引导
function TaskBehavior101030401:WeakGuide(guideId)
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
function TaskBehavior101030401:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function TaskBehavior101030401:Collide(attackInstanceId,hitInstanceId)
	----司命挨打播放对话
	--if attackInstanceId == self.role and hitInstanceId == self.flower1 then
		--if self.dialogList[2].state == self.dialogStateEnum.NotPlaying then
			--if not BehaviorFunctions.GetStoryPlayState() then
				--if BehaviorFunctions.GetEntityAttrValueRatio(self.flower1,1001) >= 1500 then
					--BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
				--end
			--end
		--end
	--end
end

function TaskBehavior101030401:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101030401:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 3 and dialogId == self.dialogList[1].Id then
				self.missionState = 4
			end
			v.state = self.dialogStateEnum.PlayOver
			--司命对话重复
			if self.missionState == 1 and dialogId == self.dialogList[2].Id then
				v.state = self.dialogStateEnum.NotPlaying
			end
			self.currentDialog = nil
		end		
	end
end