CallVehicleFacade = BaseClass("CallVehicleFacade",Facade)

function CallVehicleFacade:__init()
end

function CallVehicleFacade:__InitFacade()
    self:BindCtrl(CallVehicleCtrl)
    self:BindProxy(CallVehicleProxy)
end