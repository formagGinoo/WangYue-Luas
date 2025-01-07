TaskBehavior3011401 = BaseClass("TaskBehavior3011401")


function TaskBehavior3011401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3011401:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110008
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3011401:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.npcEntity then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	else
		self.npc = self.npcEntity.instanceId
	end
	if self.missionState == 0 and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
		--BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"要怎样才能让月灵听话呢？",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		self.missionState = 1
	end

end

function TaskBehavior3011401:__delete()

end