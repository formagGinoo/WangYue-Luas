WorldMapFacade = BaseClass("WorldMapFacade", Facade)

function WorldMapFacade:__init()

end

function WorldMapFacade:__InitFacade()
    self:BindCtrl(WorldMapCtrl)
    self:BindCtrl(WorldMapProxy)
end