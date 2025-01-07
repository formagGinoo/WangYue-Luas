LevelBehavior9001 = BaseClass("LevelBehavior9001",LevelBehaviorBase)

function LevelBehavior9001:__init(fight)
	self.fight = fight
	
end

function LevelBehavior9001.GetGenerates()
	local generates = {9001}
	return generates
end

function LevelBehavior9001:Update()
	if not self.entites then
		self.entites = {}
		local entity = BehaviorFunctions.CreateEntity(9001)
		BehaviorFunctions.DoSetEntityState(entity.instanceId,FightEnum.EntityState.Idle)
		BehaviorFunctions.DoSetPosition(entity.instanceId,0,0,10)
		self.entites[entity.instanceId] = entity
	end
end


function LevelBehavior9001:__delete()

end