FightEnum = {}

FightEnum.FightState = {
	None = 0,
	Loading = 1,
	Fighting = 2,
	Pause = 3,
	Exit = 4,
}

FightEnum.FightResult = 
{
	None = 0,
	Win  = 1,
	Lose = 2,
	Exit = 3,
}

FightEnum.KeyEvent = {
	Move = 1001, --移动
	Attack = 1002, --攻击
	Dodge = 1003, --闪避
	UltimateSkill = 1004, --大招
	NormalSkill = 1005, --普通技能
	BlueSkill = 1006, --
	Interaction = 1007, --交互
	Partner = 1008, --月灵
	Change1 = 1009, --换人
	Change2 = 1010, --换人
	Lock = 1011,    --锁定
	ScreenPress = 1012, --屏幕按下
	ScreenMove = 1013,  --屏幕移动

	Common1 = 1014, --通用Key
	Common2 = 1015, --通用Key
	Common3 = 1016, --通用Key
	Common4 = 1017, --通用Key
	Common5 = 1018, --通用Key
	Common6 = 1019, --通用Key
	Common7 = 1020, --通用Key
	Common8 = 1021, --通用Key
	AttackJ = 1022, -- 特殊的连点攻击J

	GuideClick = 1023,
	GuideTimeout = 1024,
	Jump = 1025,	--跳跃
	Change3 = 1026,	-- 换人
	LeaveClimb = 1027, -- 离开攀爬
	Aim = 1028, --瞄准
	Run = 1029,
	MoveMode = 1030,
	CommonQTE = 1031,
	Map = 1032,
	Back = 1033, -- 返回
	System = 1034,
	Team = 1035,
	Character = 1036,
	Backpack = 1037,
	Mission = 1038,
	Tutorial = 1039,
	AimMode = 1040,
	AutoPlay = 1041, -- 自动播放
	Skip = 1042, -- 跳过剧情
	Next = 1043, -- 下一段对话
	History = 1044, -- 回顾剧情
	ClimbRun = 1045, -- 爬跑
	PartnerSkill = 1046, -- 月灵天赋技能
	Activity = 1047, -- 活动
	Adventure = 1048, -- 冒险
	MouseScroll = 1049, --鼠标滚轮

	--骇入部分
	QuitHack = 1147,
	HackUpButton = 1148,
	HackDownButton = 1149,
	HackLeftButton = 1150,
	HackRightButton = 1151,
	HackShiftBuild = 1152,
	HackQuitMonitor = 1153,
	MonitorZoom = 1154,
	--End

	--建造部分
	Build = 1250,
	QuitBuild = 1251,
	RollUp = 1252,
	RollDown = 1253,
	RollLeft = 1254,
	RollRight = 1255,
	TurnUp = 1256,
	TurnDown = 1257,
	TurnForward = 1258,
	TurnBack = 1259,
	SelectModeIn = 1260,
	CancelSelect = 1261,
	RemoveJoint = 1262,
	DisablePlayerMove = 1263,
	TakeIn = 1264,
	LayUp = 1265,
	--End

	--驾驶部分
	Drone_Move = 1359,
	Drone_Fly = 1360,
	QuitFly = 1361,
	Activation = 1362,
	Accel = 1363,

	--照相
	TakePhoto = 1464,
	InPhoto = 1465,
	SwitchCamera = 1467,
	Zoom = 1468,
	--End

	--驾驶部分
	BluePrint = 1674,
	--End
	
	Drone_Brake = 75,
	Drone_Boost = 76,
	QuitPhoto = 77,
	Drone_Down = 78,
	UI_OpenMap = 79,
	UI_OpenTask = 80,

	--第三人称拍照1
	MovePhotoCamera = 1801,
	PlayerAction = 1802,
	ResetCamera = 1803,

	--调查模式
	Advance = 1901,
	BackOff = 1902,
	EscExplore = 1903,
	Inspect = 1904,

	--剧情补充部分
	Select1 = 1905,
	Select2 = 1906,
	Select3 = 1907,
	Select4 = 1908,
	Select5 = 1909,

	-- 缔结月灵
	ChangeConcludeItem = 2001,
}

FightEnum.CommonKeyIndex = 
{
	[1] = FightEnum.KeyEvent.Common1,
	[2] = FightEnum.KeyEvent.Common2,
	[3] = FightEnum.KeyEvent.Common3,
	[4] = FightEnum.KeyEvent.Common4,
	[5] = FightEnum.KeyEvent.Common5,
	[6] = FightEnum.KeyEvent.Common6,
	[7] = FightEnum.KeyEvent.Common7,
	[8] = FightEnum.KeyEvent.Common8,
}

FightEnum.KeyEventToAction =
{
	[FightEnum.KeyEvent.ScreenMove] = "ScreenMove",
	[FightEnum.KeyEvent.ScreenPress] = "ScreenPress",
	[FightEnum.KeyEvent.Move] = "Move",
	[FightEnum.KeyEvent.Attack] = "Attack",
	[FightEnum.KeyEvent.Dodge] = "Dodge",
	[FightEnum.KeyEvent.NormalSkill] = "NormalSkill",
	[FightEnum.KeyEvent.UltimateSkill] = "UltimateSkill",
	[FightEnum.KeyEvent.Partner] = "Partner",
	[FightEnum.KeyEvent.Interaction] = "Interaction",
	[FightEnum.KeyEvent.Jump] = "Jump",
	[FightEnum.KeyEvent.Run] = "Run",
	[FightEnum.KeyEvent.LeaveClimb] = "LeaveClimb",
	[FightEnum.KeyEvent.Aim] = "Aim",
	[FightEnum.KeyEvent.Change1] = "Change1",
	[FightEnum.KeyEvent.Change2] = "Change2",
	[FightEnum.KeyEvent.Change3] = "Change3",
	[FightEnum.KeyEvent.MoveMode] = "MoveMode",
	[FightEnum.KeyEvent.Lock] = "Lock",
	[FightEnum.KeyEvent.CommonQTE] = "CommonQTE",
	[FightEnum.KeyEvent.Map] = "Map",
	[FightEnum.KeyEvent.Back] = "Back",
	[FightEnum.KeyEvent.System] = "System",
	[FightEnum.KeyEvent.Team] = "Team",
	[FightEnum.KeyEvent.Character] = "Character",
	[FightEnum.KeyEvent.Backpack] = "Backpack",
	[FightEnum.KeyEvent.Mission] = "Mission",
	[FightEnum.KeyEvent.Tutorial] = "Tutorial",
	[FightEnum.KeyEvent.AimMode] = "AimMode",
	[FightEnum.KeyEvent.AutoPlay] = "AutoPlay",
	[FightEnum.KeyEvent.Skip] = "Skip",
	[FightEnum.KeyEvent.Next] = "Next",
	[FightEnum.KeyEvent.History] = "History",
	[FightEnum.KeyEvent.ClimbRun] = "ClimbRun",
	[FightEnum.KeyEvent.PartnerSkill] = "PartnerSkill",
	[FightEnum.KeyEvent.Activity] = "Activity",
	[FightEnum.KeyEvent.Adventure] = "Adventure",
	[FightEnum.KeyEvent.MouseScroll] = "MouseScroll",


	[FightEnum.KeyEvent.QuitHack] = "QuitHack",
	[FightEnum.KeyEvent.HackUpButton] = "HackUpButton",
	[FightEnum.KeyEvent.HackDownButton] = "HackDownButton",
	[FightEnum.KeyEvent.HackLeftButton] = "HackLeftButton",
	[FightEnum.KeyEvent.HackRightButton] = "HackRightButton",
	[FightEnum.KeyEvent.HackShiftBuild] = "HackShiftBuild",
	[FightEnum.KeyEvent.HackQuitMonitor] = "HackQuitMonitor",
	[FightEnum.KeyEvent.MonitorZoom] = "MonitorZoom",

	[FightEnum.KeyEvent.QuitBuild] = "QuitBuild",
	[FightEnum.KeyEvent.RollUp] = "RollUp",
	[FightEnum.KeyEvent.RollDown] = "RollDown",
	[FightEnum.KeyEvent.RollLeft] = "RollLeft",
	[FightEnum.KeyEvent.RollRight] = "RollRight",
	[FightEnum.KeyEvent.TurnUp] = "TurnUp",
	[FightEnum.KeyEvent.TurnDown] = "TurnDown",
	[FightEnum.KeyEvent.TurnForward] = "TurnForward",
	[FightEnum.KeyEvent.TurnBack] = "TurnBack",
	[FightEnum.KeyEvent.BluePrint] = "BluePrint",
	[FightEnum.KeyEvent.SelectModeIn] = "SelectModeIn",
	[FightEnum.KeyEvent.CancelSelect] = "CancelSelect",
	[FightEnum.KeyEvent.RemoveJoint] = "RemoveJoint",
	[FightEnum.KeyEvent.DisablePlayerMove] = "DisablePlayerMove",
	[FightEnum.KeyEvent.TakeIn] = "TakeIn",
	[FightEnum.KeyEvent.LayUp] = "LayUp",

	[FightEnum.KeyEvent.Drone_Move] = "Drone_Move",
	[FightEnum.KeyEvent.Drone_Fly] = "Drone_Fly",
	[FightEnum.KeyEvent.QuitFly] = "QuitFly",
	[FightEnum.KeyEvent.Activation] = "Activation",
	[FightEnum.KeyEvent.Accel] = "Accel",

	[FightEnum.KeyEvent.TakePhoto] = "TakePhoto",
	[FightEnum.KeyEvent.QuitPhoto] = "QuitPhoto",
	[FightEnum.KeyEvent.InPhoto] = "InPhoto",
	[FightEnum.KeyEvent.SwitchCamera] = "SwitchCamera",
	[FightEnum.KeyEvent.Zoom] = "Zoom",



	[FightEnum.KeyEvent.Drone_Brake] = "Drone_Brake",
	[FightEnum.KeyEvent.Drone_Boost] = "Drone_Boost",
	[FightEnum.KeyEvent.Drone_Down] = "Drone_Down",

	[FightEnum.KeyEvent.MovePhotoCamera] = "MovePhotoCamera",
	[FightEnum.KeyEvent.PlayerAction] = "PlayerAction",
	[FightEnum.KeyEvent.ResetCamera] = "ResetCamera",

	[FightEnum.KeyEvent.Advance] = "Advance",
	[FightEnum.KeyEvent.BackOff] = "BackOff",
	[FightEnum.KeyEvent.EscExplore] = "EscExplore",
	[FightEnum.KeyEvent.Inspect] = "Inspect",

	[FightEnum.KeyEvent.Select1] = "Select1",
	[FightEnum.KeyEvent.Select2] = "Select2",
	[FightEnum.KeyEvent.Select3] = "Select3",
	[FightEnum.KeyEvent.Select4] = "Select4",
	[FightEnum.KeyEvent.Select5] = "Select5",

	[FightEnum.KeyEvent.ChangeConcludeItem] = "ChangeConcludeItem",

}

FightEnum.ActionToKeyEvent =
{
	ScreenMove = FightEnum.KeyEvent.ScreenMove,
	ScreenPress = FightEnum.KeyEvent.ScreenPress,
	Move = FightEnum.KeyEvent.Move,
	Attack = FightEnum.KeyEvent.Attack,
	Dodge = FightEnum.KeyEvent.Dodge,
	NormalSkill = FightEnum.KeyEvent.NormalSkill,
	UltimateSkill = FightEnum.KeyEvent.UltimateSkill,
	Partner = FightEnum.KeyEvent.Partner,
	Interaction = FightEnum.KeyEvent.Interaction,
	Jump = FightEnum.KeyEvent.Jump,
	Run = FightEnum.KeyEvent.Run,
	LeaveClimb = FightEnum.KeyEvent.LeaveClimb,
	Aim = FightEnum.KeyEvent.Aim,
	Change1 = FightEnum.KeyEvent.Change1,
	Change2 = FightEnum.KeyEvent.Change2,
	Change3 = FightEnum.KeyEvent.Change3,
	MoveMode = FightEnum.KeyEvent.MoveMode,
	Lock = FightEnum.KeyEvent.Lock,
	CommonQTE = FightEnum.KeyEvent.CommonQTE,
	Map = FightEnum.KeyEvent.Map,
	Back = FightEnum.KeyEvent.Back,
	System = FightEnum.KeyEvent.System,
	Team = FightEnum.KeyEvent.Team,
	Character = FightEnum.KeyEvent.Character,
	Backpack = FightEnum.KeyEvent.Backpack,
	Mission = FightEnum.KeyEvent.Mission,
	Tutorial = FightEnum.KeyEvent.Tutorial,
	AimMode = FightEnum.KeyEvent.AimMode,
	Next = FightEnum.KeyEvent.Next,
	History = FightEnum.KeyEvent.History,
	Skip = FightEnum.KeyEvent.Skip,
	AutoPlay = FightEnum.KeyEvent.AutoPlay,
	ClimbRun = FightEnum.KeyEvent.ClimbRun,
	Adventure = FightEnum.KeyEvent.Adventure,
	Activity = FightEnum.KeyEvent.Activity,
	PartnerSkill = FightEnum.KeyEvent.PartnerSkill,
	MouseScroll = FightEnum.KeyEvent.MouseScroll,

	QuitHack = FightEnum.KeyEvent.QuitHack,
	HackUpButton = FightEnum.KeyEvent.HackUpButton,
	HackDownButton = FightEnum.KeyEvent.HackDownButton,
	HackLeftButton = FightEnum.KeyEvent.HackLeftButton,
	HackRightButton = FightEnum.KeyEvent.HackRightButton,
	HackShiftBuild = FightEnum.KeyEvent.HackShiftBuild,
	HackQuitMonitor = FightEnum.KeyEvent.HackQuitMonitor,
	MonitorZoom = FightEnum.KeyEvent.MonitorZoom,

	QuitBuild = FightEnum.KeyEvent.QuitBuild,
	RollUp = FightEnum.KeyEvent.RollUp,
	RollDown = FightEnum.KeyEvent.RollDown,
	RollLeft = FightEnum.KeyEvent.RollLeft,
	RollRight = FightEnum.KeyEvent.RollRight,
	TurnUp = FightEnum.KeyEvent.TurnUp,
	TurnDown = FightEnum.KeyEvent.TurnDown,
	TurnForward = FightEnum.KeyEvent.TurnForward,
	TurnBack = FightEnum.KeyEvent.TurnBack,
	BluePrint = FightEnum.KeyEvent.BluePrint,
	SelectModeIn = FightEnum.KeyEvent.SelectModeIn,
	CancelSelect = FightEnum.KeyEvent.CancelSelect,
	RemoveJoint = FightEnum.KeyEvent.RemoveJoint,
	DisablePlayerMove = FightEnum.KeyEvent.DisablePlayerMove,
	TakeIn = FightEnum.KeyEvent.TakeIn,
	LayUp = FightEnum.KeyEvent.LayUp,

	Drone_Move = FightEnum.KeyEvent.Drone_Move,
	Drone_Fly = FightEnum.KeyEvent.Drone_Fly,
	QuitFly = FightEnum.KeyEvent.QuitFly,
	Activation = FightEnum.KeyEvent.Activation,
	Accel = FightEnum.KeyEvent.Accel,

	TakePhoto = FightEnum.KeyEvent.TakePhoto,
	QuitPhoto = FightEnum.KeyEvent.QuitPhoto,
	InPhoto = FightEnum.KeyEvent.InPhoto,
	SwitchCamera = FightEnum.KeyEvent.SwitchCamera,
	Zoom = FightEnum.KeyEvent.Zoom,

	Drone_Brake = FightEnum.KeyEvent.Drone_Brake,
	Drone_Boost = FightEnum.KeyEvent.Drone_Boost,
	Drone_Down = FightEnum.KeyEvent.Drone_Down,
	UI_OpenMap = FightEnum.KeyEvent.UI_OpenMap,
	UI_OpenTask = FightEnum.KeyEvent.UI_OpenTask,

	MovePhotoCamera = FightEnum.KeyEvent.MovePhotoCamera,
	PlayerAction = FightEnum.KeyEvent.PlayerAction,
	ResetCamera = FightEnum.KeyEvent.ResetCamera,

	Advance = FightEnum.KeyEvent.Advance,
	BackOff = FightEnum.KeyEvent.BackOff,
	EscExplore = FightEnum.KeyEvent.EscExplore,
	Inspect = FightEnum.KeyEvent.Inspect,

	Select1 = FightEnum.KeyEvent.Select1,
	Select2 = FightEnum.KeyEvent.Select2,
	Select3 = FightEnum.KeyEvent.Select3,
	Select4 = FightEnum.KeyEvent.Select4,
	Select5 = FightEnum.KeyEvent.Select5,
	ChangeConcludeItem = FightEnum.KeyEvent.ChangeConcludeItem,
}


FightEnum.InputActionPhase =
{
	Disabled = 0,
	Waiting = 1,
	Started = 2,
	Performed = 3,
	Canceled = 4,
}

FightEnum.Backstage = {
	Foreground = 1,
	Background = 2,
	Combination = 3,
}

FightEnum.EntityState = 
{
	None = 1,
	Born = 2,
	Idle = 3,
	FightIdle = 4,		--废弃中
	Move = 5,
	Pathfinding = 6,	--寻路
	Skill = 7,
	Hit = 8,
	Fall = 9,			--高处往低处掉
	Immobilize = 10,	--定身
	Perform = 11,		--演出
	Die = 12,
	Death = 13,
	Stun = 14,			--晕眩
	Jump = 15,
	Slide = 16,
	Climb = 18,
	Aim = 19,
	Swim = 20,
	CloseMenu = 21,		--关闭菜单
	Revive = 22,
	Glide = 23,
	Hack = 24,
	OpenDoor = 25,
	CommonAnim = 26,
	Build = 30,			-- 建造
}

FightEnum.EntityMoveSubState =
{
	None = 1,
	WalkStart = 2,
	Walk = 3,
	WalkEnd = 4,
	WalkBack = 5,
	WalkLeft = 6,
	WalkRight = 7,
	RunStart = 8,
	RunStartEnd = 9,
	Run = 10,
	RunEnd = 11,
	Sprint = 12,
	SprintEnd = 13,
	InjuredWalk = 14,
	InjuredWalkEnd = 15,
}

FightEnum.EntityAimState =
{
	AimStart = 1,
	Aiming = 2,
	AimShoot = 3,
	AimEnd = 4,
}

FightEnum.EntityMoveMode =
{
	None = 0,
	Walk = 1,
	Run = 2,
	InjuredWalk = 3,
}

FightEnum.EntityJumpState = {
	None = 0,
	JumpUp = 1,
	JumpLand = 2,
	JumpLandHard = 3,
	JumpUpRun = 4,
	JumpUpSprint = 5,
	JumpDown = 6,
	JumpUpDouble = 7,
	RunStartLand = 8,
	ProactiveDown = 9,
	ProactiveLand = 10,
	SprintStartLand = 11,
	MonsterLand = 12,
	JumpLandRoll = 13,
}

FightEnum.EntityClimbState = {
	None = 0,
	StartClimb = 1,
	Idle = 2,
	Climbing = 3,
	ClimbingJump = 4,
	ClimbingRunStart = 5,
	ClimbingRun = 6,
	ClimbingRunEnd = 7,
	ClimbStart2 = 16,
	ClimbJumpOver = 17,	-- 攀跳触顶
	ClimbRunOver = 18,	-- 攀跑触顶
	ClimbLand = 19,		-- 攀爬触底
	StrideOver = 20,	-- 攀爬触顶
	ClimbRun = 21,
	ClimbJump = 22,
	ClimbRunEnd = 23,
	ClimbRunStart = 24,
}

FightEnum.EntitySwimState = {
	None = 0,
	Idle = 1,
	Swimming = 2,
	FastSwimming = 3,
	Drowning = 4,
}

FightEnum.EntityTag =
{
	None = 0,
	Npc = 1,
	Bullet = 2,
	SceneObj = 3,
}

FightEnum.EntityNpcTag =
{
	None = 0,
	Player = 1,
	Monster = 2,
	Elite = 3,
	Boss = 4,
	Partner = 5,
	NPC = 6,
	Animal = 7,
	Car = 8,
	DisplayPartner = 9,
}

FightEnum.EntitySceneObjTag =
{
	None = 0,
	HackOrBuild = 1, --可骇入/建造物件
	CanHitObj = 2, --可攻击物件
	Decoration = 3, -- 演出设备
}

FightEnum.EntityNpcTagBit =
{
	None = 1 << 0,
	Player = 1 << 1,
	Monster = 1 << 2,
	Elite = 1 << 3,
	Boss = 1 << 4,
	Partner = 1 << 5,
	NPC = 1 << 6,
	Animal = 1 << 7,
	Car = 1 << 8,
	DisplayPartner = 1 << 8,
}

FightEnum.SysEntityOpType =
{
	Death = 1,
	Collect = 2,
	Item = 3,
	Transport = 4,
	NPC = 5,
}

FightEnum.EcoEntityType = {
	Transport = 1, 	--传送点
	Gear = 2,		--普通
	Monster = 3,	--死亡后自动移除
	Collect = 4,		--掉落物直接进背包
	Npc = 5		--npc
}

FightEnum.CreateEntityType = {
	Normal = 0,
	Ecosystem = 1,
	Npc = 2,
	Drop = 3,
	Mercenary = 4,
	Local = 5
}

--免疫类型
FightEnum.ImmunityType =
{
	-- 全免疫:移除所有被免疫的buff，并后续被免疫的buff也无法增加
	ImmunityAll = 1, 
	-- 免疫已有的:仅移除所有被免疫的buff
	ImmunityExists = 2,
	-- 免疫后加的:仅后续被免疫的buff也无法增加
	ImmunitAddition = 3,
}


FightEnum.EntityHitState =
{
	None = 0,
	LeftLightHit = 1,-- 左轻受击
	RightLightHit = 2,-- 右轻受击
	LeftHeavyHit = 3,-- 左重受击
	RightHeavyHit = 4,-- 右重受击
	HitDown = 5,--击倒
	PressDown = 6,--压倒
	HitFly= 7,--击飞
	HitFlyUp = 71,--浮空上升
	HitFlyUpLoop = 72,--滞空（循环上升）
	HitFlyFall = 73,--下落
	HitFlyFallLoop = 74,--滞空2（循环下落）
	HitFlyHover = 75,--浮空受击
	HitFlyLand = 76,--下落着地
	HitFlyFallRecover = 77, --滞空3(下落恢复)
	Lie = 20,--躺倒
	StandUp = 21,--起身
}

FightEnum.EntityHitFlyState =
{
	None = 1,
	FlyUp = 2,
	Hover = 3,
	FlyDown = 4,
	Down = 5,
}

FightEnum.HitType = 
{
	Ground = 1,  -- 地面受击
	Armor = 2, -- 霸体受击(强制位移)
	HitFly = 3, -- 击飞
	Aloft = 4, -- 空中再受击
}

FightEnum.EntityBuffState =
{
	None = 0,
	ImmuneDamage = 1, --免疫伤害
	ImmuneHit = 2, --免疫受击
	ImmuneCure = 3, --免疫治疗
	ImmuneForceMove = 4, --免疫强制位移
	ImmuneDie = 5, --免疫死亡（最低1点血量）
	ImmuneByCollision = 6, --不产生实体碰撞（会被别人挤开，不能挤开别人）
	ImmuneToCollision = 7, --不受实体碰撞（不会被别人挤开，能挤开别人）
	PauseEntityTime = 8, --暂停实体时间帧数
	PauseBehavior = 9, --暂停实体行为逻辑
	Stun = 10, --晕眩（播放晕眩动作；无法移动、释放技能)
	PauseTime = 11, --时停（暂停NPC时间；静止动作、技能事件；无法移动、释放技能）
	ImmuneAttackMagic = 12, --免疫子弹受击效果,
	Penetrable = 13, -- 可以穿墙（穿过可以穿的墙壁）
	Levitation = 14, -- 浮空（不会下坠）
	ImmuneHitRotate = 15,--免疫受击朝向
	ForceNormalHit = 16, -- 所有受击强制变为普通受击
	IgnoreCommonTimeScale = 17, --免疫全局速度
	ForbiddenImmuneHit = 18, --禁用免疫受击
	ImmuneBreakLieDown = 19, --免疫中断倒地
	ImmuneWorldCollision = 20, --不产生世界碰撞
	ImmuneDownDmg = 21, -- 免疫落地伤害,
	StickWithTerrain = 22, -- 随地形倾斜
	ImmuneStun = 23, -- 免疫眩晕
	PauseClientAnimation = 24, -- 暂停实体动画
	ImmuneArmorMove = 25, -- 免疫霸体受击位移
	ForceHitDown = 26, -- 强制击倒受击
	AbsoluteImmuneHit = 27, -- 绝对免疫受击(最高优先级,用于龙这类大体型,无受击动作的实体,不受禁用免疫受击的影响)
	PresentationOnly = 28, -- 由显示层控制transform逻辑，再向逻辑层同步
	TimeScaleIngoreChild = 29, -- 时间缩放不影响子实体
	BigSkillPause = 30, -- 大招时停
}

FightEnum.MoveType =
{
	AnimatorMoveData = 1, --使用动画移动数据
	Linera = 2, --直线运动
	Bind = 3,--绑定目标
	Track = 4, -- 追踪
	Curve = 5, -- 变速曲线
	TrackPoint = 6, -- 路径点
	Throw = 7, -- 扔，点到点曲线位移
}

FightEnum.SpeedParamType =
{
	Replace = 1, -- 替换，同时只作用一个Replace
	Additive = 2, --增量，与Replace一起和所有增量参数叠加作用
	Unique = 3, --唯一，存在时优先级最高，新unique会替换老unique
}
FightEnum.EntityIdleType =
{
	None = 1,
	FightIdle = 2, --战斗待机
	FightToLeisurely = 3, --战斗待机转休闲待机
	LeisurelyIdle = 4,--休闲待机
	InjuredIdle = 5,--受伤待机
}

FightEnum.HackState = {
	None = 0,
	HackStart = 1,
	Waiting = 2,
	Hacking = 3,
	BeingHacked = 4,
	HackInput = 5,
	HackEnd = 6,
}

FightEnum.OpenDoorState = {
	None = 0,
	OpenDoorStart = 1,
	Driving = 2,
	OpenDoorEnd = 3,
}

FightEnum.CommonAnimState = {
	None = 0,
	CommonAnimStart = 1,
	CommonAnimEnd = 2,
}

FightEnum.EntityBuildState =
{
	BuildIdle = 1,
	BuildStart = 2,
	BuildFail = 3,
	BuildMove = 4,
	BuildEnd = 5,
	BuildConsole = 6,
}

FightEnum.CollisionType =
{
	Sphere = 1,
	Cube = 2,
	Cylinder = 3,
	Circle = 4,
	Sector = 5, 	-- 扇形
	CylinderMesh = 6, 	--圆柱体网格
}

FightEnum.EntityCamp = 
{
	Camp0 = 0,--中立阵营
	Camp1 = 1,--阵营1
	Camp2 = 2,--阵营2
	Camp3 = 4,--阵营3
	Camp4 = 8,--阵营4
}

FightEnum.ComponentType =
{
	Attributes = 1,
	Transform = 2,
	Rotate = 3,
	Part = 4,
	Skill = 5,
	State = 6,
	Animator = 7,
	Attack = 8,
	Collision = 9,
	Dodge = 10,
	HandleMoveInput = 11,
	Hit = 12,
	Sync = 13,
	TimeoutDeath = 14,
	Tag = 15,
	Effect = 16,
	Pasv = 17,
	Trigger = 18,
	SkillSet = 19,
	CreateEntity = 20,
	Combination = 21,
	Ik = 22,
	ReboundAttack = 23,
	ElementState = 24,
	Camera = 25,
	Sound = 26,
	FindPath = 27,
	Condition = 28,
	Tp = 29,
	HackingInputHandle = 30,
	CustomFSM = 31,
	MovePlatform = 32,
	Blow = 33,
	Joint = 34,
	Display = 35,
	Lenght = 36,

	Move = 1000,
	Time = 1001,
	Behavior = 1002,
	Buff = 1003,
	FollowHalo = 1004,
	Climb = 1005,
	LifeBar = 1006,
	Swim = 1007,
	Death = 1008,
	CommonBehavior = 1009,
}

local ComponentType = FightEnum.ComponentType
FightEnum.ComponentConfigName =
{
	[ComponentType.Attributes] = "Attributes",
	[ComponentType.Transform] = "Transform",
	[ComponentType.Rotate] = "Transform",
	[ComponentType.Part] = "Part",
	[ComponentType.Skill] = "Skill",
	[ComponentType.State] = "State",
	[ComponentType.Animator] = "Animator",
	[ComponentType.Attack] = "Attack",
	[ComponentType.Collision] = "Collision",
	[ComponentType.Dodge] = "Dodge",
	[ComponentType.HandleMoveInput] = "HandleMoveInput",
	[ComponentType.Hit] = "Hit",
	[ComponentType.Sync] = "Sync",
	[ComponentType.TimeoutDeath] = "TimeoutDeath",
	[ComponentType.Tag] = "Tag",
	[ComponentType.Effect] = "Effect",
	[ComponentType.Pasv] = "Pasv",
	[ComponentType.Trigger] = "Trigger",
	[ComponentType.SkillSet] = "SkillSet",
	[ComponentType.CreateEntity] = "CreateEntity",
	[ComponentType.Combination] = "Combination",
	[ComponentType.Ik] = "Ik",
	[ComponentType.ReboundAttack] = "ReboundAttack",
	[ComponentType.ElementState] = "ElementState",
	[ComponentType.Camera] = "Camera",
	[ComponentType.Sound] = "Sound",
	[ComponentType.FindPath] = "FindPath",
	[ComponentType.Condition] = "Condition",
	[ComponentType.CommonBehavior] = "CommonBehavior",
	[ComponentType.Tp] = "Tp",
	[ComponentType.HackingInputHandle] = "HackingInputHandle",
	[ComponentType.CustomFSM] = "CustomFSM",
	[ComponentType.MovePlatform] = "MovePlatform",
	[ComponentType.Blow] = "Blow",
	[ComponentType.Joint] = "Joint",
	[ComponentType.Display] = "Display",
	

	[ComponentType.Move] = "Move",
	[ComponentType.Time] = "Time",
	[ComponentType.Behavior] = "Behavior",
	[ComponentType.Buff] = "Buff",
	[ComponentType.Climb] = "Climb",
	[ComponentType.LifeBar] = "LifeBar",
	[ComponentType.Swim] = "Swim",
	[ComponentType.Death] = "Death",
}

FightEnum.SkillEventType =
{
    CreateEntity = 1,
    PlayAnimation = 2,
    FrameSign = 3,
    CameraShake = 4,
    Log = 5,
    ActiveDodge = 6,
	Move = 7,
	Rotate = 8,
	AddBuff = 9,
	DoMagic = 10,
	EntitySign = 11,
	VerticalSpeed = 12,
	ReboundAttack = 13,
	CameraOffsets = 14,
	PlaySound = 15,
	PostProcess = 16,
	CameraCtrl = 17,
	PreciseTargetMove = 18,
	EnableAnimMove = 19,
	EarlyWarning = 20,
	CameraFixeds = 21,
	EnableAnimMoveWithAxis = 22,
	PreciseTargetRotate = 23,
	EnableCollision = 24,
	ActiveParry = 25,
	Suicide = 26,
	HideFightPanel = 27,
	CameraPosReduction = 28,
	PlayWeaponAnimation = 29,
	ShieldTimeAndCameraEffect = 30,
	PreciseTargetPointMove = 31,
	CamerFOVChange = 32,
	BreakCamerFOVChange = 33,
	MotionBlur = 34,
	HideAllEntity = 35,
	AddShadow = 36,
	AddScreenEffect = 37,
}

FightEnum.CameraState = 
{
	Operating = 1,--操作
	WeakLocking = 2,--弱锁
	ForceLocking = 3,--强锁定
	Fight = 99, -- 战斗相机
	PartnerContrlCamera = 100,--策划管理强锁定
	PartnerConnectCamera = 101,--策划管理强锁定

	Aiming = 4, -- 瞄准
	UI = 5, -- UI
	Dialog = 6, --npc对话
	OpenDoor = 7, -- 开门
	NpcShop = 8, -- npc商店
	Mailing = 9,
	CatchPartner = 10, -- 月灵捕捉
	Drone = 11, -- 无人机
	Level = 12, -- 关卡相机 是关卡动态创建的实体赋值
	Hacking = 13, -- 骇入相机
	Monitor = 14, -- 监视器相机（骇入相机之后的视角）
	Car = 15, -- 车
	Atomize = 16, -- 雾化穿梭
	Photo = 17, -- 拍照相机
	Building = 18, -- 建造
	TriPhoto = 19, -- 第三人称拍照相机
	Pause = 20, -- 第三人称拍照相机
	StoryExplore = 21, --剧情探索
}

FightEnum.CameraShakeType =
{
	Shake6D = 1,	--6D
	PositionX = 2,	--位移X
	PositionY = 3,	--位移Y
	PositionZ = 4,	--位移Z
	RotationX = 5,	--旋转X
	RotationY = 6,	--旋转Y
	RotationZ = 7,	--旋转Z
	
	Lenght = 8,	
}

FightEnum.ShieldCameraShakeType = {
	NoSelfShake = 1,
	AllShake = 2
}

FightEnum.ShieldPauseFrameType = {
	NoSelfPauseFrame = 1,
	AllPauseFrame = 2
}

FightEnum.UIType = 
{
	Main = 1,
	Tip = 2,
}

FightEnum.UIActiveType = 
{
	Root      = 1,--隐藏全部
	Main      = 2,--战斗主UI（摇杆、操作按钮等）
	Joystick  = 3,--摇杆
	Operation = 4,--操作按钮
}

FightEnum.EffectPosType = 
{
	BulletHeigh = 1, -- 子弹高度
}

FightEnum.QTEType =
{
	QTE = 1,
	Change = 2
}

FightEnum.QTEState =
{
	Enable = 1,
	UnEnable = 2,
	Cooling = 3,
	Ready = 4,
}

FightEnum.uiObjs = {}
FightEnum.FlyingText =
{
	hp = 1,
}

FightEnum.AttrGroupType = 
{
	Base = 1, --基础区
	Additvie = 2, --附加区
}

--属性转换类型
FightEnum.AttrTranslationType = 
{
	Percentage = 1,--百分比转换
	FixedValue = 2,
}


FightEnum.AttrValueType =
{
	Base = 1,
	Percent = 2,
}

FightEnum.AttrOverlayType = 
{
	Additvie = 1,
	Max = 2
}

FightEnum.EOverlayMode = 
{
	Superposition = 1,
	Refresh = 2,
	Inherit = 3,
}


FightEnum.SkillAttrType =
{
	Charge = 1, 	   -- 充能型
	Recover = 2,       -- 恢复型
	Accumulate = 3,    -- 积累型
	UseVisible = 4,    -- 使用显示型
	Base = 5,		   -- 基础类型
	CDTime = 6,
}

FightEnum.AttrSourceType =
{
	Buff = 1,
}

-- 技能类型
FightEnum.SkillType =
{
	NormalAttack = 1 << 1,
	Skill = 1 << 2,
	Core = 1 << 3,
	Unique = 1 << 4,
	UniqueStart = 1 << 5,
	Dodge = 1 << 6,
	ForwardDodge = 1 << 7,
	BackwardDodge = 1 << 8,
	JumpCounter = 1 << 9,
	JumpCounterTread = 1 << 10,
	JumpCounterAttack = 1 << 11,
	DropAttack = 1 << 12,
	DropAttackStart = 1 << 13,
	DropAttackLoop = 1 << 14,
	DropAttackLand = 1 << 15,
}

FightEnum.BehaviorOpType =
{
	Behavior = 1, 		  --人物行为操作
	LevelBehavior = 2,    --关卡行为操作
}

FightEnum.SkillBehaviorConfig = 
{
	SkillCdPart = "SkillCdPart", --cd组件
	SkillCostPart = "SkillCostPart", --资源消耗组件
	SkillCdChargePart = "SkillCdChargePart", --充能组件
	SkillIconPart = "SkillIconPart", --图标组件
	SkillEffectPart = "SkillEffectPart", --特效组件
	DodgeCdPart = "DodgeCdPart", --闪避CD组件
}
FightEnum.SkillLayerConfig =
{
	ShowCD = "ShowCD", --显示CD倒计时
    SkillCDMask = "SkillCDMask", -- 显示CD百分比
    PowerMask = "PowerMask", --显示充能百分比
    RoundPowerMask = "RoundPowerMask", --圆框充能百分比（暂未使用）
    Charge = "Charge", --显示充能点个数
    ReadyEffect = "ReadyEffect", --技能准备就绪特效
    IsLoop = "IsLoop", -- 技能准备就绪特效是否循环
    CastEffect = "CastEffect", --技能释放特效
	DodgeEffect = "DodgeEffect" --显示极限闪避按钮动效
}

--BehaviorFunctions.SetSkillBehaviorConfig(3, 1002010, "ReadyEffectPath", BehaviorFunctions.GetEffectPath(22059))

FightEnum.SkillBtn2Event = 
{
	["J"] = FightEnum.KeyEvent.Attack,
	["K"] = FightEnum.KeyEvent.Dodge,
	["L"] = FightEnum.KeyEvent.UltimateSkill,
	["I"] = FightEnum.KeyEvent.NormalSkill,
	["O"] = FightEnum.KeyEvent.Jump,
	["C"] = FightEnum.KeyEvent.Lock,
	["R"] = FightEnum.KeyEvent.Partner,
	["F"] = FightEnum.KeyEvent.AimMode,
	["PartnerSkill"] = FightEnum.KeyEvent.PartnerSkill,
}

FightEnum.BehaviorBtn2Events =
{
	["X"] = {FightEnum.KeyEvent.LeaveClimb},
	["JR"] = {FightEnum.KeyEvent.Jump},
	["ClimbRun"] = {FightEnum.KeyEvent.ClimbRun},
	["SW"] = {FightEnum.KeyEvent.Dodge},
}

FightEnum.KeyEvent2BehaviorBtn =
{
	[FightEnum.KeyEvent.Attack] = {"J"},
	[FightEnum.KeyEvent.Dodge] = {"K"},
	[FightEnum.KeyEvent.UltimateSkill] = {"L"},
	[FightEnum.KeyEvent.NormalSkill] = {"I"},
	[FightEnum.KeyEvent.Lock] = {"C"},
	[FightEnum.KeyEvent.Partner] = {"R"},
	[FightEnum.KeyEvent.LeaveClimb] = {"X"},
	[FightEnum.KeyEvent.Dodge] = {"K", "SW"},
	[FightEnum.KeyEvent.Jump] = {"O", "JR"},
	[FightEnum.KeyEvent.AimMode] = {"F"},
	[FightEnum.KeyEvent.ClimbRun] = {"ClimbRun"},
	[FightEnum.KeyEvent.PartnerSkill] = {"PartnerSkill"},
}

FightEnum.JumpType = 
{
	Jump = 1,
	JumpDouble = 2,
	Glide = 3,
	GlideCancel = 4,
}

FightEnum.KeyEvent2Btn = 
{
	[FightEnum.KeyEvent.Attack] = "J",
	[FightEnum.KeyEvent.Dodge] = "K",
	[FightEnum.KeyEvent.UltimateSkill] = "L",
	[FightEnum.KeyEvent.NormalSkill] = "I",
	-- [FightEnum.KeyEvent.BlueSkill] = "O",
	-- [FightEnum.KeyEvent.Change1] = "1",
	-- [FightEnum.KeyEvent.Change2] = "2",
	-- [FightEnum.KeyEvent.Change3] = "3",
	[FightEnum.KeyEvent.Lock] = "C",
	[FightEnum.KeyEvent.Partner] = "R",
	[FightEnum.KeyEvent.Jump] = "O",
	[FightEnum.KeyEvent.LeaveClimb] = "X",
	[FightEnum.KeyEvent.AimMode] = "F",
	[FightEnum.KeyEvent.ClimbRun] = "ClimbRun",
	[FightEnum.KeyEvent.PartnerSkill] = "PartnerSkill"
}

FightEnum.BehaviorUIOpType =
{
	behavior = 1,
	level = 2,
}

FightEnum.ElementType = 
{
	Phy = 1,         	-- 物理
	Gold = 2,      	 	-- 金
	Wood = 3,        	-- 木
	Water = 4,     		-- 水
	Fire = 5,       	-- 火
	Earth = 6,		 	-- 土
}

FightEnum.ElementRelationDmgType =
{
	[FightEnum.ElementType.Water] = FightEnum.ElementType.Fire,
	[FightEnum.ElementType.Fire] = FightEnum.ElementType.Gold,
	[FightEnum.ElementType.Wood] = FightEnum.ElementType.Earth,
	[FightEnum.ElementType.Earth] = FightEnum.ElementType.Water,
	[FightEnum.ElementType.Gold] = FightEnum.ElementType.Wood,
}

FightEnum.MagicType = {
	AddBuff = 1,
	DoDamage = 2,
	SetTimeScale = 3,
	CameraShake = 4,
	CreateEntity = 5,
	AddBuffState = 6,
	HideBone = 7,
	HideGroupBone = 8,
	ForceMove = 9,
	ChangeAttr = 10,
	ScreenEffect = 11,
	EnemyCommonTimeScale = 12,
	SetSceneSpeed = 13,
	AddBehavior = 14,
	Preform = 15,
	CameraTrack = 16,
	PartLogicVisible = 17,
	PartLock = 18,
	DeadTransport = 19,
	ChangeEntityState = 20,
	HideEntity = 21,
	HideLifeBar = 22,
	CameraOffset = 23,
	PauseTranslucent = 24,
	ForbiddenBoneShake = 25,
	BuffTimeOffset = 26,
	EnableAnimMove = 27,
	CameraFixed = 28,
	ConditionListener = 29,
	ChangeYAxisParam = 30,
	ChangeAttrAccumulate = 31,
	EnableAnimMoveWithAxis = 32,
	DoCure = 33,
	ChangePlayerAttr = 34,
	ElementResistance = 35,
	Revive = 36,
	RoleCommonTimeScale = 37,
	Execute = 38,
	AdditionYAxisParam = 39,
	ChangeJumpParam = 40,
	ChangeCollisionCheckTagFlags = 41,
	ChangeCollisionBeCheckTagFlags = 42,
	WindArea = 43,
	AttrTranslationPercent = 44,
	AttrTranslationFixedValue = 45,
	AddShield = 46,
	WeaponEffect = 47,						-- 临时的武器特效 不要真的用
	PassParameter = 48,
	AddShadow = 49,
	Conclude = 50,
	ConcludeElementBreak = 51,
}

FightEnum.MagicFuncName = {
	[FightEnum.MagicType.AddBuff] = "AddBuff",
	[FightEnum.MagicType.DoDamage] = "DoDamage",
	[FightEnum.MagicType.SetTimeScale] = "SetTimeScale",
	[FightEnum.MagicType.CameraShake] = "CameraShake",
	[FightEnum.MagicType.CreateEntity] = "CreateEntity",
	[FightEnum.MagicType.AddBuffState] = "AddBuffState",
	[FightEnum.MagicType.HideBone] = "HideBone",
	[FightEnum.MagicType.HideGroupBone] = "HideGroupBone",
	[FightEnum.MagicType.ForceMove] = "ForceMove",
	[FightEnum.MagicType.ChangeAttr] = "ChangeAttr",
	[FightEnum.MagicType.ScreenEffect] = "ScreenEffect",
	[FightEnum.MagicType.EnemyCommonTimeScale] = "EnemyCommonTimeScale",
	[FightEnum.MagicType.SetSceneSpeed] = "SetSceneSpeed",
	[FightEnum.MagicType.AddBehavior] = "AddBehavior",
	[FightEnum.MagicType.Preform] = "Preform",
	[FightEnum.MagicType.CameraTrack] = "CameraTrack",
	[FightEnum.MagicType.PartLogicVisible] = "PartLogicVisible",
	[FightEnum.MagicType.PartLock] = "PartLock",
	[FightEnum.MagicType.DeadTransport] = "DeadTransport",
	[FightEnum.MagicType.ChangeEntityState] = "ChangeEntityState",
	[FightEnum.MagicType.HideEntity] = "HideEntity",
	[FightEnum.MagicType.HideLifeBar] = "HideLifeBar",
	[FightEnum.MagicType.CameraOffset] = "CameraOffset",
	[FightEnum.MagicType.PauseTranslucent] = "PauseTranslucent",
	[FightEnum.MagicType.ForbiddenBoneShake] = "ForbiddenBoneShake",
	[FightEnum.MagicType.BuffTimeOffset] = "BuffTimeOffset",
	[FightEnum.MagicType.EnableAnimMove] = "EnableAnimMove",
	[FightEnum.MagicType.CameraFixed] = "CameraFixed",
	[FightEnum.MagicType.ConditionListener] = "ConditionListener",
	[FightEnum.MagicType.ChangeYAxisParam] = "ChangeYAxisParam",
	[FightEnum.MagicType.ChangeAttrAccumulate] = "ChangeAttrAccumulate",
	[FightEnum.MagicType.EnableAnimMoveWithAxis] = "EnableAnimMoveWithAxis",
	[FightEnum.MagicType.DoCure] = "DoCure",
	[FightEnum.MagicType.ChangePlayerAttr] = "ChangePlayerAttr",
	[FightEnum.MagicType.ElementResistance] = "ElementResistance",
	[FightEnum.MagicType.Revive] = "Revive",
	[FightEnum.MagicType.RoleCommonTimeScale] = "RoleCommonTimeScale",
	[FightEnum.MagicType.Execute] = "Execute",
	[FightEnum.MagicType.AdditionYAxisParam] = "AdditionYAxisParam",
	[FightEnum.MagicType.ChangeJumpParam] = "ChangeJumpParam",
	[FightEnum.MagicType.ChangeCollisionCheckTagFlags] = "ChangeCollisionCheckTagFlags",
	[FightEnum.MagicType.ChangeCollisionBeCheckTagFlags] = "ChangeCollisionBeCheckTagFlags",
	[FightEnum.MagicType.WindArea] = "WindArea",
	[FightEnum.MagicType.AttrTranslationPercent] = "AttrTranslationPercent",
	[FightEnum.MagicType.AttrTranslationFixedValue] = "AttrTranslationFixedValue",
	[FightEnum.MagicType.AddShield] = "AddShield",
	[FightEnum.MagicType.WeaponEffect] = "WeaponEffect",
	[FightEnum.MagicType.PassParameter] = "PassParameter",
	[FightEnum.MagicType.AddShadow] = "AddShadow",
	[FightEnum.MagicType.Conclude] = "Conclude",
	[FightEnum.MagicType.ConcludeElementBreak] = "ConcludeElementBreak",
}

-- 对magic的来源做分类 对应去读不同类型来源的magic（应用于关卡这种没有实体的magic施加方）
FightEnum.MagicConfigFormType = {
	Player = 1,			-- 角色
	Monster = 2,		-- 怪物
	Level = 3,			-- 关卡
	Equip = 4,			-- 装备
	Item = 5,			-- 道具
	Partner = 6,		-- 仲魔
	FightEvent = 7,		-- 战斗事件
	Roguelike = 8,      -- 肉鸽
	PartnerPerk = 9,
}

FightEnum.MagicConfigName = {
	[FightEnum.MagicConfigFormType.Player] = 1000,
	[FightEnum.MagicConfigFormType.Monster] = 9000,
	[FightEnum.MagicConfigFormType.Level] = 2000,
	[FightEnum.MagicConfigFormType.Equip] = 3000,
	[FightEnum.MagicConfigFormType.Partner] = 6000,
	[FightEnum.MagicConfigFormType.FightEvent] = 2001,
	[FightEnum.MagicConfigFormType.Roguelike] = 4000,
	[FightEnum.MagicConfigFormType.PartnerPerk] = 60000,
	[FightEnum.MagicConfigFormType.Item] = 5000,
}

FightEnum.BuffType = {
	Normal = 1,
	Accumulate = 2,
	CountDown = 3
}

FightEnum.BuffEffectType =
{
	ValueBuff = 1,
	ValueDebuff = 2,
	EffectBuff = 3,
	EffectDebuff = 4,
}

FightEnum.DamageType = 
{
	Normal = 1,			-- 普通的造成伤害，走加成计算公式 -> (基础伤害+技能固定伤害)*(1+通用伤害加成%+角色类型伤害加成%)*守方防御承伤%*守方抗性承伤%*部位承伤%*暴击
	Assassinate = 2,	-- 暗杀，专有暗杀计算公式,不计算部位易伤 -> 基础伤害/10000-暗杀抗性/10000- (max(怪物等级-角色等级-压制最小等级差,0))*等级差系数）*被暗杀者最大生命值
	Percent = 3,		-- 真实伤害，百分比
	Fixed = 4			-- 真实伤害，固定
}

FightEnum.CureType =
{
	Normal = 1,			-- 普通的治疗，走加成计算公式 -> (治疗者攻击*技能系数%+技能附加值)*(1+治疗者治疗加成%+被治疗者受治疗加成%)
	Percent = 2,		-- 生命值上限万分比
	ToPercent = 3,		-- 到生命值上限万分比
	Fixed = 4			-- 固定值
}

FightEnum.RoleDmgType =
{
	Closed = 1,			-- 近战
	Remote = 2,			-- 远程
}

FightEnum.RoleDmgTypeToAttr =
{
	[FightEnum.RoleDmgType.Closed] = Config.DataPlayerAttrsDefine.AttrsType.closedmgatkpercent[1],			-- 近战角色伤害加成
	[FightEnum.RoleDmgType.Remote] = Config.DataPlayerAttrsDefine.AttrsType.remotedmgatkpercent[1],		-- 远程角色伤害加成
}

FightEnum.PreLoadUI = {
	--RemoteDialog = "Prefabs/UI/Fight/DiaogPanel/remote_dialog_panel.prefab",	--带头像的剧情对话框UI
	--FightTalkDialog = "Prefabs/UI/Fight/DiaogPanel/talk_dialog_panel.prefab",	--纯文字的剧情对话框UI
	--GuideMask = "Prefabs/UI/Guide/UIGuideMask.prefab",				--教学引导UI
	FightTips = "Prefabs/UI/Fight/FightTips/FightTips.prefab",		--中间横幅和底部横幅
}

FightEnum.BindResType = {
	None = 0,		-- 没有绑定属性装饰
	Empty = 1,		-- 属性空了显示
	Full = 2,		-- 属性满了显示
	Normal = 3,		-- 有属性就显示
	Always = 4,		-- 一直显示
}

FightEnum.SkillGuideState = {
    Waiting = 1,
    Processing = 2,
    Failed = 3,
    Succeeded = 4
}

FightEnum.SkillGuideType = {
    Click = 1,
    Press = 2,
    CrazyPush = 3,
}

FightEnum.SkillGuideTypeDesc = {
    [FightEnum.SkillGuideType.Click] = "",
    [FightEnum.SkillGuideType.Press] = "长按",
    [FightEnum.SkillGuideType.CrazyPush] = "",
}

FightEnum.CombinationRoot = "CombinationRoot"

FightEnum.Layer =
{
	Default = 0,
	IgnoreRayCastLayer = 2,
	Water = 4,
	Terrain = 6,
	AirWall = 7,
	Wall = 8,
	Area = 9,
	EntityCollision = 15,
	Entity = 16,
	NoClimbing = 17,
	Marsh = 20,
	InRoom = 25,
}

FightEnum.LayerBit =
{
	Default = 1 << 0,
	IgnoreRayCastLayer = 1 << 2,
	Water = 1 << 4,
	Terrain = 1 << 6,
	AirWall = 1 << 7,
	Wall = 1 << 8,
	Area = 1 << 9,
	EntityCollision = 1 << 15,
	Entity = 1 << 16,
	NoClimbing = 1 << 17,
	Marsh = 1 << 20,
	InRoom = 1 << 25,
	CarBody = 1 << 29
}

FightEnum.Layer2LayerBit =
{
	[FightEnum.Layer.Default] = 1 << 0,
	[FightEnum.Layer.IgnoreRayCastLayer] = 1 << 2,
	[FightEnum.Layer.Water] = 1 << 4,
	[FightEnum.Layer.Terrain] = 1 << 6,
	[FightEnum.Layer.Wall] = 1 << 8,
	[FightEnum.Layer.Area] = 1 << 9,
	[FightEnum.Layer.EntityCollision] = 1 << 15,
	[FightEnum.Layer.Entity] = 1 << 16,
	[FightEnum.Layer.NoClimbing] = 1 << 17,
	[FightEnum.Layer.Marsh] = 1 << 20,
	[FightEnum.Layer.InRoom] = 1 << 25,
}

FightEnum.DeathReason = {
	Damage = 1,				-- 伤害
	Direct = 2,				-- 逻辑调用直接死亡(GM)
	Drowning = 3,			-- 淹死
	TerrainDeath = 4,		-- 摔死
	ExecuteDeath = 5,		-- 处决
	CatchDeath = 6,			-- 捕捉
}

FightEnum.DeathState = {
	None = 0,
	Dying = 1,				-- 正在死亡
	Death = 2,				-- 死亡
	Drowning = 3,			-- 淹死
	TerrainDeath = 4,		-- 摔死
	Revive = 5,				-- 复活
	ExecuteDeath = 6,		-- 处决
	FakeDeath = 7,			-- 假死
	CatchDeath = 8,         -- 捕捉死亡
}

FightEnum.DeathCondition = {
	Drown = 1,
	Terrain = 2,
}

FightEnum.DeathCondition2Reason = {
	[FightEnum.DeathCondition.Drown] = 3,
	[FightEnum.DeathCondition.Terrain] = 4,
}

-- 总的地图标记分类
FightEnum.MapMarkType = {
	Player = 0,
	Ecosystem = 1,
	Custom = 2,
	Task = 3,
	Event = 4,
	RoadPath = 5,
	SummonCar = 6,
	NavMeshPath = 7,
	LevelEvent = 8,
	LevelEnemy = 9,
}

FightEnum.NavDrawColor = {
	Default = Color(1.49803925,0.603921592,0,1),
	White = Color(1, 1, 1, 1),
	Yellow = Color(230/255, 255/255, 22/255, 1),
}

-- 地图标记追踪线的颜色对应的层级
FightEnum.NavDrawColor2SortingOrder = {
	[FightEnum.NavDrawColor.White] = 0,
	[FightEnum.NavDrawColor.Yellow] = 1,
}

-- 地图标记追踪对应追踪线的颜色
FightEnum.MapMarkTraceInfo = {
	[FightEnum.MapMarkType.Task] = { guideType = 4, color = FightEnum.NavDrawColor.Yellow },
}

FightEnum.MapMarkCustomType = {
	-- 后续自定义标签都写这里
	None = 1,
}

FightEnum.Direction = {
	None = 0,
	Forward = 1,
	Back = 2,
	Left = 3,
	Right = 4,
}

FightEnum.WalkDirAnim = {
	[FightEnum.Direction.None] = "AimIdle",
	[FightEnum.Direction.Forward] = "AimWalk",
	[FightEnum.Direction.Back] = "AimWalkBack",
	[FightEnum.Direction.Left] = "AimWalkLeft",
	[FightEnum.Direction.Right] = "AimWalkRight",
}

FightEnum.BuildWalkDirAnim = {
	[FightEnum.Direction.None] = "Building_thigh",
	[FightEnum.Direction.Forward] = "BuildWalk",
	[FightEnum.Direction.Back] = "BuildWalkBack",
	[FightEnum.Direction.Left] = "BuildWalkLeft",
	[FightEnum.Direction.Right] = "BuildWalkRight",
}

FightEnum.EntityLookAtType = {
	Entity = 2,
	EntityOwner = 3,
}

FightEnum.CameraTriggerLayer = FightEnum.LayerBit.Area|FightEnum.LayerBit.Default

FightEnum.AimImageType = 
{
	None = 1,
	Part = 2,
	PartWeak = 3,
}

FightEnum.PartType =
{
	None = 0,
	Weak = 1,
}

FightEnum.PartWeakType =
{
	Head = 1,
}

FightEnum.AimAnimatorLayer = {
	Default = 0,
	Aim = 1,
	AimWalk = 2,
}

FightEnum.GuideType = {
	FightTarget = 1,
	TreasureBox = 2,
	Transport = 3,
	Task = 4,
	Rogue_Police = 5,--城市威胁
	Rogue_Challenge = 6,--能力挑战
	Rogue_Riddle = 7,--探索解密
	SummonCar = 8,
	Collect = 9,--拾取
	OpenDoor = 10,--开门
	Check = 11,	--查看
	Map_Badguy = 12,--npc骇入
	Map_Jiujishou = 13,--究极手
	Map_Robbery = 14,--室内解密战斗
	Map_Attacking = 15,--随机事件
	Map_ChallengePaoku = 16,--跑酷挑战
	Map_ChallengeFight = 17,--战斗挑战
	Map_wuding = 18,--屋顶解密战斗
	Map_yueMaster = 19,--月灵大师
	Map_strongholdYue = 20, --月灵据点
	Custom = 21, --自定义
}

FightEnum.TaskGuideType = {
	Position = 1,
	Entity = 2,
	EcoEntity = 3,
	Area = 4,
}

FightEnum.PointerShowType = {
	Hide = 1,
	Show = 2,
	ShowAndHideArrow = 3,
}

FightEnum.DodgeInvalidType = {
	None = 0,
	Forever = 1,
	Duration = 2,
}

FightEnum.ReboundTag =
{
    Mark = 1,
    Attack = 2,
}

FightEnum.DeadLayer = 
{
	[FightEnum.Layer.Marsh] = true,
}

FightEnum.StateIgonreMoveCheck =
{
	[FightEnum.EntityState.Climb] = true,
	[FightEnum.EntityState.Idle] = true,
	[FightEnum.EntityState.FightIdle] = true,
	[FightEnum.EntityState.Swim] = true,
	[FightEnum.EntityState.Perform] = true,
}

FightEnum.LimitConditions = {
	CheckLevel = 10101, --玩家等级是否达标
	CheckRole = 11101, --查询玩家是否拥有指定角色
	CheckSkillLevelByHeroNum = 11201, -- 查询是否有X个英雄将技能提升至Y级
	CheckItemNum = 15101, --查询当前背包中指定道具数量是否达标
	CheckTask = 17101, --查询玩家是否完成某个任务
	CheckWorldLevel = 10102, --判断世界等级是否达到
	CheckAllTalentLevel = 10103, --判断角色天赋达到xx级
	CheckRoleLevel = 11104, --指定id角色达到X级
	CheckRoleCountByLevel = 11102, --任意N个角色达到X级
	CheckRoleCountByStage = 11103, --任意N个角色达到突破X阶
	CheckWeaponLevel = 12101, --指定id武器达到X级
	CheckWeaponCountByLevel = 12102, --任意N个武器达到X级
	CheckWeaponCountByStage = 12103, --任意N个武器达到突破X阶
	CheckPartnerLevel = 13101, --指定id月灵达到X级
	CheckPartnerCountByLevel = 13102, -- 任意N个月灵达到X级
	CheckPartner = 13301,
	CheckPartnerPassiveSkillCount = 13304, -- 任意X只月灵拥有Y个打书被动
	CheckTransport = 16101, --查询玩家是否激活指定传送点
	CheckTransportByCount = 16102, --已激活传送点数量达到X个
	CheckPerfectAssassinate = 13201,--使用X次完美刺杀
	CheckUsePartnerSkill = 13202,--使用X次月灵技能
	CheckUseItem = 15203,--使用物品
	CheckHistroyUseItem = 15205,-- 历史使用物品
	CheckGetItem = 15301,--获取物品
	CheckRoleUpgrade = 11105, --任意角色合计升级X次
	CheckWeaponUpgrade = 12104, --任意武器合计强化X次
	CheckKillEnemy = 19101, --击杀X个敌人
	CheckDodge = 19102, --完成X次闪避或跳反
	CheckElementReadyState = 19103, --击破X次弱点槽
	CheckMercenaryTask = 17102, --完成N次嗜脉猎手任务
	CheckPlayerIdentity = 10105,  --玩家道途身份是否达标
	CheckPlayerNowIdentity = 10106,  --玩家当前佩戴道途身份是否达标
	CheckNightMareLevelPoint = 22101, -- 梦魇关卡达成指定积分
	CheckNightMareLayerPoint = 22102, -- 梦魇层级达成指定积分
	CheckNightMareFinishSystemDup = 23101, -- 完成system_duplicate指定id的关卡

	CheckAssetLevel = 24101, -- XX资产达到XX等级
	CheckHaveDecorationCount = 24102, -- 拥有X个X资产物件
	CheckAssetDecorationCount = 24103, -- 在id为xx的资产中布置id为xx的资产物件
	CheckAssetPartnerCount = 24104, -- 在id为xx的资产中布置xx个员工
	CheckDecorationWorkAmount = 24105, -- 使用id为xx的资产物件完成xx个功能产物
	CheckAssetAddFood = 24106, -- 在id为xx的资产中的任意饭桌添加X个任意食物
	UnLockPartnerSkill = 24107, -- 通过月灵中心解锁X个技能

	CheckRogueLikeEventNum = 25101, -- 检查历史完成肉鸽事件
	CheckPurchasePartnerBook = 26101, -- 检查历史累计购买配从书
	CheckDailyActivation = 27101, -- 检查每日活跃度
	CheckSignInDays = 27201, -- 检查历史登录天数
	CheckVITTotalCost = 27301, -- 检查历史累计消耗体力
	CheckFeedMailingTime = 28101, -- 检查历史累计脉灵投喂次数
	CheckTrafficTotalDistance = 28102,  -- 检查历史总驾驶距离
	CheckSinceFinishLevelEvent = 29101, -- 随机事件完成时间
	CheckSystemTaskFinish = 30101,       -- 系统任务完成或者待领取奖励


}

FightEnum.AnimEventType = {
	LeftWeaponVisible = 1,
	RightWeaponVisible = 2,
	PlaySound = 3,
	PlayTerrainSound = 4,
	JumpDodge = 5,
	EnableIkShake = 6,
	AimShoot = 7,
	IKAnimateDirection = 8,
	EnableIkLook = 9,
	FlyHeight = 10,
}

-- 声音触发事件类型，在声音组件中配置这些事件发生时实体需要播放的音效
FightEnum.SoundEventType = {
	Born = 1,
	Destroy = 2,
	Hit = 3,
	HitBlow = 4,
	BreakBlow = 5,
	Looting = 6,
	Stand1 = 7,	-- 这个代码中没发现触发点，但是有语音资源，先占个位
	LowHp = 8
}

FightEnum.CameraOffsetType = {
	PositionX = 1,
	PositionY = 2,
	PositionZ = 3,
	RotationX = 4,
	RotationY = 5,
	RotationZ = 6,
}

FightEnum.CameraOffsetReferType ={
	Camera = 0,
	Target = 1,
}

FightEnum.CameraFixedType = {
	PositionX = 1,
	PositionY = 2,
	PositionZ = 3,
	RotationX = 4,
	RotationY = 5,
	RotationZ = 6,
}

FightEnum.CameraFixedReferType ={
	Camera = 0,
	Target = 1,
}

FightEnum.AttackShakeDir = {
	Left = 1,
	Right = 2,
	LeftFront = 3,
	LeftBack = 4,
	RightFront = 5,
	RightBack = 6,
}

FightEnum.AnimationLayer = 
{
	BaseLayer = "Base Layer",
	PerformLayer = "Perform Layer",
	FaceLayer = "Face Layer",
	LipLayer = "Lip Layer",
	AdvanceLayer = "Advance Layer",
}

FightEnum.AnimationLayerIndexToName =
{
	"BaseLayer",
	"PerformLayer",
	"FaceLayer",
	"LipLayer",
	"AdvanceLayer",
}

FightEnum.FightTipsType =
{
	Center = 1,		-- 中间黑色横幅
	Bottom = 2,		-- 弃用
	GuideTips = 3,	-- 主界面侧边栏追踪
	CurtainTips = 4,	-- 黑幕+文字提示
}

FightEnum.PostProcessType =
{
	ColorStyle = 0,
	RGBSplit = 1,
	RadialBlur = 2,
	BlurMask = 4,
	
	FullScreen = -1,
}

FightEnum.DebuffQTEType = 
{
	Freeze = 5001,	--冻结
	Stun = 5002,	--眩晕
	Charm = 5003,	--魅惑
}

FightEnum.NewQTEType =
{
	Click = 1,
	Resist = 2,
	Section = 3,
	Hold = 4,
	Scratch = 5,
	Switch = 6,
	Debuff = 7,
	Assassin = 8,
}

FightEnum.QTEAnchorType =
{
	LeftTop = 1,
	LeftBottom = 2,
	RightTop = 3,
	RightBottom = 4,
	Center = 5,
}

FightEnum.AreaType =
{
	Block = 0,
	Small = 1,
	Mid = 2,
	Big = 3,
	Mercenary = 4,
	Bgm = 5,
	Level = 6,
}

FightEnum.BlockType = {
	WhiteHole = 1,	-- 白洞 只出不进
	BlockHole = 2,	-- 黑洞 只进不出
}

FightEnum.EAttackType =
{
	General = 1,--常规
	Special = 2,--特殊
	Low = 3,--下段
	Grasp = 4,--抓取
	Aim = 5,--瞄准
	Air = 6,--空反
	Rebound = 7,--弹反
	Other = 8,--其他
	Gain = 9,--增益
}

FightEnum.AttackTarget = {
	Enemy = 1,
	Ally = 2,
	Player = 3,
	All = 4,
}

FightEnum.AttackRepeatType =
{
	Normal = 1,			-- 普通 根据子弹生成的时间来计算间隔
	Hit = 2,			-- 命中 根据子弹命中第一个实体的时间计算间隔
	SingleHit = 3,		-- 子弹对不同实体的命中时间计算间隔
}

FightEnum.GuidingType =
{
	NotStart = 1,
	Guiding = 2,
	WaitForCallback = 3,
	WaitForUIOpen = 4,
}

FightEnum.KeyInputStatus =
{
	Up = 0,
	Down = 1,
}

FightEnum.HitEffectBornType =
{
	Bone = 1,
	HitPos = 2,
	HitOffset = 3,
}

FightEnum.PartTag =
{
	Single = 1,
	Plural = 2
}

FightEnum.RoleSkillPoint =
{
	Ex = EntityAttrsConfig.AttrType.ExSkillPoint,
	Normal = EntityAttrsConfig.AttrType.NormalSkillPoint
}

FightEnum.SkillPointSource = 
{
	None = 0,
	NormalAttack = EntityAttrsConfig.AttrType.NormalAttackSPPercent
}

FightEnum.ColliderFollow =
{
	BothFollow = 1,
	PositionOnly = 2,
}

FightEnum.CollisionCheckType =
{
	Normal = 1,
	TerrainOnly = 2,
	GenerateOnly = 3,
}

FightEnum.WorldSceneId = 10020001 

FightEnum.GlideState = {
	None = 0,
	GlideStart = 1,
	GlideLoop = 2,
	GlideLand = 3,
	GlideLandRoll = 4,
}

FightEnum.FightConditionType = 
{
	LifeInRange = 1,
	HitCount = 2,
	HasBuff = 3,
}

FightEnum.MeetFightConditionEventType = 
{
	CustomCallback = 1,
	SuperArmor = 2,
}

FightEnum.GlideLoopState = {
	None = 0,
	Left = 1,
	Right = 2,
	Front = 3,
}

FightEnum.ElementState = {
	Accumulation = 1,
	Ready = 1 << 1,
	Cooling = 1 << 2,
}

FightEnum.SkillMoveDone = {
	StopMove = 1,
	BreakSkill = 2,
	PauseAnimationMove = 3,
	CheckRadiusMove = 4,
	None = 5,
}

FightEnum.NavPathDrawType = {
	Static = 1,
	Self2Static = 2,
	self2Entity = 3
}

FightEnum.NavMeshDrawType = {
	Role2Road = 1,
	Road2Target = 2,
}

FightEnum.MapAreaBoundsColor = {
	[1] = Color(255/255, 96/255, 59/255, 1),
	[2] = Color(250/255, 224/255, 78/255, 1),
	[3] = Color(63/255, 226/255, 255/255, 1),
	[4] = Color(92/255, 255/255, 153/255, 1),
}


FightEnum.AiCarConditionType = {
	CheckObstacle = "CheckObstacle", -- 结果bool -- 参数1/检测距离 number 
	CheckPassableSpace = "CheckPassableSpace", -- 结果bool -- 参数1/可否逆行 bool  参数2 float插缝检测宽度
	GetPlayerDistance = "GetPlayerDistance" -- 结果number
}


FightEnum.AiCarActionType = {
	maxSpeedDefinite = 1,
	maxSpeedAddtive = 2,
	maxSpeedMultiplier = 3,
	accelerationDefinite = 4,
	accelerationAddtive = 5,
	accelerationMultiplier = 6,
	changeLanes = 7,
	unStopable = 8
}
FightEnum.WorkPlaceSize = {
	
	WorkPlace_S = 1,
	WorkPlace_M = 2,
	WorkPlace_L = 3,
}
--月灵演出时间列举
FightEnum.PartnerDisplayType = {
	
	interact = 99,
	takeUp = 98,
	idle = 0,
	attack = 1,
	operate = 2,
	cast = 3,
	sleep = 4,
	feed = 5,
}


--佩丛状态列举
FightEnum.PartnerStatusEnum = {
    None = 0, --无
    Hunger = 1, --饥饿
    Sad = 2, --抑郁
    HungerAndSad = 3, --抑郁+饥饿
	Interact = 4, --交互
	TakeUp = 5 -- 举起
}

FightEnum.DisplayFinishType = {
	FadeIn = 1,
	FadeOut = 2,
}

FightEnum.DisplayAnimType = {
	FadeIn = 1,
	Loop = 2,
	FadeOut = 3,
}


FightEnum.PTMOffsetType = {
	TargetRelation = 1,
	MoveDirection = 2,	
}
-- #非常重要,与实体属性使用一致的id,如果是只有玩家才有的属性，则不要再实体属性类型枚举中定义
FightEnum.PlayerAttr = {
 	--固定值属性
    MaxLife = 1, --基础生命
    ExtraMaxLife = 101, --额外生命
    Attack = 2, --基础攻击
    ExtraAttack = 102, --额外攻击
    Defense = 3, --防御
    ExtraDefense = 103, --额外防御
    ElementAtk = 4, --元素精通(状态强度)
    ExtraElementAtk = 104, --额外状态强度
    MaxEnergy = 5, --能量
    LifeBar = 6, --生命条数
    MaxArmor = 7, --霸体值
    RunSpeed = 8, --跑速度
    WalkSpeed = 9, --前走速度
    WalkBackSpeed = 10, --后走速度
    WalkLeftSpeed = 11, --左走速度
    WalkRightSpeed = 12, --右走速度
    RotationSpeed = 13, --角速度
    Gravity = 14, --落地加速度
    Energy_ex = 15, --骇入值
    MaxLife2 = 16,
    MaxLife3 = 17,
    SprintSpeed = 18, --疾跑速度

    --万分比属性
    MaxLifePercent = 21, --生命加成
    AttackPercent = 22, --攻击加成
    DefensePercent = 23, --防御加成
    ElementPercent = 24, --元素精通加成(状态强度)
    CritPercent = 25, --暴击率
    CritDefPercent = 26, --暴击抗性
    CritAtkPercent = 27, --暴击伤害
    CritDecPercent = 28, --暴伤减免
    DmgAtkPercent = 29, --伤害加成
    DmgDefercent = 30, --伤害减免
    ArmorDefPercent = 31, --霸体伤害减免
    PartAtkPercent = 32, --部位伤害加成
    PartDefPercent = 33, --部位伤害减免
    CureAtkPercent = 34, --治疗加成
    CureDefPercent = 35, --受治疗加成
    AssassinateDef = 36, --暗杀抗性

    ShieldPercent = 19,  --护盾加成
    SkillPercent = 20, --技能倍率加成
    SkillPointFront = 37,--前台日向回复
    SkillPointBack = 38,--后台日向回复
    ExSkillPointPercent = 39, --月相回复加成
    IgnoreDefPercent = 40, --忽视防御百分比
    WeaknessPercent = 41, --脆弱
    VulPercent = 42, --易伤
    SuppressPercent = 43,--压制
    ElementBreakPercent = 44, --五行击破加成
    NormalAttackSPPercent = 45, --普攻日相恢复加成

    --元素属性
    AtkPercentEl1 = 51, --物理伤害加成
    DefPercentEl1 = 52, --物理抗性
    ThroughPercentEl1 = 53, --物理穿透
    AtkPercentEl2 = 54, --金属性伤害加成
    DefPercentEl2 = 55, --金属性抗性
    ThroughPercentEl2 = 56, --金属性穿透
    AtkPercentEl3 = 57, --木属性伤害加成
    DefPercentEl3 = 58, --木属性抗性
    ThroughPercentEl3 = 59, --木属性穿透
    AtkPercentEl4 = 60, --水属性伤害加成
    DefPercentEl4 = 61, --水属性抗性
    ThroughPercentEl4 = 62, --水属性穿透
    AtkPercentEl5 = 63, --火属性伤害加成
    DefPercentEl5 = 64, --火属性抗性
    ThroughPercentEl5 = 65, --火属性穿透
    AtkPercentEl6 = 66, --暗属性伤害加成
    DefPercentEl6 = 67, --暗属性抗性
    ThroughPercentEl6 = 68, --暗属性穿透

    PartDefPercentEl1 = 80, --部位物理抗性
    PartDefPercentEl2 = 81, --部位金属性抗性
    PartDefPercentEl3 = 82, --部位木属性抗性
    PartDefPercentEl4 = 83, --部位水属性抗性
    PartDefPercentEl5 = 84, --部位火属性抗性 
    PartDefPercentEl6 = 85, --部位暗属性抗性   


	MaxNormalSkillPoint = 201,  --红色消耗技能点
	MaxExSkillPoint = 202, --蓝色消耗技能点
	MaxSkillPoint = 203,  --技能点上限
	MaxCoreRes = 204,     --核心资源上限
	EnergyCost = 205,     --大招消耗能量
	MaxDodge = 206,       --最大闪避值

	MaxDefineRes1 = 211,
	MaxDefineRes2 = 212,
	MaxDefineRes3 = 213,
	MaxDefineRes4 = 214,
	MaxDefineRes5 = 215,
	MaxDefineRes6 = 216,
	MaxDefineRes7 = 217,
	MaxDefineRes8 = 218,
	MaxDefineRes9 = 219,
	MaxDefineRes10 = 220,

	MaxCommonAttr1 = 301,  -- 所有角色通用属性

	FallDamageReductionPercent = 601,    --坠落伤害降低
	VerticalClimbSpeed = 602,    --纵向攀爬速度
	HorizontalClimbSpeed = 603,    --横向攀爬速度
	ClimbJumpHeight = 604,    --攀爬跳跃高度
	ClimbRunSpeed = 605,    --跑墙速度
	GlideSpeed = 606,    --滑翔水平速度
	SwimSpeed = 607,    --游泳速度
	FastSwimSpeed = 608,    --速泳速度
	WalkSpeedPercent = 609,    --移动速度加成
	RunSpeedPercent = 610,    --跑步速度加成
	SprintSpeedPercent = 611,    --疾跑速度加成
	ClimbSpeedPercent = 612,    --攀爬速度加成
	HorizontalClimbSpeedPercent = 613,    --横向攀爬速度加成,弃用
	ClimbJumpHeightPercent = 614,    --攀爬跳跃高度加成
	ClimbRunSpeedPercent = 615,    --跑墙速度加成
	GlideSpeedPercent = 616,    --滑翔水平速度加成
	SwimSpeedPercent = 617,    --游泳速度加成
	FastSwimSpeedPercent = 618,    --速泳速度加成
	DodgeCost = 619,    --闪避消耗的体力值
	WalkCost = 620,    --走路消耗体力值
	RunCost = 621,    --跑步消耗体力值
	SprintCost = 622,    --疾跑消耗体力值
	ClimbCost = 623,    --攀爬消耗体力值
	ClimbJumpCost = 624,    --攀爬跳跃消耗体力值
	ClimbRunCost = 625,    --跑墙消耗体力值
	GlideCost = 626,    --滑翔消耗体力值
	SwimCost = 627,    --游泳消耗体力值
	FastSwimCost = 628,    --速泳消耗体力值
	DodgeCostPercent = 629,    --闪避消耗的体力值加成
	WalkCostPercent = 630,    --走路消耗体力值加成
	RunCostPercent = 631,    --跑步消耗体力值加成
	SprintCostPercent = 632,    --疾跑消耗体力值加成
	ClimbCostPercent = 633,    --攀爬消耗体力值加成
	ClimbJumpCostPercent = 634,    --攀爬跳跃消耗体力值加成
	ClimbRunCostPercent = 635,    --跑墙消耗体力值加成
	GlideCostPercent = 636,    --滑翔消耗体力值加成
	SwimCostPercent = 637,    --游泳消耗体力值加成
	FastSwimCostPercent = 638,    --速泳消耗体力值加成
	HackingDistance = 639,    --骇入和建造距离
	HackingBuildCount = 640,    --建造物数量上限

	MaxStamina = 642,    --体力值上限
	StaminaRecoveryRate = 643,    --体力恢复速度
	MaxStaminaPercent = 644,    --体力值上限加成
	ItemDurationPercent = 645,    --消耗品持续时间加成
	TeamAttackPercent = 646,    --全队攻击力加成

	MaxElectricity = 650,    		--电量值上限
	ElectricityRecoveryRate = 651,    --电量恢复速度
	MaxElectricityPercent = 652,    --电量值上限加成
	Maxqteres = 653, --临时QTE资源上限
	StaminaRecoverPercent = 654, --体力恢复加成
	DebuffDurationPercent = 655,    -- 减益效果持续时间加成
	ElectricityCostPercent = 656, --电量值消耗加成
	ExtraBuildEnergy = 657, --额外建造上限
    BuffDurationPercent = 658,  -- 增益BUFF持续时间加成
	BuildItemCostSubPercent = 659,  -- 建造材料消耗减免
	JumpCost = 660, --跳跃体力消耗
	InputSpeedPerent = 664,	--摇杆速度加成

	-- 当前值，当前值ID比配置最大值ID 大1000
	CurStaminaValue = 1642,  --当前体力值
	CurElectricityValue = 1650,  --当前电量值
	Curqteres = 1653, --临时当前QTE资源

	MaxRam = 661,
	RamResponseTimeUnit = 662,
	RamResponseUnit = 663,
	CurRamValue = 1661,
}

FightEnum.PlayerAttrToMaxType = {
	[FightEnum.PlayerAttr.CurStaminaValue] = FightEnum.PlayerAttr.MaxStamina,
	[FightEnum.PlayerAttr.CurElectricityValue] = FightEnum.PlayerAttr.MaxElectricity,
	[FightEnum.PlayerAttr.Curqteres] = FightEnum.PlayerAttr.Maxqteres,
	[FightEnum.PlayerAttr.CurRamValue] = FightEnum.PlayerAttr.MaxRam,
}

FightEnum.PlayerAttrToAttrPercent = {
	[FightEnum.PlayerAttr.MaxStamina] = FightEnum.PlayerAttr.MaxStaminaPercent,
	[FightEnum.PlayerAttr.MaxElectricity] = FightEnum.PlayerAttr.MaxElectricityPercent,
}

FightEnum.PlayerAttrPercentToAttr = {
	[FightEnum.PlayerAttr.MaxStaminaPercent] = FightEnum.PlayerAttr.MaxStamina,
	[FightEnum.PlayerAttr.MaxElectricityPercent] = FightEnum.PlayerAttr.MaxElectricity,
}

FightEnum.PlayerAttrPropertyValue = {
	[FightEnum.PlayerAttr.MaxStamina] = FightEnum.PlayerAttr.MaxStamina,
	[FightEnum.PlayerAttr.MaxElectricity] = FightEnum.PlayerAttr.MaxElectricity,
	[FightEnum.PlayerAttr.MaxRam] = FightEnum.PlayerAttr.MaxRam,
	[FightEnum.PlayerAttr.Curqteres] = FightEnum.PlayerAttr.Curqteres,
	[FightEnum.PlayerAttr.CurStaminaValue] = FightEnum.PlayerAttr.CurStaminaValue,
}

FightEnum.PlayerSyncAttr = 
{
	[FightEnum.PlayerAttr.Curqteres] = FightEnum.PlayerAttr.Curqteres,
	[FightEnum.PlayerAttr.CurStaminaValue] = FightEnum.PlayerAttr.CurStaminaValue,
}

FightEnum.PlayerAttrAllowLessThanZero = {
	[FightEnum.PlayerAttr.StaminaRecoveryRate] = FightEnum.PlayerAttr.StaminaRecoveryRate,
	[FightEnum.PlayerAttr.ElectricityCostPercent] = FightEnum.PlayerAttr.ElectricityCostPercent,
}

FightEnum.MailingState = 
{
	Active = 1,
	Finished = 2,
	NotActive = 3,
}

FightEnum.TriggerType = 
{
	Fight = 1 << 0,
	Collision = 1 << 1,
	Terrain = 1 << 2,
	InteractIn = 1 << 3,
	InteractOut = 1 << 4,
	MovePlatformIn = 1 << 5,
	MovePlatformOut = 1 << 6,
}

FightEnum.CommonBehaviorParamMap =
{
	["CommonPartnerBehavior"] = {
		"进场时间",
		"退场时间",
		"退场动作开始帧数",
		"退场结束时间",
		"进场magicId"
	},
	["CommonSetFollowMoveBehavior"] = {
	},
	["CommonControlDroneBehavior"] = {
		"最大离地高度",
		"最远操控距离",
		"每帧消耗电量",
		"可操控帧数",
		"水平最大速度",
		"水平加速度",
		"垂直最大速度",
		"垂直加速度",
		"转弯速度",
		"自动下落速度",
	},
	["CommonControlCarBehavior"] = {
		"最远操控距离",
		"每帧消耗电量",
		"可操控帧数",
	},
	["CommonAtomizePointBehavior"] = {
		"环境类型",
		"穿梭方向",
		"水平视野转动范围",
		"垂直视野转动范围",
		"移动帧数",
		"室外穿梭帧数",
		"室内穿梭帧数",
		"室外穿梭相机切换开始帧数",
		"镜头移动速度",
		"室外结束后光球移动速度",
		"室内结束光球移动速度",
	},
	["CommonAnimBehavior"] = {
	},
	["CommonFanBehavior"] = {
		"推力",
		"吹风最大推力",
		"吹风衰减距离",
	},
	["CommonBuildConsoleBehavior"] = {
		"(空中)X轴最大倾斜角度",
		"(空中)X轴每帧旋转角度",
		"(空中)Y轴每帧旋转角度",
		"(空中)Z轴最大倾斜角度",
		"(空中)Z轴每帧旋转角度",
		"(水中)Y轴每帧旋转角度",
	},
	["CommonTireBehavior"] = {
		"目标旋转角速度",
		"旋转施加的力",
		"转向时最大偏转角度",
		"偏转力",
		"最大偏转角度所需距离",
		"差速转弯角速度修正",
		"差速转弯力矩修正",
	},
	["CommonFlatCarBehavior"] = {
		"目标旋转角速度",
		"旋转施加的力",
		"转向时最大偏转角度",
	},
	["CommonPartnerWorkBehavior"] = {
	},
	["CommonDisplayInteractBehavior"] = {
	},
}

FightEnum.PartnerHenshinState = {
	None = 0,		-- 后台
	Show = 1,		-- 变身中
	Henshin = 2,	-- 变身
	Out = 3,		-- 在退场
}

FightEnum.ChangeRoleCheckState = {
	FightEnum.EntityState.Move,
	FightEnum.EntityState.Glide,
	FightEnum.EntityState.Jump,
	FightEnum.EntityState.Swim,
	FightEnum.EntityState.Climb,
}

FightEnum.InheritMoveState = {
	[FightEnum.EntityState.Move] = {
		[FightEnum.EntityMoveSubState.Run] = FightEnum.EntityMoveSubState.Run,
		[FightEnum.EntityMoveSubState.RunStart] = FightEnum.EntityMoveSubState.Run,
		[FightEnum.EntityMoveSubState.Sprint] = FightEnum.EntityMoveSubState.Sprint,
	},
	[FightEnum.EntityState.Swim] = {
		[FightEnum.EntitySwimState.Idle] = FightEnum.EntitySwimState.Swimming,
		[FightEnum.EntitySwimState.Swimming] = FightEnum.EntitySwimState.Swimming,
		[FightEnum.EntitySwimState.FastSwimming] = FightEnum.EntitySwimState.FastSwimming,
	},
	[FightEnum.EntityState.Climb] = {
		[FightEnum.EntityClimbState.Climbing] = FightEnum.EntityClimbState.Climbing,
		[FightEnum.EntityClimbState.ClimbingRun] = FightEnum.EntityClimbState.ClimbingRun,
		[FightEnum.EntityClimbState.ClimbingRunStart] = FightEnum.EntityClimbState.ClimbingRun,
	},
	[FightEnum.EntityState.Glide] = {
		[FightEnum.GlideState.GlideLoop] = FightEnum.GlideState.GlideLoop,
	},
	[FightEnum.EntityState.Jump] = {
		[FightEnum.EntityJumpState.JumpDown] = FightEnum.EntityJumpState.JumpDown,
	},
}

FightEnum.InheritState = {
	["Normal"] = {
		[FightEnum.EntityState.Move] = FightEnum.EntityMoveSubState.RunStartEnd,
		[FightEnum.EntityState.Swim] = FightEnum.EntitySwimState.Idle,
		[FightEnum.EntityState.Climb] = FightEnum.EntityClimbState.Idle,
		[FightEnum.EntityState.Jump] = FightEnum.EntityJumpState.JumpDown,
		[FightEnum.EntityState.Glide] = FightEnum.GlideState.GlideLoop,
	},
	["Speical"] = {
		[FightEnum.EntityState.Move] = {
			[FightEnum.EntityMoveSubState.Sprint] = FightEnum.EntityMoveSubState.SprintEnd,
		},
		[FightEnum.EntityState.Climb] = {
			[FightEnum.EntityClimbState.ClimbingRun] = FightEnum.EntityClimbState.ClimbingRunEnd,
		},
	}
}

FightEnum.BuildPreviewType = {
	adheringSurface = 1, --依附在地形表面
	avoidCollisions = 2, --避免碰撞，垂直创建
	LiftAndRotation = 3, --托举旋转,类塞尔达
}

FightEnum.HackingType = {
	Drone = 1, --无人机
	Camera = 2, --摄像头
	Npc = 3,
	Box = 4, --机匣
	Other = 5, --其他(纯策划逻辑的)
}

FightEnum.HackingEffectType = {
	None = 0,
	OtherTarget = 1 << 1, --其他骇入
	CanHackingTarget = 1 << 2, --可骇入物
	EnmityTarget = 1 << 3, --敌对目标
	TaskTarget = 1 << 4, --任务目标
}

FightEnum.HackingButtonType = 
{
	Click = 0,
	Active = 1,
}

FightEnum.HackMode = {
	Hack = 10000,
	Build = 20000,
}

FightEnum.HackOperateState = {
	Forbidden = 1,
	Normal = 2,
	Continue = 3,	
}

FightEnum.NpcHackType = {
	Mail = 1,
	PhoneCall = 2,
}

FightEnum.NpcHackState = {
	Start = 1,
	Finish = 2,
	UnFinish = 3,
}

FightEnum.CommonFSMType = {
	State = 1,
	SubFSM = 2,
}

FightEnum.TrafficLightType = {
	Red = 1,
	Yellow = 2,
	Green = 3
}

FightEnum.TrafficMode = {
	
	Normal = 1,
	Safe = 2
}

FightEnum.TrafficCameraMode = {
	
	Along = 0,
	FreeDom = 1
}

FightEnum.SearchOnlyWeight = 10000

FightEnum.AtomizePointLocationType = {
	InDoor = 1,
	OutDoor = 2,
}

FightEnum.AtomizePointInteractType = {
	In = 1,
	Out = 2,
	Both = 3,
}

FightEnum.SoundSignType =
{
	Normal = 1,
	Language =2,
}
FightEnum.BlowPhysicType =
{
	Collider = 1, --unity计算碰撞，性能消耗大
	Simple =2,	--简单运动，性能消耗小
}


FightEnum.DuplicateType = {
	Def = 0,
	Res = 1,
	Dup = 2, --默认的副本
	CitySimulation = 3
}

FightEnum.SystemDuplicateType = {
	Res = 1, --资源副本
	Task = 2, --任务副本
	NightMare = 3, --梦魇副本
	NoSystem = 4,  --非系统副本
	CitySimulation = 5 --委托副本
}

FightEnum.DuplicateTimerType = {
	-- 累加
	Acc = 1,
	-- 倒计时
	CountDown = 2,
	-- 有UI的倒计时，枚举名就是UI名字
	FightTargetUI = 3,
	-- 有UI的累加，枚举名就是UI名字 + Acc
	FightTargetUIAcc = 4,
}

FightEnum.UseAttrType = {
	Self = 1,
	Creator = 2,
	CreatorRoot = 3,
}

FightEnum.Formation = {
	All = -1,
	First = 1,
	Second = 2,
	Third = 3,
}

FightEnum.SystemDuplicateReviveType = {
	ReviveBtn = 1, --失败界面包含退出和重置按钮
	Exit = 2, --只能退出副本
	Die = 3, --不能用复活药，成员死亡直接失败
	LiveByPoint = 4,--复活点复活
	LiveByUnlimited = 5, --无限复活（特殊玩法）
}

FightEnum.DamageParam = 
{
	--1、带#号备注的不能获取，带*号备注的不能修改
	--2、需要攻击力、防御力，请使用“修改实体属性”方法
	--3、"公式参数获取后"才会有有效的值
	--基础伤害区

	SkillBase = "SkillBase", --技能基础倍率
	SkillPercent = "SkillPercent", --技能倍率加成
	Extra = "Extra",--额外附加伤害

	--增伤区
	DmgDefercent = "DmgDefercent", --伤害减免、属性伤害减免
	DmgAtkPercent = "DmgAtkPercent", --伤害加成、属性伤害加成

	--双爆区
	UnableCrit = "UnableCrit", --必定不暴击
	IsCrit = "IsCrit", --是否暴击
	TempCrit = "TempCrit", --临时暴击率
	TempCritDef = "TempCritDef", --临时暴击抵抗
	CritDmgPercent = "CritDmgPercent", --暴击伤害加成
	CritDmgDef = "CritDmgDef", --暴击伤害减免

	--防御区
	IgnoreDef = "IgnoreDef",         --#无视防御乘区
	IsWeaknees = "IsWeaknees", --是否有脆弱效果
	Weakness = "Weakness",--受击方脆弱
	DefLev = "DefLev", --防御方等级

	--状态振幅区
	IsVulnerability = "IsVulnerability", --是否有易伤效果
	Vulnerability = "Vulnerability", --易伤和

	--状态强度区
	ElementAtk = "ElementAtk", --攻击方强度(元素精通,放大易伤和脆弱效果)

	--抗性区
	ThroughPercentE = "ThroughPercentE", --穿透
	DefPercentE = "DefPercentE", --抵抗

	--部位承伤区
	IsHitPart = "IsHitPart", --是否名字部位
	PartDefPercent = "PartDefPercent", --部位伤害减免
	PartAtkPercent = "PartAtkPercent", --部位伤害加成

	--霸体减伤区
	IsArmor = "IsArmor", --是否存在霸体
	ArmorDefPercent = "ArmorDefPercent", --霸体伤害减免

	--元素克制区
	IsElementRelation = "IsElementRelation", --是否克制
	BeElementRelation = "BeElementRelation", --是否被克制
	ElementRelationValue = "ElementRelationValue", --元素克制加成

	--五行击破效果值
	ElementBreakValue = "ElementBreakValue", -- 五行击破基础值
	ElementBreakPercent = "ElementBreakPercent", --五行击破加成
}

FightEnum.DamageInfo = 
{
	AtkCamp = "atkCamp", --*攻击者阵营
	PartType = "partType", --*攻击部位类型
	DmgElement = "dmgElement", --伤害元素类型
	SkillType = "skillType" --*技能类型
}

FightEnum.CureParam = 
{
	SkillBase = "SkillBase", --技能倍率
	SkillPercent = "SkillPercent", --技能倍率加成
	Extra = "Extra", --额外治疗量

	CurePercent = "CurePercent",--治疗加成和
}

--万分比参数
FightEnum.PercentParam = 
{
	[FightEnum.DamageParam.SkillBase] = true,
	[FightEnum.DamageParam.SkillPercent] = true,
	[FightEnum.DamageParam.DmgDefercent] = true,
	[FightEnum.DamageParam.DmgAtkPercent] = true,
	[FightEnum.DamageParam.TempCrit] = true,
	[FightEnum.DamageParam.TempCritDef] = true,
	[FightEnum.DamageParam.CritDmgPercent] = true,
	[FightEnum.DamageParam.CritDmgDef] = true,
	[FightEnum.DamageParam.Vulnerability] = true,
	[FightEnum.DamageParam.Weakness] = true,
	[FightEnum.DamageParam.PartDefPercent] = true,
	[FightEnum.DamageParam.PartAtkPercent] = true,
	[FightEnum.DamageParam.ArmorDefPercent] = true,
	[FightEnum.DamageParam.ElementBreakPercent] = true,
	[FightEnum.DamageParam.IgnoreDef] = true,
	[FightEnum.CureParam.SkillBase] = true,
	[FightEnum.CureParam.SkillPercent] = true,
	[FightEnum.CureParam.CurePercent] = true,
}

FightEnum.CustomBehaviorParamType =
{
	Number = 1,
	String = 2,
	Bool = 3,
}

FightEnum.ComparisonOperation = 
{
	GreaterThan = 1,
	LessThan = 2,
}

FightEnum.EntityLODLevel = {
	Zero = 0,
	One = 1,
	Two = 2,
	Three = 3,
}

FightEnum.LevelType = {
	TaskType = 1,
	RogueType = 2,
	EntityType = 3,
	DupType = 4,
}

FightEnum.BluePrintType = {
	PreFab = 1,
	Custom = 2,
}
FightEnum.BuildType = {
	Single = 1,       --单体
	Combination = 2,    --组合
}

FightEnum.NPCPatrolType = {
	OneWay = 0,		--单向
	Return = 1,		--往返
	Close = 2,		--闭合
}

FightEnum.MonsterAttackType = {
	Close = 1,			-- 近战
	LongRange = 2,		-- 远程
}

FightEnum.MonsterTypeId = {
	Monster = 1, --小怪
	Elite = 2, --精英
	Boss = 3, --boss
}

FightEnum.BuildDisConnectType = {
	Player = 1, --玩家主动断开
	Angle = 2,  --角度过大断开
}

FightEnum.BuildConnectPointType = {
	PrefabPoint = "1", --预设点
	NearestPoint = "2", --最近点
}