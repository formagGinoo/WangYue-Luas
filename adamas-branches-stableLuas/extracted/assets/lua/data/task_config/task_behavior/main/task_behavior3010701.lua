TaskBehavior3010701 = BaseClass("TaskBehavior3010701")


function TaskBehavior3010701.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior3010701:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.npcId = 5003001110004
	self.npc = nil
	self.npcEntity = nil
end

function TaskBehavior3010701:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.npcEntity then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	else
		self.npc = self.npcEntity.instanceId
	end
	if self.missionState == 1 and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
		BehaviorFunctions.PlayAnimation(self.npc,"Dodge",FightEnum.AnimationLayer.BaseLayer)
		self.missionState = 2
	end

end


function TaskBehavior3010701:StoryStartEvent(dialogId)
	if dialogId == 602090201 then
		self.missionState = 1
	end
end	
	
	


function TaskBehavior3010701:__delete()

end