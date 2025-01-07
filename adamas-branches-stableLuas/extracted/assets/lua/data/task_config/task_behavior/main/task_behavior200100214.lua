TaskBehavior200100214= BaseClass("TaskBehavior200100214",LevelBehaviorBase)
--于静给玩家回礼
function TaskBehavior200100214:__init(taskInfo)
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
		{name = '于静',ecoID = 408, taskDialogID = 44001,clueState = false,uniqueID = nil,instanceID = nil},
	}
	
	self.DialogInfo = {
		--Actor代表需要屏蔽的生态实体
	}
	self.timeLineState = 0
	self.totalClue = 0
	self.currentTimeline = nil
	self.missionStep = 0
end



function TaskBehavior200100214:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self:DialogCheck()
	--self:CheckTimelienState()
	if self.taskState == 0 then

		self.taskState = 1
	end
	
	if self.taskState == 1 then
		for index,value in ipairs(self.NPCIdentity) do
			if BehaviorFunctions.CheckEntity(self.NPCIdentity[index].instanceID) then
				if self.NPCIdentity[index].instanceID ~= nil and self.NPCIdentity[index].clueState == false then
					local value = BehaviorFunctions.GetEntityValue(self.NPCIdentity[index].instanceID,"diaLogState")
					if value == true then
						BehaviorFunctions.SetEntityValue(self.NPCIdentity[index].instanceID,"taskDialog",nil)
						self.NPCIdentity[index].clueState = true
					end
				end
			end
		end
		if self.NPCIdentity[1].clueState == true then
			self.taskState = 2
		end
	end
	if self.taskState == 2 then
		if self.timeLineState == self.StoryStateEnum.PlayOver then
			BehaviorFunctions.SendTaskProgress(200100214,1,1)
			self.taskState = 3
		end
	end
end

function TaskBehavior200100214:DialogCheck()
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

function TaskBehavior200100214:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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


function TaskBehavior200100214:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	BehaviorFunctions.SetEntityValue(triggerInstanceId,"taskDialog",nil)
end

--function TaskBehavior200100214:CheckTimelienState()
	--if BehaviorFunctions.GetStoryPlayState() == true and self.timeLineState ~= self.StoryStateEnum.Playing then
		--self.timeLineState = self.StoryStateEnum.Playing

	--elseif BehaviorFunctions.GetStoryPlayState() == false and self.timeLineState == self.StoryStateEnum.Playing then
		--self.timeLineState = self.StoryStateEnum.PlayOver

	--elseif BehaviorFunctions.GetStoryPlayState() == false and self.timeLineState == self.StoryStateEnum.PlayOver then
		--self.timeLineState = self.StoryStateEnum.NotPlaying
	--end
	--return self.timeLineState
--end

function TaskBehavior200100214:WorldInteractClick(uniqueId)

end

function TaskBehavior200100214:RemoveTask()
	
end

function TaskBehavior200100214:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function TaskBehavior200100214:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
end
