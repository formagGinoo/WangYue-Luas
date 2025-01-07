TaskBehavior200100202 = BaseClass("TaskBehavior200100202",LevelBehaviorBase)
--与三位npc对话了解现在的情况
function TaskBehavior200100202:__init(taskInfo)
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
	
	self.NPCIdentity = {
		{name = '安晴',ecoID = 402, taskDialogID = 30001,clueState = false,uniqueID = nil,instanceID = nil},
		{name = '于用',ecoID = 403, taskDialogID = 32001,clueState = false,uniqueID = nil,instanceID = nil},
		{name = '莉莉',ecoID = 404, taskDialogID = 28001,clueState = false,uniqueID = nil,instanceID = nil},
	}
	
	self.DialogInfo = {
		--Actor代表需要屏蔽的生态实体
		{DialogID = 30001 , Actor = {402}},
		{DialogID = 28001 , Actor = {404}},
		{DialogID = 32001 , Actor = {403}},
	}
	self.timeLineState = 0
	self.totalClue = 0
	self.currentTimeline = nil
	self.missionStep = 0
	self.taskProgress1 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
	self.taskProgress2 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,2)
	self.taskProgress3 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,3)
	self.taskProgress4 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,4)
end

function TaskBehavior200100202:Update()
	--查询任务完成状态
	self.taskProgress1 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
	self.taskProgress2 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,2)
	self.taskProgress3 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,3)
	self.taskProgress4 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,4)
	--处理当前任务进度
	self.totalClue = self.taskProgress1 + self.taskProgress2 + self.taskProgress3
	if self.taskProgress1 == 1 then
		self.NPCIdentity[1].clueState = true
	end
	if self.taskProgress2 == 1 then
		self.NPCIdentity[2].clueState = true
	end
	if self.taskProgress3 == 1 then
		self.NPCIdentity[3].clueState = true
	end
	
	--流程
	self.role = BehaviorFunctions.GetCtrlEntity()
	self:DialogCheck()
	if self.taskState == 0 then
		BehaviorFunctions.SetGuideTask(200100202)
		self.taskState = 1
	end
	
	if self.taskState == 1 then
		for index,value in ipairs(self.NPCIdentity) do
			if self.NPCIdentity[index].instanceID ~= nil and self.NPCIdentity[index].clueState == false then
				local value2 = nil
				if BehaviorFunctions.CheckEntity(self.NPCIdentity[index].instanceID) ~= false then
					value2 = BehaviorFunctions.GetEntityValue(self.NPCIdentity[index].instanceID,"diaLogState")
				end
				if value2 == true then
					BehaviorFunctions.SetEntityValue(self.NPCIdentity[index].instanceID,"taskDialog",nil)
					self.NPCIdentity[index].clueState = true
					self.totalClue = self.totalClue + 1
					
					if self.NPCIdentity[index].name == "安晴" then
						BehaviorFunctions.SendTaskProgress(200100202,1,1)
					elseif self.NPCIdentity[index].name == "于用" then
						BehaviorFunctions.SendTaskProgress(200100202,2,1)
					elseif self.NPCIdentity[index].name == "莉莉" then
						BehaviorFunctions.SendTaskProgress(200100202,3,1)
					end
					self.timeLineState = self.StoryStateEnum.Playing
				end
			end
		end
		
		--完成三个条件则播放timeline，且完成任务
		if self.totalClue == 3 then
			if self.timeLineState == self.StoryStateEnum.PlayOver then
				BehaviorFunctions.SendTaskProgress(200100202,4,1)
				BehaviorFunctions.StartStoryDialog(34001,{})
				self.timeLineState = self.StoryStateEnum.Playing
				self.taskState = 2
			end
		end
	end
	
	if self.taskState == 2 then
		if self.timeLineState == self.StoryStateEnum.PlayOver then
			self.taskState = 3
		end
	end
end

function TaskBehavior200100202:DialogCheck()
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

function TaskBehavior200100202:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	local ecoID = BehaviorFunctions.GetEntityEcoId(triggerInstanceId)
	for index,value in ipairs(self.NPCIdentity) do
		if ecoID == self.NPCIdentity[index].ecoID and self.NPCIdentity[index].clueState == false then
			BehaviorFunctions.SetEntityValue(triggerInstanceId,"taskDialog",self.NPCIdentity[index].taskDialogID)
			self.NPCIdentity[index].uniqueID = BehaviorFunctions.GetEntityValue(triggerInstanceId,"UniID")
			self.NPCIdentity[index].instanceID = triggerInstanceId
		elseif ecoID == self.NPCIdentity[index].ecoID and self.NPCIdentity[index].clueState == true then
			BehaviorFunctions.SetEntityValue(triggerInstanceId,"taskDialog",nil)
		end
	end
end


function TaskBehavior200100202:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	BehaviorFunctions.SetEntityValue(triggerInstanceId,"taskDialog",nil)
end

function TaskBehavior200100202:WorldInteractClick(uniqueId)

end

function TaskBehavior200100202:RemoveTask()
	
end

function TaskBehavior200100202:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function TaskBehavior200100202:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
end
