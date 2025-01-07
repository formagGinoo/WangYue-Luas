Behavior900083 = BaseClass("Behavior900083",EntityBehaviorBase)
--资源预加载
function Behavior900083.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900083.GetMagics()
	local generates = {}
	return generates
end

local BF = BehaviorFunctions

function Behavior900083:Init()
	self.MonsterCommonParam = BF.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BF.CreateBehavior("MonsterCommonBehavior",self)

	
	--离体召唤物位置属性
	local cubePos = Vec3.New()
	local positionP = Vec3.New()
	local positionH = Vec3.New()
	self.couldfly = 0
	self.bati = 0
	
	--被暗杀动作
	self.beAssassin = 900083009
	self.backHited = 900083062

	self.MonsterCommonParam.canBeAss = true							  --可以被暗杀

	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false              --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	              --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		                  --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil                      --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             	--是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3          	--近身警告距离
	self.MonsterCommonParam.warnShortRange = 6          	--近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12        	  	--远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80        	--远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2           	--警告延迟时间
	self.MonsterCommonParam.warnSkillId = 900083010         --警告技能Id
	--self.MonsterCommonParam.warnSitSkillId = 900080010    --坐下后起立警告技能Id
	--self.MonsterCommonParam.tauntSkillId = 900080010      --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 5        	--自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           	--难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = true   	--技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		--气脉凝结
		{id = 900083001,
			minDistance = 3,         --技能释放最小距离（有等号）
			maxDistance = 20,         --技能释放最大距离（无等号）
			angle = 85,              --技能释放角度
			--cd = 15,                  --技能cd，单位：秒
			cd = 20,                --技能cd，单位：秒
			durationFrame = 140,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 4,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},

		--气脉炸弹
		{id = 900083004,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 15,         --技能释放最大距离（无等号）
			angle = 160,              --技能释放角度
			--cd = 15,                 --技能cd，单位：秒
			cd = 20,                --技能cd，单位：秒
			durationFrame = 90,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000      --技能释放最高生命万分比（无等号）
		},
	}
	--MonsterWander
	self.MonsterCommonParam.shortRange = 7                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 15                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.2         --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.2          --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 0               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false          --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 900083004	   --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 30               --视野范围，不在视野范围内会进行转向
	self.MonsterCommonParam.isFly = true				   --是否为飞行怪
	
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
	
	
	
	
	--躲子弹
	self.dodgeCd = 2
	self.inDodgeCd = false
	self.leftDodgeSkillId = 900083003
	self.rightDodgeSkillId = 900083002
	self.flyHeight = 1.6
end


function Behavior900083:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900083:Update()
	
	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()

	--执行一次：添加霸体
	if self.bati == 0 then
		self.bati = 1
		--强制左轻受击
		BF.DoMagic(1,self.MonsterCommonParam.me,900000022)
	end
	
	self.MonsterCommonBehavior.MonsterPeace:Update()
	
	--执行一次：移除重力，移动怪物位置至头顶
	if self.couldfly == 0 then
		self.couldfly = 1
		--浮空
		BF.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,90008301)
		BF.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,90008302)
		local positionH = BF.GetPositionP(self.MonsterCommonParam.me)
		BF.DoSetPosition(self.MonsterCommonParam.me,positionH.x,positionH.y + self.flyHeight, positionH.z)
	end
	
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
	
	--开放参数
	BF.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	BF.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)
	--if BF.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
	--BF.PlayAnimation(self.MonsterCommonParam.me,"Sit")
	--end

	--if self.mission == 0 then
	--BF.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000055)
	----BF.CreateHeadViewUI(self.MonsterCommonParam.me, 0, 10)
	--self.mission = 1
	--end


	--if self.MonsterCommonParam.battleTargetDistance <10 then
	--BF.ShowHeadViewUI(self.MonsterCommonParam.me, true)
	--BF.SetHeadViewValue(self.MonsterCommonParam.me,10-self.MonsterCommonParam.battleTargetDistance)
	--end

	----角色是否有潜行
	--if BF.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
		--self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
		--self.MonsterCommonParam.warnShortRange = 3
		--self.MonsterCommonParam.warnLongRange = 3
	--else
		--self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
		--self.MonsterCommonParam.warnShortRange = 6
		--self.MonsterCommonParam.warnLongRange = 12
	--end
end

------------------------------死亡相关效果调用逻辑------------------------------
--执行死亡逻辑前移除避免进入浮空状态机Buff&获得向下移动速度模拟重力
function Behavior900083:BeforeDie(instanceId)
	if instanceId==self.MonsterCommonParam.me then
		BF.RemoveBuff(self.MonsterCommonParam.me,90008301)
		BF.DoMagic(instanceId,instanceId,90008303)
	end
end

function Behavior900083:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BF.DoMagic(instanceId,instanceId,900000008)
		BF.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900083:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BF.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BF.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end


function Behavior900083:BeforeCollide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if hitInstanceId == self.MonsterCommonParam.me then
		if BehaviorFunctions.GetEntityTemplateId(attackInstanceId) == 600050 then
			if BehaviorFunctions.HasBuffKind(hitInstanceId,900000007) then
				BehaviorFunctions.RemoveBuff(hitInstanceId,900000007)
			end
		end
		if not self.inDodgeCd and BehaviorFunctions.CanCtrl(hitInstanceId) and (attackType == FightEnum.EAttackType.Special or attackType == FightEnum.EAttackType.Aim) then
			--子弹在右
			if BehaviorFunctions.CheckEntityAngleRange(hitInstanceId,instanceId,0,180) then
				self:DodgeBullet(false)
			--子弹在左		
			else
				self:DodgeBullet(true)
			end
			self.inDodgeCd = true
			BehaviorFunctions.AddDelayCallByTime(self.dodgeCd,self,self.Assignment,"inDodgeCd",false)
		end	
	end
end

function Behavior900083:DodgeBullet(isLeft)
	BehaviorFunctions.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	if isLeft then
		BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.rightDodgeSkillId,self.MonsterCommonParam.battleTarget)
	else	
		BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.leftDodgeSkillId,self.MonsterCommonParam.battleTarget)
	end
end

--赋值
function Behavior900083:Assignment(variable,value)
	self[variable] = value
end

