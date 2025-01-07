
Behavior900030 = BaseClass("Behavior900030",EntityBehaviorBase)
--资源预加载
function Behavior900030.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900030.GetMagics()
	local generates = {900000024,900000025}
	return generates
end


function Behavior900030:Init()
	self.me = self.instanceId--记录自身
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	self.beAssassin = 90003009
	self.backHited = 90003062
	self.MonsterCommonParam.canBeAss = true	--可以被暗杀
	--开放参数
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2	                                        --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actSkillId = nil                                                   --演出技能Id
	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true              --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
	self.MonsterCommonParam.warnShortRange =  6         --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange = 12           --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80         --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 90003014       --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 90003016            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 90003015            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断


	--技能列表(id,默认释放距离,最小释放距离，角度,cd秒数,技能动作持续帧数，计时用帧数,优先级,是否自动释放,难度系数)
	self.MonsterCommonParam.initialSkillList = {
		--冲撞技能Attack012
		{id = 90003012,
			minDistance = 3,         --技能释放最小距离（有等号）
			maxDistance = 5,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 12,                  --技能cd，单位：秒
			durationFrame = 83,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--敲击技能Attack001
		{id = 90003001,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 2.4,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 66,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		----警告技能Warning
		{id = 90003015,
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 50,                  --技能cd，单位：秒
			durationFrame = 65,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		}

	}
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2.3                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 10                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 25                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.3                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.92        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 0.96667         --延迟切换时间(前后走) 
	self.MonsterCommonParam.walkDazeTime = 1               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 90003001		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange =30           --脱战距离
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20       --脱战时间
	self.skillGroupKey1=false                            --防御反击连段
	self.skillGroupKey2=false                            --收盾连段
	self.MonsterCommonParam.canNotChase = 50              --追不上玩家的距离，增加的变量，感觉没必要
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange


	
end


--感觉需要两个距离，一个是怪物离出生点的距离，一个是怪物距离玩家的距离。
--脱战距离，有两种情况，一种是怪物离出生点太远，二是怪物距离玩家太远。
--重生距离：当怪物距离玩家很近，但是距离出生点很远时，直接重生也很奇怪。建议是，当怪物脱战的时候，往原来的方向走，当怪物距离玩家很远/无法寻路时，且出生点很远时，怪物重生。


function Behavior900030:Update()
	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self:SkillGroup()
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
		--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90003015,self.MonsterCommonParam.battleTarget)
		----LogError("a")
		----BehaviorFunctions.PlayAnimation(self.MonsterCommonParam.me,"Alert")
		----BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
		----BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
	--end
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

--function BehaviorBase:FirstCollide(attackInstanceId,hitInstanceId,InstanceIdId)
	--if attackInstanceId==self.battleTarget then
		--BehaviorFunctions.CastSkillByTarget(self.me,90003012,self.battleTarget)
	--end
--end

function Behavior900030:FirstCollide(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	if hitInstanceId==self.MonsterCommonParam.me then

		if attackInstanceId==self.battleTarget and BehaviorFunctions.GetEntityAngle(self.me,self.battleTarget)<15 then

			BehaviorFunctions.DoMagic(self.me,self.me,900000001)
			BehaviorFunctions.CastSkillByTarget(self.me,90003011,self.battleTarget)
			self.skillGroupKey1 = true
		end
	end
end





function Behavior900030:SkillGroup()
	if  self.MonsterCommonParam.inFight == true then  --因为技能列表需要在战斗状态才会初始化，在战斗状态再走这个流程。
		if self.skillGroupKey1 ==true then
			if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
				if self.MonsterCommonParam.currentSkillList ~=nil then
					if self.MonsterCommonParam.currentSkillList[2].frame < self.MonsterCommonParam.myFrame  then
						BehaviorFunctions.CastSkillByTarget(self.me,90003012,self.battleTarget)
						--self.MonsterCommonParam.currentSkillList[1].frame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.commonSkillCd * 30 + self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillList[1]].durationFrame+ self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillList[1]].cd * 30
						self.MonsterCommonParam.currentSkillList[2].frame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.currentSkillList[2].cd * 30
						self.skillCastingFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.currentSkillList[2].durationFrame
						self.MonsterCommonParam.commonSkillCdFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.commonSkillCd * 30 + self.MonsterCommonParam.currentSkillList[2].durationFrame
						self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.CastingSkill
						self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default
					else
						BehaviorFunctions.CastSkillByTarget(self.me,90003010,self.battleTarget)
					end
					--self.MonsterCommonParam.currentSkillList[num].frame
					self.skillGroupKey1 = false
					self.skillGroupKey2 = true
				end
			end
		end
		if self.skillGroupKey2 ==true then

			if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
				BehaviorFunctions.CastSkillByTarget(self.me,90003013,self.battleTarget)
				self.skillGroupKey2=false
			end

		end
	end
end

function Behavior900030:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900030:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end


--临时弹刀判断
function Behavior900030:ReboundAttack(instanceId,instanceId2)
	if instanceId2 == self.MonsterCommonParam.me then
		local skillId=0
		if BehaviorFunctions.GetSkill(instanceId2)==90003001 then
			skillId=90003002
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

