TaskBehavior3011101 = BaseClass("TaskBehavior3011101")


function TaskBehavior3011101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3011101:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110007
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3011101:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.npcEntity then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	else
		self.npc = self.npcEntity.instanceId
	end
	if self.missionState == 0 and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
		--BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"散了散了，大家不要往这个方向走！",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		self.missionState = 1
	end

end

function TaskBehavior3011101:__delete()

end