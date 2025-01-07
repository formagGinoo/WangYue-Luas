Behavior900150 = BaseClass("Behavior900150",EntityBehaviorBase)
--资源预加载
function Behavior900150.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900150.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end



function Behavior900150:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	self.me = self.MonsterCommonParam.me
	
	--被暗杀动作
	self.beAssassin = 90012008
	self.backHited = 90012009
	
	self.MonsterCommonParam.canBeAss = false				  --可以被暗杀
	
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false      --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	      --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		          --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil              --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             	  --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3                --直接警告距离
	self.MonsterCommonParam.warnShortRange = 6                --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12               --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80              --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2                 --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 90015002            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 90015002         --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 90015002           --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30           --无警告状态时直接进战的距离
	self.MonsterCommonParam.curAlertnessValue = 0             --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100           --最大警戒值
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0              --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				  --技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				  --技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false        --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		--技能1：飞踹
		{id = 90015001,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3.5,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 8,           	       --技能cd，单位：秒
			durationFrame = 65,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		}
	}
	
	self.MonsterCommonParam.endureBreakTime=10             --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2.5               --游荡近距离边界值（小于此距离往后走）
	self.MonsterCommonParam.longRange = 6                  --游荡远距离边界值（小于此距离前走或左右走）
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值（小于此距离跑）
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 2.799       --左右走持续时间
	self.MonsterCommonParam.switchDelayTime = 0.933        --前后走持续时间
	self.MonsterCommonParam.walkDazeTime = 2.667           --待机时间（配stand2时间）
	self.MonsterCommonParam.canRun = true                  --跑步开关
	
	self.MonsterCommonParam.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.minRange = 1                 --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.defaultSkillId = 90015001	   --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 50            --脱战距离（距离出生点）
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true            --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20        --脱战时间
	self.MonsterCommonParam.canNotChase = 50               --追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange    --脱战距离（距离锁定目标）
	self.MonsterCommonParam.monsterRangeRadius = 2.5							   --以自身为圆心的一个范围，其他怪物无法wander进来

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	self.mission = 0
	self.testValue = 0
	--属性参数
	self.ElementList={}
	
	
	--默认动作
	self.actList =
	{
		[1] = {aniName = "Eat", lastFrame = 120},           --休闲动作列表
		[2] = {aniName = "Stand1", lastFrame = 80},
		[3] = {aniName = "Comb", lastFrame = 90},
		[4] = {aniName = "Walk", lastFrame = 20}
	}
	self.defaultActing = nil
	self.defaultActNum = 1
	self.defaultActState = 0
	self.defaultActStateEnum =
	{
		Default = 0, --默认
		In = 1, --进入
		End = 2, --结束
	}
	self.walkLoopCount = nil

end
function Behavior900150:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900150:Update()
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
	self.fightFrame = BehaviorFunctions.GetFightFrame()
	
	--非战斗状态时的休闲行为
	self:Xiuxian()
	
	--怪物进战播危险特效，非进战播和平特效
	if not (BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Die) or
		BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Death) or 
		BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Born)) then
		if self.MonsterCommonParam.inFight == true then
			BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,90015002)
			BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,90015001)
		else
			BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,90015001)
			BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,90015002)
		end
	end		
end


function Behavior900150:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.RemoveBuffByGroup(instanceId,90015001)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end



function Behavior900150:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

function Behavior900150:Xiuxian()
	if self.MonsterCommonParam.inPeace == true and not (BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Die) or
		BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Death) or
		BehaviorFunctions.CheckEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Born) or
		self.MonsterCommonParam.exitFightstate == self.MonsterCommonParam.ExitFightStateEnum.Exiting) then
		
		if self.defaultActState == self.defaultActStateEnum.Default and not self.defaultActing then
			self.defaultActNum = math.random(1, #self.actList)
			local aniName = self.actList[self.defaultActNum].aniName
			--如果是行走，转向跳一定次数
			if aniName == "Walk" then
				local randomAngle = math.random(0,360)
				local lookAtPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me, 100, randomAngle)
				BehaviorFunctions.DoLookAtPositionByLerp(self.me,lookAtPos.x,lookAtPos.y,lookAtPos.z,false,180,460,true)
				self.walkLoopCount = math.random(3, 6)
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				self.defaultActing = true
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastFrame*self.walkLoopCount,self,self.Assignment,"defaultActState",self.defaultActStateEnum.Default)
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastFrame*self.walkLoopCount,self,self.Assignment,"defaultActing",nil)
				--如果不是行走，直接播放
			else
				if BehaviorFunctions.GetSubMoveState(self.me) == FightEnum.EntityMoveSubState.Walk then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.None)
				end
				BehaviorFunctions.PlayAnimation(self.me,aniName)
				self.defaultActing = true
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastFrame,self,self.Assignment,"defaultActState",self.defaultActStateEnum.Default)
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastFrame,self,self.Assignment,"defaultActing",nil)
			end
		end
		
	end
end

--赋值
function Behavior900150:Assignment(variable,value)
	self[variable] = value
	if variable == "myState" then
	end
end