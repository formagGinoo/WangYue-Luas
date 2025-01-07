LevelBehavior102080104 = BaseClass("LevelBehavior102080104",LevelBehaviorBase)
--灭火装置

function LevelBehavior102080104:__init(fight)
	self.fight = fight
end

function LevelBehavior102080104.GetGenerates()
	local generates = {2030802}   --灭火装置
	return generates
end

function LevelBehavior102080104:Init()
	self.role = nil
    self.missionState = 0
	self.imageTipId = 20031
	self.baojingqiEcoId = nil
end

function LevelBehavior102080104:Update()
    --灭火装置
	if self.missionState == 0 then
		if self.imageTipId then
			BehaviorFunctions.ShowGuideImageTips(self.imageTipId)
		end
		local pos = BehaviorFunctions.GetTerrainPositionP("XuantianXianjing", 10020005, "Main02_1")
		self.baojingqi = BehaviorFunctions.CreateEntity(2030802, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId)
		local pos1 = BehaviorFunctions.GetTerrainPositionP("XuantianXianjing1", 10020005, "Main02_1")
		self.baojingqi1 = BehaviorFunctions.CreateEntity(2030802, nil, pos1.x, pos1.y, pos1.z, nil, nil, nil, self.levelId)
		local pos2 = BehaviorFunctions.GetTerrainPositionP("XuantianXianjing2", 10020005, "Main02_1")
		self.baojingqi2 = BehaviorFunctions.CreateEntity(2030802, nil, pos2.x, pos2.y, pos2.z, nil, nil, nil, self.levelId)
		self.missionState = 1
	end	
			
	local isOff = BehaviorFunctions.GetEntityValue(self.baojingqi,"isOff")
	local isOff1 = BehaviorFunctions.GetEntityValue(self.baojingqi1,"isOff")
	local isOff2 = BehaviorFunctions.GetEntityValue(self.baojingqi2,"isOff")
	if isOff == true or isOff1 == true or isOff2 == true then
		BehaviorFunctions.FinishLevel(self.levelId)
	end
end

function LevelBehavior102080104:__delete()

end
