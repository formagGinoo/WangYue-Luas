LevelBehavior3105 = BaseClass("LevelBehavior3105",LevelBehaviorBase)

function LevelBehavior3105.GetGenerates()
	local generates = {}
	return generates
end

function LevelBehavior3105:__init(fight)
	self.fight = fight
end

function LevelBehavior3105:Init()

	-------------------基础参数----------------------
	self.role = nil
	self.missionState = 0
end

function LevelBehavior3105:LateInit()
	
end

function LevelBehavior3105:Update()
	if self.missionState == 0 then
		LogError("区域测试关卡类型1：任务创建关卡已创建")
		self.missionState = 1
	end
end







