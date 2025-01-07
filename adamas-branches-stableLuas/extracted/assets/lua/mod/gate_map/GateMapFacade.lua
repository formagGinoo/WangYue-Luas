GateMapFacade = BaseClass("GateMapFacade",Facade)

function GateMapFacade:__init()

end

function GateMapFacade:__InitFacade()
    self:BindCtrl(GateMapCtrl)
    self:BindProxy(GateMapProxy)
end