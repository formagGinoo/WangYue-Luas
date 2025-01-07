Config = Config or {}
Config.CameraConfig = Config.CameraConfig or {}

Config.CameraConfig.ManinCameraPrefab = "Prefabs/Camera/MainCamera.prefab"
Config.CameraConfig.DefaultCamera = "Prefabs/Camera/CameraCommon.prefab"

Config.CameraConfig.DefaultConfig = {
	Prefab = "Prefabs/Camera/CameraCommon.prefab",
	Params = {
		CameraDistance = 4,--相机距离
		CameraXDamping = 0.5,--相机X轴跟随阻尼（数组越大越慢）
		CameraZDamping = 0.5,--相机Z轴跟随阻尼（数组越大越慢）
		CameraHeight = 0.9,--相机基准高度
		CameraRotateX = 10,--高度偏移时，X轴需要旋转
		CameraMaxAngle = 90,--相机和人物最大角度
		CameraMinAngle = 30,--相机和人物最小角度
		CameraForceReviseAngle = 0,--相机强制修正角度（主要用于避免人物和目标重叠）
		CameraTargetWeight = 80,--目标权重（中心点偏向权重大的,和另一个加起来=100）
		CameraMaxOffsetX = 0.1,--相机在X方向距离角色的最大距离
	}
}

--[[
CameraDistance  相机距离人物的距离
Fov				FOV
BodySoftWidth	位置跟随的缓冲水平范围
BodySoftHeight	位置跟随的缓冲垂直范围
AimSoftWidth	看向跟随的缓冲水平范围
AimSoftHeight   看向跟随的缓冲垂直范围
--]]

Config.CameraParams = {}
Config.CameraParams[1] = {
	CameraDistance = 3,
}



--巴希利克斯BOSS镜头基本参数
Config.CameraParams[9200201] = {
	
	--地面水平距离差Aim相关参数
	MinDis = 1,
	MaxDis = 25,
	MinBodyScreenY = 0.55,
	MaxBodyScreenY = 0.6,
	MinAimScreenY = 0.35,
	MaxAimScreenY = 0.35,
	MinAimDeadZoneHeight = 0.1,
	MaxAimDeadZoneHeight = 0.05,
	MinAimSoftZoneHeight = 0.7,
	MaxAimSoftZoneHeight = 0.3,
	MinAimDeadZoneWidth = 0.4,
	MaxAimDeadZoneWidth = 0.03,
	MinAimSoftZoneWidth = 0.5,
	MaxAimSoftZoneWidth = 0.08,
	
	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 6,
	MaxCameraDistance = 6,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = true,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,
	
	--高度差Aim相关参数
	MinYdif = 0,
	MaxYdif = 6,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.2,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = 0,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
}


--贝露贝特BOSS镜头基本参数
Config.CameraParams[9200101] = {
	
	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.6,
	MinAimScreenY = 0.4,
	MaxAimScreenY = 0.4,
	MinAimDeadZoneHeight = 0.02,
	MaxAimDeadZoneHeight = 0.02,
	MinAimSoftZoneHeight = 0.35,
	MaxAimSoftZoneHeight = 0.35,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,
	
	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 5,
	MaxCameraDistance = 5,
	
	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0,
	
	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = true,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,
	
	--高度差Aim相关参数
	MinYdif = -1,
	MaxYdif = 4,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.3,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = 0,
	MinYdifAimDeadZoneHeight = 0.05,
	MaxYdifAimDeadZoneHeight = 0.2,
	MinYdifAimSoftZoneHeight = 0.05,
	MaxYdifAimSoftZoneHeight = 0.2,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
	
	----高度差Aim相关参数
	--MinYdif = 0,
	--MaxYdif = 4,
	--MinYdifAimScreenY = 0,
	--MaxYdifAimScreenY = -0.1,
	--MinYdifAimDeadZoneHeight = 0.1,
	--MaxYdifAimDeadZoneHeight = 0.05,
	--MinYdifAimSoftZoneHeight = 0.7,
	--MaxYdifAimSoftZoneHeight = 0.3,
	--MinYdifAimDeadZoneWidth = 0.4,
	--MaxYdifAimDeadZoneWidth = 0.03,
	--MinYdifAimSoftZoneWidth = 0.5,
	--MaxYdifAimSoftZoneWidth = 0.08,
}


--跳反镜头基本参数
Config.CameraParams[10000001] = {
	
	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.7,
	MinAimScreenY = 0.3,
	MaxAimScreenY = 0.3,
	MinAimDeadZoneHeight = 0.01,
	MaxAimDeadZoneHeight = 0.01,
	MinAimSoftZoneHeight = 0.02,
	MaxAimSoftZoneHeight = 0.02,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,
	
	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 5,
	MaxCameraDistance = 5,
	
	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0,
	
	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,
	
	--高度差Aim相关参数
	MinYdif = -1,
	MaxYdif = 1,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = 0,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
	
	----高度差Aim相关参数
	--MinYdif = 0,
	--MaxYdif = 4,
	--MinYdifAimScreenY = 0,
	--MaxYdifAimScreenY = -0.1,
	--MinYdifAimDeadZoneHeight = 0.1,
	--MaxYdifAimDeadZoneHeight = 0.05,
	--MinYdifAimSoftZoneHeight = 0.7,
	--MaxYdifAimSoftZoneHeight = 0.3,
	--MinYdifAimDeadZoneWidth = 0.4,
	--MaxYdifAimDeadZoneWidth = 0.03,
	--MinYdifAimSoftZoneWidth = 0.5,
	--MaxYdifAimSoftZoneWidth = 0.08,
}


Config.CameraParams[1000] = {
	CameraDistance = 5,
}
Config.CameraParams[1001] = {
	CameraDistance = 5,
}
Config.CameraParams[1100] = {
	CameraDistance = 5,
}
Config.CameraParams[1101] = {
	
	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.6,
	MinAimScreenY = 0.4,
	MaxAimScreenY = 0.4,
	MinAimDeadZoneHeight = 0.2,
	MaxAimDeadZoneHeight = 0.2,
	MinAimSoftZoneHeight = 0.35,
	MaxAimSoftZoneHeight = 0.35,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 5,
	MaxCameraDistance = 5,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = true,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = -1,
	MaxYdif = 4,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.3,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = 0,
	MinYdifAimDeadZoneHeight = 0.05,
	MaxYdifAimDeadZoneHeight = 0.2,
	MinYdifAimSoftZoneHeight = 0.05,
	MaxYdifAimSoftZoneHeight = 0.2,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,

	----高度差Aim相关参数
	--MinYdif = 0,
	--MaxYdif = 4,
	--MinYdifAimScreenY = 0,
	--MaxYdifAimScreenY = -0.1,
	--MinYdifAimDeadZoneHeight = 0.1,
	--MaxYdifAimDeadZoneHeight = 0.05,
	--MinYdifAimSoftZoneHeight = 0.7,
	--MaxYdifAimSoftZoneHeight = 0.3,
	--MinYdifAimDeadZoneWidth = 0.4,
	--MaxYdifAimDeadZoneWidth = 0.03,
	--MinYdifAimSoftZoneWidth = 0.5,
	--MaxYdifAimSoftZoneWidth = 0.08,
}