TaskBehavior200100216= BaseClass("TaskBehavior200100216",LevelBehaviorBase)
--在屋顶寻找三把钥匙
function TaskBehavior200100216:__init(taskInfo)
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
	self.clueList = {
		{instanceId = nil,uniqueID = nil,collect = false,pos = "Key1",progressNum = 1},
		{instanceId = nil,uniqueID = nil,collect = false,pos = "Key2",progressNum = 2},
		{instanceId = nil,uniqueID = nil,collect = false,pos = "Key3",progressNum = 3},
		}
	self.DialogInfo = {
		--Actor代表需要屏蔽的生态实体
		
	}
	self.hasClue = 0
	self.clueCount = 0
	self.taskProgress1 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
	self.taskProgress2 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,2)
	self.taskProgress3 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,3)
	self.taskProgress4 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,4)
end



function TaskBehavior200100216:Update()
	if self.taskState == 0 then
		--检查任务进度
		self.taskProgress1 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1)
		self.taskProgress2 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,2)
		self.taskProgress3 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,3)
		self.taskProgress4 = BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,4)
		--更新任务进度
		if self.taskProgress1 == 1 then
			self.clueList[1].collect = true
		end
		if self.taskProgress2 == 1 then
			self.clueList[2].collect = true
		end
		if self.taskProgress3 == 1 then
			self.clueList[3].collect = true
		end
	end
	
	self:DialogCheck()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--创建三把钥匙
	if self.taskState == 0 then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		for i,v in ipairs(self.clueList) do
			if self.clueList[i].collect ~= true then
				local pos = BehaviorFunctions.GetTerrainPositionP(self.clueList[i].pos,10020001,"Logic10020001_5")
				self.clueList[i].instanceId = BehaviorFunctions.CreateEntity(200000102,nil,pos.x,pos.y,pos.z)
				self.clueCount = self.clueCount + 1
			elseif self.clueList[i].collect == true then
				self.hasClue = self.hasClue + 1
				self.clueCount = self.clueCount + 1
			end
		end
		self.taskState = 1
	end
	
	--刻刻提议去开门，完成任务
	if self.taskState == 1 and self.clueCount == self.hasClue then
		BehaviorFunctions.StartStoryDialog(57001)
		self.taskState = 2
	end
end

function TaskBehavior200100216:WorldInteractClick(uniqueId)
	for i,v in ipairs(self.clueList) do
		if uniqueId == v.uniqueID then
			self.hasClue = self.hasClue + 1
			BehaviorFunctions.WorldInteractRemove(v.uniqueID)
			if BehaviorFunctions.CheckEntity(v.instanceId) then
				BehaviorFunctions.RemoveEntity(v.instanceId)
				BehaviorFunctions.SendTaskProgress(200100216,v.progressNum,1)
				BehaviorFunctions.ShowTip(4001001,self.lasttime)--提示拾取了一把钥匙
			end
		end
	end
end


function TaskBehavior200100216:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.clueList) do
		if v.instanceId == triggerInstanceId then
			v.uniqueID = BehaviorFunctions.WorldNPCInteractActive(self.me,"拾取")
		end
	end
end


function TaskBehavior200100216:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.clueList) do
		if v.instanceId == triggerInstanceId then
			BehaviorFunctions.WorldInteractRemove(v.uniqueID)
		end
	end
end

function TaskBehavior200100216:DialogCheck()
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

function TaskBehavior200100216:RemoveTask()
	
end

function TaskBehavior200100216:StoryStartEvent(dialogId)
	self.timeLineState = self.storyStateEnum.Playing
end

function TaskBehavior200100216:StoryEndEvent(dialogId)
	self.timeLineState = self.storyStateEnum.PlayOver
	if dialogId == 57001 then
		self.taskState = 3
	end
end
