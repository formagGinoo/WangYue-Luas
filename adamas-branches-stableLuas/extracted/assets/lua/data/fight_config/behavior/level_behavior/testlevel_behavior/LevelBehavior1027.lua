LevelBehavior1027 = BaseClass("LevelBehavior1027",LevelBehaviorBase)
--大世界测试
function LevelBehavior1027:__init(fight)
	self.fight = fight
end


function LevelBehavior1027.GetGenerates()
	local generates = {9001}
	return generates
end


function LevelBehavior1027:Init()
	self.missionState = 0
end

function LevelBehavior1027:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	if self.missionState == 0  then
		BehaviorFunctions.DoSetPosition(self.role,216.55,34.6,203.89)
		self.missionState = 1
	end
end


function LevelBehavior1027:__delete()

end


--BehaviorFunctions.DoSetPosition(2,565.55,160.6,1148.89)