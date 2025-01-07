MapListManager = BaseClass("MapListManager",BaseManager)
MapListManager.NotClear = true

function MapListManager:__init()
	if MapListManager.Instance then
		LogError("不可以对单例对象重复实例化")
	end

	MapListManager.Instance = self
	self.model = MapListModel.New()


end

function MapListManager:__delete()

end