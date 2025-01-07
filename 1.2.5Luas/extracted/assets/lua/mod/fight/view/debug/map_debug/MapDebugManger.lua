MapDebugManger = BaseClass("MapDebugManger",BaseManager)
MapDebugManger.NotClear = true

function MapDebugManger:__init()
	if MapDebugManger.Instance then
		LogError("不可以对单例对象重复实例化")
	end

	MapDebugManger.Instance = self
	self.model = MapDebugModel.New()
end

function MapDebugManger:__delete()

end