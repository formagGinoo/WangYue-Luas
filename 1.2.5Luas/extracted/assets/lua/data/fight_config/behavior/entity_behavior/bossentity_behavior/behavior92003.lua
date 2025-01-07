Behavior92003 = BaseClass("Behavior92003",EntityBehaviorBase)
--资源预加载
function Behavior92003.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function Behavior92003.GetMagics()
	local generates = {92003003,92003004}
	return generates
end



--声明怪物
function Behavior92003:Init()

	self.me = self.instanceId--记录自身
	self.role = BehaviorFunctions.GetCtrlEntity()--记录玩家

	--出生参数
	self.haveBornSkill = false           --是否有出生技能
	self.haveSpecialBornLogic = false    --出生技能是否有特殊逻辑
	self.bornSkillId = nil	           --出生技能id
	self.initialDazeTime = 1		       --出生发呆时间
	self.inFight  = false				--出生时不进入战斗
	self.inPeace = true
	--踱步距离
	
	self.shortRange = 4                 --游荡近距离边界值
	self.longRange = 10                  --游荡远距离边界值
	self.maxRange = 16                   --游荡超远距离边界值
	self.minRange = 2                  --极限近身距离，追杀模式最小追踪距离
	self.RanderFrame = 0				--踱步切换cd
	self.RanderTime = 5
	self.RanderBFrame = 0
	self.RanderBTime = 2
	self.ignoreWalk = false
	
	self.born = false
	--技能放完计时
	self.skillFinishFrame = 0
	
	self.time = 0
	self.skillIndex = 1
	self.Angry = 0
	self.AngryFrame = 0
	
	--转向相关参数
	self.rotateTime = 0
	self.rotateCdFrame = 30
	self.visionAngle = 60
	self.inVision = false
	
	--检查相关参数
	self.ObsRight = 0
	self.ObsRtacle = 0
	self.ObsLtacle = 0
	self.ObsLeft = 0

	self.PreSkillList = {}
	self.curSkillList = {}
	
	self.thunderTimes = 0
	self.hitEffectFrame = 0 --受击特效时间
	
	self.confrontation = false --允许对峙
	self.walking = 0	--当前的行走方向，0待机，1前，2后，3左，4右
	
	
	--记录移动开始时间和移动状态
	self.moving = 0
	self.moveTime = 0
	self.closeTime = 0
	self.subMoveType = 0
	self.skillAngle = 0
	--用于记录一些特殊状态

	self.TurnPhase = false
	self.AngryRatio = 0
	self.phase = 1
	
	self.ultimateFrame = 0	--大招cd
	
	self.AngryCd = 0
	self.AngryTime = 0
	
	self.useCombo = true --连击状态
	self.comboCheckFrame = 0
	
	self.test = 0 --是否开启调试
	
	self.coreDamageaccumulation = 0

	self.stopBehavior = false
	
	self.warnDelayTime = 5 --警戒时间

	
	self.storyFrame = 0

	
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
	}

	--方向枚举
	self.dirEnum =
	{
		Front = 1,
		Back = 2,
		Left = 3,
		Right = 4,
		FrontLeft = 5,
		FrontRight = 6,
		BackLeft = 7,
		BackRight = 8,
		Any = 9,
		
	}
	
	--角度方向判断
	self.directionList =
	{
		--前方
		[self.dirEnum.Front] = {minAngle = 315 , maxAngle = 45},
		--后方
		[self.dirEnum.Back] = { minAngle = 165 , maxAngle = 195},
		--左侧
		[self.dirEnum.Left] = { minAngle = 270 , maxAngle = 300},
		--右侧
		[self.dirEnum.Right] = {minAngle = 60 , maxAngle = 120},
		--左前
		[self.dirEnum.FrontLeft] = { minAngle = 300 , maxAngle = 315},
		--左后
		[self.dirEnum.BackLeft] = { minAngle = 195 , maxAngle = 270},
		--右前
		[self.dirEnum.FrontRight] = {minAngle = 45 , maxAngle = 60 },
		--右后
		[self.dirEnum.BackRight] = { minAngle = 120 , maxAngle = 165},
		
		

	}
	
	

		

	--技能列表(id,默认释放距离,最小释放距离，角度,cd秒数,技能动作持续帧数，计时用帧数,优先级,是否自动释放,难度系数)
	self.skillList =
	{
		--转身斜下砸
		--{id = 92003007 ,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 4,        --技能释放最大距离（无等号）
			--dir = self.dirEnum.Left,
			--minAngle = 0,
			--maxAngle = 150,
			--cd = 8,
			--frame = 0,
			--durationFrame = 126,     --技能持续帧数
			--priority = 50,           --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--phase = 1,		 	 	 --技能所属阶段
			--group = 92003007,
			--ComboSkill = {92003305},
		--},

		----上挑
		--{id = 92003004 ,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 4,        --技能释放最大距离（无等号）
			--dir = self.dirEnum.Right,
			--minAngle = 0,
			--maxAngle = 180,
			--cd = 10,
			--frame = 0,
			--durationFrame = 103,     --技能持续帧数
			--priority = 90,           --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--phase = 1,		 	 	 --技能所属阶段
			--ComboSkill = {92003305},
		--},
		
		--下砸
		{id = 92003005 ,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,
			dir = self.dirEnum.None,
			minAngle = 60,
			maxAngle = 120,
			cd = 12,
			frame = 0,
			durationFrame = 111,     --技能持续帧数
			priority = 100,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能所属阶段
			group = 0,
			ComboSkill = {92003305},
		},
		
		----转身二连
		{id = 92003306 ,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			dir = self.dirEnum.BackLeft,--释放角度1
			minAngle = 0,			--释放角度2
			maxAngle = 180,
			cd = 12,
			frame = 0,
			durationFrame = 126,     --技能持续帧数
			priority = 100,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能所属阶段
			group = 0,
			ComboSkill = {92003305},
		},
		--横扫二连
		{id = 92003030 ,
			minDistance = 0,        --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Right,
			minAngle = 30,
			maxAngle = 270,
			cd = 15,
			frame = 0,
			durationFrame = 200,      --技能持续帧数
			priority = 70,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能所属阶段
			group = 0,
			ComboSkill = {92003305},
		},
		
		----三连
		--{id = 92003307 ,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 6,
			--dir = self.dirEnum.None,
			--minAngle = 30,
			--maxAngle = 180,
			--cd = 18,
			--frame = 0,
			--durationFrame = 167,     --技能持续帧数
			--priority = 10,            --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--phase = 1,		 	 	 --技能所属阶段
			--group = 92003007,
			--ComboSkill = {92003305},
		--},


		----四连1
		----{id = 92003006 ,
			----minDistance = 0,         --技能释放最小距离（有等号）
			----maxDistance = 4,
			----dir = self.dirEnum.None,
			----minAngle = 45,
			----maxAngle = 135,
			----cd = 15,
			----frame = 0,
			----durationFrame = 360,     --技能持续帧数
			----priority = 50,            --优先级，数值越大优先级越高
			----isAuto = true,           --是否自动释放
			----phase = 1,		 	 	 --技能所属阶段
			----group = 0,
			----ComboSkill = {92003305},
		----},
		



		--踩地
		{id = 92003009 ,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 10,
			dir = self.dirEnum.BackLeft,
			minAngle = 0,
			maxAngle = 180,
			cd = 12,
			frame = 0,
			durationFrame = 75,     --技能持续帧数
			priority = 100,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能所属阶段
			group = 92003009,
		},
			
		----横扫
		----{id = 92003010 ,
			----minDistance = 0,        --技能释放最小距离（有等号）
			----maxDistance = 3.5,        --技能释放最大距离（无等号）
			----dir = self.dirEnum.Right,
			----minAngle = 30,
			----maxAngle = 270,
			----cd = 15,
			----frame = 0,
			----durationFrame = 168,      --技能持续帧数
			----priority = 40,           --优先级，数值越大优先级越高
			----isAuto = true,           --是否自动释放
			----phase = 1,		 	 	 --技能所属阶段
			----group = 0,
			----ComboSkill = {92003305},
		----},
		

		
		----跳砸
		{id = 92003015 ,
			minDistance = 6,        --技能释放最小距离（有等号）
			maxDistance = 18,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,
			minAngle = 45,
			maxAngle = 135,
			cd = 12,
			frame = 0,
			durationFrame = 108,      --技能持续帧数
			priority = 70,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能所属阶段
			group = 0,
			ComboSkill = {92003305},
		},


		----前冲横扫
		{id = 92003013 ,
			minDistance = 6,        --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,
			minAngle = 45,
			maxAngle = 135,
			cd = 10,
			frame = 0,
			durationFrame = 103,      --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 1,		 	 	 --技能所属阶段
			group = 0,
			ComboSkill = {92003305},
		},
		

		------中距离踩地
		----{id = 92003309 ,
			----minDistance = 5,         --技能释放最小距离（有等号）
			----maxDistance = 8,
			----dir = self.dirEnum.BackLeft,
			----minAngle = 0,
			----maxAngle = 180,
			----cd = 15,
			----frame = 0,
			----durationFrame = 75,     --技能持续帧数
			----priority = 70,            --优先级，数值越大优先级越高
			----isAuto = true,           --是否自动释放
			----phase = 1,		 	 	 --技能所属阶段
			----group = 92003009,
		----},
		
		----后跳
		{id = 92003003 ,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,	 --允许的释放方向
			minAngle = 45,
			maxAngle = 135,
			cd = 25,
			frame = 0,			 --初始CD长度
			durationFrame = 55,     --技能持续帧数
			priority = 10,           --优先级，数值越大优先级越高
			isAuto = true,          --是否自动释放
			phase = 1,		 	 	 --技能所属阶段
			group = 2,
			ComboSkill = {92003305},
		},

		----旋转后跳
		{id = 92003001 ,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 6,        --技能释放最大距离（无等号）
			dir = self.dirEnum.BackLeft,	 --允许的释放方向
			minAngle = 135,
			maxAngle = 360,
			cd = 25,
			frame = 0,			 --初始CD长度
			durationFrame = 55,     --技能持续帧数
			priority = 30,           --优先级，数值越大优先级越高
			isAuto = true,          --是否自动释放
			phase = 1,		 	 	 --技能所属阶段
			group = 2,
			ComboSkill = {92003305},
		},
		------横扫后跳
		----{id = 92003103 ,
			----minDistance = 0,        --技能释放最小距离（有等号）
			----maxDistance = 4,        --技能释放最大距离（无等号）
			----dir = self.dirEnum.Left,
			----cd = 20,
			----frame = 120,
			----durationFrame = 95,      --技能持续帧数
			----priority = 50,           --优先级，数值越大优先级越高
			----isAuto = true,           --是否自动释放
			----phase = 1		 	 	 --技能所属阶段
		----},
		------横扫下砸
		----{id = 92003105 ,
			----minDistance = 0,        --技能释放最小距离（有等号）
			----maxDistance = 5,        --技能释放最大距离（无等号）
			----dir = self.dirEnum.Front,
			----cd = 15,
			----frame = 0,
			----durationFrame = 153,      --技能持续帧数
			----priority = 50,           --优先级，数值越大优先级越高
			----isAuto = true,           --是否自动释放
			----phase = 1		 	 	 --技能所属阶段
		----},

		
		
		----左位移
		{id = 92003201 ,
			minDistance = 0,        --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,
			minAngle = 60,
			maxAngle = 120,
			cd = 20,
			frame = 0,
			durationFrame = 35,      --技能持续帧数
			priority = 40,           --优先级，数值越大优先级越高
			isAuto = false,           --是否自动释放
			phase = 2,		 	 	 --技能所属阶段
			--ComboSkill = {92003305},
		},

		----后位移
		{id = 92003202 ,
			minDistance = 0,        --技能释放最小距离（有等号）
			maxDistance = 6,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Left,
			minAngle = 0,
			maxAngle = 45,
			cd = 20,
			frame = 0,
			durationFrame = 53,      --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			group = 4,
			phase = 2,		 	 	 --技能所属阶段
			--ComboSkill = {92003305},
		},
		
		
		----后跳
		{id = 92003203 ,
			minDistance = 0,        --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			dir = self.dirEnum.BackLeft,
			minAngle = 0,
			maxAngle = 60,
			cd = 20,
			frame = 0,
			durationFrame = 52,      --技能持续帧数
			priority = 10,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			group = 3,
			phase = 2,		 	 	 --技能所属阶段
			--ComboSkill = {92003305},
		},
		
		----旋转后跳
		{id = 92003226 ,
			minDistance = 0,        --技能释放最小距离（有等号）
			maxDistance = 6,        --技能释放最大距离（无等号）
			dir = self.dirEnum.BackLeft,	 --允许的释放方向
			minAngle = 135,
			maxAngle = 360,
			cd = 20,
			frame = 0,
			durationFrame = 52,      --技能持续帧数
			priority = 10,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			group = 3,
			phase = 2,		 	 	 --技能所属阶段
			--ComboSkill = {92003305},
		},
		----二阶段左挥锤
		--{id = 92003204 ,
			--minDistance = 0,        --技能释放最小距离（有等号）
			--maxDistance = 4,        --技能释放最大距离（无等号）
			--dir = self.dirEnum.None,
			--minAngle = 0,
			--maxAngle = 180,
			--cd = 5,
			--frame = 0,
			--durationFrame = 124,      --技能持续帧数
			--priority = 50,           --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--group = 0,
			--phase = 2,		 	 	 --技能所属阶段
			--ComboSkill = {92003305},
		--},
		
		----二阶段下砸
		{id = 92003205 ,
			minDistance = 0,        --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,
			minAngle = 0,
			maxAngle = 180,
			cd = 15,
			frame = 0,
			durationFrame = 97,      --技能持续帧数
			priority = 100,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 2,		 	 	 --技能所属阶段
			group = 0,
			ComboSkill = {92003305},
		},
		
		
		----召雷不死斩
		{id = 92003312 ,
			minDistance = 0,        --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,
			minAngle = 45,
			maxAngle = 135,
			cd = 12,
			frame = 0,
			durationFrame = 35,      --技能持续帧数
			priority = 90,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 2,
			group = 0	 	 	 --技能所属阶段
			--ComboSkill = {92003305},
		},
		
		----二阶段三连
		--{id = 92003207 ,
			--minDistance = 0,        --技能释放最小距离（有等号）
			--maxDistance = 4,        --技能释放最大距离（无等号）
			--dir = self.dirEnum.None,
			--minAngle = 0,
			--maxAngle = 180,
			--cd = 15,
			--frame = 0,
			--durationFrame = 130,      --技能持续帧数
			--priority = 80,           --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--phase = 2,		 	 	 --技能所属阶段
			--group = 0,
			--ComboSkill = {92003305},
		--},
		
		--二阶段-新三连
		{id = 92003228 ,
			minDistance = 0,        --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,
			minAngle = 0,
			maxAngle = 180,
			cd = 15,
			frame = 0,
			durationFrame = 130,      --技能持续帧数
			priority = 80,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 2,		 	 	 --技能所属阶段
			group = 0,
			ComboSkill = {92003305},
		},	
		

		
		----二阶段横扫
		--{id = 92003211 ,
			--minDistance = 0,        --技能释放最小距离（有等号）
			--maxDistance = 4,        --技能释放最大距离（无等号）
			--dir = self.dirEnum.None,
			--minAngle = 90,
			--maxAngle = 225,
			--cd = 15,
			--frame = 0,
			--durationFrame = 95,      --技能持续帧数
			--priority = 50,           --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--phase = 2,		 	 	 --技能所属阶段
			--group = 0,
			--ComboSkill = {92003305},
		--},
		
		----二阶段踏步横劈
		----{id = 92003212 ,
			----minDistance = 0,        --技能释放最小距离（有等号）
			----maxDistance = 4,        --技能释放最大距离（无等号）
			----dir = self.dirEnum.None,
			----minAngle = 45,
			----maxAngle = 135,
			----cd = 30,
			----frame = 0,
			----durationFrame = 68,      --技能持续帧数
			----priority = 50,           --优先级，数值越大优先级越高
			----isAuto = false,           --是否自动释放
			----phase = 2,		 	 	 --技能所属阶段
			----group = 0,
			----ComboSkill = {92003305},
		----},
		

		
		----二阶段前刺
		----{id = 92003209 ,
			----minDistance = 0,        --技能释放最小距离（有等号）
			----maxDistance = 4,        --技能释放最大距离（无等号）
			----dir = self.dirEnum.None,
			----minAngle = 60,
			----maxAngle = 120,
			----cd = 30,
			----frame = 0,
			----durationFrame = 63,      --技能持续帧数
			----priority = 50,           --优先级，数值越大优先级越高
			----isAuto = false,           --是否自动释放
			----phase = 2,		 	 	 --技能所属阶段
			----group = 0,
			----ComboSkill = {92003305},
		----},
		
		----二阶段跳跃横扫
		{id = 92003213 ,
			minDistance = 6,        --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,
			minAngle = 0,
			maxAngle = 180,
			cd = 12,
			frame = 0,
			durationFrame = 83,      --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 2,		 	 	 --技能所属阶段
			group = 0,
			ComboSkill = {92003305},
		},
		
		----二阶段跳砸
		{id = 92003215 ,
			minDistance = 7,        --技能释放最小距离（有等号）
			maxDistance = 20,        --技能释放最大距离（无等号）
			dir = self.dirEnum.None,
			minAngle = 30,
			maxAngle = 150,
			cd = 15,
			frame = 0,
			durationFrame = 118,      --技能持续帧数
			priority = 50,           --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			phase = 2,		 	 	 --技能所属阶段
			group = 4,
			ComboSkill = {92003305},
		},
		------二阶段后横扫
		----{id = 92003223 ,
			----minDistance = 0,        --技能释放最小距离（有等号）
			----maxDistance = 4,        --技能释放最大距离（无等号）
			----dir = self.dirEnum.BackRight,
			----minAngle = 0,
			----maxAngle = 180,
			----cd = 0,
			----frame = 120,
			----durationFrame = 95,      --技能持续帧数
			----priority = 50,           --优先级，数值越大优先级越高
			----isAuto = true,           --是否自动释放
			----phase = 2,		 	 	 --技能所属阶段
			----ComboSkill = {92003305},
		----},	
		----小跑二连接大招
		{id = 92003316,
			minDistance = 5,
			maxDistance = 10,
			dir = self.dirEnum.None,
			minAngle = 0,
			maxAngle = 180,
			cd = 30,
			frame = 0,
			durationFrame = 225,
			priority = 100,
			isAuto = true,
			phase = 2,
			group = 0,
			ComboSkill = {},
			}
		
	}
	--释放技能相关参数
	self.battleRange = self.BattleRangeEnum.Default
	self.frame = 0
	self.randomSkilCdFrame = {90,150}
	self.nextSkill = nil
	self.nextSkillSign = false
	self.initialSkill = false
	self.Move = 0
	self.ChangeState = 0
	self.AngryState = false
	self.blackFrame = 0
	self.confrontFrame = 0
	self.useMove = false
	self.leaveAway = false
end



function Behavior92003:Update()
	self.hp = BehaviorFunctions.GetEntityAttrValueRatio(self.me,1001)
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	self.myPos = BehaviorFunctions.GetPositionP(self.me)--记录自身位置
	self.dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)--记录距离
	self.Angle = BehaviorFunctions.GetEntityAngle(self.me,self.role)--记录角度
	self.role = BehaviorFunctions.GetCtrlEntity()--记录玩家
	self.roleDistance = math.abs(BehaviorFunctions.GetDistanceFromTarget(self.me,self.role))
	self.time = BehaviorFunctions.GetFightFrame()		 --记录当前世界时间
	self.selfTime = BehaviorFunctions.GetEntityFrame(self.me)--记录自身时间
	self.MoveState = BehaviorFunctions.GetSubMoveState(self.me)--记录自身移动状态
	self.ObsLeft = BehaviorFunctions.GetPositionOffsetBySelf(self.me,3,270)
	self.ObsRight = BehaviorFunctions.GetPositionOffsetBySelf(self.me,3,90)
	self.ObsBack = BehaviorFunctions.GetPositionOffsetBySelf(self.me,3,180)
	self.ObsLeft.y = self.ObsLeft.y + 0.5
	self.ObsRight.y = self.ObsRight.y + 0.5
	self.ObsBack.y = self.ObsBack.y + 0.5
	self.ObsRtacle = BehaviorFunctions.CheckObstaclesBetweenPos(self.myPos,self.ObsRight,false)
	self.ObsLtacle = BehaviorFunctions.CheckObstaclesBetweenPos(self.myPos,self.ObsLeft,false)
	self.ObsBtacle = BehaviorFunctions.CheckObstaclesBetweenPos(self.myPos,self.ObsBack,false)
	self.frame = 1
	self.pro = math.random(0,100)
	self:AngleCount()
	self:skillRush()
	self:skillFinishTurn()
	self:ComboLimit()
	self.hited = BehaviorFunctions.GetEntityValue(self.me,"hited")
	self:BeAngry(self.phase)
	self:ChangePhase(5000)
	BehaviorFunctions.SetEntityValue(self.me,"ChangeState",self.ChangeState)
	
	--添加索敌
	if not BehaviorFunctions.HasEntitySign(1,10000007) then
		BehaviorFunctions.AddEntitySign(1,10000007,-1,false)--添加强锁标签
		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,9200101,true)
	end
	
	--创建初始buff
	if self.initBuff ~= true then
		BehaviorFunctions.AddFightTarget(self.me,self.role)--添加索敌
		--BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,90001)--修改强锁参数
		BehaviorFunctions.DoMagic(self.me,self.me,92003003)
		BehaviorFunctions.DoMagic(self.me,self.me,92003021)
		
		--测试音效录屏用无敌
		--BehaviorFunctions.DoMagic(self.role,self.role,1000048)
		self.initBuff = true
	end
	
	--到时间关闭对峙模式
	if self.confrontFrame < self.time and self.confrontation == true then
		self.confrontation = false
	end
	

	--战斗前
	if self.inFight  == false and self.inPeace == true then
		if self.dis <= 6 then	
			self.inPeace = false
			self.warnFrame = self.time
		else
			self.inPeace = true
		end
	end
	
	--准备进入战斗
	if self.inPeace == false then
		if self.time - self.warnFrame >= self.warnDelayTime * 30 then
			self.inFight = true
		end
	end
	
	
	BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.me)--添加BossUI
	
	--处理技能期间的帧转向
	if BehaviorFunctions.CanCtrl(self.me) == false then
		BehaviorFunctions.CancelLookAt(self.me)
	end
	
	--添加boss血条
	if not BehaviorFunctions.HasEntitySign(1,10000020) then
		BehaviorFunctions.AddEntitySign(1,10000020,-1)
	end
	
	--动态修改踩地权重
	--if self.dis < 6 then
		--self.skillList[self:GetSkillIndex(92003009)].priority = 10
	--else
		--self.skillList[self:GetSkillIndex(92003009)].priority = 100
	--end
	
	--是否调试模式
	if self.test == 0 then
	--根据不同阶段释放不同技能
		--self.phase = 2
		if self.inFight == true then
			if BehaviorFunctions.CanCtrl(self.me) then
				if self.useMove == true and self.phase == 2 and self.skillList[self:GetSkillIndex(92003202)].frame < self.time and self.dis <= 6 then
					self:CastSkill1(self:GetSkillIndex(92003201))
					self.useMove = false
				elseif self.useMove == true and self.phase == 1 and self.skillList[self:GetSkillIndex(92003003)].frame < self.time and self.dis <= 6 then
					self:CastSkill1(self:GetSkillIndex(92003003))
					self.useMove = false
				else
					if self.ChangeState == 0 or self.ChangeState == 3 then
						if self.phase == 1 then
							self.randomSkilCdFrame = {90,150}
							self.skillIndex = self:selectSkill(1)
							self:CastSkill1(self.skillIndex)
						elseif self.phase == 2 then
							BehaviorFunctions.SetAnimatorLayer(self.me, "AngryLayer")
							self.randomSkilCdFrame = {0,90}
							self.skillIndex = self:selectSkill(2)
							self:CastSkill1(self.skillIndex)
							--self.phase = 2
						end
					end
				end
			else
				--BehaviorFunctions.SetHeadIkVisible(self.me,true)
			end
		end
	--调试模式
	else
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.LeaveClimb) then
			BehaviorFunctions.CastSkillByTarget(self.me,92003211,self.role)
		end
	end
	

end
	

--返回玩家处于哪个方向
function Behavior92003:ReturnDirection()
	local dirList = {}
	for dir,Angle in ipairs(self.directionList) do
		if dir ~= self.dirEnum.Front then
			if self.Angle >= Angle.minAngle and self.Angle < Angle.maxAngle then
				dirList = dir
			end
		elseif dir == self.dirEnum.Front then
			if self.Angle >= Angle.minAngle or self.Angle < Angle.maxAngle then
				dirList = dir
			end
		else
			dirList = {}
		end
	end
	return dirList
end

--踱步逻辑
function Behavior92003:Wander()
	

	--区域判断
	if self.dis < self.shortRange then
		self.battleRange = self.BattleRangeEnum.Short
	elseif self.dis > self.longRange and self.dis < self.maxRange then
		self.battleRange = self.BattleRangeEnum.Long
	elseif self.dis >=self.maxRange then
		self.battleRange = self.BattleRangeEnum.Far
	elseif self.dis >= self.shortRange and self.dis < self.longRange then
		self.battleRange = self.BattleRangeEnum.Mid
	end
		
		
	if BehaviorFunctions.CanCtrl(self.me) then
		--在视野中
		if BehaviorFunctions.CompEntityLessAngle(self.me,self.role,self.visionAngle/2) then
			self.inVision = true
		--不在则进行转向
		else
			self.inVision = false
			--BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.role,false,0,5,-2)
		end
		if self.myState ==  FightEnum.EntityState.Move or self.inVision == false then
			--if BehaviorFunctions.GetSkillSign(self.me,9999) == false then
			BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.role,true,0,5,-2)
			--end
		end
	end
	
	--检查障碍,重置行走状态
	--if self.ObsLtacle == true or self.ObsRtacle
	if self.ObsLtacle == true and self.walking == 3 
		or (self.ObsRtacle == true and self.walking == 4) then
		self.RanderFrame = self.time
	end
	
	if self.ObsBtacle == true and self.walking == 2 then
		self.RanderFrame = self.time
	end
	
	--不同距离
	if self.ignoreWalk == false then
		if self.battleRange == self.BattleRangeEnum.Far then
			if self.MoveState ~= FightEnum.EntityMoveSubState.Run and not BehaviorFunctions.CheckObstaclesBetweenEntity(self.me,self.role,true) then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
				self.ignoreWalk = true
				self.walking = 1
			end
		elseif self.battleRange == self.BattleRangeEnum.Long and self.ignoreWalk == false then
			if self.MoveState ~= FightEnum.EntityMoveSubState.Walk then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				self.walking = 1
			end
		elseif self.battleRange == self.BattleRangeEnum.Mid then
				
			if self:CheckSkillCanUse(self.phase,4) and self.confrontation ~= true then
				if self.MoveState ~= FightEnum.EntityMoveSubState.Walk then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
					self.walking = 1
				end
			elseif self.time > self.RanderFrame then
				self:WanderLR()
			end
			--self:WanderLR()
		elseif self.battleRange == self.BattleRangeEnum.Short and not self:CheckSkillCanUse(self.phase,4) then
			--if self.time - self.skillFinishFrame < 90 then
			if self.ObsBtacle == false then
				if self.MoveState ~= FightEnum.EntityMoveSubState.WalkBack then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkBack)
					self.RanderBFrame = self.time + self.RanderBTime * 30
					self.walking = 2
				end
			elseif self.time > self.RanderFrame and self.ObsBtacle == true then
				self:WanderLR()
			end
			--else
				--if self.MoveState ~= FightEnum.EntityMoveSubState.Walk then
					--BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				--end
			--end
		end
	else	
		if self.MoveState ~= FightEnum.EntityMoveSubState.Run then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
		end
	end
	
	if self.battleRange == self.BattleRangeEnum.Short and self.ignoreWalk == true then
		self.ignoreWalk = false
	end
end

--左右走
function Behavior92003:WanderLR()
	local direction = math.random(2)
	
	--根据随到的对峙结果做障碍检测
	--if self.ObsRtacle == true and self.ObsLtacle == false then
		--direction = 2
	--elseif self.ObsLtacle == true and self.ObsRtacle == false then
		--direction = 1
	--elseif self.ObsLtacle == true and self.ObsRtacle == true and self.ObsBtacle == false then
		--direction = 3
	--elseif self.ObsLtacle == true and self.ObsRtacle == true and self.ObsBtacle == true then
		--direction = 4
	--end
	
	--根据随到的对峙结果做障碍检测
	if self.ObsRtacle == true and self.ObsLtacle == false then
		direction = 2
	elseif self.ObsLtacle == true and self.ObsRtacle == false then
		direction = 1
	elseif self.ObsLtacle == true and self.ObsRtacle == true and self.ObsBtacle == false then
		direction = 3
	elseif self.ObsLtacle == true and self.ObsRtacle == true and self.ObsBtacle == true then
		direction = 4
	end

	--根据结果执行对峙行为
	if direction == 1 then
		if self.MoveState ~= FightEnum.EntityMoveSubState.WalkRight then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
			self.RanderFrame = self.time + self.RanderTime * 30
			self.walking = 4
		end
	elseif direction == 2 then
		if self.MoveState ~= FightEnum.EntityMoveSubState.WalkRight then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
			self.RanderFrame = self.time + self.RanderTime * 30
			self.walking = 3
		end
	elseif direction == 3 then
		if self.MoveState ~= FightEnum.EntityMoveSubState.WalkBack then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkBack)
			--self.RanderFrame = self.time + self.RanderBTime * 30
			self.walking = 2
		end
	elseif direction == 4 then
		if self.myState ~= FightEnum.EntityState.Idle then
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
			self.RanderFrame = self.time + self.RanderTime * 30
			self.walking = 0
		end
	end
end

--返回列表第一的技能
function Behavior92003:selectSkill(phase)
	if BehaviorFunctions.CanCtrl(self.me) then
		local dir = self:ReturnDirection()
		self.skillList = self:InitSkillList(self.skillList)
		for index,skill in pairs(self.skillList) do
			if self.time >= skill.frame then
				if skill.isAuto == true then
					if skill.phase == phase then
						if (self.skillAngle > skill.minAngle and self.skillAngle < skill.maxAngle) or skill.dir == dir then
						--if skill.dir == dir or skill.dir == self.dirEnum.Any then
							if self.ignoreWalk == false then
								if self.roleDistance >= skill.minDistance and
									self.roleDistance < skill.maxDistance then
									return index
								end
							else
								if self.roleDistance >= skill.minDistance and
									self.roleDistance < skill.maxDistance and self.roleDistance <= 4 then
									return index
								end
							end
						end
					end
				end
			end
		end
		return nil
	end
end

--返回没cd但不满足距离条件的技能
function Behavior92003:CheckSkillCanUse(phase,distance)
	if BehaviorFunctions.CanCtrl(self.me) then
		local dir = self:ReturnDirection()
		self.skillList = self:InitSkillList(self.skillList)
		for index,skill in pairs(self.skillList) do
			if self.time >= skill.frame then
				if skill.isAuto == true and skill.phase == phase then
					if (self.skillAngle > skill.minAngle and self.skillAngle < skill.maxAngle) or skill.dir == dir then
						if distance <= skill.maxDistance then
							if skill.group ~= 2 then
								return index
							end
						end
					end
				end
			end
		end
	end
	return nil
end

--释放技能
function Behavior92003:CastSkill1(skillIndex)
	local skill = self.skillList[skillIndex]
		--if self.time >= self.frame then
			if skillIndex then
				local skillCdFrame = math.ceil(math.random(self.randomSkilCdFrame[1],self.randomSkilCdFrame[2]))
				BehaviorFunctions.CastSkillByTarget(self.me,skill.id,self.role)
				--self:Confrontation(skillIndex)
				self:SkillGroupCD(skill)
				--self.frame = self.time + skillCdFrame + self.skillList[skillIndex].durationFrame - self.Angry
				skill.frame = self.time + skill.cd * 30 + skill.durationFrame - self.AngryFrame
				self.ignoreWalk = false
				--self:SetUseMove(skill.id)
			else
					self:Wander()
			end
		--else
			--self:Wander()
		--end

end

function Behavior92003:Confrontation(skillIndex)
	if self.skillList[skillIndex].group == 2 then
		self.confrontation = true
		self.confrontFrame = self.time + 150 +self.skillList[skillIndex].durationFrame
	end
	
	if self.skillList[skillIndex].group == 3 then
		self.confrontation = true
		self.confrontFrame = self.time + 90 +self.skillList[skillIndex].durationFrame
	end
end

--设置移动状态
function Behavior92003:SetUseMove(skillId)
	if skillId == 1 then
		
		
	end
end

--受击次数位移通知
--function Behavior92003:MoveSign()
	--local skillIndex = 0
	--for index,skill in pairs(self.skillList) do
		--if skill.id == 92003202 then
			--skillIndex = index
		--end
	--end
	
	--if self.hited >= 10 then
		--self.skillList[skillIndex].isAuto = true
	--end
--end


--处理公共cd
function Behavior92003:SkillGroupCD(skill)
	--横扫
	--if skill.id == 92003010 or skill.id == 92003103 or skill.id == 92003105 or skill.id == 92003115 or skill.id == 92003001 then

		--for index,skill1 in pairs(self.skillList) do
			--if skill1.id == 92003010 or skill1.id == 92003103 or skill1.id == 92003105 or skill1.id == 92003115 or skill1.id == 92003001 then
				--skill1.isAuto = false
				--BehaviorFunctions.AddDelayCallByTime(30,self,self.DelayTurnOn,skill1.id)
			--end
		--end
	--end
		
	--后跳后暂时设置远程技能不可释放
	--if skill.group == 2 then
		--for index,skill2 in pairs(self.skillList) do
			----设置突进技能cd为5
			--if skill2.id == 92003015 or skill2.id == 92003013 then
				--skill2.isAuto = false
				--BehaviorFunctions.AddDelayCallByTime(5,self,self.DelayTurnOn,skill2.id)
			--elseif skill2.id == 92003002 or skill2.id == 92003001 then
				--skill2.frame = self.time + skill2.cd * 30 + skill2.durationFrame - self.AngryFrame
			--end
		--end
	--end
	if skill.group == 92003009 then
		for index,skill2 in pairs(self.skillList) do
			if skill2.id == 92003009 or skill2.id == 92003309 then
				skill2.frame = self.time + skill2.cd * 30 + skill2.durationFrame - self.AngryFrame
			end
		end
	end
	
	if skill.group == 4 then
		for index,skill2 in pairs(self.skillList) do
			if skill2.id == 92003202 or skill2.id == 92003215 then
				skill2.frame = self.time + skill2.cd * 30 + skill2.durationFrame - self.AngryFrame
			end
		end
	end
	
	if skill.group == 92003007 then
		for index,skill2 in pairs(self.skillList) do
			if skill2.id == 92003007 or skill2.id == 92003307 then
				skill2.frame = self.time + skill2.cd * 30 + skill2.durationFrame - self.AngryFrame
			end
		end
	end
	
	--大招后锁跳砸
	if skill.id == 92003316 then
		for index,skill2 in pairs(self.skillList) do
			if skill2.id == 92003215 or skill2.id == 92003202 then
				skill2.isAuto = false
				BehaviorFunctions.AddDelayCallByTime(10,self,self.DelayTurnOn,skill2.id)
			end
		end
	end
	
	--三连
	if skill.id == 92003206 and skill.id == 92003207 then
		for index,skill2 in pairs(self.skillList) do
			if skill2.id == 92003206 or skill2.id == 92003207 then
				skill2.isAuto = false
				BehaviorFunctions.AddDelayCallByTime(5,self,self.DelayTurnOn,skill2.id)
			end
		end
	end
	
	if skill.id ==92003201 and skill.id == 92003202 or 92003226 then
		for index,skill2 in pairs(self.skillList) do
			if skill2.id == 92003201 or skill2.id == 92003202 or skill2.id == 92003316 or skill2.id == 92003226 then
				skill2.isAuto = false
				BehaviorFunctions.AddDelayCallByTime(8,self,self.DelayTurnOn,skill2.id)
			end
		end
	end
	
	
end


--愤怒值
function Behavior92003:BeAngry(phase)
	
	--愤怒值最大值=100
	if self.Angry >= 100 then
		self.Angry = 100
		if self.AngryState ~= true and self.AngryCd < self.time and phase == 2 then
			self.AngryState = true
			self.AngryTime = self.time + 8*30
			self.Angry = 0
		end
	end

	--十秒内不会红温
	if self.AngryTime < self.time and self.AngryState == true and phase == 2 then
		self.AngryState = false
		self.AngryCd = self.time + 10 * 30
	end
	
	--愤怒值自然衰减
	if self.Angry >= 3 then
		self.Angry = self.Angry - 3
	end
	
	--受击减少cd
	if phase == 1 then
		self.AngryRatio = 0.6
		self.AngryIncrease = 7
	elseif phase == 2 then
		self.AngryRatio = 0.9
		self.AngryIncrease = 10
	end

	self.AngryFrame = self.Angry * self.AngryRatio
end

--特殊状态检测
--function Behavior92003:AngryState()
	--if BehaviorFunctions.CanCastSkill(self.me) then
		--if self.Angle > 90 then
			
		--end
	--end	
--end

--技能列表排序
function Behavior92003:InitSkillList(skillList)
	local list = {}
	local rannum = math.random(0,2)
	for k = 1, #skillList do
		list[k] = skillList[k]
	end
	--技能列表排序，优先级：优先priority降序，priority相同则id升序
	table.sort(list,function(a,b)
			if a.priority > b.priority then
				return true
			elseif a.priority == b.priority then
				if rannum == 0 then
						return a.id < b.id
				elseif rannum == 1 then
						return a.id > b.id
				end
			end
		end)
	return list
end

--公共cd开启
function Behavior92003:DelayTurnOn(skillId)
	if self.me then
		for index,skill1 in pairs(self.skillList) do
			if skill1.id == skillId then
				skill1.isAuto = true
			end
		end
	end
end

----检查是否有连击技能
--function Behavior92003:ComboCheck(skill)
	--local ComboSkillList = {}
	--for index,skill1 in pairs(self.skillList) do
		--if skill1.id == skill and skill1.ComboSkill then
			--table.insert(ComboSkillList,skill1.ComboSkill)
		--end
	--end
	--local ComboSkill = math.random( 1,#ComboSkillList)
	--return ComboSkill
--end

--欧拉欧拉欧拉
function Behavior92003:AddSkillSign(instanceId,sign)
	if instanceId == self.me then
		--local ComboSkill = self:ComboCheck(sign)
		--if ComboSkill then
			--for index,skill1 in pairs(self.ComboSkillList) do
				--if skill1 == ComboSkill and skill1.frame < self.time and skill1.isAuto == true then
					--BehaviorFunctions.CastSkillByTarget(self.me,ComboSkill,self.role)
					--skill1.frame = self.time + skill1.duration + skill1.cd * 30
				--end
			--end
		--end
		self:Combo()
		--if sign == 100202 then
			--for index,skill1 in pairs(self.skillList) do
				--if skill1.id == 92003202 then
					--skill1.isAuto = false
				--end
			--end
		--end
		if sign == 92003207 then
			if self.dis < 6 then
				BehaviorFunctions.CastSkillByTarget(self.me,92003218,self.role)
			else
				BehaviorFunctions.CastSkillByTarget(self.me,92003220,self.role)
			end
		end
		
		if sign == 92003211 then
			BehaviorFunctions.CastSkillByTarget(self.me,92003210,self.role)
		end
		
		
		if sign == 92003228 then
			if self.dis < 6 then
				BehaviorFunctions.CastSkillByTarget(self.me,92003229,self.role)
			else
				BehaviorFunctions.CastSkillByTarget(self.me,92003230,self.role)
			end
		end
		
		--后位移接跳砸
		if sign == 92003202 then
			BehaviorFunctions.CastSkillByTarget(self.me,92003219,self.role)
		end
		
		if sign == 92003316 then
			if self.dis > 8 then
				BehaviorFunctions.CastSkillByTarget(self.me,92003322,self.role)
			else
				BehaviorFunctions.CastSkillByTarget(self.me,92003317,self.role)
			end
		end
		
		if sign == 92003322 then
			if self.dis < 8 then
				BehaviorFunctions.CastSkillByTarget(self.me,92003317,self.role)
			else
				BehaviorFunctions.CastSkillByTarget(self.me,92003322,self.role)
			end
		end
		
		if sign == 92003317 then
		--	if self.ultimateFrame < self.time then
				BehaviorFunctions.CastSkillByTarget(self.me,92003321,self.role)
				--self.ultimateFrame = self.time + 40 * 30
		--	end
		end
		
		
		--if sign == 92003019 and self.thunderTimes < 5 then
			--BehaviorFunctions.CastSkillBySelfPosition(self.me,92003019)
			--self.thunderTimes = self.thunderTimes + 1
		--elseif sign == 92003019 and self.thunderTimes == 5 then
			--BehaviorFunctions.CastSkillBySelfPosition(self.me,92003020)
		--end
		
		--if sign == 92003020 then
			--self.phase = 2
			--self.thunderTimes = 0
			--self.ChangeState = 3
			--BehaviorFunctions.RemoveBuff(self.me,92003010)
		--end
		
		if sign == 92003218 then
			if BehaviorFunctions.CheckSkillEventActiveSign(self.me,9999) then
				if self.skillList[self:GetSkillIndex(92003203)].frame < self.time then
					self:CastSkill1(self:GetSkillIndex(92003203))
				end
			else
				if self.skillList[self:GetSkillIndex(92003226)].frame < self.time then
					self:CastSkill1(self:GetSkillIndex(92003226))
				end
			end
		end
		
		--if sign == 92003220 then
			--self:CreateThunder(9200301902,self.thunderVal3.target,self.thunderVal3.num,self.thunderVal3.interval,self.thunderVal3.rangeDistance,self.thunderVal3.angle,self.thunderVal3.disBetweenThunder,self.thunderVal3.warnFrame)
		--end

		
		if sign == 92003319 then
			self:CreateThunder(9200301902,self.thunderVal1.target,self.thunderVal1.num,self.thunderVal1.interval,self.thunderVal1.rangeDistance,self.thunderVal1.angle,self.thunderVal1.disBetweenThunder,self.thunderVal1.warnFrame)
			BehaviorFunctions.AddDelayCallByFrame(10,self,self.CreateThunder,9200301902,self.thunderVal2.target,self.thunderVal2.num,self.thunderVal2.interval,self.thunderVal2.rangeDistance,self.thunderVal2.angle,self.thunderVal2.disBetweenThunder,self.thunderVal1.warnFrame)
		end
		
		if sign == 92003306 then
			BehaviorFunctions.CastSkillByTarget(self.me,92003308,self.role)
		end
		
		if sign == 92003011 and self.dis >= 6 then
			BehaviorFunctions.CastSkillByTarget(self.me,92003011,self.role)
		end
		
		if sign == 92003311 and self.dis <= 5 then
			BehaviorFunctions.CastSkillByTarget(self.me,92003311,self.role)
		end
	end
end

--转阶段机制技能
function Behavior92003:ChangePhase(hp)
	
	if BehaviorFunctions.CanCtrl(self.me) and self.phase == 1 then
		--触发timeline
		if self.hp < hp then
			if  self.ChangeState == 0 then
				BehaviorFunctions.AddEntitySign(self.me,92003019,-1,false)
				BehaviorFunctions.DoMagic(self.me,self.me,92003010)
				BehaviorFunctions.DoMagic(self.me,self.me,92003018)
				BehaviorFunctions.DoMagic(self.me,self.me,92003020)
				BehaviorFunctions.DoMagic(self.me,self.role,92003020)
				BehaviorFunctions.DoMagic(self.me,self.role,92003019)
				BehaviorFunctions.SetFightMainNodeVisible(1,"I",false)	--技能
				BehaviorFunctions.SetFightMainNodeVisible(1,"J",false)	--普攻
				BehaviorFunctions.SetFightMainNodeVisible(1,"O",false)	--跳跃
				BehaviorFunctions.SetFightMainNodeVisible(1,"K",false)	--疾跑
				BehaviorFunctions.SetFightMainNodeVisible(1,"R",false)	--仲魔
				BehaviorFunctions.SetFightMainNodeVisible(1,"Core",false)	--核心被动条
				BehaviorFunctions.SetFightMainNodeVisible(1,"PowerGroup",false,1)--隐藏能量条
				self.changStateStory = false
				self.storyFrame = self.time + 660
				self.ChangeState = 1
			end
		--测试二阶段用
		elseif hp == 0 then
			self.phase = 2
		end
		
		if self.storyFrame < self.time and self.ChangeState == 1 then
			BehaviorFunctions.ShowBlackCurtain(true,0)
			BehaviorFunctions.AddDelayCallByTime(1.5,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.6)
			BehaviorFunctions.SetFightMainNodeVisible(1,"I",true)	--技能
			BehaviorFunctions.SetFightMainNodeVisible(1,"J",true)	--普攻
			BehaviorFunctions.SetFightMainNodeVisible(1,"O",true)	--跳跃
			BehaviorFunctions.SetFightMainNodeVisible(1,"K",true)	--疾跑
			BehaviorFunctions.SetFightMainNodeVisible(1,"R",true)	--仲魔
			BehaviorFunctions.SetFightMainNodeVisible(1,"Core",true)	--核心被动条
			BehaviorFunctions.SetFightMainNodeVisible(1,"PowerGroup",true,1)--隐藏能量条
			BehaviorFunctions.RemoveBuff(self.me,92003019)
			BehaviorFunctions.RemoveBuff(self.me,92003018)
			BehaviorFunctions.RemoveBuff(self.role,92003020)
			BehaviorFunctions.DoSetPosition(self.me,95.57,7,100.9)	--设置自己位置
			BehaviorFunctions.DoSetPosition(self.role,95.57,7,105.9)	--设置角色位置
			BehaviorFunctions.SetEntityElementStateAccumulation(self.me, self.me, -1, 0)	--重置元素值
			BehaviorFunctions.CastSkillBySelfPosition(self.me,92003019)	--释放转阶段技能
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,95.57,7,100,true)
			BehaviorFunctions.DoLookAtTargetByLerp(self.role,self.me,false,180,180,-2)
			BehaviorFunctions.RemoveBuff(self.me,92003003)
			BehaviorFunctions.DoMagic(self.me,self.me,92003004,1)
			self.ChangeState = 2
		end
	end

	--被打断
	if self.ChangeState == 2 and self.phase == 1 then
		if BehaviorFunctions.CheckEntityElementState(self.me, 2, -1) then
			BehaviorFunctions.SetFightMainNodeVisible(1,"I",true)	--技能
			BehaviorFunctions.SetFightMainNodeVisible(1,"J",true)	--普攻
			BehaviorFunctions.SetFightMainNodeVisible(1,"O",true)	--跳跃
			BehaviorFunctions.SetFightMainNodeVisible(1,"K",true)	--疾跑
			BehaviorFunctions.SetFightMainNodeVisible(1,"R",true)	--仲魔
			BehaviorFunctions.SetFightMainNodeVisible(1,"Core",true)	--核心被动条
			BehaviorFunctions.SetFightMainNodeVisible(1,"PowerGroup",true,1)--隐藏能量条
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,92003225)
			BehaviorFunctions.RemoveEntitySign(self.me,92003019)
			BehaviorFunctions.RemoveBuff(self.me,92003010)
			self.ChangeState = 3
			self.phase = 2
		end
	end
	
end

--欧拉欧拉欧拉
function Behavior92003:Combo()
	local skillId = 0
	--if BehaviorFunctions.CanCastSkill(self.me) then

		if BehaviorFunctions.GetSkillSign(self.me,92003010) then
			skillId = 92003305
			BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.role)
			self:SkillGroupCD(self.skillList)
		elseif BehaviorFunctions.GetSkillSign(self.me,92003209) then
			skillId = 92003221
			BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.role)
			self:SkillGroupCD(self.skillList)
		elseif BehaviorFunctions.GetSkillSign(self.me,92003212) then
			skillId = 92003222
			BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.role)
			self:SkillGroupCD(self.skillList)
		elseif BehaviorFunctions.GetSkillSign(self.me,92003006) then
			skillId = 92003224
			BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.role)
			self:SkillGroupCD(self.skillList)
		elseif BehaviorFunctions.GetSkillSign(self.me,92003010) then
			skillId = 92003305
			BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.role)
			self:SkillGroupCD(self.skillList)
		elseif BehaviorFunctions.GetSkillSign(self.me,92003224) then
			skillId = 92003008
			BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.role)
			self:SkillGroupCD(self.skillList)
		elseif BehaviorFunctions.GetSkillSign(self.me,92003225) then
			skillId = 92003221
			BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.role)
			self:SkillGroupCD(self.skillList)
		--elseif BehaviorFunctions.GetSkillSign(self.me,92003218) then
			--skillId = 92003225
			--BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.role)
			--self:SkillGroupCD(self.skillList)
		end
	
	--end
end


--受击处理
function Behavior92003:AfterDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	if attackInstanceId == self.role and hitInstanceId == self.me and self.Angry == false then
		self.Angry = self.Angry + self.AngryIncrease	
	end
end

--释放技能回调
function Behavior92003:CastSkill()

	
	
end

--技能后摇转向
function Behavior92003:skillFinishTurn()
	--在前方
	if self.Angle < 90 or self.Angle > 270 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9999)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9999)
	end
	--在左前
	if self.skillAngle < 90 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9998)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9998)
	end
	--在右前
	if self.skillAngle > 90 and self.skillAngle < 180 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9997)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9997)
	end
	--右
	if self.skillAngle > 90 and self.skillAngle < 270 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9996)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9996)
	end
	--左
	if self.skillAngle > 270 and self.skillAngle < 360 or self.skillAngle > 0 and self.skillAngle < 90 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9995)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9995)
	end
	--后方
	if self.skillAngle > 180 and self.skillAngle < 360 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9994)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9994)
	end
	
	--左+左后
	if self.skillAngle > 300 and self.skillAngle < 360 or self.skillAngle > 0 and self.skillAngle < 90 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9992)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9992)
	end
	
	--右边+右后
	if self.skillAngle > 90 and self.skillAngle < 240 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9993)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9993)
	end
	
	--前+左后
	if self.skillAngle > 300 and self.skillAngle < 360 or self.skillAngle > 0 and self.skillAngle < 180 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9991)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9991)
	end
	
	--前+右后
	if self.skillAngle > 0 and self.skillAngle < 235 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,9990)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,9990)
	end
end


--技能前摇突进
function Behavior92003:skillRush()
	if self.dis <= 7 and self.dis > 0.5 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,8888)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,8888)
	end
	
	if self.dis <= 4.5 and self.dis > 0.5 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,8845)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,8845)
	end
	
	if self.dis <= 5 and self.dis > 0.5 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,8850)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,8850)
	end
	
end


--技能角度换算
function Behavior92003:AngleCount()
	if self.Angle >= 0 and self.Angle <= 270 then
		self.skillAngle = self.Angle + 90
	elseif self.Angle > 270 then
		self.skillAngle = self.Angle - 270
	end
end

function Behavior92003:BreakSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		self.skillFinishFrame = self.time
	end
end

function Behavior92003:FinishSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		self.skillFinishFrame = self.time
	end
end

function Behavior92003:Death(instanceId,isFormationRevive)
	if instanceId == self.me then
		BehaviorFunctions.RemoveFightTarget(self.me,self.role)
		--怪物死亡时移除强锁标签
		if BehaviorFunctions.HasEntitySign(1,10000007) then
			BehaviorFunctions.RemoveEntitySign(1,10000007)
			--BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,90002)--改回强锁参数
		end
		--怪物死后，移除Boss血条标签
		if BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.RemoveEntitySign(1,10000020)
		end
	end
end

function Behavior92003:SetSkillFrame()
	
end


--根据技能id返回序号
function Behavior92003:GetSkillIndex(skillId)
	for index,skill in pairs(self.skillList) do
		if skill.id == skillId then
			return index
		end
	end
	return nil
end

--追刀限制逻辑
function Behavior92003:ComboLimit()
	--下砸追击
	if BehaviorFunctions.GetSkillSign(self.me,92003205) and self.useCombo == true then
		BehaviorFunctions.CastSkillByTarget(self.me,92003214,self.role)
	end
	if self.useCombo == false and self.comboCheckFrame < self.time then
		self.useCombo = true
	end
end

--红温检测
function Behavior92003:ConditionEvent(instanceId, eventId)
	if instanceId == self.me and eventId == 92003021 then
		self.useMove = true
	end
end
----临时弹刀判断
--function Behavior92003:ReboundAttack(instanceId,instanceId2)
--if instanceId2 == self.me then
--local skillId = 0
--if BehaviorFunctions.GetSkill(instanceId2) == 92003212
--or BehaviorFunctions.GetSkill(instanceId2) == 92003209 then
--skillId = 92003217
--end
--if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Skill) then
--BehaviorFunctions.BreakSkill(self.me)
--end
--if BehaviorFunctions.HasBuffKind(self.me,900000001) then
--BehaviorFunctions.RemoveBuff(self.me,900000001)
--end
--if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Hit) then
--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
--end
--if skillId ~= 0 then
--BehaviorFunctions.CastSkillBySelfPosition(self.me,skillId)
--end


----if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Skill) then
----BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
----end

----BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Hit)
----BehaviorFunctions.SetHitType(self.MonsterCommonParam.me,FightEnum.EntityHitState.HitDown)
----if BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) then
----BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000001)
----end

--end
--end
function Behavior92003:UseMove()
	
end

function Behavior92003:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	--播放霸体特效
	if hitInstanceId == self.me then
		--播放霸体受击特效
		if BehaviorFunctions.HasBuffKind(hitInstanceId,900000040) and self.hitEffectFrame < self.time then
			BehaviorFunctions.DoMagic(self.me,self.me,900000052)
			self.hitEffectFrame = self.time + 8
		end
		
		if self.inFight == false then
			self.inFight = true
		end
		
		if BehaviorFunctions.GetSkillSign(self.me,92003321) then
			if attackType == 6 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92003225)
			end
		end
	end
	
	
	if attackInstanceId == self.me and hitInstanceId == self.role then
		if BehaviorFunctions.GetSkillSign(self.me,920032051) then
			self.useCombo = false
			self.comboCheckFrame = self.time + 30
		end
	end
	
end
