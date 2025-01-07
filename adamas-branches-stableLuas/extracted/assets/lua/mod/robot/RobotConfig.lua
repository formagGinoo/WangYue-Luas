--机器人配置表
RobotConfig = RobotConfig or {}

local RobotHero = Config.DataRobotHero.Find

function RobotConfig.GetRobotHeroCfgById(robotId)
    return RobotHero[robotId]
end