Config = Config or {}
Config.EntityCommonConfig = Config.EntityCommonConfig or {}
local EntityCommonConfig = Config.EntityCommonConfig
local AnimatorNames = {
	Idle = "Stand1",
	Born = "Born",
	FightIdle = "Stand2",
	InjuredIdle = "InjuredStand",
	WalkStart = "WalkStart",
	Walk = "Walk",
	WalkEnd = "WalkEnd",
	WalkBack = "WalkBack",
	WalkLeft = "WalkLeft",
	WalkRight = "WalkRight",
	Run = "Run",
	RunStart = "RunStart",
	RunStartEnd = "RunStartEnd",
	RunEnd = "RunEnd",
	Sprint = "Sprint",
	SprintEnd = "SprintEnd",
	InjuredWalk = "InjuredWalk",
	InjuredWalkEnd = "InjuredWalkEnd",
	Dying = "Death",
	FightToLeisurely = "StandChange",
	Stun = "Stun",
	JumpUp = "JumpUp",
	JumpLand = "JumpLand",
	JumpUpRun = "JumpUpRun",
	JumpUpSprint = "JumpUpSprint",
	JumpUpDouble = "JumpUpDouble",
	JumpLandHard = "JumpLandHard",
	JumpLandRoll = "JumpLandRoll",
	JumpDown = "JumpDown",
	RunStartLand = "RunStartLand",
	SprintStartLand = "SprintStartLand",
	AimUp = "AimUp", 
	Aiming = "Aiming", 
	AimShoot = "AimShoot", 
	AimDown = "AimDown",
	StrideOver = "Climb",
	SwimIdle = "SwimStand",
	Swimming = "Swim",
	FastSwimming = "SwimFast",
	Drowning = "SwimDeath",
	StartClimb = "ClimbingJumpStart",
	Climbing = "Climbing",
	ClimbIdle = "ClimbingStand",
	ClimbingRunStart = "ClimbingRunStart",
	ClimbingRun = "ClimbingRunLoop",
	ClimbingRunEnd = "ClimbingRunEnd",
	ClimbingJump = "ClimbingJump",
	GlideStart = "GlideStart",
	GlideLoopLeft = "GlideLeft",
	GlideLoopRight = "GlideRight",
	GlideLoop = "Gliding",
	GlideLoopFront = "GlideFront",
}


local Anim2SubAnim = {
	[AnimatorNames.WalkStart] = {"WalkStartRight", "WalkStartLeft"},
	[AnimatorNames.WalkEnd] = {"WalkEndRight", "WalkEndLeft"},
	[AnimatorNames.RunStartEnd] = {"RunStartEndRight", "RunStartEndLeft"},
	[AnimatorNames.RunEnd] = {"RunEndRight", "RunEndLeft"},
	[AnimatorNames.SprintEnd] = {"SprintEndRight", "SprintEndLeft"},
	[AnimatorNames.InjuredWalkEnd] = {"InjuredEndRight", "InjuredEndLeft"},
	[AnimatorNames.JumpUpRun] = {"JumpUpRunLeft", "JumpUpRunRight"},
	[AnimatorNames.JumpUpSprint] = {"JumpUpSprintLeft", "JumpUpSprintRight"},
	[AnimatorNames.JumpDown] = {"JumpDownLeft", "JumpDownRight"},
	[AnimatorNames.RunStartLand] = {"RunStartLandLeft", "RunStartLandRight"},
	[AnimatorNames.SprintStartLand] = {"SprintStartLandLeft", "SprintStartLandRight"},
	[AnimatorNames.JumpUpDouble] = {"JumpUpDoubleLeft", "JumpUpDoubleRight"},
	[AnimatorNames.JumpLandRoll] = {"JumpLandRollLeft", "JumpLandRollRight"},
}

EntityCommonConfig.AnimMaskAnimation =
{
	["AimUpIdle"] = {{animation = "AimUp", layer = "AimLayer"}, {animation = "Idle", layer = "AimWalkLayer"}},
	["AimingIdle"] = {{animation = "Aiming", layer = "AimLayer"}, {animation = "Idle", layer = "AimWalkLayer"}},
	["AimShootIdle"] = {{animation = "AimShoot", layer = "AimLayer"}, {animation = "Idle", layer = "AimWalkLayer"}},
	["AimDownIdle"] = {{animation = "AimDown", layer = "AimLayer"}, {animation = "Idle", layer = "AimWalkLayer"}},

	["AimUpWalk"] = {{animation = "AimUp", layer = "AimLayer"}, {animation = "Walk", layer = "AimWalkLayer"}},
	["AimingWalk"] = {{animation = "Aiming", layer = "AimLayer"}, {animation = "Walk", layer = "AimWalkLayer"}},
	["AimShootWalk"] = {{animation = "AimShoot", layer = "AimLayer"}, {animation = "Walk", layer = "AimWalkLayer"}},
	["AimDownWalk"] = {{animation = "AimDown", layer = "AimLayer"}, {animation = "Walk", layer = "AimWalkLayer"}},
}

local HitNames = {
	[1] = "LeftSlightHit",
	[2] = "RightSlightHit",
	[3] = "LeftHeavyHit",
	[4] = "RightHeavyHit",
	[5] = "HitDown",
	[6] = "PressDown",
	[71] = "HitFlyUp",
	[72] = "HitFlyUpLoop",
	[73] = "HitFlyFall",
	[74] = "HitFlyFallLoop",
	[75] = "HitFlyHover",
	[76] = "HitFlyLand",
	[20] = "Lie",
	[21] = "StandUp",
}

local EventType = {
	FootSwitch = 1,
}

local FootType = {
	Left = 1,
	Right = 2,
}

EntityCommonConfig.AnimatorNames = AnimatorNames
EntityCommonConfig.AnimatorNames.HitNames = HitNames
EntityCommonConfig.EventType = EventType
EntityCommonConfig.FootType = FootType
EntityCommonConfig.Anim2SubAnim = Anim2SubAnim

--跳跃参数
EntityCommonConfig.JumpParam = {
	
	--跳跃初速度相关
	JumpUpSpeed = 9,			--原地跳向上初速度-- 9
	JumpUpRunSpeed = 10,		--跑跳向上初速度--
	JumpUpSprintSpeed = 10,		--疾跑跳向上初速度--
	JumpUpDoubleSpeed = 10,		--二段跳向上初速度--
	
	--重力相关
	Gravity = -10,					--基本重力--
	JumpSpeedAcceleration = -23,	--跳跃额外加速度--
	MaxFallSpeed = -20,				--跳跃下落最大速度--
	
	--跳跃水平速度相关
	StandJumpPlaneSpeed = 1,	--(播放时无摇杆操作，播放后才操作)原地跳水平速度--
	JumpPlaneSpeed = 1.5,		--走跳水平速度--
	JumpRunPlaneSpeed = 5,		--跑跳水平速度--
	JumpSprintPlaneSpped = 8,	--疾跑跳水平速度--
	
	--着地相关
	JumpBreakTime = 0.03,			--原地着地打断时间--
	LandHardBreakTime = 0.4, 		--高空着地打断时间--
	LandHardSpeed = -20, 			--高空着地播放所需下落速度--
	RunStartLandBreakTime = 0.03,	--落地起跑打断时间(持续摇杆输入会播完接跑步)--
	ProactiveLandBreakTime = 0.3, 	--主动落地打断时间--
	LandRollSpeed = -20,			--落地翻滚所需下落速度--
	LandRollBreakTime = 0.37,		--落地翻滚打断时间--

	--二段跳相关
	StandDoubleJumpPlaneSpeed = 1,		--(播放时无摇杆操作，播放后才操作)二段跳水平速度--
	DoubleJumpPlaneSpeed = 5,			--(原地跳/走跳)二段跳水平速度--
	DoubleJumpRunPlaneSpeed = 5,		--(跑跳)二段跳水平速度--
	DoubleJumpSprintPlaneSpeed = 5, 	--(疾跑跳)二段跳水平速度--
	DoubleJumpNeedTime = 0.18,			--(任意起跳后)二段跳释放延迟时间--
	DoubleJumpNeedHeight = 0.1,			--二段跳释放必要离地高度--
	DoubleJumpStartHeight = 1,			--二段跳释放必要头顶距离--

	--主动下落相关
	ProactiveDownSpeed = 0,				--主动下落初始速度--
	ProactiveDownAcceleration = -300,	--主动下落加速度--
	ProactiveJumpDownTime = 0,		--(任意起跳后)主动下落释放延迟时间--
	ProactiveJumpDownHeight = 1.5,		--主动下落释放必要离地高度--

	-- 切人
	JumpUpChangeRoleTime = 0.1,			-- 起跳后可以切人的时间

	KeyRecordFrame = 15

}

EntityCommonConfig.LogicPlayEffect = {
	SwimJumpTo = 200010001,
	SwimIdle = 200010002,
	Swim = 200010003,
	SwimFast = 200010005,
	SwimFastPat = 200010006,
	WaterWalk = 200010007,
	Drowning = 200010008,
	
	DoubleJump = 1000000008,
	JumpLand = 1000000009,
}

EntityCommonConfig.SwimParam = {

	--游泳速度相关
	SwimmingSpeed = 2,				--游泳速度--
	FastSwimmingSpeed = 4,			--快速游泳速度--
	JumpIntoSpeed = 10,				--最大跳入水初速度--
	
	--游泳角速度相关
	SwimmingRotateSpeed = 180,		--游泳角速度--
	FastSwimmingRotateSpeed = 100,	--快速游泳角速度--
	
	--下沉加速度相关
	FallDownAcc = 0.01,				--下沉加速度初始值--
	FallDownAccOffset = 1,			--下沉加速度变化值--
	FallDownMaxAcc = 15,			--下沉加速度最大值--
	FallDownMaxDistance = 3,		--下沉最大深度--

	--上浮加速度相关
	FloatAcc = 0.01,				--上浮加速度初始值--
	FloatAccOffset = 0.02,			--上浮加速度变化值--
	FloatMaxAcc = 0.1,				--上浮加速度最大值--
	FloatMaxSpeed = 1,				--上浮最大速度--
	
	--停止游泳的惯性减速度
	StopSwimmingAcc = 0.11,			--停止游泳的惯性减速度--
	StopFastSwimmingAcc = 0.17,		--停止速泳的惯性减速度--
	
	--特效
	SwimStandEffectPlayInterval = 0.7,		--浮水水花特效播放间隔
	SwimEffectPlayInterval = 0.2,			--游泳水花特效播放间隔
	SwimFastPatEffectPlayInterval = 0.2,	--速泳拍打水花特效播放间隔
	WaterWalkEffectPlayInterval = 0.2,		--水面行走水花特效播放间隔
}

--动画时间
EntityCommonConfig.AnimatorTimes = {
	[FightEnum.EntityJumpState.JumpUp] = 1.733,
	[FightEnum.EntityJumpState.JumpUpRun] = 1.5,
	[FightEnum.EntityJumpState.JumpUpSprint] = 1.533,
	[FightEnum.EntityJumpState.JumpUpDouble] = 1.9,
	[FightEnum.EntityJumpState.JumpLand] = 0.8,
	[FightEnum.EntityJumpState.JumpLandHard] = 1.267,
	[FightEnum.EntityJumpState.RunStartLand] = 0.8,
	[FightEnum.EntityJumpState.SprintStartLand] = 0.2,
	[FightEnum.EntityJumpState.JumpLandRoll] = 1.5,
}

--摔落伤害参数
EntityCommonConfig.JumpHurt = {
	CheckHeightHurt = 12,    -- 着地受伤高度
	PercentHeightHurt = 25,  -- 基础受伤百分比
	HeightHurtParam = 1,    -- 每0.1米掉落百分比
}

--瞄准参数
EntityCommonConfig.AimParam = {
	AimMinDistance = 2.5,     -- 瞄准最近距离
	AimMaxDistance = 50,    -- 瞄准最远距离
}


EntityCommonConfig.AimMousePC = 
{
	X = 2,
	Y = 2,
	AccTimeX = 0.06,
	DecTimeX = 0.1,
	AccTimeY = 0.06,
	DecTimeY = 0.1,
}

EntityCommonConfig.AimMousePhone = 
{
	X = 0.35,
	Y = 0.25,
	AccTimeX = 0.06,
	DecTimeX = 0.1,
	AccTimeY = 0.06,
	DecTimeY = 0.1,
}

EntityCommonConfig.AimWeakMouseMoveParam = 0.3

EntityCommonConfig.HitState = {
	[0] = "None",
	[1] = "LeftLightHit",
	[2] = "RightLightHit",
	[3] = "LeftHeavyHit",
	[4] = "RightHeavyHit",
	[5] = "HitDown",
	[6] = "PressDown",
	[7] = "HitFly",
	[71] = "HitFlyUp",
	[72] = "HitFlyUpLoop",
	[73] = "HitFlyFall",
	[74] = "HitFlyFallLoop",
	[75] = "HitFlyHover",
	[76] = "HitFlyLand",
	[20] = "Lie",
	[21] = "StandUp",
}

EntityCommonConfig.AssassinateMinLvDiff = 8 --等级差高于该值才开始对暗杀有等级压制
EntityCommonConfig.AssassinateLvParam = 0.05 --每一级压制减少的伤害百分比


EntityCommonConfig.AimViewSearch =
{
	MinViewSize = 1,
	MaxViewSize = 1,
	ViewDistanceParam = 0.05,
	CheckViewDegree = 30,
}

EntityCommonConfig.AimLockTarget =
{
	MinSpeedX = 0.05,
	MaxSpeedX = 0.03,
	MinSpeedY = 0.03,
	MaxSpeedY = 0.02,
}
