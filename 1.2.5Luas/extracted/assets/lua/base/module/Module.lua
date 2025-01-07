Module = BaseClass("Module")

function Module:__init()
    local moduleClass = ClassToModule[self.__className]
    self.module = Facade.GetFacade(moduleClass)
	if not self.module then
		LogError(string.format("类映射模块失败[类:%s][模块:%s]",self.__className,moduleClass))
	end
    --assert(self.module,string.format("类映射模块失败[类:%s][模块:%s]",self.__className,moduleClass))
end