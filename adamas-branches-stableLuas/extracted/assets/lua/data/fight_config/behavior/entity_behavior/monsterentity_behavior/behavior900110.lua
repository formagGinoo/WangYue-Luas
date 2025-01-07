Behavior900110 = BaseClass("Behavior900110",EntityBehaviorBase)
--资源预加载
function Behavior900110.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900110.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end

function Behavior900110:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = 90004009
	self.backHited = 90004062
	
	self.MonsterCommonParam.canBeAss = false	--可以被暗杀
	
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false	--出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil				--出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2				--出生发呆时间

	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil	--演出技能Id
	self.MonsterCommonParam.actKey = true		--表演开关

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 6           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12          --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80         --远距离警告视角
	self.MonsterCommonParam.warnLimitHeight = 6          --极限警告高度
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 900110004      --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 900110004   --坐下后警告技能Id
	self.MonsterCommonParam.tauntSkillId = 900110004     --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30		--进战斗的距离
	self.MonsterCommonParam.hitEffectFrame = 0			--霸体受击特效计时用
	self.MonsterCommonParam.curAlertnessValue = 0        --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100      --最大警戒值
	self.MonsterCommonParam.alertUIOffset = Vec3.New(0,0.7,0) 		--警戒UI基于markcase的偏移值，默认偏移表现不佳时需要手动修改
	self.MonsterCommonParam.alertUIPoint = nil             --自定义警戒UI挂点，默认挂点markcase表现不佳时可以修改，例："Bip001 Head"

	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 2.5				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.MonsterCommonParam.mySpecialState = nil           --特殊状态才能释放该技能
	self.MonsterCommonParam.initialSkillList = {
		--喷射火线
		{id = 900110001,
		minDistance = 0,         --技能释放最小距离（有等号）
		maxDistance = 10,         --技能释放最大距离（无等号）
		angle = 10,             --技能释放角度
		cd = 6,                  --技能cd，单位：秒
		durationFrame = 60,      --技能持续帧数
		frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		priority = 1,            --优先级，数值越大优先级越高
		weight = 1,              --随机权重
		isAuto = true,           --是否自动释放
		difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		maxLifeRatio = 10000,    --技能释放最高生命万分比（无等号）
		grade = 5				 --分级系数，高于一定系数的技能释放后进入群组公共cd
		},
		--旋转撞击
		{id = 900110002,
		minDistance = 3,         --技能释放最小距离（有等号）
		maxDistance = 6,         --技能释放最大距离（无等号）
		angle = 10,              --技能释放角度
		cd = 13,                 --技能cd，单位：秒
		durationFrame = 125,     --技能持续帧数
		frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		priority = 2,            --优先级，数值越大优先级越高
		weight = 1,              --随机权重
		isAuto = true,           --是否自动释放
		difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		maxLifeRatio = 10000,    --技能释放最高生命万分比（无等号）
		grade = 5				 --分级系数，高于一定系数的技能释放后进入群组公共cd
		},
		--豪火球之术
		{id = 900110003,
		minDistance = 3,         --技能释放最小距离（有等号）
		maxDistance = 9,         --技能释放最大距离（无等号）
		angle = 10,              --技能释放角度
		cd = 14,                 --技能cd，单位：秒
		durationFrame = 134,     --技能持续帧数
		frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		priority = 1,            --优先级，数值越大优先级越高
		weight = 1,              --随机权重
		isAuto = true,           --是否自动释放
		difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		maxLifeRatio = 10000,    --技能释放最高生命万分比（无等号）
		grade = 5				 --分级系数，高于一定系数的技能释放后进入群组公共cd
		},
		--后撤
		{id = 900110005,
		minDistance = 0,         --技能释放最小距离（有等号）
		maxDistance = 5,         --技能释放最大距离（无等号）
		angle = 10,              --技能释放角度
		cd = 15,                 --技能cd，单位：秒
		durationFrame = 58,     --技能持续帧数
		frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		priority = 1,            --优先级，数值越大优先级越高
		weight = 1,              --随机权重
		isAuto = true,           --是否自动释放
		difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		maxLifeRatio = 10000,    --技能释放最高生命万分比（无等号）
		grade = 0				 --分级系数，高于一定系数的技能释放后进入群组公共cd
		},
	}
	
	
	
	
	self.MonsterCommonParam.endureBreakTime=10		--霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 3			--游荡近距离边界值
	self.MonsterCommonParam.longRange = 6			--游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50			--游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.2			--极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canWalkBack = true		--能否后退
	self.MonsterCommonParam.canLRWalk = true		--左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 2.8	--左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.4	--延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1		--移动发呆时间
	self.MonsterCommonParam.canRun = true			--跑步开关
	self.MonsterCommonParam.haveRunAndHit = false	--是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 90004006	--默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 5			--视野范围，不在视野范围内会进行转向
	self.MonsterCommonParam.isFly = true			--是否飞行怪
	--MonsterExitFight
	self.MonsterCommonParam.canExitFight = true		--能否脱战
	self.MonsterCommonParam.targetMaxRange = 0		--超过后会脱战
	self.MonsterCommonParam.ExitFightRange = 50		--脱战距离
	self.MonsterCommonParam.RebornRange = 200		--重生距离
	self.MonsterCommonParam.exitFightLimitTime = 20	--脱战时间
	self.MonsterCommonParam.canNotChase = 50		--追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0	--执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0		--执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	self.mission = 0
	self.testValue = 0
	--属性参数
	self.ElementList={}
	

end
function Behavior900110:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900110:Update()
	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
	--开放参数
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
		--BehaviorFunctions.PlayAnimation(self.MonsterCommonParam.me,"Sit")
	--end
end


function Behavior900110:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end



function Behavior900110:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

--function Behavior900110:EnterElementState(atkInstanceId,instanceId,element)
	--if instanceId==self.MonsterCommonParam.me 
		--and element==FightEnum.ElementType.Fire then
		--if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Skill) then
			--BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
		--end
		--BehaviorFunctions.CastSkillBySelfPosition(self.MonsterCommonParam.me,90004011)
	--end
	
--end