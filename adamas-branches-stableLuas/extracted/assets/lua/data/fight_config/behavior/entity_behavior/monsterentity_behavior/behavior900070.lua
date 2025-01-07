Behavior900070 = BaseClass("Behavior900070",EntityBehaviorBase)
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
local FES = FightEnum.EntityState

function Behavior900070:Init()
	self.MonsterCommonParam = BF.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BF.CreateBehavior("MonsterCommonBehavior",self)
	self.me = self.instanceId
	
	--个人属性检测参数：
	local myPos = Vec3.New()					--获取怪物释放技能时位置
	local positionP = Vec3.New()				--获取玩家坐标
	local myPosOffset = Vec3.New()				--角色位置偏移
	self.hitEffectFrame = 0
	self.myFrame = 0
	

	self.isActive = 0
	self.hideWeapon = false

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
	self.MonsterCommonParam.noWarnInFightRange = 30        	--自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           	--难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.6				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = true   	--技能是否有生命值区间判断
	self.SkillSoundList = {"Play_v_zhanke_01","Play_v_zhanke_02","Play_v_zhanke_03"}
	self.MonsterCommonParam.initialSkillList = {
		--竖劈
		--{id = 900070001,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 3,         --技能释放最大距离（无等号）
			--angle = 100,              --技能释放角度
			--cd = 10,                  --技能cd，单位：秒
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
		--举刀斜劈（1111）
		{id = 900070002,
			minDistance = 0,       --技能释放最小距离（有等号）
			maxDistance = 5,         --技能释放最大距离（无等号）
			angle = 60,             --技能释放角度
			cd = 8,                 --技能cd，单位：秒
			durationFrame = 90,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,   	 --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		----------后撤步（蓄力架势）
		----{id = 900070003,
			----minDistance = 0,         --技能释放最小距离（有等号）
			----maxDistance = 4.5,       --技能释放最大距离（无等号）
			----angle = 140,             --技能释放角度
			----cd = 25,                 --技能cd，单位：秒
			------cd = 2,                --技能cd，单位：秒
			----durationFrame = 50,      --技能持续帧数
			----frame = 900,          	 --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			----priority = 1,            --优先级，数值越大优先级越高
			----weight = 1,              --随机权重
			----isAuto = true,           --是否自动释放
			----difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			----minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			----maxLifeRatio = 10000      --技能释放最高生命万分比（无等号）
		----},
		----前突刺（1111）
		{id = 900070004,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 8,         --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 15,               	 --技能cd，单位：秒
			durationFrame = 115,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		----充能蓄力斩（111）
		{id = 900070005,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,         --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 10,               	 --技能cd，单位：秒
			durationFrame = 105,     --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		----后撤蓄力斩
		--{id = 900070006,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 4,         --技能释放最大距离（无等号）
			--angle = 90,              --技能释放角度
			----cd = 1,                --技能cd，单位：秒
			--cd = 40,                 --技能cd，单位：秒
			--durationFrame = 105,     --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 2,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 10000      --技能释放最高生命万分比（无等号）
		--},
		----结印隐身（25cd）
		{id = 90007021,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 90,            	 --技能释放角度
			cd = 30,             	 --技能cd，单位：秒
			durationFrame = 92,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		----结印隐身（25cd）
		--{id = 900070010,
		--minDistance = 0,         --技能释放最小距离（有等号）
		--maxDistance = 15,        --技能释放最大距离（无等号）
		--angle = 90,            	 --技能释放角度
		--cd = 30,             	 --技能cd，单位：秒
		----cd = 2,                --技能cd，单位：秒
		--durationFrame = 92,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000      --技能释放最高生命万分比（无等号）
		--},
		
		----结印隐身袭杀
		--{id = 900070008,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 3,        --技能释放最大距离（无等号）
			--angle = 360,             --技能释放角度
			--cd = 2,             	 --技能cd，单位：秒
			----cd = 90,               --技能cd，单位：秒
			--durationFrame = 41,     --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 2,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 4000      --技能释放最高生命万分比（无等号）
		--},
		--------跳劈跳反
		{id = 900070010,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 12,       --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 30,                 --技能cd，单位：秒
			durationFrame = 89,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,     --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		}
		------结印隐身袭杀落地
		--{id = 900070012,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 2,        --技能释放最大距离（无等号）
			--angle = 360,             --技能释放角度
			--cd = 2,             	 --技能cd，单位：秒
			----cd = 90,               --技能cd，单位：秒
			--durationFrame = 50,     --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 2,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 4000      --技能释放最高生命万分比（无等号）
		--},

	}
	--MonsterWander
	self.MonsterCommonParam.shortRange = 3                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 6                  --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.5                 --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 2.4         --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.2          --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1.067               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false         --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 900070002	   --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 20               --视野范围，不在视野范围内会进行转向

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

	--self.ExhibitWeapon = true							   --Alert武器隐藏功能保护

	--碰撞移除强制打断计时参数
	self.startTime = nil
	self.limitTime = 2
	self.hitcount = 0
	self.police = nil
	
	--放技能语音
	self.AudioState = 0 --是不是第一次放技能
	self.AudioTime = 0 --语音CD
	self.LastAudio = 0
end

function Behavior900070:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end

function Behavior900070:Update()
	
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

	--if self.MonsterCommonParam.battleTargetDistance <10 then
		--BF.ShowHeadViewUI(self.MonsterCommonParam.me, true)
		--BF.SetHeadViewValue(self.MonsterCommonParam.me,10-self.MonsterCommonParam.battleTargetDistance)
	--end

	--武器隐藏功能
	--self:HideIdleWeapon(self.MonsterCommonParam.me)

	--self:ShowWeapon(self.MonsterCommonParam.me)
	--self:StealthHideWeapon(self.MonsterCommonParam.me)

	--ATK003派生&ATK008功能逻辑
	--self:ATK008(self.MonsterCommonParam.me)
	
	self.player = BehaviorFunctions.GetCtrlEntity()
	
	if self.hitcount >= 3 then
		BehaviorFunctions.SetEntityValue(self.me,"battleTarget",self.police)
	--elseif self.hitcount >= 5 then
		--BehaviorFunctions.SetEntityValue(self.me,"battleTarget",self.player)
	end
	--隐身技能Start结束
	if BF.HasEntitySign(self.me,90007021) then
		BF.BreakSkill(self.me)
		BF.RemoveEntitySign(self.me,90007021)
		BF.CastSkillBySelfPosition(self.me,90007022)
	end
	--显示血条
	if BF.HasEntitySign(self.me,90007022) then
		BF.SetEntityLifeBarVisibleType(self.me,2)
	end
	
	--显隐血条\创建刀特效
	if BF.HasEntitySign(self.me,900070212) then
		BF.SetEntityLifeBarVisibleType(self.me,3)
		BF.RemoveEntitySign(self.me,900070212)
		BF.DoMagic(self.me,self.MonsterCommonParam.battleTarget,9000702101,1)
	end
	
	if BF.HasEntitySign(self.me,900070213) then
		BF.DoMagic(self.me,self.MonsterCommonParam.battleTarget,9000702102,1)
		BF.RemoveEntitySign(self.me,900070213)
	end
	
end




------------------------------武器隐藏逻辑------------------------------
--休闲待机状态永久隐藏武器
--function Behavior900070:HideIdleWeapon(instanceId)
	--if BF.CheckIdleState(instanceId,4) then
		--if self.hideWeapon == false then
			--BF.AddBuff(instanceId,instanceId,9007002)
			--self.hideWeapon = true
		--end
	--else
		--if self.hideWeapon == true then
			--BF.RemoveBuff(instanceId,9007002)
			--self.hideWeapon = false
		--end
	--end
--end

--function Behavior900070:StealthHideWeapon(instanceId)
	--if BF.GetSkill(self.MonsterCommonParam.me) == 900070007 then
		--if BF.GetSkillSign(self.MonsterCommonParam.me,9007007) then
			--BF.AddBuff(instanceId,instanceId,9007002)
		--else
			--BF.RemoveBuff(instanceId,9007002)
		--end
	--end
--end

--Alert状态挥动过程武器屏蔽
--function Behavior900070:ShowWeapon(instanceId,skillId,skillSign,skillType)
	--if self.ExhibitWeapon and BF.GetSkill(instanceId) == 900070901 and instanceId==self.MonsterCommonParam.me then
		---- 触发一次功能
		--BF.AddBuff(instanceId,instanceId,9007001)    --激活一次延时展示怪物手中武器
		--self.ExhibitWeapon = false
	--elseif not self.ExhibitWeapon and not BF.GetSkill(instanceId) == 90007001 and instanceId==self.MonsterCommonParam.me then
		--self.ExhibitWeapon = true
	--end
--end


function Behavior900070:AddSkillSign(instanceId,sign)
	----后撤步横扫触发窗口
	--if instanceId == self.MonsterCommonParam.me and self.isActive == 0 and sign == 900700301 then
		--if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) < 4 then
			--self.isActive = 1
			----识别到技能窗口90007031&玩家距离符合
			----切换播放ATK006横斩
			--BF.BreakSkill(self.MonsterCommonParam.me)
			--BF.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,360,360,-2,includeX)
			--BF.CastSkillByTarget(self.MonsterCommonParam.me,900070006,self.MonsterCommonParam.battleTarget)
			----特殊處理：清除預備技能列表
			--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
			--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
		--end
	--else
		--self.isActive = 0
	--end

	----后撤步前突刺触发窗口
	--if instanceId == self.MonsterCommonParam.me and self.isActive == 0 and sign == 900700302 then
		--if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) >= 4 then
			--self.isActive = 1
			----识别到技能窗口90007031&玩家距离符合
			----切换播放ATK006横斩
			--BF.BreakSkill(self.MonsterCommonParam.me)
			--BF.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,360,360,-2,includeX)
			--BF.CastSkillByTarget(self.MonsterCommonParam.me,900070004, self.MonsterCommonParam.battleTarget)
			----特殊處理：清除預備技能列表
			--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
			--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
		--end
	--else
		--self.isActive = 0
	--end
	
	----玩家低血量时打断自身后撤步技能
	--if instanceId == self.MonsterCommonParam.me and sign == 900700303 then
		--if BF.GetEntityAttrValueRatio(self.MonsterCommonParam.battleTarget,1001) < 5000 then
			--BF.BreakSkill(self.MonsterCommonParam.me)
		--end
	--end
	
	--获取结印隐身时自身位置
	if instanceId == self.MonsterCommonParam.me and sign == 9007007 then
		local CastPos = BF.GetPositionP(self.MonsterCommonParam.me)
	end
	
	----下砸攻击衔接普通后撤步
	----检查是否满足条件：释放ATK008 & 自身存在 & 怪物距玩家间距<2 & ATK008技能切换标识已激活
	--if  instanceId == self.MonsterCommonParam.me and sign == 9007012 then
		--if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) < 4.5 then
			----移除当前技能并释放ATK003后闪避
			--BF.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
			--BF.CastSkillBySelfPosition(self.MonsterCommonParam.me,900070011)
			----特殊處理：清除預備技能列表
			--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
			--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
		--end
	--end
end


------------------------------隐身突袭技能相关逻辑------------------------------
--function Behavior900070:BeforeCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	--self.hitEffectFrame = self.myFrame + 240            					--霸体特效计时器
	---- 霸体相关受击监视
	--if hitInstanceId == self.MonsterCommonParam.me and BF.GetSkill(hitInstanceId) == 900070007 then
		---- 播放霸体受击特效
		--if self.hitEffectFrame > self.myFrame then
			--if BF.HasBuffKind(hitInstanceId,900000045) then
				--BF.DoMagic(self.me,self.me,900000052)                           --播放霸体受击特效
				--self.hitCount = self.hitCount + 1                				--受击计数器
			--end
		--end
	
	---- 霸体受击数满足条件，触发弱点效果
		--if self.hitCount >= 2 then
			--BF.BreakSkill(hitInstanceId)
			--BF.DoMagic(hitInstanceId,hitInstanceId,9007007,1)					--触发施法失败伤害
		--end
	--end
--end

-------------------------------隐身突袭技能 版本2-------------------------------
--function Behavior900070:ATK008(instanceId)
	----local dd = BF.GetSkill(instanceId)
	----local xx = BF.CheckEntity(self.MonsterCommonParam.battleTarget)
	----local ff = BF.GetSkillSign(instanceId,9007008)
	--if BF.GetSkill(instanceId) == 900070008 and BF.CheckEntity(self.MonsterCommonParam.battleTarget) and BF.GetSkillSign(instanceId,9007008) then
		----移除武器隐藏buff
		--BF.RemoveBuff(instanceId,9007002)  			
		----位置怪物受重力影响的位置信息&下落触底检查
		--local myPos = BF.GetPositionP(self.MonsterCommonParam.me)
		--local myPosOffset = Vec3.New(myPos.x, myPos.y + 0.2, myPos.z)
		--BF.SetEntityLifeBarVisibleType(self.MonsterCommonParam.me,2)
		--local hightM,layerM=BF.CheckPosHeight(myPosOffset)
		----检查地面层级(使用玩家偏移位置探针)，离地高度（使用怪物时实位置探针）
		--if hightM~=nil and hightM <= 0.25 then                            
			----释放地面攻击技能&恢复碰撞
			--BF.CastSkillBySelfPosition(self.MonsterCommonParam.me,900070012)
			--BF.RemoveBuff(self.MonsterCommonParam.me,900070802)
			------如果玩家在范围内，则激活地面震屏效果
			----if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,checkRadius) <= 4 then
				----BF.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,9007006,magicLev)
			----end
			----特殊處理：清除預備技能列表al.prepareSkillList = {}
			----self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
		--end
	--end
--end


---------------------------------隐身突袭技能 版本1-------------------------------
--function Behavior900070:ATK008(instanceId)
	----检查是否进入ATK008（ATK008Active为保护开关）
	--if BF.GetSkill(self.MonsterCommonParam.me) == 900070008 and BF.CheckEntity(self.MonsterCommonParam.battleTarget) then
		--positionP = BF.GetPositionP(self.MonsterCommonParam.battleTarget)
		----关闭时实同步数据条件判定，获取执行攻击标记后会停止更新移动数据指令--------攻击执行流程
		--if BF.GetSkillSign(self.MonsterCommonParam.me,9007008) == false then
			----隐藏生命条，位置信息记录
			--BF.SetEntityLifeBarVisibleType(self.MonsterCommonParam.me,3)
			----同步怪物位于角色前上方
			--BF.DoSetPosition(self.MonsterCommonParam.me,positionP.x, positionP.y + 2.4,positionP.z)
		--else
			--local state = BF.CheckEntityState(self.MonsterCommonParam.battleTarget,FightEnum.EntityState.Glide)
			--if BF.GetEntityState(self.MonsterCommonParam.battleTarget) ~= FightEnum.EntityState.Glide then
				----显示生命条，位置怪物受重力影响的位置信息&下落触底检查
				--myPos = BF.GetPositionP(self.MonsterCommonParam.me)
				--BF.RemoveBuff(instanceId,9007002)  								--移除武器隐藏buff保底
				--BF.SetEntityLifeBarVisibleType(self.MonsterCommonParam.me,2)
				--local hightM,layerM=BF.CheckPosHeight(myPos)
				----检查地面层级(使用玩家偏移位置探针)，离地高度（使用怪物时实位置探针）
				--if hightM~=nil and hightM <= 0.1 then
					----BF.BreakSkill(self.MonsterCommonParam.me)
					----释放退出隐身刺杀技能
					--BF.CastSkillBySelfPosition(self.MonsterCommonParam.me,900070012)
					----如果玩家在范围内，则激活地面震屏效果
					--if BF.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,checkRadius) <= 7 then
						--BF.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,9007006,magicLev)
					--end
					----特殊處理：清除預備技能列表
					--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
					--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
				--end
			--else
				--BF.CastSkillByPosition(self.MonsterCommonParam.me,900070012,CastPos)
				----特殊處理：清除預備技能列表
				--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
				--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
			--end
		--end
	--end
--end


--防止武器隐藏恢复流程被打断无法显示的特殊保底
--function Behavior900070:BreakSkill(instanceId,skillId,skillSign,skillType)
	--if instanceId == self.me and skillId == 900070007 then
		--BF.RemoveBuff(instanceId,9007002)
		--BF.SetEntityLifeBarVisibleType(self.MonsterCommonParam.me,2)
		--BF.RemoveBuff(self.me,900000010)
		--BF.RemoveBuff(self.me,900000045)
		--BF.RemoveBuff(self.me,9007005)
	--end
--end

--------------------------------跳反预警------------------------------
--function Behavior900070:Warning(instance, targetInstance,sign,isEnd)
	----当子弹快打到角色身上时，出现跳反预警
	--if instance == self.MonsterCommonParam.me
		--and sign == 900070
		--and BehaviorFunctions.GetBuffCount(self.MonsterCommonParam.battleTarget,1000036) == 0
		--and BehaviorFunctions.GetDistanceFromTarget(instance,targetInstance,false) >= 1  and isEnd == nil then
		--BehaviorFunctions.AddBuff(self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.battleTarget,1000036)
	--end
--end

function Behavior900070:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		local role = BehaviorFunctions.GetCtrlEntity()
		local pos = BehaviorFunctions.GetPositionP(role)
		--BehaviorFunctions.SetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime,pos)
		
		--第一次放技能播
		if self.AudioState == 0 then
			BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_04",true,FightEnum.SoundSignType.Language)--"密令已发！"
			self.AudioState = 1
			self.AudioTime = BF.GetFightFrame()
		else
			--放对应技能播对应语音，会判断角色是否在说话，是否间隔20秒
			--local T = BF.GetFightFrame()
			--if not BF.GetEntitySignSound(self.player,signType) then
				--if T >= self.AudioTime + 20*30 then
					--if skillId == 900070004 then
						--BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_03",true,FightEnum.SoundSignType.Language)
					--elseif skillId == 900070007 then
						--BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_02",true,FightEnum.SoundSignType.Language)
					--elseif skillId == 900070005 then
						--BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_01",true,FightEnum.SoundSignType.Language)
					--end
					--self.AudioTime = T
				--end
			--end
		end
		
	end
	
	
end

function Behavior900070:OnLand(instanceId)
	if BF.HasEntitySign(self.me,90007022) then
		BF.BreakSkill(self.me)
		BF.CastSkillBySelfPosition(self.me,90007023)
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
		BF.DoEntityAudioPlay(self.me,"Play_v_zhanke_05",false,FightEnum.SoundSignType.Language)--"死亡语音"
	end
end

--function Behavior900070:FirstCollide(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	--if hitInstanceId == self.MonsterCommonParam.me then
		--if attackInstanceId ~= self.player then
			--self.hitcount = self.hitcount + 1
			--self.police = attackInstanceId
		--end
	--end
--end