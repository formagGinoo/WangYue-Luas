CallVehicleProxy = BaseClass("CallVehicleProxy",Proxy)

function CallVehicleProxy:__init()
    
end

function CallVehicleProxy:__InitProxy()
    self:BindMsg("vehicle_unlock_list")
end

function CallVehicleProxy:Recv_vehicle_unlock_list(data)
    mod.CallVehicleCtrl:UpdateVehicleData(data)
end