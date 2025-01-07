Behavior900020 = BaseClass("Behavior900020",EntityBehaviorBase)
--资源预加载
function Behavior900020.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function Behavior900020.GetMagics()
	local generates = {900000008,900000009}
	return generates
end

function Behavior900020:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)

	--被暗杀动作
	self.beAssassin = 900020009
	self.backHited = 900020062

	self.MonsterCommonParam.canBeAss = true				--可以被暗杀

	--怪物出生
	self.MonsterCommonParam.haveBornSkill = false           --是否有出生技能
	self.MonsterCommonParam.haveSpecialBornLogic = false    --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil      		   --出生技能id
	self.MonsterCommonParam.initialDazeTime = 2		       --出生发呆时间

	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true              --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3.5           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 6           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12          --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80         --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId =  900020901        --警告技能Id
	self.MonsterCommonParam.tauntSkillId = 900020005         --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名

	--技能参数
	self.MonsterCommonParam.difficultyDegree = 0            --难度系数
	self.MonsterCommonParam.initialSkillCd = 0.2			 --技能初始cd
	self.MonsterCommonParam.commonSkillCd = 0.5			   --技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false      --技能是否有生命值区间判断

	--技能列表(id,默认释放距离,最小释放距离，角度,cd秒数,技能动作持续帧数，计时用帧数,优先级,是否自动释放,难度系数)
	self.MonsterCommonParam.initialSkillList = {
		--蜥蜴通用技能
		--技能1 近距离普攻
		{id = 900020001,
			minDistance = 0,
			maxDistance = 3,
			angle = 70,
			cd = 8,
			durationFrame = 90,
			frame = 0,
			priority = 1,
			weight = 1,              --随机权重
			isAuto = true,
			difficultyDegree = 0,
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},

		--技能2 中距离突进2连
		{id = 900020002,
			minDistance = 3,
			maxDistance = 8,
			angle = 70,
			cd = 12,
			durationFrame = 90,
			frame = 0,
			priority = 2,
			weight = 1,              --随机权重
			isAuto = true,
			difficultyDegree = 0,
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		
		--技能3 后跳,6m
		--{id = 900020003,
			--minDistance = 0,
			--maxDistance = 4,
			--angle = 80,
			--cd = 6,
			--durationFrame = 0,
			--frame = 0,
			--priority = 10,
			--isAuto = false,
			--difficultyDegree = 0},

		--蜥蜴专属技能
		--技能5 物理蜥蜴石头砸地
		--{id = 900020011,
			--minDistance = 4,
			--maxDistance = 10,
			--angle = 120,
			--cd = 18,
			--durationFrame = 173,
			--frame = 0,
			--priority = 11,
			--isAuto = true,
			--difficultyDegree = 0},

		--技能6 物理蜥蜴扔石头
		{id = 900020012,
			minDistance = 5,
			maxDistance = 10,
			angle = 120,
			cd = 15,
			durationFrame = 160,
			frame = 0,
			priority = 12,
			isAuto = true,
			difficultyDegree = 0},
		
		--蜥蜴出生表演
		--地下待机
		{id = 900020021,
			distance = 9999,
			angle = 90,
			cd = 5,
			durationFrame = 0,
			frame = 0,
			priority = 0,
			isAuto = false,
			difficultyDegree = 0},

		--破土而出
		{id = 900020022,
			distance = 3,
			angle = 90,
			cd = 5,
			durationFrame = 0,
			frame = 0,
			priority = 0,
			isAuto = false,
			difficultyDegree = 0},
	}

	--MonsterWander
	self.MonsterCommonParam.shortRange = 3                  --游荡近距离边界值
	self.MonsterCommonParam.longRange = 6                  --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2                 --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.6           --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.6         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 0             --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false          --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 900020001		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 25               --视野范围，不在视野范围内会进行转向

	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 50           --脱战距离
	self.MonsterCommonParam.RebornRange = 200             --重生距离
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
	self.testValue = 0

	--自己用的参数
	self.bronSkillState = 0
end


function Behavior900020:Update()
	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)
	--self.MonsterCommonBehavior.MonsterGroup:Update()
	--if self.MonsterCommonParam.initialState == self.MonsterCommonParam.InitialStateEnum.Special then
	--if  self.bronSkillState == 0 then
	--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.bornSkillId,self.MonsterCommonParam.battleTarget)
	--self.bronSkillState = 1
	--end
	--if self.bronSkillState == 1 and self.MonsterCommonParam.battleTargetDistance < 5 then
	--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.specialSkillId,self.MonsterCommonParam.battleTarget)
	--self.MonsterCommonParam.initialState = self.MonsterCommonParam.InitialStateEnum.Done
	--end
	--end
	
	-- --角色是否有潜行（写在通用AI里了）
	-- if BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
	-- 	self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
	-- 	self.MonsterCommonParam.warnShortRange = 3
	-- 	self.MonsterCommonParam.warnLongRange = 3
	-- else
	-- 	self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
	-- 	self.MonsterCommonParam.warnShortRange = 6
	-- 	self.MonsterCommonParam.warnLongRange = 12
	-- end
end

function Behavior900020:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900020:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end


--function Behavior900020:WorldInteractClick(uniqueId, instanceId)
--	if instanceId ~= self.me then
		--return
	--end
	--if self.interactUniqueId and self.interactUniqueId == uniqueId then
		--if self.bronState == 1 then
			--BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			--self.bronState = 2
		--end	
	--end
--end

--function Behavior900020:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if self.bronState == 1 then
		--if self.isTrigger then
			--return
		--end
		--self.isTrigger = triggerInstanceId == self.MonsterCommonParam.me
		--if not self.isTrigger then
			--return
		--end
		--self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Collect,nil,"金矿",1)
	--end
--end

--function Behavior900020:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if self.bronState == 1 then
		--if self.isTrigger and triggerInstanceId == self.MonsterCommonParam.me then
			--self.isTrigger = false
			--BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		--end	
	--end
--end