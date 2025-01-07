CitySimulationFacade = BaseClass("CitySimulationFacade",Facade)

function CitySimulationFacade:__init()
end

function CitySimulationFacade:__InitFacade()
    self:BindCtrl(CitySimulationCtrl)
    self:BindProxy(CitySimulationProxy)
end