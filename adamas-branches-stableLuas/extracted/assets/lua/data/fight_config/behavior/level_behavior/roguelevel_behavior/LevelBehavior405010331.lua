LevelBehavior405010331 = BaseClass("LevelBehavior405010331",LevelBehaviorBase)
--城市赛车
function LevelBehavior405010331:__init(fight)
	self.fight = fight
end


function LevelBehavior405010331.GetGenerates()
	local generates = {2040802,2040803}
	return generates
end


function LevelBehavior405010331:Init()
	self.role = 0
	self.initState = 0
	self.missionState = 0
	self.createState = 0
	self.car = 0
	self.pos = 0
end

function LevelBehavior405010331:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

end
