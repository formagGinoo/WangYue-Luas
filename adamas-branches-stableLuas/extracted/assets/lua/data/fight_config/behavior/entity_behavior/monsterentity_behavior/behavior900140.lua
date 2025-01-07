Behavior900140 = BaseClass("Behavior900140",EntityBehaviorBase)
--资源预加载
function Behavior900140.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900140.GetMagics()
	local generates = {900000024,900000025,900000107}
	return generates
end



function Behavior900140:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = 90014009
	self.backHited = 90014062
	self.Me = self.instanceId		--记录自己
	self.can = nil
	self.cantime = 0
	
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
	self.MonsterCommonParam.warnSkillId = 900140901            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 90004007            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = 90014005            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	self.MonsterCommonParam.curAlertnessValue = 0        --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100      --最大警戒值
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5			--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		
		--打耳光
		{id = 900140001,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 7,                  --技能cd，单位：秒
			durationFrame = 72,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		------近距离超人拳
		{id = 900140006,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 72,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		
		--------超人拳
		{id = 900140002,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 9.5,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 13,                  --技能cd，单位：秒
			durationFrame = 85,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
		----------扔罐子
		{id = 900140003,
			minDistance = 4,         --技能释放最小距离（有等号）
			maxDistance = 8,        --技能释放最大距离（无等号）
			angle = 20,              --技能释放角度
			--20
			cd = 20,                  --技能cd，单位：秒
			durationFrame = 100,      --技能持续帧数
			frame = 60,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,					--分级系数，大于一定系数的技能释放后进入群组公共cd
		},
		
	
	}
	
	self.MonsterCommonParam.endureBreakTime=10           --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 2                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 3                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 2.66        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 2.66        --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1               --移动发呆时间
	self.MonsterCommonParam.canRun = true                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = true           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 900140001      --默认技能id，追杀模式使用
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
	--技能用参数记录
	self.slapstate = 0
	self.hittime = 0
	self.backCD = 0
	

end
function Behavior900140:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900140:Update()
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
	--罐子计时
	self:cantimecount()
	self.battletargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.Me,self.MonsterCommonParam.battleTarget)
end


function Behavior900140:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900140:RemoveEntity(instanceId)
	--if instanceId == BehaviorFunctions.GetEntityTemplateId(instanceId) == 90014001 then
		--local p = BehaviorFunctions.GetPositionP(instanceId)
		----BehaviorFunctions.CreateEntityByPosition(9001400302, self.Me, "PlayerRestart", "Task_Main_53", 10503021, self.levelId, nil)
		--BehaviorFunctions.CreateEntityByEntity(self.Me,9001400302,p.x,p.y,p.z)
	--end
end

function Behavior900140:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
	
end

function Behavior900140:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
	--if instanceId == self.Me and skillId == 900140004 then
		--BehaviorFunctions.BreakSkill(self.Me)
		--BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.MonsterCommonParam.battleTarget)
	--end
end

function Behavior900140:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
	if attackInstanceId == self.Me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 90014001001 then
		if self.battletargetDistance <= 3.5 then
			self.slapstate = 1
		end	
	
	elseif attackInstanceId == self.Me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 90014001 then
		local p = BehaviorFunctions.GetPositionP(instanceId)
		--BehaviorFunctions.CreateEntityByPosition(9001400302, self.Me, "PlayerRestart", "Task_Main_53", 10503021, self.levelId, nil)
		--BehaviorFunctions.CreateEntityByEntity(self.Me,9001400302,p.x,p.y,p.z)
		self.canstate = 0 
	elseif attackInstanceId == self.Me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 90014002 then
		local p = BehaviorFunctions.GetPositionP(instanceId)
		--BehaviorFunctions.CreateEntityByPosition(9001400302, self.Me, "PlayerRestart", "Task_Main_53", 10503021, self.levelId, nil)
		--BehaviorFunctions.CreateEntityByEntity(self.Me,9001400302,p.x,p.y,p.z)
		self.canstate = 0
	end
	
	if hitInstanceId == self.Me then
		self.hittime = self.hittime + 1
		
		local s = BehaviorFunctions.GetSkill(self.Me)
		local h = BehaviorFunctions.GetHitType(self.Me)
		-- 被狂揍之后，如果不是击倒击飞什么的，就往后撤
		if self.hittime >= 15 and s == 0 then
			if self.fightFrame - 12*30 >= self.backCD then
				if h ~= 5 and h ~= 6 and h ~= 7 and h ~= 71 and h ~= 72 and h ~= 73 and h ~= 74 and h ~= 75 and h ~= 76 and h ~= 20 then
					--BehaviorFunctions.AddBuff(self.Me,self.Me,900000045)
					BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.MonsterCommonParam.battleTarget)
					BehaviorFunctions.AddEntitySign(self.Me,90014000401,-1,false)
					self.hittime = 0
					self.backCD = self.fightFrame
				end
			end
		end
	end
	
	
	
end

function Behavior900140:SkillFrameUpdate(instanceId,skillId,skillFrame)
	
	--打耳光帧标记
	if instanceId == self.Me and skillId == 900140001 and skillFrame == 35 and self.slapstate == 1 then
		local R = BehaviorFunctions.RandomSelect(1,2,3)
		--打耳光之后随机后撤，加实体标记
		if R == 1 then
			BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.MonsterCommonParam.battleTarget)
			BehaviorFunctions.AddEntitySign(self.Me,90014000402,-1,false)
		end
			self.slapstate = 0
	end	

end

--判断放了技能
function Behavior900140:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.Me and skillId == 900140006 then
		self:SetSkillFrame(900140002)
	elseif instanceId == self.Me and skillId == 900140002 then
		self:SetSkillFrame(900140006)
	end
		
end


function Behavior900140:AddSkillSign(instanceId,sign)

	--打耳光帧标记
	if instanceId == self.Me and sign == 900140101 and self.slapstate == 1 then
		if self.slaptime ~= 0 then
			local R = BehaviorFunctions.RandomSelect(1,2,3)
			if R == 1 then
				BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.MonsterCommonParam.battleTarget)
				self.slapstate = 0
			end
		else
			BehaviorFunctions.CastSkillByTarget(self.Me,900140004,self.MonsterCommonParam.battleTarget)
			self.slapstate = 0
			self.slaptime = 1
		end
	end

	--扔罐子帧标记
	if instanceId == self.Me and sign == 900140302 then
		
		self.canstate = 1
		--self.x,self.y,self.z = BehaviorFunctions.GetEntityTransformPos(self.Me,"wuqi_000")
		--self.x,self.y,self.z = BehaviorFunctions.GetEntityTransformRot(self.me,"wuqi_000")
		--self.can = BehaviorFunctions.CreateEntityByEntity(self.Me,90014001,self.x,self.y,self.z)
	end
	
	if instanceId == self.Me and sign == 900140401 then
		
		if BehaviorFunctions.HasEntitySign(self.Me,90014000402) then
			--如果是扇巴掌之后的后撤，接嘲讽
			BehaviorFunctions.CastSkillByTarget(self.Me,900140005,self.MonsterCommonParam.battleTarget)
			BehaviorFunctions.RemoveEntitySign(self.Me,90014000402)
			
		elseif BehaviorFunctions.HasEntitySign(self.Me,90014000401) then
			--如果是挨揍的后撤，根据距离随机接技能
			if self.battletargetDistance <= 6 then				
					BehaviorFunctions.CastSkillByTarget(self.Me,900140006,self.MonsterCommonParam.battleTarget)
					self:SetSkillFrame(900140006)
			else
				local R = BehaviorFunctions.RandomSelect(1,2)
				if R == 1 then
					BehaviorFunctions.CastSkillByTarget(self.Me,900140002,self.MonsterCommonParam.battleTarget)
					self:SetSkillFrame(900140002)
				else
					BehaviorFunctions.CastSkillByTarget(self.Me,900140003,self.MonsterCommonParam.battleTarget)
					self:SetSkillFrame(900140003)
				end
			end
					
		end
	end
	
	if instanceId == self.Me and sign == 900140301 then
		BehaviorFunctions.RemoveSkillEventActiveSign(self.Me,900140302)
		BehaviorFunctions.RemoveSkillEventActiveSign(self.Me,900140303)
		if self.battletargetDistance <= 5 then
			--BehaviorFunctions.AddEntitySign(self.Me,900140302,3,false)
			BehaviorFunctions.AddSkillEventActiveSign(self.Me,900140302)
		else 
			--BehaviorFunctions.AddEntitySign(self.Me,900140303,3,false)
			BehaviorFunctions.AddSkillEventActiveSign(self.Me,900140303)
		end
	end
	
	
end

--根据id查找列表中对应id的技能的列表下标
function Behavior900140:SerchSkillList(skillid,table)
	for i = 1,#table do
		if skillid == table[i].id then
			return i
		end
	end
end

--罐子倒计时判断
function Behavior900140:cantimecount()
	--if self.fightFrame - 18 >= self.cantime and self.canstate == 1 and self.can then
		--local p = BehaviorFunctions.GetPositionP(self.can)
		--BehaviorFunctions.CreateEntityByEntity(self.Me, 9001400304 ,p.x,p.y,p.z)
		----BehaviorFunctions.RemoveEntity(self.can)
		--self.canstate = 0
		--self.can = nil
	--end
end
		
		
function Behavior900140:KeyFrameAddEntity(instanceId,entityId)
	if entityId == 90014001 and BehaviorFunctions.GetSkill(self.Me) == 900140003 then
		self.cantime = self.fightFrame
		self.can = instanceId
		
		local t = BehaviorFunctions.CreateEntity(9001400301,self.Me)
		BehaviorFunctions.BindTransform(t,"Root",{x = 0, y =0, z = 0},self.can)
		local t1 = BehaviorFunctions.CreateEntity(9001400301,self.Me)
		BehaviorFunctions.BindTransform(t1,"Root",{x = 0, y =0, z = 0},self.can)
		
		--双点曲线
		local p = BehaviorFunctions.GetPositionP(self.MonsterCommonParam.battleTarget)
		
		local ctrlPos = {ZRate = 0.3,YRate = 0.5}
		--local selfEntity = BehaviorFunctions.fight.entityManager:GetEntity(self.MonsterCommonParam.battleTarget)
		--local PartName = "Root"
		BehaviorFunctions.SetEntityMoveCurveThrow(self.can,nil,ctrlPos,Vec3.New(p.x,p.y,p.z),22,nil)
			--function ()
				
				--BehaviorFunctions.CreateEntity(9001400306,self.Me,p.x,p.y,p.z)
			
		--end)
		--{Entity = selfEntity,PartName = PartName}
	end	
	
	if entityId == 90014002 and BehaviorFunctions.GetSkill(self.Me) == 900140003 then
		local t = BehaviorFunctions.CreateEntity(9001400301,self.Me)
		BehaviorFunctions.BindTransform(t,"Root",{x = 0, y =0, z = 0},instanceId)
		
	end
end		

function Behavior900140:Dodge(attackInstanceId,hitInstanceId,limit)
	
end



function Behavior900140:HitGround(attackInstanceId,instanceId,positionX, positionY, positionZ)
	
	if attackInstanceId == self.Me and instanceId == self.can then
		
		BehaviorFunctions.CreateEntity(9001400306,self.Me,positionX, positionY+0.45, positionZ)
		--BehaviorFunctions.DoMagic(self.Me,self.can,9001400302)
		--if self.can then
		--BehaviorFunctions.RemoveEntity(self.can)
		--end
	end
end
	

--修改技能frame值
function Behavior900140:SetSkillFrame(skillId)
	--找到这个技能
	local i = self:SerchSkillList(skillId,self.MonsterCommonParam.initialSkillList)
	--修改frame值
	self.MonsterCommonParam.initialSkillList[i].frame = self.fightFrame + self.MonsterCommonParam.initialSkillList[i].cd*30
end


----监听器回调
--function Behavior900140:ConditionEvent(instanceId,eventId)
	--if instanceId == self.Me then
		--BehaviorFunctions.CastSkillByTarget(self.Me,900140005,self.MonsterCommonParam.battleTarget)
	--end
--end

--function Behavior900140:Warning(instance, targetInstance, sign,isEnd)
	--if instance == self.Me then
		
	--end
	
--end