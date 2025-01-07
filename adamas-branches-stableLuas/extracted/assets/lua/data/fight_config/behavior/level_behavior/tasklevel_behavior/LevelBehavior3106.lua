LevelBehavior3106 = BaseClass("LevelBehavior3106",LevelBehaviorBase)

function LevelBehavior3106.GetGenerates()
	local generates = {}
	return generates
end

function LevelBehavior3106:__init(fight)
	self.fight = fight
end

function LevelBehavior3106:Init()

	-------------------基础参数----------------------
	self.role = nil
	self.missionState = 0
end

function LevelBehavior3106:LateInit()

end

function LevelBehavior3106:Update()
	if self.missionState == 0 then
		LogError("区域测试关卡类型2：实体单位创建关卡已创建")
		self.missionState = 1
	end
end







