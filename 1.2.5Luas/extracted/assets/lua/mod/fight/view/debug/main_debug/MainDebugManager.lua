MainDebugManager = BaseClass("MainDebugManager",BaseManager)
MainDebugManager.NotClear = true

function MainDebugManager:__init()
	if MainDebugManager.Instance then
		LogError("不可以对单例对象重复实例化")
	end

	MainDebugManager.Instance = self
	self.model = MainDebugModel.New()
end

function MainDebugManager:__delete()
	
end