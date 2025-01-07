Behavior910040 = BaseClass("Behavior910040",EntityBehaviorBase)
--资源预加载
function Behavior910040.GetGenerates()
	local generates = {}
	return generates
end

function Behavior910040.GetMagics()
	local generates = {900000024,900000025}
	return generates
end


function Behavior910040:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = 91004009
	self.backHited = 91004062
	self.MonsterCommonParam.canBeAss = true --可以被暗杀
	--开放参数
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		                                        --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actSkillId = nil                                                   --演出技能Id
	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 5           --近身疑问距离（无视角度）
	self.MonsterCommonParam.warnLongRange = 10            --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 60          --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 91004091            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = nil            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = nil            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 100        --自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.4				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断

	self.MonsterCommonParam.initialSkillList = {
		----挥锤挑飞
		{id = 91004001,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 102,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		--横扫
		{id = 91004002,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 84,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		--恐怖胸炮攻击
		{id = 91004003,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 16,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 135,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--地波攻击
		{id = 91004004,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 40,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 118,      --技能持续帧数
			frame = 30,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放w
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		--跳砸攻击
		{id = 91004005,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 16,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 112,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		}
		
	}
	--MonsterWander
	self.MonsterCommonParam.shortRange = 3                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 10                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 25                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.3                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true              --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 3.2        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.4         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 91004002		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 30           --脱战距离
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20       --脱战时间
	self.MonsterCommonParam.canNotChase = 50
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.ExitFightRange

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.walkSwitchFrame=0
	
	self.posCheck={}
	self.stopMove=0
	self.list = {}
	self.patrolPositionList={}
	self.patrolPositionList={}
	self.information={"moveState"}
	self.direactionDisable={}
	self.mission=0
		
	self.canSee=false
	
	self.cameraEnum =
	{
		Inside = 1,
		Outside = 0,
		
		}
	self.cameraState = self.cameraEnum.Inside
	
	self.direactionEnum =
	{
		Right = 1,
		Left =2,
		}
	
	self.moveStateEnum =
	{
		Default = 0,
		OutsideCamera = 1,
		Wander = 2,
		WanderForSkill =3,
		}
	
	self.skillWanderEnum = 
	{
		Default = 0,
		Forward = 1,
		RightOrLeft =2,
		
		}
	
	
	self.moveWanderEnum ={
		Default = 0,--默认
		Wander = 1,--随机游荡
		WalkForward = 2,--远距离前走
		RunForward = 3,--远距离前跑
		WalkBack = 4,--近距离后退
		RunAndHit = 5,--超远距离跑打	
		}
	
	--技能参数
	self.inSkillAngle = 0                                                   --是否符合技能释放角度
	self.skillCastingFrame = 0
	self.prepareSkillList = {}                                              --准备中技能列表(能立刻放的技能)
	self.skillBeginFrame = 0
	self.skillBeginState = 0
	self.FightTargetArrowEffect=false	
	
	--游荡相关参数
	self.inVision = false                                                   --是否在视野内
	self.battleRange = 0 			                                        --游荡分区
	self.BattleRangeEnum = {                                                --游荡分区枚举
		Default = 0,
		Short = 1,
		Mid = 2,
		Long = 3,
		Far = 4
	}
	self.walkSwitchFrame = 0
	self.hitSkillFrame = 0
	self.posCheck={}
	self.direactionDisable={}
	self.skillWanderKey = 0
	self.skillWander = 0
	self.haveSkillWrongDistance = 0
	self.wrongDistanceSkillList = {}
end

function Behavior910040:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
	--接收运动参数
	if self.sInstanceId~=nil then
		self.param = BehaviorFunctions.GetEcoEntityExtraParam(self.MonsterCommonParam.ecoMe)
		if not self.param or not next(self.param) then
			return
		else
			for k,v in pairs(self.param) do
				for n,m in ipairs(self.information) do
					if v[m]~=nil then
						self.list[m]=self:SplitParam(v[m],"|")
					end

				end
			end
		end
	end
end

function Behavior910040:Update()
	
	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
	
	--被暗杀动作传参
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	
	if BehaviorFunctions.GetSkillSign(self.MonsterCommonParam.me,9100400)
		and self.MonsterCommonParam.battleTargetDistance<10 
		and BehaviorFunctions.GetBuffCount(self.MonsterCommonParam.battleTarget,1000036) == 0 then
		BehaviorFunctions.AddBuff(self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.battleTarget,1000036)
	end
	
	-- --角色是否有潜行
	-- if BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
	-- 	self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
	-- 	self.MonsterCommonParam.warnShortRange = 3
	-- 	self.MonsterCommonParam.warnLongRange = 3
	-- else
	-- 	self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
	-- 	self.MonsterCommonParam.warnShortRange = 5
	-- 	self.MonsterCommonParam.warnLongRange = 10
	-- end
end

	

function Behavior910040:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000027)
	end
end

function Behavior910040:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then		
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

function Behavior910040:PartHit(instanceId,partName,life,damage,MissileType)
	--瞄头削刃
	if MissileType ==FightEnum.EAttackType.Aim
		and instanceId==self.MonsterCommonParam.me
		and self.aimSkill == true
		and partName=="Head" then
		if BehaviorFunctions.GetSkill(instanceId) then
			BehaviorFunctions.BreakSkill(instanceId)
		end
		BehaviorFunctions.CastSkillBySelfPosition(instanceId,91004090)

	end
end

function Behavior910040:CastSkill(instanceId,skillId,skillSign,skillType)	
	if instanceId==self.me
		and skillId ==91004004
		or skillId ==91004005
		or skillId ==91004006 then
		self.aimSkill = true
	end
end



function Behavior910040:BreakSkill(instanceId,skillId,skillSign,skillType)
	if instanceId==self.me
		and skillId ==91004004
		or skillId ==91004005
		or skillId ==91004006 then
		self.aimSkill = false
	end
	if instanceId==self.me
		and skillId ==910040900 then
		self.toughness = 1000
		self.canReduceToughness=true
	end
end

function Behavior910040:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId==self.me
		and skillId ==91004004
		or skillId ==91004005
		or skillId ==91004006 then
		self.aimSkill = false
	end
	if instanceId==self.me
		and skillId ==910040900 then
		self.toughness = 1000
		self.canReduceToughness=true
	end	
end

function Behavior910040:Warning(instance, targetInstance,sign,isEnd)
	--当子弹快打到角色身上时，出现跳反预警
	if instance == self.MonsterCommonParam.me 
		and sign == 910040
		and BehaviorFunctions.GetBuffCount(self.MonsterCommonParam.battleTarget,1000036) == 0 
		and BehaviorFunctions.GetDistanceFromTarget(instance,targetInstance,false) <= 6  and isEnd == nil then
		BehaviorFunctions.AddBuff(instance,targetInstance,1000036)
	end
end