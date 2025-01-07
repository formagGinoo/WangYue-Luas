Behavior900102 = BaseClass("Behavior900102",EntityBehaviorBase)
--计都灵客
--资源预加载
function Behavior900102.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900102.GetMagics()
	local generates = {}
	return generates
end

function Behavior900102:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = 90010207
	self.backHited = 90010208

	self.MonsterCommonParam.canBeAss = true				--可以被暗杀

	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		                                        --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actPerformance = nil                                                   --演出技能Id

	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 6           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 15           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange =  20           --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 80          --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 90010201            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = nil            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = nil            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	self.MonsterCommonParam.curAlertnessValue = 0        --初始警戒值
	self.MonsterCommonParam.maxAlertnessValue = 100      --最大警戒值
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 1.5				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断
	self.MonsterCommonParam.initialSkillList = {
		--近战敲击后撤
		--attack001 =
		{id = 90010202,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 1.7,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 6,                  --技能cd，单位：秒
			durationFrame = 110,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,				 --分级系数，大于一定系数的技能释放后进入群组公共cd
		},

		--远程蓄力法术
		--attack002 =
		{id = 90010203,
			minDistance = 5,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 100,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,				 --分级系数，大于一定系数的技能释放后进入群组公共cd
		},

		--减伤法阵
		--attack003 =
		{id = 90010204,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 15,        --技能释放最大距离（无等号）
			angle = 360,              --技能释放角度
			cd = 25,                  --技能cd，单位：秒
			durationFrame = 128,      --技能持续帧数
			frame = 150,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			grade = 5,				 --分级系数，大于一定系数的技能释放后进入群组公共cd
		},

		-- --复活法术
		-- {id = 90010204,
		-- minDistance = 0,         --技能释放最小距离（有等号）
		-- maxDistance = 10,        --技能释放最大距离（无等号）
		-- angle = 360,              --技能释放角度
		-- cd = 15,                  --技能cd，单位：秒
		-- durationFrame = 126,      --技能持续帧数
		-- frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		-- priority = 2,            --优先级，数值越大优先级越高
		-- weight = 1,              --随机权重
		-- isAuto = false,           --是否自动释放
		-- difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		-- minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		-- maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
		-- },

		--闪现消失
		--attack004 =
		{id = 90010205,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 100,        --技能释放最大距离（无等号）
			angle = 360,              --技能释放角度
			cd = 1,                  --技能cd，单位：秒
			durationFrame = 9,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 0.5,            --优先级，数值越大优先级越高
			weight = 1,              --随机权重
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
			ignoreCommonSkillCd = true,           --默认为false，配了true无视CommonCd
			grade = 0,				 --分级系数，大于一定系数的技能释放后进入群组公共cd
		},

		----闪现出现
		--{id = 90010206,
		--minDistance = 1,         --技能释放最小距离（有等号）
		--maxDistance = 100,        --技能释放最大距离（无等号）
		--angle = 30,              --技能释放角度
		--cd = 1,                  --技能cd，单位：秒
		--durationFrame = 38,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--weight = 1,              --随机权重
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000,     --技能释放最高生命万分比（无等号）
		--ignoreCommonSkillCd = false           --默认为false，配了true无视CommonCd
		--},
	}

	self.MonsterCommonParam.endureBreakTime=10           --霸体条破持续时间
	--MonsterWander
	self.MonsterCommonParam.shortRange = 1.3                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 8                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 50                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 1.2                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = true               --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 1.333        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.2         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1               --移动发呆时间
	self.MonsterCommonParam.canRun = false                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 90010202		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 50           --脱战距离
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20       --脱战时间
	self.MonsterCommonParam.canNotChase = 50              --追不上玩家的距离
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange
	--SpecialSkill
	self.dieMonsterTable = {}
	self.canReviveTable = {}
	self.reviveMonsterTable = {}
	self.soulTable =
	{
		soulEntityId = 9001020305,
		soulInEntityId = 9001020304,
		soulEndEntityId01 = 9001020306,   --溢散
		soulEndEntityId02 = 9001020307,   --复活
	}
	self.returnNum = 0

end
function Behavior900102:LateInit()
	self.MonsterCommonBehavior.MonsterPeace:LateInit()
end


function Behavior900102:Update()
	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me, "beAssassin",self.beAssassin)
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)
	--个性化定制
	self:BasicData()
	self:SpecialSkill()
end

--函数----------------------------------------------------------------------------------------------

function Behavior900102:BasicData()
	self.myPos = BehaviorFunctions.GetPositionP(self.MonsterCommonParam.me)
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.distance = BehaviorFunctions.GetDistanceFromPos(self.myPos, self.rolePos)
end

function Behavior900102:SpecialSkill()
	--闪现技能逻辑
	--根据所在位置不同，设置不同cd
	if self.distance > 15 then
		self.MonsterCommonParam.initialSkillList[4].cd = 1    --赶路很快
	elseif self.distance <= 15 then
		self.MonsterCommonParam.initialSkillList[4].cd = 6
	end
end

function Behavior900102:GetFlashPos(instanceId)
	--判断要闪到哪(还要加上判断位置是否合法)
	local angle = BehaviorFunctions.GetEntityAngle(instanceId, self.role)
	local appearPos = nil
	local flashDistance = 6
	if self.returnNum < 3 then
		if self.distance > 15 then
			--往玩家方向闪
			appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, flashDistance, angle)
		elseif 5 < self.distance and self.distance <= 15 then
			local movementType = math.random(1, 2)
			--两种闪法，一种往12m线上闪
			if movementType == 1 then
				if self.distance < 12 then
					appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, -flashDistance, angle)
				else
					appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, flashDistance, angle)
				end
				--一种保持距离半径不变，在扇形两端点上左右闪
			else
				-- 计算cos(angle)的值
				local cosValue = (2 * self.distance^2 - flashDistance^2) / (2 * self.distance^2)
				-- 将cos(angle)的值转化为angle的值，并将其转化为角度制
				local rad = math.acos(cosValue)
				angle = math.deg(rad)
				appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, flashDistance, angle)
			end
			--太近了往后闪
		elseif self.distance <= 5 then
			appearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId, -flashDistance, angle)
		end
	else
		appearPos = BehaviorFunctions.GetRandomNavRationalPoint(instanceId, 4, 8)
	end
	--暂时删去危险判断
	--if appearPos then
		--local isPosSave = nil
		----local isCollide = BehaviorFunctions.CheckEntityCollideAtPosition(900102, appearPos.x, appearPos.y+0.5, appearPos.z, {instanceId}, instanceId)	--检查闪的点是否合法
		----BehaviorFunctions.DoCollideCheckAtPosition(appearPos.x, appearPos.y, appearPos.z,sizeX,sizeY,sizeZ,ignoreList)
		--local y,layer = BehaviorFunctions.CheckPosHeight(appearPos)
		--if y ~= nil
			--and layer ~= nil
			--and y > 3
			--or BehaviorFunctions.CheckObstaclesBetweenPos(appearPos,self.myPos,false)   --要传送的点和现在的点之间有障碍
			--or layer == FightEnum.Layer.Water
			--or layer == FightEnum.Layer.Marsh then
			----or isCollide == false then
			--isPosSave = false
		--else
			--isPosSave = true
		--end
	--end
	local isPosSave = true
	if isPosSave then
		BehaviorFunctions.DoSetPositionP(instanceId, appearPos)
		if BehaviorFunctions.CanCastSkill(instanceId) then
			BehaviorFunctions.CastSkillByTarget(instanceId, 90010206, self.role)
		end
	--else
		--self.returnNum = self.returnNum + 1
		--return self:GetFlashPos(instanceId)
	end
end

--回调----------------------------------------------------------------------------------------------

function Behavior900102:DeathEnter(instanceId,isFormationRevive)
	if instanceId == self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900102:Die(attackInstanceId,dieInstanceId)
	--自己的死亡溶解
	if dieInstanceId == self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end

function Behavior900102:FinishSkill(instanceId,skillId,skillType)
	--闪现技能放完之后
	if skillId  == 90010205 then
		self:GetFlashPos(instanceId)
	end
end


--复活相关暂时删除----------------------------------------------------------------------------------------------------------------

-- function Behavior900102:RecordDeathInfo(dieInstanceId)
-- 	if dieInstanceId == self.MonsterCommonParam.me then   --自己不会变魂
-- 		return
-- 	end
-- 	local monsterType = 1
-- 	local diePos = BehaviorFunctions.GetPositionP(dieInstanceId)
-- 	local soul = BehaviorFunctions.CreateEntityByEntity(self.MonsterCommonParam.me, self.soulTable.soulEntityId, diePos.x, diePos.y, diePos.z, self.rolePos.x, self.rolePos.y, self.rolePos.z)
-- 	if BehaviorFunctions.GetNpcType(dieInstanceId) == FightEnum.EntityNpcTag.Elite then   --如果是精英怪
-- 		monsterType = 2
-- 	end
-- 	local dieMonsterInfo =
-- 	{
-- 		dieMonster = dieInstanceId,
-- 		soulInstanceId = soul,
-- 		priority = monsterType,
-- 		soulTime = 0,
-- 		pos = diePos
-- 	}
-- 	table.insert(self.dieMonsterTable, dieMonsterInfo)
-- end

-- function Behavior900102:EntityStateChange(instanceId, state)
-- 	if state ~= FightEnum.EntityState.Death or self.MonsterCommonParam.inFight == false then
-- 		return
-- 	end
-- 	--别的怪死时
-- 	if BehaviorFunctions.CheckCampBetweenTarget(instanceId, self.MonsterCommonParam.me)
-- 		and (BehaviorFunctions.GetNpcType(instanceId) == FightEnum.EntityNpcTag.Monster or BehaviorFunctions.GetNpcType(instanceId) == FightEnum.EntityNpcTag.Elite) then		--如果是怪
-- 		--还需要没有被复活过
-- 		local isRevive = false
-- 		for i, v in ipairs(self.reviveMonsterTable) do
-- 			if v == instanceId then
-- 				isRevive = true
-- 				BehaviorFunctions.SetEntityFakeDeath(instanceId, false)   --把假死状态改回来
-- 				break
-- 			end
-- 		end
-- 		if not isRevive then
-- 			--判断和计都灵客的距离
-- 			local diePos = BehaviorFunctions.GetPositionP(instanceId)
-- 			local distance = BehaviorFunctions.GetDistanceFromPos(diePos, self.myPos)
-- 			if distance < 20 then
-- 				BehaviorFunctions.SetEntityFakeDeath(instanceId, true, 30)   --设置假死状态
-- 				--记录死者信息
-- 				BehaviorFunctions.AddDelayCallByFrame(30, self, self.RecordDeathInfo, instanceId)   --创灵魂插表格
-- 				--处理死者遗体
-- 				BehaviorFunctions.PlayAnimation(instanceId, "Death")   --播放死亡动画（不用我播）
-- 				--BehaviorFunctions.AddBuff(1, dieInstanceId, 900000010)   --把假死的怪隐身
-- 				--BehaviorFunctions.CreateEntityByEntity(self.MonsterCommonParam.me,200000107,pos.x,pos.y,pos.z)   --爆炸特效
-- 				BehaviorFunctions.AddDelayCallByFrame(30, BehaviorFunctions, BehaviorFunctions.AddBuff, 1, instanceId, 900000010)   --把假死的怪隐身
-- 				--BehaviorFunctions.AddDelayCallByFrame(30, BehaviorFunctions, BehaviorFunctions.CreateEntityByEntity, self.MonsterCommonParam.me, self.soulTable.soulInEntityId, diePos.x,diePos.y,diePos.z)  --灵魂出现
-- 				--BehaviorFunctions.AddDelayCallByFrame(30, BehaviorFunctions, BehaviorFunctions.CreateEntityByEntity, self.MonsterCommonParam.me,200000107,diePos.x,diePos.y,diePos.z,self.myPos.x,self.myPos.y,self.myPos.z)   --爆炸特效
-- 			end
-- 		end
-- 	end
-- end

-- function Behavior900102:BreakSkill(randomMonsterinstanceId,skillId,skillType)
-- 	--复活技能放完后
-- 	if skillId == 90010204 then
-- 		--随机选一只怪
-- 		local randomIndex = math.random(#self.canReviveTable)
-- 		local randomMonster = self.canReviveTable[randomIndex].dieMonster
-- 		--进行一个诈尸
-- 		BehaviorFunctions.DoMagic(self.MonsterCommonParam.me, randomMonster, 900102041)   --复活
-- 		--BehaviorFunctions.AddDelayCallByFrame(110, BehaviorFunctions, BehaviorFunctions.RemoveBuff, randomMonster, 900000010)   --取消隐身
-- 		--BehaviorFunctions.AddDelayCallByFrame(110, BehaviorFunctions, BehaviorFunctions.RemoveEntity, self.dieMonsterTable[randomIndex].soulInstanceId)   --删除灵魂
-- 		--BehaviorFunctions.AddDelayCallByFrame(110, BehaviorFunctions, BehaviorFunctions.CreateEntityByEntity, self.MonsterCommonParam.me, self.soulTable.soulEndEntityId02)   --灵魂复活
-- 		BehaviorFunctions.CreateEntityByEntity(self.MonsterCommonParam.me, self.soulTable.soulEndEntityId02)
-- 		BehaviorFunctions.RemoveBuff(randomMonster, 900000010)
-- 		BehaviorFunctions.RemoveEntity(self.canReviveTable[randomIndex].soulInstanceId)   --删除灵魂
-- 		--BehaviorFunctions.AddFightTarget(randomMonster, self.role)   --手动加锁定
-- 		--修改生死簿
-- 		self.canReviveTable[randomIndex] = nil  -- 删除键为index的元素
-- 		table.insert(self.reviveMonsterTable, randomMonster)
-- 	end
-- end


--function Behavior900102:CastSkill(instanceId,skillId,skillType)
----放复活技能（打算放到break那边，就不用加延迟了）
--if skillId == 90010204 then
----随机选一只怪
--local randomIndex = math.random(#self.dieMonsterTable)
--local randomMonster = self.dieMonsterTable[randomIndex].dieMonster
----进行一个诈尸
--BehaviorFunctions.DoMagic(self.MonsterCommonParam.me, randomMonster, 900102041)   --复活
--BehaviorFunctions.AddDelayCallByFrame(110, BehaviorFunctions, BehaviorFunctions.RemoveBuff, randomMonster, 900000010)   --取消隐身
--BehaviorFunctions.AddDelayCallByFrame(110, BehaviorFunctions, BehaviorFunctions.RemoveEntity, self.dieMonsterTable[randomIndex].soulInstanceId)   --删除灵魂
--BehaviorFunctions.AddDelayCallByFrame(110, BehaviorFunctions, BehaviorFunctions.CreateEntityByEntity, self.MonsterCommonParam.me, self.soulTable.soulEndEntityId02, pos.x, pos.y, pos.z)   --灵魂复活
----BehaviorFunctions.RemoveBuff(randomMonster, 900000010)
----BehaviorFunctions.RemoveEntity(self.dieMonsterTable[randomIndex][2])   --删除灵魂
----修改生死簿
--self.dieMonsterTable[randomIndex] = nil  -- 删除键为index的元素
--table.insert(self.reviveMonsterTable, randomMonster)
--end
--end

-- function Behavior900102:ReviveSkill()
-- 	--复活技能
-- 	--管理死亡后时间计时,一个魂至少是死了8秒之后才能被救
-- 	for i, v in ipairs(self.dieMonsterTable) do
-- 		v.soulTime = BehaviorFunctions.GetEntityFrame(v.soulInstanceId)/30
-- 		--print(v.soulTime)
-- 		if v.soulTime > 8 then
-- 			table.insert(self.canReviveTable, v)
-- 			table.remove(self.dieMonsterTable, i)
-- 		end
-- 	end
-- 	--有人死了且死到足够时间才会放复活技能
-- 	if #self.canReviveTable >= 1 then
-- 		self.MonsterCommonParam.initialSkillList[3].isAuto = true
-- 	else
-- 		self.MonsterCommonParam.initialSkillList[3].isAuto = false
-- 	end
-- end