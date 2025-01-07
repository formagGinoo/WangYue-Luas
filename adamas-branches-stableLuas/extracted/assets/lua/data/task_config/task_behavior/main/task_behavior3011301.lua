TaskBehavior3011301 = BaseClass("TaskBehavior3011301")


function TaskBehavior3011301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3011301:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110007
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3011301:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.npcEntity then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	else
		self.npc = self.npcEntity.instanceId
	end
	if self.missionState == 1 and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
		BehaviorFunctions.PlayAnimation(self.npc,"Clap_loop",FightEnum.AnimationLayer.BaseLayer)
		self.missionState = 2
	end

end


function TaskBehavior3011301:StoryStartEvent(dialogId)
	if dialogId == 602110301 then
		self.missionState = 1
	end
end	
	
	


function TaskBehavior3011301:__delete()

end