Behavior910120 = BaseClass("Behavior900120",EntityBehaviorBase)

local BF = BehaviorFunctions

--资源预加载
function Behavior910120.GetGenerates()
	local generates = {}
	return generates
end

function Behavior910120.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end



function Behavior910120:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	
	--被暗杀动作
	self.beAssassin = 91012011
	self.backHited = 91012012
	
	self.MonsterCommonParam.canBeAss = true				  --可以被暗杀

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
	self.MonsterCommonParam.warnSkillId = 91012010            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 90012005         --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 91012010           --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30           --无警告状态时直接进战的距离
	self.MonsterCommonParam.curAlertnessValue = 0             --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100           --最大警戒值
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0              --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				  --技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1				  --技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = true        --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		--技能1：右扫
		{id = 91012001,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 7,           	       --技能cd，单位：秒
			--cd = 7,
			durationFrame = 85,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 5000,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--技能2：远距离冲刺上挑
		{id = 91012002,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 12,       --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			--cd = 12,
			durationFrame = 127,      --技能持续帧数
			frame = 120,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--技能2：原地二连
		{id = 910120021,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 6,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 10,           	       --技能cd，单位：秒
			durationFrame = 125,      --技能持续帧数
			frame = 120,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			--ignoreCommonSkillCd = true
		},

		
		--技能4：飞扑
		{id = 91012004,
			minDistance = 9,         --技能释放最小距离（有等号）
			maxDistance = 15,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 15,           	       --技能cd，单位：秒
			--cd = 20
			durationFrame = 125,      --技能持续帧数
			frame = 30,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		--技能4：后撤飞扑
		{id = 910120051,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 6,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 15,           	       --技能cd，单位：秒
			--20
			durationFrame = 142,      --技能持续帧数
			frame = 120,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			--ignoreCommonSkillCd = true
		},
		
		
		--技能5：后撤大招
		{id = 910120071,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 20,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 45,           	       --技能cd，单位：秒
			durationFrame = 228,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 5000,     --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
			--ignoreCommonSkillCd = true
		},
		
		----技能5：后撤大招真的
		--{id = 910120071,
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 20,       --技能释放最大距离（无等号）
			--angle = 45,              --技能释放角度
			--cd = 45,           	       --技能cd，单位：秒
			--durationFrame = 300,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 2,            --优先级，数值越大优先级越高
			--weight = 1,              --随机权重
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 4000,     --技能释放最高生命万分比（无等号）
			----ignoreCommonSkillCd = true
		--},
		
		--技能61：右爪撕咬二连
		{id = 910120062,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 5.5,       --技能释放最大距离（无等号）
			angle = 45,              --技能释放角度
			cd = 8,           	       --技能cd，单位：秒
			durationFrame = 124,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 5000,     --技能释放最高生命万分比（无等号）
			grade = 10,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
	}

	self.MonsterCommonParam.endureBreakTime=10             --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2               --游荡近距离边界值（小于此距离往后走）
	self.MonsterCommonParam.longRange = 10                  --游荡远距离边界值（小于此距离前走或左右走）
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值（小于此距离跑）
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 3.033        --左右走持续时间
	self.MonsterCommonParam.switchDelayTime = 1.33         --前后走持续时间
	self.MonsterCommonParam.walkDazeTime = 2.134          --待机时间（配stand2时间）
	self.MonsterCommonParam.canRun = true                  --跑步开关
	
	self.MonsterCommonParam.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.minRange = 1                 --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.defaultSkillId = 91012001	   --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 50            --脱战距离（距离出生点）
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true            --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20        --脱战时间
	self.MonsterCommonParam.canNotChase = 50               --追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange    --脱战距离（距离锁定目标）

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.MonsterCommonParam.haveGroup=false
	self.mission = 0
	self.testValue = 0
	--属性参数
	self.ElementList={}
	
	--记录自身
	self.Me = self.instanceId

end

function Behavior910120:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior910120:Update()
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
	--后撤衔接技能检查
	self:BackCombo()
	--刷新战斗目标距离
	self.battletargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.Me,self.MonsterCommonParam.battleTarget)
	BehaviorFunctions.SetEntityValue(self.Me,"cameraParams",910120)	--设置特殊相机
	--if Input.GetKeyUp(KeyCode.Keypad9) then
		--BehaviorFunctions.CastSkillByTarget(self.Me,910120051,self.MonsterCommonParam.battleTarget)
	--end
	
end


function Behavior910120:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end


function Behavior910120:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

function Behavior910120:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.MonsterCommonParam.me and skillId == 90012002 then
		self:SetSkillFrame(90012007)
	elseif instanceId == self.MonsterCommonParam.me and skillId == 90012007 then
		self:SetSkillFrame(90012002)
	end
end

--让指定id的技能进入cd
function Behavior910120:SetSkillFrame(skillId)
	for k = 1, #self.MonsterCommonParam.currentSkillList do
		if self.MonsterCommonParam.currentSkillList[k].id == skillId then
			self.MonsterCommonParam.currentSkillList[k].frame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.currentSkillList[k].cd * 30
		end
	end
end

function Behavior910120:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	--后撤的两种版本会同时进入cd
	if instanceId == self.MonsterCommonParam.me then
		--两种飞扑互相加CD
		if skillId == 910120051 then
			self:SetSkillFrame(91012004)
		elseif skillId == 91012004 then
			self:SetSkillFrame(910120051)
		--两种二连互相加CD
		elseif skillId == 91012002 then
			self:SetSkillFrame(910120021)
		elseif skillId == 910120021 then
			self:SetSkillFrame(91012002)
		--后撤大招加后撤飞扑CD
		elseif skillId == 91012007 then
			self:SetSkillFrame(910120051)
		end
	end
end

function Behavior910120:CheckAngle()
	if self.MonsterCommonParam.battletarget then
		local a = BehaviorFunctions.GetEntityAngle(self.Me,self.MonsterCommonParam.battletarget)
		--左边就是01，右边是02
		if 180 < a < 360 then
			BF.AddSkillEventActiveSign(self.Me,910120401) 
			BF.RemoveSkillEventActiveSign(self.Me,910120402)
		else
			BF.AddSkillEventActiveSign(self.Me,910120402)
			BF.RemoveSkillEventActiveSign(self.Me,910120401)
		end
	end
end

--后撤后衔接技能
function Behavior910120:BackCombo()	
	--隐身后传送点右
	if BF.GetSkillSign(self.Me,910120701) then
		--获取玩家六向位置
		local  p1 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,2,0,2)
		local  p2 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,-2,0,2)
		local  p3 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,2,0,-2)
		local  p4 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,-2,0,-2)
		local  p5 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,0,0,2)
		local  p6 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,0,0,-2)
		
		-- 参数列表
		local params = {p1, p2, p3, p4}
		-- 存储返回下面true 的参数
		local trueParams = {}
		-- 遍历参数并使用 getpos 函数检查
		for i, param in ipairs(params) do
			local L = BF.GetPosAngleWithCamera(param.x, param.y, param.z)
			if 0 < L and L < 45  then
				table.insert(trueParams, param)
			end
		end
		if #trueParams > 0 then
			--math.randomseed(os.time()) -- 设置随机数种子，使每次结果都不相同
			local randomIndex = math.random(1, #trueParams)
			local p = trueParams[randomIndex]
			BF.DoSetPositionP(self.Me, p)
		end
		--朝向玩家放技能
		BF.DoLookAtTargetImmediately(self.Me,self.MonsterCommonParam.battleTarget)
		BF.SetEntityLifeBarVisibleType(self.Me,2)
	end
	
	--隐身后传送点左
	if BF.GetSkillSign(self.Me,910120702) then
		--获取玩家六向位置
		local  p1 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,2,0,2)
		local  p2 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,-2,0,2)
		local  p3 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,2,0,-2)
		local  p4 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,-2,0,-2)
		local  p5 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,0,0,2)
		local  p6 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,0,0,-2)

		-- 参数列表
		local params = {p1, p2, p3, p4}
		-- 存储返回下面true 的参数
		local trueParams = {}
		-- 遍历参数并使用 getpos 函数检查
		for i, param in ipairs(params) do
			local L = BF.GetPosAngleWithCamera(param.x, param.y, param.z)
			if -45 < L and L < 0  then
				table.insert(trueParams, param)
			end
		end
		if #trueParams > 0 then
			--math.randomseed(os.time()) -- 设置随机数种子，使每次结果都不相同
			local randomIndex = math.random(1, #trueParams)
			local p = trueParams[randomIndex]
			BF.DoSetPositionP(self.Me, p)
		end
		--朝向玩家放技能
		BF.DoLookAtTargetImmediately(self.Me,self.MonsterCommonParam.battleTarget)
		BF.SetEntityLifeBarVisibleType(self.Me,2)
	end
	
	--隐身后传送点前
	if BF.GetSkillSign(self.Me,910120703) then
		--获取玩家六向位置
		local  p1 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,-2,0,2)
		local  p2 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,0,0,2)
		local  p3 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,2,0,2)
		local  p4 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,2,0,0)
		local  p5 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,2,0,-2)
		local  p6 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,0,0,-2)
		local  p7 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,-2,0,-2)
		local  p8 = BF.GetEntityPositionOffset(self.MonsterCommonParam.battleTarget,-2,0,0)

		-- 参数列表
		local params = {p1, p2, p3, p4}
		-- 存储返回下面true 的参数
		local trueParams = {}
		-- 遍历参数并使用 getpos 函数检查
		for i, param in ipairs(params) do
			local L = BF.GetPosAngleWithCamera(param.x, param.y, param.z)
			if -10 < L and L < 10  then
				table.insert(trueParams, param)
			end
		end
		if #trueParams > 0 then
			--math.randomseed(os.time()) -- 设置随机数种子，使每次结果都不相同
			local randomIndex = math.random(1, #trueParams)
			local p = trueParams[randomIndex]
			BF.DoSetPositionP(self.Me, p)
		end
		--朝向玩家放技能
		BF.DoLookAtTargetImmediately(self.Me,self.MonsterCommonParam.battleTarget)
		BF.SetEntityLifeBarVisibleType(self.Me,2)
	end
	
	
	--隐藏血条标记
	if BF.GetSkillSign(self.Me,910120502) then
		BF.SetEntityLifeBarVisibleType(self.Me,3)
	end
	
end
--0.self.0

