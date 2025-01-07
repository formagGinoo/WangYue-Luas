TaskBehavior200100107 = BaseClass("TaskBehavior200100107")
--任务7：遇到刻刻
function TaskBehavior200100107:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.createLevelState = 0
	self.subTask = {
		{progressId = 1,currentCount = 0,setCount = 999},
		{progressId = 2,currentCount = 0,setCount = 999},
	}
	--剧情相关
	self.storyList = {
		{id = 1,storyState = 0,storyDialogId = 24001},  --遇到刻刻timeline
		{id = 2,storyState = 0,storyDialogId = 18001},  --timeline后对话
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
	self.addLevelState = 0
end

function TaskBehavior200100107:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self:HideButton()
	--设置追踪
	if self.taskState == 0 then
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,true)
		BehaviorFunctions.SetTaskGuideDisState(true)
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.taskState = 1
	end
end

function TaskBehavior200100107:RemoveTask()

end






function TaskBehavior200100107:HideButton()
	--BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	--BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	--BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	--BehaviorFunctions.SetFightMainNodeVisible(2,"R",false) --缔约
	--BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避
	--BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --地图
	----BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --攻击
	----BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
	----BehaviorFunctions.SetFightMainNodeVisible(2,"HeroProgress",false) --血条
end

function TaskBehavior200100107:PlayStory(storyListId,bindList,timeIn,timeOut,position,lookatPosition)
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

function TaskBehavior200100107:EnterArea(triggerInstanceId, areaName)
	if triggerInstanceId == self.role and self:CheckAreaName("StoryArea3","MVP_1", areaName) and self.addLevelState == 0 then
		BehaviorFunctions.AddLevel(30002)
		self.addLevelState = 1
	end

end

function TaskBehavior200100107:ExitArea(triggerInstanceId, areaName)

end


function TaskBehavior200100107:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100107:StoryStartEvent(dialogId)
	if self.storyList then
		for i = 1, #self.storyList do
			if self.storyList[i].storyDialogId == dialogId then
				self.storyList[i].storyState = self.StoryStateEnum.Playing
				break
			end
		end
	end
end

function TaskBehavior200100107:StoryEndEvent(dialogId)
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
