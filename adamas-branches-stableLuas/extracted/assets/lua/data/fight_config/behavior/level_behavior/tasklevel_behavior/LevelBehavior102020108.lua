LevelBehavior102020108 = BaseClass("LevelBehavior102020108",LevelBehaviorBase)
--通电报警器

function LevelBehavior102020108:__init(fight)
	self.fight = fight
end

function LevelBehavior102020108.GetGenerates()
	local generates = {2030801}   --蓄电装置
	return generates
end

function LevelBehavior102020108:Init()
	self.role = nil
    self.missionState = 0
	self.imageTipId = 20032
	self.baojingqiEcoId = nil
end

function LevelBehavior102020108:Update()
    --显示通电报警器
	if self.missionState == 0 then
		if self.imageTipId then
			BehaviorFunctions.ShowGuideImageTips(self.imageTipId)
		end
		local pos = BehaviorFunctions.GetTerrainPositionP("ParkDevice", 10020005, "Main02_1")
		self.baojingqi = BehaviorFunctions.CreateEntity(2030801, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId)
		self.missionState = 1
	end	
			
	local isOpen = BehaviorFunctions.GetEntityValue(self.baojingqi,"isOpen")
	if isOpen == true then
		BehaviorFunctions.FinishLevel(self.levelId)
	end
end

function LevelBehavior102020108:__delete()

end
