TaskBehavior200100108 = BaseClass("TaskBehavior200100108")
--任务8：去打boss
function TaskBehavior200100108:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.createLevelState = 0
	self.subTask = {
		{progressId = 1,currentCount = 0,setCount = 999},
		{progressId = 2,currentCount = 0,setCount = 999},
	}
	--剧情相关
	self.storyList = {
		{id = 1,storyState = 0,storyDialogId = 19001},
		{id = 2,storyState = 0,storyDialogId = 77001},
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
		{id = 10004,state = 0},
	}
	self.bossGuide = nil
	self.shootGuide = nil
	self.canGuide = false
end

function TaskBehavior200100108.GetGenerates()
	local generates = {21007}
	return generates
end

function TaskBehavior200100108:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--设置追踪
	if self.taskState == 0 then
		if BehaviorFunctions.CheckEntityInArea(self.role,"BossTrigger","Logic10020001_5") then
			--把玩家传送回副本门口
			--BehaviorFunctions.DoSetPosition(self.role,241.76,65.12,478.92)
			BehaviorFunctions.InMapTransport(241.76,65.12,478.92)
		end
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.taskState = 1
		--local position = BehaviorFunctions.GetTerrainPositionP("BossPosition",10020001,"Logic10020001_5")
		--self.bossGuide = BehaviorFunctions.CreateEntity(21007,nil,position.x,position.y,position.z)
	end
	--处理角色
	if self.taskState == 1 then
		if BehaviorFunctions.CheckRoleExist(1001002) == true then
			if 	BehaviorFunctions.CheckRoleInCurFormation(1001002) == false then
				self.canGuide = true
				BehaviorFunctions.UpdateCurFomration({1001001,1001002})
			elseif BehaviorFunctions.CheckRoleInCurFormation(1001002) == true and self.canGuide == true then
				--BehaviorFunctions.ShowWeakGuide(10004)
				BehaviorFunctions.ShowTip(3001010)
				BehaviorFunctions.ShowGuidTip(101002)
				self:PlayStory(1)
				self.taskState	= 999
			end
		end
	end
	if not self.shootGuide and BehaviorFunctions.GetEntityTemplateId(self.role) == 1002 and self.canGuide == true then
		BehaviorFunctions.ShowGuideImageTips(10018)
		self.shootGuide = true
	end
end

function TaskBehavior200100108:RemoveTask()

end

function TaskBehavior200100108:PlayStory(storyListId,bindList,timeIn,timeOut,position,lookatPosition)
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

function TaskBehavior200100108:EnterArea(triggerInstanceId, areaName)
	if triggerInstanceId == self.role and self:CheckAreaName("BossTrigger2","Logic10020001_5", areaName) then
		BehaviorFunctions.RemoveEntity(self.bossGuide)
		BehaviorFunctions.ActiveSceneObj("born",false,10020001)
		BehaviorFunctions.CreateDuplicate(1004)
		self:PlayStory(1)
	end
	--if triggerInstanceId == self.role and self:CheckAreaName("ShootGuide","MVP_1", areaName) then
		--self:PlayStory(2)
	--end
end

function TaskBehavior200100108:ExitArea(triggerInstanceId, areaName)

end


function TaskBehavior200100108:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100108:StoryStartEvent(dialogId)
	if self.storyList then
		for i = 1, #self.storyList do
			if self.storyList[i].storyDialogId == dialogId then
				self.storyList[i].storyState = self.StoryStateEnum.Playing
				break
			end
		end
	end
end

function TaskBehavior200100108:StoryEndEvent(dialogId)
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
