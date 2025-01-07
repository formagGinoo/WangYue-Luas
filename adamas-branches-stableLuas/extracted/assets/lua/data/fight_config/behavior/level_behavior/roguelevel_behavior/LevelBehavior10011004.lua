LevelBehavior10011004 = BaseClass("LevelBehavior10011004",LevelBehaviorBase)
--肉鸽测试关卡:浮空岛基础战斗01
function LevelBehavior10011004:__init(fight)
	self.fight = fight
end


function LevelBehavior10011004.GetGenerates()
	local generates = {900040,910040,2030502,203051113,20305080002,20305023,20305080101,203050804,900070,900071,900080}
	return generates
end


function LevelBehavior10011004:Init()
	self.me = self.instanceId
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.time = nil
	
------追踪标--- -----------------------------------------------------------------------------------------------------
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 50
	self.guidePos = nil
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}

	
-----状态定义---------------------------------------------------------------------------------------------------------------------------------------	

	--怪物状态枚举
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}	
	--关卡状态枚举
	self.levelStateEnum = 
	{
		Default = 0,
		Ongoing = 1,
		LevelSuccess = 2,
		LevelFail = 3,
		LevelEnd = 4,
	}
	--关卡状态	
	self.levelState = self.levelStateEnum.Default

	--关卡开启标状态枚举
	self.levelFlagStateEnum =
	{
		Default = 0,
		Showing = 1,
	}
	--关卡开启标状态
	self.levelFlagState = self.levelFlagStateEnum.Default

	--关卡开启标志
	self.levelFlag = nil
	self.levelFlagInteractionId = nil
	
-----关卡配置参数---------------------------------------------------------------------------------------------------------------------------------------

	--关卡起始点位
	self.levelStartPos = nil
	--玩家靠近点位至少多少距离才会开始战斗	
	self.startRange = 5
	
	--怪物信息参数
	self.monsterList =
	{
		[1] = {state = self.monsterStateEnum.Default,wave = 1,entityId = 900040},
		[2] = {state = self.monsterStateEnum.Default,wave = 2,entityId = 900040},
		[3] = {state = self.monsterStateEnum.Default,wave = 2,entityId = 900071},
		[4] = {state = self.monsterStateEnum.Default,wave = 3,entityId = 900080},
	}
	
	--怪物信息参数——点位
	self.monsterDotList =
	{
		[1] = "MonTest01",
		[2] = "MonTest02",
		[3] = "MonTest03",
		[4] = "MonTest04"
	}
	
	--重力装置信息参数
	self.gravityList =
	{
		[1] = {state = self.monsterStateEnum.Default,wave =1,distance = 0,pos=0,radius = 18,inRadius = false,round = true, roundDeep = 13},
		[2] = {state = self.monsterStateEnum.Default,wave =2,distance = 0,pos=0,radius = 15,inRadius = false,round = false,roundDeep = 5},
	}
	
	--重力装置信息参数——点位
	self.gravityDotList =
	{
		[1] = "Gravity01",
		[2] = "Gravity02",
	}
	
	--怪物死亡数量
	self.monsterDead  = 0
	--自动填充怪物上限
	self.monsterLimit = 3
	--怪物出现{最近,最远}距离
	self.monsterBornDistance = {5,8}
	
	--距离警告
	self.distanceWarning = false
	--距离范围
	self.warninDistance = 10
	--警告时间
	self.warningEndTime = nil
	--警告时长(秒)
	self.warningTime = 8
	
	--创建无人机
	self.createThing = true
	
	--是否创造了重力装置
	self.createGravity = false
	--重力装置id
	self.gravityEntity = 203051113
	self.gravityId = nil
	--重力装置摧毁数量
	self.gravityDead = 0
	--重力异常范围
	self.gravityRadius = 30
	self.gravityNum = 0
	self.gravityLimit = nil
end

function LevelBehavior10011004:LateInit()
	----设置任务开始位置
	--if not self.levelStartPos then
		--if self.rogueEventId then
			--self.levelStartPos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
		--else
			--self.levelStartPos = BehaviorFunctions.GetPositionP(self.role)
		--end
	--end
end

function LevelBehavior10011004:Update()
	self.time = BehaviorFunctions.GetFightFrame() --获得游戏当前帧数
	self.role = BehaviorFunctions.GetCtrlEntity() --获得当前操控角色
	

	
	--关卡处于默认状态时
	if self.levelState == self.levelStateEnum.Default then
		if not self.levelStartPos then
			if self.rogueEventId then
				--获取Rogue_Event表中配置的点位信息
				local pos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
				self.levelStartPos = BehaviorFunctions.GetTerrainPositionP(pos.position,pos.positionId,pos.logicName)
			else
				--如果获取不到点位就在玩家身边创建
				self.levelStartPos = BehaviorFunctions.GetPositionP(self.role)
			end
		end

		--创建关卡开启路牌
		if self.levelFlagState == self.levelFlagStateEnum.Default then
			self.levelFlag = BehaviorFunctions.CreateEntity(200000108,nil,self.levelStartPos.x,self.levelStartPos.y,self.levelStartPos.z,nil,nil,nil,self.levelId)
			self.levelFlagState = self.levelFlagStateEnum.Showing
		end
		
		--关卡追踪标
		if self.guidePos then
			local pos = BehaviorFunctions.GetTerrainPositionP(self.guidePos.position,self.guidePos.positionId,self.guidePos.logicName)
			self:RogueGuidePointer(pos,self.guideDistance,self.GuideTypeEnum.Police)
		else
			if self.rogueEventId then
				self.guidePos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
			end
		end
	
	----关卡处于默认状态时
	--if self.levelState == self.levelStateEnum.Default then
		--if not self.levelStartPos then
			--self.levelStartPos = BehaviorFunctions.GetPositionP(self.role)
		--end
		
		--if self:CheckPlayerInRange(self.startRange) then --检查角色是否在关卡开始范围内
			--BehaviorFunctions.ShowTip(32000008) --显示敌人剩余数量
			--BehaviorFunctions.ChangeSubTipsDesc(1,32000008,#self.monsterList) --修改剩余敌人数量
			--BehaviorFunctions.ChangeSubTipsDesc(2,32000008,#self.gravityList) --修改剩余重力装置数量
			--self.levelState = self.levelStateEnum.Ongoing	--修改关卡状态为进行中
		--end
		
	--关卡处于开始状态
	elseif self.levelState == self.levelStateEnum.Start then
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		BehaviorFunctions.ShowTip(32000008) --显示敌人剩余数量
		BehaviorFunctions.ChangeSubTipsDesc(1,32000008,#self.monsterList) --修改剩余敌人数量
		BehaviorFunctions.ChangeSubTipsDesc(2,32000008,#self.gravityList) --修改剩余重力装置数量
		self.levelState = self.levelStateEnum.Ongoing	
		
	--若关卡处于进行中状态
	elseif self.levelState == self.levelStateEnum.Ongoing then
		--自动补充怪物数量
		self:SummonMonster(self.monsterList,self.monsterDotList,self.monsterLimit)
		--怪物队列死完进入胜利状态
		if self:KillAllMonsterChallenge(self.monsterList,self.gravityList) == true then
			self.levelState = self.levelStateEnum.LevelSuccess
		end

		--创建重力装置
		if self.createGravity == false then
			--self.gravityId = BehaviorFunctions.CreateEntityByPosition(self.gravityEntity, self.me, "Gravity01", "Rogue_island", 10020004, 10020004, nil)
			self:SummonGravity(self.gravityList,self.gravityDotList)
			self.createGravity = true
		end
		
		--判断最大重力装置数量
		if self.gravityLimit == nil then
			self.gravityLimit = #self.gravityList			
		end
		--判断是否增加重力异常buff
		if next(self.gravityList) then
			for i = 1, #self.gravityList do
				--判断当前重力装置是否激活且为摧毁
				if self.gravityList[i].state == self.monsterStateEnum.Live then
					self.role = BehaviorFunctions.GetCtrlEntity() --获得当前操控角色
					self.gravityList[i].distance = BehaviorFunctions.GetDistanceFromTarget(self.gravityList[i].Id,self.role,false)
					self.gravityList[i].pos = BehaviorFunctions.GetPositionP(self.gravityList[i].Id)
						
					--重力装置是否从本身的平面开始判定
					--如果是从自身高度开始判断
					if self.gravityList[i].round == false then
						--检测是否在重力装置的生效范围内（要在重力装置的平面上,通过roundDeep来控制开始计算的平面高度）
						if self.gravityList[i].distance < self.gravityList[i].radius and
							self.gravityList[i].pos.y-self.gravityList[i].roundDeep < self.rolePos.y then
							----设置角色攻击目标
							--if self.gravityList[i].distance < 10 then
								--BehaviorFunctions.SetEntityTrackTarget(self.role,self.gravityList[i].Id)
								--BehaviorFunctions.SetLockTarget(self.gravityList[i].Id)
							--end
							if self.gravityList[i].inRadius == false then
								self.gravityNum = self.gravityNum +1
								self.gravityList[i].inRadius = true
	
							end
						--不在重力装置的生效范围内
						else
							if self.gravityList[i].inRadius == true then
								self.gravityNum = self.gravityNum -1
								self.gravityList[i].inRadius = false
							end
						end
					--如果不必从自身高度开始判断
					else
						--检测是否在重力装置的生效范围内
						if self.gravityList[i].distance < self.gravityList[i].radius then
							----设置角色攻击目标
							--if self.gravityList[i].distance < 10 then
								--BehaviorFunctions.SetEntityTrackTarget(self.role,self.gravityList[i].Id)
								--BehaviorFunctions.SetLockTarget(self.gravityList[i].Id)
							--end
							if self.gravityList[i].inRadius == false then
								self.gravityNum = self.gravityNum +1
								self.gravityList[i].inRadius = true
							end
							--不在重力装置的生效范围内
						else
							if self.gravityList[i].inRadius == true then
								self.gravityNum = self.gravityNum -1
								self.gravityList[i].inRadius = false
							end
						end
					end

				--如果当前重力装置摧毁
				elseif self.gravityList[i].state == self.monsterStateEnum.Dead then
					if self.gravityList[i].inRadius == true then
						self.gravityNum = self.gravityNum -1
						self.gravityList[i].inRadius = false
					end
				end
			end
		end
		
		--self.role1 = BehaviorFunctions.GetCurFormationEntities()
		--print(self.role1)

		--根据gravityNum的数量来判断是否要增加/移除重力异常状态
		if self.gravityNum > 0 then
			if BehaviorFunctions.HasBuffKind(self.role,1000100) then
			else
				BehaviorFunctions.AddBuff(self.role,self.role,1000100)
			end
		else
			if BehaviorFunctions.HasBuffKind(self.role,1000100) then
			BehaviorFunctions.RemoveBuff(self.role,1000100)
			end
		end
		
		----创建武装无人机
		--if self.createThing == false then
			--BehaviorFunctions.CreateEntityByPosition(20305023,nil,"Aircraft01","Rogue_island", 10020004, 10020004, nil)	
			--self.createThing = true
		--end
		

	--关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccess then
		BehaviorFunctions.HideTip(32000008) --隐藏敌人数量的tips
		if self.rogueEventId then
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,true)
		end
		self.gravityNum = 0
		self.levelState = self.levelStateEnum.LevelEnd
		--删除重力异常buff
		if BehaviorFunctions.HasBuffKind(self.role,1000100) then
			BehaviorFunctions.RemoveBuff(self.role,1000100)
		end
	--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		BehaviorFunctions.HideTip(32000008)
		if self.rogueEventId then
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,false)
		end
		self.gravityNum = 0
		--删除重力异常buff
		if BehaviorFunctions.HasBuffKind(self.role,1000100) then
			BehaviorFunctions.RemoveBuff(self.role,1000100)
		end
		self.levelState = self.levelStateEnum.LevelEnd
	--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then
	end
end

--检查玩家角色是否处于关卡范围内
function LevelBehavior10011004:CheckPlayerInRange(distance)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance2 = BehaviorFunctions.GetDistanceFromPos(playerPos,self.levelStartPos)
	if distance2 < distance then
		return true
	else
		return false
	end
end

--肉鸽追踪
function LevelBehavior10011004:RogueGuidePointer(guidePos,guideDistance,guideType)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	if distance <= guideDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(2001,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			self.guide =BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
		end
	else
		--移除追踪标空实体
		if self.guideEntity and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

--进入实体范围
function LevelBehavior10011004:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerInstanceId == self.levelFlag then
			self.levelFlagInteractionId = BehaviorFunctions.WorldInteractActive(self.levelFlag,WorldEnum.InteractType.Talk,nil,"开始挑战",1)
		end
	end
end

--退出实体范围
function LevelBehavior10011004:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerInstanceId == self.levelFlag then
			BehaviorFunctions.WorldInteractRemove(self.levelFlag,self.levelFlagInteractionId)
		end
	end
end

--实体按钮交互
function LevelBehavior10011004:WorldInteractClick(uniqueId,instanceId)
	if uniqueId == self.levelFlagInteractionId and instanceId == self.levelFlag then
		self.levelState = self.levelStateEnum.Start
		BehaviorFunctions.WorldInteractRemove(self.levelFlag,self.levelFlagInteractionId)
		BehaviorFunctions.RemoveEntity(self.levelFlag)
		
		--移除追踪标空实体
		if self.guideEntity and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

--召唤敌人
function LevelBehavior10011004:SummonMonster(monsterList,monsterDotList,monsterNumLimit)
	local currentMonsterNum = 0
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			currentMonsterNum = currentMonsterNum + 1
		end
	end
	if currentMonsterNum < monsterNumLimit then
		local needRefill = monsterNumLimit - currentMonsterNum
		for i = 1,needRefill do
			for i,v in ipairs(monsterList) do
				if v.state == self.monsterStateEnum.Default then
					--local randomDis = math.random(self.monsterBornDistance[1],self.monsterBornDistance[2])
					--local pos = self:ReturnPosition(self.role,randomDis,0,360,0.5,true)
					local pos = BehaviorFunctions.GetTerrainPositionP(monsterDotList[i],10020004,"Rogue_island")
					monsterList[i].Id = BehaviorFunctions.CreateEntity(monsterList[i].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
					monsterList[i].state = self.monsterStateEnum.Live
					BehaviorFunctions.AddEntityGuidePointer(monsterList[i].Id,1,0,true)
					--BehaviorFunctions.DoLookAtTargetImmediately(monsterList[i].Id,self.role)
					----关闭警戒
					--BehaviorFunctions.SetEntityValue(monsterList[i].Id,"haveWarn",false)
					break
				end
			end
		end
	end
end

--召唤重力装置
function LevelBehavior10011004:SummonGravity(gravityList,gravityDotList)
	local currentGravityNum = 0
	for i,v in ipairs(gravityList) do
		if v.state == self.monsterStateEnum.Live then
			currentGravityNum = currentGravityNum + 1
		end
	end

	for i,v in ipairs(gravityList) do
		if v.state == self.monsterStateEnum.Default then
			gravityList[i].Id = BehaviorFunctions.CreateEntityByPosition(self.gravityEntity, self.me, gravityDotList[i], "Rogue_island", 10020004, 10020004, nil)
			gravityList[i].state = self.monsterStateEnum.Live
			BehaviorFunctions.AddEntityGuidePointer(gravityList[i].Id,self.GuideTypeEnum.Police,0,false)
			BehaviorFunctions.AddBuff(gravityList[i].Id,gravityList[i].Id,200001103)
			BehaviorFunctions.RemoveBuff(gravityList[i].Id,200001103)
			BehaviorFunctions.AddBuff(gravityList[i].Id,gravityList[i].Id,200001103)
		end
	end
end

--解决全部敌人
function LevelBehavior10011004:KillAllMonsterChallenge(monsterList,gravityList)
	for i,v in ipairs(monsterList) do
		if v.state ~= self.monsterStateEnum.Dead then
			return false
		end
	end
	
	for i,v in ipairs(gravityList) do
		if v.state ~= self.monsterStateEnum.Dead then
			return false
		end
	end
	
	return true
end

function LevelBehavior10011004:Die(attackInstanceId,instanceId)
	--怪物死亡计数
	for i,v in ipairs(self.monsterList) do
		if instanceId == v.Id then
			self.monsterDead = self.monsterDead + 1
			local totalMonster = #self.monsterList - self.monsterDead
			BehaviorFunctions.ChangeSubTipsDesc(1,32000008,totalMonster)
		end
	end
	
	--重力装置摧毁计数
	for i,v in ipairs(self.gravityList) do
		if instanceId == v.Id then
			self.gravityDead = self.gravityDead + 1
			local totalGravity = #self.gravityList - self.gravityDead
			BehaviorFunctions.ChangeSubTipsDesc(2,32000008,totalGravity)
		end
	end
end

function LevelBehavior10011004:Death(instanceId,isFormationRevive)
	--角色死亡判负
	if isFormationRevive then
		self.levelState = self.levelStateEnum.LevelFail
	end
	--怪物死亡计数
	for i,v in ipairs(self.monsterList) do
		if instanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
		end
	end
	
	--重力装置摧毁计数
	for i,v in ipairs(self.gravityList) do
		if instanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
		end
	end
end

--检查坐标点是否处于画面中
function LevelBehavior10011004:CheckPosInCam(Position)
	local uiPos = UtilsBase.WorldToUIPointBase(Position.x,Position.y,Position.z)
	if uiPos.z > 0 and math.abs(uiPos.x) <= 640 and math.abs(uiPos.y) <= 360 then
		return true
	else
		return false
	end
end

function LevelBehavior10011004:OnSwitchPlayerCtrl(oldInstanceId, instanceId)
	if BehaviorFunctions.HasBuffKind(oldInstanceId,1000100) then
		BehaviorFunctions.RemoveBuff(oldInstanceId,1000100)
		BehaviorFunctions.AddBuff(instanceId,instanceId,1000100)
	end
end