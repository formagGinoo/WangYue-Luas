LevelBehavior1 = BaseClass("LevelBehavior1",LevelBehaviorBase)

function LevelBehavior1:__init(fight)
	self.fight = fight
end


function LevelBehavior1.GetGenerates()
	return {}
end


function LevelBehavior1:Init()
	self.role = 1
	self.Missionstate = 0
end

function LevelBehavior1:Update()
	--if  self.Missionstate == 0 then
		--self.entites = {}   --初始化self.entites表
		--local mb101 = BehaviorFunctions.GetTerrainPositionP("col11", self.levelId)
		--self.Monster = BehaviorFunctions.CreateEntity(910024,nil,mb101.x,mb101.y,mb101.z)
		--self.Missionstate = 5
	--end
end

function LevelBehavior1:Death(instanceId)

end

function LevelBehavior1:__delete()

end