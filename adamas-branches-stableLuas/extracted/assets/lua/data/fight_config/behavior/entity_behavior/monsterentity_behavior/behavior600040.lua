Behavior600040 = BaseClass("Behavior600040",EntityBehaviorBase)
--资源预加载
function Behavior600040.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600040.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end



function Behavior600040:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)

	--开放参数
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 0.1		                                        --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil                                                   --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 6           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12           --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80          --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 60004004            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 60004007            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 60004005            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		----敲击
		--{id = 60004001,
		--minDistance = 1,         --技能释放最小距离（有等号）
		--maxDistance = 2.4,        --技能释放最大距离（无等号）
		--angle = 30,              --技能释放角度
		--cd = 8,                  --技能cd，单位：秒
		--durationFrame = 72,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},
		----助跑敲击
		--{id = 60004002,
		--minDistance = 3,         --技能释放最小距离（有等号）
		--maxDistance = 4,        --技能释放最大距离（无等号）
		--angle = 30,              --技能释放角度
		--cd = 10,                  --技能cd，单位：秒
		--durationFrame = 94,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},
		------爪击
		--{id = 60004003,
		--minDistance = 1,         --技能释放最小距离（有等号）
		--maxDistance = 2.4,        --技能释放最大距离（无等号）
		--angle = 30,              --技能释放角度
		--cd = 8,                  --技能cd，单位：秒
		--durationFrame = 70,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},
		
		--敲击
		{id = 60004014,
			minDistance = 0.5,         --技能释放最小距离（有等号）
			maxDistance = 2.7,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 71,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		
		--助跑敲击
		{id = 60004017,
			minDistance = 3,         --技能释放最小距离（有等号）
			maxDistance = 4.5,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			durationFrame = 106,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		
		--爪击
		{id = 60004016,
			minDistance = 0.5,         --技能释放最小距离（有等号）
			maxDistance = 2.7,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 68,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		
		--吼叫
		{id = 60004005,
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 50,                  --技能cd，单位：秒
			durationFrame = 65,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--敲棍警告
		{id = 60004006,
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 50,                  --技能cd，单位：秒
			durationFrame = 65,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		}
		
		
		
		
		
	}
	
	self.MonsterCommonParam.endureBreakTime=10           --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2.3                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 5                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.2                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.92        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 0.97         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 60004006		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 50           --脱战距离
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20       --脱战时间
	self.MonsterCommonParam.canNotChase = 50              --追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	self.mission = 0
	--属性参数
	self.ElementList={}
	self.hitEffectFrame = 0

end
function Behavior600040:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior600040:Update()
	self.MonsterCommonParam:Update()
	--self.MonsterCommonBehavior.MonsterBorn:Update()
	--self.MonsterCommonBehavior.MonsterPeace:Update()
	--self.MonsterCommonBehavior.MonsterWarn:Update()
	--self.MonsterCommonBehavior.MonsterExitFight:Update()
	--self.MonsterCommonBehavior.MonsterWander:Update()
	--self.MonsterCommonBehavior.MonsterCastSkill:Update()
	
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
		--BehaviorFunctions.PlayAnimation(self.MonsterCommonParam.me,"Sit")
	--end
	--if self.MonsterCommonParam.battleTargetDistance < 100 then
		--if BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,120) then
			----BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000040)
			--BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000053)
			--BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,1000046)
		--else
			--BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000053)
		--end
	--end
	

	----临时霸体逻辑
	--if BehaviorFunctions.GetBuffCount(self.MonsterCommonParam.me, 900000034) == 0 then
		--BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000034)
	--end
	--临时被暗杀动作检测
	--if BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.me,62001101) then
		--BehaviorFunctions.CastSkillBySelfPosition(self.MonsterCommonParam.me,60004009)
		--BehaviorFunctions.RemoveEntitySign(self.MonsterCommonParam.me,62001101)
	--end
end







--function Behavior600040:EnterElementState(atkInstanceId,instanceId,element)
	--if instanceId==self.MonsterCommonParam.me 
		--and element==FightEnum.ElementType.Fire then
		--if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Skill) then
			--BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
		--end
		--BehaviorFunctions.CastSkillBySelfPosition(self.MonsterCommonParam.me,60004011)
	--end
	
--end