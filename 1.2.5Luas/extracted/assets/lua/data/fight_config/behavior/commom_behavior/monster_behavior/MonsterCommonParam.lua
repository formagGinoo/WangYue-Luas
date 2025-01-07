MonsterCommonParam = BaseClass("MonsterCommonParam",EntityBehaviorBase)

--通用参数
function MonsterCommonParam:Init()
	self.inPeace = true                                                     --是否在非战斗状态
	self.inFight = false                                                    --是否在战斗状态                                         
	self.me = self.instanceId							                    --自身
	self.ecoMe = self.sInstanceId                                           --ecoid名称
	self.battleTarget = 0								                    --战斗目标
	self.myFrame = 0								                      	--自身帧数
	self.battleTargetDistance = 0		                                    --战斗目标与自身的距离
	self.myState = 0					                                    --自身状态
	self.LifeRatio = 0                                                      --生命值比率
	self.targetInHit = false                                                --目标受击
	self.inAlert = false													--是否在警戒状态
	
	--开放参数
	--MonsterBorn
	self.ecoId=nil
	self.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.initialDazeTime = 0		                                        --出生发呆时间
	--MonsterPeace
	self.actSkillId = nil                                                   --演出技能Id
	self.InitialActEnum = {           --怪物表演动画分类，在警告状态的时候会用到
		Sit=1,
		Lay=2
		}
	self.actKey = true                 --表演开关
	--MonsterWarn
	self.haveWarn = false             --是否有警告状态
	self.warnLimitRange = 0           --近身警告距离
	self.warnShortRange = 0           --近身疑问距离（无视角度）
	self.warnLongRange = 0            --远距离警告距离（结合VisionAngle）
	self.warnVisionAngle = 0          --远距离警告视角
	self.warnLimitHeight = 2          --极限警告高度
	self.warnDelayTime = 0            --警告延迟时间
	self.warnSkillId = nil            --警告技能Id
	self.warnSitSkillId=nil           --坐下后警告技能Id
	self.tauntSkillId=nil             --嘲讽技能
	self.noWarnInFightRange = 0       --havewarn ==false时 进战斗的距离
	self.warnValue = 0
	self.inFightValue = 0
	self.soundLimitRange = 3		--听觉极限近身距离
	self.soundShortRange = 5		--听觉近区
	self.soundLongRange = 8			--听觉远区
	self.soundReduce = 3			--当玩家不移动时，每帧减少的听觉警戒值
	self.AlertValue = 240			--听觉阈值
	self.fightValue = 120			--视觉阈值
	self.hitEffectFrame = 0			--霸体受击特效计时用
	
	self.canBeAss = false				--可否被暗杀
	
	
	--MonsterCastSkill
	self.difficultyDegree = 0           --难度系数
	self.initialSkillCd = 0				--技能初始cd
	self.commonSkillCd = 0				--技能公共cd
	self.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.mySpecialState = nil           --特殊状态才能释放该技能
	self.initialSkillList = {
		--模板
		--{id = 92001001,
		--minDistance = 0,                      --技能释放最小距离（有等号）
		--maxDistance = 3.5,                    --技能释放最大距离（无等号）
		--angle = 120,                          --技能释放角度
		--cd = 3,                               --技能cd，单位：秒
		--durationFrame = 35,                   --技能持续帧数
		--frame = 0,                            --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,                         --优先级，数值越大优先级越高
		--weight = 0,                           --随机权重
		--isAuto = true,                        --是否自动释放
		--difficultyDegree = 0,                 --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,                     --技能释放最低生命万分比（无等号）
		--maxLifeRatio = 10000                  --技能释放最高生命万分比（有等号）
		--canCastSkillWhenTargetInHit = false	--目标受击状态下能否放技能（不配也不可放）
		--specialLogic = true                   --默认不配，配了的话为true才会放
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		}
	--MonsterWander
	self.shortRange = 4                 --游荡近距离边界值
	self.longRange = 10                 --游荡远距离边界值
	self.maxRange = 15                  --游荡超远距离边界值
	self.minRange = 2                   --极限近身距离，追杀模式最小追踪距离
	self.canWalkBack = true             --能否后退
	self.canLRWalk = true               --左右走开关
	self.LRWalkSwitchTime = 1.6         --左右走切换时间
	self.switchDelayTime = 1.6          --延迟切换时间(前后走)
	self.walkDazeTime = 1               --移动发呆时间
	self.canRun = true                  --跑步开关
	self.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.defaultSkillId = 0		        --默认技能id，追杀模式使用
	self.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.canExitFight = false         --能否脱战
	self.targetMaxRange = 0           --超过后会脱战
	self.ExitFightRange = 0           --脱战距离
	self.RebornRange = 0              --重生距离
	self.exitFightLimitTime = 0       --脱战时间
	self.canNotChase = 0              --追不上玩家的距离
	
	--逻辑参数
	--MonsterBorn
	self.inInitial = false                                                  --是否在初始化
	self.initialState = 0                                                   --初始化进度
	self.InitialStateEnum = {                                               --初始化进度枚举
		Default = 0,
		Initial = 1,
		Done = 2,
		Special = 99,
	}
	self.dazeFrame = 0
	--MonsterPeace
	self.PeaceStateEnum = {            --非战斗状态枚举
		Default = 0,
		Patrol = 1,
		Act = 2,
	}
	--MonsterMercenaryChase
	self.inMercenaryChase = false
		
	--MonsterWarn
	self.warnState = 0
	self.warnStateEnum = {            --警告状态枚举
		Default = 0,
		GetReadyToWarn = 1,
		Warning = 2,
		WarnDone = 3,
		Alert = 4
	}
	--MonsterCastSkill
	self.commonSkillCdFrame = 0
	self.skillState = 0	                                                    --技能状态
	self.SkillStateEnum = {                                                 --技能状态枚举
		Default = 0,
		Initial = 1,
		PrepareSkill = 2,
		HaveSkill = 3,
		Ready = 4,
		CastingSkill = 5,
		InCommonCd = 6
	}
	self.currentSkillList = {}                                              --当前技能列表(剔除不符合规则的技能)
	self.skillIsAuto = false                                                --是否自动放技能
	self.currentSkillId = 0				                                    --记录当前释放中技能，否则为0
	--MonsterWander
	self.moveState = 0                                                      --移动状态
	self.MoveStateEnum = {                                                  --移动状态枚举
		Default = 0,--默认
		Wander = 1,--游荡
		WalkForward = 2,--远距离前走
		RunForward = 3,--远距离前跑
		WalkBack = 4,--近距离后退
		RunAndHit = 5,--超远距离跑打
	}
	self.cannotWander = false
	self.battleTargetPos =nil
	
	--MonsterExitFight
	self.exitFightState = 0
	self.ExitFightStateEnum = {
		Default = 0,
		Exiting = 1,
	}
	
	
	--分组参数
	--self.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.groupSkillSign = nil    
	self.key=0              --分组讯号
	self.addLifeBar= true    --进战斗后血条显示
	self.lifeBarDistance = nil  --血条显示距离
	
	
	--能否瘫倒
	self.canBreak = false  --怪物是否会瘫痪
	
	--怪物寻路开关
	self.pathFindKey = true
	
	
end

function MonsterCommonParam:LateInit()
	if BehaviorFunctions.GetEntityValue(self.me,"skillList") then
	self.initialSkillList=BehaviorFunctions.GetEntityValue(self.me,"skillList")
	end

	
end





function MonsterCommonParam:Update()
	if self.bornPosition == nil then
		if BehaviorFunctions.GetEntityEcoId(self.me) then
			self.ecoId=BehaviorFunctions.GetEntityEcoId(self.me)
			self.bornPosition=BehaviorFunctions.GetEcoEntityBornPosition(self.ecoId)
		else
			local posx, posy, posz = BehaviorFunctions.GetPosition(self.me)
			self.bornPosition = Vec3.New(posx, posy, posz)               --出生点
		end
	end
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
	
	--if BehaviorFunctions.GetEntityValue(self.me,"skillList") then
		--self.initialSkillList=BehaviorFunctions.GetEntityValue(self.me,"skillList")
	--end
	--注释注释注释
	if BehaviorFunctions.GetEntityValue(self.me,"battleTarget") then
		self.battleTarget = BehaviorFunctions.GetEntityValue(self.me,"battleTarget")
	else
		self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	end
	self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget)
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	self.LifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.me,1001)
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.battleTargetPos = BehaviorFunctions.GetPositionP(self.battleTarget)
	
	--角色受击检测
	if BehaviorFunctions.GetEntityState(self.battleTarget) == FightEnum.EntityState.Hit
		or BehaviorFunctions.GetEntityState(self.battleTarget) == FightEnum.EntityState.Stun then
		self.targetInHit = true
	else
		self.targetInHit = false	
	end
	
	--发呆时间初始化
	if self.dazeFrame == 0 and self.initialDazeTime ~= 0 then
		self.dazeFrame = self.myFrame + self.initialDazeTime * 30
	end
	
	
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
	end

	--怪物能否被暗杀
	if self.battleTarget and self.canBeAss == true and BehaviorFunctions.HasEntitySign(self.battleTarget,62001003) then
		BehaviorFunctions.DoMagic(self.me,self.me,900000055)
	else
		BehaviorFunctions.RemoveBuff(self.me,900000055)
	end
	
	--怪物待机状态切换
	if self.inFight == true then
		--进入战斗后，idle状态下也用战斗待机的动作
		local entityState = BehaviorFunctions.GetEntityState(self.me)
		local None = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.None)
		local inFightIdle = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.FightIdle)
		local inIdle = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.LeisureIdle)
		local FTL = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.FightToLeisurely)
		local II = BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.InjuredIdle)

		if BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.LeisurelyIdle) then
			BehaviorFunctions.SetIdleType(self.me,FightEnum.EntityIdleType.FightIdle)
		end
	elseif self.inFight == false then
		--退出战斗后，idle状态下动作恢复休闲待机
		if BehaviorFunctions.CheckIdleState(self.me,FightEnum.EntityIdleType.FightIdle) then
			BehaviorFunctions.SetIdleType(self.me,FightEnum.EntityIdleType.LeisurelyIdle)
		end		
	end	
	
end


--检测暗杀目标移除
function MonsterCommonParam:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if entityInstanceId == self.me then
		if buffId == 900000055 or buffId == 900000053 then
			if self.battleTarget then
				BehaviorFunctions.RemoveBuff(self.me,1000046)
				BehaviorFunctions.HideAssassinLifeBarTip(self.battleTarget, self.me)
			end
		end
	end
end


function MonsterCommonParam:BeforeDie(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveBuff(self.me,900000053)
		BehaviorFunctions.RemoveBuff(self.me,900000055)
	end
end