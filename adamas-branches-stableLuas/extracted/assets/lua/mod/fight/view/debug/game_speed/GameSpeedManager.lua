GameSpeedManager = BaseClass("GameSpeedManager",BaseManager)
GameSpeedManager.NotClear = true

function GameSpeedManager:__init()
	if GameSpeedManager.Instance then
		LogError("不可以对单例对象重复实例化")
	end

	GameSpeedManager.Instance = self
	self.model = GameSpeedModel.New()


end

function GameSpeedManager:__delete()

end