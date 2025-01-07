TaskBehavior3010201 = BaseClass("TaskBehavior3010201")


function TaskBehavior3010201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3010201:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110002
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3010201:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.npcEntity then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	else
		self.npc = self.npcEntity.instanceId
	end
	if self.missionState == 0 and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
		--BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"呜呜呜，可恶的小偷",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		self.missionState = 1
	end

end

function TaskBehavior3010201:__delete()

end