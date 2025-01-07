TaskBehavior200100217= BaseClass("TaskBehavior200100217",LevelBehaviorBase)
--前往去打开大门
function TaskBehavior200100217:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.createLevelState = 0
	self.subTask = {

	} 
	self.storyStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
		}
	self.timeLineState = 0
	self.totalClue = 0
	self.currentTimeline = nil
	self.DialogInfo = {
		--Actor代表需要屏蔽的生态实体
		{DialogID = 53001 , Actor = {}},
	}
end



function TaskBehavior200100217:Update()
	self:DialogCheck()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.taskState == 0 then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		local GateID = BehaviorFunctions.GetEcoEntityByEcoId(40011)
		if GateID ~= nil then
			if BehaviorFunctions.CheckEntity(GateID) then
				BehaviorFunctions.SetEntityValue(GateID,"condition",true)
				self.gateUniqueID = BehaviorFunctions.GetEntityValue(GateID,"myUniqueID")
				self.gateIns = GateID
			end
		end
	end
	if self.taskState == 1 then
		BehaviorFunctions.SendTaskProgress(200100217,1,1)
	end
end

function TaskBehavior200100217:WorldInteractClick(uniqueId)
	if uniqueId == self.gateUniqueID then
		BehaviorFunctions.InteractEntityHit(self.gateIns,FightEnum.SysEntityOpType.Death)
		if BehaviorFunctions.CheckEntity(self.gateIns) then
			BehaviorFunctions.RemoveEntity(self.gateIns)
		end
		BehaviorFunctions.StartStoryDialog(53001)
	end
end


function TaskBehavior200100217:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)

end


function TaskBehavior200100217:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)

end

function TaskBehavior200100217:DialogCheck()
	--local timeLineState = self:CheckTimelienState()
	local timeLineState = self.timeLineState
	local player = BehaviorFunctions.GetCtrlEntity()
	if timeLineState == self.storyStateEnum.Playing then
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
	elseif timeLineState == self.storyStateEnum.PlayOver and self.currentTimeline ~= nil then
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

function TaskBehavior200100217:RemoveTask()
	
end

function TaskBehavior200100217:StoryStartEvent(dialogId)
	self.timeLineState = self.storyStateEnum.Playing
end

function TaskBehavior200100217:StoryEndEvent(dialogId)
	self.timeLineState = self.storyStateEnum.PlayOver
	if dialogId == 53001 then
		self.taskState = 1
	end
end
