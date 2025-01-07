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

Config.CameraConfig.DefFightCameraId = 9999901
Config.CameraConfig.CorrectFightCameraId = 9999902

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


Config.CameraParams[80001] = {
	BodySoftWidth = 0,
	BodySoftHeight = 0,
	XDamping = 1,
	YDamping = 1,
	ZDamping = 1,
	CameraDistance = 5,
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
	
	MinAimScreenX = 0.5,
	MaxAimScreenX = 0.5,
	
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
	MinDis = 0,
	MaxDis = 10,
	MinBodyScreenY = 0.46,
	MaxBodyScreenY = 0.5,
	MinAimScreenY = 0.45,
	MaxAimScreenY = 0.5,
	MinAimDeadZoneHeight = 0.02,
	MaxAimDeadZoneHeight = 0.02,
	MinAimSoftZoneHeight = 0.35,
	MaxAimSoftZoneHeight = 0.35,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.3,
	MaxAimSoftZoneWidth = 0.5,
	
	MinAimScreenX = 0.4,
	MaxAimScreenX = 0.6,
	
	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 5,
	MaxCameraDistance = 5,
	
	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = -2,
	
	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = true,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,
	
	--高度差Aim相关参数
	MinYdif = 1,
	MaxYdif = 6,
	MinYdifBodyScreenY = 0.1,
	MaxYdifBodyScreenY = 0.4,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.3,
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

--神荼BOSS镜头基本参数
Config.CameraParams[9200301] = {

	--地面水平距离差Aim相关参数
	MinDis = 3,
	MaxDis = 10,
	MinBodyScreenY = 0.45,
	MaxBodyScreenY = 0.5,
	MinAimScreenY = 0.46,
	MaxAimScreenY = 0.4,
	MinAimDeadZoneHeight = 0.2,
	MaxAimDeadZoneHeight = 0.02,
	MinAimSoftZoneHeight = 0.2,
	MaxAimSoftZoneHeight = 0.35,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,

	MinAimScreenX = 0.4,
	MaxAimScreenX = 0.6,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 5,
	MaxCameraDistance = 5,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = -2,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = true,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = 1,
	MaxYdif = 6,
	MinYdifBodyScreenY = 0.1,
	MaxYdifBodyScreenY = 0.4,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.3,
	MinYdifAimDeadZoneHeight = 0.05,
	MaxYdifAimDeadZoneHeight = 0.08,
	MinYdifAimSoftZoneHeight = 0.03,
	MaxYdifAimSoftZoneHeight = 0.3,
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
	MinCameraDistance = 6,
	MaxCameraDistance = 6,
	
	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = -1,
	
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

--青门隐跳反镜头基本参数
Config.CameraParams[10000006] = {

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
	MinCameraDistance = 6,
	MaxCameraDistance = 6,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = -1,

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

--叙慕上挑连携强锁
Config.CameraParams[100000010] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.5,
	MinAimScreenY = 0.45,
	MaxAimScreenY = 0.45,
	MinAimDeadZoneHeight = 0.02,
	MaxAimDeadZoneHeight = 0.02,
	MinAimSoftZoneHeight = 0.02,
	MaxAimSoftZoneHeight = 0.02,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 4,
	MaxCameraDistance = 4,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0.5,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = 0,
	MaxYdif = 5,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.15,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.25,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0.1,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0.1,
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

--离歌连携出场击退子弹
Config.CameraParams[62001614006] = {

	--地面水平距离差Aim相关参数
	MinDis = 0,
	MaxDis = 10,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.5,
	MinAimScreenY = 0.5,
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
	MinCameraDistance = 4,
	MaxCameraDistance = 4,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 1,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = 0,
	MaxYdif = 8,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.1,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.3,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0.05,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0.1,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
}

--离歌连携下砸强锁参数
Config.CameraParams[62001614003] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.55,
	MaxBodyScreenY = 0.55,
	MinAimScreenY = 0.45,
	MaxAimScreenY = 0.45,
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
	MaxYCameraDistance = 1,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = 1,
	MaxYdif = 3,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.1,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.19,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0.02,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0.02,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
	
	XDamping = 0.5,
	YDamping = 0.5,
	ZDamping = 0.5,
}

--叙慕连携下砸强锁参数
Config.CameraParams[1001998005] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.4,
	MaxBodyScreenY = 0.4,
	MinAimScreenY = 0.4,
	MaxAimScreenY = 0.4,
	MinAimScreenX = 0.6,
	MaxAimScreenX = 0.6,
	MinAimDeadZoneHeight = 0.15,
	MaxAimDeadZoneHeight = 0.15,
	MinAimSoftZoneHeight = 0.3,
	MaxAimSoftZoneHeight = 0.3,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 4,
	MaxCameraDistance = 4,

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
}

--连携神荼强锁切换
Config.CameraParams[62003] = {

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
	MinCameraDistance = 6,
	MaxCameraDistance = 6,

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
--连携跳砸
Config.CameraParams[62103] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.55,
	MaxBodyScreenY = 0.55,
	MinAimScreenY = 0.4,
	MaxAimScreenY = 0.4,
	MinAimScreenX = 0.7,
	MaxAimScreenX = 0.7,
	MinAimDeadZoneHeight = 0.2,
	MaxAimDeadZoneHeight = 0.2,
	MinAimSoftZoneHeight = 0.4,
	MaxAimSoftZoneHeight = 0.4,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 6,
	MaxCameraDistance = 6,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = 2,
	MaxYdif = 5,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.1,
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
--连携切换特写
Config.CameraParams[62203] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.45,
	MaxBodyScreenY = 0.45,
	MinAimScreenY = 0.6,
	MaxAimScreenY = 0.6,
	MinAimScreenX = 0.5,
	MaxAimScreenX = 0.5,
	MinAimDeadZoneHeight = 0.2,
	MaxAimDeadZoneHeight = 0.2,
	MinAimSoftZoneHeight = 0.4,
	MaxAimSoftZoneHeight = 0.4,
	MinAimDeadZoneWidth = 0.15,
	MaxAimDeadZoneWidth = 0.15,
	MinAimSoftZoneWidth = 0.15,
	MaxAimSoftZoneWidth = 0.15,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 2.5,
	MaxCameraDistance = 2.5,

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

	XDamping = 0.1,
	YDamping = 0.1,
	ZDamping = 0.1,
	
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

--升龙连携
Config.CameraParams[62303] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.3,
	MaxBodyScreenY = 0.3,
	MinAimScreenY = 0.4,
	MaxAimScreenY = 0.4,
	MinAimScreenX = 0.6,
	MaxAimScreenX = 0.6,
	MinAimDeadZoneHeight = 0.4,
	MaxAimDeadZoneHeight = 0.4,
	MinAimSoftZoneHeight = 0.6,
	MaxAimSoftZoneHeight = 0.6,
	MinAimDeadZoneWidth = 0.1,
	MaxAimDeadZoneWidth = 0.1,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.4,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 4,
	MaxCameraDistance = 4,

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
	MaxYdifAimDeadZoneHeight = 0.2,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0.2,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,

	XDamping = 0.1,
	YDamping = 0.1,
	ZDamping = 0.1,
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

--连携神荼强锁切换
Config.CameraParams[62403] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.7,
	MinAimScreenY = 0.4,
	MaxAimScreenY = 0.4,
	MinBodyDeadZoneHeight = 0.04,
	MaxBodyDeadZoneHeight = 0.04,
	MinBodySoftZoneHeight = 0.04,
	MaxBodySoftZoneHeight = 0.04,
	MinAimDeadZoneHeight = 0.02,
	MaxAimDeadZoneHeight = 0.02,
	MinAimSoftZoneHeight = 0.04,
	MaxAimSoftZoneHeight = 0.04,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 8,
	MaxCameraDistance = 8,

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

	XDamping = 0.4,
	YDamping = 0.4,
	ZDamping = 0.4,
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

--连携切换特写
Config.CameraParams[62503] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.45,
	MaxBodyScreenY = 0.45,
	MinAimScreenY = 0.6,
	MaxAimScreenY = 0.6,
	MinAimScreenX = 0.5,
	MaxAimScreenX = 0.5,
	MinAimDeadZoneHeight = 0.4,
	MaxAimDeadZoneHeight = 0.4,
	MinAimSoftZoneHeight = 0.6,
	MaxAimSoftZoneHeight = 0.6,
	MinAimDeadZoneWidth = 0.4,
	MaxAimDeadZoneWidth = 0.4,
	MinAimSoftZoneWidth = 0.6,
	MaxAimSoftZoneWidth = 0.6,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 2.5,
	MaxCameraDistance = 2.5,

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

	XDamping = 0.1,
	YDamping = 0.1,
	ZDamping = 0.1,

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

--青门隐踢飞切换
Config.CameraParams[100601202] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenY = 0.6,
	MaxBodyScreenY = 0.55,
	MinAimScreenY = 0.4,
	MaxAimScreenY = 0.4,
	MinAimScreenX = 0.6,
	MaxAimScreenX = 0.6,
	MinAimDeadZoneHeight = 0.2,
	MaxAimDeadZoneHeight = 0.2,
	MinAimSoftZoneHeight = 0.4,
	MaxAimSoftZoneHeight = 0.4,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.2,
	MinAimSoftZoneWidth = 0.4,
	MaxAimSoftZoneWidth = 0.5,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 4,
	MaxCameraDistance = 4,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0.1,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = -1,
	MaxYdif = 2,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.1,
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
	MaxYCameraDistance = -1,

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



--巴希利克斯BOSS出场镜头基本参数
Config.CameraParams[6200201] = {
	
	--XDamping = 0.1,
	--YDamping = 0.1,
	--ZDamping = 0.1,

	--地面水平距离差Aim相关参数
	MinDis = 1,
	MaxDis = 25,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.5,
	MinAimScreenY = 0.35,
	MaxAimScreenY = 0.35,
	
	MinBodyScreenX = 0.25,
	MaxBodyScreenX = 0.25,
	MinAimScreenX = 0.65,
	MaxAimScreenX = 0.65,
	
	MinXdifAimScreenX = 0,
	MaxXdifAimScreenX = 0.1,
	
	MinAimDeadZoneHeight = 0.1,
	MaxAimDeadZoneHeight = 0.05,
	MinAimSoftZoneHeight = 0.7,
	MaxAimSoftZoneHeight = 0.5,
	MinAimDeadZoneWidth = 0.4,
	MaxAimDeadZoneWidth = 0.03,
	MinAimSoftZoneWidth = 0.5,
	MaxAimSoftZoneWidth = 0.08,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 5,
	MaxCameraDistance = 5,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 1,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = true,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 3,

	--高度差Aim相关参数
	MinYdif = 0,
	MaxYdif = 6,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.2,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.1,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
}

--巴希利克斯BOSS常驻镜头基本参数
Config.CameraParams[6200202] = {
	
	--XDamping = 20,
	--YDamping = 20,
	--ZDamping = 20,

	--地面水平距离差Aim相关参数
	MinDis = 1,
	MaxDis = 25,
	MinBodyScreenY = 0.55,
	MaxBodyScreenY = 0.6,
	MinAimScreenY = 0.35,
	MaxAimScreenY = 0.35,

	MinBodyScreenX = 0.25,
	MaxBodyScreenX = 0.35,
	MinAimScreenX = 0.35,
	MaxAimScreenX = 0.5,

	MinXdifAimScreenX = 0,
	MaxXdifAimScreenX = 0,

	MinAimDeadZoneHeight = 0.1,
	MaxAimDeadZoneHeight = 0.05,
	MinAimSoftZoneHeight = 0.7,
	MaxAimSoftZoneHeight = 0.3,
	MinAimDeadZoneWidth = 0.4,
	MaxAimDeadZoneWidth = 0.03,
	MinAimSoftZoneWidth = 0.5,
	MaxAimSoftZoneWidth = 0.08,

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

--锁定相机参数
Config.CameraParams[1000000] = {

	--地面水平距离差Aim相关参数
	MinDis = 1,
	MaxDis = 25,
	MinBodyScreenY = 0.55,
	MaxBodyScreenY = 0.6,
	MinAimScreenY = 0.35,
	MaxAimScreenY = 0.35,

	MinBodyScreenX = 0.25,
	MaxBodyScreenX = 0.35,
	MinAimScreenX = 0.35,
	MaxAimScreenX = 0.5,

	MinXdifAimScreenX = 0,
	MaxXdifAimScreenX = 0,

	MinAimDeadZoneHeight = 0.1,
	MaxAimDeadZoneHeight = 0.05,
	MinAimSoftZoneHeight = 0.7,
	MaxAimSoftZoneHeight = 0.3,
	MinAimDeadZoneWidth = 0.4,
	MaxAimDeadZoneWidth = 0.03,
	MinAimSoftZoneWidth = 0.5,
	MaxAimSoftZoneWidth = 0.08,

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


Config.CameraParams[9999901] = {
	Id = 9999901,
	CurveId = 0,
	Base = {
		BodyTrackedObjectOffsetX = 0.0,
		BodyTrackedObjectOffsetY = 0.0,
		BodyTrackedObjectOffsetZ = 0.0,
		BodyXDamping = 0.1,
		BodyYDamping = 0.1,
		BodyZDamping = 0.1,
		BodyScreenX = 0.5,
		BodyScreenY = 0.5,
		BodyCameraDistance = 4.5,
		BodyDeadZoneWidth = 0.02,
		BodyDeadZoneHeight = 0.02,
		BodyDeadZoneDepth = 0.0,
		BodyUnlimitedSoftZone = false,
		BodySoftZoneWidth = 0.4,
		BodySoftZoneHeight = 0.5,
		BodyBiasX = 0.0,
		BodyBiasY = 0.0,
		AimTrackedObjectOffsetX = 0.0,
		AimTrackedObjectOffsetY = 0.0,
		AimTrackedObjectOffsetZ = 0.0,
		AimHorizontalDamping = 0.2,
		AimVerticalDamping = 0.2,
		AimScreenX = 0.5,
		AimScreenY = 0.48,
		AimDeadZoneWidth = 0.7,
		AimDeadZoneHeight = 0.7,
		AimSoftZoneWidth = 0.8,
		AimSoftZoneHeight = 0.7,
		AimBiasX = 0.0,
		AimBiasY = 0.0
	},
	VerticalOffset = {
		MinValue = 0.0,
		MaxValue = 0.0,
		MinOffset = {
			BodyTrackedObjectOffsetX = 0.0,
			BodyTrackedObjectOffsetY = 0.0,
			BodyTrackedObjectOffsetZ = 0.0,
			BodyXDamping = 0.2,
			BodyYDamping = 0.2,
			BodyZDamping = 0.2,
			BodyScreenX = 0.5,
			BodyScreenY = 0.52,
			BodyCameraDistance = 4.0,
			BodyDeadZoneWidth = 0.2,
			BodyDeadZoneHeight = 0.02,
			BodyDeadZoneDepth = 0.0,
			BodyUnlimitedSoftZone = false,
			BodySoftZoneWidth = 0.5,
			BodySoftZoneHeight = 0.5,
			BodyBiasX = 0.0,
			BodyBiasY = 0.0,
			AimTrackedObjectOffsetX = 0.0,
			AimTrackedObjectOffsetY = 0.0,
			AimTrackedObjectOffsetZ = 0.0,
			AimHorizontalDamping = 0.2,
			AimVerticalDamping = 0.2,
			AimScreenX = 0.5,
			AimScreenY = 0.48,
			AimDeadZoneWidth = 0.05,
			AimDeadZoneHeight = 0.05,
			AimSoftZoneWidth = 0.6,
			AimSoftZoneHeight = 0.6,
			AimBiasX = 0.0,
			AimBiasY = 0.0
		},
		MaxOffset = {
			BodyTrackedObjectOffsetX = 0.0,
			BodyTrackedObjectOffsetY = 0.0,
			BodyTrackedObjectOffsetZ = 0.0,
			BodyXDamping = 0.2,
			BodyYDamping = 0.2,
			BodyZDamping = 0.2,
			BodyScreenX = 0.5,
			BodyScreenY = 0.52,
			BodyCameraDistance = 4.0,
			BodyDeadZoneWidth = 0.2,
			BodyDeadZoneHeight = 0.02,
			BodyDeadZoneDepth = 0.0,
			BodyUnlimitedSoftZone = false,
			BodySoftZoneWidth = 0.5,
			BodySoftZoneHeight = 0.5,
			BodyBiasX = 0.0,
			BodyBiasY = 0.0,
			AimTrackedObjectOffsetX = 0.0,
			AimTrackedObjectOffsetY = 0.0,
			AimTrackedObjectOffsetZ = 0.0,
			AimHorizontalDamping = 0.2,
			AimVerticalDamping = 0.2,
			AimScreenX = 0.5,
			AimScreenY = 0.48,
			AimDeadZoneWidth = 0.05,
			AimDeadZoneHeight = 0.05,
			AimSoftZoneWidth = 0.6,
			AimSoftZoneHeight = 0.6,
			AimBiasX = 0.0,
			AimBiasY = 0.0
		}
	},
	HorizontaltOffset = {
		MinValue = 0.0,
		MaxValue = 0.0,
		MinOffset = {
			BodyTrackedObjectOffsetX = 0.0,
			BodyTrackedObjectOffsetY = 0.0,
			BodyTrackedObjectOffsetZ = 0.0,
			BodyXDamping = 0.2,
			BodyYDamping = 0.2,
			BodyZDamping = 0.2,
			BodyScreenX = 0.5,
			BodyScreenY = 0.52,
			BodyCameraDistance = 4.0,
			BodyDeadZoneWidth = 0.2,
			BodyDeadZoneHeight = 0.02,
			BodyDeadZoneDepth = 0.0,
			BodyUnlimitedSoftZone = false,
			BodySoftZoneWidth = 0.5,
			BodySoftZoneHeight = 0.5,
			BodyBiasX = 0.0,
			BodyBiasY = 0.0,
			AimTrackedObjectOffsetX = 0.0,
			AimTrackedObjectOffsetY = 0.0,
			AimTrackedObjectOffsetZ = 0.0,
			AimHorizontalDamping = 0.2,
			AimVerticalDamping = 0.2,
			AimScreenX = 0.5,
			AimScreenY = 0.48,
			AimDeadZoneWidth = 0.05,
			AimDeadZoneHeight = 0.05,
			AimSoftZoneWidth = 0.6,
			AimSoftZoneHeight = 0.6,
			AimBiasX = 0.0,
			AimBiasY = 0.0
		},
		MaxOffset = {
			BodyTrackedObjectOffsetX = 0.0,
			BodyTrackedObjectOffsetY = 0.0,
			BodyTrackedObjectOffsetZ = 0.0,
			BodyXDamping = 0.2,
			BodyYDamping = 0.2,
			BodyZDamping = 0.2,
			BodyScreenX = 0.5,
			BodyScreenY = 0.52,
			BodyCameraDistance = 4.0,
			BodyDeadZoneWidth = 0.2,
			BodyDeadZoneHeight = 0.02,
			BodyDeadZoneDepth = 0.0,
			BodyUnlimitedSoftZone = false,
			BodySoftZoneWidth = 0.5,
			BodySoftZoneHeight = 0.5,
			BodyBiasX = 0.0,
			BodyBiasY = 0.0,
			AimTrackedObjectOffsetX = 0.0,
			AimTrackedObjectOffsetY = 0.0,
			AimTrackedObjectOffsetZ = 0.0,
			AimHorizontalDamping = 0.2,
			AimVerticalDamping = 0.2,
			AimScreenX = 0.5,
			AimScreenY = 0.48,
			AimDeadZoneWidth = 0.05,
			AimDeadZoneHeight = 0.05,
			AimSoftZoneWidth = 0.6,
			AimSoftZoneHeight = 0.6,
			AimBiasX = 0.0,
			AimBiasY = 0.0,
			
			
			
			},
		}
}

--尾狐技能相机
Config.CameraParams[600060006] = {

	--地面水平距离差Aim相关参数
	MinDis = 3,
	MaxDis = 15,
	MinBodyScreenX = 0.3,
	MaxBodyScreenX = 0.3,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.45,
	MinAimScreenY = 0.5,
	MaxAimScreenY = 0.6,
	MinAimScreenX = 0.5,
	MaxAimScreenX = 0.6,
	MinAimDeadZoneHeight = 0.02,
	MaxAimDeadZoneHeight = 0.01,
	MinAimSoftZoneHeight = 0.04,
	MaxAimSoftZoneHeight = 0.02,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.05,
	MinAimSoftZoneWidth = 0.2,
	MaxAimSoftZoneWidth = 0.2,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 4,
	MaxCameraDistance = 4,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 1,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = 0,
	MaxYdif = 8,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.1,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.3,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0.05,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0.1,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
}

--恶来卒
Config.CameraParams[600140002] = {

	--地面水平距离差Aim相关参数
	MinDis = 3,
	MaxDis = 15,
	MinBodyScreenX = 0.3,
	MaxBodyScreenX = 0.3,
	MinBodyScreenY = 0.5,
	MaxBodyScreenY = 0.45,
	MinAimScreenY = 0.5,
	MaxAimScreenY = 0.6,
	MinAimScreenX = 0.5,
	MaxAimScreenX = 0.6,
	MinAimDeadZoneHeight = 0.02,
	MaxAimDeadZoneHeight = 0.01,
	MinAimSoftZoneHeight = 0.04,
	MaxAimSoftZoneHeight = 0.02,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.05,
	MinAimSoftZoneWidth = 0.2,
	MaxAimSoftZoneWidth = 0.2,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 4,
	MaxCameraDistance = 4,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 1,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = -1,
	MaxCameraYPosition = 1,

	--高度差Aim相关参数
	MinYdif = 0,
	MaxYdif = 8,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0.1,
	MinYdifAimScreenY = 0,
	MaxYdifAimScreenY = -0.3,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0.05,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0.1,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
}


--义向下砸连携特写
Config.CameraParams[100506301] = {

	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenX = 0.7,
	MaxBodyScreenX = 0.7,
	MinBodyScreenY = 0.25,	--0.4
	MaxBodyScreenY = 0.25,	--0.4
	MinAimScreenY = 0.5,
	MaxAimScreenY = 0.5,
	MinAimScreenX = 0.3,
	MaxAimScreenX = 0.3,
	MinAimDeadZoneHeight = 0.02,
	MaxAimDeadZoneHeight = 0.01,
	MinAimSoftZoneHeight = 0.04,
	MaxAimSoftZoneHeight = 0.02,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.05,
	MinAimSoftZoneWidth = 0.2,
	MaxAimSoftZoneWidth = 0.2,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 3.5,
	MaxCameraDistance = 3.5,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = 0,
	MaxCameraYPosition = 0,

	--高度差Aim相关参数
	MinYdif = -3,
	MaxYdif = 0.5,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0,
	MinYdifAimScreenY = 1,
	MaxYdifAimScreenY = 0,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0.05,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0.1,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
}


--义向下砸连携
Config.CameraParams[100506302] = {
	--地面水平距离差Aim相关参数
	MinDis = 4,
	MaxDis = 10,
	MinBodyScreenX = 0.5,
	MaxBodyScreenX = 0.5,
	MinBodyScreenY = 0.35,	--0.4
	MaxBodyScreenY = 0.35,	--0.4
	MinAimScreenY = 0.4,
	MaxAimScreenY = 0.4,
	MinAimScreenX = 0.4,
	MaxAimScreenX = 0.4,
	MinAimDeadZoneHeight = 0.4,
	MaxAimDeadZoneHeight = 0.4,
	MinAimSoftZoneHeight = 0.2,
	MaxAimSoftZoneHeight = 0.2,
	MinAimDeadZoneWidth = 0.05,
	MaxAimDeadZoneWidth = 0.05,
	MinAimSoftZoneWidth = 0.2,
	MaxAimSoftZoneWidth = 0.2,

	--地面水平距离差镜头距离最大/小值
	MinCameraDistance = 4,
	MaxCameraDistance = 4,

	--高度差镜头距离最大/小值
	MinYCameraDistance = 0,
	MaxYCameraDistance = 0,

	--镜头Y轴偏移最大/小值
	EnableMinCameraYPosition = false,
	MinCameraYPosition = 0,
	MaxCameraYPosition = 0,

	--高度差Aim相关参数
	MinYdif = -3,
	MaxYdif = 0.5,
	MinYdifBodyScreenY = 0,
	MaxYdifBodyScreenY = 0,
	MinYdifAimScreenY = 1,
	MaxYdifAimScreenY = 0,
	MinYdifAimDeadZoneHeight = 0,
	MaxYdifAimDeadZoneHeight = 0.05,
	MinYdifAimSoftZoneHeight = 0,
	MaxYdifAimSoftZoneHeight = 0.1,
	MinYdifAimDeadZoneWidth = 0,
	MaxYdifAimDeadZoneWidth = 0,
	MinYdifAimSoftZoneWidth = 0,
	MaxYdifAimSoftZoneWidth = 0,
}
