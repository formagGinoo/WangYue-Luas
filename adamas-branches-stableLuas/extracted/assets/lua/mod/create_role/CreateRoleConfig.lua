CreateRoleConfig = CreateRoleConfig or {}

local DataChooseGender = Config.DataChooseGender.Find

CreateRoleConfig.CamareConfig =
{
    camera_position = {x = 0, y = 1.38, z = 3.04},
    camera_rotation = {x = 0, y = 189, z = 0.00}
}

function CreateRoleConfig.GetCameraConfig(case)
    return DataChooseGender[case]
end

function CreateRoleConfig.GetModelUi(index)
    return DataChooseGender[index].ui_model
end