TaskBehavior3011701 = BaseClass("TaskBehavior3011701")


function TaskBehavior3011701.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3011701:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110009
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3011701:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.npcEntity then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	else
		self.npc = self.npcEntity.instanceId
	end
	if self.missionState == 0 and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
		--BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"觉醒者，天月警司需要你的协助",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		self.missionState = 1
	end

end

function TaskBehavior3011701:__delete()

end