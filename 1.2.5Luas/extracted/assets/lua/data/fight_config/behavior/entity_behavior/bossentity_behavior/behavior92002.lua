Behavior92002 = BaseClass("Behavior92002",EntityBehaviorBase)
--资源预加载
function Behavior92002.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function Behavior92002.GetMagics()
	local generates = {900000001,900000035,900000008,900000009,900000010,900000007,1001990}
	return generates
end
local BF=BehaviorFunctions

function Behavior92002:Init()
	self.me = self.instanceId--记录自身
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	
	--点位信息记录
	self.myBornPos = nil
	self.myPos = nil
	self.centerPos = nil

	--出生参数
	self.haveBornSkill = false           --是否有出生技能
	self.haveSpecialBornLogic = false    --出生技能是否有特殊逻辑
	self.bornSkillId = nil	           --出生技能id
	self.initialDazeTime = 1		       --出生发呆时间

	--游荡参数
	self.shortRange = 12                 --游荡近距离边界值
	self.longRange = 15                  --游荡远距离边界值
	self.maxRange = 40                   --游荡超远距离边界值
	self.minRange = 12                   --极限近身距离，追杀模式最小追踪距离

	--距离范围枚举
	self.BattleRangeEnum = {        
		Default = 0,
		Short = 1,
		Mid = 2,
		Long = 3,
		Far = 4
	}
	
	--移动类型枚举
	self.subMoveTypeEnum = {
		Run = 1,
		Walk = 2,
		WalkBack = 3,
		WalkLeft = 4,
		WalkRight = 5,	
		Idle = 6,
	}
	
	--方向枚举
	self.dirEnum = 
	{
		Any = 1,
		FullFront = 2,
		FullBack = 3,
		FullLeft = 4,
		FullRight = 5,
		Front = 6,
		Back = 7,
		Left = 8,
		Right = 9,
		FrontLeft = 10,
		FrontRight = 11,
		BackLeft = 12,
		BackRight = 13,
	}
	
	--方向角度判断
	self.directionList =
	{
	--全向
		[self.dirEnum.Any] = { minAngel = 0 , maxAngel = 360},
	--四向位置
		--全前方
		[self.dirEnum.FullFront] = {minAngel = 270 , maxAngel = 90},
		--全后方
		[self.dirEnum.FullBack] = {minAngel = 90 , maxAngel = 270},
		--全左方
		[self.dirEnum.FullLeft] = {minAngel = 180 , maxAngel = 0},
		--全右方
		[self.dirEnum.FullRight] = {minAngel = 0 , maxAngel = 180},
	--八向精准位置
		--前方
		[self.dirEnum.Front] = {minAngel = 337.5 , maxAngel = 22.5},
		--后方
		[self.dirEnum.Back] = { minAngel = 157.5 , maxAngel = 202.5},
		--左侧
		[self.dirEnum.Left] = { minAngel = 247.5 , maxAngel = 292.5},
		--右侧
		[self.dirEnum.Right] = {minAngel = 67.5 , maxAngel = 112.5},
		--左前
		[self.dirEnum.FrontLeft] = { minAngel = 292.5 , maxAngel = 337.5},		
		--左后
		[self.dirEnum.BackLeft] = { minAngel = 202.5 , maxAngel = 247.5},
		--右前
		[self.dirEnum.FrontRight] = {minAngel = 22.5 , maxAngel = 67.5 },
		--右后
		[self.dirEnum.BackRight] = { minAngel = 112.5 , maxAngel = 157.5},
	}
	
	--方向转向动作
	self.rotateList =
	{
		--右转45度动作
		{id = 92002002 ,
			dir = self.dirEnum.FrontRight,
			durationFrame = 35
		},
		--左转45度动作
		{id = 92002003 ,
			dir = self.dirEnum.FrontLeft,
			durationFrame = 35
		},
		--右转90度动作
		{id = 92002004 ,
			dir = self.dirEnum.Right,
			durationFrame = 35
		},
		--左转90度动作
		{id = 92002005 ,
			dir = self.dirEnum.Left,
			durationFrame = 35
		},
		--右转135度动作
		{id = 92002006 ,
			dir = self.dirEnum.BackRight,
			durationFrame = 35
		},
		--左转135度动作
		{id = 92002007 ,
			dir = self.dirEnum.BackLeft,
			durationFrame = 35
		},
		--倒转180度动作
		{id = 92002008 ,
			dir = self.dirEnum.Back,
			durationFrame = 52
		},
	}
	
	--技能列表(id,默认释放距离,最小释放距离，角度,cd秒数,技能动作持续帧数，计时用帧数,优先级,是否自动释放,难度系数)
	self.skillList =
	{
		--嘶吼落雷
		{id = 92002001 ,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 40,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Any,	 --允许的释放方向
			cd = 90,
			frame = 600,			 --初始CD长度
			durationFrame = 150,     --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = false,           --是否自动释放
			phase = 1		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--吸氣強化
		{id = 92002009 , 
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 100,       --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Any,	 --允许的释放方向
			cd = 60,
			frame = 1200,			 --初始CD长度
			durationFrame = 150,     --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = false,          --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--中距离前方撕咬
		{id = 92002032 ,
			checkType = "square",	 --技能检查方式（圆、方）
			wide = 6,				 --检查方块宽度度
			hight = 4,				 --检查方块高度
			angle = 0,				 --实体对应角度（仅用于方块检查）
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Front,
			--dir = self.dirEnum.FullFront,
			cd = 20,
			frame = 0,
			durationFrame = 103,     --技能持续帧数
			priority = 30,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},

		--近战前方2连拍击
		{id = 92002033 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			isJueji = false,
			--dir = self.dirEnum.Front,
			dir = self.dirEnum.FullFront,
			cd = 20,
			frame = 0,
			durationFrame = 120,     --技能持续帧数
			priority = 20,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--近距离喷火
		{id = 92002034 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 4,        --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			isJueji = false,
			--dir = self.dirEnum.Front,
			dir = self.dirEnum.FullFront,
			cd = 30,
			frame = 0,
			durationFrame = 95,      --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 2,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--左转横扫45
		{id = 92002038 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.FrontLeft,
			cd = 10,
			frame = 0,
			durationFrame = 85,      --技能持续帧数
			priority = 100,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--右转横扫45
		{id = 92002039 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.FrontRight,
			cd = 10,
			frame = 0,
			durationFrame = 85,      --技能持续帧数
			priority = 100,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},

		--起飞转身喷火
		{id = 92002040 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.FullBack,
			cd = 40,
			frame = 0,
			durationFrame = 170,     --技能持续帧数
			priority = 20,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的）
		},		
		
		--甩尾攻击
		{id = 92002041 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Any,
			cd = 30,
			frame = 0,
			durationFrame = 185,     --技能持续帧数
			priority = 40,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},

		----拍地板二连
		--{id = 92002042 ,
			--minDistance = 11,         --技能释放最小距离（有等号）
			--maxDistance = 23,        --技能释放最大距离（无等号）
			--isJueji = false,
			--dir = self.dirEnum.FullFront,
			--cd = 20,
			--frame = 0,
			--durationFrame = 138,     --技能持续帧数
			--priority = 20,            --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		--},
		
		--左转横扫90
		{id = 92002043 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Left,
			cd = 10,
			frame = 0,
			durationFrame = 80,     --技能持续帧数
			priority = 100,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},

		--右转横扫90
		{id = 92002044 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Right,--角度修正面向
			cd = 10,
			frame = 0,
			durationFrame = 80,      --技能持续帧数
			priority = 100,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--转身翅膀戳地
		{id = 92002045 ,
			checkType = "square",	 --技能检查方式（圆、方）
			wide = 8,				 --检查方块宽度度
			hight = 4,				 --检查方块高度
			angle = 180,				 --实体对应角度（仅用于方块检查）
			minDistance = 11,         --技能释放最小距离（有等号）
			maxDistance = 25,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Back, --角度修正面向
			cd = 30,
			frame = 0,
			durationFrame = 80,     --技能持续帧数
			priority = 50,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 2,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--绝技：拍地板二连
		{id = 92002046 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 18,        --技能释放最大距离（无等号）
			isJueji = true,
			dir = self.dirEnum.Front,
			cd = 50,
			frame = 0,
			durationFrame = 138,     --技能持续帧数
			priority = 40,            --优先级，数值越大优先级越高
			isAuto = false,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--中距离突进撕咬
		{id = 92002051 ,
			checkType = "square",	 --技能检查方式（圆、方）
			wide = 6,				 --检查方块宽度度
			hight = 4,				 --检查方块高度
			angle = 0,				 --实体对应角度（仅用于方块检查）
			minDistance = 8,         --技能释放最小距离（有等号）
			maxDistance = 16,        --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Front,
			cd = 10,
			frame = 0,
			durationFrame = 200,     --技能持续帧数
			priority = 15,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		----起飞俯冲突袭下砸
		--{id = 92002053 ,
			--minDistance = 40,         --技能释放最小距离（有等号）
			--maxDistance = 50,         --技能释放最大距离（无等号）
			--dir = self.dirEnum.Front,
			--cd = 90,
			--frame = 600,
			--durationFrame = 200,     --技能持续帧数
			--priority = 20,            --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--phase = 1		 	 	 --技能使用阶段，数字大则包含小的
		--},
		
		--铁山靠：左
		{id = 92002054 ,
			checkType = "square",	 --技能检查方式（圆、方）
			wide = 10,				 --检查方块宽度度
			hight = 6,				 --检查方块高度
			angle = 270,			 --实体对应角度（仅用于方块检查）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 23,         --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.FullLeft,
			cd = 30,
			frame = 0,
			durationFrame = 130,     --技能持续帧数
			priority = 50,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--铁山靠：右
		{id = 92002055 ,
			checkType = "square",	 --技能检查方式（圆、方）
			wide = 10,				 --检查方块宽度度
			hight = 6,				 --检查方块高度
			angle = 90,				 --实体对应角度（仅用于方块检查）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 23,         --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.FullRight,
			cd = 30,
			frame = 0,
			durationFrame = 130,     --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--远距离喷火
		{id = 92002071 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 10,         --技能释放最小距离（有等号）
			maxDistance = 40,         --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.FullFront,
			cd = 40,
			frame = 300,
			durationFrame = 200,     --技能持续帧数
			priority = 30,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--贝露贝特射箭
		{id = 92002072 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 15,         --技能释放最小距离（有等号）
			maxDistance = 60,         --技能释放最大距离（无等号）
			isJueji = true,
			dir = self.dirEnum.FullFront,
			cd = 35,
			frame = 0,
			durationFrame = 135,     --技能持续帧数
			priority = 60,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		--悬空落陨石
		{id = 92002091 ,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 30,         --技能释放最大距离（无等号）
			isJueji = false,
			dir = self.dirEnum.Any,
			cd = 900,
			frame = 0,
			durationFrame = 537,     --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = false,           --是否自动释放
			phase = 2		 	 	 --技能使用阶段，数字大则包含小的
		},
		
		----可爱星星飞天撞
		--{id = 92002093 ,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 999,        --技能释放最大距离（无等号）
			--isJueji = false,
			--dir = self.dirEnum.Any,
			--cd = 90,
			--frame = 900,
			--durationFrame = 653,     --技能持续帧数
			--priority = 50,           --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--phase = 1		 	 	 --技能使用阶段，数字大则包含小的
		--},
		
		--绝技：滑翔撞击
		{id = 92002098 ,
		checkType = "circle",	 --技能检查方式（圆、方）
		minDistance = 25,         --技能释放最小距离（有等号）
		maxDistance = 100,        --技能释放最大距离（无等号）
		isJueji = true,
		dir = self.dirEnum.FullFront,
		cd = 20,
		frame = 300,
		durationFrame = 304,     --技能持续帧数
		priority = 50,           --优先级，数值越大优先级越高
		isAuto = false,           --是否自动释放
		phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
		},
	}
	
	self.born = false
	
	self.time = 0	
	
	--转向相关参数
	self.rotateTime = 0
	self.rotateCdFrame = 30
	self.rotateState = false
	
	--跳跃面向相关参数
	self.jumpOutTime = 450
	self.jumpOutCdFrame = 450
	
	--释放技能相关参数
	self.battleRange = self.BattleRangeEnum.Default
	self.skillTime = 150
	self.randomSkilCdFrame = {90,150}
	self.nextSkill = nil
	self.nextSkillSign = false
	self.initialSkill = false
	
	--绝技相关参数
	self.juejiSkillTime = 600
	self.juejiSkillCDFrame = 600
	self.juejiDistanceFix = false
	
	--伤害组落雷参数
	self.thunderVal1 = 
	{	
		--目标
		target = self.battleTarget,
		--数量
		num  = 3,
		--释放间隔
		interval = {18,25},
		--释放范围
		rangeDistance = {0,15},
		--角度
		angle = {0,360},
		--最小距离间隔
		disBetweenThunder = 7
	}
	
	--氛围组落雷参数
	self.thunderVal2 =
	{
		--目标
		target = self.me,
		--数量
		num  = 9,
		--释放间隔
		interval = {8,10},
		--释放范围
		rangeDistance = {30,40},
		--角度
		angle = {0,360},
		--最小距离间隔
		disBetweenThunder = 10
	}
	
	--伤害组陨石参数
	self.meteroVal1 =
	{
		--目标
		target = self.battleTarget,
		--数量
		num  = 8,
		--释放间隔
		interval = {40,50},
		--释放范围
		rangeDistance = {0,5},
		--角度
		angle = {0,360},
		--最小距离间隔
		disBetweenThunder = 0
	}
	
	--氛围组陨石参数
	self.meteroVal2 =
	{
		--目标
		target = self.me,
		--数量
		num  = 12,
		--释放间隔
		interval = {30,45},
		--释放范围
		rangeDistance = {20,40},
		--角度
		angle = {0,360},
		--最小距离间隔
		disBetweenThunder = 10
	}
	
	--可爱星星飞天撞参数
	self.flyAngle = 70
	self.flyDistance = 600
	self.flySpeed = 5 -- m/s
	
	--记录移动开始时间和移动状态
	self.moving = 0
	self.moveTime = 0
	self.closeTime = 0
	self.subMoveType = 0
	
	--用于记录一些特殊状态
	self.dragonBreath = false
	self.powerUp = false
	self.powerUpLimitTime = 0
	self.powerUpDuration = 60
	self.powerUpCD = 120
	self.powerUpFrame = 0
	self.poweUpSkill = false
	self.phase = 1
	
	--部位血量记录
	self.totalHealth = nil
	self.partProtect = false	--眩晕后的部位保护开关
	self.partProtectFrame = 600 --眩晕后的部位保护时长
	
	self.stopBehavior = false
	
	self.shakeRatio = 0
	
	--部位锁定信息
	self.lockPartInfo = 
	{
		[1] = {partName = "Body" , lockState = true},
		[2] = {partName = "Head" , lockState = false},
		[3] = {partName = "Tail" , lockState = false},
	}
	
	--多点锁定挂点信息
	self.lockGroupInfo =
	{
		[1] = 
		{
			groupName = "TargetGroup1",
			targetInfo =
			{
				[1] = {index = 1 , bindName = "LockCaseHead" , isOpen = true ,weight = 0.8 , dis = nil , weightMutiply = 1.5},
				[2] = {index = 2 , bindName = "LockCaseBody" , isOpen = true ,weight = 0.2 , dis = nil , weightMutiply = nil },
				[3] = {index = 3 , bindName = "LockCaseCore" , isOpen = false ,weight = 0.2 , dis = nil , weightMutiply = 10},
			}
		},
	}
end

function Behavior92002:LateInit()
	self.myBornPos = BehaviorFunctions.GetPositionP(self.me)
end

function Behavior92002:Update()
	
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	self.myPos = BehaviorFunctions.GetPositionP(self.me)--记录当前点位
	self.centerPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,3.0,0)--记录当前中心点位
	--self.battleTargetDistance2 = math.abs(BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget))
	self.battleTargetDistance = math.abs(BehaviorFunctions.GetTransformDistance(self.battleTarget,"Root",self.me,"Center"))
	self.time = BehaviorFunctions.GetEntityFrame(self.me)
	
	if self.bornPosEntity == nil then
		self.bornPosEntity = BehaviorFunctions.CreateEntity(2001,nil,self.myBornPos.x,self.myBornPos.y,self.myBornPos.z)
	end
	
	--获取锁定挂点距离
	self:GetTargetGroupDistance(self.lockGroupInfo)
	
	--根据锁定挂点距离设置锁定点权重
	self:SetTargetGroupWeight(self.lockGroupInfo)
	
	--创建初始buff
	if self.initBuff ~= true then
		self.totalHealth = BehaviorFunctions.GetEntityAttrVal(self.me,1001)
		BehaviorFunctions.AddFightTarget(self.me,self.battleTarget)--添加索敌
		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,9200201,true)--修改强锁参数
		BehaviorFunctions.DoMagic(self.me,self.me,1001995) --左眼效果
		BehaviorFunctions.DoMagic(self.me,self.me,1001996) --右眼效果
		BehaviorFunctions.DoMagic(self.me,self.me,1001997) --胸口效果
		BehaviorFunctions.DoMagic(self.me,self.me,900000001)--免疫受击效果
		BehaviorFunctions.DoMagic(self.me,self.me,900000035)--免疫强制位移效果
		self.skillList = self:InitSkillList(self.skillList)
		self.initBuff = true
	end	
	
	--接收外部传来的参数
	if BehaviorFunctions.GetEntityValue(self.me,"Stop") == true then
		self.stopBehavior = true
	elseif BehaviorFunctions.GetEntityValue(self.me,"Stop") == false then
		self.stopBehavior = false
	end

	--停止行为树处理
	if self.stopBehavior == true then
		return
	end

	--处理技能期间的帧转向	
	if BehaviorFunctions.CanCtrl(self.me) == false then
		BehaviorFunctions.CancelLookAt(self.me)
	end	
	
	--镜头强锁效果
	if BehaviorFunctions.HasEntitySign(self.me,92002006) then
		if BehaviorFunctions.HasEntitySign(1,10000007) then
			BehaviorFunctions.RemoveEntitySign(1,10000007)--移除强锁标签
		end
	else
		if not BehaviorFunctions.HasEntitySign(1,10000007) then
			BehaviorFunctions.AddEntitySign(1,10000007,-1,false)--添加强锁标签
		end
	end
	
	--镜头强锁切换部位效果
	if not BehaviorFunctions.HasEntitySign(self.me,10000024) then
		BehaviorFunctions.AddEntitySign(self.me,10000024,-1,false)--添加强锁切换效果
	end
	
	--多部位怪物搜索相关标记：10000022
	if not BehaviorFunctions.HasEntitySign(self.me,10000022) then
		BehaviorFunctions.AddEntitySign(self.me,10000022,-1)
	end
	
	--龙进入飞空状态或者吸气状态，核心可以遭到损伤
	if BehaviorFunctions.HasEntitySign(self.me,92002003) == true
	or BehaviorFunctions.HasEntitySign(self.me,92002007) == true then
		--如果还没开启核心
		if self.dragonBreath == false then
			--开启核心锁定，关闭其他部位锁定
			self.lockGroupInfo[1].targetInfo[3].isOpen = true
			self.lockGroupInfo[1].targetInfo[1].isOpen = false
			self.lockGroupInfo[1].targetInfo[2].isOpen = false
			--允许核心累积部位伤害
			BehaviorFunctions.SetHurtPartDamageEnable(self.me,"Core",true)
			self.dragonBreath = true
		end
	else
		--如果处于核心开启状态
		if self.dragonBreath == true then
			self.dragonBreath = false
			--修改核心权重
			--开启核心锁定，关闭其他部位锁定
			self.lockGroupInfo[1].targetInfo[1].isOpen = true
			self.lockGroupInfo[1].targetInfo[2].isOpen = true
			self.lockGroupInfo[1].targetInfo[3].isOpen = false
			--关闭核心累积部位伤害
			BehaviorFunctions.SetHurtPartDamageEnable(self.me,"Core",false)
		end
	end
	
	--滑翔状态障碍物检测
	if BehaviorFunctions.GetSkillSign(self.me,920020981) then
		local result = self:CheckObstacles(self.me,10,self.dirEnum.Front,5)
		if result == true then
			BehaviorFunctions.BreakSkill(self.me)
		end
	end
		
	--不可操作时，不执行下列行为
	if BehaviorFunctions.CanCtrl(self.me) == false then
		return
	end
	
	--根据不同阶段释放不同技能
	--开场释放龙吼
	if self.initialSkill == false then
		if BehaviorFunctions.CanCastSkill(self.me) then
			BehaviorFunctions.CastSkillByTarget(self.me,92002201,self.battleTarget)
			self.initialSkill = true
		end
	end
	--强化状态下第一个技能必定是陨石
	if self.powerUp == true then
		if BehaviorFunctions.CanCastSkill(self.me) and self.poweUpSkill == false then
			BehaviorFunctions.CastSkillByTarget(self.me,92002091,self.battleTarget)
			self.initialSkill = true
			self.poweUpSkill = true
		end
	end	
	
	--技能循环逻辑
	if BehaviorFunctions.CanCastSkill(self.me) then
		if BehaviorFunctions.GetEntityAttrValueRatio(self.me,1001) <= 5000 then
			self.jumpOutCdFrame = 120
			self.randomSkilCdFrame = {84,168}
			self:Phase2CastSkill()
			if self.powerUp == false and self.time >= self.powerUpFrame then
				BehaviorFunctions.CastSkillByTarget(self.me,92002009,self.me)
				self.powerUpFrame = self.time + self.powerUpCD * 30
			end
		else
			self.jumpOutCdFrame = 500
			--self.randomSkilCdFrame = {42,126}
			self.randomSkilCdFrame = {0,84}
			self:Phase1CastSkill()
		end
		
	end
	
	----技能测试用按键监听（按R）
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
		----local pos = BehaviorFunctions.GetPositionP(self.me)
		----local skill = {angle = 90 , minDistance = 5 , maxDistance = 20 , wide = 6,hight = 5 }
		--if BehaviorFunctions.CanCastSkill(self.me)  then
			----BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
			----self:JumpOut("jumpRight")
			--BehaviorFunctions.CastSkillByTarget(self.me,92002046,self.battleTarget)
			----LogError("dis :"..self.battleTargetDistance)
			----BehaviorFunctions.DoMagic(self.me,self.me,1001990)
			----BehaviorFunctions.DoLookAtPositionImmediately(self.me,424.2,436.1)
		--end
	--end		
	
	----技能测试用按键监听（按空格）
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump) then
		----LogError(self.battleTargetDistance)
		--self:Turn(self.battleTarget)
	--end
end

--一阶段移动逻辑
function Behavior92002:Phase1Move()
	local canNotMoveFront = self:CheckObstacles(self.me,5,self.dirEnum.Front,3)
	local canNotMoveBack = self:CheckObstacles(self.me,5,self.dirEnum.Back,3)
	local canNotMoveLeft = self:CheckObstacles(self.me,5,self.dirEnum.Left,3)
	local canNotMoveRight = self:CheckObstacles(self.me,5,self.dirEnum.Right,3)
	--检查当前状态
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	--返回与玩家的面向
	local directionList = self:ReturnDirection(self.battleTarget)
	local dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget)
	--判断距离
	if dis < self.shortRange then
		self.battleRange = self.BattleRangeEnum.Short
	elseif dis > self.longRange and dis < self.maxRange then
		self.battleRange = self.BattleRangeEnum.Long
	elseif dis >=self.maxRange then
		self.battleRange = self.BattleRangeEnum.Far
	else
		self.battleRange = self.BattleRangeEnum.Mid
	end
	--如果没有处于移动中,给出一个移动状态
	if self.myState ~= FightEnum.EntityState.Move then
		--设置每帧转向
		BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,false,15,0,-1)
		--如果处于超远距离
		if self.battleRange == self.BattleRangeEnum.Far then
			--朝玩家走过来
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
			self.subMoveType = self.subMoveTypeEnum.Walk
		else
			--如果左侧有障碍则右走
			if canNotMoveLeft then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
				self.subMoveType = self.subMoveTypeEnum.WalkRight
				--如果右侧有障碍则左走
			elseif canNotMoveRight then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
				self.subMoveType = self.subMoveTypeEnum.WalkLeft
				--如果都能走则随机一个方向
			else
				local R = BehaviorFunctions.RandomSelect(1,2)
				if R == 1 then --左走
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
					self.subMoveType = self.subMoveTypeEnum.WalkLeft
				elseif R == 2 then --右走
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
					self.subMoveType = self.subMoveTypeEnum.WalkRight
				end
			end
		end

	--如果处于移动状态
	elseif self.myState == FightEnum.EntityState.Move then
		--检查玩家具体的四面向情况
		local inLeftSide = false
		local inRightSide = false
		for i,v in ipairs(directionList) do
			if v == self.dirEnum.Left 
			or v == self.dirEnum.FrontLeft then
				inLeftSide = true
			end
			if v == self.dirEnum.Right
			or v == self.dirEnum.FrontRight then
				inRightSide = true
			end
		end
		--如果处于左走状态已经不能左走了或玩家处于背面则右走
		if self.subMoveType == self.subMoveTypeEnum.WalkLeft then
			if canNotMoveLeft 
			or inLeftSide then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
				self.subMoveType = self.subMoveTypeEnum.WalkRight
			end
		--如果处于右走状态已经不能右走了或玩家处于背面则左走
		elseif self.subMoveType == self.subMoveTypeEnum.WalkRight then
			if canNotMoveRight 
			or inRightSide then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
				self.subMoveType = self.subMoveTypeEnum.WalkLeft
			end
		--如果处于前走状态
		elseif self.subMoveType == self.subMoveTypeEnum.Walk then
			--处于中距离的时候停下
			if self.battleRange == self.BattleRangeEnum.Mid then
				--清空为待机
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
				self.subMoveType = self.subMoveTypeEnum.Idle
			end
		end
		--如果处于超远距离
		if self.battleRange == self.BattleRangeEnum.Far then
			--如果不处于前走状态
			if self.subMoveType ~= self.subMoveTypeEnum.Walk then
				--朝玩家走过来
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				self.subMoveType = self.subMoveTypeEnum.Walk
			end
		end
		--如果玩家处于龙的移动死角
		for i,v in ipairs(directionList) do
			if v == self.dirEnum.FullBack then
				local skillID = self:SelectSkill()
				if skillID then
					for i,skill in ipairs(self.skillList) do
						if skill.id == skillID then
							local skillIndex = i
							self:MonsterCastSkill(skillIndex)
						end
					end
				else
					self:Turn(self.battleTarget)
				end
			end
		end
	end	
end

--一阶段技能释放逻辑
function Behavior92002:Phase1CastSkill()
	--如果可以释放技能
	if BehaviorFunctions.CanCastSkill(self.me) then
		--判断当前公共CD是否允许释放
		if self.time >= self.skillTime then
			--如果可以使用绝技则优先使用绝技
			if self.time >= self.juejiSkillTime then
				local juejiSkillId = self:SelectJuejiSkill()
				if juejiSkillId then
					for i,skill in ipairs(self.skillList) do
						if skill.id == juejiSkillId then
							local skillIndex = i
							--释放绝技技能
							local skillCdFrame = math.ceil(math.random(self.randomSkilCdFrame[1],self.randomSkilCdFrame[2]))
							self:MonsterCastSkill(skillIndex)
							self.skillTime = self.time + skillCdFrame + self.skillList[skillIndex].durationFrame
						end
					end
					--else
					--LogError("无法选出绝技技能，请检查")
				end
			else
				--选择技能
				local skillId = self:SelectSkill()
				if skillId then
					for i,skill in ipairs(self.skillList) do
						if skill.id == skillId then
							local skillIndex = i
							--释放普通技能
							local skillCdFrame = math.ceil(math.random(self.randomSkilCdFrame[1],self.randomSkilCdFrame[2]))
							self:MonsterCastSkill(skillIndex)
							self.skillTime = self.time + skillCdFrame + self.skillList[skillIndex].durationFrame
						end
					end
					else
					--LogError("无法选出普通技能，请检查")
				end
			end
		else
			--如果间隔时间太短就用跳跃来替代移动
			if self.skillTime - self.time <= 40 and self.time >= self.jumpOutTime and self.juejiSkillTime - self.time >= 90 then
				if self.time >= self.jumpOutTime then
					local canNotMoveFront = self:CheckObstacles(self.me,30,self.dirEnum.Front,3)
					local canNotMoveBack = self:CheckObstacles(self.me,30,self.dirEnum.Back,3)
					local canNotMoveLeft = self:CheckObstacles(self.me,25,self.dirEnum.Left,3)
					local canNotMoveRight = self:CheckObstacles(self.me,25,self.dirEnum.Right,3)
					local canNotMoveLeft2 = self:CheckObstacles(self.me,10,self.dirEnum.Left,3)
					local canNotMoveRight2 = self:CheckObstacles(self.me,10,self.dirEnum.Right,3)
					--如果处于极近距离
					if self.battleRange == self.BattleRangeEnum.Short then
						--如果可以进行远程攻击
						if self:CheckSkillCD(92002071)
						or self:CheckSkillCD(92002072) then
							if canNotMoveBack then
								self:JumpOut("jumpBack")
							elseif canNotMoveFront then
								self:JumpOut("jumpFront")
							end
						end
					end
					self.jumpOutTime = self.time + self.jumpOutCdFrame
				end
			else
				self:Phase1Move()
			end
		end
	end
end

--二阶段移动逻辑
function Behavior92002:Phase2Move()
	local canNotMoveFront = self:CheckObstacles(self.me,5,self.dirEnum.Front,3)
	local canNotMoveBack = self:CheckObstacles(self.me,5,self.dirEnum.Back,3)
	local canNotMoveLeft = self:CheckObstacles(self.me,5,self.dirEnum.Left,3)
	local canNotMoveRight = self:CheckObstacles(self.me,5,self.dirEnum.Right,3)
	--检查当前状态
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	--返回与玩家的面向
	local directionList = self:ReturnDirection(self.battleTarget)
	local dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget)
	--判断距离
	if dis < self.shortRange then
		self.battleRange = self.BattleRangeEnum.Short
	elseif dis > self.longRange and dis < self.maxRange then
		self.battleRange = self.BattleRangeEnum.Long
	elseif dis >=self.maxRange then
		self.battleRange = self.BattleRangeEnum.Far
	else
		self.battleRange = self.BattleRangeEnum.Mid
	end
	--如果没有处于移动中,给出一个移动状态
	if self.myState ~= FightEnum.EntityState.Move then
		--设置每帧转向
		BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,false,15,0,-1)
		--如果处于超远距离
		if self.battleRange == self.BattleRangeEnum.Far then
			--朝玩家走过来
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
			self.subMoveType = self.subMoveTypeEnum.Walk
		else
			--如果左侧有障碍则右走
			if canNotMoveLeft then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
				self.subMoveType = self.subMoveTypeEnum.WalkRight
				--如果右侧有障碍则左走
			elseif canNotMoveRight then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
				self.subMoveType = self.subMoveTypeEnum.WalkLeft
				--如果都能走则随机一个方向
			else
				local R = BehaviorFunctions.RandomSelect(1,2)
				if R == 1 then --左走
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
					self.subMoveType = self.subMoveTypeEnum.WalkLeft
				elseif R == 2 then --右走
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
					self.subMoveType = self.subMoveTypeEnum.WalkRight
				end
			end
		end

		--如果处于移动状态
	elseif self.myState == FightEnum.EntityState.Move then
		--检查玩家具体的四面向情况
		local inLeftSide = false
		local inRightSide = false
		for i,v in ipairs(directionList) do
			if v == self.dirEnum.Left
				or v == self.dirEnum.FrontLeft then
				inLeftSide = true
			end
			if v == self.dirEnum.Right
				or v == self.dirEnum.FrontRight then
				inRightSide = true
			end
		end
		--如果处于左走状态已经不能左走了或玩家处于背面则右走
		if self.subMoveType == self.subMoveTypeEnum.WalkLeft then
			if canNotMoveLeft
				or inLeftSide then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
				self.subMoveType = self.subMoveTypeEnum.WalkRight
			end
			--如果处于右走状态已经不能右走了或玩家处于背面则左走
		elseif self.subMoveType == self.subMoveTypeEnum.WalkRight then
			if canNotMoveRight
				or inRightSide then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
				self.subMoveType = self.subMoveTypeEnum.WalkLeft
			end
			--如果处于前走状态
		elseif self.subMoveType == self.subMoveTypeEnum.Walk then
			--处于中距离的时候停下
			if self.battleRange == self.BattleRangeEnum.Mid then
				--清空为待机
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
				self.subMoveType = self.subMoveTypeEnum.Idle
			end
		end
		--如果处于超远距离
		if self.battleRange == self.BattleRangeEnum.Far then
			--如果不处于前走状态
			if self.subMoveType ~= self.subMoveTypeEnum.Walk then
				--朝玩家走过来
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				self.subMoveType = self.subMoveTypeEnum.Walk
			end
		end
		--如果玩家处于龙的移动死角
		for i,v in ipairs(directionList) do
			if v == self.dirEnum.FullBack then
				local skillID = self:SelectSkill()
				if skillID then
					for i,skill in ipairs(self.skillList) do
						if skill.id == skillID then
							local skillIndex = i
							self:MonsterCastSkill(skillIndex)
						end
					end
				else
					self:Turn(self.battleTarget)
				end
			end
		end
	end
end

--二阶段技能释放逻辑
function Behavior92002:Phase2CastSkill()
	--如果可以释放技能
	if BehaviorFunctions.CanCastSkill(self.me) then
		--判断当前公共CD是否允许释放
		if self.time >= self.skillTime then
			--如果可以使用绝技则优先使用绝技
			if self.time >= self.juejiSkillTime then
				local juejiSkillId = self:SelectJuejiSkill()
				if juejiSkillId then
					for i,skill in ipairs(self.skillList) do
						if skill.id == juejiSkillId then
							local skillIndex = i
							--释放绝技技能
							local skillCdFrame = math.ceil(math.random(self.randomSkilCdFrame[1],self.randomSkilCdFrame[2]))
							self:MonsterCastSkill(skillIndex)
							self.skillTime = self.time + skillCdFrame + self.skillList[skillIndex].durationFrame
						end
					end
					--else
					--LogError("无法选出绝技技能，请检查")
				end
			else
				--选择技能
				local skillId = self:SelectSkill()
				if skillId then
					for i,skill in ipairs(self.skillList) do
						if skill.id == skillId then
							local skillIndex = i
							--释放普通技能
							local skillCdFrame = math.ceil(math.random(self.randomSkilCdFrame[1],self.randomSkilCdFrame[2]))
							self:MonsterCastSkill(skillIndex)
							self.skillTime = self.time + skillCdFrame + self.skillList[skillIndex].durationFrame
						end
					end
					--else
					--LogError("无法选出普通技能，请检查")
				end
			end
		else
			--如果间隔时间太短就用跳跃来替代移动
			if self.skillTime - self.time <= 40 and self.time >= self.jumpOutTime and self.juejiSkillTime - self.time >= 90 then
				if self.time >= self.jumpOutTime then
					local canNotMoveFront = self:CheckObstacles(self.me,30,self.dirEnum.Front,3)
					local canNotMoveBack = self:CheckObstacles(self.me,30,self.dirEnum.Back,3)
					local canNotMoveLeft = self:CheckObstacles(self.me,25,self.dirEnum.Left,3)
					local canNotMoveRight = self:CheckObstacles(self.me,25,self.dirEnum.Right,3)
					local canNotMoveLeft2 = self:CheckObstacles(self.me,10,self.dirEnum.Left,3)
					local canNotMoveRight2 = self:CheckObstacles(self.me,10,self.dirEnum.Right,3)
					--如果处于极近距离
					if self.battleRange == self.BattleRangeEnum.Short then
						--如果可以进行远程攻击
						if self:CheckSkillCD(92002071) 
						or self:CheckSkillCD(92002072) then
							if canNotMoveBack then
								self:JumpOut("jumpBack")
							elseif canNotMoveFront then
								self:JumpOut("jumpFront")
							elseif canNotMoveLeft then
								self:JumpOut("jumpLeft")
							elseif canNotMoveRight then
								self:JumpOut("jumpRight")
							end
						else
							if canNotMoveLeft2 then
								self:JumpOut("jumpLeftTurn")
							elseif canNotMoveRight2 then
								self:JumpOut("jumpRightTurn")
							--else
								--self:JumpOut("FrontToTarget")
							end
						end
					--如果处于其他距离
					else
						if canNotMoveLeft2 then
							self:JumpOut("jumpLeftTurn")
						elseif canNotMoveRight2 then
							self:JumpOut("jumpRightTurn")
						else
							self:JumpOut("FrontToTarget")
						end
					end
					self.jumpOutTime = self.time + self.jumpOutCdFrame
				end
			else
				self:Phase2Move()
			end
		end
	end
end

--计算玩家与其各个锁定点的距离
function Behavior92002:GetTargetGroupDistance(list)
	for groupIndex,group in ipairs(list) do
		for Index,targetInfo in ipairs(group.targetInfo) do
			targetInfo.dis = BehaviorFunctions.GetTransformDistance(self.battleTarget,"Root",self.me,targetInfo.bindName)
		end
	end
end

--根据锁定点距离和权重乘算计算出点位权重
function Behavior92002:SetTargetGroupWeight(list)
	local totalWeight = 0
	for groupIndex,group in ipairs(list) do
		--先算出总权重
		for Index,targetInfo in ipairs(group.targetInfo) do
			--if targetInfo.isOpen then
				totalWeight = totalWeight + targetInfo.dis
			--end
		end
		--给出单个权重
		for Index2,targetInfo2 in ipairs(group.targetInfo) do
			local resultWeight = 0
			if targetInfo2.isOpen then
				targetInfo2.weight = totalWeight - targetInfo2.dis
				if targetInfo2.weightMutiply then
					resultWeight = targetInfo2.weight * targetInfo2.weightMutiply
				else
					resultWeight = targetInfo2.weight
				end
				BehaviorFunctions.SetMemberWeight(self.me,group.groupName,targetInfo2.index,resultWeight)
			else
				BehaviorFunctions.SetMemberWeight(self.me,group.groupName,targetInfo2.index,0)
			end
		end
	end
end

function Behavior92002:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		if skillId == 92002072 then
			local beilubeite = BehaviorFunctions.GetCombinationTargetId(self.me)
			if beilubeite then
				if BehaviorFunctions.CanCastSkill(beilubeite) then
					BehaviorFunctions.CastSkillByTarget(beilubeite,92001072,self.battleTarget)
				end
			end
		end
	end
end

--技能结束判断
function Behavior92002:FinishSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		--注视ik开始
		BehaviorFunctions.SetHeadIkVisible(self.me,true)
	end
	--绝技技能接续
	if instanceId == self.me and skillId == 92002098 then
		BehaviorFunctions.CastSkillByTarget(self.me,92002099,self.battleTarget)
	end
	if instanceId == self.me then
		--记录转向技能是否结束
		for i,v in ipairs(self.rotateList) do
			if skillId == v.id then
				self.rotateState = false
			end
		end
		self.juejiDistanceFix = false
	end
end

--技能打断判断
function Behavior92002:BreakSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		--注视ik开始
		BehaviorFunctions.SetHeadIkVisible(self.me,true)
	end
	--绝技技能接续
	if instanceId == self.me and skillId == 92002098 then
		BehaviorFunctions.CastSkillByTarget(self.me,92002099,self.battleTarget)
	end
	if instanceId == self.me then
		--记录转向技能是否结束
		for i,v in ipairs(self.rotateList) do
			if skillId == v.id then
				self.rotateState = false
			end
		end
		self.juejiDistanceFix = false
	end
end

function Behavior92002:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local bulletEntityID = BehaviorFunctions.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.battleTarget and hitInstanceId == self.me then
		if bulletEntityID == 1001080001 then
			--local nowCast = BehaviorFunctions.GetSkill(self.me)
			--if nowCast then
				--if nowCast == 92002098 then
					----BehaviorFunctions.BreakSkill(self.me)
					----左轻受击动作
					--BehaviorFunctions.CastSkillByTarget(self.me,92002019,self.battleTarget)
				--end
			--end
			--左轻受击动作
			BehaviorFunctions.CastSkillByTarget(self.me,92002019,self.battleTarget)
		end
		if attackType == FightEnum.EAttackType.Air then
			--大受击后退硬直
			BehaviorFunctions.CastSkillByTarget(self.me,92002018,self.battleTarget)
		end
	end
end

--实体标记进入判断
function Behavior92002:AddEntitySign(instanceId,sign)
	if instanceId == self.me then
		--进入瘫痪状态时，播放瘫倒在地动作
		if sign == 92002001  then
			--关闭核心搜索和锁定
			if BehaviorFunctions.CheckEntityPartSearch(self.me,"Core") == false then
				BehaviorFunctions.SetEntityPartSearch(self.me,"Core",true)
			end
			if BehaviorFunctions.CheckEntityPartLock(self.me,"Core") == false then
				BehaviorFunctions.SetEntityPartSearch(self.me,"Core",true)
			end
			BehaviorFunctions.CastSkillByTarget(self.me,92002014,self.battleTarget)
		end
		--瘫倒在地动作结束时，播放起身动作
		if sign == 92002002 then
			BehaviorFunctions.CastSkillByTarget(self.me,92002015,self.battleTarget)
		end
		
		--进入吸气状态
		if sign == 92002003 and self.dragonBreath == false then
			--开启核心搜索和锁定
			if BehaviorFunctions.CheckEntityPartSearch(self.me,"Core") == true then
				BehaviorFunctions.SetEntityPartSearch(self.me,"Core",false)
			end
			--if BehaviorFunctions.CheckEntityPartLock(self.me,"Core") == true then
				--BehaviorFunctions.SetEntityPartSearch(self.me,"Core",false)
			--end
		end
		
		--检测到吸气过程结束,进入狂化状态
		if sign == 92002004 and self.dragonBreath ==  true then
			--关闭核心搜索和锁定
			if BehaviorFunctions.CheckEntityPartSearch(self.me,"Core") == false then
				BehaviorFunctions.SetEntityPartSearch(self.me,"Core",true)
			end
			--if BehaviorFunctions.CheckEntityPartLock(self.me,"Core") == false then
				--BehaviorFunctions.SetEntityPartSearch(self.me,"Core",true)
			--end
			--吸气完成动作
			BehaviorFunctions.CastSkillByTarget(self.me,92002012,self.battleTarget)
			BehaviorFunctions.AddBuff(self.me,self.me,1001999)--添加强化特效
			self.powerUpLimitTime = BehaviorFunctions.GetEntityFrame(self.me) + self.powerUpDuration * 30 --记录强化截止时间
			BehaviorFunctions.AddEntitySign(self.me,92002005,self.powerUpDuration,true)--标记为狂化状态，受时间缩放影响
			self:CleanUpSkillCDFrame() --清空主动技能CD
			self.powerUp = true
			self.phase = 2
		end
		
		--技能嘶吼落雷随机落雷地点判断
		if sign == 920020011 then
			local val1 = self.thunderVal1
			local val2 = self.thunderVal2
			--气氛组落雷
			self:CreatBullet(92002001001,val1.target,val1.num,val1.interval,val1.rangeDistance,val1.angle,val1.disBetweenThunder)
			--伤害组落雷
			self:CreatBullet(92002001001,val2.target,val2.num,val2.interval,val2.rangeDistance,val2.angle,val2.disBetweenThunder)
		end

		--技能飞天随机陨石地点判断
		if sign == 920020911 then
			local val1 = self.meteroVal1
			local val2 = self.meteroVal2
			--气氛组陨石
			self:CreatBullet(92002091001,val1.target,val1.num,val1.interval,val1.rangeDistance,val1.angle,val1.disBetweenThunder)
			--伤害组陨石
			self:CreatBullet(92002091001,val2.target,val2.num,val2.interval,val2.rangeDistance,val2.angle,val2.disBetweenThunder)
		end
		
		--技能可爱星星飞天撞临时判断
		if sign == 920020931 then
			local angle = math.random(0,360)
			local place = BehaviorFunctions.GetPositionOffsetBySelf(self.battleTarget,660,angle)
			BehaviorFunctions.DoSetPosition(self.me,place.x,place.y,place.z)
		end
		
		--技能可爱星星飞天撞2判断
		if sign == 920020961 then
			self:CuteStarFlySmash(self.battleTarget,40,600,5)
		end	
	end	
end

--实体标记退出判断
function Behavior92002:RemoveEntitySign(instanceId,sign)
	if instanceId == self.me then
		--退出狂化状态
		if self.powerUp == true and sign == 92002005 then
			BehaviorFunctions.RemoveBuff(self.me,1001999)--移除强化特效
			self.powerUp = false
			self.powerUpSkill = false
			self.phase = 2
		end		
	end
end

function Behavior92002:AddSkillSign(instanceId,sign)
	if instanceId == self.me then
		if sign == 92002100 then
			--注视ik关闭
			BehaviorFunctions.SetHeadIkVisible(self.me,false)
		end
	end
end

--部位移除封装
function Behavior92002:RemovePart(partName)
	--关闭部位伤害
	local isDamegeEnable = BehaviorFunctions.GetPartEnableHit(self.me,partName)
	if isDamegeEnable == true then
		BehaviorFunctions.SetPartEnableHit(self.me,partName,false)
	end
	--关闭部位碰撞
	local isCollisionEnable = BehaviorFunctions.SetPartEnableCollision(self.me,partName)
	if isCollisionEnable == true then
		BehaviorFunctions.SetPartEnableCollision(self.me,partName,false)
	end
	--关闭部位搜索
	local isSearchEnable = BehaviorFunctions.CheckEntityPartSearch(self.me,partName)
	if isSearchEnable == true then
		BehaviorFunctions.SetEntityPartSearch(self.me,partName,false)
	end
	--关闭部位锁定
	local isLockEnable = BehaviorFunctions.CheckEntityPartLock(self.me,partName)
	if isLockEnable == true then
		BehaviorFunctions.SetEntityPartLock(self.me,partName,false)
	end
end

--部位摧毁逻辑
function Behavior92002:PartDestroy(instanceId, partName,eventId)
	if instanceId == self.me then
		--尾巴相关处理
		if partName == "Tail" then
			if eventId == 1001 then
				BehaviorFunctions.CastSkillByTarget(self.me,92002017,self.battleTarget)
				BehaviorFunctions.DoMagic(self.me,self.me,1001994)
				self:RemovePart("Tail")
			end
		--头部相关处理
		elseif partName == "Head" then
			if eventId == 2001 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92002013,self.battleTarget)
				BehaviorFunctions.DoMagic(self.me,self.me,1001998)--爆头特效
			elseif eventId == 2002 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92002013,self.battleTarget)
				BehaviorFunctions.DoMagic(self.me,self.me,1001998)--爆头特效
			end
		--核心相关处理
		elseif partName == "Core" then
			if BehaviorFunctions.GetSkill(self.me) == 92002091 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92002092,self.battleTarget)
			else
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92002011,self.battleTarget)
			end
		end
	end
end

--部位受击逻辑
function Behavior92002:PartHit(instanceId,partName,life,damage,attackType,shakeStrenRatio)
	--受击骨骼抖动
	if shakeStrenRatio > 0.2 then
		if shakeStrenRatio >= 1 then
			self.shakeRatio = 1
		elseif shakeStrenRatio > 0.2 and shakeStrenRatio <= 0.4 then
			self.shakeRatio = shakeStrenRatio + 0.2
		elseif shakeStrenRatio > 0.4 and shakeStrenRatio < 1 then
			self.shakeRatio = shakeStrenRatio
		end
		if partName == "RightBackLeg" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"RightBackHit","RightBackHit",self.shakeRatio,100000014,false)
		end
		if partName == "LeftBackLeg" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"LeftBackHit","LeftBackHit",self.shakeRatio,100000014,false)
		end
		if partName == "LeftFrontLeg" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"LeftFrontHit","LeftFrontHit",self.shakeRatio,100000014,false)
		end
		if partName == "RightFrontLeg" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"RightFrontHit","RightFrontHit",self.shakeRatio,100000014,false)
		end
		if partName == "Tail" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"TailHit","TailHit",self.shakeRatio,100000014,false)
		end		
		if partName == "Head" then
			--local Angle = BehaviorFunctions.GetEntityAngle(self.me,self.battleTarget)
			local Angle = BehaviorFunctions.GetEntityBonesAngle(self.me, "Center", self.battleTarget, "Root")
			if Angle > 0 and Angle <= 180 then
				BehaviorFunctions.PlayAddAnimation(instanceId,"HeadRightHit","HeadHit",self.shakeRatio,100000014,false)
			elseif Angle > 180 and Angle <= 360 then
				BehaviorFunctions.PlayAddAnimation(instanceId,"HeadLeftHit","HeadHit",self.shakeRatio,100000014,false)
			end
		end
		
	end
end

--返回玩家处于巴西利克斯的哪个方向
function Behavior92002:ReturnDirection(target)
	local dirList = {}
	--local angleToEnemy = BehaviorFunctions.GetEntityAngle(self.me,target)
	local angleToEnemy = BehaviorFunctions.GetEntityBonesAngle(self.me, "Center", self.battleTarget, "Root")
	for dir,angle in ipairs(self.directionList) do
		if angle.maxAngel > angle.minAngel then
			if angleToEnemy >= angle.minAngel and angleToEnemy < angle.maxAngel then
				table.insert(dirList,dir)
			end
		else
			if angleToEnemy >= angle.minAngel or angleToEnemy < angle.maxAngel then
				table.insert(dirList,dir)
			end
		end
	end
	--会返回（1个全向+2个四向位置+1个八向精准位置）
	return dirList
	--1全向2全前方3全后方4全左方5全右方6前方7后方8左方9右方10左前11右前12左后13右后
end

--转向相关
function Behavior92002:Turn(target)
	if BehaviorFunctions.CanCastSkill(self.me) then
		if self.time >= self.rotateTime then
			local dirList = self:ReturnDirection(target)
			for i,dir in ipairs(dirList) do
				if dir ~= self.dirEnum.Front then
					for index,rotate in ipairs(self.rotateList) do
						if rotate.dir == dir then
							if target == self.battleTarget then
								BehaviorFunctions.CastSkillByTarget(self.me,rotate.id,target)
							else
								local pos = BehaviorFunctions.GetPositionP(self.bornPosEntity)
								BehaviorFunctions.CastSkillByPositionP(self.me,rotate.id,pos)
							end
							self.rotateTime = self.rotateTime +self.rotateCdFrame
							self.rotateState = true
							return rotate
						end
					end
				end
			end
		end
	end
end

--选择绝技技能
function Behavior92002:SelectJuejiSkill()
	if BehaviorFunctions.CanCastSkill(self.me) then
		local juejiList = {}
		--获得角度
		local dirList = self:ReturnDirection(self.battleTarget)
		--挑选出当前阶段可以使用的绝技
		for index,skill in ipairs(self.skillList) do
			if skill.isJueji == true and skill.phase <= self.phase then	
				if self.time > skill.frame then
					table.insert(juejiList,skill)
				end	
			end
		end
		--计算绝技总数量
		local juejiNum = #juejiList
		--检查对应技能的适配性
		for index,skill in ipairs(juejiList) do
			--如果距离适合则检查角度，是否需要先进行转向
			if self.battleTargetDistance >= skill.minDistance and
				self.battleTargetDistance < skill.maxDistance then
				--检查角度
				for i,dir in ipairs(dirList) do
					if skill.dir == dir then
						return skill.id
					end
				end
				self:Turn(self.battleTarget)
				break
			end
		end
		if self.juejiDistanceFix == false then
			--则使用飞天冲撞绝技
			local dirList = self:ReturnDirection(self.bornPosEntity)
			for i,dir in ipairs(dirList) do
				--先判断四面向
				if dir == self.dirEnum.FullFront then
					for i2,dir2 in ipairs(dirList) do
						if dir2 == self.dirEnum.Front then
							--朝前方跳跃
							BehaviorFunctions.CastSkillByTarget(self.me,92002029,self.battleTarget)
							self.juejiDistanceFix = true
							break
						end
					end
				elseif dir == self.dirEnum.FullBack then
					for i2,dir2 in ipairs(dirList) do
						if dir2 == self.dirEnum.Back then
							--朝后方跳跃
							BehaviorFunctions.CastSkillByTarget(self.me,92002030,self.battleTarget)
							self.juejiDistanceFix = true
							break
						end
					end
				end
				--先进行转向
				self:Turn(self.bornPosEntity)
			end
		else
			--self:MonsterCastSkill(92002098)
			BehaviorFunctions.CastSkillByTarget(self.me,92002098,self.battleTarget)
			self.juejiSkillTime = self.time + self.juejiSkillCDFrame
		end
	end
end

--选择技能
function Behavior92002:SelectSkill()
	if BehaviorFunctions.CanCastSkill(self.me) then
		local skillList = self:SkillState()
		local skillNum = #skillList
		for index,skill in ipairs(skillList) do
			if skill.canCast == true then
				return skill.id
			end
			for index2,skill2 in ipairs(skillList) do
				if skill.phase == true and skill.distance == true and skill.CD == true and skill.isAuto == true then
					--LogError("需要转向")
					self:Turn(self.battleTarget)
					break
				elseif skill.phase == true and skill.CD == true and skill.isAuto == true then
					if skill.distance == "tooFar" then
						--LogError("太远了")
						local result = self:JumpOut("FrontToTarget")
						if not result then
							self.juejiSkillTime = self.time
							break
						end					
					elseif skill.distance == "tooClose" then
						--LogError("太近了")
						--检查后方是否可以跳跃
						local result = self:CheckObstacles(self.me,10,self.dirEnum.Back,3)
						if result then
							--向后跳跃
							self:JumpOut("jumpBack")
							break
						else
							--向前跳跃
							self:JumpOut("jumpFront")
							break
						end
					end
				end
			end
		end
	end
end

--检查对应技能cd是否好了
function Behavior92002:CheckSkillCD(skillID)
	for index,skill in ipairs(self.skillList) do
		if skill.id == skillID then
			if self.time >= skill.frame then
				return true
			else
				return false
			end
		end
	end
end

--方形范围检测
function Behavior92002:SquareDetect(target,skill)
	local angle = skill.angle
	local minDis = skill.minDistance
	local maxDis = skill.maxDistance
	--获得长宽
	local long = maxDis - minDis
	local wide = skill.wide
	local hight = skill.hight*2

	local distance = minDis+(long/2)

	--先确认点的位置
	local myEuler = BehaviorFunctions.GetEntityEuler(self.me)
	local facaPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,5,0)
	local center = BehaviorFunctions.GetPositionOffsetP(self.centerPos,facaPos,distance,angle)
	--local center = BehaviorFunctions.GetPositionOffsetBySelf(self.me,distance,angle)
	local result = BehaviorFunctions.CheckEntityInBoxArea(target,center,wide,hight,long,myEuler.y+angle)
	return result
end

--记录当前技能状态
function Behavior92002:SkillState()
	local skillList = {}
	local dirList = self:ReturnDirection(self.battleTarget)
	for index,skill in ipairs(self.skillList) do
		table.insert(skillList,index,{id = skill.id , canCast = false, CD = false , isAuto = false ,phase = false , dir = false , distance = false})
		--检查CD
		if self.time >= skill.frame then
			skillList[index].CD = true
		end
		--检查角度
		if skill.checkType == "circle" then
			for i,dir in ipairs(dirList) do
				if skill.dir == dir then
					skillList[index].dir = true
				end
			end
		elseif skill.checkType == "square" then
			local result = self:SquareDetect(self.battleTarget,skill)
			if result then
				skillList[index].dir = true
			end
		end

		--检查距离	
		if skill.checkType == "circle" then
			if self.battleTargetDistance >= skill.minDistance and
				self.battleTargetDistance < skill.maxDistance then
				skillList[index].distance = true
			elseif self.battleTargetDistance < skill.minDistance then
				skillList[index].distance = "tooClose"
			elseif self.battleTargetDistance > skill.maxDistance then
				skillList[index].distance = "tooFar"
			end
		elseif skill.checkType == "square" then
			if skillList[index].dir == true then
				skillList[index].distance = true
			end
		end	
		
		--检查阶段
		if skill.phase <= self.phase then
			skillList[index].phase = true
		end
		--是否自动释放
		if skill.isAuto == true then
			skillList[index].isAuto = true
		end
	end
	--标记为是否可释放
	for index,skill in ipairs(skillList) do
		if skill.isAuto then
			if skill.CD == true then
				if skill.dir == true then
					if skill.distance == true then
						if skill.phase == true then
							skillList[index].canCast = true
						end
					end
				end
			end
		end
	end
	return skillList
end

--清空所有主动技能CD
function Behavior92002:CleanUpSkillCDFrame()
	for index,skill in ipairs(self.skillList) do
		if skill.isAuto == true then
			skill.frame = self.time
		end
	end
end

--释放技能
function Behavior92002:MonsterCastSkill(indexNum)
	local skill = self.skillList[indexNum]
	BehaviorFunctions.CastSkillByTarget(self.me,skill.id,self.battleTarget)
	skill.frame = self.time +skill.cd * 30
	--如果是绝技
	if skill.isJueji == true then
		self.juejiSkillTime = self.time + self.juejiSkillCDFrame
	end
end

function Behavior92002:JumpOut(order)
	if self.time > self.jumpOutTime then
		if order == "jumpBack" then
			BehaviorFunctions.CastSkillByTarget(self.me,92002031,self.battleTarget)
		elseif order == "FrontToTarget" then
			BehaviorFunctions.CastSkillByTarget(self.me,92002028,self.battleTarget)
		elseif order == "jumpFront" then
			BehaviorFunctions.CastSkillByTarget(self.me,92002037,self.battleTarget)
		elseif order == "jumpLeftTurn" then
			BehaviorFunctions.CastSkillByTarget(self.me,92002035,self.battleTarget)
		elseif order == "jumpRightTurn" then
			BehaviorFunctions.CastSkillByTarget(self.me,92002036,self.battleTarget)
		elseif order == "jumpLeft" then
			BehaviorFunctions.CastSkillByTarget(self.me,92002047,self.battleTarget)
		elseif order == "jumpRight" then
			BehaviorFunctions.CastSkillByTarget(self.me,92002048,self.battleTarget)
		end
	else
		return  false
	end
end

--技能列表初始化
function Behavior92002:InitSkillList(skillList)
	local list = {}
	for k = 1, #skillList do
		list[k] = skillList[k]
	end
	--技能列表排序，优先级：优先priority降序，priority相同则id升序
	table.sort(list,function(a,b)
			if a.priority > b.priority then
				return true
			elseif a.priority == b.priority then
				if a.id < b.id then
					return true
				end
			end
		end)
	return list
end

--制造雷电
function Behavior92002:CreatBullet(bullet1,target1,num1,interval1,rangeDistance1,angle1,disBetweenThunder1)
	local bullet = bullet1
	local placeRocrd = nil
	local target = target1			  --以该目标为中心
	local times = num1				  --释放次数
	local interval = {}				 --用于储存释放帧数间隔
	local minInterval = interval1[1]   --释放的帧数最小间隔
	local maxInterval = interval1[2]   --释放的帧数最大间隔
	local minDis = rangeDistance1[1]	  --最小释放距离
	local maxDis = rangeDistance1[2]	  --最大释放距离
	local minAngle = angle1[1]			--最小释放角度
	local maxAngle = angle1[2]			--最大释放角度
	local minThunderDis = disBetweenThunder1	--雷之间的最小距离
	local releaseFrame = 0

	for thunderNum = 1, times do
		interval [thunderNum] = math.ceil(math.random(minInterval,maxInterval))
		releaseFrame = releaseFrame + interval [thunderNum]
		local place = 0
		local dis = 0
		--循环1000次来找一个满足偏移需求的距离
		for placeNum = 1, 1000 do
			local range = math.random(minDis,maxDis)	--最小与最大释放距离
			local angle = math.random(minAngle,maxAngle)--随机释放角度
			place = BehaviorFunctions.GetPositionOffsetBySelf(target,range,angle)
			local height = BehaviorFunctions.CheckPosHeight(place,PhysicsTerrain.TerrainCheckLayer)--获取与地面的相对高度
			if height ~=  nil then
				place.y = place.y - height
			end
			if placeRocrd ~= nil then
				dis = BehaviorFunctions.GetDistanceFromPos(place,placeRocrd[thunderNum - 1]) --只比对上一次闪电的落点
			end
			if placeRocrd ~= nil then 
				if placeNum ~= 1000 and dis >= minThunderDis
					or placeNum == 1000 then
					--延迟添加雷电和震屏,这里Y轴坐标取怪物坐标防止玩家跳起来
					BehaviorFunctions.AddDelayCallByFrame(releaseFrame,BehaviorFunctions,BehaviorFunctions.CreateEntity,bullet,self.me,place.x,place.y,place.z,place.x,nil,place.z)
					placeRocrd[thunderNum] = place--记录这一次的位置
					break
				elseif dis < minThunderDis then
					--如果距离小于预设距离则
				end
			elseif placeRocrd == nil then
				BehaviorFunctions.AddDelayCallByFrame(releaseFrame,BehaviorFunctions,BehaviorFunctions.CreateEntity,bullet,self.me,place.x,place.y,place.z,place.x,nil,place.z)				
				placeRocrd = {}
				placeRocrd[thunderNum] = place
				break
			end
		end
	end
end

--计算飞行角度下的长宽
function Behavior92002:TriangleLenth(angel,distance)
	local height = math.sin(math.rad(angel))*distance
	local wide = math.sqrt((distance*distance)-(height*height))
	local Lenth = {x = wide , y = height}
	return Lenth
end


--飞行角度预估
function Behavior92002:SkillAngle(target,angle,distance)
	local Lenth = self:TriangleLenth(angle,distance)
	local angle2 = math.random(0,360)
	--额外在玩家前方20米的地方降落
	local place = BehaviorFunctions.GetPositionOffsetBySelf(target,Lenth.x+20,angle2)
	place.y = place.y + Lenth.y
	local playerPlace = BehaviorFunctions.GetPositionP(target)
	local height = BehaviorFunctions.CheckPosHeight(playerPlace,PhysicsTerrain.TerrainCheckLayer)
	if height == nil then
		height = 0
	end
	playerPlace.y = playerPlace.y - height + 0.5
	local result = BehaviorFunctions.CheckObstaclesBetweenPos(place,playerPlace)

	--如果飞行过程中有障碍物则换一个角度试试，直至没有角度可试
	if result == true then
		local checkAngel = 5
		local checkTimes = 360/checkAngel
		for i = 1, checkTimes do
			angle2 = angle2 + checkAngel
			if angle2 >= 360 then
				angle2 = angle2 -360
			end
			place = BehaviorFunctions.GetPositionOffsetBySelf(target,Lenth.x+20,angle2)
			place.y = place.y + Lenth.y
			local height = BehaviorFunctions.CheckPosHeight(playerPlace,PhysicsTerrain.TerrainCheckLayer)
			playerPlace.y = playerPlace.y - height + 0.2
			result = BehaviorFunctions.CheckObstaclesBetweenPos(place,playerPlace)
			if result == false then
				return place
			else
				if i == checkTimes then
					LogError("所有角度都不可通过")
					return nil
				end
			end
		end
	else
		return place
	end
end

--可爱星星飞天撞2
function Behavior92002:CuteStarFlySmash (target,angle,distance,speed)
	if BehaviorFunctions.HasEntitySign(self.me,920020961) then
		--返回滑翔时该有的高度
		local Lenth = self:TriangleLenth(angle,distance)
		--返回滑翔时该出现的高度		
		local place = self:SkillAngle(target,angle,distance)
		
		if place ~= nil then			
			BehaviorFunctions.DoSetPosition(self.me,place.x,place.y,place.z)
			BehaviorFunctions.DoLookAtTargetImmediately(self.me,target)
		end

	elseif BehaviorFunctions.HasEntitySign(self.me,920020962) then
		local position = BehaviorFunctions.GetPositionP(self.me)
		local vect = Vec3.New(position.x,position.y,position.z)
		local groud = BehaviorFunctions.CheckPosHeight(vect,PhysicsTerrain.TerrainCheckLayer)
		local myEuler = BehaviorFunctions.GetEntityEuler(self.me)
		if groud ~= nil then
			if groud <= 1 and myEuler.x ~= 0 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.SetEntityEuler(self.me,0,myEuler.y,myEuler.z)
				BehaviorFunctions.CastSkillByTarget(self.me,92002097,self.battleTarget)
			elseif groud >= 1 then
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
				BehaviorFunctions.SetEntityEuler(self.me,angle,myEuler.y,myEuler.z)
				BehaviorFunctions.DoMoveForward(self.me,speed)
			end
		else
			BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
			BehaviorFunctions.SetEntityEuler(self.me,angle,myEuler.y,myEuler.z)
			BehaviorFunctions.DoMoveForward(self.me,speed)
		end
	end
end

function Behavior92002:Death(instanceId,isFormationRevive)
	if instanceId == self.me then
		BehaviorFunctions.RemoveFightTarget(self.me,self.battleTarget)
		--怪物死亡时移除强锁标签
		if BehaviorFunctions.HasEntitySign(1,10000007) then
			BehaviorFunctions.RemoveEntitySign(1,10000007)
			BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,1101,true)--改回强锁参数
		end
		--怪物死后，移除强锁切换标签
		if BehaviorFunctions.HasEntitySign(self.me,10000024) then
			BehaviorFunctions.RemoveEntitySign(self.me,10000024)
		end
		--怪物死后，移除Boss血条标签
		if BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.RemoveEntitySign(1,10000020)
		end
	end
end

--检查周围障碍
function Behavior92002:CheckObstacles(target,distance,direction,offsetY)
	local targetPos = BehaviorFunctions.GetPositionP(target)
	local angle = nil
	if direction == self.dirEnum.Front then
		angle = 0
	elseif direction == self.dirEnum.Back then
		angle = 180
	elseif direction == self.dirEnum.Left then
		angle = 270
	elseif direction == self.dirEnum.Right then
		angle = 90
	end
	local pos = BehaviorFunctions.GetPositionOffsetBySelf(target,distance,angle)
	if offsetY then
		pos.y = pos.y + offsetY
	end
	local result = BehaviorFunctions.CheckObstaclesBetweenPos(targetPos,pos)
	--if result == true then
		--LogError("CurrentPos:"..targetPos.x,targetPos.y,targetPos.z)
		--LogError("TargetPos:"..pos.x,pos.y,pos.z)
	--end
	return result
end