--叫车系统配置
CallVehicleConfig = CallVehicleConfig or {}

CallVehicleConfig.DataVehicle = Config.DataVehicle.Find
local globalConfig = Config.DataGlobal.data_global

CallVehicleConfig.CameraPos =
{
    Near = {pos = {x = 0.5, y = 1, z = 10}, rot = {x = 6.5, y = 180}},
    Far = {pos = {x = 0, y = 0.89, z = 5}, rot = {y = 180}}
}

function CallVehicleConfig.GetVehicleConfigById(vehicle_id)
    return CallVehicleConfig.DataVehicle[vehicle_id]
end

function CallVehicleConfig.GetCallVehicleDisMinValue()
    return globalConfig["CallVehicleDisMin"].ivalue
end

function CallVehicleConfig.GetCallVehicleDisMaxValue()
    return globalConfig["CallVehicleDisMax"].ivalue
end

function CallVehicleConfig.GetCallVehicleRemoveDisValue()
    return globalConfig["CallVehicleRemoveDis"].ivalue
end

