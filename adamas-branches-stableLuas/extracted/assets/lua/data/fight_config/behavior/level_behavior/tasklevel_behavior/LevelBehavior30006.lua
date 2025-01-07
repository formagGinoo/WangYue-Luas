LevelBehavior30006 = BaseClass("LevelBehavior30006",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior30006:__init(fight)
	self.fight = fight
end


function LevelBehavior30006.GetGenerates()
	local generates = {92001,92002}
	return generates
end


function LevelBehavior30006:Init()
	self.role = 1
	self.missionState = 0
end

function LevelBehavior30006:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	if  self.missionState == 0 then
		BehaviorFunctions.SetPlayerBorn(260,65,432)
		BehaviorFunctions.DoMagic(self.role,self.role,200000002)
		self.monster = BehaviorFunctions.CreateEntity(92001,nil,293,65,461)
		self.monster2 = BehaviorFunctions.CreateEntity(92002,nil,293,65,461)
		--self.monster2 = BehaviorFunctions.CreateEntity(92002,nil,423,97,435)
		BehaviorFunctions.EntityCombination(self.monster2,self.monster,true)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
		BehaviorFunctions.SetCameraDistance(7)
		self.missionState = 5
	end

end

function LevelBehavior30006:__delete()

end
