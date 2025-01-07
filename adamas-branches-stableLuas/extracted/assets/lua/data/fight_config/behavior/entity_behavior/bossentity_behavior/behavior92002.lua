Behavior92002 = BaseClass("Behavior92002",EntityBehaviorBase)
--资源预加载
function Behavior92002.GetGenerates()
	local generates = {}
	return generates
end
--mgaic预加载
function Behavior92002.GetMagics()
	--local generates = {900000001,900000035,900000008,900000009,900000010,900000007,1001990}
	--return generates
end

function Behavior92002:Init()
	self.me = self.instanceId--记录自身
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	self.time = nil --记录游戏时间
	
	--点位信息记录
	self.myBornPos = nil
	self.myPos = nil
	self.centerPos = nil
	
	--怪物行为类型
	self.BehaEnum = {
		Default = 0,
		Idle = 1,
		CastingSkill = 2,
		Turn = 3,
		Moving = 4,
		Stun = 5,
		Death = 6,
	}
	
	--游荡参数
	self.shortRange = 12                 --游荡近距离边界值
	self.longRange = 15                  --游荡远距离边界值
	self.maxRange = 40                   --游荡超远距离边界值
	self.minRange = 12                   --极限近身距离，追杀模式最小追踪距离
	
	
	--距离范围枚举
	self.BattleRangeEnum = {
		Default = 0,
		Short = 1,
		Mid = 2,
		Long = 3,
		Far = 4
	}
	
	self.myBeha = self.BehaEnum.Default
	
	--移动类型枚举
	self.subMoveTypeEnum = {
		Run = 1,
		Walk = 2,
		WalkBack = 3,
		WalkLeft = 4,
		WalkRight = 5,	
		Idle = 6,
	}
	
	--方向枚举
	self.dirEnum = 
	{
		Any = 1,
		FullFront = 2,
		FullBack = 3,
		FullLeft = 4,
		FullRight = 5,
		Front = 6,
		Back = 7,
		Left = 8,
		Right = 9,
		FrontLeft = 10,
		FrontRight = 11,
		BackLeft = 12,
		BackRight = 13,
	}
	
	--方向角度判断
	self.directionList =
	{
	--全向
		[self.dirEnum.Any] = { minAngel = 0 , maxAngel = 360},
	--四向位置
		--全前方
		[self.dirEnum.FullFront] = {minAngel = 270 , maxAngel = 90},
		--全后方
		[self.dirEnum.FullBack] = {minAngel = 90 , maxAngel = 270},
		--全左方
		[self.dirEnum.FullLeft] = {minAngel = 180 , maxAngel = 0},
		--全右方
		[self.dirEnum.FullRight] = {minAngel = 0 , maxAngel = 180},
	--八向精准位置
		--前方
		[self.dirEnum.Front] = {minAngel = 337.5 , maxAngel = 22.5},
		--后方
		[self.dirEnum.Back] = { minAngel = 157.5 , maxAngel = 202.5},
		--左侧
		[self.dirEnum.Left] = { minAngel = 247.5 , maxAngel = 292.5},
		--右侧
		[self.dirEnum.Right] = {minAngel = 67.5 , maxAngel = 112.5},
		--左前
		[self.dirEnum.FrontLeft] = { minAngel = 292.5 , maxAngel = 337.5},		
		--左后
		[self.dirEnum.BackLeft] = { minAngel = 202.5 , maxAngel = 247.5},
		--右前
		[self.dirEnum.FrontRight] = {minAngel = 22.5 , maxAngel = 67.5 },
		--右后
		[self.dirEnum.BackRight] = { minAngel = 112.5 , maxAngel = 157.5},
	}
	
	self.currentDir = {}
	
	--方向转向动作
	self.rotateList =
	{
		--右转45度动作
		{id = 92002002 ,
			dir = self.dirEnum.FrontRight,
			durationFrame = 35
		},
		--左转45度动作
		{id = 92002003 ,
			dir = self.dirEnum.FrontLeft,
			durationFrame = 35
		},
		--右转90度动作
		{id = 92002004 ,
			dir = self.dirEnum.Right,
			durationFrame = 35
		},
		--左转90度动作
		{id = 92002005 ,
			dir = self.dirEnum.Left,
			durationFrame = 35
		},
		--右转135度动作
		{id = 92002006 ,
			dir = self.dirEnum.BackRight,
			durationFrame = 35
		},
		--左转135度动作
		{id = 92002007 ,
			dir = self.dirEnum.BackLeft,
			durationFrame = 35
		},
		--倒转180度动作
		{id = 92002008 ,
			dir = self.dirEnum.Back,
			durationFrame = 52
		},
	}
	
	--普通技能列表
	self.normalSkillList = 
	{
		--铁山靠：左
		{id = 92002054 ,
			checkType = "square",	 --技能检查方式（圆、方）
			wide = 10,				 --检查方块宽度度
			hight = 6,				 --检查方块高度
			angle = 270,			 --实体对应角度（仅用于方块检查）
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 23,         --技能释放最大距离（无等号）
			dir = self.dirEnum.FullLeft,
			durationFrame = 130,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},

		--铁山靠：右
		{id = 92002055 ,
			checkType = "square",	 --技能检查方式（圆、方）
			wide = 10,				 --检查方块宽度度
			hight = 6,				 --检查方块高度
			angle = 90,				 --实体对应角度（仅用于方块检查）
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 23,         --技能释放最大距离（无等号）
			dir = self.dirEnum.FullRight,
			durationFrame = 130,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
		
		--左转横扫45
		{id = 92002038 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			dir = self.dirEnum.FrontLeft,
			durationFrame = 85,      --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},

		--右转横扫45
		{id = 92002039 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			dir = self.dirEnum.FrontRight,
			durationFrame = 85,      --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
		
		--左转横扫90
		{id = 92002043 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Left,
			durationFrame = 80,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},

		--右转横扫90
		{id = 92002044 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Right,--角度修正面向
			durationFrame = 80,      --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},		
		
		----起飞转身喷火
		--{id = 92002040 ,
			--checkType = "circle",	 --技能检查方式（圆、方）
			--minDistance = 0,         --技能释放最小距离（有等号）
			--maxDistance = 15,        --技能释放最大距离（无等号）
			--dir = self.dirEnum.Back,
			--durationFrame = 170,     --技能持续帧数
			--phase = 1,		 	 	 --技能使用阶段，数字大则包含小的）
			--times = 0,				 --使用次数
		--},

		--向前扑杀
		{id = 92002056 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 15,         --技能释放最小距离（有等号）
			maxDistance = 40,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Front,
			durationFrame = 123,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},	
		
		--拍地板二连
		{id = 92002042 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 25,        --技能释放最大距离（无等号）
			dir = self.dirEnum.FullFront,
			durationFrame = 138,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},	
		
		--近战扇形吐火
		{id = 92002034 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			dir = self.dirEnum.FullFront,
			durationFrame = 125,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
		
		--甩尾攻击
		{id = 92002041 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 10,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Any,
			durationFrame = 185,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
		
		--转身翅膀戳地
		{id = 920020451 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 25,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Back, --角度修正面向
			durationFrame = 80,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
	}
	
	--特殊技能列表
	self.specialSkillList = 
	{	
		--贝露贝特砸地板
		{id = 92002073 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 15,         --技能释放最大距离（无等号）
			dir = self.dirEnum.FullFront,
			durationFrame = 143,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},			

		--绝技：滑翔撞击
		{id = 92002098 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 25,         --技能释放最小距离（有等号）
			maxDistance = 100,        --技能释放最大距离（无等号）
			dir = self.dirEnum.FullFront,
			durationFrame = 304,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
		
		--嘶吼落雷
		{id = 92002001 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 40,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Any,	 --允许的释放方向
			durationFrame = 150,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
		
		--跳入传送门
		{id = 92002019 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 99,        --技能释放最大距离（无等号）
			dir = self.dirEnum.Any,	 --允许的释放方向
			durationFrame = 176,     --技能持续帧数
			phase = 2,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
		
		--贝露贝特射箭
		{id = 92002072 ,
			checkType = "circle",	 --技能检查方式（圆、方）
			minDistance = 15,         --技能释放最小距离（有等号）
			maxDistance = 50,         --技能释放最大距离（无等号）
			dir = self.dirEnum.FullFront,
			durationFrame = 135,     --技能持续帧数
			phase = 1,		 	 	 --技能使用阶段，数字大则包含小的
			times = 0,				 --使用次数
		},
					

	}
	
	--伤害组落雷参数
	self.thunderVal1 = 
	{	
		--目标
		target = self.battleTarget,
		--数量
		num  = 3,
		--释放间隔
		interval = {18,25},
		--释放范围
		rangeDistance = {0,15},
		--角度
		angle = {0,360},
		--最小距离间隔
		disBetweenThunder = 7
	}
	
	--氛围组落雷参数
	self.thunderVal2 =
	{
		--目标
		target = self.me,
		--数量
		num  = 9,
		--释放间隔
		interval = {8,10},
		--释放范围
		rangeDistance = {30,40},
		--角度
		angle = {0,360},
		--最小距离间隔
		disBetweenThunder = 10
	}
	
	--伤害组陨石参数
	self.meteroVal1 =
	{
		--目标
		target = self.battleTarget,
		--数量
		num  = 8,
		--释放间隔
		interval = {40,50},
		--释放范围
		rangeDistance = {0,5},
		--角度
		angle = {0,360},
		--最小距离间隔
		disBetweenThunder = 0
	}
	
	--氛围组陨石参数
	self.meteroVal2 =
	{
		--目标
		target = self.me,
		--数量
		num  = 12,
		--释放间隔
		interval = {30,45},
		--释放范围
		rangeDistance = {20,40},
		--角度
		angle = {0,360},
		--最小距离间隔
		disBetweenThunder = 10
	}
	
	--可爱星星飞天撞参数
	self.flyAngle = 70
	self.flyDistance = 600
	self.flySpeed = 5 -- m/s
	
	--用于记录一些特殊状态
	self.dragonBreath = false
	self.dragonBreathLoopFrame = 120
	self.powerUp = false
	self.powerUpLimitTime = 0
	self.powerUpDuration = 999
	self.powerUpCD = 120
	self.powerUpFrame = 0
	self.poweUpSkill = false
	self.powerUpDelayCall = nil
	self.phase = 1
	
	--部位血量记录
	self.totalHealth = nil
	self.partProtect = false	--眩晕后的部位保护开关
	self.partProtectFrame = 400 --眩晕后的部位保护时长
	self.stunFrame = 90 --瘫痪倒地的时长
	
	--是否停止行为树
	self.stopBehavior = false
	
	--骨骼抖动等级
	self.shakeRatio = 0
	
	--多点锁定挂点信息
	self.lockGroupInfo =
	{
		[1] = 
		{
			groupName = "TargetGroup1",
			targetInfo =
			{
				[1] = {index = 1 , bindName = "LockCaseHead" , isOpen = true ,weight = 0.8 , dis = nil , weightMutiply = 1.5},
				[2] = {index = 2 , bindName = "LockCaseBody" , isOpen = true ,weight = 0.2 , dis = nil , weightMutiply = nil },
				[3] = {index = 3 , bindName = "LockCaseCore" , isOpen = false ,weight = 0.2 , dis = nil , weightMutiply = 10},
				[4] = {index = 4 , bindName = "LockCaseTail" , isOpen = false ,weight = 0.8 , dis = nil , weightMutiply = nil},
				[5] = {index = 5 , bindName = "LockCaseBeilubeite" , isOpen = false ,weight = 0.8 , dis = nil , weightMutiply = 10},
			}
		},
	}
	
	--普通技能释放次数
	self.normalSkillCount = 0
	
	--初始技能
	self.initialSkill = false
	
	--跳跃过一次后不会立刻进行第二次跳跃
	self.moveCD = false
	
	--所有的延迟被记录在这里，如果怪物在延迟执行前死亡则全部移除
	self.delayCallList = {}
	
	--设置下一次的传送点
	self.telePos = nil
	
	--特殊技能释放频率
	self.specialSkillFrequence = 1
	
	--是否处于合体状态
	self.beenCombination = false

end

function Behavior92002:LateInit()
	
end

function Behavior92002:Update()
	
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	self.myPos = BehaviorFunctions.GetPositionP(self.me)--记录当前点位
	self.centerPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,3.0,0)--记录当前中心点位
	self.battleTargetDistance = BehaviorFunctions.GetTransformDistance(self.battleTarget,"Root",self.me,"Center") --计算中心点位的距离
	self.currentDir = self:ReturnDirection(self.battleTarget) --返回当前的方向列表
	self.time = BehaviorFunctions.GetEntityFrame(self.me)
	
	--获取是否有合体对象
	self.beenCombination = BehaviorFunctions.GetCombinationTargetId(self.me)
	
	--获取锁定挂点距离
	self:GetTargetGroupDistance(self.lockGroupInfo)
	
	--根据锁定挂点距离设置锁定点权重
	self:SetTargetGroupWeight(self.lockGroupInfo)
	
	--创建初始buff
	if self.initBuff ~= true then
		self.totalHealth = BehaviorFunctions.GetEntityAttrVal(self.me,1001)
		self.myBornPos = TableUtils.CopyTable(BehaviorFunctions.GetPositionP(self.me))
		BehaviorFunctions.AddFightTarget(self.me,self.battleTarget)--添加索敌
		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,9200201,true)--修改强锁参数
		BehaviorFunctions.AddBuff(self.me,self.me,1001995)--龙眼和胸口效果
		BehaviorFunctions.DoMagic(self.me,self.me,900000001)--免疫受击效果
		BehaviorFunctions.DoMagic(self.me,self.me,900000035)--免疫强制位移效果
		BehaviorFunctions.DoMagic(self.me,self.me,900000058)--免疫强制眩晕效果
		
		--添加BossUI
		BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.me)
		--添加boss血条
		if not BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.AddEntitySign(1,10000020,-1)
		end
		--贝露贝特不传入boss血条
		if self.beenCombination then
			if not BehaviorFunctions.HasEntitySign(self.beenCombination,10000031) then
				BehaviorFunctions.AddEntitySign(self.beenCombination,10000031,-1)
			end
		end		
		self.initBuff = true
	end	
	
	--接收外部传来的参数
	--是否停止行为树
	if BehaviorFunctions.GetEntityValue(self.me,"Stop") == true then
		self.stopBehavior = true
	elseif BehaviorFunctions.GetEntityValue(self.me,"Stop") == false then
		self.stopBehavior = false
	end
	
	--眩晕时长的调整
	if BehaviorFunctions.GetEntityValue(self.me,"StunFrame")  then
		self.stunFrame = BehaviorFunctions.GetEntityValue(self.me,"StunFrame")
	end

	--停止行为树处理
	if self.stopBehavior == true then
		return
	end
	
	--强制移除镜头强锁效果
	if BehaviorFunctions.HasEntitySign(self.me,92002008) then
		self:SetPlayerForceLock(nil)
	else
		--镜头强锁标记（无标记时进入弱锁定状态）
		if BehaviorFunctions.HasEntitySign(self.me,92002006) then
			if BehaviorFunctions.HasEntitySign(1,10000007) then
				BehaviorFunctions.RemoveEntitySign(1,10000007)--移除强锁标签(进入弱锁定状态)
			end
		else
			if not BehaviorFunctions.HasEntitySign(1,10000007) then
				BehaviorFunctions.AddEntitySign(1,10000007,-1,false)--添加强锁标签（恢复可强锁定）
			end
		end
	end
	
	--镜头强锁切换部位效果
	if not BehaviorFunctions.HasEntitySign(self.me,10000024) then
		BehaviorFunctions.AddEntitySign(self.me,10000024,-1,false)--添加强锁切换效果
	end
	
	--多部位怪物搜索相关标记：10000022
	if not BehaviorFunctions.HasEntitySign(self.me,10000022) then
		BehaviorFunctions.AddEntitySign(self.me,10000022,-1)
	end
	
	--龙进入飞空状态或者吸气状态，核心可以遭到损伤
	if BehaviorFunctions.HasEntitySign(self.me,92002003) == true
	or BehaviorFunctions.HasEntitySign(self.me,92002007) == true then
		--如果还没开启核心
		if self.dragonBreath == false then
			--开启核心锁定，关闭其他部位锁定
			self.lockGroupInfo[1].targetInfo[3].isOpen = true
			--允许核心累积部位伤害
			BehaviorFunctions.SetHurtPartDamageEnable(self.me,"Core",true)
			self.dragonBreath = true
		end
	else
		--如果处于核心开启状态
		if self.dragonBreath == true then
			self.dragonBreath = false
			--关闭核心锁定
			self.lockGroupInfo[1].targetInfo[3].isOpen = false
			--关闭核心累积部位伤害
			BehaviorFunctions.SetHurtPartDamageEnable(self.me,"Core",false)
		end
	end
	
	--滑翔状态障碍物检测
	if BehaviorFunctions.GetSkillSign(self.me,920020981) then
		local dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget,2)
		local result = self:CheckObstacles(self.me,5,self.dirEnum.Front,2)
		if result == true then
			BehaviorFunctions.CastSkillByTarget(self.me,92002099,self.battleTarget)
			--BehaviorFunctions.BreakSkill(self.me)
		elseif dis <= 1 then
			BehaviorFunctions.CastSkillByTarget(self.me,92002099,self.battleTarget)
			--BehaviorFunctions.BreakSkill(self.me)
		end
	end
	
	if BehaviorFunctions.GetSkillSign(self.me,92002102) then
		--技能42的派生技能
		if self.battleTargetDistance <= 10 then
			--BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillByTarget(self.me,920020421,self.battleTarget)
		end
	end

		--技能45的派生技能
	if BehaviorFunctions.GetSkillSign(self.me,92002103) then
		if self.battleTargetDistance > 12 and self.currentDir[2] == self.dirEnum.FullFront then
			--BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillByTarget(self.me,920020452,self.battleTarget)
		end
	end
		
	--不可操作时，不执行下列行为
	if not BehaviorFunctions.CanCtrl(self.me) then
		return
	end
	
	--根据不同阶段释放不同技能
	--开场释放龙吼
	if self.initialSkill == false then
		if BehaviorFunctions.CanCastSkill(self.me) then
			--强制玩家锁定龙
			self:SetPlayerForceLock(self.me,"Head","TargetGroup1")
			BehaviorFunctions.CastSkillByTarget(self.me,92002201,self.battleTarget)
			self.initialSkill = true
		end
	else
		--技能循环逻辑
		if BehaviorFunctions.CanCastSkill(self.me) then
			local currentLife = BehaviorFunctions.GetEntityAttrValueRatio(self.me,1001) / 100
			--阶段判断
			if currentLife < 50 and self.phase < 2 then
				--释放吸气强化
				BehaviorFunctions.CastSkillByTarget(self.me,92002009,self.battleTarget )
				self.phase = 2
				return
			end
			self:TestBeha()
		else
			LogError("cant")
		end
	end
	
	----技能测试用按键监听（按R）
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
		--if BehaviorFunctions.CanCastSkill(self.me)  then
			----BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
		----LogError(BehaviorFunctions.GetEntityBonesAngle(self.me, "Center", self.battleTarget, "Root"))
			--BehaviorFunctions.CastSkillByTarget(self.me,92002019,self.battleTarget)
			----BehaviorFunctions.AddBuff(self.me,2,1201004)
			----self:JumpOut(50)
		--end
	--end	
	----技能测试用按键监听（按R）
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump) then
		--if BehaviorFunctions.CanCastSkill(self.me)  then
			--BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
		--end
	--end
end
--------------------------------------------------回调函数----------------------------------------------------------------------------------------
--技能帧事件创建实体回调
function Behavior92002:KeyFrameAddEntity(instanceId,entityId)
	if entityId == 92002021003 then
		self:SetPlayerForceLock(instanceId,"root","root")
	end
end

--添加buff
function Behavior92002:AddBuff(entityInstanceId, buffInstanceId,buffId)
	if entityInstanceId == self.me and self.beenCombination then
		--获得切割特效时，对合体角色也添加一个切割特效
		if buffId == 1020008 then
			BehaviorFunctions.AddBuff(self.me,self.beenCombination,1020008)
		end
	end
end

--移除buff
function Behavior92002:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if entityInstanceId == self.me and self.beenCombination then
		--获得切割特效时，对合体角色也添加一个切割特效
		if buffId == 1020008 then
			BehaviorFunctions.RemoveBuff(self.beenCombination,1020008)
		end
	end
end

--怪物死亡后处理
function Behavior92002:Death(instanceId,isFormationRevive)
	if instanceId == self.me then
		BehaviorFunctions.RemoveFightTarget(self.me,self.battleTarget)
		--怪物死亡时移除强锁标签
		if BehaviorFunctions.HasEntitySign(1,10000007) then
			BehaviorFunctions.RemoveEntitySign(1,10000007)
			BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,1101,true)--改回强锁参数
		end
		--怪物死后，移除强锁切换标签
		if BehaviorFunctions.HasEntitySign(self.me,10000024) then
			BehaviorFunctions.RemoveEntitySign(self.me,10000024)
		end
		--怪物死后，移除Boss血条标签
		if BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.RemoveEntitySign(1,10000020)
		end
		--移除所有delayCall
		for i,v in ipairs(self.delayCallList) do
			BehaviorFunctions.RemoveDelayCall(v)
		end
	end
end

--怪物释放技能判断
function Behavior92002:CastSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		if self.beenCombination then
			--让贝露贝特协同释放射箭
			if skillId == 92002072 then
				BehaviorFunctions.CastSkillByTarget(self.beenCombination,92001072,self.battleTarget)
				--让贝露贝特协同释放砸地板
			elseif skillId == 92002073 then
				BehaviorFunctions.CastSkillByTarget(self.beenCombination,92001073,self.battleTarget)
			end
		end
	end
end

--技能结束判断
function Behavior92002:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		--注视ik开始
		BehaviorFunctions.SetLookIKEnable(self.me,true)		
		--绝技技能接续
		if skillId == 92002098 then
			BehaviorFunctions.CastSkillByTarget(self.me,92002099,self.battleTarget)
		end
	end
end

--技能打断判断
function Behavior92002:BreakSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		----注视ik开始
		--BehaviorFunctions.SetLookIKEnable(self.me,true)
		--BehaviorFunctions.SetLookIKTarget(self.me,self.battleTarget)
		--绝技技能接续
		--if skillId == 92002098 then
			--BehaviorFunctions.CastSkillByTarget(self.me,92002099,self.battleTarget)
		--end
	end
end

function Behavior92002:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local bulletEntityID = BehaviorFunctions.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.battleTarget and hitInstanceId == self.me then
		--通用跳反子弹ID
		if bulletEntityID == 1000000019 then
			--左轻受击动作
			BehaviorFunctions.CastSkillByTarget(self.me,92002202,self.battleTarget)
		end
		if attackType == FightEnum.EAttackType.Air then
			--大受击后退硬直
			BehaviorFunctions.CastSkillByTarget(self.me,92002018,self.battleTarget)
		end
	end
end

--实体标记进入判断
function Behavior92002:AddEntitySign(instanceId,sign)
	if instanceId == self.me then
		--进入瘫痪状态时，播放瘫倒在地动作
		if sign == 92002001  then
			--开启贝露贝特锁定
			self.lockGroupInfo[1].targetInfo[5].isOpen = true
			----设置龙的碰撞可以上去
			--BehaviorFunctions.SetCollisionLayer(self.me,FightEnum.Layer.Terrain)
			----关掉大碰撞盒
			--BehaviorFunctions.SetPartEnableCollision(self.me,"Collider",false)
			----贝露贝特部位搜索开启
			--BehaviorFunctions.SetEntityPartSearch(self.me,"CombinationRoot",true)
			--部位保护开启
			self:PartProtect("Head",self.partProtectFrame)
			--标记为瘫痪倒地状态
			self.myBeha = self.BehaEnum.Stun
			--开始瘫痪恢复倒计时
			local delayId = BehaviorFunctions.AddDelayCallByFrame(self.stunFrame,BehaviorFunctions,BehaviorFunctions.AddEntitySign,self.me,92002002,1)
			table.insert(self.delayCallList,delayId)
			--关闭核心搜索和锁定
			if BehaviorFunctions.CheckEntityPartSearch(self.me,"Core") == true then
				BehaviorFunctions.SetEntityPartSearch(self.me,"Core",false)
			end
			if BehaviorFunctions.CheckEntityPartLock(self.me,"Core") == true then
				BehaviorFunctions.SetEntityPartLock(self.me,"Core",false)
			end
			BehaviorFunctions.CastSkillByTarget(self.me,92002014,self.battleTarget)
		end
		--瘫倒在地动作结束时，播放起身动作
		if sign == 92002002 then
			--关闭贝露贝特锁定
			self.lockGroupInfo[1].targetInfo[5].isOpen = false
			--恢复为待机状态
			self.myBeha = self.BehaEnum.Idle
			----设置龙的碰撞不可上去
			--BehaviorFunctions.SetCollisionLayer(self.me,FightEnum.Layer.EntityCollision)
			----开启大碰撞盒
			--BehaviorFunctions.SetPartEnableCollision(self.me,"Collider",true)
			----贝露贝特部位搜索关闭
			--BehaviorFunctions.SetEntityPartSearch(self.me,"CombinationRoot",false)
			--起身动作
			BehaviorFunctions.CastSkillByTarget(self.me,92002015,self.battleTarget)
		end
		
		--进入吸气状态
		if sign == 92002003 and self.dragonBreath == false then
			--开启核心搜索和锁定
			if BehaviorFunctions.CheckEntityPartSearch(self.me,"Core") == false then
				BehaviorFunctions.SetEntityPartSearch(self.me,"Core",true)
			end
			self.powerUpDelayCall = BehaviorFunctions.AddDelayCallByFrame(self.dragonBreathLoopFrame,BehaviorFunctions,BehaviorFunctions.AddEntitySign,self.me,92002004,1,true)
		end
		
		--检测到吸气过程结束,进入狂化状态
		if sign == 92002004 and self.dragonBreath ==  true then
			--关闭核心搜索和锁定
			if BehaviorFunctions.CheckEntityPartSearch(self.me,"Core") == true then
				BehaviorFunctions.SetEntityPartSearch(self.me,"Core",false)
			end
			--吸气完成动作
			BehaviorFunctions.CastSkillByTarget(self.me,92002012,self.battleTarget)
			--BehaviorFunctions.AddBuff(self.me,self.me,1001999)--添加强化特效
			self.powerUpLimitTime = BehaviorFunctions.GetEntityFrame(self.me) + self.powerUpDuration * 30 --记录强化截止时间
			BehaviorFunctions.AddEntitySign(self.me,92002005,self.powerUpLimitTime,true)--标记为狂化状态，受时间缩放影响
			BehaviorFunctions.DoEntityAudioPlay(self.me,"BaxilikesiMb1_Phase2",true)
			self.powerUp = true
			self.phase = 2
		end
		
		--技能嘶吼落雷随机落雷地点判断
		if sign == 920020011 then
			local val1 = self.thunderVal1
			local val2 = self.thunderVal2
			--气氛组落雷
			self:CreatBullet(92002001001,val1.target,val1.num,val1.interval,val1.rangeDistance,val1.angle,val1.disBetweenThunder)
			--伤害组落雷
			self:CreatBullet(92002001001,val2.target,val2.num,val2.interval,val2.rangeDistance,val2.angle,val2.disBetweenThunder)
		end
		
		----强化完成落雷氛围
		--if sign == 920020091 then
			--BehaviorFunctions.CreateEntity(9200209905,self.me,self.myBornPos.x,self.myBornPos.y,self.myBornPos.z)
		--end

		--技能飞天随机陨石地点判断ss
		if sign == 920020911 then
			local val1 = self.meteroVal1
			local val2 = self.meteroVal2
			--气氛组陨石
			self:CreatBullet(92002091001,val1.target,val1.num,val1.interval,val1.rangeDistance,val1.angle,val1.disBetweenThunder)
			--伤害组陨石
			self:CreatBullet(92002091001,val2.target,val2.num,val2.interval,val2.rangeDistance,val2.angle,val2.disBetweenThunder)
		end
		
		--技能可爱星星飞天撞临时判断
		if sign == 920020931 then
			local angle = math.random(0,360)
			local place = BehaviorFunctions.GetPositionOffsetBySelf(self.battleTarget,660,angle)
			BehaviorFunctions.DoSetPosition(self.me,place.x,place.y,place.z)
		end
		
		--技能可爱星星飞天撞2判断
		if sign == 920020961 then
			self:CuteStarFlySmash(self.battleTarget,40,600,5)
		end	
		
		--传送突袭传送位置判断
		if sign == 920020191 then
			local pos = self:RandomTeleportPos(self.battleTarget,55,0,360,1,true)
			if pos then
				self:TeleportToPos(self.battleTarget,pos)
			else
				
			end
		end
		
		--传送突袭锁定判断
		if sign == 920020193 then
			--强制玩家锁定龙
			self:SetPlayerForceLock(self.me,"Head","TargetGroup1")
		end
		
		--普通传送
		if sign == 920020221 then
			if self.telePos == nil then
				local pos = self:RandomTeleportPos(self.battleTarget,50,0,360,1,true)
				self:TeleportToPos(self.battleTarget,pos)
			else
				self:TeleportToPos(self.battleTarget,self.telePos)
				self.telePos = nil
			end
		end
	end	
end

--实体标记退出判断
function Behavior92002:RemoveEntitySign(instanceId,sign)
	if instanceId == self.me then
		--退出狂化状态
		if self.powerUp == true and sign == 92002005 then
			BehaviorFunctions.DoEntityAudioStop(self.me,"BaxilikesiMb1_Phase2",0.1,0.1)
			BehaviorFunctions.RemoveBuff(self.me,1001999)--移除强化特效
			self.powerUp = false
			self.powerUpSkill = false
			self.phase = 2
		end		
	end
end

--添加实体标记时判断
function Behavior92002:AddSkillSign(instanceId,sign)
	if instanceId == self.me then
		if sign == 92002100 then
			--注视ik关闭
			BehaviorFunctions.SetLookIKEnable(self.me,false)
			--BehaviorFunctions.SetLookIKEnable(self.me,false)
		end
	end
end

--部位移除封装
function Behavior92002:RemovePart(partName)
	--关闭部位伤害
	local isDamegeEnable = BehaviorFunctions.GetPartEnableHit(self.me,partName)
	if isDamegeEnable == true then
		BehaviorFunctions.SetPartEnableHit(self.me,partName,false)
	end
	--关闭部位碰撞
	local isCollisionEnable = BehaviorFunctions.SetPartEnableCollision(self.me,partName)
	if isCollisionEnable == true then
		BehaviorFunctions.SetPartEnableCollision(self.me,partName,false)
	end
	--关闭部位搜索
	local isSearchEnable = BehaviorFunctions.CheckEntityPartSearch(self.me,partName)
	if isSearchEnable == true then
		BehaviorFunctions.SetEntityPartSearch(self.me,partName,false)
	end
	--关闭部位锁定
	local isLockEnable = BehaviorFunctions.CheckEntityPartLock(self.me,partName)
	if isLockEnable == true then
		BehaviorFunctions.SetEntityPartLock(self.me,partName,false)
	end
end

--部位摧毁逻辑
function Behavior92002:PartDestroy(instanceId, partName,eventId)
	if instanceId == self.me then
		--尾巴相关处理
		if partName == "Tail" then
			if eventId == 1001 then
				BehaviorFunctions.CastSkillByTarget(self.me,92002017,self.battleTarget)
				BehaviorFunctions.DoMagic(self.me,self.me,1001994)
				self:RemovePart("Tail")
				--从列表中移除扫尾技能
				self:RemoveSkillFromList(92002041,self.normalSkillList)
			end
		--头部相关处理
		elseif partName == "Head" then
			if eventId == 2001 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92002013,self.battleTarget)
				BehaviorFunctions.DoMagic(self.me,self.me,1001998)--爆头特效
			elseif eventId == 2002 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92002013,self.battleTarget)
				BehaviorFunctions.DoMagic(self.me,self.me,1001998)--爆头特效
			end
		--核心相关处理
		elseif partName == "Core" then
			if BehaviorFunctions.GetSkill(self.me) == 92002091 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92002092,self.battleTarget)
			else
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillByTarget(self.me,92002011,self.battleTarget)
				if self.powerUpDelayCall then
					BehaviorFunctions.RemoveDelayCall(self.powerUpDelayCall)
				end
			end
		end
		if self.powerUpDelayCall then
			BehaviorFunctions.RemoveDelayCall(self.powerUpDelayCall)
		end
	end
end

--部位保护:部位引发瘫痪后一段时间内部位不会被累积为部位伤害
function Behavior92002:PartProtect(partName,frame)
	--关闭部位的伤害累积
	BehaviorFunctions.SetHurtPartDamageEnable(self.me,partName,false)
	--计算延迟时间
	local totalFrame = self.stunFrame + frame
	--延迟开启
	local delayId = BehaviorFunctions.AddDelayCallByFrame(totalFrame,BehaviorFunctions,BehaviorFunctions.SetHurtPartDamageEnable,self.me,partName,true)
	table.insert(self.delayCallList,delayId)
end

--部位受击逻辑
function Behavior92002:PartHit(instanceId,partName,life,damage,attackType,shakeStrenRatio)
	--受击骨骼抖动
	if shakeStrenRatio > 0.2 then
		if shakeStrenRatio >= 1 then
			self.shakeRatio = 1
		elseif shakeStrenRatio > 0.2 and shakeStrenRatio <= 0.4 then
			self.shakeRatio = shakeStrenRatio + 0.2
		elseif shakeStrenRatio > 0.4 and shakeStrenRatio < 1 then
			self.shakeRatio = shakeStrenRatio
		end
		if partName == "RightBackLeg" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"RightBackHit","RightBackHit",self.shakeRatio,100000014,false)
		end
		if partName == "LeftBackLeg" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"LeftBackHit","LeftBackHit",self.shakeRatio,100000014,false)
		end
		if partName == "LeftFrontLeg" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"LeftFrontHit","LeftFrontHit",self.shakeRatio,100000014,false)
		end
		if partName == "RightFrontLeg" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"RightFrontHit","RightFrontHit",self.shakeRatio,100000014,false)
		end
		if partName == "Tail" then
			BehaviorFunctions.PlayAddAnimation(instanceId,"TailHit","TailHit",self.shakeRatio,100000014,false)
		end		
		if partName == "Head" then
			--local Angle = BehaviorFunctions.GetEntityAngle(self.me,self.battleTarget)
			local Angle = BehaviorFunctions.GetEntityBonesAngle(self.me, "Center", self.battleTarget, "Root")
			if Angle > 0 and Angle <= 180 then
				BehaviorFunctions.PlayAddAnimation(instanceId,"HeadRightHit","HeadHit",self.shakeRatio,100000014,false)
			elseif Angle > 180 and Angle <= 360 then
				BehaviorFunctions.PlayAddAnimation(instanceId,"HeadLeftHit","HeadHit",self.shakeRatio,100000014,false)
			end
		end		
	end
	
	--受击特效
	if partName == "Head" then
		if BehaviorFunctions.HasBuffKind(self.me,1001982) then
			BehaviorFunctions.RemoveBuff(self.me,1001982)
		end
		BehaviorFunctions.AddBuff(self.me,self.me,1001982)
	elseif partName == "Tail" then
		if BehaviorFunctions.HasBuffKind(self.me,1001984) then
			BehaviorFunctions.RemoveBuff(self.me,1001984)
		end
		BehaviorFunctions.AddBuff(self.me,self.me,1001984)
	elseif partName == "Core" then
		if BehaviorFunctions.HasBuffKind(self.me,1001983) then
			BehaviorFunctions.RemoveBuff(self.me,1001983)
		end
		BehaviorFunctions.AddBuff(self.me,self.me,1001983)
	else
		if BehaviorFunctions.HasBuffKind(self.me,1001981) then
			BehaviorFunctions.RemoveBuff(self.me,1001981)
		end
		BehaviorFunctions.AddBuff(self.me,self.me,1001981)
	end
end


--------------------------------------------------通用封装函数----------------------------------------------------------------------------------------

function Behavior92002:SetPlayerForceLock(target,targetPoint,targetPart)
	local player = BehaviorFunctions.GetCtrlEntity()
	if target then
		BehaviorFunctions.SetEntityValue(player,"LockTarget",target) --锁定目标
		if targetPoint then
			BehaviorFunctions.SetEntityValue(player,"LockTargetPoint",targetPoint) --锁定点
		end
		if targetPart then
			BehaviorFunctions.SetEntityValue(player,"LockTargetPart",targetPart) --锁定部位
		end
	else
		BehaviorFunctions.SetEntityValue(player,"LockTarget",0) --不锁定目标
		BehaviorFunctions.SetEntityValue(player,"LockTargetPoint",0) --锁定点
		BehaviorFunctions.SetEntityValue(player,"LockTargetPart",0) --锁定部位
	end
	BehaviorFunctions.AddEntitySign(1,10000001,1)  --指定攻击/锁定目标标记，施加后，攻击、锁定、攻击备用、锁定备用都用指定目标
end

--计算玩家与其各个锁定点的距离
function Behavior92002:GetTargetGroupDistance(list)
	for groupIndex,group in ipairs(list) do
		for Index,targetInfo in ipairs(group.targetInfo) do
			targetInfo.dis = BehaviorFunctions.GetTransformDistance(self.battleTarget,"Root",self.me,targetInfo.bindName)
		end
	end
end

--根据锁定点距离和权重乘算计算出点位权重
function Behavior92002:SetTargetGroupWeight(list)
	local totalWeight = 0
	for groupIndex,group in ipairs(list) do
		--先算出总权重
		for Index,targetInfo in ipairs(group.targetInfo) do
			if targetInfo.isOpen then
				totalWeight = totalWeight + targetInfo.dis
			end
		end
		--给出单个权重
		for Index2,targetInfo2 in ipairs(group.targetInfo) do
			local resultWeight = 0
			if targetInfo2.isOpen then
				targetInfo2.weight = totalWeight - targetInfo2.dis
				if targetInfo2.weightMutiply then
					resultWeight = targetInfo2.weight * targetInfo2.weightMutiply
				else
					resultWeight = targetInfo2.weight
				end
				BehaviorFunctions.SetMemberWeight(self.me,group.groupName,targetInfo2.index,resultWeight)
			else
				BehaviorFunctions.SetMemberWeight(self.me,group.groupName,targetInfo2.index,0)
			end
		end
	end
end

--返回玩家处于巴西利克斯的哪个方向
function Behavior92002:ReturnDirection(target)
	local dirList = {}
	local angleToEnemy = BehaviorFunctions.GetEntityAngle(self.me,target)
	--local angleToEnemy = BehaviorFunctions.GetEntityBonesAngle(self.me, "Center", self.battleTarget, "Root")
	for dir,angle in ipairs(self.directionList) do
		if angle.maxAngel > angle.minAngel then
			if angleToEnemy >= angle.minAngel and angleToEnemy < angle.maxAngel then
				table.insert(dirList,dir)
			end
		else
			if angleToEnemy >= angle.minAngel or angleToEnemy < angle.maxAngel then
				table.insert(dirList,dir)
			end
		end
	end
	--会返回（1个全向+2个四向位置+1个八向精准位置）
	return dirList
	--1全向2全前方3全后方4全左方5全右方6前方7后方8左方9右方10左前11右前12左后13右后
end

--转向相关
function Behavior92002:Turn(target)
	if BehaviorFunctions.CanCastSkill(self.me) then
		local dirList = self:ReturnDirection(target)
		for i,dir in ipairs(dirList) do
			if dir ~= self.dirEnum.Front then
				for index,rotate in ipairs(self.rotateList) do
					if rotate.dir == dir then
						if target == self.battleTarget then
							BehaviorFunctions.CastSkillByTarget(self.me,rotate.id,target)
						end
						return rotate
					end
				end
			else
				--告知当前不需要转向
				return nil
			end
		end
	end
end

--方形范围检测
function Behavior92002:SquareDetect(target,skill)
	local angle = skill.angle
	local minDis = skill.minDistance
	local maxDis = skill.maxDistance
	--获得长宽
	local long = maxDis - minDis
	local wide = skill.wide
	local hight = skill.hight*2

	local distance = minDis+(long/2)

	--先确认点的位置
	local myEuler = BehaviorFunctions.GetEntityEuler(self.me)
	local facaPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,5,0)
	local center = BehaviorFunctions.GetPositionOffsetP(self.centerPos,facaPos,distance,angle)
	local result = BehaviorFunctions.CheckEntityInBoxArea(target,center,wide,hight,long,myEuler.y+angle)
	return result
end

--跳出到合适的地方
function Behavior92002:JumpOut(distance)
	local backResult = self:CheckObstacles(self.me,distance,self.dirEnum.Back,3)
	local frontResult = self:CheckObstacles(self.me,distance,self.dirEnum.Front,3)
	local leftResult = self:CheckObstacles(self.me,distance,self.dirEnum.Left,3)
	local rightResult = self:CheckObstacles(self.me,distance,self.dirEnum.Right,3)
	if distance >= 50 then
		if not backResult then
			BehaviorFunctions.CastSkillByTarget(self.me,92002031,self.battleTarget)
		elseif not frontResult then
			BehaviorFunctions.CastSkillByTarget(self.me,92002029,self.battleTarget)	
		elseif not leftResult then
			BehaviorFunctions.CastSkillByTarget(self.me,92002035,self.battleTarget)
		elseif not rightResult then
			BehaviorFunctions.CastSkillByTarget(self.me,92002036,self.battleTarget)
		end
		self.moveCD = true
	end
end

--传送到合适位置
function Behavior92002:TeleportOut(distance)	
	self.telePos = self:RandomTeleportPos(self.battleTarget,distance,0,360,1,true)
	--玩家位于其右侧时，左跳进传送门
	if self.currentDir[3] == self.dirEnum.FullRight then
	BehaviorFunctions.CastSkillByTarget(self.me,92002023,self.battleTarget)
	--玩家位于其左侧时，右跳进传送门
	elseif self.currentDir[3] == self.dirEnum.FullLeft then
	BehaviorFunctions.CastSkillByTarget(self.me,92002024,self.battleTarget)
	end
	self.moveCD = true
end


--检查周围障碍
function Behavior92002:CheckObstacles(target,distance,direction,offsetY)
	local targetPos = BehaviorFunctions.GetPositionP(target)
	local angle = nil
	if direction == self.dirEnum.Front then
		angle = 0
	elseif direction == self.dirEnum.Back then
		angle = 180
	elseif direction == self.dirEnum.Left then
		angle = 270
	elseif direction == self.dirEnum.Right then
		angle = 90
	end
	local pos = BehaviorFunctions.GetPositionOffsetBySelf(target,distance,angle)
	local posClone = TableUtils.CopyTable(pos)
	local targetposClone = TableUtils.CopyTable(targetPos)
	if offsetY then
		--点位克隆
		targetposClone.y =targetPos.y + offsetY
		posClone.y = pos.y + offsetY
	end
	local result = BehaviorFunctions.CheckObstaclesBetweenPos(targetposClone,posClone,true)
	return result
end

--测试行为树
function Behavior92002:TestBeha()
	if self.normalSkillCount < self.specialSkillFrequence then
		local skill = self:SkillSelect(self.battleTarget,self.normalSkillList)
		--如果当前范围有技能则释放
		if skill then
			self:SkillCast(self.battleTarget,skill.id,self.normalSkillList)
			self.normalSkillCount = self.normalSkillCount + 1
		--否则去特殊技能寻找技能
		else
			local result = self:Turn(self.battleTarget)
			if not result then
				self.normalSkillCount = self.specialSkillFrequence
			else
				self:Turn(self.battleTarget)
				return
			end
		end
	else
		local skill = self:SkillSelect2(self.battleTarget,self.specialSkillList)
		if skill then
			self:SkillCast(self.battleTarget,skill.id,self.specialSkillList)
			self.normalSkillCount = 0	
		end
	end
end

--移动逻辑
function Behavior92002:MoveLogic()
	local canNotMoveFront = self:CheckObstacles(self.me,5,self.dirEnum.Front,3)
	local canNotMoveBack = self:CheckObstacles(self.me,5,self.dirEnum.Back,3)
	local canNotMoveLeft = self:CheckObstacles(self.me,5,self.dirEnum.Left,3)
	local canNotMoveRight = self:CheckObstacles(self.me,5,self.dirEnum.Right,3)
	--检查当前状态
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	--返回与玩家的面向
	local directionList = self:ReturnDirection(self.battleTarget)
	local dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget)
	--判断距离
	if dis < self.shortRange then
		self.battleRange = self.BattleRangeEnum.Short
	elseif dis > self.longRange and dis < self.maxRange then
		self.battleRange = self.BattleRangeEnum.Long
	elseif dis >=self.maxRange then
		self.battleRange = self.BattleRangeEnum.Far
	else
		self.battleRange = self.BattleRangeEnum.Mid
	end
	--如果没有处于移动中,给出一个移动状态
	if self.myState ~= FightEnum.EntityState.Move then
		--设置每帧转向
		BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,false,15,0,-1)
		--如果处于超远距离
		if self.battleRange == self.BattleRangeEnum.Far then
			--朝玩家走过来
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
			self.subMoveType = self.subMoveTypeEnum.Walk
		else
			--如果左侧有障碍则右走
			if canNotMoveLeft then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
				self.subMoveType = self.subMoveTypeEnum.WalkRight
				--如果右侧有障碍则左走
			elseif canNotMoveRight then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
				self.subMoveType = self.subMoveTypeEnum.WalkLeft
				--如果都能走则随机一个方向
			else
				local R = BehaviorFunctions.RandomSelect(1,2)
				if R == 1 then --左走
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
					self.subMoveType = self.subMoveTypeEnum.WalkLeft
				elseif R == 2 then --右走
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
					self.subMoveType = self.subMoveTypeEnum.WalkRight
				end
			end
		end

		--如果处于移动状态
	elseif self.myState == FightEnum.EntityState.Move then
		--检查玩家具体的四面向情况
		local inLeftSide = false
		local inRightSide = false
		for i,v in ipairs(directionList) do
			if v == self.dirEnum.Left
				or v == self.dirEnum.FrontLeft then
				inLeftSide = true
			end
			if v == self.dirEnum.Right
				or v == self.dirEnum.FrontRight then
				inRightSide = true
			end
		end
		--如果处于左走状态已经不能左走了或玩家处于背面则右走
		if self.subMoveType == self.subMoveTypeEnum.WalkLeft then
			if canNotMoveLeft
				or inLeftSide then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
				self.subMoveType = self.subMoveTypeEnum.WalkRight
			end
			--如果处于右走状态已经不能右走了或玩家处于背面则左走
		elseif self.subMoveType == self.subMoveTypeEnum.WalkRight then
			if canNotMoveRight
				or inRightSide then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
				self.subMoveType = self.subMoveTypeEnum.WalkLeft
			end
			--如果处于前走状态
		elseif self.subMoveType == self.subMoveTypeEnum.Walk then
			--处于中距离的时候停下
			if self.battleRange == self.BattleRangeEnum.Mid then
				--清空为待机
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
				self.subMoveType = self.subMoveTypeEnum.Idle
			end
		end
		--如果处于超远距离
		if self.battleRange == self.BattleRangeEnum.Far then
			--如果不处于前走状态
			if self.subMoveType ~= self.subMoveTypeEnum.Walk then
				--朝玩家走过来
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				self.subMoveType = self.subMoveTypeEnum.Walk
			end
		end
		--如果玩家处于龙的移动死角
		for i,v in ipairs(directionList) do
			if v == self.dirEnum.FullBack then
				self:Turn(self.battleTarget)
			end
		end
	end
end

--返回当前列表中最靠前的距离和角度合适的技能
function Behavior92002:SkillSelect(target,skillList)
	local dirList = self:ReturnDirection(target)
	for index,skill in ipairs(skillList) do
		if skill.phase <= self.phase then
			--检查角度和距离
			if skill.checkType == "circle" then
				for i,dir in ipairs(dirList) do
					if skill.dir == dir then
						if self.battleTargetDistance >= skill.minDistance and
							self.battleTargetDistance < skill.maxDistance then
							return skill
						end
					end
				end
			elseif skill.checkType == "square" then
				local result = self:SquareDetect(self.battleTarget,skill)
				if result then
					return skill
				end
			end
		end
	end
	return nil
end

--返回当前列表中最靠前的距离和角度合适的技能
function Behavior92002:SkillSelect2(target,skillList)
	local dirList = self:ReturnDirection(target)
	for index,skill in ipairs(skillList) do
			if skill.phase <= self.phase then
			--检查角度和距离
			if skill.checkType == "circle" then
				for i,dir in ipairs(dirList) do
					if skill.dir == dir then
						if self.battleTargetDistance >= skill.minDistance and
							self.battleTargetDistance < skill.maxDistance then
							return skill
						else
							--如果距离太近
							if self.battleTargetDistance < skill.minDistance then
									if self.moveCD == false then
										if self.phase == 1 then
											self:JumpOut(50)
										else
											self:TeleportOut((skill.maxDistance + skill.minDistance) / 2)
										end
										return nil
									else
										return skill 
									end
							--如果距离太远
							elseif self.battleTargetDistance > skill.maxDistance then
								local R = nil
								if self.moveCD == false then
									R = BehaviorFunctions.RandomSelect(1,3)
								else
									R = BehaviorFunctions.RandomSelect(1,2)	
								end
								if R == 1 then --滑翔绝技
									self:SkillCast(self.battleTarget,92002098,self.specialSkillList)
									return nil
								elseif R == 2 then--扑杀绝技
									self:SkillCast(self.battleTarget,92002056,self.normalSkillList)
									return nil
								else--随机传送
									--self:TeleportOut((skill.maxDistance + skill.minDistance) / 2)
									self:TeleportOut(skill.minDistance) 
									return nil
								end
							end
						end
					end
				end
				self:Turn(self.battleTarget)
				return nil
			end
		end
	end
end

--释放技能表中的技能
function Behavior92002:SkillCast(target,skillId,skillList)
	BehaviorFunctions.CastSkillByTarget(self.me,skillId,target)
	--把使用的技能置于列表最底部
	for index,skill in ipairs(skillList) do
		if skill.id == skillId then
			table.insert(skillList,skill)
			table.remove(skillList,index)
			skillList = self:SortSkillList(skillList)
			self.moveCD = false
		end
	end
end

--从技能库中移除该技能
function Behavior92002:RemoveSkillFromList(skillId,skillList)
	for index,v in ipairs(skillList) do
		if v.id == skillId then
			table.remove(skillList,index)
		end
	end
end

--技能根据使用次数进行排序
function Behavior92002:SortSkillList(skillList)
	local list = {}
	for k = 1, #skillList do
		list[k] = skillList[k]
	end
	--技能列表排序，优先级：优先priority降序，priority相同则id升序
	table.sort(list,function(a,b)
			if a.times < b.times then
				return true				
			elseif a.times == b.times then
				return false
			end
		end)
	return list
end

--------------------------------------------------特殊技能封装函数----------------------------------------------------------------------------------------

--制造雷电
function Behavior92002:CreatBullet(bullet1,target1,num1,interval1,rangeDistance1,angle1,disBetweenThunder1)
	local bullet = bullet1
	local placeRocrd = nil
	local target = target1			  --以该目标为中心
	local times = num1				  --释放次数
	local interval = {}				 --用于储存释放帧数间隔
	local minInterval = interval1[1]   --释放的帧数最小间隔
	local maxInterval = interval1[2]   --释放的帧数最大间隔
	local minDis = rangeDistance1[1]	  --最小释放距离
	local maxDis = rangeDistance1[2]	  --最大释放距离
	local minAngle = angle1[1]			--最小释放角度
	local maxAngle = angle1[2]			--最大释放角度
	local minThunderDis = disBetweenThunder1	--雷之间的最小距离
	local releaseFrame = 0

	for thunderNum = 1, times do
		interval [thunderNum] = math.ceil(math.random(minInterval,maxInterval))
		releaseFrame = releaseFrame + interval [thunderNum]
		local place = 0
		local dis = 0
		--循环1000次来找一个满足偏移需求的距离
		for placeNum = 1, 1000 do
			local range = math.random(minDis,maxDis)	--最小与最大释放距离
			local angle = math.random(minAngle,maxAngle)--随机释放角度
			place = BehaviorFunctions.GetPositionOffsetBySelf(target,range,angle)
			local height = BehaviorFunctions.CheckPosHeight(place,PhysicsTerrain.TerrainCheckLayer)--获取与地面的相对高度
			if height ~=  nil then
				place.y = place.y - height
			end
			if placeRocrd ~= nil then
				dis = BehaviorFunctions.GetDistanceFromPos(place,placeRocrd[thunderNum - 1]) --只比对上一次闪电的落点
			end
			if placeRocrd ~= nil then 
				if placeNum ~= 1000 and dis >= minThunderDis
					or placeNum == 1000 then
					--延迟添加雷电和震屏,这里Y轴坐标取怪物坐标防止玩家跳起来
					BehaviorFunctions.AddDelayCallByFrame(releaseFrame,BehaviorFunctions,BehaviorFunctions.CreateEntity,bullet,self.me,place.x,place.y,place.z,place.x,nil,place.z)
					placeRocrd[thunderNum] = place--记录这一次的位置
					break
				elseif dis < minThunderDis then
					--如果距离小于预设距离则
				end
			elseif placeRocrd == nil then
				BehaviorFunctions.AddDelayCallByFrame(releaseFrame,BehaviorFunctions,BehaviorFunctions.CreateEntity,bullet,self.me,place.x,place.y,place.z,place.x,nil,place.z)				
				placeRocrd = {}
				placeRocrd[thunderNum] = place
				break
			end
		end
	end
end

--计算飞行角度下的长宽
function Behavior92002:TriangleLenth(angel,distance)
	local height = math.sin(math.rad(angel))*distance
	local wide = math.sqrt((distance*distance)-(height*height))
	local Lenth = {x = wide , y = height}
	return Lenth
end


--飞行角度预估
function Behavior92002:FlySkillAngle(target,angle,distance)
	local Lenth = self:TriangleLenth(angle,distance)
	local angle2 = math.random(0,360)
	--额外在玩家前方20米的地方降落
	local place = BehaviorFunctions.GetPositionOffsetBySelf(target,Lenth.x+20,angle2)
	place.y = place.y + Lenth.y
	local playerPlace = BehaviorFunctions.GetPositionP(target)
	local height = BehaviorFunctions.CheckPosHeight(playerPlace,PhysicsTerrain.TerrainCheckLayer)
	if height == nil then
		height = 0
	end
	playerPlace.y = playerPlace.y - height + 0.5
	local result = BehaviorFunctions.CheckObstaclesBetweenPos(place,playerPlace)

	--如果飞行过程中有障碍物则换一个角度试试，直至没有角度可试
	if result == true then
		local checkAngel = 5
		local checkTimes = 360/checkAngel
		for i = 1, checkTimes do
			angle2 = angle2 + checkAngel
			if angle2 >= 360 then
				angle2 = angle2 -360
			end
			place = BehaviorFunctions.GetPositionOffsetBySelf(target,Lenth.x+20,angle2)
			place.y = place.y + Lenth.y
			local height = BehaviorFunctions.CheckPosHeight(playerPlace,PhysicsTerrain.TerrainCheckLayer)
			playerPlace.y = playerPlace.y - height + 0.2
			result = BehaviorFunctions.CheckObstaclesBetweenPos(place,playerPlace)
			if result == false then
				return place
			else
				if i == checkTimes then
					LogError("所有角度都不可通过")
					return nil
				end
			end
		end
	else
		return place
	end
end

--可爱星星飞天撞2
function Behavior92002:CuteStarFlySmash (target,angle,distance,speed)
	if BehaviorFunctions.HasEntitySign(self.me,920020961) then
		--返回滑翔时该有的高度
		local Lenth = self:TriangleLenth(angle,distance)
		--返回滑翔时该出现的高度		
		local place = self:FlySkillAngle(target,angle,distance)
		
		if place ~= nil then			
			BehaviorFunctions.DoSetPosition(self.me,place.x,place.y,place.z)
			BehaviorFunctions.DoLookAtTargetImmediately(self.me,target)
		end

	elseif BehaviorFunctions.HasEntitySign(self.me,920020962) then
		local position = BehaviorFunctions.GetPositionP(self.me)
		local vect = Vec3.New(position.x,position.y,position.z)
		local groud = BehaviorFunctions.CheckPosHeight(vect,PhysicsTerrain.TerrainCheckLayer)
		local myEuler = BehaviorFunctions.GetEntityEuler(self.me)
		if groud ~= nil then
			if groud <= 1 and myEuler.x ~= 0 then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.SetEntityEuler(self.me,0,myEuler.y,myEuler.z)
				BehaviorFunctions.CastSkillByTarget(self.me,92002097,self.battleTarget)
			elseif groud >= 1 then
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
				BehaviorFunctions.SetEntityEuler(self.me,angle,myEuler.y,myEuler.z)
				BehaviorFunctions.DoMoveForward(self.me,speed)
			end
		else
			BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)
			BehaviorFunctions.SetEntityEuler(self.me,angle,myEuler.y,myEuler.z)
			BehaviorFunctions.DoMoveForward(self.me,speed)
		end
	end
end

--返回范围内没有障碍的随机方向位置
function Behavior92002:RandomTeleportPos(target,distance,startAngel,endAngel,checkheight,returnFarthestPos)
	local posTable = {}
	local farthestPos = nil
	for angel = startAngel,endAngel,5 do
		local pos = BehaviorFunctions.GetPositionOffsetBySelf(target,distance,angel)
		local targetPos = BehaviorFunctions.GetPositionP(target)
		--点位克隆
		local posClone = TableUtils.CopyTable(pos)
		local targetposClone = TableUtils.CopyTable(targetPos)
		--如果有检查高度则检查
		if checkheight then
			posClone.y = posClone.y + checkheight
			targetposClone.y = targetposClone.y + checkheight
		end
		--获取与该点的距离
		local dis = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(targetposClone,posClone,false)
		--获取与该障碍的距离
		if farthestPos then
			--选取最远的距离
			local dis2 = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(targetposClone,farthestPos,false)
			if dis > dis2 then
				farthestPos = posClone
				farthestPos = BehaviorFunctions.GetPositionOffsetBySelf(target,dis,angel)
			end
		else
			farthestPos = BehaviorFunctions.GetPositionOffsetBySelf(target,dis,angel)
		end
		--检测障碍：
		if not BehaviorFunctions.CheckObstaclesBetweenPos(targetposClone,posClone,false) then
			table.insert(posTable,pos)
		end
	end
	local posNum = #posTable
	if #posTable ~= 0 then
		local randomIndex = math.random(1,#posTable)
		return posTable[randomIndex]
	else
		if not returnFarthestPos then
			return nil
		else
			--返回最远的点
			return farthestPos
		end
	end
end

--技能传送突袭
function Behavior92002:TeleportToPos(target,pos)
	--如果没有障碍的情况下就进行传送：
	BehaviorFunctions.DoLookAtTargetImmediately(self.me,target)
	BehaviorFunctions.DoSetPosition(self.me,pos.x,pos.y,pos.z)
end