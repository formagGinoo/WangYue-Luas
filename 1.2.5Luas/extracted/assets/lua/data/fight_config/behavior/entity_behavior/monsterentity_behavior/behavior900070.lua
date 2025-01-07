Behavior900070 = BaseClass("Behavior900040",EntityBehaviorBase)
--资源预加载
function Behavior900070.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900070.GetMagics()
	local generates = {90007002}
	return generates
end

local BF = BehaviorFunctions

function Behavior900070:Init()
	self.MonsterCommonParam = BF.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BF.CreateBehavior("MonsterCommonBehavior",self)

	--个人属性检测参数：
	self.myLifeRatio=0--检测生命值比(万分比)
	local myPos = Vec3.New()					--获取怪物释放技能位置
	local positionP = Vec3.New()				--获取玩家坐标

	self.isActive = 0
	self.ATK008Active = 0

	--被暗杀动作
	self.beAssassin = 900070009
	self.backHited = 900070062

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
	self.MonsterCommonParam.warnSkillId = 900070901         --警告技能Id
	--self.MonsterCommonParam.warnSitSkillId = 90004007     --坐下后起立警告技能Id
	--self.MonsterCommonParam.tauntSkillId = 90007005       --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 5        	--自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           	--难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false   	--技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		--竖劈
		--{id = 900070001,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 3,         --技能释放最大距离（无等号）
			--angle = 85,              --技能释放角度
			--cd = 8,                  --技能cd，单位：秒
			----cd = 2,                --技能cd，单位：秒
			--durationFrame = 92,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 4,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},

		------充能蓄力斩
		--{id = 900070005,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 3,         --技能释放最大距离（无等号）
			--angle = 90,              --技能释放角度
			--cd = 25,               	 --技能cd，单位：秒
			----cd = 2,                --技能cd，单位：秒
			--durationFrame = 100,     --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 4000      --技能释放最高生命万分比（无等号）
		--},

		----举刀斜劈
		--{id = 900070002,
			--minDistance = 2,         --技能释放最小距离（有等号）
			--maxDistance = 5,         --技能释放最大距离（无等号）
			--angle = 85,              --技能释放角度
			--cd = 14,                 --技能cd，单位：秒
			----cd = 2,                --技能cd，单位：秒
			--durationFrame = 90,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 4000,     --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},

		--------后撤步（蓄力架势）
		--{id = 900070003,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 3.5,       --技能释放最大距离（无等号）
			--angle = 90,              --技能释放角度
			--cd = 30,                 --技能cd，单位：秒
			----cd = 2,                --技能cd，单位：秒
			--durationFrame = 60,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 5000      --技能释放最高生命万分比（无等号）
		--},

		--------后撤步
		--{id = 900070011,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 3.5,       --技能释放最大距离（无等号）
			--angle = 90,              --技能释放角度
			--cd = 25,                 --技能cd，单位：秒
			----cd = 2,                --技能cd，单位：秒
			--durationFrame = 60,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 5000,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},

		----前突刺
		--{id = 900070004,
			--minDistance = 3,         --技能释放最小距离（有等号）
			--maxDistance = 8,         --技能释放最大距离（无等号）
			--angle = 65,              --技能释放角度
			--cd = 24,                 --技能cd，单位：秒
			----cd = 2,                --技能cd，单位：秒
			--durationFrame = 115,     --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 8000      --技能释放最高生命万分比（无等号）
		--},

		----后撤蓄力斩
		--{id = 900070006,
		--minDistance = 0,         --技能释放最小距离（有等号）
		--maxDistance = 4,         --技能释放最大距离（无等号）
		--angle = 90,              --技能释放角度
		----cd = 1,               --技能cd，单位：秒
		--cd = 40,                  --技能cd，单位：秒
		--durationFrame = 105,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 2,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 2000     --技能释放最高生命万分比（无等号）
		--},

		----结印隐身
		{id = 900070007,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 40,        --技能释放最大距离（无等号）
			angle = 120,             --技能释放角度
			cd = 2,             	 --技能cd，单位：秒
			--cd = 90,               --技能cd，单位：秒
			durationFrame = 57,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 4000      --技能释放最高生命万分比（无等号）
		},
		
		----结印隐身袭杀
		{id = 900070008,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3,        --技能释放最大距离（无等号）
			angle = 360,             --技能释放角度
			cd = 2,             	 --技能cd，单位：秒
			--cd = 90,               --技能cd，单位：秒
			durationFrame = 58,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 4000      --技能释放最高生命万分比（无等号）
		},
		
		----结印隐身袭杀落地
		{id = 900070012,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 2,        --技能释放最大距离（无等号）
			angle = 360,             --技能释放角度
			cd = 2,             	 --技能cd，单位：秒
			--cd = 90,               --技能cd，单位：秒
			durationFrame = 50,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 4000      --技能释放最高生命万分比（无等号）
		},

	}
	--MonsterWander
	self.MonsterCommonParam.shortRange = 3                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 6                  --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.2        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.2         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 0               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false          --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 900070001	   --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 25               --视野范围，不在视野范围内会进行转向

	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 50           --脱战距离
	self.MonsterCommonParam.RebornRange = 200             --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20       --脱战时间
	self.MonsterCommonParam.canNotChase = 50              --追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0          --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0            --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	self.mission = 0
	self.testValue = 0

	self.ExhibitWeapon = true							   --Alert武器隐藏功能保护

	--碰撞移除强制打断计时参数
	self.startTime = nil
	self.limitTime = 2
end


function Behavior900070:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900070:Update()
	--每一帧检测自身的血量：
	self.myLifeRatio=BF.GetEntityAttrValueRatio(self.MonsterCommonParam.me,1001)

	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
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

	--角色是否有潜行
	if BF.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
		self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
		self.MonsterCommonParam.warnShortRange = 3
		self.MonsterCommonParam.warnLongRange = 3
	else
		self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
		self.MonsterCommonParam.warnShortRange = 6
		self.MonsterCommonParam.warnLongRange = 12
	end


	--武器隐藏功能
	self:HideIdleWeapon(self.MonsterCommonParam.me)
	self:ShowWeapon(self.MonsterCommonParam.me)
	self:StealthHideWeapon(self.MonsterCommonParam.me)
	--self:ATK003Sub(self.MonsterCommonParam.me)
	self:ATK008(self.MonsterCommonParam.me)


end

--Attack003激活后有概率触发Attack005
--function BF.GetSkillSign(instanceId,type)
--local randomWeight = 0
--if instanceId==self.MonsterCommonParam.me and type == 900070003 then
--randomWeight = BF.Random(0,10)
--if randomWeight > 7 and 10 > self.randomWeight then					--30%概率触发技能
--self:BreakSkill(self.MonsterCommonParam.me)						--打断ATK003切换ATk005
--end
--end
--end



------------------------------武器隐藏逻辑------------------------------
--休闲待机状态永久隐藏武器
function Behavior900070:HideIdleWeapon(instanceId)
	if BF.CheckIdleState(instanceId,FightEnum.EntityIdleType.LeisurelyIdle) and instanceId==self.MonsterCommonParam.me then
		BF.AddBuff(instanceId,instanceId,9007002)
	else
		BF.RemoveBuff(instanceId,9007002)
	end
end

function Behavior900070:StealthHideWeapon(instanceId)
	if BF.HasEntitySign(self.MonsterCommonParam.me,9007007) and instanceId==self.MonsterCommonParam.me then
		BF.AddBuff(instanceId,instanceId,9007003)
	else if BF.HasEntitySign(self.MonsterCommonParam.me,9007007) == false then
			BF.RemoveBuff(instanceId,9007003)
		end
	end
end


--Alert状态挥动过程武器屏蔽
function Behavior900070:ShowWeapon(instanceId,skillId,skillType)
	if self.ExhibitWeapon and BF.GetSkill(instanceId) == 900070901 and instanceId==self.MonsterCommonParam.me then
		-- 触发一次功能
		BF.AddBuff(instanceId,instanceId,9007001)    --激活一次延时展示怪物手中武器
		self.ExhibitWeapon = false
	elseif not self.ExhibitWeapon and not BF.GetSkill(instanceId) == 90007001 and instanceId==self.MonsterCommonParam.me then
		self.ExhibitWeapon = true
	end
end


------------------------------隐身突袭技能相关逻辑------------------------------
--准备隐身弱点状态：霸体受击N次会打断施法并获得重伤

--function Behavior900070:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
--local hitCount = 0
----霸体相关受击监视
--if hitInstanceId == self.MonsterCommonParam.me then
----播放霸体受击特效
--if self.MonsterCommonParam.hitEffectFrame < self.MonsterCommonParam.myFrame then
--if BF.HasBuffKind(hitInstanceId,900000045) then
--BF.DoMagic(self.me,self.me,900000052)   												--播放霸体受击特效
--self.MonsterCommonParam.hitEffectFrame = self.MonsterCommonParam.myFrame + 8			--霸体特效计时器
--hitCount = hitCount + 1																	--受击计数器
--end
--else
--hitCount = 0
--end
--end
----霸体受击数满足条件，触发弱点效果
--if hitInstanceId == self.MonsterCommonParam.me and hitCount >= 2 then
--BF.BreakSkill(hitInstanceId)
--BF.DoMagic(hitInstanceId,hitInstanceId,900070007,1)												--触发施法失败伤害
--end
--end


-------------------------------下砸攻击衔接普通后撤步-------------------------------
--function Behavior900070:BreakSkill(instanceId,skillId,skillType)
----检查是否满足条件：释放ATK008 & 自身存在 & 怪物距玩家间距<2 & ATK008技能切换标识已激活
--if  skillId == 900070008 and instanceId == self.MonsterCommonParam.me and BF.HasEntitySign(self.MonsterCommonParam.me,9000708) then

----移除当前技能并释放ATK003后闪避
--skillId = nil
--BehaviorFunctions.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,900070003,self.MonsterCommonParam.battleTarget)
----特殊處理：清除預備技能列表
--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
--end
--end

-------------------------------充能后撤步派生触发-------------------------------
function Behavior900070:ATK003Sub(instanceId)
	if BF.GetSkill(self.MonsterCommonParam.me) == 900070003 and self.isActive == 0 then
		--充能后撤步检测距离选择派生技能
		if instanceId == self.MonsterCommonParam.me and BF.HasEntitySign(self.MonsterCommonParam.me,900700301) then
			if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) < 4 then
				self.isActive = 1
				--识别到技能窗口90007031&玩家距离符合
				--切换播放ATK006横斩
				BF.BreakSkill(self.MonsterCommonParam.me)
				BF.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,360,360,-2,includeX)
				BF.CastSkillByTarget(self.MonsterCommonParam.me,900070006,self.MonsterCommonParam.battleTarget)
				--特殊處理：清除預備技能列表
				self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
				self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
			end
		else if instanceId == self.MonsterCommonParam.me and BF.HasEntitySign(self.MonsterCommonParam.me,900700302) then
				if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) >= 4 then
					self.isActive = 1
					--识别到技能窗口90007031&玩家距离符合
					--切换播放ATK006横斩
					BF.BreakSkill(self.MonsterCommonParam.me)
					BF.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,360,360,-2,includeX)
					BF.CastSkillByTarget(self.MonsterCommonParam.me,900070010, self.MonsterCommonParam.battleTarget)
					--特殊處理：清除預備技能列表
					self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
					self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
				end
			end
		end
	else
		self.isActive = 0
	end
end

-------------------------------隐身突袭技能逻辑-------------------------------
function Behavior900070:ATK008(instanceId)
	--检查是否进入ATK008
	if BF.GetSkill(self.MonsterCommonParam.me) == 900070008 and self.ATK008Active == 0 then
		--关闭时实同步数据条件判定，获取执行攻击标记后会停止更新移动数据指令
		if BF.HasEntitySign(self.MonsterCommonParam.me,9007008) == false and BF.CheckEntity(self.MonsterCommonParam.battleTarget) then
			--位置信息记录
			positionP = BF.GetPositionP(self.MonsterCommonParam.battleTarget)
			myPos = BF.GetPositionP(self.MonsterCommonParam.me)
			--同步怪物位于角色前上方
			myPos:Set(positionP.x, positionP.y + 2.2, positionP.z)
		end

		--下落触底检查
		local hightM,layerM=BF.CheckPosHeight(myPos)
		--检查地面层级(使用玩家偏移位置探针)，离地高度（使用怪物时实位置探针）
		if hightM~=nil and hightM <= 0.1 then
			self.ATK008Active = 1
			BF.BreakSkill(self.MonsterCommonParam.me)
			--释放退出隐身刺杀技能
			BF.CastSkillBySelfPosition(self.MonsterCommonParam.me,900070012)
			--特殊處理：清除預備技能列表
			self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
			self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default

		else 
			self.ATK008Active = 0
		end
	end
end


------------------------------跳反预警------------------------------
function Behavior900070:Warning(instance, targetInstance,sign,isEnd)
	--当子弹快打到角色身上时，出现跳反预警
	if instance == self.MonsterCommonParam.me
		and sign == 900070
		and BehaviorFunctions.GetBuffCount(self.MonsterCommonParam.battleTarget,1000036) == 0
		and BehaviorFunctions.GetDistanceFromTarget(instance,targetInstance,false) >= 1  and isEnd == nil then
		BehaviorFunctions.AddBuff(self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.battleTarget,1000036)
	end
end

------------------------------死亡相关效果调用逻辑------------------------------
function Behavior900070:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BF.DoMagic(instanceId,instanceId,900000008)
		BF.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900070:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BF.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BF.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end