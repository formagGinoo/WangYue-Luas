Behavior808012003 = BaseClass("Behavior808012003",EntityBehaviorBase)
--第四章用脉灵
local DataItem = Config.DataItem.data_item

--预加载
function Behavior808012003.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior808012003:Init()
	self.me = self.instanceId
	self.npcId = nil
	self.npcName = nil
	self.defaultDialogId = nil
end

function Behavior808012003:LateInit()
	if self.sInstanceId then
		self.npcId = self.sInstanceId
		self.npcName = BehaviorFunctions.GetNpcName(self.npcId)
	end
	self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
end


function Behavior808012003:Update()
	--会根据任务变化，所以需要每帧数判断
	if self.npcId then
		self.isInTask = BehaviorFunctions.CheckNpcIsInTask(self.npcId)
		self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
		self.bubbleId = BehaviorFunctions.GetNpcBubbleId(self.npcId)
	end
end


--进入交互范围，添加交互列表
function Behavior808012003:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.defaultDialogId	> 0 then
		if self.isTrigger then
			return
		end
		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
			self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,self.npcName)
	end

end

--退出交互范围，移除交互列表
function Behavior808012003:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

--点击交互:播放默认对话
function Behavior808012003:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.defaultDialogId	 then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			if self.npcId then
				BehaviorFunctions.ActiveMapIcon(self.npcId)
			end
			BehaviorFunctions.StartNPCDialog(self.defaultDialogId,self.me)
			self.isTrigger = nil
		end
	end
end

--function Behavior808012003:HackingClickUp(instanceId)
	--if instanceId == self.me then
	--end
--end


function Behavior808012003:CallHackUp(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.StartStoryDialog(104031701)
	end
end