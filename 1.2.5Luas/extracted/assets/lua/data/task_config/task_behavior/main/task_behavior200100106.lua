TaskBehavior200100106 = BaseClass("TaskBehavior200100106")
--任务6:去激活大赐福
function TaskBehavior200100106:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.createLevelState = 0
	self.subTask = {
		{progressId = 1,currentCount = 0,setCount = 999},
		{progressId = 2,currentCount = 0,setCount = 999},
	}
	--剧情相关
	self.storyList = {
		{id = 1,storyState = 0,storyDialogId = 6001},  --打障碍前
		{id = 2,storyState = 0,storyDialogId = 7001},  --打障碍后
	}
	self.StoryStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.playingStoryId = 0
	--弱引导相关
	self.weakGuideList = {
		{id = 10001,state = 0},
	}
	self.checkFrame = 0
	self.guide = nil
	self.camGuide = true
	self.camGuideState = 0
end

function TaskBehavior200100106:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self:HideButton()
	self.transport = BehaviorFunctions.GetEcoEntityByEcoId(1103)
	self.frame = BehaviorFunctions.GetFightFrame()
	if self.taskState == 0 then
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,true)
		BehaviorFunctions.SetTaskGuideDisState(true)
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.guide = true
		self.frameStart = self.frame
		if BehaviorFunctions.HasBuffKind(self.role,900000010) then
			BehaviorFunctions.RemoveBuff(self.role,900000010)
		end
		self.taskState = 1
	end
	--相机指引
	if self.camGuide and self.camGuideState == 0 and self.frame > 10 then
		local camPos = BehaviorFunctions.GetTerrainPositionP("bigtransport1",10020001,"MVP_1")
		local camTarget = BehaviorFunctions.CreateEntity(2001,nil,camPos.x,camPos.y,camPos.z)
		local cam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(cam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(cam,camTarget)
		BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.RemoveEntity,cam)
		self.camGuideState = 1
	end
	--if self.taskState == 1 and self.frame > self.frameStart then
		--if not self.guide and self.transport  and BehaviorFunctions.GetDistanceFromTarget(self.role,self.transport) > 30 then
			--BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,true)
			--BehaviorFunctions.SetTaskGuideDisState(true)
			--self.guide = true
		--elseif self.guide and self.transport and BehaviorFunctions.GetDistanceFromTarget(self.role,self.transport) <= 30 then
			--BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
			--BehaviorFunctions.SetTaskGuideDisState(false)
			--self.guide = nil
		--end
	--end
	--if self.taskState == 1 and BehaviorFunctions.GetFightFrame() - self.checkFrame > 10 then
	--self.bigTransport = BehaviorFunctions.GetEcoEntityByEcoId(1103) --获取大赐福
	--if self.bigTransport and BehaviorFunctions.CheckEntity(self.bigTransport) then
	--if BehaviorFunctions.CheckEntityEcoState(self.bigTransport) then
	--BehaviorFunctions.SendGmExec("task_finish", {"200100105"})
	--self.bigTransport =nil
	--self.checkFrame = BehaviorFunctions.GetFightFrame()
	--end
	--end
	--end
end

function TaskBehavior200100106:RemoveTask()

end

function TaskBehavior200100106:HideButton()
	--BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	--BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	--BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	--BehaviorFunctions.SetFightMainNodeVisible(2,"R",false) --缔约
	--BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避
	--BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --地图
	--BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --攻击
	--BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
	--BehaviorFunctions.SetFightMainNodeVisible(2,"HeroProgress",false) --血条
end

function TaskBehavior200100106:PlayStory(storyListId,bindList,timeIn,timeOut,position,lookatPosition)
	if self.storyList then
		--遍历子任务列表，匹配传入Id
		for i = 1, #self.storyList do
			if storyListId == self.storyList[i].id then
				if self.storyList[i].storyState == self.StoryStateEnum.Default then
					--开始播剧情
					BehaviorFunctions.StartStoryDialog(self.storyList[i].storyDialogId,bindList,timeIn,timeOut,position,lookatPosition)
					--修改子任务列表中stortystate
					self.storyList[i].storyState = self.StoryStateEnum.Playing
					self.playingStoryId = self.storyList[i].id
					break
				end
			end
		end
	end
end

function TaskBehavior200100106:EnterArea(triggerInstanceId, areaName)

end

function TaskBehavior200100106:ExitArea(triggerInstanceId, areaName)

end

function TaskBehavior200100106:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100106:StoryStartEvent(dialogId)
	if self.storyList then
		for i = 1, #self.storyList do
			if self.storyList[i].storyDialogId == dialogId then
				self.storyList[i].storyState = self.StoryStateEnum.Playing
				break
			end
		end
	end
end

function TaskBehavior200100106:StoryEndEvent(dialogId)
	if self.storyList then
		for i = 1, #self.storyList do
			if self.storyList[i].storyDialogId == dialogId then
				self.storyList[i].storyState = self.StoryStateEnum.PlayOver
				self.playingStoryId = 0
				break
			end
		end
	end
end