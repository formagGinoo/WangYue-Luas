TaskBehavior3010401 = BaseClass("TaskBehavior3010401")


function TaskBehavior3010401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3010401:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110002
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3010401:Update()
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


function TaskBehavior3010401:StoryStartEvent(dialogId)
	if dialogId == 602080201 then
		self.missionState = 1
	end
end	
	
	


function TaskBehavior3010401:__delete()

end