TaskBehavior3010501 = BaseClass("TaskBehavior3010501")


function TaskBehavior3010501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3010501:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110004
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3010501:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.npcEntity then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	else
		self.npc = self.npcEntity.instanceId
	end
	if self.missionState == 0 and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
		--BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"朋友，先等等别过去那条街！",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		self.missionState = 1
	end

end

function TaskBehavior3010501:__delete()

end