LevelBehavior3004 = BaseClass("LevelBehavior3004",LevelBehaviorBase)
--关卡测试关
function LevelBehavior3004:__init(fight)
	self.fight = fight
end


function LevelBehavior3004.GetGenerates()
	--local generates = {910040,900041,900042}
	--local generates = {900022,910040,900041,900042}
	local generates = {900040,79000401}
	return generates
end


function LevelBehavior3004:Init()
	self.role = 1
	self.missionState = 0
	self.monster1 = 0
	self.monster2 = 0
	self.monster3 = 0 
	self.pos = 0
	self.pos2 = 0
	self.createId = 900040
end

function LevelBehavior3004:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not BehaviorFunctions.HasEntitySign(self.role,10000007) then
	BehaviorFunctions.AddEntitySign(self.role,10000910025007,-1)
	end
	
	self.pos = BehaviorFunctions.GetTerrainPositionP("characterBorn",self.levelId)
	--self.pos2 = BehaviorFunctions.GetTerrainPositionP("enemyBorn",self.levelId)
	
	if self.missionState == 0 then
		--local bornPos = BehaviorFunctions.GetTerrainPositionP("Born1",10021003)
		--BehaviorFunctions.DoSetPosition(self.role,self.pos.x+12,self.pos.y,self.pos.z+2)
		BehaviorFunctions.InMapTransport(self.pos.x+12,self.pos.y,self.pos.z+2)
		--self.monster1 = BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		----self.monster1 = BehaviorFunctions.CreateEntity(1999,nil,pos.x+1,pos.y,pos.z)
		--self.monster2 = BehaviorFunctions.CreateEntity(910040,nil,self.pos2.x-10,self.pos2.y,self.pos2.z)
		--self.monster3 = BehaviorFunctions.CreateEntity(900041,nil,self.pos2.x,self.pos2.y,self.pos2.z+10)
		--self.monster4 = BehaviorFunctions.CreateEntity(910040,nil,self.pos2.x,self.pos2.y,self.pos2.z-3)
		--BehaviorFunctions.AddEntitySign(1,10000007,-1,false)
		self.missionState = 1
	end
end

--死亡事件
function LevelBehavior3004:RemoveEntity(instanceId)
	--if instanceId == self.monster1 then
		--self.monster1 = BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		----Log(self.monster)
	--end
	--if instanceId == self.monster2 then
		--self.monster2 = BehaviorFunctions.CreateEntity(900042,nil,self.pos2.x-10,self.pos2.y,self.pos2.z)
		----Log(self.monster2)
	--end
	--if instanceId == self.monster3 then
		--self.monster3 = BehaviorFunctions.CreateEntity(900041,nil,self.pos2.x,self.pos2.y,self.pos2.z+10)
		----Log(self.monster3)
	--end
	--if instanceId == self.monster4 then
		--self.monster4 = BehaviorFunctions.CreateEntity(910040,nil,self.pos2.x,self.pos2.y,self.pos2.z-3)
		----Log(self.monster4)
	--end
end

function LevelBehavior3004:__delete()

end

function LevelBehavior3004:GMSetMonsterId(id)
	--if id ~= self.createId and self.monster1 then
		--self.createId = id
		--BehaviorFunctions.RemoveEntity(self.monster1)
	--end
end