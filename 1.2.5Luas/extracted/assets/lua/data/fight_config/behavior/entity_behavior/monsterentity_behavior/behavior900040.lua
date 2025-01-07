Behavior900040 = BaseClass("Behavior900040",EntityBehaviorBase)
--资源预加载
function Behavior900040.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900040.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end



function Behavior900040:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = 90004009
	self.backHited = 90004062
	
	self.MonsterCommonParam.canBeAss = true				--可以被暗杀
	
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		                                        --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil                                                   --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 6           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12           --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80          --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 90004004            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 90004007            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 90004005            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		----敲击
		--{id = 90004001,
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
		--{id = 90004002,
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
		--{id = 90004003,
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
		{id = 90004014,
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
		{id = 90004017,
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
		{id = 90004016,
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
		{id = 90004005,
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
		{id = 90004006,
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
	self.MonsterCommonParam.defaultSkillId = 90004006		        --默认技能id，追杀模式使用
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
	self.testValue = 0
	--属性参数
	self.ElementList={}
	

end
function Behavior900040:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900040:Update()
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

	--if self.mission == 0 then
		--BehaviorFunctions.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000055)
		----BehaviorFunctions.CreateHeadViewUI(self.MonsterCommonParam.me, 0, 10)
		--self.mission = 1
	--end
	

	--if self.MonsterCommonParam.battleTargetDistance <10 then
		--BehaviorFunctions.ShowHeadViewUI(self.MonsterCommonParam.me, true)
		--BehaviorFunctions.SetHeadViewValue(self.MonsterCommonParam.me,10-self.MonsterCommonParam.battleTargetDistance)
	--end

	--角色是否有潜行
	if BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
		self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
		self.MonsterCommonParam.warnShortRange = 3
		self.MonsterCommonParam.warnLongRange = 3
	else
		self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
		self.MonsterCommonParam.warnShortRange = 6
		self.MonsterCommonParam.warnLongRange = 12
	end

end


function Behavior900040:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end



function Behavior900040:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

--临时弹刀判断
function Behavior900040:ReboundAttack(instanceId,instanceId2)
	if instanceId2 == self.MonsterCommonParam.me then
		local skillId=0
		if BehaviorFunctions.GetSkill(instanceId2)==90004014
			or BehaviorFunctions.GetSkill(instanceId2)==90004017 then
			skillId=90004008
		end
		if BehaviorFunctions.GetSkill(instanceId2)==90004016 then
			skillId=90004010
		end
		if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Skill) then
			BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
		end
		if BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) then
			BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000001)
		end
		if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Hit) then
			BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.FightIdle)
		end
		if skillId~=0 then
			BehaviorFunctions.CastSkillBySelfPosition(self.MonsterCommonParam.me,skillId)
		end	
		

		--if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Skill) then
			--BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
		--end

		--BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Hit)
		--BehaviorFunctions.SetHitType(self.MonsterCommonParam.me,FightEnum.EntityHitState.HitDown)
		--if BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) then
			--BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000001)
		--end

	end
end






--function Behavior900040:EnterElementState(atkInstanceId,instanceId,element)
	--if instanceId==self.MonsterCommonParam.me 
		--and element==FightEnum.ElementType.Fire then
		--if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Skill) then
			--BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
		--end
		--BehaviorFunctions.CastSkillBySelfPosition(self.MonsterCommonParam.me,90004011)
	--end
	
--end