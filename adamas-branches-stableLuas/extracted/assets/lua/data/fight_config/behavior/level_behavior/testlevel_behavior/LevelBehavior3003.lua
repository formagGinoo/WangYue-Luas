LevelBehavior3003 = BaseClass("LevelBehavior3003",LevelBehaviorBase)
--关卡测试关
function LevelBehavior3003:__init(fight)
	self.fight = fight
end


function LevelBehavior3003.GetGenerates()
	--local generates = {910040,900041,900042}
	--local generates = {900022,910040,900041,900042}
	local generates = {900040}
	return generates
end


function LevelBehavior3003:Init()
	self.role = 1
	self.missionState = 0
	self.monster1 = 0
	self.monster2 = 0
	self.monster3 = 0 
	self.pos = 0
	self.pos2 = 0
	self.createId = 900040
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	self.battleTargetDistance = 0
end

function LevelBehavior3003:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	self.pos = BehaviorFunctions.GetTerrainPositionP("characterBorn",self.levelId)
	self.pos2 = BehaviorFunctions.GetTerrainPositionP("enemyBorn",self.levelId)
	
	if self.missionState == 0 then
		BehaviorFunctions.InMapTransport(self.pos.x+12,self.pos.y,self.pos.z+2)
		self.monster1 = BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		BehaviorFunctions.RemoveBehavior(self.monster1)


		self.missionState = 1
	end

	if self.missionState == 1 then
		self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.monster1,self.battleTarget)
	end
	
		if BehaviorFunctions.GetEntityState(self.monster1) ~= FightEnum.EntityState.Move and self.time > 30 then
			if BehaviorFunctions.CanCtrl(self.monster1) then
				if self.battleTargetDistance > 1.75 then
					BehaviorFunctions.DoLookAtTargetByLerp(self.monster1,self.battleTarget,true,500,1250,-1)
					BehaviorFunctions.DoSetEntityState(self.monster1,FightEnum.EntityState.Move)
					BehaviorFunctions.DoSetMoveType(self.monster1,FightEnum.EntityMoveSubState.Run)
				end
			end
		elseif BehaviorFunctions.GetEntityState(self.monster1) == FightEnum.EntityState.Move and self.battleTargetDistance <= 1.75 then
			if BehaviorFunctions.CanCtrl(self.monster1) then
				BehaviorFunctions.DoLookAtTargetByLerp(self.monster1,self.battleTarget,true,500,1250,-1)
				BehaviorFunctions.DoSetEntityState(self.monster1,FightEnum.EntityState.Idle)
			end
		end

end

--死亡事件
function LevelBehavior3003:RemoveEntity(instanceId)
	if instanceId == self.monster1 then
		self.monster1 = BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		BehaviorFunctions.RemoveBehavior(self.monster1)
	end

end

function LevelBehavior3003:__delete()

end

function LevelBehavior3003:GMSetMonsterId(id)
	if id ~= self.createId and self.monster1 then
		self.createId = id
		BehaviorFunctions.RemoveEntity(self.monster1)
	end
end