LevelBehavior3002 = BaseClass("LevelBehavior3002",LevelBehaviorBase)
--关卡测试关
function LevelBehavior3002:__init(fight)
	self.fight = fight
end


function LevelBehavior3002.GetGenerates()
	--local generates = {910040,900041,900042}
	--local generates = {900022,910040,900041,900042}
	local generates = {8012005,900040,900071,900090,900140,910040,910120,910120}
	return generates
end


function LevelBehavior3002:Init()
	self.role = 1
	self.missionState = 0
	self.monster1 = 0
	self.monster2 = 0
	self.monster3 = 0 
	self.pos = 0
	self.pos2 = 0
	self.createId = 900040
end

function LevelBehavior3002:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	self.pos = BehaviorFunctions.GetTerrainPositionP("characterBorn",self.levelId)
	self.pos2 = BehaviorFunctions.GetTerrainPositionP("enemyBorn",self.levelId)
	
	if self.missionState == 0 then
		BehaviorFunctions.InMapTransport(self.pos.x+12,self.pos.y,self.pos.z+2)
		self.monster1 = BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		--移除怪物逻辑
		BehaviorFunctions.RemoveBehavior(self.monster1) 
		--角色无敌
		BehaviorFunctions.AddBuff(self.role,self.role,1000075)
		BehaviorFunctions.DoMagic(self.monster1,self.monster1,900000026)
		--BehaviorFunctions.AddBuff(self.monster1,self.monster1,900000045)
		self.missionState = 1
	end
end

--死亡事件
function LevelBehavior3002:RemoveEntity(instanceId)
	if instanceId == self.monster1 then
		self.monster1 = BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
	
	end

end

function LevelBehavior3002:__delete()

end

function LevelBehavior3002:GMSetMonsterId(id)
	if id ~= self.createId and self.monster1 then
		self.createId = id
		BehaviorFunctions.RemoveEntity(self.monster1)
	end
end