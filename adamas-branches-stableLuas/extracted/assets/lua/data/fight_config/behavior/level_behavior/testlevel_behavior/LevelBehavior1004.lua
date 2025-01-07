LevelBehavior1004 = BaseClass("LevelBehavior1004",LevelBehaviorBase)

function LevelBehavior1004:__init(fight)
	self.fight = fight
	
end

function LevelBehavior1004.GetGenerates()
	local generates = {1004}
	return generates
end

function LevelBehavior1004:Update()
	if not self.entites then
		self.entites = {}
		local entity = BehaviorFunctions.CreateEntity(1004)
		BehaviorFunctions.DoSetEntityState(entity.instanceId,FightEnum.EntityState.Idle)
		BehaviorFunctions.DoSetPosition(entity.instanceId,0,0,10)
		self.entites[entity.instanceId] = entity
	end
end


function LevelBehavior1004:__delete()

end