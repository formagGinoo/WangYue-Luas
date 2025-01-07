TaskBehavior200100102 = BaseClass("TaskBehavior200100102")
--任务2:破坏花

function TaskBehavior200100102.GetGenerates()
	local generates = {2030201}
	return generates
end


function TaskBehavior200100102:__init(taskInfo)
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
		{id = 10002,state = 0}, --普攻
	}
	self.rebornFrame = 0
	self.guideState = nil
end

function TaskBehavior200100102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.taskState == 0 then
		self:HideButton()
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.taskState = 1
	end
end

function TaskBehavior200100102:RemoveTask()

end

function TaskBehavior200100102:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"R",false) --缔约
	BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --攻击
end

function TaskBehavior200100102:PlayStory(storyListId,bindList,timeIn,timeOut,position,lookatPosition)
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


function TaskBehavior200100102:EnterArea(triggerInstanceId, areaName)
	if triggerInstanceId == self.role and self:CheckAreaName("AttackTeach","MVP_1", areaName)then
		if self.guideState == nil then
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --攻击
			BehaviorFunctions.ShowWeakGuide(10002)
			self:PlayStory(1)
			self.guideState = 1
		end
	end
end

function TaskBehavior200100102:ExitArea(triggerInstanceId, areaName)

end

--function TaskBehavior200100102:Death(instanceId, isFormationRevive)
	----打死花，任务完成
	--if instanceId == self.flower then
		--BehaviorFunctions.SendGmExec("task_finish", {"200100102"})
		--self.rebornFrame = BehaviorFunctions.GetFightFrame()
		--self.flower = nil
	--end
--end

function TaskBehavior200100102:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100102:StoryStartEvent(dialogId)
	if self.storyList then
		for i = 1, #self.storyList do
			if self.storyList[i].storyDialogId == dialogId then
				self.storyList[i].storyState = self.StoryStateEnum.Playing
				break
			end
		end
	end
end

function TaskBehavior200100102:StoryEndEvent(dialogId)
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