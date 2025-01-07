TaskBehavior200100203 = BaseClass("TaskBehavior200100203",LevelBehaviorBase)
--与辉光蜻蜓的工作人员对话得知店员被抓走
function TaskBehavior200100203:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.createLevelState = 0
	self.subTask = {

	} 
	self.StoryStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
		}

	self.DialogInfo = {
		--Actor代表需要屏蔽的生态实体
		{DialogID = 35001 , Actor = {406}},
	}
	
	self.subTaskPlayingId = 0

end

function TaskBehavior200100203:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self:DialogCheck()
	--self:CheckTimelienState()
	if self.taskState == 0 then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.taskState = 0.5
	end
	if self.taskState == 2 then
		BehaviorFunctions.StartStoryDialog(35001)
		self.timeLineState = self.StoryStateEnum.Playing
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.DoSetPosition,self.role,335.596,65.4,694.356)
		self.taskState = 3
	end

	if self.taskState == 3 then
		if self.timeLineState == self.StoryStateEnum.PlayOver then
			BehaviorFunctions.ShowWeakGuide(10006)--指引玩家利用地图传送
			BehaviorFunctions.SendTaskProgress(200100206,1,1)
			self.taskState = 4
		end
	end
end

function TaskBehavior200100203:RemoveTask()
	
end

function TaskBehavior200100203:DialogCheck()
	--local timeLineState = self:CheckTimelienState()
	local timeLineState = self.timeLineState
	local player = BehaviorFunctions.GetCtrlEntity()
	if timeLineState == self.StoryStateEnum.Playing then
		self.currentTimeline = BehaviorFunctions.GetNowPlayingId()
		for index,infor in ipairs(self.DialogInfo) do
			if self.DialogInfo[index].DialogID == self.currentTimeline then
				local ActorList = self.DialogInfo[index].Actor
				for List,actor in ipairs(ActorList) do
					local NPCInstance = BehaviorFunctions.GetEcoEntityByEcoId(actor)
					if NPCInstance ~= nil then
						--隐藏对话NPC模型
						if BehaviorFunctions.HasBuffKind(NPCInstance,900000010) == false then
							BehaviorFunctions.DoMagic(NPCInstance,NPCInstance,900000010)
						end
					end
				end
				--隐藏玩家模型
				if BehaviorFunctions.HasBuffKind(player,900000010) == false then
					BehaviorFunctions.DoMagic(player,player,900000010)
				end
			end
		end
	elseif timeLineState == self.StoryStateEnum.PlayOver and self.currentTimeline ~= nil then
		local player = BehaviorFunctions.GetCtrlEntity()
		for index,infor in ipairs(self.DialogInfo) do
			if self.DialogInfo[index].DialogID == self.currentTimeline then
				local ActorList = self.DialogInfo[index].Actor
				for List,actor in ipairs(ActorList) do
					local NPCInstance = BehaviorFunctions.GetEcoEntityByEcoId(actor)
					if NPCInstance ~= nil then
						--显示对话NPC模型
						if BehaviorFunctions.HasBuffKind(NPCInstance,900000010) == true then
							BehaviorFunctions.RemoveBuff(NPCInstance,900000010)
						end
					end
				end
				--显示对话玩家模型
				if BehaviorFunctions.HasBuffKind(player,900000010) == true then
					BehaviorFunctions.RemoveBuff(player,900000010)
				end
			end
		end
		self.currentTimeline = nil
	end
end

--function TaskBehavior200100203:CheckTimelienState()
	--if BehaviorFunctions.GetStoryPlayState() == true and self.timeLineState ~= self.StoryStateEnum.Playing then
		--self.timeLineState = self.StoryStateEnum.Playing

	--elseif BehaviorFunctions.GetStoryPlayState() == false and self.timeLineState == self.StoryStateEnum.Playing then
		--self.timeLineState = self.StoryStateEnum.PlayOver

	--elseif BehaviorFunctions.GetStoryPlayState() == false and self.timeLineState == self.StoryStateEnum.PlayOver then
		--self.timeLineState = self.StoryStateEnum.NotPlaying
	--end
	--return self.timeLineState
--end

function TaskBehavior200100203:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100203:EnterArea(triggerInstanceId, areaName)
	local area = self:CheckAreaName("HuiGuangArea","Logic10020001_5",areaName)
	if area == true then
		self.taskState = 2
	end
end

function TaskBehavior200100203:ExitArea(triggerInstanceId, areaName)

end

function TaskBehavior200100203:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function TaskBehavior200100203:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
end