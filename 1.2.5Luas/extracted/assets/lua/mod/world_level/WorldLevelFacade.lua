WorldLevelFacade = BaseClass("WorldLevelFacade",Facade)

function WorldLevelFacade:__init()
end

function WorldLevelFacade:__InitFacade()
	self:BindCtrl(WorldLevelCtrl)
	self:BindProxy(WorldLevelProxy)
end