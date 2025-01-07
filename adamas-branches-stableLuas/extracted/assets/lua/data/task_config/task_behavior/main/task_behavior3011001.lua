TaskBehavior3011001 = BaseClass("TaskBehavior3011001")


function TaskBehavior3011001.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3011001:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110005
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3011001:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.npcEntity then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	else
		self.npc = self.npcEntity.instanceId
	end
	if self.missionState == 1 and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
		BehaviorFunctions.PlayAnimation(self.npc,"Jump",FightEnum.AnimationLayer.BaseLayer)
		self.missionState = 2
	end

end


function TaskBehavior3011001:StoryStartEvent(dialogId)
	if dialogId == 602100201 then
		self.missionState = 1
	end
end	
	
	


function TaskBehavior3011001:__delete()

end