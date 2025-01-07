Behavior900090 = BaseClass("Behavior900090",EntityBehaviorBase)
--资源预加载
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior900090.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900090.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end



function Behavior900090:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = 900090009
	self.backHited = 90009062

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
	self.MonsterCommonParam.warnSkillId = 90009004            --警告技能Id
	--self.MonsterCommonParam.warnSitSkillId = 90004007            --坐下后起立警告技能Id
	--self.MonsterCommonParam.tauntSkillId = 90004005            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	self.MonsterCommonParam.curAlertnessValue = 0        --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100      --最大警戒值
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 4				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.battleTarget = nil
	self.player = nil
	self.Inskill = false
	self.inblock = false
	self.blockCombo = 0
	self.battleTargetDistance = 0
	self.fightFrame = 0
	self.HitState = 0
	self.HitCD = 0
	self.myState = 0
	self.hitcount = 0
	self.MonsterCommonParam.initialSkillList = {

		--斩击
		{id = 90009001,
		minDistance = 0,         --技能释放最小距离（有等号）
		maxDistance = 3,        --技能释放最大距离（无等号）
		angle = 30,              --技能释放角度
		cd = 8,                  --技能cd，单位：秒
		durationFrame = 63,      --技能持续帧数
		frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		priority = 1,            --优先级，数值越大优先级越高
		weight = 1,              --随机权重
		isAuto = true,           --是否自动释放
		difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},

		--射击
		{id = 90009002,
		minDistance = 1,         --技能释放最小距离（有等号）
		maxDistance = 4.5,        --技能释放最大距离（无等号）
		angle = 30,              --技能释放角度
		cd = 8,                  --技能cd，单位：秒
		durationFrame = 90,      --技能持续帧数
		frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		priority = 1,            --优先级，数值越大优先级越高
		weight = 1,              --随机权重
		isAuto = true,           --是否自动释放
		difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},

		--冲撞
		{id = 90009003,
		minDistance = 0,         --技能释放最小距离（有等号）
		maxDistance = 10,        --技能释放最大距离（无等号）
		angle = 30,              --技能释放角度
		cd = 20,                  --技能cd，单位：秒
		durationFrame = 145,      --技能持续帧数
		frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		priority = 1,            --优先级，数值越大优先级越高
		weight = 1,              --随机权重
		isAuto = true,           --是否自动释放
		difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},

		--三连射
		{id = 90009005,
		minDistance = 3,         --技能释放最小距离（有等号）
		maxDistance = 10,        --技能释放最大距离（无等号）
		angle = 30,              --技能释放角度
		cd = 30,                  --技能cd，单位：秒
		durationFrame = 184,      --技能持续帧数
		frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		priority = 1,            --优先级，数值越大优先级越高
		weight = 1,              --随机权重
		isAuto = true,           --是否自动释放
		difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},


	}
	
	self.bcSkillList01 = {1,2,3}
	self.bcSkillList02 = {1,2,3}

	self.MonsterCommonParam.endureBreakTime=10           --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2.3                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 5                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.2                 --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.87       --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 2.36        --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 0               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 90009001		        --默认技能id，追杀模式使用
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
function Behavior900090:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


--动画帧事件判断
function Behavior900090:OnAnimEvent(instanceId,eventType,params,animationName)
	--左手盾牌显隐判断
	if instanceId == self.me and eventType == FEAET.LeftWeaponVisible then
		if params.visible then
			if BehaviorFunctions.HasBuffKind(self.me,9000904) then
				BehaviorFunctions.RemoveBuff(self.me,9000904,5)
			end
		else
			if not BehaviorFunctions.HasBuffKind(self.me,9000904) then
				BehaviorFunctions.AddBuff(self.me,self.me,9000904,1)
			end
		end
	end
end


function Behavior900090:Update()
	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
	self.me = self.MonsterCommonParam.me
	self.fightFrame = BehaviorFunctions.GetFightFrame()
	self.myState = BehaviorFunctions.GetEntityState(self.me)

	----获取战斗对象
	self.battleTarget = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"battleTarget")
	self.player = BehaviorFunctions.GetCtrlEntity()
	self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.player)
	--开放参数
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)


	self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.player)
	BehaviorFunctions.CheckHitType(self.me,hitType)

	--格挡反击
	--self:BlocakFightBack()
	--self:HitTime()

end


function Behavior900090:FirstCollide(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	if hitInstanceId == self.MonsterCommonParam.me then
		--local a = BehaviorFunctions.GetEntityAngle(self.me,self.player)
		--if a < 60 or a > 300 then
			--local h = BehaviorFunctions.GetHitType(self.Me)
			--if h ~= 5 and h ~= 6 and h ~= 7 and h ~= 71 and h ~= 72 and h ~= 73 and h ~= 74 and h ~= 75 and h ~= 76 and h ~= 20 then
				--if (self.Inskill == false or BehaviorFunctions.GetSkill(self.me) == 90009006) and self.HitState ~= 1 then
					--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90009006,self.MonsterCommonParam.me)
				--end
			--end
		--end
		
		--if self.hitcount >= 15 then
			--BehaviorFunctions.AddBuff(self.me,self.me,900000045)
			--self.hitcount = 0
		--else 
			--self.hitcount = self.hitcount + 1
		--end
		
	end
end

function Behavior900090:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end



function Behavior900090:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

function Behavior900090:CastSkill(instanceId,skillId,skillSign,skillType)
	--if instanceId == self.me then

		--if skillId == 90009006 then
			--self.blockCombo = self.blockCombo + 1
		--else
				--self.Inskill = true
		--end
	--end
end

function Behavior900090:BreakSkill(instanceId,skillId,skillSign,skillType)
	--if instanceId == self.me and self.Inskill == true then
		--self.Inskill = false
		--if skillId == 90009006 then
			--self.inblock = false
		--end
	--end
end

function Behavior900090:FinishSkill(instanceId,skillId,skillSign,skillType)
	--if instanceId == self.me and self.Inskill == true then
		--self.Inskill = false
		--if skillId == 90009006 then
			--self.inblock = false
		--end
	--end
end


--格挡5次后反击
--function Behavior900090:BlocakFightBack()
	
	--if self.blockCombo >= 5 then
		--local R = BehaviorFunctions.RandomSelect(1,2,3)
		
		----距离远的时候，冲锋 OR 射击 OR 三连射
			--if self.battleTargetDistance >= 5.5 then
				--if R == 1 then
					--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90009005,self.player)
					--self:SetSkillFrame(90009005)
				--elseif R == 2 then
					--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90009002,self.player)
					--self:SetSkillFrame(90009002)
				--elseif R == 3 then
					--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90009003,self.player)
					--self:SetSkillFrame(90009003)
				--end
				----距离近的时候，斩击 OR 射击 OR 冲锋
			--elseif self.battleTargetDistance < 5.5 then
				--if R == 1 then
					--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90009001,self.player)
					--self:SetSkillFrame(90009001)
				--elseif R == 2 then
					--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90009002,self.player)
					--self:SetSkillFrame(90009002)
				--elseif R == 3 then
					--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,90009003,self.player)
					--self:SetSkillFrame(90009003)
				--end
				--self.HitState = 0
			--end
	
		--self.blockCombo  = 0
	--end
--end


--根据id查找列表中对应id的技能的列表下标
function Behavior900090:SerchSkillList(skillid,table)
	for i = 1,#table do
		if skillid == table[i].id then
			return i
		end
	end
end

--修改技能frame值
function Behavior900090:SetSkillFrame(skillId)
	--找到这个技能
	local i = self:SerchSkillList(skillId,self.MonsterCommonParam.initialSkillList)
	--修改frame值
	self.MonsterCommonParam.initialSkillList[i].frame = self.fightFrame + self.MonsterCommonParam.initialSkillList[i].cd*30
end


--受击次数记录
--function Behavior900090:HitTime()
	--local s = BehaviorFunctions.GetEntityState(self.me)
	--if s == 8 and self.HitState == 0 then
		--self.HitCD = self.fightFrame + 2*30
		--self.HitState = 1
	--end

	--if self.HitState == 1 and self.HitCD <= self.fightFrame then
		--self.HitState = 2
	--end
--end


