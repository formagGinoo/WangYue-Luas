-- Automatically generated - do not edit.

Config = Config or {}
Config.DataBuild = Config.DataBuild or {}


local DataBuild = Config.DataBuild
DataBuild.FindLength = 6

DataBuild.FindbyInstanceId = {
	[2080101] = { [1] = 1002,},
	[2080102] = { [1] = 1001,},
	[2080103] = { [1] = 1003,},
	[2080104] = { [1] = 1004,},
	[2080105] = { [1] = 1005,},
	[2080106] = { [1] = 1006,},
}

DataBuild.Find = {
	[1001] = { angular_drag = 2.0, build_id = 1001, build_magic = 200001060, condition = 0, cost_energy = 0.0, cost_list = {{8,1,},}, count_limit = 10, desc = "", destroy_magic = 200001012, drag = 0.1, icon = "Textures/Icon/Single/BuildIcon/Steelplate.png", instance_id = 2080102, mass = 30, name = "钢板", priority = 4,},
	[1002] = { angular_drag = 2.0, build_id = 1002, build_magic = 200001062, condition = 0, cost_energy = 2.0, cost_list = {{8,3,},}, count_limit = 4, desc = "", destroy_magic = 200001012, drag = 0.1, icon = "Textures/Icon/Single/BuildIcon/ElectricFan.png", instance_id = 2080101, mass = 10, name = "风扇", priority = 5,},
	[1003] = { angular_drag = 2.0, build_id = 1003, build_magic = 200001061, condition = 0, cost_energy = 0.0, cost_list = {{8,1,},}, count_limit = 10, desc = "", destroy_magic = 200001012, drag = 0.1, icon = "Textures/Icon/Single/BuildIcon/Console.png", instance_id = 2080103, mass = 10, name = "操纵台", priority = 7,},
	[1004] = { angular_drag = 2.0, build_id = 1004, build_magic = 200001061, condition = 0, cost_energy = 0.0, cost_list = {{8,1,},}, count_limit = 10, desc = "", destroy_magic = 200001012, drag = 0.1, icon = "Textures/Icon/Single/BuildIcon/WoodStump.png", instance_id = 2080104, mass = 60, name = "木桩", priority = 10,},
	[1005] = { angular_drag = 2.0, build_id = 1005, build_magic = 200001061, condition = 0, cost_energy = 0.0, cost_list = {{8,1,},}, count_limit = 10, desc = "", destroy_magic = 200001012, drag = 0.1, icon = "Textures/Icon/Single/BuildIcon/FlatCar.png", instance_id = 2080105, mass = 40, name = "平台车", priority = 11,},
	[1006] = { angular_drag = 0.1, build_id = 1006, build_magic = 200001061, condition = 0, cost_energy = 0.0, cost_list = {{8,1,},}, count_limit = 10, desc = "", destroy_magic = 200001012, drag = 0.1, icon = "Textures/Icon/Single/BuildIcon/FlatCar.png", instance_id = 2080106, mass = 1, name = "大轮胎", priority = 11,},
}


return DataBuild
