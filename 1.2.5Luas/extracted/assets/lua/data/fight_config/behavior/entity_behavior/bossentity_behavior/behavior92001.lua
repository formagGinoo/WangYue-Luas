Behavior92001 = BaseClass("Behavior92001",EntityBehaviorBase)
--资源预加载
function Behavior92001.GetGenerates()
	--local generates = {1002990001}--预加载弱点击破特效
	--return generates
	local generates = {}
	return generates
end
--mgaic预加载
function Behavior92001.GetMagics()
	local generates = {900000008,900000009,900000010,900000007,1000036,900000107}
	return generates
end
local BF=BehaviorFunctions

function Behavior92001:Init()
	self.me = self.instanceId--记录自身
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	
	self.MonsterCommonParam.isBoss = true
	
	
	--MonsterBorn
	self.MonsterCommonParam.initialDazeTime = 4		           --出生发呆时间
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
	self.MonsterCommonParam.initialSkillCd = 0.2			   --技能初始cd
	self.MonsterCommonParam.commonSkillCd = 0			   --技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = true       --技能是否有生命值区间判断
			
	--游荡参数
	self.MonsterCommonParam.shortRange = 3.5                --游荡近距离边界值
	self.MonsterCommonParam.longRange = 10                  --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 100                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2                    --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canWalkBack = true              --能否后退     
	self.MonsterCommonParam.canLRWalk = true                --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 3            --移动方向切换时间
	self.MonsterCommonParam.switchDelayTime = 2.6           --移动方向切换时间
	self.MonsterCommonParam.walkDazeTime = 0                --移动发呆时间
	self.MonsterCommonParam.canRun = false                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = true            --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 92001004	    --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 1                 --视野范围，不在视野范围内会进行转向
	
	
	--MonsterExitFight
	--开放参数
	self.MonsterCommonParam.ExitFightRange = 999           --脱战距离
	self.MonsterCommonParam.RebornRange = 999              --重生距离
	self.MonsterCommonParam.canExitFight = false           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 999       --脱战时间
	
	
	--按键监听用参数
	self.specialSkillFrame = 0
	self.specialSkillID = 92001006
	self.specialSkillCD = 0


	--个人属性检测参数：
	self.myLifeRatio=0--检测生命值比(万分比)
	self.isStageChane=false--转阶段开关
	

	
	--闪避反击开关：
	self.isCounterattack = 0--初始没有反击
	
	--技能列表(id,默认释放距离,最小释放距离，角度,cd秒数,技能动作持续帧数，计时用帧数,优先级,是否自动释放,难度系数)
	self.MonsterCommonParam.initialSkillList = {
		--左跳001
		{id = 92001001,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3.5,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 35,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 5000,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--右跳002
		{id = 92001002,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3.5,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 35,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 5000,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000    --技能释放最高生命万分比（无等号）
		},
		--后跳隐身+突袭
		{id = 92001003,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 30,        --技能释放最大距离（无等号）
			angle = 100,              --技能释放角度
			cd = 160,                  --技能cd，单位：秒
			durationFrame = 150,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 5000     --技能释放最高生命万分比（无等号）
		},
		--普攻2连 004
		{id = 92001004,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 70,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 140,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 5000,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--后撤突进反击 005
		{id = 92001005,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3.5,        --技能释放最大距离（无等号）
			angle = 70,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 80,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--二连后跳 006
		{id = 92001006,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 70,              --技能释放角度
			cd = 6,                  --技能cd，单位：秒
			durationFrame = 100,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 0,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 5000,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--脚踢二连下砸
		{id = 92001007,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 120,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			durationFrame = 140,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--中距离突进挑飞 
		{id = 92001008,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 14,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			durationFrame = 105,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 5000,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--中距离飞天砸地
		{id = 92001009,
			minDistance = 8,         --技能释放最小距离（有等号）
			maxDistance = 16,        --技能释放最大距离（无等号）
			angle = 50,              --技能释放角度
			cd = 14,                  --技能cd，单位：秒
			durationFrame = 95,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 5000,     --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--闪避反击  010
		{id = 92001010,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 12,                  --技能cd，单位：秒
			durationFrame = 80,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
		},
		--大旋转砸地
		{id = 92001013,
			minDistance = 8,         --技能释放最小距离（有等号）
			maxDistance = 16,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 14,                  --技能cd，单位：秒
			durationFrame = 145,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 5000,     --技能释放最高生命万分比（无等号）
		},
		----黑剑三连
		--{id = 92001014,
			--minDistance = 8,         --技能释放最小距离（有等号）
			--maxDistance = 16,        --技能释放最大距离（无等号）
			--angle = 80,              --技能释放角度
			--cd = 12,                  --技能cd，单位：秒
			--durationFrame = 187,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 5000     --技能释放最高生命万分比（无等号）
		--},
		--转阶段空爆AOE
		{id = 92001016,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 100,        --技能释放最大距离（无等号）
			angle = 360,              --技能释放角度
			cd = 999999,                  --技能cd，单位：秒
			durationFrame = 240,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 4,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 5000     --技能释放最高生命万分比（无等号）
		},
		--突进上挑+空中连击
		 {id = 92001017,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			angle = 100,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 154,      --技能持续帧数
			frame = 1,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 5000     --技能释放最高生命万分比（无等号）
		},
	}
	
	self.skillNum = 92001004
	self.time = 0
	self.timeStart = 300
	self.baxilikesi = nil
	
	--是否可以瘫倒

	
end


--function Behavior900040:LateInit()
	--self.MonsterCommonParam:LateInit()
--end



function Behavior92001:Update()
	
	--记录玩家
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	
	--与巴西利克斯合体时的相关处理
	if BehaviorFunctions.IsEntityBackCombination(self.me) then
		if self.baxilikesi == nil then
			self.baxilikesi = BehaviorFunctions.GetCombinationTargetId(self.me)
		elseif self.baxilikesi ~= nil then
			--local skillID = BehaviorFunctions.GetSkill(self.baxilikesi)
			----如果是贝露贝特射箭则
			--if skillID == 92002072 then
				--if BehaviorFunctions.CanCastSkill(self.me) then
					--BehaviorFunctions.CastSkillByTarget(self.me,92001072,self.battleTarget)
				--end
			--else
				return
			--end
		else
			return
		end
	end
	
	--创建初始buff
	if self.initBuff ~= true then
		BehaviorFunctions.DoMagic(self.me,self.me,92001013) --常驻头发拖尾效果

		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,9200101,true)--设置强锁镜头参数
		

		--BehaviorFunctions.DoMagic(self.me,self.me,900000001)--免疫受击效果
		self.initBuff = true
	end	
	
	--BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.me)--添加BossUI
	
	----添加boss血条
	--if not BehaviorFunctions.HasEntitySign(1,10000020) then
		--BehaviorFunctions.AddEntitySign(1,10000020,-1,false)
	--end
	
	--添加强锁
	if BehaviorFunctions.HasEntitySign(1,10000007) == false then
		BehaviorFunctions.AddEntitySign(1,10000007,-1,false)--添加强锁标签
		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,9200101,true)
	end
	
	
	if not BF.HasBuffKind(self.me,92001010)  and BF.CheckEntity(self.battleTarget) then --不存在这种隐身突袭行为树这个buff，并且存在敌方目标
		
		
		--每一帧检测自身的血量：
		self.myLifeRatio=BF.GetEntityAttrValueRatio(self.me,1001)
		
		--如果自身到了转阶段的变化值则进行以下变化：
		if self.myLifeRatio <=4000 and self.isStageChane == false then
			--BF.AddBuff(self.me,self.me,92001008,1)--添加霸体值buff常驻
			self.MonsterCommonParam.canLRWalk = false--关闭左右走
			self.MonsterCommonParam.canRun = false --开启跑步开关
			
			self.isStageChane =true--把转阶段开关打开
		end
		
		self.MonsterCommonParam:Update()
		self.MonsterCommonBehavior.MonsterBorn:Update()
		self.MonsterCommonBehavior.MonsterPeace:Update()
		self.MonsterCommonBehavior.MonsterWarn:Update()
		self.MonsterCommonBehavior.MonsterExitFight:Update()
		self.MonsterCommonBehavior.MonsterCastSkill:Update()
		self.MonsterCommonBehavior.MonsterWander:Update()

		
		
		
		
		
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
			--BehaviorFunctions.CastSkillByTarget(self.me,92001072,self.battleTarget)
		--end
		
		----技能测试用技能连播
		--if self.timeStart == 0 then
			--self.timeStart = BehaviorFunctions.GetFightFrame() + 150
		--end
		
		--self.time = BehaviorFunctions.GetFightFrame()
		--if self.time == self.timeStart then
	
			--if self.skillNum <= 92001017 then
				--if self.skillNum == 92001011 then
					--self.skillNum = 92001013
				--end
				--BehaviorFunctions.CastSkillByTarget(self.me,self.skillNum,self.battleTarget)
				--self.skillNum = self.skillNum + 1
				--self.timeStart = self.timeStart + 300
			--end
		--end

	end	
	
end

--实体死亡后的行为：结束血条和强锁。
function Behavior92001:Death(instanceId,isFormationRevive)
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

--实体死亡播放动画期间的行为：溶解特效
function Behavior92001:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
	end
end



--临时弹刀判断
function Behavior92001:ReboundAttack(instanceId,instanceId2)
	if instanceId2 == self.me then
		if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Skill) then
			BehaviorFunctions.BreakSkill(self.me)
		end
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Hit)
		--BehaviorFunctions.SetHitType(self.me,FightEnum.EntityHitState.HitDown)
		BehaviorFunctions.RandomFunctionWithParms(
			{BehaviorFunctions.SetHitType,BehaviorFunctions,{self.me,FightEnum.EntityHitState.LeftHeavyHit}},
			{BehaviorFunctions.SetHitType,BehaviorFunctions,{self.me,FightEnum.EntityHitState.RightHeavyHit}}
		)
		
	end	
	
end

--霸体受击逻辑
function Behavior92001:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if hitInstanceId == self.MonsterCommonParam.me then
		--播放霸体受击特效
		if BehaviorFunctions.HasBuffKind(hitInstanceId,900000040) and self.MonsterCommonParam.hitEffectFrame < self.MonsterCommonParam.myFrame then
			BehaviorFunctions.DoMagic(self.me,self.me,900000052)
			self.MonsterCommonParam.hitEffectFrame = self.MonsterCommonParam.myFrame + 8
		end
	end
end










