TaskBehavior200100215= BaseClass("TaskBehavior200100215",LevelBehaviorBase)
--救回于静后与多闻了解被封印的城门的事
function TaskBehavior200100215:__init(taskInfo)
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
		{name = '多闻',ecoID = 409, taskDialogID = 55001,clueState = false,uniqueID = nil,instanceID = nil},
	}
	
	self.DialogInfo = {
		--Actor代表需要屏蔽的生态实体
		{DialogID = 55001 , Actor = {409}},
	}
	self.timeLineState = 0
	self.totalClue = 0
	self.currentTimeline = nil
end



function TaskBehavior200100215:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self:DialogCheck()
	--self:CheckTimelienState()
	if self.taskState == 0 then
		if self.StoryStateEnum.PlayOver and BehaviorFunctions.GetNowPlayingId() == nil then
			BehaviorFunctions.StartStoryDialog(54001)
			self.taskState = 0.5
		end
	end
	
	if self.taskState == 1 then
		for index,value in ipairs(self.NPCIdentity) do
			if self.NPCIdentity[index].instanceID ~= nil and self.NPCIdentity[index].clueState == false then
				if BehaviorFunctions.CheckEntity(self.NPCIdentity[index].instanceID) == true then
					local value = BehaviorFunctions.GetEntityValue(self.NPCIdentity[index].instanceID,"diaLogState")
					if value == true then
						BehaviorFunctions.SetEntityValue(self.NPCIdentity[index].instanceID,"taskDialog",nil)
						self.NPCIdentity[index].clueState = true
						self.taskState = 1.5
						--local pos = BehaviorFunctions.GetTerrainPositionP("P55001",10020001,"Logic10020001_5")
						--BehaviorFunctions.DoSetPositionOffset(self.role,pos.x,pos.y,pos.z)
					end
				end
			end
		end
	end
	
	if self.taskState == 2 then
		if self.StoryStateEnum.PlayOver then
			BehaviorFunctions.StartStoryDialog(56001)
			self.taskState = 3
		end
	end
	
	if self.taskState == 3 then
		BehaviorFunctions.SendTaskProgress(200100215,1,1)
		self.taskState = 4
	end
end

function TaskBehavior200100215:DialogCheck()
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

function TaskBehavior200100215:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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


function TaskBehavior200100215:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	BehaviorFunctions.SetEntityValue(triggerInstanceId,"taskDialog",nil)
end

--function TaskBehavior200100215:CheckTimelienState()
	--if BehaviorFunctions.GetStoryPlayState() == true and self.timeLineState ~= self.StoryStateEnum.Playing then
		--self.timeLineState = self.StoryStateEnum.Playing

	--elseif BehaviorFunctions.GetStoryPlayState() == false and self.timeLineState == self.StoryStateEnum.Playing then
		--self.timeLineState = self.StoryStateEnum.PlayOver

	--elseif BehaviorFunctions.GetStoryPlayState() == false and self.timeLineState == self.StoryStateEnum.PlayOver then
		--self.timeLineState = self.StoryStateEnum.NotPlaying
	--end
	--return self.timeLineState
--end

function TaskBehavior200100215:WorldInteractClick(uniqueId)

end

function TaskBehavior200100215:RemoveTask()
	
end

function TaskBehavior200100215:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function TaskBehavior200100215:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
	if dialogId == 54001 then
		BehaviorFunctions.SetGuideTask(200100215)
		self.taskState = 1
	elseif dialogId == 55001 then
		self.taskState = 2
	end
end
