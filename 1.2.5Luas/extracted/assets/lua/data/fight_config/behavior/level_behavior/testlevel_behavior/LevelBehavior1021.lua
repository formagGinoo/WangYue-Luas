LevelBehavior1021 = BaseClass("LevelBehavior1021",LevelBehaviorBase)
--星辰学院测试关
function LevelBehavior1021:__init(fight)
	self.fight = fight
end


function LevelBehavior1021.GetGenerates()
	local generates = {910024}
	return generates
end


function LevelBehavior1021:Init()
	self.role = 1           
	self.Missionstate = 0   
end

function LevelBehavior1021:Update()
	if  self.Missionstate == 0 then
		self.entites = {}   --初始化self.entites表
		local pb1 = BehaviorFunctions.GetTerrainPositionP("role")
		local mb101 = BehaviorFunctions.GetTerrainPositionP("mb101")
		BehaviorFunctions.InitCameraAngle(180)
		--BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)  
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)	--设置角色出生点 
		self.Monster = BehaviorFunctions.CreateEntity(910024,nil,mb101.x,mb101.y,mb101.z,pb1.x,nil,pb1.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
		self.Missionstate = 5
	end
end

function LevelBehavior1021:Death(instanceId)
	if instanceId == self.Monster then
		local pb1 = BehaviorFunctions.GetTerrainPositionP("role")
		local mb101 = BehaviorFunctions.GetTerrainPositionP("mb101")
		self.Monster = BehaviorFunctions.CreateEntity(910024,nil,mb101.x,mb101.y,mb101.z,pb1.x,nil,pb1.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
	end
end

function LevelBehavior1021:__delete()

end