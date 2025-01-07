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
	Move = 1, --移动
	Attack = 2, --攻击
	Dodge = 3, --闪避
	UltimateSkill = 4, --
	NormalSkill = 5, --普通技能
	BlueSkill = 6, --
	Interaction = 7, --交互
	Partner = 8, --佩从
	Change1 = 9, --换人
	Change2 = 10, --换人
	Lock = 11,    --锁定
	ScreenPress = 12, --屏幕按下
	ScreenMove = 13,  --屏幕移动

	Common1 = 14, --通用Key
	Common2 = 15, --通用Key
	Common3 = 16, --通用Key
	Common4 = 17, --通用Key
	Common5 = 18, --通用Key
	Common6 = 19, --通用Key
	Common7 = 20, --通用Key
	Common8 = 21, --通用Key
	AttackJ = 22, -- 特殊的连点攻击J

	GuideClick = 23,
	GuideTimeout = 24,
	Jump = 25,	--跳跃
	Change3 = 26,	-- 换人
	LeaveClimb = 27, -- 离开攀爬
	Aim = 28, --瞄准
	Run = 29,
	MoveMode = 30,
	CommonQTE = 31,
	Map = 32,
	Back = 33, -- 返回
	System = 34,
	Team = 35,
	Character = 36,
	Backpack = 37,
	Mission = 38,
	Tutorial = 39,
	AimMode = 40,
	AutoPlay = 41, -- 自动播放
	Skip = 42, -- 跳过剧情
	Next = 43, -- 下一段对话
	History = 44, -- 回顾剧情
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
}

FightEnum.ActionToKeyEvent =
{
	ScreenMove = FightEnum.KeyEvent.ScreenMove,
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
	FightIdle = 4,--废弃中
	Move = 5,
	Pathfinding = 6,--寻路
	Skill = 7,
	Hit = 8,
	Fall = 9,--高处往低处掉
	Immobilize = 10,--定身
	Perform = 11,--演出
	Die = 12,
	Death = 13,
	Stun = 14,--晕眩
	Jump = 15,
	Slide = 16,
	StrideOver = 17,
	Climb = 18,
	Aim = 19,
	Swim = 20,
	CloseMenu = 21,--关闭菜单
	Revive = 22,
	Glide = 23,
	Hack = 24,
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
	Transport = 1,
	Gear = 2,
	Monster = 3,
	Collect = 4
}

FightEnum.CreateEntityType = {
	Normal = 0,
	Ecosystem = 1,
	Npc = 2,
	Drop = 3,
	Mercenary = 4,
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
	IgnoreCommonEnemyTimeScale = 17, --忽略通用怪物时间缩放
	ForbiddenImmuneHit = 18, --禁用免疫受击
	ImmuneBreakLieDown = 19, --免疫中断倒地
	ImmuneWorldCollision = 20, --不产生世界碰撞
	ImmuneDownDmg = 21, -- 免疫落地伤害,
	StickWithTerrain = 22, -- 随地形倾斜
	ImmuneStun = 23, -- 免疫眩晕
}

FightEnum.MoveType =
{
	AnimatorMoveData = 1, --使用动画移动数据
	Linera = 2, --直线运动
	Bind = 3,--绑定目标
	Track = 4, -- 追踪
	Curve = 5, -- 变速曲线
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
	HackEnd = 5,
}

FightEnum.CollisionType =
{
	Sphere = 1,
	Cube = 2,
	Cylinder = 3,
	Circle = 4,
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
	Camp = 9,
	Collision = 10,
	Dodge = 11,
	HandleMoveInput = 12,
	Hit = 13,
	Sync = 14,
	TimeoutDeath = 15,
	Tag = 16,
	Effect = 17,
	Pasv = 18,
	Trigger = 19,
	SkillSet = 20,
	CreateEntity = 21,
	Combination = 22,
	Ik = 23,
	Aim = 24,
	ReboundAttack = 25,
	ElementState = 26,
	Camera = 27,
	Sound = 28,
	FindPath = 29,
	Condition = 30,
	CommonBehavior = 31,
	Tp = 32,
	HackingInputHandle = 33,
	CustomFSM = 34,
	Lenght = 35,

	Move = 1000,
	Time = 1001,
	Behavior = 1002,
	Buff = 1003,
	FollowHalo = 1004,
	Climb = 1005,
	LifeBar = 1006,
	Swim = 1007,
	Death = 1008,
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
	[ComponentType.Camp] = "Camp",
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
	[ComponentType.Aim] = "Aim",
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
}

FightEnum.CameraState = 
{
	Operating = 1,--操作
	WeakLocking = 2,--弱锁
	ForceLocking = 3,--强锁定
	Aiming = 4, -- 瞄准
	UI = 5, -- UI
	Dialog = 6, --npc对话
	OpenDoor = 7, -- 开门
	NpcShop = 8, -- npc商店
	Mailing = 9,
	CatchPartner = 10, -- 佩从捕捉
	Drone = 11, -- 无人机
	Level = 12, -- 关卡相机 是关卡动态创建的实体赋值
	Hacking = 13, -- 骇入相机
	Monitor = 14, -- 监视器相机（骇入相机之后的视角）
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
	Base = 1,
	Additvie = 2,
}

FightEnum.AttrValueType =
{
	Base = 1,
	Percent = 2,
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

FightEnum.SkillSpecialType =
{
	NormalAtk = 1,		-- 普攻
	NormalSkill = 10,		-- 红色技能
	BlueSkill = 20,		-- 蓝色技能
	Dodge = 30,			-- 闪避
	CorePositive = 40,	-- 核心被动
	CounterAtk = 50,	-- 闪避反击
	QTE = 60,			-- QTE
	FinalSkill = 70,	-- 大招
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
	-- ["O"] = FightEnum.KeyEvent.BlueSkill,
	["O"] = FightEnum.KeyEvent.Jump,
	["C"] = FightEnum.KeyEvent.Lock,
	["R"] = FightEnum.KeyEvent.Partner,
	["F"] = FightEnum.KeyEvent.AimMode,
}

FightEnum.BehaviorBtn2Events =
{
	["X"] = {FightEnum.KeyEvent.LeaveClimb},
	["JR"] = {FightEnum.KeyEvent.Jump},
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
	[FightEnum.KeyEvent.Aim] = {"F"},
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
	[FightEnum.KeyEvent.Aim] = "F",
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
	[FightEnum.ElementType.Fire] = FightEnum.ElementType.Wood,
	[FightEnum.ElementType.Wood] = FightEnum.ElementType.Earth,
	[FightEnum.ElementType.Earth] = FightEnum.ElementType.Gold,
	[FightEnum.ElementType.Gold] = FightEnum.ElementType.Water,
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
}

-- 对magic的来源做分类 对应去读不同类型来源的magic（应用于关卡这种没有实体的magic施加方）
FightEnum.MagicConfigFormType = {
	Player = 1,			-- 角色
	Monster = 2,		-- 怪物
	Level = 3,			-- 关卡
	Equip = 4,			-- 装备
	-- Item = 5,			-- 道具
	Partner = 6,		-- 仲魔
}

FightEnum.MagicConfigName = {
	[FightEnum.MagicConfigFormType.Player] = 1000,
	[FightEnum.MagicConfigFormType.Monster] = 9000,
	[FightEnum.MagicConfigFormType.Level] = 2000,
	[FightEnum.MagicConfigFormType.Equip] = 3000,
	[FightEnum.MagicConfigFormType.Partner] = 6000,
}

FightEnum.BuffType = {
	Normal = 1,
	Accumulate = 2,
	CountDown = 3
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
	Defalut = 0,
	IgonreRayCastLayer = 2,
	Water = 4,
	Terrain = 6,
	Wall = 8,
	Area = 9,
	EntityCollision = 15,
	Entity = 16,
	Marsh = 20,
	Lava = 21,
	Driftsand = 22,
	InRoom = 25,
}

FightEnum.LayerBit =
{
	Defalut = 1 << 0,
	IgonreRayCastLayer = 1 << 2,
	Water = 1 << 4,
	Terrain = 1 << 6,
	Wall = 1 << 8,
	Area = 1 << 9,
	EntityCollision = 1 << 15,
	Entity = 1 << 16,
	Marsh = 1 << 20,
	Lava = 1 << 21,
	Driftsand = 1 << 22,
	InRoom = 1 << 25,
}

FightEnum.Layer2LayerBit =
{
	[FightEnum.Layer.Defalut] = 1 << 0,
	[FightEnum.Layer.IgonreRayCastLayer] = 1 << 2,
	[FightEnum.Layer.Water] = 1 << 4,
	[FightEnum.Layer.Terrain] = 1 << 6,
	[FightEnum.Layer.Wall] = 1 << 8,
	[FightEnum.Layer.Area] = 1 << 9,
	[FightEnum.Layer.EntityCollision] = 1 << 15,
	[FightEnum.Layer.Entity] = 1 << 16,
	[FightEnum.Layer.Marsh] = 1 << 20,
	[FightEnum.Layer.Lava] = 1 << 21,
	[FightEnum.Layer.Driftsand] = 1 << 22,
	[FightEnum.Layer.InRoom] = 1 << 25,
}

FightEnum.DeathReason = {
	Damage = 1,
	Direct = 2,
	Drowning = 3,
	TerrainDeath = 4,
}

FightEnum.DeathState = {
	None = 0,
	Dying = 1,
	Death = 2,
	Drowning = 3,
	TerrainDeath = 4,
	Revive = 5,
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

FightEnum.EntityLookAtType = {
	Entity = 2,
	EntityOwner = 3,
}

FightEnum.CameraTriggerLayer = FightEnum.LayerBit.Area|FightEnum.LayerBit.Defalut

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
	Defalut = 0,
	Aim = 1,
	AimWalk = 2,
}

FightEnum.GuideType = {
	FightTarget = 1,
	TreasureBox = 2,
	Transport = 3,
	Task = 4,
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
	[FightEnum.Layer.Lava] = true,
	[FightEnum.Layer.Driftsand] = true,
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
	CheckPartnerLevel = 13101, --指定id佩从达到X级
	CheckPartnerCountByLevel = 13102, -- 任意N个佩从达到X级
	CheckTransport = 16101, --查询玩家是否激活指定传送点
	CheckTransportByCount = 16102, --已激活传送点数量达到X个
	CheckPerfectAssassinate = 13201,--使用X次完美刺杀
	CheckUsePartnerSkill = 13202,--使用X次佩从技能
	CheckUseItem = 15203,--使用物品
	CheckGetItem = 15301,--获取物品
	CheckRoleUpgrade = 11105, --任意角色合计升级X次
	CheckWeaponUpgrade = 12104, --任意武器合计强化X次
	CheckKillEnemy = 19101, --击杀X个敌人
	CheckDodge = 19102, --完成X次闪避或跳反
	CheckElementReadyState = 19103, --击破X次弱点槽
	CheckMercenaryTask = 17102, --完成N次嗜脉猎手任务
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
}


FightEnum.SoundEventType = {
	Born = 1,
	Destroy = 2,
	Hit = 3,
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
}

FightEnum.FightTipsType =
{
	Center = 1,		-- 中间黑色横幅
	Bottom = 2,		-- 弃用
	GuideTips = 3,	-- 主界面侧边栏追踪
}

FightEnum.PostProcessType =
{
	ColorStyle = 0,
	RGBSplit = 1,
	RadialBlur = 2,
	BlurMask = 4,
	
	FullScreen = -1,
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
	Ex = 1202,
	Normal = 1201
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


FightEnum.PTMOffsetType = {
	TargetRelation = 1,
	MoveDirection = 2,	
}

FightEnum.PlayerAttr = {
	MaxLife = 1,    	--生命
	Attack = 2,    		--攻击
	Defense = 3,     	--防御
	ElementAtk = 4,     --元素精通
	MaxEnergy = 5,     	--能量
	LifeBar = 6,   		--生命条数
	MaxArmor = 7,     	--霸体值
	RunSpeed = 8,     	--跑速度
	WalkSpeed = 9,     	--前走速度
	WalkBackSpeed = 10,--后走速度
	WalkLeftSpeed = 11, --左走速度
	WalkRightSpeed = 12, --右走速度
	RotationSpeed = 13,  --角速度
	Gravity = 14,		 --落地加速度
	Energy_ex = 15,      --骇入值
	MaxLife2 = 16,
	MaxLife3 = 17,
	SprintSpeed = 18,	--疾跑速度

	--万分比属性
	MaxLifePercent = 21,  --生命加成
	AttackPercent = 22,   --攻击加成
	DefensePercent = 23,  --防御加成
	ElementPercent = 24,  --元素精通加成
	CritPercent = 25,     --暴击率
	CritDefPercent = 26,  --暴击抗性
	CritAtkPercent = 27,  --暴击伤害
	CritDecPercent = 28,  --暴伤减免
	DmgAtkPercent = 29,   --伤害加成
	DmgDefercent = 30,    --伤害减免
	ArmorDefPercent = 31, --霸体伤害减免
	PartAtkPercent = 32,  --部位伤害加成
	PartDefPercent = 33,  --部位伤害减免
	CureAtkPercent = 34,  --治疗加成
	CureDefPercent = 35,  --受治疗加成
	AssassinateDef = 36,	--暗杀抗性


	--元素属性
	AtkPercentEl1 = 51,     --物理伤害加成
	DefPercentEl1 = 52,     --物理抗性
	ThroughPercentEl1 = 53, --物理穿透
	AtkPercentEl2 = 54,     --金属性伤害加成
	DefPercentEl2 = 55,     --金属性抗性
	ThroughPercentEl2 = 56, --金属性穿透
	AtkPercentEl3 = 57,     --木属性伤害加成
	DefPercentEl3 = 58,     --木属性抗性
	ThroughPercentEl3 = 59, --木属性穿透
	AtkPercentEl4 = 60,     --水属性伤害加成
	DefPercentEl4 = 61,     --水属性抗性
	ThroughPercentEl4 = 62, --水属性穿透
	AtkPercentEl5 = 63,     --火属性伤害加成
	DefPercentEl5 = 64,     --火属性抗性
	ThroughPercentEl5 = 65, --火属性穿透
	AtkPercentEl6 = 66,     --暗属性伤害加成
	DefPercentEl6 = 67,     --暗属性抗性
	ThroughPercentEl6 = 68, --暗属性穿透


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
	VerticalClimbSpeedPercent = 612,    --纵向攀爬速度加成
	HorizontalClimbSpeedPercent = 613,    --横向攀爬速度加成
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

	-- 当前值，当前值ID比配置最大值ID 大1000
	CurStaminaValue = 1642,  --当前体力值
}

FightEnum.PlayerAttrToMaxType = {
	[FightEnum.PlayerAttr.CurStaminaValue] = FightEnum.PlayerAttr.MaxStamina,
}

FightEnum.PlayerAttrToAttrPercent = {
	[FightEnum.PlayerAttr.MaxStamina] = FightEnum.PlayerAttr.MaxStaminaPercent,
}

FightEnum.PlayerAttrPercentToAttr = {
	[FightEnum.PlayerAttr.MaxStaminaPercent] = FightEnum.PlayerAttr.MaxStamina,
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
}

Fight.CommonBehaviorParamMap =
{
	["CommonPartnerBehavior"] = {
		"进场时间",
		"退场时间",
		"退场动作开始帧数",
		"退场结束时间"
	},
	["CommonSetFollowMoveBehavior"] = {
	},
	["CommonSetFollowRotationBehavior"] = {
	},
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
}

FightEnum.HackingType = {
	Drone = 1, --无人机
	Camera = 2, --摄像头
	Npc = 3,
	Box = 4, --机匣
}

FightEnum.CommonFSMType = {
	State = 1,
	SubFSM = 2,
}