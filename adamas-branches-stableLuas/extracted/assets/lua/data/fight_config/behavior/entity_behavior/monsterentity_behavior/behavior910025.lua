Behavior910025 = BaseClass("Behavior910025",EntityBehaviorBase)
--资源预加载
function Behavior910025.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function Behavior910025.GetMagics()
	local generates = {900000008,900000009,900000024,900000025,900000107}
	return generates
end

function Behavior910025:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	
	--被暗杀动作
	self.beAssassin = 910025009
	self.backHited = 910025062

	self.MonsterCommonParam.canBeAss = true				--可以被暗杀
	--怪物出生
	self.MonsterCommonParam.haveBornSkill = false           --是否有出生技能
	self.MonsterCommonParam.haveSpecialBornLogic = false    --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil      		   --出生技能id
	self.MonsterCommonParam.initialDazeTime = 2		       --出生发呆时间
	
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil
	
	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true              --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 4.5           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 8           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  12          --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80         --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId =  910025901        --警告技能Id
	self.MonsterCommonParam.tauntSkillId = 910025901         --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	self.MonsterCommonParam.curAlertnessValue = 0        --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100      --最大警戒值

	--技能参数
	self.MonsterCommonParam.difficultyDegree = 0            --难度系数
	self.MonsterCommonParam.initialSkillCd = 1			 --技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5			   --技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false      --技能是否有生命值区间判断
	--技能列表
	self.MonsterCommonParam.initialSkillList = {
		
		--技能1 右手爪击
		{id = 910025001,
			minDistance = 0,			--技能释放最小距离（有等号）
			maxDistance = 6,			--技能释放最大距离（无等号
			angle = 45,					--技能释放角度
			cd = 6,						--技能cd，单位：秒
			durationFrame = 86,			--技能持续帧数
			frame = 0,					--cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,				--优先级，数值越大优先级越高
			weight = 1,             	--随机权重
			isAuto = true,				--是否自动释放
			difficultyDegree = 0,		--难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,       	--技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,    	--技能释放最高生命万分比（无等号）
			grade = 5			--分级系数，高于一定系数的技能释放后进入群组公共cd
		},

		--技能2 助跑飞扑远
		{id = 910025006,
			minDistance = 8,			--技能释放最小距离（有等号）
			maxDistance = 16,			--技能释放最大距离（无等号
			angle = 70,					--技能释放角度
			cd = 20,						--技能cd，单位：秒
			durationFrame = 187,			--技能持续帧数
			frame = 0,					--cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,				--优先级，数值越大优先级越高
			weight = 1,             	--随机权重
			isAuto = true,				--是否自动释放
			difficultyDegree = 0,		--难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,       	--技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,    	--技能释放最高生命万分比（无等号）
			grade = 5		--分级系数，高于一定系数的技能释放后进入群组公共cd
		},

		--技能3 助跑飞扑近
		{id = 910025007,
			minDistance = 5,			--技能释放最小距离（有等号）
			maxDistance = 8,			--技能释放最大距离（无等号
			angle = 45,					--技能释放角度
			cd = 20,						--技能cd，单位：秒
			durationFrame = 173,			--技能持续帧数
			frame = 60,					--cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,				--优先级，数值越大优先级越高
			weight = 1,             	--随机权重
			isAuto = true,				--是否自动释放
			difficultyDegree = 0,		--难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,       	--技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,    	--技能释放最高生命万分比（无等号）
			grade = 5		--分级系数，高于一定系数的技能释放后进入群组公共cd
		},

		--技能4 甩尾后撤
		{id = 910025008,
			minDistance = 0,			--技能释放最小距离（有等号）
			maxDistance = 6,			--技能释放最大距离（无等号
			angle = 45,					--技能释放角度
			cd = 12,						--技能cd，单位：秒
			durationFrame = 88,			--技能持续帧数
			frame = 150,					--cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 2,				--优先级，数值越大优先级越高
			weight = 1,             	--随机权重
			isAuto = false,				--是否自动释放
			difficultyDegree = 0,		--难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,       	--技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,    	--技能释放最高生命万分比（无等号）
			grade = 0,		--分级系数，高于一定系数的技能释放后进入群组公共cd
			ignoreCommonSkillCd = true
		},

		--技能5 右手爪击接背砸
		{id = 910025010,
			minDistance = 0,			--技能释放最小距离（有等号）
			maxDistance = 6,			--技能释放最大距离（无等号
			angle = 45,					--技能释放角度
			cd = 6,						--技能cd，单位：秒
			durationFrame = 182,			--技能持续帧数
			frame = 150,					--cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,				--优先级，数值越大优先级越高
			weight = 1,             	--随机权重
			isAuto = true,				--是否自动释放
			difficultyDegree = 0,		--难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,       	--技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,    	--技能释放最高生命万分比（无等号）
			grade = 5		--分级系数，高于一定系数的技能释放后进入群组公共cd
		},

		--精英石龙专属技能
		--专属技能1 钻入地面+潜行，最后钻地攻击版
		{id = 910025013,
			minDistance = 8,
			maxDistance = 20,
			angle = 90,
			cd = 30,
			durationFrame = 240,
			frame = 0,
			priority = 10,
			weight = 1,              --随机权重
			isAuto = true,
			difficultyDegree = 0,
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 0		--分级系数，高于一定系数的技能释放后进入群组公共cd
		},

		--专属技能2 钻出地面
		{id = 910025014,
			minDistance = 0,
			maxDistance = 2,
			angle = 90,
			cd = 0,
			durationFrame = 0,
			frame = 0,
			priority = 0,
			weight = 1,              --随机权重
			isAuto = false,
			difficultyDegree = 0,
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5		--分级系数，高于一定系数的技能释放后进入群组公共cd
		},

		--专属技能3 钻入地面+潜行，最后跳砸攻击版
		{id = 910025015,
			minDistance = 8,
			maxDistance = 20,
			angle = 90,
			cd = 30,
			durationFrame = 240,
			frame = 300,
			priority = 10,
			weight = 1,              --随机权重
			isAuto = true,
			difficultyDegree = 0,
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 0		--分级系数，高于一定系数的技能释放后进入群组公共cd
		},

		--专属技能4 跳砸攻击
		{id = 910025016,
			minDistance = 0,
			maxDistance = 2,
			angle = 90,
			cd = 0,
			durationFrame = 0,
			frame = 0,
			priority = 0,
			weight = 1,              --随机权重
			isAuto = false,
			difficultyDegree = 0,
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5		--分级系数，高于一定系数的技能释放后进入群组公共cd
		},

	}
	
	self.MonsterCommonParam.endureBreakTime=10           --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 3                  --游荡近距离边界值
	self.MonsterCommonParam.longRange = 20                  --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.2                 --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.333       --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.167        --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1.5             --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false          --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 910025001		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 20               --视野范围，不在视野范围内会进行转向
	
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
	
	--自己用的参数
	self.bronSkillState = 0
	--self.specialSkillId = self.MonsterCommonParam.bornSkillId + 1
	
	
	--强制打断
	self.startTime = nil
	self.limitTime = 5
end

function Behavior910025:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end

function Behavior910025:Update()
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
	
	
	--根据远扑、钻地技能是否在冷却，决定能不能放甩尾技能
	local num = 0
	for i=1, #self.MonsterCommonParam.currentSkillList do
		if self.MonsterCommonParam.currentSkillList[i].id == 910025008 then
			num = i
			self.MonsterCommonParam.currentSkillList[i].isAuto = false
		end
	end
	if num ~= 0 then
		for i=1, #self.MonsterCommonParam.currentSkillList do
			if self.MonsterCommonParam.currentSkillList[i].id == 910025006 or self.MonsterCommonParam.currentSkillList[i].id == 910025013 or self.MonsterCommonParam.currentSkillList[i].id == 910025015 then
				if self.MonsterCommonParam.currentSkillList[i].frame <= self.MonsterCommonParam.myFrame then
					self.MonsterCommonParam.currentSkillList[num].isAuto = true
				end
			end
		end
	end
	
	--快捷键，注意屏蔽
	--if Input.GetKeyUp(KeyCode.Keypad5) then
		--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,910025008,self.MonsterCommonParam.battleTarget)
	--elseif Input.GetKeyUp(KeyCode.Keypad6) then
		--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,910025013,self.MonsterCommonParam.battleTarget)
	--elseif Input.GetKeyUp(KeyCode.Keypad7) then
		--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,910025014,self.MonsterCommonParam.battleTarget)
	--elseif Input.GetKeyUp(KeyCode.Keypad8) then
		--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,910025015,self.MonsterCommonParam.battleTarget)
	--elseif Input.GetKeyUp(KeyCode.Keypad9) then
		--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,910025016,self.MonsterCommonParam.battleTarget)
	--end
	
	
	
	--if self.MonsterCommonParam.initialState == self.MonsterCommonParam.InitialStateEnum.Special then
		--if  self.bronSkillState == 0 then
			--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.bornSkillId,self.MonsterCommonParam.battleTarget)
			--self.bronSkillState = 1
		--end
		--if self.bronSkillState == 1 and self.MonsterCommonParam.battleTargetDistance < 5 then
			--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.specialSkillId,self.MonsterCommonParam.battleTarget)
			--self.MonsterCommonParam.initialState = self.MonsterCommonParam.InitialStateEnum.Done
		--end
	--end
	
	-- --角色是否有潜行
	-- if BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
	-- 	self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
	-- 	self.MonsterCommonParam.warnShortRange = 3
	-- 	self.MonsterCommonParam.warnLongRange = 3
	-- else
	-- 	self.MonsterCommonParam.warnLimitRange = 3           --近身警告距离
	-- 	self.MonsterCommonParam.warnShortRange = 6
	-- 	self.MonsterCommonParam.warnLongRange = 12
	-- end
	
	--旧逻辑，潜地超时判断，超时则打断
	--if self.startTime and (self.startTime - BehaviorFunctions.GetFightFrame()/30) >= self.limitTime then
		--BehaviorFunctions.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
		--BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,910025012,self.MonsterCommonParam.battleTarget)
		----特殊處理：清除預備技能列表
		--self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
		--self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default	
		--self.startTime = nil
	--end
end

function Behavior910025:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior910025:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

function Behavior910025:BreakSkill(instanceId,skillId,skillSign,skillType)
	--潜地之后自动接破土而出
	if  skillId == 910025013 and instanceId == self.MonsterCommonParam.me then
		skillId = nil
		BehaviorFunctions.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
		BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,910025014,self.MonsterCommonParam.battleTarget)
		--特殊處理：清除預備技能列表
		self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
		self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	end
	if  skillId == 910025015 and instanceId == self.MonsterCommonParam.me then
		skillId = nil
		BehaviorFunctions.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
		BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,910025016,self.MonsterCommonParam.battleTarget)
		--特殊處理：清除預備技能列表
		self.MonsterCommonBehavior.MonsterCastSkill.prepareSkillList = {}
		self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	end
end


------------------------------碰撞移除恢复保底------------------------------
function Behavior910025:CheckEntityState(instanceId,state)
	if instanceId == self.MonsterCommonParam.me and state ~= FightEnum.Entitystate.Skill then
		BehaviorFunctions.RemoveEntitySign(instanceId,910025001)
	end
end		


function Behavior910025:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	
	--旧逻辑，用于记录潜地开始时间，超时则会打断
	--if instanceId == self.MonsterCommonParam.me and skillId == 910025011 then
		--self.startTime = BehaviorFunctions.GetFightFrame()/30
	--end

	--if instanceId == self.MonsterCommonParam.me and not (skillId == 910025011 or skillId == 910025012) then
		--BehaviorFunctions.RemoveEntitySign(instanceId,910025001)
	--end
	
	--扑击的两种距离版本会同时进入cd
	if instanceId == self.MonsterCommonParam.me then
		--两种扑击
		if skillId == 910025006 then
			self:SetSkillFrame(910025007)
		elseif skillId == 910025007 then
			self:SetSkillFrame(910025006)
			--两种爪击
		elseif skillId == 910025001 then
			self:SetSkillFrame(910025010)
		elseif skillId == 910025010 then
			self:SetSkillFrame(910025001)
			--两种钻地
		elseif skillId == 910025013 then
			self:SetSkillFrame(910025015)
		elseif skillId == 910025015 then
			self:SetSkillFrame(910025013)
		end
	end
end

--让指定id的技能进入cd
function Behavior910025:SetSkillFrame(skillId)
	for k = 1, #self.MonsterCommonParam.currentSkillList do
		if self.MonsterCommonParam.currentSkillList[k].id == skillId then
			self.MonsterCommonParam.currentSkillList[k].frame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.currentSkillList[k].cd * 30
		end
	end
end


function Behavior910025:AddEntitySign(instanceId,sign)
	--潜入地底移除部位碰撞逻辑
	if instanceId == self.MonsterCommonParam.me and sign == 910025001 then
		local isOpen = BehaviorFunctions.GetPartEnableCollision(self.MonsterCommonParam.me,"Body")
		if isOpen then
			BehaviorFunctions.SetPartEnableCollision(self.MonsterCommonParam.me,"Body",false)
		end
	end
end

function Behavior910025:RemoveEntitySign(instanceId,sign)
	--潜入地底移除部位碰撞逻辑
	if instanceId == self.MonsterCommonParam.me and sign == 910025001 then
		local isOpen = BehaviorFunctions.GetPartEnableCollision(self.MonsterCommonParam.me,"Body")
		if isOpen == false then
			BehaviorFunctions.SetPartEnableCollision(self.MonsterCommonParam.me,"Body",true)
		end
	end
end