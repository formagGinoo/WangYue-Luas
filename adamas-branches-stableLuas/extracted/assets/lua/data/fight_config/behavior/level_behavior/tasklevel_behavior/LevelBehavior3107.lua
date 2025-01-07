LevelBehavior3107 = BaseClass("LevelBehavior3107",LevelBehaviorBase)

function LevelBehavior3107.GetGenerates()
	local generates = {}
	return generates
end

function LevelBehavior3107:__init(fight)
	self.fight = fight
end

function LevelBehavior3107:Init()

	-------------------基础参数----------------------
	self.role = nil
	self.missionState = 0
end

function LevelBehavior3107:LateInit()

end

function LevelBehavior3107:Update()
	if self.missionState == 0 then
		LogError("区域测试关卡类型3：rougue关卡已创建")
		self.missionState = 1
	end
end







