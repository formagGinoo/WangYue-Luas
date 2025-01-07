Behavior900120 = BaseClass("Behavior900120",EntityBehaviorBase)
--资源预加载
function Behavior900120.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900120.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end



function Behavior900120:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	
	--被暗杀动作
	self.beAssassin = 90012008
	self.backHited = 90012009
	
	self.MonsterCommonParam.canBeAss = true				  --可以被暗杀
	
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false      --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	      --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		          --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil              --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             	  --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3                --直接警告距离
	self.MonsterCommonParam.warnShortRange = 6                --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12               --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80              --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2                 --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 90012004            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 90012005         --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 90012006           --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30           --无警告状态时直接进战的距离
	self.MonsterCommonParam.curAlertnessValue = 0             --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100           --最大警戒值
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0              --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				  --技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				  --技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false        --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		--技能1：敲击
		{id = 90012001,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 6,           	       --技能cd，单位：秒
			durationFrame = 73,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--技能2：冲刺上挑
		{id = 90012002,
			minDistance = 4.5,         --技能释放最小距离（有等号）
			maxDistance = 7,       --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			durationFrame = 100,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		----技能3：突刺
		{id = 90012003,
			minDistance = 7.5,       --技能释放最小距离（有等号）
			maxDistance = 11,         --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 15,                 --技能cd，单位：秒
			durationFrame = 89,      --技能持续帧数
			frame = 0,             --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--技能4：近战上挑
		{id = 90012007,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 10,           	       --技能cd，单位：秒
			durationFrame = 87,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		}
		
		----嘲讽
		--{id = 90012006,
			--minDistance = 4,         --技能释放最小距离（有等号）
			--maxDistance = 8,        --技能释放最大距离（无等号）
			--angle = 30,              --技能释放角度
			--cd = 60,                 --技能cd，单位：秒
			--durationFrame = 91,      --技能持续帧数
			--frame = 600,             --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--}
	}
	
	self.MonsterCommonParam.endureBreakTime=10             --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2.5               --游荡近距离边界值（小于此距离往后走）
	self.MonsterCommonParam.longRange = 10                  --游荡远距离边界值（小于此距离前走或左右走）
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值（小于此距离跑）
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.667        --左右走持续时间
	self.MonsterCommonParam.switchDelayTime = 1.333         --前后走持续时间
	self.MonsterCommonParam.walkDazeTime = 1.333           --待机时间（配stand2时间）
	self.MonsterCommonParam.canRun = true                  --跑步开关
	
	self.MonsterCommonParam.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.minRange = 1                 --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.defaultSkillId = 90012001	   --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 50            --脱战距离（距离出生点）
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true            --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20        --脱战时间
	self.MonsterCommonParam.canNotChase = 50               --追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange    --脱战距离（距离锁定目标）
	self.MonsterCommonParam.monsterRangeRadius = 2.5							   --以自身为圆心的一个范围，其他怪物无法wander进来

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	self.mission = 0
	self.testValue = 0
	--属性参数
	self.ElementList={}
	

end
function Behavior900120:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900120:Update()
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
	self.fightFrame = BehaviorFunctions.GetFightFrame()
	
end


function Behavior900120:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end



function Behavior900120:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

function Behavior900120:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.MonsterCommonParam.me and skillId == 90012002 then
		self:SetSkillFrame(90012007)
	elseif instanceId == self.MonsterCommonParam.me and skillId == 90012007 then
		self:SetSkillFrame(90012002)
	end
end

--技能：近战上挑和技能：冲刺上挑共CD，一个技能用了，另一个技能cd增加70%自身cd时间
function Behavior900120:SetSkillFrame(skillId)	
	for k = 1, #self.MonsterCommonParam.currentSkillList do
		if self.MonsterCommonParam.currentSkillList[k].id == skillId then
			--修改frame值
			self.MonsterCommonParam.currentSkillList[k].frame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.currentSkillList[k].cd * 21
		end
	end
end
