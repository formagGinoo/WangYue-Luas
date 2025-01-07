FSMBehavior900070 = BaseClass("FSMBehavior900070",FSMBehaviorBase)
--资源预加载
function FSMBehavior900070.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function FSMBehavior900070.GetMagics()
	local generates = {90007002}
	return generates
end

function FSMBehavior900070:Init()
	
	--个人属性检测参数：
	local myPos = Vec3.New()					--获取怪物释放技能时位置
	local positionP = Vec3.New()				--获取玩家坐标
	local myPosOffset = Vec3.New()				--角色位置偏移
	self.hitEffectFrame = 0
	self.myFrame = 0


	self.isActive = 0
	self.hideWeapon = false

	--被暗杀动作
	self.beAssassin = 900070009
	self.backHited = 900070062
	
	self.inFight = false													--是否在战斗总状态
	self.me = self.instanceId							                    --自身
	self.ecoMe = self.sInstanceId                                           --ecoid名称
	self.battleTarget = 0								                    --战斗目标
	self.myFrame = 0								                      	--自身帧数
	self.battleTargetDistance = 0		                                    --战斗目标与自身的距离
	self.myState = 0					                                    --自身状态
	self.LifeRatio = 0                                                      --生命值比率
	self.targetInHit = false                                                --目标受击
	
	--开放参数
	--MonsterBorn
	self.ecoId=nil
	self.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.initialDazeTime = 2		                                        --出生发呆时间
	
	--MonsterPeace
	self.actKey = true
	
	--MonsterWarn
	self.haveWarn = true             --是否有警告状态
	self.warnLimitRange = 3           --近身警告距离
	self.warnShortRange = 6           --近身疑问距离（无视角度）
	self.warnLongRange = 12            --远距离警告距离（结合VisionAngle）
	self.warnVisionAngle = 80          --远距离警告视角
	self.warnLimitHeight = 2          --极限警告高度
	self.warnDelayTime = 2            --警告延迟时间
	self.warnSkillId = 900070901            --警告技能Id
	self.warnSitSkillId = nil         --坐下后起立警告技能Id
	self.tauntSkillId = nil           --嘲讽技能
	self.noWarnInFightRange = 30       --havewarn ==false时 进战斗的距离
	
	self.hitEffectFrame = 0			--霸体受击特效计时用
	self.curAlertnessValue = 0        --初始警戒值
	self.maxAlertnessValue = 100      --最大警戒值（改这个值不能改变怪物的警戒条变化速度，需要改DelayTime）
	self.alertUIOffset = Vec3.New(0,0.7,0)     --警戒UI基于markcase的偏移值，默认偏移表现不佳时需要手动修改
	self.alertUIPoint = nil             --自定义警戒UI挂点，默认挂点markcase表现不佳时可以修改，例："Bip001 Head"
	
	self.canBeAss = true				--可否被暗杀

	--MonsterWander
	self.shortRange = 3				--游荡近距离边界值
	self.longRange = 6                 --游荡远距离边界值
	self.maxRange = 50                  --游荡超远距离边界值
	self.minRange = 2.5                   --极限近身距离，追杀模式最小追踪距离
	self.canLRWalk = true               --左右走开关
	self.LRWalkSwitchTime = 2.4		--左右走切换时间
	self.switchDelayTime = 1.2		--延迟切换时间(前后走)
	self.walkDazeTime = 1.067			--移动发呆时间
	self.canRun = true                  --跑步开关
	self.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.defaultSkillId = 900070002		--默认技能id，追杀模式使用
	self.visionAngle = 20               --视野范围，不在视野范围内会进行转向
	self.isFly = false                  --是否飞行怪
	self.monsterRangeRadius = 2			--以自身为圆心的一个范围，其他怪物无法wander进来
	
	--MonsterCastSkill
	self.difficultyDegree = 0           --难度系数
	self.initialSkillCd = 0				--技能初始cd
	self.commonSkillCd = 1.6				--技能公共cd
	self.haveSkillLifeRatio = true     --技能是否有生命值区间判断
	self.mySpecialState = nil           --特殊状态才能释放该技能
	self.attackRange = 1			  --怪物的攻击范围，1为近战，2为远程
	self.SkillSoundList = {"Play_v_zhanke_01","Play_v_zhanke_02","Play_v_zhanke_03"}
	self.initialSkillList = {
		--竖劈
		--{id = 900070001,
		--minDistance = 0,         --技能释放最小距离（有等号）
		--maxDistance = 3,         --技能释放最大距离（无等号）
		--angle = 100,              --技能释放角度
		--cd = 10,                  --技能cd，单位：秒
		----cd = 2,                --技能cd，单位：秒
		--durationFrame = 92,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--weight = 4,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
		--grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		--canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
		--specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		--},
		--举刀斜劈（1111）
		{id = 900070002,
			minDistance = 0,       --技能释放最小距离（有等号）
			maxDistance = 5,         --技能释放最大距离（无等号）
			angle = 60,             --技能释放角度
			cd = 8,                 --技能cd，单位：秒
			durationFrame = 90,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,   	 --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
			specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
			ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		},
		----------后撤步（蓄力架势）
		----{id = 900070003,
		----minDistance = 0,         --技能释放最小距离（有等号）
		----maxDistance = 4.5,       --技能释放最大距离（无等号）
		----angle = 140,             --技能释放角度
		----cd = 25,                 --技能cd，单位：秒
		------cd = 2,                --技能cd，单位：秒
		----durationFrame = 50,      --技能持续帧数
		----frame = 900,          	 --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		----priority = 1,            --优先级，数值越大优先级越高
		----weight = 1,              --随机权重
		----isAuto = true,           --是否自动释放
		----difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		----minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		----maxLifeRatio = 10000,      --技能释放最高生命万分比（无等号）
		--grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		--canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
		--specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		----},
		----前突刺（1111）
		{id = 900070004,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 8,         --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 15,               	 --技能cd，单位：秒
			durationFrame = 115,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
			specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
			ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		},
		----充能蓄力斩（111）
		{id = 900070005,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,         --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 10,               	 --技能cd，单位：秒
			durationFrame = 105,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,      --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
			specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
			ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		},
		----后撤蓄力斩
		--{id = 900070006,
		--minDistance = 0,         --技能释放最小距离（有等号）
		--maxDistance = 4,         --技能释放最大距离（无等号）
		--angle = 90,              --技能释放角度
		----cd = 1,                --技能cd，单位：秒
		--cd = 40,                 --技能cd，单位：秒
		--durationFrame = 105,     --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 2,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000,      --技能释放最高生命万分比（无等号）
		--grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		--canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
		--specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		--},
		----结印隐身（25cd）
		{id = 90007021,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 90,            	 --技能释放角度
			cd = 30,             	 --技能cd，单位：秒
			durationFrame = 92,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,      --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
			specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
			ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		},
		----结印隐身（25cd）
		--{id = 900070010,
		--minDistance = 0,         --技能释放最小距离（有等号）
		--maxDistance = 15,        --技能释放最大距离（无等号）
		--angle = 90,            	 --技能释放角度
		--cd = 30,             	 --技能cd，单位：秒
		----cd = 2,                --技能cd，单位：秒
		--durationFrame = 92,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000,      --技能释放最高生命万分比（无等号）
		--grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		--canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
		--specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		--},

		----结印隐身袭杀
		--{id = 900070008,
		--minDistance = 0,         --技能释放最小距离（有等号）
		--maxDistance = 3,        --技能释放最大距离（无等号）
		--angle = 360,             --技能释放角度
		--cd = 2,             	 --技能cd，单位：秒
		----cd = 90,               --技能cd，单位：秒
		--durationFrame = 41,     --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 2,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 4000,      --技能释放最高生命万分比（无等号）
		--grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		--canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
		--specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		--},
		--------跳劈跳反
		{id = 900070010,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 12,       --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 30,                 --技能cd，单位：秒
			durationFrame = 89,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,     --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,      --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
			specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
			ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		}
		------结印隐身袭杀落地
		--{id = 900070012,
		--minDistance = 0,         --技能释放最小距离（有等号）
		--maxDistance = 2,        --技能释放最大距离（无等号）
		--angle = 360,             --技能释放角度
		--cd = 2,             	 --技能cd，单位：秒
		----cd = 90,               --技能cd，单位：秒
		--durationFrame = 50,     --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 2,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 4000,      --技能释放最高生命万分比（无等号）
		--grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		--canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
		--specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		--},
		
	}
	
	--MonsterExitFight
	self.canExitFight = true		--能否脱战
	self.targetMaxRange = self.maxRange	--超过后会脱战
	self.ExitFightRange = 50		--脱战距离
	self.RebornRange = 200			--重生距离
	self.exitFightLimitTime = 20	--脱战时间

	--逻辑参数（仅记录，不可公开修改）
	--MonsterCastSkill
	self.commonSkillCdFrame = 0												--当前公共cd时间
	self.currentSkillList = {}                                              --当前技能列表(剔除不符合规则的技能)
	self.currentSkillId = 0				                                    --记录当前释放中技能，否则为0
	self.isAggressive = 0													--基于群组ai判断，是否有攻击性
	self.skillBeginState = 0												--用于记录技能是否已经初始化过了
	self.gradeNum = {					--技能的分级
		Perform = 0,	--暂定为表演类技能，如出生、警告、嘲讽等
		NormalSkill = 5,	--暂定为普通的战斗技能，如普攻、小技能等
		BigSkill = 10,	--暂定为关键技能，如大招、转阶段、跳反等，这个等级及以上会受群组ai公共冷却限制
	}
	
	--MonsterWander
	self.battleTargetPos =nil												--战斗目标位置
	self.initialShortRange = 0												--在wander逻辑里，用于记录初始的游荡近距离边界值
	self.initialLongRange = 0												--在wander逻辑里，用于记录游荡远距离边界值

	self.key=0              --分组讯号
	self.addLifeBar= true    --进战斗后血条显示

	--能否瘫倒
	self.canBreak = false  --怪物是否会瘫痪
	
	--怪物寻路开关
	self.pathFindKey = true
	
	--仅策划测试用，在释放技能逻辑里关闭掉之后，不会判断是否有技能可释放而前进
	self.CanCastSkill = false
	
	--碰撞移除强制打断计时参数
	self.startTime = nil
	self.limitTime = 2
	self.hitcount = 0
	self.police = nil

	--放技能语音
	self.AudioState = 0 --是不是第一次放技能
	self.AudioTime = 0 --语音CD
	self.LastAudio = 0
	
end

function FSMBehavior900070:LateInit()
	if BehaviorFunctions.GetEntityValue(self.me,"skillList") then
		self.initialSkillList=BehaviorFunctions.GetEntityValue(self.me,"skillList")
	end
end

function FSMBehavior900070:Update()
	
	--基于策划配置数据，怪物属于近战还是远程
	if BehaviorFunctions.GetMonsterAttackType(self.me) then
		self.attackRange = BehaviorFunctions.GetMonsterAttackType(self.me)
	else
		self.attackRange = 1
	end
	
	if self.bornPosition == nil then
		if BehaviorFunctions.GetEntityEcoId(self.me) then
			self.ecoId=BehaviorFunctions.GetEntityEcoId(self.me)
			self.bornPosition=BehaviorFunctions.GetEcoEntityBornPosition(self.ecoId)
		else
			local posx, posy, posz = BehaviorFunctions.GetPosition(self.me)
			self.bornPosition = Vec3.New(posx, posy, posz)               --出生点
		end
	end

	
	--判断是否有攻击性
	if BehaviorFunctions.HasEntitySign(self.me,10000035) then
		self.isAggressive = 1
		--BehaviorFunctions.DoMagic(self.me,self.me,900000025)
	else
		self.isAggressive = 0
	end
	
	--开放领域范围参数
	BehaviorFunctions.SetEntityValue(self.me,"monsterRangeRadius",self.monsterRangeRadius)

	--开放技能列表
	BehaviorFunctions.SetEntityValue(self.me,"skillList",self.initialSkillList)

	--用于重载台子上的怪物
	if self.bornPosition~=nil
		and self.ecoMe then
		if BehaviorFunctions.CheckEcoEntityGroup(self.me)==true then
			if self.bornPosition then
				if self.key ==0 then
					BehaviorFunctions.SetEntityValue(self.me,"bornPosition",self.bornPosition)
					BehaviorFunctions.SetEntityValue(self.me,"keyOpen",true)
					self.key=1
				end
			end
		end
	end

	--获取战斗目标
	if BehaviorFunctions.GetEntityValue(self.me,"battleTarget") then
		self.battleTarget = BehaviorFunctions.GetEntityValue(self.me,"battleTarget")
	else
		self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	end

	--获取战斗目标距离和坐标
	if BehaviorFunctions.CheckEntity(self.battleTarget) then
		self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget)
		self.battleTargetPos = BehaviorFunctions.GetPositionP(self.battleTarget)
		--角色受击检测
		if BehaviorFunctions.GetEntityState(self.battleTarget) == FightEnum.EntityState.Hit
			or BehaviorFunctions.GetEntityState(self.battleTarget) == FightEnum.EntityState.Stun then
			self.targetInHit = true
		else
			self.targetInHit = false
		end
	end
	
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	self.LifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.me,1001)
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.roleState = BehaviorFunctions.GetEntityState(self.battleTarget)
	
	if BehaviorFunctions.GetEntityValue(self.me,"haveWarn")~=nil then
		self.haveWarn=BehaviorFunctions.GetEntityValue(self.me,"haveWarn")
	end

	if BehaviorFunctions.GetEntityValue(self.me,"peaceState") ~= nil then
		self.peaceState = BehaviorFunctions.GetEntityValue(self.me,"peaceState")
	end

	if BehaviorFunctions.GetEntityValue(self.me,"actPerformance")~=nil then
		self.actPerformance=BehaviorFunctions.GetEntityValue(self.me,"actPerformance")
	end

	if BehaviorFunctions.GetEntityValue(self.me,"skillList")~=nil then
		--if BehaviorFunctions.GetEntityValue(self.me,"skillList") == "empty" then
		--self.currentSkillList={}
		--else
		self.currentSkillList=BehaviorFunctions.GetEntityValue(self.me,"skillList")
		--end
	end

	--怪物是否能够瘫痪
	if BehaviorFunctions.GetEntityValue(self.me,"canBreak")~=nil then
		self.canBreak = BehaviorFunctions.GetEntityValue(self.me,"canBreak")
	end

	if BehaviorFunctions.GetEntityValue(self.me,"haveRunAndHit") then
		self.haveRunAndHit = BehaviorFunctions.GetEntityValue(self.me,"haveRunAndHit")
	end

	if BehaviorFunctions.GetEntityValue(self.me,"ExitFightRange") then
		self.ExitFightRange = BehaviorFunctions.GetEntityValue(self.me,"ExitFightRange")
	end

	if BehaviorFunctions.GetEntityValue(self.me,"targetMaxRange") then
		self.targetMaxRange = BehaviorFunctions.GetEntityValue(self.me,"targetMaxRange")
		self.noWarnInFightRange = BehaviorFunctions.GetEntityValue(self.me,"targetMaxRange")
	end

	--怪物能否被暗杀
	if self.battleTarget and self.canBeAss == true and BehaviorFunctions.HasEntitySign(self.battleTarget,62001003) then
		BehaviorFunctions.DoMagic(1,self.me,900000055)
	else
		BehaviorFunctions.RemoveBuff(self.me,900000055)
	end
	
	--和出生点之间的距离
	self.bornDistance = BehaviorFunctions.GetDistanceFromPos(self.myPos,self.bornPosition)

	
	--怪物待机状态切换
	if self.inFight == true then
		--进入战斗后，idle状态下也用战斗待机的动作
		local entityState = BehaviorFunctions.GetEntityState(self.me)
		local None = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.None)
		local inFightIdle = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.FightIdle)
		local inIdle = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.LeisureIdle)
		local FTL = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.FightToLeisurely)
		local II = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.InjuredIdle)
	
		--if BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.LeisurelyIdle) then
		BehaviorFunctions.SetIdleType(self.me,FightEnum.EntityIdleType.FightIdle)
		--end
	elseif self.inFight == false then
		--退出战斗后，idle状态下动作恢复休闲待机
		if BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.FightIdle) then
			BehaviorFunctions.SetIdleType(self.me,FightEnum.EntityIdleType.LeisurelyIdle)
		end
	end
	
	--自定義邏輯
	
	self.player = BehaviorFunctions.GetCtrlEntity()

	if self.hitcount >= 3 then
		BehaviorFunctions.SetEntityValue(self.me,"battleTarget",self.police)
		--elseif self.hitcount >= 5 then
		--BehaviorFunctions.SetEntityValue(self.me,"battleTarget",self.player)
	end
	--隐身技能Start结束
	if BF.HasEntitySign(self.me,90007021) then
		BF.BreakSkill(self.me)
		BF.RemoveEntitySign(self.me,90007021)
		BF.CastSkillBySelfPosition(self.me,90007022)
	end
	--显示血条
	if BF.HasEntitySign(self.me,90007022) then
		BF.SetEntityLifeBarVisibleType(self.me,2)
	end

	--显隐血条\创建刀特效
	if BF.HasEntitySign(self.me,900070212) then
		BF.SetEntityLifeBarVisibleType(self.me,3)
		BF.RemoveEntitySign(self.me,900070212)
		BF.DoMagic(self.me,self.battleTarget,9000702101,1)
	end

	if BF.HasEntitySign(self.me,900070213) then
		BF.DoMagic(self.me,self.battleTarget,9000702102,1)
		BF.RemoveEntitySign(self.me,900070213)
	end
	
end

function FSMBehavior900070:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function FSMBehavior900070:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end


--检测暗杀目标移除
function FSMBehavior900070:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if entityInstanceId == self.me then
		if buffId == 900000055 or buffId == 900000053 then
			if self.battleTarget then
				BehaviorFunctions.RemoveBuff(self.me,1000046)
				BehaviorFunctions.HideAssassinLifeBarTip(self.battleTarget, self.me)
			end
		end
	end
end

function FSMBehavior900070:BeforeDie(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveBuff(self.me,900000053)
		BehaviorFunctions.RemoveBuff(self.me,900000055)
	end
end

function FSMBehavior900070:AddSkillSign(instanceId,sign)
	----后撤步横扫触发窗口
	--if instanceId == self.MonsterCommonParam.me and self.isActive == 0 and sign == 900700301 then
	--if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) < 4 then
	--self.isActive = 1
	----识别到技能窗口90007031&玩家距离符合
	----切换播放ATK006横斩
	--BF.BreakSkill(self.MonsterCommonParam.me)
	--BF.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,360,360,-2,includeX)
	--BF.CastSkillByTarget(self.MonsterCommonParam.me,900070006,self.MonsterCommonParam.battleTarget)
	----特殊處理：清除預備技能列表
	--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
	--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	--end
	--else
	--self.isActive = 0
	--end

	----后撤步前突刺触发窗口
	--if instanceId == self.MonsterCommonParam.me and self.isActive == 0 and sign == 900700302 then
	--if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) >= 4 then
	--self.isActive = 1
	----识别到技能窗口90007031&玩家距离符合
	----切换播放ATK006横斩
	--BF.BreakSkill(self.MonsterCommonParam.me)
	--BF.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,360,360,-2,includeX)
	--BF.CastSkillByTarget(self.MonsterCommonParam.me,900070004, self.MonsterCommonParam.battleTarget)
	----特殊處理：清除預備技能列表
	--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
	--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	--end
	--else
	--self.isActive = 0
	--end

	----玩家低血量时打断自身后撤步技能
	--if instanceId == self.MonsterCommonParam.me and sign == 900700303 then
	--if BF.GetEntityAttrValueRatio(self.MonsterCommonParam.battleTarget,1001) < 5000 then
	--BF.BreakSkill(self.MonsterCommonParam.me)
	--end
	--end

	--获取结印隐身时自身位置
	if instanceId == self.me and sign == 9007007 then
		local CastPos = BF.GetPositionP(self.me)
	end

	----下砸攻击衔接普通后撤步
	----检查是否满足条件：释放ATK008 & 自身存在 & 怪物距玩家间距<2 & ATK008技能切换标识已激活
	--if  instanceId == self.MonsterCommonParam.me and sign == 9007012 then
	--if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) < 4.5 then
	----移除当前技能并释放ATK003后闪避
	--BF.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	--BF.CastSkillBySelfPosition(self.MonsterCommonParam.me,900070011)
	----特殊處理：清除預備技能列表
	--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
	--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	--end
	--end
end

function FSMBehavior900070:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		local role = BehaviorFunctions.GetCtrlEntity()
		local pos = BehaviorFunctions.GetPositionP(role)
		--BehaviorFunctions.SetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime,pos)

		--第一次放技能播
		if self.AudioState == 0 then
			BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_04",true,FightEnum.SoundSignType.Language)--"密令已发！"
			self.AudioState = 1
			self.AudioTime = BF.GetFightFrame()
		else
			--放对应技能播对应语音，会判断角色是否在说话，是否间隔20秒
			--local T = BF.GetFightFrame()
			--if not BF.GetEntitySignSound(self.player,signType) then
			--if T >= self.AudioTime + 20*30 then
			--if skillId == 900070004 then
			--BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_03",true,FightEnum.SoundSignType.Language)
			--elseif skillId == 900070007 then
			--BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_02",true,FightEnum.SoundSignType.Language)
			--elseif skillId == 900070005 then
			--BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_01",true,FightEnum.SoundSignType.Language)
			--end
			--self.AudioTime = T
			--end
			--end
		end

	end


end

function FSMBehavior900070:OnLand(instanceId)
	if BF.HasEntitySign(self.me,90007022) then
		BF.BreakSkill(self.me)
		BF.CastSkillBySelfPosition(self.me,90007023)
	end
end