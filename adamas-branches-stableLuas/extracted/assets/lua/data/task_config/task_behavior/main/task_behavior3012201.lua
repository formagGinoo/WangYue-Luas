TaskBehavior3012201 = BaseClass("TaskBehavior3012201")


function TaskBehavior3012201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3012201:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110010
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3012201:Update()
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


function TaskBehavior3012201:StoryStartEvent(dialogId)
	if dialogId == 602180201 then
		self.missionState = 1
	end
end	
	
	


function TaskBehavior3012201:__delete()

end