LevelBehavior10011001 = BaseClass("LevelBehavior10011001",LevelBehaviorBase)
--肉鸽测试关卡01
function LevelBehavior10011001:__init(fight)
	self.fight = fight
end


function LevelBehavior10011001.GetGenerates()
	local generates = {}
	return generates
end


function LevelBehavior10011001:Init()
	self.missionState = 0
end

function LevelBehavior10011001:LateInit()
	LogError("当前已创建关卡".."id:"..self.levelId)
end

--local bcomb = false
function LevelBehavior10011001:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.role = BehaviorFunctions.GetCtrlEntity()

end

function LevelBehavior10011001:__delete()

end