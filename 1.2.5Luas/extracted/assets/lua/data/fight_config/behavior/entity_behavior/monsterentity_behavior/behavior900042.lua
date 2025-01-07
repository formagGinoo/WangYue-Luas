Behavior900042 = BaseClass("Behavior900042",EntityBehaviorBase)
--资源预加载
function Behavior900042.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900042.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end


function Behavior900042:Init()
	self.beAssassin = 90004209				--被暗杀动作
	self.backHited = 90004262
	self.mission = 0
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)

	--开放参数
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		                                        --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actSkillId = nil                                                   --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 6           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange = 12            --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80          --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 90004204            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 90004207            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 90004206            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.MonsterCommonParam.canBeAss = true	--可以被暗杀
	self.MonsterCommonParam.initialSkillList = {
		----敲击
		--{id = 90004201,
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
		--{id = 90004202,
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
		--{id = 90004203,
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
		{id = 90004214,
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
		{id = 90004217,
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
		{id = 90004216,
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
		{id = 90004205,
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
		{id = 90004206,
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
		{id = 90004212,
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 50,                  --技能cd，单位：秒
			durationFrame = 94,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = false,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		
		
		
		
		
	}
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2.3                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 5                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.2                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.92        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 0.96667         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 90004206		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 30          --脱战距离
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20      --脱战时间
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	
	
	--元素技能
	self.elementCleanUpKey=0
	self.cleanUpTime=10                                   --清除元素时间


end



function Behavior900042:Update()
	--目标可暗杀buff
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)
	--可暗杀
	--if self.mission == 0 then
	--BehaviorFunctions.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000055)

	--self.mission = 1
	--end

	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
	
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
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
	----BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90004206,self.MonsterCommonParam.battleTarget)
		----BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,EntityMoveSubState.WalkRight)
	----LogError("a")
	----BehaviorFunctions.PlayAnimation(self.MonsterCommonParam.me,"Alert")
	----BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
	--BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
	--end
	--self.MonsterCommonBehavior.MonsterGroupBehavior:Update()
	--self:ElementStateClean()
	--if BehaviorFunctions.GetBuffCount(self.MonsterCommonParam.me, 900000034) == 0 then
		--BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000034)
	--end

end

function Behavior900042:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900042:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end


--临时弹刀判断
function Behavior900042:ReboundAttack(instanceId,instanceId2)
	if instanceId2 == self.MonsterCommonParam.me then
		local skillId=0
		if BehaviorFunctions.GetSkill(instanceId2)==90004214
			or BehaviorFunctions.GetSkill(instanceId2)==90004217 then
			skillId=90004208
		end
		if BehaviorFunctions.GetSkill(instanceId2)==90004216 then
			skillId=90004210
		end
		if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Skill) then
			BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
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


	end
end


--进入元素状态
--function Behavior900042:EnterElementState(atkInstanceId,instanceId,element)
	--if instanceId==self.MonsterCommonParam.me
		--and element==FightEnum.ElementType.Gold then
		--if BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Skill) then
			--BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
		--end
		--if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
		--BehaviorFunctions.CastSkillBySelfPosition(self.MonsterCommonParam.me,90004211)
		--end
	--end
--end




----清理状态
--function Behavior900042:ElementStateClean()
	--local count,maxCount= BehaviorFunctions.GetEntityElementStateAccumulation(self.MonsterCommonParam.me,FightEnum.ElementType.Gold)
	--local minCount=-maxCount
	--if count==0 then
		--self.elementCleanUpKey=1
	--end
	
	--if count>0 and self.elementCleanUpKey==1 then
		--self.cleanUpStart=BehaviorFunctions.GetEntityFrame(self.MonsterCommonParam.me)
		--self.elementCleanUpKey=2

	--end
	
	--if count>0
		--and BehaviorFunctions.GetEntityFrame(self.MonsterCommonParam.me)>self.cleanUpStart+self.cleanUpTime*30  
	    --and self.elementCleanUpKey==2
		--and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me)  
		--and self.MonsterCommonParam.battleTargetDistance>8
		--and (self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default
			--or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd
			--or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.CastingSkill) then
		--self.elementCleanUpKey=3
		--BehaviorFunctions.CastSkillBySelfPosition(self.MonsterCommonParam.me,90004212) --释放清空技能，等技能释放完才会有清空的效果
		--self.cleaningTime=BehaviorFunctions.GetEntityFrame(self.MonsterCommonParam.me)
		
	--end 
	--if self.elementCleanUpKey==3 
		--and BehaviorFunctions.GetEntityFrame(self.MonsterCommonParam.me)>self.cleaningTime+94 then
		--BehaviorFunctions.AddEntityElementStateAccumulation(self.MonsterCommonParam.me,self.MonsterCommonParam.me,FightEnum.ElementType.Gold,minCount)
		
	--end
	
	
	
	
	
--end 

----BehaviorFunctions.GetEntityElementStateAccumulation(instanceId,element)
----BehaviorFunctions.AddEntityElementStateAccumulation(instanceId,atkInstanceId,element,accumulation)



--function Behavior900042:BreakSkill(instanceId,skillId,skillType)
	--if instanceId==self.MonsterCommonParam.me
		--and skillId==90004212 then
		--self.elementCleanUpKey=2
		--self.cleanUpStart=BehaviorFunctions.GetEntityFrame(self.MonsterCommonParam.me)
	--end
--end