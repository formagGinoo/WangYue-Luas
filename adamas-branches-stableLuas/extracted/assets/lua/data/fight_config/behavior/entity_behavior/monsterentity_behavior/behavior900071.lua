Behavior900071 = BaseClass("Behavior900040",EntityBehaviorBase)
--资源预加载
function Behavior900071.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900071.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end

local BF = BehaviorFunctions
local FES = FightEnum.EntityState

function Behavior900071:Init()
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
	self.MonsterCommonParam.warnSkillId = 900071901            --警告技能Id
	--self.MonsterCommonParam.warnSitSkillId = 90004007            --坐下后起立警告技能Id
	--self.MonsterCommonParam.tauntSkillId = 90004005            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	self.MonsterCommonParam.curAlertnessValue = 0        --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100      --最大警戒值
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		
		--转身斜劈
		{id = 90007101,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 6,                  --技能cd，单位：秒
			durationFrame = 71,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--前突刺
		{id = 90007102,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 7,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			durationFrame = 106,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--横斩
		{id = 90007103,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 68,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--抛沙后翻
		{id = 90007104,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 6,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 90,      --技能持续帧数
			frame = 15,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 2,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},	
		
		--刀插地裂
		{id = 90007105,
			minDistance = 3,         --技能释放最小距离（有等号）
			maxDistance = 12,        --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 100,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		
	}
	
	--近战连携技能列表
	self.InitialComboSkillList = {90007101,90007102}
	self.ComboSkillList = {90007101,90007102}
	
	self.MonsterCommonParam.endureBreakTime=10           --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2.5                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 5                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.2                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.2        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.2         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 0               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 90007101	   --默认技能id，追杀模式使用
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
	
	self.state = 0
	self.me = self.instanceId
	

end
function Behavior900071:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900071:Update()
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
	self.fightFrame = BF.GetFightFrame()
	
	self:HasEntitySign()
	self:StunAvoid()
end


function Behavior900071:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BF.DoMagic(instanceId,instanceId,900000008)
		BF.DoMagic(instanceId,instanceId,900000036)
	end
end



function Behavior900071:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BF.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BF.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

--检测实体标记
function Behavior900071:HasEntitySign()
	if self.MonsterCommonParam.battleTarget and self.me then
		--抛沙后撤派生
		if BF.HasEntitySign(self.me,900071041) then
			local L = BF.GetDistanceFromTarget(self.me,self.MonsterCommonParam.battleTarget)
			--近距离派生
			if L <= 5 then
				--判断派生技能表是否为空
				if next(self.ComboSkillList) then
					--释放表里的第一个技能
					BF.CastSkillByTarget(self.me,self.ComboSkillList[1],self.MonsterCommonParam.battleTarget)
					--第一个技能加CD
					self:SetSkillFrame(self.ComboSkillList[1])
					--移除表里的第一个技能
					table.remove(self.ComboSkillList,1)
				else
					self.ComboSkillList = {90007101,90007102}
					BF.CastSkillByTarget(self.me,self.ComboSkillList[1],self.MonsterCommonParam.battleTarget)
					self:SetSkillFrame(self.ComboSkillList[1])
					table.remove(self.ComboSkillList,1)
				end
			else
				BF.CastSkillByTarget(self.me,90007105,self.MonsterCommonParam.battleTarget)
				self:SetSkillFrame(90007105)
			end
			BF.RemoveEntitySign(self.me,900071041)
		end
		
		----刀插地获取敌人位置
		--if BF.HasEntitySign(self.me,900071051) then
			--self.x,self.y,self.z = BehaviorFunctions.GetEntityTransformPos(self.MonsterCommonParam.battleTarget)
			--BF.RemoveEntitySign(self.me,900071051)
		--end
		----地裂时在刚才获取的位置处创建子弹
		--if BF.HasEntitySign(self.me,900071052) then
			--BF.CreateEntity(90007105001,self.me,self.x,self.y,self.z)
			--BF.RemoveEntitySign(self.me,900071052)
		--end
	end
end

--根据id查找列表中对应id的技能的列表下标
function Behavior900071:SerchSkillList(skillid,table)
	for i = 1,#table do
		if skillid == table[i].id then
			return i
		end
	end
end

--修改技能frame值
function Behavior900071:SetSkillFrame(skillId)
	--找到这个技能
	local i = self:SerchSkillList(skillId,self.MonsterCommonParam.initialSkillList)
	--修改frame值
	self.MonsterCommonParam.initialSkillList[i].frame = self.fightFrame + self.MonsterCommonParam.initialSkillList[i].cd*30
end

----命中时判断
--function Behavior900071:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType,camp)
	--local I = BF.GetEntityTemplateId(instanceId)
	--if attackInstanceId == self.Me then
		----部分子弹命中时增加少核心充能
		--if BF.CheckEntity(hitInstanceId) and (I == 1007004001) then
			--BF.ChangeEntityAttr(self.Me,1204,0.025,1)	--总1
		--end
	--end
	--if BF.CheckEntity(hitInstanceId) and I == 100701011001 then
		--BF.ChangeEntityAttr(self.Me,1204,0.0549,1)
	--end
--end

function Behavior900071:StunAvoid()
	local S = BF.GetEntityState(self.me)
	local i = self:SerchSkillList(90007104,self.MonsterCommonParam.initialSkillList)
	
	if S == 14 and self.state == 0 then
		self.state = 1
		self.MonsterCommonParam.initialSkillList[i].priority = 2
	elseif S ~= 14 and self.state == 1 then
		if BF.GetSkill(self.me) == 90007105 then
			self.MonsterCommonParam.initialSkillList[i].priority = 1
			self.state = 0
		end
	end
end