WorldMapTipFacade = BaseClass("WorldMapTipFacade", Facade)

function WorldMapTipFacade:__init()

end

function WorldMapTipFacade:__InitFacade()
    self:BindCtrl(WorldMapTipCtrl)
    self:BindCtrl(WorldMapTipProxy)
end