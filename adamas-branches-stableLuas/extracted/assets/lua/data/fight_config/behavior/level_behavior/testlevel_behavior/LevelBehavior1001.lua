LevelBehavior1001 = BaseClass("LevelBehavior1000",LevelBehaviorBase)
--战斗单怪测试关
function LevelBehavior1001:__init(fight)
	self.fight = fight
end


function LevelBehavior1001.GetGenerates()
	local generates = {9001}
	return generates
end


function LevelBehavior1001:Init()
	self.role = 2
	self.Missionstate = 0
end

function LevelBehavior1001:Update()
	if  self.Missionstate == 0 then
		self.entites = {}   --初始化self.entites表
		local pb1 = BehaviorFunctions.GetTerrainPositionP("Born1")
		local mb101 = BehaviorFunctions.GetTerrainPositionP("s1")
		--BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)	--设置角色出生点

		local pb1 = BehaviorFunctions.GetPositionP(self.role)
		self.Monster = BehaviorFunctions.CreateEntity(9001,nil,pb1.x,pb1.y,pb1.z,pb1.x,nil,pb1.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
		self.Missionstate = 5
	end
end

function LevelBehavior1000:Death(instanceId)
	if instanceId == self.Monster then
		local pb1 = BehaviorFunctions.GetPositionP(self.role)
		self.Monster = BehaviorFunctions.CreateEntity(9001,nil,pb1.x,pb1.y,pb1.z,pb1.x,nil,pb1.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
	end
end

function LevelBehavior1000:__delete()

end