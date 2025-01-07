TaskBehavior200100201 = BaseClass("TaskBehavior200100201",LevelBehaviorBase)
--击败贝露贝特后前往熙来
function TaskBehavior200100201:__init(taskInfo)
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
		--进城门的多闻
		{DialogID = 25001 , Actor = {405}}
	}
	self.subTaskPlayingId = 0

end

function TaskBehavior200100201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self:DialogCheck()
	if self.taskState == 0 then
		self.taskState = 0.1
	end
	
	if self.taskState == 0.1 and BehaviorFunctions.GetNowPlayingId() == nil then
		BehaviorFunctions.SetGuideTask(200100201)
		self.taskState = 0.5
	end
	
	if self.taskState == 1 then
		BehaviorFunctions.StartStoryDialog(25001,{})
		self.timeLineState = self.StoryStateEnum.Playing
		self.taskState = 2
	end
	
	if self.taskState == 2 then
		if self.timeLineState == self.StoryStateEnum.PlayOver then
			BehaviorFunctions.ShowCommonTitle(1,"熙来",true)
			BehaviorFunctions.SendTaskProgress(200100201,1,1)
			self.taskState = 3
		end
	end
end

function TaskBehavior200100201:DialogCheck()
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

function TaskBehavior200100201:RemoveTask()
	
end

function TaskBehavior200100201:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100201:EnterArea(triggerInstanceId, areaName)
	local area = self:CheckAreaName("XilaiArea","Logic10020001_5",areaName)
	if area == true and self .taskState < 1 then
		--BehaviorFunctions.ShowCommonTitle(1,"熙来",true)
		self.taskState = 1
	end
end

function TaskBehavior200100201:ExitArea(triggerInstanceId, areaName)

end

function TaskBehavior200100201:StoryStartEvent(dialogId)
	for i,v in ipairs(self.DialogInfo) do
		if v.DialogID == dialogId then
			self.timeLineState = self.StoryStateEnum.Playing
		end
	end
end

function TaskBehavior200100201:StoryEndEvent(dialogId)
	for i,v in ipairs(self.DialogInfo) do
		if v.DialogID == dialogId then
			self.timeLineState = self.StoryStateEnum.PlayOver
		end
	end
end