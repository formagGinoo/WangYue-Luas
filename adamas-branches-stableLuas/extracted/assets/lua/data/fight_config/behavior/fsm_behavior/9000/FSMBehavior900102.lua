FSMBehavior900102 = BaseClass("FSMBehavior900102",FSMBehaviorBase)
--资源预加载
function FSMBehavior900102.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function FSMBehavior900102.GetMagics()
	local generates = {}
	return generates
end

function FSMBehavior900102:Init()

	--被暗杀动作
	self.beAssassin = 90010207
	self.backHited = 90010208
	
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
	self.warnLimitRange = 6           --近身警告距离
	self.warnShortRange = 15           --近身疑问距离（无视角度）
	self.warnLongRange = 20            --远距离警告距离（结合VisionAngle）
	self.warnVisionAngle = 80          --远距离警告视角
	self.warnLimitHeight = 2          --极限警告高度
	self.warnDelayTime = 2            --警告延迟时间
	self.warnSkillId = 90010201            --警告技能Id
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
	self.shortRange = 1.3				--游荡近距离边界值
	self.longRange = 8                 --游荡远距离边界值
	self.maxRange = 50                  --游荡超远距离边界值
	self.minRange = 1.2                   --极限近身距离，追杀模式最小追踪距离
	self.canLRWalk = true               --左右走开关
	self.LRWalkSwitchTime = 1.333		--左右走切换时间
	self.switchDelayTime = 1.2		--延迟切换时间(前后走)
	self.walkDazeTime = 1			--移动发呆时间
	self.canRun = false                  --跑步开关
	self.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.defaultSkillId = 90010202		--默认技能id，追杀模式使用
	self.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	self.isFly = false                  --是否飞行怪
	self.monsterRangeRadius = 2.5			--以自身为圆心的一个范围，其他怪物无法wander进来
	
	--MonsterCastSkill
	self.difficultyDegree = 0           --难度系数
	self.initialSkillCd = 0				--技能初始cd
	self.commonSkillCd = 2				--技能公共cd
	self.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.mySpecialState = nil           --特殊状态才能释放该技能
	self.attackRange = 2			  --怪物的攻击范围，1为近战，2为远程
	self.initialSkillList = {
		--近战敲击后撤
		--attack001 =
		{id = 90010202,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 1.7,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 6,                  --技能cd，单位：秒
			durationFrame = 110,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,				 --分级系数，大于一定系数的技能释放后进入群组公共cd
			canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
			specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
			ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		},

		--远程蓄力法术
		--attack002 =
		{id = 90010203,
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 100,      --技能持续帧数
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

		--减伤法阵
		--attack003 =
		{id = 90010204,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 360,              --技能释放角度
			cd = 25,                  --技能cd，单位：秒
			durationFrame = 128,      --技能持续帧数
			frame = 150,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
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

		-- --复活法术
		-- {id = 90010204,
		-- minDistance = 0,         --技能释放最小距离（有等号）
		-- maxDistance = 10,        --技能释放最大距离（无等号）
		-- angle = 360,              --技能释放角度
		-- cd = 15,                  --技能cd，单位：秒
		-- durationFrame = 126,      --技能持续帧数
		-- frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		-- priority = 2,            --优先级，数值越大优先级越高
		-- weight = 1,              --随机权重
		-- isAuto = false,           --是否自动释放
		-- difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		-- minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		-- maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
		--grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		--canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
		--specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		-- },

		--闪现消失
		--attack004 =
		{id = 90010205,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 100,        --技能释放最大距离（无等号）
			angle = 360,              --技能释放角度
			cd = 1,                  --技能cd，单位：秒
			durationFrame = 9,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 0.5,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			ignoreCommonSkillCd = true,           --默认为false，配了true无视CommonCd
			grade = 0,				 --分级系数，大于一定系数的技能释放后进入群组公共cd
			canCastSkillWhenTargetInHit = false,	--目标受击状态下能否放技能（不配也不可放）
			specialState = nil,                    --默认不配，配了的话技能的specialState和mySpecialState相等才会释放
			ignoreCommonSkillCd = true           --默认为false，配了true无视CommonCd
		},

		----闪现出现
		--{id = 90010206,
		--minDistance = 1,         --技能释放最小距离（有等号）
		--maxDistance = 100,        --技能释放最大距离（无等号）
		--angle = 30,              --技能释放角度
		--cd = 1,                  --技能cd，单位：秒
		--durationFrame = 38,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
		--grade = 0,					--分级系数，大于一定系数的技能释放后进入群组公共cd
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

	--SpecialSkill
	self.dieMonsterTable = {}
	self.canReviveTable = {}
	self.reviveMonsterTable = {}
	self.soulTable =
	{
		soulEntityId = 9001020305,
		soulInEntityId = 9001020304,
		soulEndEntityId01 = 9001020306,   --溢散
		soulEndEntityId02 = 9001020307,   --复活
	}
	self.returnNum = 0
	
end

function FSMBehavior900102:LateInit()
	if BehaviorFunctions.GetEntityValue(self.me,"skillList") then
		self.initialSkillList=BehaviorFunctions.GetEntityValue(self.me,"skillList")
	end
end

function FSMBehavior900102:Update()
	
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
	
	--个性化定制
	self:BasicData()
	self:SpecialSkill()
	
end

function FSMBehavior900102:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function FSMBehavior900102:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end


--检测暗杀目标移除
function FSMBehavior900102:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if entityInstanceId == self.me then
		if buffId == 900000055 or buffId == 900000053 then
			if self.battleTarget then
				BehaviorFunctions.RemoveBuff(self.me,1000046)
				BehaviorFunctions.HideAssassinLifeBarTip(self.battleTarget, self.me)
			end
		end
	end
end

function FSMBehavior900102:BeforeDie(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveBuff(self.me,900000053)
		BehaviorFunctions.RemoveBuff(self.me,900000055)
	end
end

function FSMBehavior900102:BasicData()
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.distance = BehaviorFunctions.GetDistanceFromPos(self.myPos, self.rolePos)
end

function FSMBehavior900102:SpecialSkill()
	--闪现技能逻辑
	--根据所在位置不同，设置不同cd
	if self.distance > 15 then
		self.initialSkillList[4].cd = 1    --赶路很快
	elseif self.distance <= 15 then
		self.initialSkillList[4].cd = 6
	end
end

function FSMBehavior900102:GetFlashPos(instanceId)
	--判断要闪到哪(还要加上判断位置是否合法)
	local angle = BehaviorFunctions.GetEntityAngle(instanceId, self.role)
	local appearPos = nil
	local flashDistance = 6
	if self.returnNum < 3 then
		if self.distance > 15 then
			--往玩家方向闪
			appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, flashDistance, angle)
		elseif 5 < self.distance and self.distance <= 15 then
			local movementType = math.random(1, 2)
			--两种闪法，一种往12m线上闪
			if movementType == 1 then
				if self.distance < 12 then
					appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, -flashDistance, angle)
				else
					appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, flashDistance, angle)
				end
				--一种保持距离半径不变，在扇形两端点上左右闪
			else
				-- 计算cos(angle)的值
				local cosValue = (2 * self.distance^2 - flashDistance^2) / (2 * self.distance^2)
				-- 将cos(angle)的值转化为angle的值，并将其转化为角度制
				local rad = math.acos(cosValue)
				angle = math.deg(rad)
				appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, flashDistance, angle)
			end
			--太近了往后闪
		elseif self.distance <= 5 then
			appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, -flashDistance, angle)
		end
	else
		appearPos = BehaviorFunctions.GetRandomNavRationalPoint(instanceId, 4, 8)
	end
--暂时删去危险判断
--if appearPos then
--local isPosSave = nil
----local isCollide = BehaviorFunctions.CheckEntityCollideAtPosition(900102, appearPos.x, appearPos.y+0.5, appearPos.z, {instanceId}, instanceId)	--检查闪的点是否合法
----BehaviorFunctions.DoCollideCheckAtPosition(appearPos.x, appearPos.y, appearPos.z,sizeX,sizeY,sizeZ,ignoreList)
--local y,layer = BehaviorFunctions.CheckPosHeight(appearPos)
--if y ~= nil
--and layer ~= nil
--and y > 3
--or BehaviorFunctions.CheckObstaclesBetweenPos(appearPos,self.myPos,false)   --要传送的点和现在的点之间有障碍
--or layer == FightEnum.Layer.Water
--or layer == FightEnum.Layer.Marsh then
----or isCollide == false then
--isPosSave = false
--else
--isPosSave = true
--end
--end
	local isPosSave = true
	if isPosSave then
		BehaviorFunctions.DoSetPositionP(instanceId, appearPos)
		if BehaviorFunctions.CanCastSkill(instanceId) then
			BehaviorFunctions.CastSkillByTarget(instanceId, 90010206, self.role)
		end
	--else
	--self.returnNum = self.returnNum + 1
	--return self:GetFlashPos(instanceId)
	end
end

function FSMBehavior900102:FinishSkill(instanceId,skillId,skillType)
	--闪现技能放完之后
	if skillId  == 90010205 then
		self:GetFlashPos(instanceId)
	end
end