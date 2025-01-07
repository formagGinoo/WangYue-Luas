WorldFacade = BaseClass("WorldFacade",Facade)

function WorldFacade:__init()

end

function WorldFacade:__InitFacade()
    self:BindCtrl(WorldCtrl)
    self:BindProxy(WorldProxy) 
end