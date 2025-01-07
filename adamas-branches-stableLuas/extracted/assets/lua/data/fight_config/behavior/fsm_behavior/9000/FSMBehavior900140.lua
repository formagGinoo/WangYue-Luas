FSMBehavior900140 = BaseClass("FSMBehavior900140",FSMBehaviorBase)
--资源预加载
function FSMBehavior900140.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function FSMBehavior900140.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end

function FSMBehavior900140:Init()

	--被暗杀动作
	self.beAssassin = 90014009
	self.backHited = 90014062
	
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
	self.warnSkillId = 900140901            --警告技能Id
	self.warnSitSkillId = 90004007         --坐下后起立警告技能Id
	self.tauntSkillId = 90014005           --嘲讽技能
	self.noWarnInFightRange = 30       --havewarn ==false时 进战斗的距离
	
	self.hitEffectFrame = 0			--霸体受击特效计时用
	self.curAlertnessValue = 0        --初始警戒值
	self.maxAlertnessValue = 100      --最大警戒值（改这个值不能改变怪物的警戒条变化速度，需要改DelayTime）
	self.alertUIOffset = Vec3.New(0,0.7,0)     --警戒UI基于markcase的偏移值，默认偏移表现不佳时需要手动修改
	self.alertUIPoint = nil             --自定义警戒UI挂点，默认挂点markcase表现不佳时可以修改，例："Bip001 Head"
	
	self.canBeAss = true				--可否被暗杀

	--MonsterWander
	self.shortRange = 2				--游荡近距离边界值
	self.longRange = 3                 --游荡远距离边界值
	self.maxRange = 50                  --游荡超远距离边界值
	self.minRange = 2                   --极限近身距离，追杀模式最小追踪距离
	self.canLRWalk = true               --左右走开关
	self.LRWalkSwitchTime = 2.66		--左右走切换时间
	self.switchDelayTime = 2.66		--延迟切换时间(前后走)
	self.walkDazeTime = 1			--移动发呆时间
	self.canRun = true                  --跑步开关
	self.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.defaultSkillId = 900140001		--默认技能id，追杀模式使用
	self.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	self.isFly = false                  --是否飞行怪
	self.monsterRangeRadius = 2.5			--以自身为圆心的一个范围，其他怪物无法wander进来
	
	--MonsterCastSkill
	self.difficultyDegree = 0           --难度系数
	self.initialSkillCd = 0				--技能初始cd
	self.commonSkillCd = 1.5				--技能公共cd
	self.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.mySpecialState = nil           --特殊状态才能释放该技能
	self.attackRange = 1			  --怪物的攻击范围，1为近战，2为远程
	self.initialSkillList = {
		
		--打耳光
		{id = 900140001,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 7,                  --技能cd，单位：秒
			durationFrame = 72,      --技能持续帧数
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

		------近距离超人拳
		{id = 900140006,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 72,      --技能持续帧数
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


		--------超人拳
		{id = 900140002,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 9.5,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 13,                  --技能cd，单位：秒
			durationFrame = 85,      --技能持续帧数
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

		----------扔罐子
		{id = 900140003,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 8,        --技能释放最大距离（无等号）
			angle = 20,              --技能释放角度
			--20
			cd = 20,                  --技能cd，单位：秒
			durationFrame = 100,      --技能持续帧数
			frame = 60,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
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
	
	--自定义部分
	self.can = nil
	self.cantime = 0
	--技能用参数记录
	self.slapstate = 0
	self.hittime = 0
	self.backCD = 0
	
end

function FSMBehavior900140:LateInit()
	if BehaviorFunctions.GetEntityValue(self.me,"skillList") then
		self.initialSkillList=BehaviorFunctions.GetEntityValue(self.me,"skillList")
	end
end

function FSMBehavior900140:Update()
	
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
	
	
	--自定义部分
	--罐子计时
	self:cantimecount()
	self.battletargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.Me,self.battleTarget)
end

function FSMBehavior900140:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function FSMBehavior900140:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end


--检测暗杀目标移除
function FSMBehavior900140:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if entityInstanceId == self.me then
		if buffId == 900000055 or buffId == 900000053 then
			if self.battleTarget then
				BehaviorFunctions.RemoveBuff(self.me,1000046)
				BehaviorFunctions.HideAssassinLifeBarTip(self.battleTarget, self.me)
			end
		end
	end
end

function FSMBehavior900140:BeforeDie(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveBuff(self.me,900000053)
		BehaviorFunctions.RemoveBuff(self.me,900000055)
	end
end

function FSMBehavior900140:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
	if attackInstanceId == self.Me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 90014001001 then
		if self.battletargetDistance <= 3.5 then
			self.slapstate = 1
		end

	elseif attackInstanceId == self.Me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 90014001 then
		local p = BehaviorFunctions.GetPositionP(instanceId)
		--BehaviorFunctions.CreateEntityByPosition(9001400302, self.Me, "PlayerRestart", "Task_Main_53", 10503021, self.levelId, nil)
		--BehaviorFunctions.CreateEntityByEntity(self.Me,9001400302,p.x,p.y,p.z)
		self.canstate = 0
	elseif attackInstanceId == self.Me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 90014002 then
		local p = BehaviorFunctions.GetPositionP(instanceId)
		--BehaviorFunctions.CreateEntityByPosition(9001400302, self.Me, "PlayerRestart", "Task_Main_53", 10503021, self.levelId, nil)
		--BehaviorFunctions.CreateEntityByEntity(self.Me,9001400302,p.x,p.y,p.z)
		self.canstate = 0
	end

	if hitInstanceId == self.Me then
		self.hittime = self.hittime + 1

		local s = BehaviorFunctions.GetSkill(self.Me)
		local h = BehaviorFunctions.GetHitType(self.Me)
		-- 被狂揍之后，如果不是击倒击飞什么的，就往后撤
		if self.hittime >= 15 and s == 0 then
			if self.fightFrame - 12*30 >= self.backCD then
				if h ~= 5 and h ~= 6 and h ~= 7 and h ~= 71 and h ~= 72 and h ~= 73 and h ~= 74 and h ~= 75 and h ~= 76 and h ~= 20 then
					--BehaviorFunctions.AddBuff(self.Me,self.Me,900000045)
					BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.battleTarget)
					BehaviorFunctions.AddEntitySign(self.Me,90014000401,-1,false)
					self.hittime = 0
					self.backCD = self.fightFrame
				end
			end
		end
	end



end

function FSMBehavior900140:SkillFrameUpdate(instanceId,skillId,skillFrame)

	--打耳光帧标记
	if instanceId == self.Me and skillId == 900140001 and skillFrame == 35 and self.slapstate == 1 then
		local R = BehaviorFunctions.RandomSelect(1,2,3)
		--打耳光之后随机后撤，加实体标记
		if R == 1 then
			BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.battleTarget)
			BehaviorFunctions.AddEntitySign(self.Me,90014000402,-1,false)
		end
		self.slapstate = 0
	end

end

--判断放了技能
function FSMBehavior900140:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.Me and skillId == 900140006 then
		self:SetSkillFrame(900140002)
	elseif instanceId == self.Me and skillId == 900140002 then
		self:SetSkillFrame(900140006)
	end

end


function FSMBehavior900140:AddSkillSign(instanceId,sign)

	--打耳光帧标记
	if instanceId == self.Me and sign == 900140101 and self.slapstate == 1 then
		if self.slaptime ~= 0 then
			local R = BehaviorFunctions.RandomSelect(1,2,3)
			if R == 1 then
				BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.battleTarget)
				self.slapstate = 0
			end
		else
			BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.battleTarget)
			self.slapstate = 0
			self.slaptime = 1
		end
	end

	--扔罐子帧标记
	if instanceId == self.Me and sign == 900140302 then

		self.canstate = 1
		--self.x,self.y,self.z = BehaviorFunctions.GetEntityTransformPos(self.Me,"wuqi_000")
		--self.x,self.y,self.z = BehaviorFunctions.GetEntityTransformRot(self.me,"wuqi_000")
		--self.can = BehaviorFunctions.CreateEntityByEntity(self.Me,90014001,self.x,self.y,self.z)
	end

	if instanceId == self.Me and sign == 900140401 then

		if BehaviorFunctions.HasEntitySign(self.Me,90014000402) then
			--如果是扇巴掌之后的后撤，接嘲讽
			BehaviorFunctions.CastSkillByTarget(self.Me,900140005,self.battleTarget)
			BehaviorFunctions.RemoveEntitySign(self.Me,90014000402)

		elseif BehaviorFunctions.HasEntitySign(self.Me,90014000401) then
			--如果是挨揍的后撤，根据距离随机接技能
			if self.battletargetDistance <= 6 then
				BehaviorFunctions.CastSkillByTarget(self.Me,900140006,self.battleTarget)
				self:SetSkillFrame(900140006)
			else
				local R = BehaviorFunctions.RandomSelect(1,2)
				if R == 1 then
					BehaviorFunctions.CastSkillByTarget(self.Me,900140002,self.battleTarget)
					self:SetSkillFrame(900140002)
				else
					BehaviorFunctions.CastSkillByTarget(self.Me,900140003,self.battleTarget)
					self:SetSkillFrame(900140003)
				end
			end

		end
	end

	if instanceId == self.Me and sign == 900140301 then
		BehaviorFunctions.RemoveSkillEventActiveSign(self.Me,900140302)
		BehaviorFunctions.RemoveSkillEventActiveSign(self.Me,900140303)
		if self.battletargetDistance <= 5 then
			--BehaviorFunctions.AddEntitySign(self.Me,900140302,3,false)
			BehaviorFunctions.AddSkillEventActiveSign(self.Me,900140302)
		else
			--BehaviorFunctions.AddEntitySign(self.Me,900140303,3,false)
			BehaviorFunctions.AddSkillEventActiveSign(self.Me,900140303)
		end
	end


end

--根据id查找列表中对应id的技能的列表下标
function FSMBehavior900140:SerchSkillList(skillid,table)
	for i = 1,#table do
		if skillid == table[i].id then
			return i
		end
	end
end

--罐子倒计时判断
function FSMBehavior900140:cantimecount()
	--if self.fightFrame - 18 >= self.cantime and self.canstate == 1 and self.can then
	--local p = BehaviorFunctions.GetPositionP(self.can)
	--BehaviorFunctions.CreateEntityByEntity(self.Me, 9001400304 ,p.x,p.y,p.z)
	----BehaviorFunctions.RemoveEntity(self.can)
	--self.canstate = 0
	--self.can = nil
	--end
end


function FSMBehavior900140:KeyFrameAddEntity(instanceId,entityId)
	if entityId == 90014001 and BehaviorFunctions.GetSkill(self.Me) == 900140003 then
		self.cantime = self.fightFrame
		self.can = instanceId

		local t = BehaviorFunctions.CreateEntity(9001400301,self.Me)
		BehaviorFunctions.BindTransform(t,"Root",{x = 0, y =0, z = 0},self.can)
		local t1 = BehaviorFunctions.CreateEntity(9001400301,self.Me)
		BehaviorFunctions.BindTransform(t1,"Root",{x = 0, y =0, z = 0},self.can)

		--双点曲线
		local p = BehaviorFunctions.GetPositionP(self.battleTarget)

		local ctrlPos = {ZRate = 0.3,YRate = 0.5}
		--local selfEntity = BehaviorFunctions.fight.entityManager:GetEntity(self.MonsterCommonParam.battleTarget)
		--local PartName = "Root"
		BehaviorFunctions.SetEntityMoveCurveThrow(self.can,nil,ctrlPos,Vec3.New(p.x,p.y,p.z),22,nil)
		--function ()

		--BehaviorFunctions.CreateEntity(9001400306,self.Me,p.x,p.y,p.z)

		--end)
		--{Entity = selfEntity,PartName = PartName}
	end

	if entityId == 90014002 and BehaviorFunctions.GetSkill(self.Me) == 900140003 then
		local t = BehaviorFunctions.CreateEntity(9001400301,self.Me)
		BehaviorFunctions.BindTransform(t,"Root",{x = 0, y =0, z = 0},instanceId)

	end
end

function FSMBehavior900140:Dodge(attackInstanceId,hitInstanceId,limit)

end



function FSMBehavior900140:HitGround(attackInstanceId,instanceId,positionX, positionY, positionZ)

	if attackInstanceId == self.Me and instanceId == self.can then

		BehaviorFunctions.CreateEntity(9001400306,self.Me,positionX, positionY+0.45, positionZ)
		--BehaviorFunctions.DoMagic(self.Me,self.can,9001400302)
		--if self.can then
		--BehaviorFunctions.RemoveEntity(self.can)
		--end
	end
end


--修改技能frame值
function FSMBehavior900140:SetSkillFrame(skillId)
	--找到这个技能
	local i = self:SerchSkillList(skillId,self.initialSkillList)
	--修改frame值
	self.initialSkillList[i].frame = self.fightFrame + self.initialSkillList[i].cd*30
end