LevelBehavior30000004 = BaseClass("LevelBehavior30000004",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior30000004:__init(fight)
	self.fight = fight
end


function LevelBehavior30000004.GetGenerates()
	local generates = {900040,900042,900050,900051}
	--local generates = {900040}
	return generates
end


function LevelBehavior30000004:Init()
	self.role = 1
	self.missionState = 0
end

function LevelBehavior30000004:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--if not BehaviorFunctions.HasEntitySign(self.role,10000007) then
	--BehaviorFunctions.AddEntitySign(self.role,10000007,-1)
	--end

	if self.missionState == 0  then
		local pos = BehaviorFunctions.GetTerrainPositionP("characterBorn",20010006)
		local pos2 = BehaviorFunctions.GetTerrainPositionP("enemyBorn",20010006)
		--local bornPos = BehaviorFunctions.GetTerrainPositionP("Born1",10021003)
		BehaviorFunctions.DoSetPosition(self.role,pos.x+14,pos.y,pos.z+6)
		self.monster1 = BehaviorFunctions.CreateEntity(900040,nil,pos2.x,pos2.y,pos2.z)
		----self.monster1 = BehaviorFunctions.CreateEntity(1999,nil,pos.x+1,pos.y,pos.z)
		--self.monster2 = BehaviorFunctions.CreateEntity(900050,nil,pos2.x-3,pos2.y,pos2.z)
		--self.monster3 = BehaviorFunctions.CreateEntity(900040,nil,pos2.x,pos2.y,pos2.z+3)
		--self.monster4 = BehaviorFunctions.CreateEntity(900050,nil,pos2.x,pos2.y,pos2.z-3)
		--BehaviorFunctions.AddEntitySign(1,10000007,-1,false)
		self.missionState = 1
	end

end

--死亡事件
function LevelBehavior30000004:RemoveEntity(instanceId)
	--if instanceId == self.monster1 then
	--local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021003)
	--self.monster1 = BehaviorFunctions.CreateEntity(90000,nil,pos.x+1,pos.y,pos.z)
	----Log(self.monster)
	--end
	if instanceId == self.monster1 then
		local pos = BehaviorFunctions.GetTerrainPositionP("enemyBorn",20010006)
		self.monster1 = BehaviorFunctions.CreateEntity(900040,nil,pos.x+3,pos.y,pos.z)
		--Log(self.monster)
	end
	--if instanceId == self.monster2 then
	--local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021003)
	--self.monster2 = BehaviorFunctions.CreateEntity(900050,nil,pos.x-3,pos.y,pos.z)
	----Log(self.monster2)
	--end
	--if instanceId == self.monster3 then
	--local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021003)
	--self.monster3 = BehaviorFunctions.CreateEntity(900040,nil,pos.x,pos.y,pos.z+3)
	----Log(self.monster3)
	--end
	--if instanceId == self.monster4 then
	--local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021003)
	--self.monster4 = BehaviorFunctions.CreateEntity(900050,nil,pos.x,pos.y,pos.z-3)
	----Log(self.monster4)
	--end
end


function LevelBehavior30000004:__delete()

end