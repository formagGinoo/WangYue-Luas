Behavior900080 = BaseClass("Behavior900080",EntityBehaviorBase)
--资源预加载
function Behavior900080.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900080.GetMagics()
	local generates = {}
	return generates
end

local BF = BehaviorFunctions

function Behavior900080:Init()
	self.MonsterCommonParam = BF.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BF.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = 900080009
	self.backHited = 900080062

	self.MonsterCommonParam.canBeAss = true							  --可以被暗杀

	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false              --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	              --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		                  --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil                      --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             	--是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 5          	--近身警告距离
	self.MonsterCommonParam.warnShortRange = 10          	--近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  40        	  	--远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80        	--远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2           	--警告延迟时间
	self.MonsterCommonParam.warnSkillId = 900080010         --警告技能Id
	--self.MonsterCommonParam.warnSitSkillId = 900080010    --坐下后起立警告技能Id
	--self.MonsterCommonParam.tauntSkillId = 900080010      --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        	--自如其名
	self.MonsterCommonParam.curAlertnessValue = 0
	self.MonsterCommonParam.maxAlertnessValue = 100
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           	--难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = true   	--技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		--气脉凝结
		{id = 900080001,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 12,                 --技能cd，单位：秒
			durationFrame = 130,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,     --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			specialState = 0
		},
		----气脉冲击
		{id = 900080002,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 6,         --技能释放最大距离（无等号）
			angle = 60,             --技能释放角度
			cd = 10,                 --技能cd，单位：秒
			durationFrame = 67,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,    	 --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			specialState = 0
		},
		------电充领域
		--{id = 900080003,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 6,       	 --技能释放最大距离（无等号）
			--angle = 150,             --技能释放角度
			--cd = 25,               --技能cd，单位：秒
			----cd = 2,               	 --技能cd，单位：秒
			--durationFrame = 90,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 5000,      --技能释放最高生命万分比（无等号）
			--specialState = 0
		--},
		--气脉炸弹
		{id = 900080004,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 60,             --技能释放角度
			cd = 15,                 --技能cd，单位：秒
			durationFrame = 85,    	 --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			specialState = 0
		}
	}
	--MonsterWander
	self.MonsterCommonParam.shortRange = 8                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 15                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.5                 --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 2.4         --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 2.4          --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1.5               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 900080002	   --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 25               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 50           --脱战距离
	self.MonsterCommonParam.RebornRange = 200             --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20       --脱战时间
	self.MonsterCommonParam.canNotChase = 40              --追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0          --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0            --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	self.mission = 0
	self.testValue = 0
end

function Behavior900080:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end

function Behavior900080:Update()
	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
	
	--开放参数
	BF.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	BF.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)

	--战斗核心激活特效
	if not BF.CheckIdleState(self.MonsterCommonParam.me,FightEnum.EntityIdleType.LeisurelyIdle)
		and not BF.HasBuffKind(self.MonsterCommonParam.me) then
		BF.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,90008002)
	end

end


-------------------------------ATK002击退玩家逻辑-------------------------------
--命中玩家触发受击后激活后退，获得安全输出距离
--function Behavior900080:BeforeDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt)
	--if attackInstanceId == self.MonsterCommonParam.me and hitInstanceId == self.MonsterCommonParam.battleTarget then
		--if BF.GetSkill(attackInstanceId) == 900080002 then
			--BF.AddDelayCallByFrame(30,self,self.TriggerATK004)
		--end
	--end
--end
--function Behavior900080:TriggerATK004()
	--BF.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,useBase,50,180,-2,includeX)
	--BF.CastSkillByTarget(self.MonsterCommonParam.me,900080004,self.MonsterCommonParam.battleTarget)
	------特殊處理：清除預備技能列表
	----self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
	----self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
--end


--------------------------------跳反预警------------------------------
--function Behavior900080:Warning(instance, targetInstance,sign,isEnd)
	----当子弹快打到角色身上时，出现跳反预警
	--if instance == self.MonsterCommonParam.me
		--and sign == 9000803
		--and BF.GetBuffCount(self.MonsterCommonParam.battleTarget,1000036) == 0
		--and BF.GetDistanceFromTarget(instance,targetInstance,false) <= 4.5  and isEnd == nil then
		--BF.AddBuff(self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.battleTarget,1000036)
	--end
--end


------------------------------死亡相关效果调用逻辑------------------------------
function Behavior900080:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BF.DoMagic(instanceId,instanceId,900000008)
		BF.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900080:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BF.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BF.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end