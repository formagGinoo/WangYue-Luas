Behavior920031 = BaseClass("Behavior920031",EntityBehaviorBase)
--资源预加载
function Behavior920031.GetGenerates()
	--local generates = {1002990001}--预加载弱点击破特效
	--return generates
	local generates = {}
	return generates
end
--mgaic预加载
function Behavior920031.GetMagics()
	local generates = {900000008,900000009,900000010,900000007}
	return generates
end
local BF=BehaviorFunctions

function Behavior920031:Init()
	self.me = self.instanceId--记录自身
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)

	self.MonsterCommonParam.isBoss = true


	--MonsterBorn
	self.MonsterCommonParam.initialDazeTime = 3		           --出生发呆时间
	self.MonsterCommonParam.haveSpecialBornLogic = false       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	       --出生技能id


	--MonsterPeace
	self.MonsterCommonParam.actSkillId = nil                   --演出技能Id


	--MonsterWarn
	self.MonsterCommonParam.haveWarn = false              --是否有警告状态
	self.MonsterCommonParam.warnShortRange = nil           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange = nil            --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = nil         --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = nil            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = nil      --警告技能Id

	--技能参数
	self.MonsterCommonParam.difficultyDegree = 0            --难度系数
	self.MonsterCommonParam.initialSkillCd = 0			   --技能初始cd
	self.MonsterCommonParam.commonSkillCd = 0			   --技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = true       --技能是否有生命值区间判断

	--游荡参数
	self.MonsterCommonParam.shortRange = 3.5                  --游荡近距离边界值
	self.MonsterCommonParam.longRange = 10                  --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 16                   --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2                    --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.walkSwitchTime = 2.5              --移动方向切换时间
	self.MonsterCommonParam.LRWalkSwitchTime = 2.5
	self.MonsterCommonParam.switchDelayTime = 1          --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 0                --移动发呆时间
	self.MonsterCommonParam.canRun = false                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 920031004		       --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 1                 --视野范围，不在视野范围内会进行转向

	--MonsterExitFight
	--开放参数
	self.MonsterCommonParam.ExitFightRange = 999           --脱战距离
	self.MonsterCommonParam.RebornRange = 999              --重生距离
	self.MonsterCommonParam.canExitFight = false           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 999       --脱战时间


	--按键监听用参数
	self.specialSkillFrame = 0
	self.specialSkillID = 920031006
	self.specialSkillCD = 0


	--个人属性检测参数：
	self.myLifeRatio=0--检测生命值比(万分比)
	self.isStageChane=false--转阶段开关



	--闪避反击开关：
	self.isCounterattack = 0--初始没有反击

	--技能列表(id,默认释放距离,最小释放距离，角度,cd秒数,技能动作持续帧数，计时用帧数,优先级,是否自动释放,难度系数)
	self.MonsterCommonParam.initialSkillList = {
		
		--后跳
		{id = 92003003,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度			--突进技能冷却
			cd = 20,                  --技能cd，单位：秒
			durationFrame = 55,      --技能持续帧数
			frame = 180,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 2		
		},
		
		--横扫
		{id = 92003010,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3.5,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			durationFrame = 100,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 4
		},
		
		--左斜下挥
		{id = 92003004,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3.5,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 5,                  --技能cd，单位：秒
			durationFrame = 75,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 4
		},
		
		--下砸
		{id = 92003005,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			durationFrame = 111,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 0
		},
		
		--前冲横扫
		--{id = 92003013,
			--minDistance = 5,         --技能释放最小距离（有等号）
			--maxDistance = 10,        --技能释放最大距离（无等号）
			--angle = 80,              --技能释放角度
			--cd = 18,                  --技能cd，单位：秒
			--durationFrame = 77,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
		--},	
		
		--前冲横扫
		{id = 92003013,
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 103,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 0
		},
		
		--跳砸
		{id = 92003015,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			angle = 90,              --技能释放角度
			cd = 12,                  --技能cd，单位：秒
			durationFrame = 108,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 0
		},
		
		
		--横扫下砸
		{id = 92003105,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 5,        --技能释放最大距离（无等号）
			angle = 120,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 153,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 0
		},
		
		--横扫跳砸
		{id = 92003115,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 7,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 20,                  --技能cd，单位：秒
			durationFrame = 163,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 0
		},
		
		--横扫后跳
		{id = 92003103,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 12,                  --技能cd，单位：秒
			durationFrame = 79,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 0,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			specialState = 0
		},
		
	}
	self.jumpframe = 0 
	self.time = 0
	self.timeStart = 300
	self.jumpcd = 0
	self.WanderOff = 0 
	self.jumpcheck = 0
	self.MonsterCommonParam.mySpecialState = 0
	self.restcd = 0
	self.restframe = 0
	self.atkframe = 0
	self.atkcd = 0
	self.atkOff = 0
	self.atkcheck = 0
end



function Behavior920031:Update()
	local skillID = BehaviorFunctions.GetSkill(self.me)
	self.MoveState = BehaviorFunctions.GetSubMoveState(self.me)
	--记录玩家
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	self.restcd = math.random(0,10)
	self.jumpcd = math.random(1,5)
	self.atkcd = math.random(1,5)
	--创建初始buff
	self.time = BehaviorFunctions.GetFightFrame()

	if self.initBuff ~= true then
		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,90002)--设置强锁镜头参数
		self.initBuff = true
	end
	

	BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.me)--添加BossUI

	--添加boss血条
	if not BehaviorFunctions.HasEntitySign(1,10000020) then
		BehaviorFunctions.AddEntitySign(1,10000020,-1,false)
	end

	--添加强锁
	if BehaviorFunctions.HasEntitySign(1,10000007) == false then
		BehaviorFunctions.AddEntitySign(1,10000007,-1,false)--添加强锁标签
		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,90002)
	end

	--添加部位锁定标识
	if BehaviorFunctions.HasEntitySign(1,90000001) == false then
		BehaviorFunctions.AddEntitySign(1,90000001,-1,false)--添加强锁标签
	end


	
	--攻击频率
	if self.restframe > self.time then
		if self.MonsterCommonParam.mySpecialState ~= 0 then
			self.MonsterCommonParam.mySpecialState = 99
			self.restcd = 0
		else
			self.MonsterCommonParam.mySpecialState = 0 
		end
	end
	
	
	--临时处理横扫cd
	if self.time > self.atkframe then
		self.atkOff = 0
	end
	
	if self.atkOff == 1 and self.atkcheck == 1 then
		self.MonsterCommonParam.initialSkillList[2].specialState = 1
		self.MonsterCommonParam.initialSkillList[7].specialState = 1
		self.MonsterCommonParam.initialSkillList[8].specialState = 1
		self.MonsterCommonParam.initialSkillList[9].specialState = 1
		self.atkframe = self.time + self.atkcd * 30
		self.atkcheck = 0
	end
	if self.atkOff == 0 then

		self.MonsterCommonParam.initialSkillList[5].specialState = 0
		self.MonsterCommonParam.initialSkillList[6].specialState = 0
		self.MonsterCommonParam.initialSkillList[8].specialState = 0
		self.MonsterCommonParam.initialSkillList[9].specialState = 0
	end
	--检测是否后跳后
	if self.time > self.jumpframe then
		self.WanderOff = 0
	end

	if self.WanderOff == 1 and self.jumpcheck == 1 then
		self.MonsterCommonParam.initialSkillList[5].specialState = 1
		self.MonsterCommonParam.initialSkillList[6].specialState = 1
		--self.MonsterCommonParam.initialSkillList[8].specialState = 1
		self.MonsterCommonParam.initialSkillList[9].specialState = 1
		self.jumpframe = self.time + self.jumpcd * 30
		self.jumpcheck = 0
	end
	if self.WanderOff == 0 then

		self.MonsterCommonParam.initialSkillList[5].specialState = 0
		self.MonsterCommonParam.initialSkillList[6].specialState = 0
		--self.MonsterCommonParam.initialSkillList[8].specialState = 0
		self.MonsterCommonParam.initialSkillList[9].specialState = 0
	end
	

	if BF.CheckEntity(self.battleTarget) then --存在敌方目标

		if self.MonsterCommonParam.battleTargetDistance > 20 and self.MoveState ~= FightEnum.EntityMoveSubState.Run then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
		end
		--每一帧检测自身的血量：
		self.myLifeRatio=BF.GetEntityAttrValueRatio(self.me,1001)

		--如果自身到了转阶段的变化值则进行以下变化：
		--if self.myLifeRatio <=4000 and self.isStageChane == false then
			--Log("ad")
			--BF.AddBuff(self.me,self.me,920031008,1)--添加霸体值buff常驻
			--self.MonsterCommonParam.canLRWalk = false--关闭左右走
			--self.MonsterCommonParam.canRun = false --开启跑步开关

			--self.isStageChane =true--把转阶段开关打开
		--end

		self.MonsterCommonParam:Update()
		self.MonsterCommonBehavior.MonsterBorn:Update()
		self.MonsterCommonBehavior.MonsterPeace:Update()
		if self.MonsterCommonParam.battleTargetDistance <= 20 then
		self.MonsterCommonBehavior.MonsterWarn:Update()
		end
		self.MonsterCommonBehavior.MonsterExitFight:Update()
		self.MonsterCommonBehavior.MonsterWander:Update()
		self.MonsterCommonBehavior.MonsterCastSkill:Update()
			if BehaviorFunctions.CanCtrl(self.me) == true then	
			 --if self.jumpcd == 1 then
			
				--if self.MonsterCommonParam.battleTargetDistance < 4 then
					----if #self.MonsterCommonParam.currentSkillList > 0 then
						----self.MonsterCommonBehavior.MonsterCastSkill:AlterCurrentSkillList(92003015,cd,3)
						----self.MonsterCommonBehavior.MonsterCastSkill:AlterCurrentSkillList(92003014,cd,3)
						----self.jumpcd = 0
 					--self.MonsterCommonParam.initialSkillList[1].commonCD = 0
					--self.jumpcd = 0
					--end
					----end
				--end
		end
		----按键监听示例
		--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) then
		--if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) and self.MonsterCommonParam.fightFrame >= self.specialSkillFrame then
		--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.specialSkillID,self.MonsterCommonParam.battleTarget)
		--self.specialSkillFrame = self.MonsterCommonParam.fightFrame + self.specialSkillCD*30
		--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
		--self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default
		--end
		--end

		--技能测试用按键监听（按U）
		--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
		--BehaviorFunctions.CastSkillByTarget(self.me,920031072,self.battleTarget)
		--end

		----技能测试用技能连播
		--if self.timeStart == 0 then
		--self.timeStart = BehaviorFunctions.GetFightFrame() + 150
		--end

		--self.time = BehaviorFunctions.GetFightFrame()
		--if self.time == self.timeStart then

		--if self.skillNum <= 920031017 then
		--if self.skillNum == 920031011 then
		--self.skillNum = 920031013
		--end
		--BehaviorFunctions.CastSkillByTarget(self.me,self.skillNum,self.battleTarget)
		--self.skillNum = self.skillNum + 1
		--self.timeStart = self.timeStart + 300
		--end
		--end

	end

end

function Behavior920031:FinishSkill(instanceId,skillId,skillType)

	if instanceId ==self.me then
			if skillId == 92003003 or skillId == 92003115 then
				self.WanderOff = 1
				self.jumpcheck = 1
			end

			if skillId == 92003010 or skillId == 92003103 or skillId == 92003105 or skillId == 92003115 then
				self.atkOff = 1
				self.atkcheck = 1

			end

	end
end

--function Behavior920031:CastSkill(instanceId,skillId,skillType)
	--LogError("1")
--end



function Behavior920031:BreakSkill(instanceId,skillId,skillType)

	if instanceId ==self.me then
		if skillId == 92003003 or skillId == 92003115 then
			self.WanderOff = 1
			self.jumpcheck = 1
		end
		
		if skillId == 92003010 or skillId == 92003103 or skillId == 92003105 or skillId == 92003115 then
			self.atkOff = 1
			self.atkcheck = 1
			
		end

		if self.restcd > 5 then
			self.restframe = self.time + math.random(1,4) * 38
		end
	end
end
--实体死亡后的行为：结束血条和强锁。
function Behavior920031:Death(instanceId,isFormationRevive)
	if instanceId == self.me then
		BehaviorFunctions.RemoveFightTarget(self.me,self.battleTarget)
		--怪物死亡时移除强锁标签
		if BehaviorFunctions.HasEntitySign(1,10000007) then
			BehaviorFunctions.RemoveEntitySign(1,10000007)
			--BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,90002)--恢复强锁参数
		end
		--怪物死后，移除Boss血条标签
		if BehaviorFunctions.HasEntitySign(1,100000020) then
			BehaviorFunctions.RemoveEntitySign(1,10000020)
		end
	end
end
--
function Behavior920031:AfterDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	if hitInstanceId == self.me then
		self.restframe = self.restframe - 5
	end
	
	
end
--实体死亡播放动画期间的行为：溶解特效
--function Behavior920031:DeathEnter(instanceId,isFormationRevive)
	--if instanceId==self.MonsterCommonParam.me then
		--BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
	--end
--end

--元素反应弱点：
--function Behavior920031:EnterElementState(atkInstanceId,instanceId,element)

	--if instanceId == self.me and element == FightEnum.ElementType.Gold then
		--BehaviorFunctions.CreateEntity(1002990001,self.me)--弱点击破特效

		--if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Skill) then
			--BehaviorFunctions.BreakSkill(self.me)
		--end
		--if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Hit) then
			--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
		--end
		--BF.CastSkillByTarget(self.me,920031091,self.battleTarget)
	--end

--end

--临时弹刀判断
--function Behavior920031:ReboundAttack(instanceId,instanceId2)
	--if instanceId2 == self.me then
		--if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Skill) then
			--BehaviorFunctions.BreakSkill(self.me)
		--end
		--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Hit)
		----BehaviorFunctions.SetHitType(self.me,FightEnum.EntityHitState.HitDown)
		--BehaviorFunctions.RandomFunctionWithParms(
			--{BehaviorFunctions.SetHitType,BehaviorFunctions,{self.me,FightEnum.EntityHitState.LeftHeavyHit}},
			--{BehaviorFunctions.SetHitType,BehaviorFunctions,{self.me,FightEnum.EntityHitState.RightHeavyHit}}
		--)
	--end
--end