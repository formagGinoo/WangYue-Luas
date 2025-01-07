LevelBehavior10011002 = BaseClass("LevelBehavior10011002",LevelBehaviorBase)
--肉鸽测试关卡:楼顶战斗关卡
function LevelBehavior10011002:__init(fight)
	self.fight = fight
end


function LevelBehavior10011002.GetGenerates()
	local generates = {900120,910040}
	return generates
end


function LevelBehavior10011002:Init()
	self.me = self.instanceId
	self.role = BehaviorFunctions.GetCtrlEntity()
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
		Start = 1,
		Ongoing = 2,
		LevelSuccece = 3,
		LevelFail = 4,
		LevelEnd = 5,
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
	--关卡其实点位实体
	self.levelStartPosIns = nil

	
	--怪物信息参数
	self.monsterList =
	{
		[1] = {state = self.monsterStateEnum.Default,wave = 1,entityId = 900120},
		[2] = {state = self.monsterStateEnum.Default,wave = 1,entityId = 900120},
		[3] = {state = self.monsterStateEnum.Default,wave = 1,entityId = 900120},
		[4] = {state = self.monsterStateEnum.Default,wave = 1,entityId = 900120},
		[5] = {state = self.monsterStateEnum.Default,wave = 1,entityId = 900120},
		[6] = {state = self.monsterStateEnum.Default,wave = 1,entityId = 900120},
		[7] = {state = self.monsterStateEnum.Default,wave = 1,entityId = 910040},
	}
	
	--怪物死亡数量
	self.monsterDead  = 0
	--自动填充怪物上限
	self.monsterLimit = 3
	--怪物出现{最近,最远}距离
	self.monsterBornDistance = {5,10}
	--关卡卸载距离
	self.levelRemoveDistance = 40
end

function LevelBehavior10011002:LateInit()

end

function LevelBehavior10011002:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--关卡追踪标
	if self.guidePos then
		local pos = BehaviorFunctions.GetTerrainPositionP(self.guidePos.position,self.guidePos.positionId,self.guidePos.logicName)
		self:RogueGuidePointer(pos,self.guideDistance,self.GuideTypeEnum.Police)		
	else
		if self.rogueEventId then
			self.guidePos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)	
		end
	end
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
		
	--关卡处于开始状态
	elseif self.levelState == self.levelStateEnum.Start then
		self.levelStartPosIns = BehaviorFunctions.CreateEntity(2001,nil,self.levelStartPos.x,self.levelStartPos.y,self.levelStartPos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		BehaviorFunctions.ShowTip(32000007)
		BehaviorFunctions.ChangeSubTipsDesc(1,32000007,#self.monsterList)
		self.levelState = self.levelStateEnum.Ongoing
		
	--关卡处于进行中状态
	elseif self.levelState == self.levelStateEnum.Ongoing then
		--自动补充怪物数量
		self:SummonMonster(self.levelStartPosIns,self.monsterList,self.monsterLimit)
		--怪物队列死完进入胜利状态
		if self:KillAllMonsterChallenge(self.monsterList) == true then
			self.levelState = self.levelStateEnum.LevelSuccece
		end
		local playerPos = BehaviorFunctions.GetPositionP(self.role)
		if BehaviorFunctions.GetDistanceFromPos(self.levelStartPos,playerPos) > self.levelRemoveDistance then
			self.levelState = self.levelStateEnum.LevelFail
		end
		
	--关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccece then
		BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		BehaviorFunctions.HideTip(32000007)
		if self.rogueEventId then
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,true)
		end
		self.levelState = self.levelStateEnum.LevelEnd
		
	--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		BehaviorFunctions.HideTip(32000007)
		if self.rogueEventId then
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,false)
		end
		BehaviorFunctions.RemoveLevel(self.levelId)
		self.levelState = self.levelStateEnum.LevelEnd
		
	--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then
	end
end

--进入实体范围
function LevelBehavior10011002:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerInstanceId == self.levelFlag then
			self.levelFlagInteractionId = BehaviorFunctions.WorldInteractActive(self.levelFlag,WorldEnum.InteractType.Talk,nil,"开始挑战",1)
		end
	end
end

--退出实体范围
function LevelBehavior10011002:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerInstanceId == self.levelFlag then
			BehaviorFunctions.WorldInteractRemove(self.levelFlag,self.levelFlagInteractionId)
		end
	end
end

--实体按钮交互
function LevelBehavior10011002:WorldInteractClick(uniqueId,instanceId)
	if uniqueId == self.levelFlagInteractionId and instanceId == self.levelFlag then
		self.levelState = self.levelStateEnum.Start
		BehaviorFunctions.WorldInteractRemove(self.levelFlag,self.levelFlagInteractionId)
		BehaviorFunctions.RemoveEntity(self.levelFlag)
	end
end

--检查玩家角色是否处于关卡范围内
function LevelBehavior10011002:CheckPlayerInRange(distance)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance2 = BehaviorFunctions.GetDistanceFromPos(playerPos,self.levelStartPos)
	if distance2 < distance then
		return true
	else
		return false
	end
end

--肉鸽追踪
function LevelBehavior10011002:RogueGuidePointer(guidePos,guideDistance,guideType)
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

--召唤敌人
function LevelBehavior10011002:SummonMonster(baseInstance,monsterList,monsterNumLimit)
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
					local randomDis = math.random(self.monsterBornDistance[1],self.monsterBornDistance[2])
					local pos = self:ReturnPosition(baseInstance,randomDis,0,360,0.5,true)
					monsterList[i].Id = BehaviorFunctions.CreateEntity(monsterList[i].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
					monsterList[i].state = self.monsterStateEnum.Live
					BehaviorFunctions.DoLookAtTargetImmediately(monsterList[i].Id,self.role)
					--关闭警戒
					BehaviorFunctions.SetEntityValue(monsterList[i].Id,"haveWarn",false)
					break
				end
			end
		end
	end
end

function LevelBehavior10011002:KillAllMonsterChallenge(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state ~= self.monsterStateEnum.Dead then
			return false
		end
	end
	return true
end

---返回范围内没有障碍的位置
function LevelBehavior10011002:ReturnPosition(target,distance,startAngel,endAngel,checkheight,returnFarthestPos)
	local posTable = {}
	local posTable2 = {}
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
			local layerHight,layer = BehaviorFunctions.CheckPosHeight(posClone)
			if layerHight <= 1 then
				if layer == FightEnum.Layer.Terrain or layer == FightEnum.Layer.Default then
					if BehaviorFunctions.CheckPosIsInScreen(pos) then
						table.insert(posTable2,pos)
					end
					--if self:CheckPosInCam(pos) then
						--table.insert(posTable2,pos)
					--end
					table.insert(posTable,pos)
				end
			end
		end
	end
	if #posTable2 ~= 0 then
		local randomPos = math.random(1,#posTable2)
		return posTable2[randomPos]
	else
		if #posTable ~= 0 then
			local randomPos = math.random(1,#posTable)
			return posTable[randomPos]
		else
			if not returnFarthestPos then
				return nil
			else
				--返回最远的点
				return farthestPos
			end
		end
	end
end

function LevelBehavior10011002:Die(attackInstanceId,instanceId)
	--怪物死亡计数
	for i,v in ipairs(self.monsterList) do
		if instanceId == v.Id then
			self.monsterDead = self.monsterDead + 1
			local totalMonster = #self.monsterList - self.monsterDead
			BehaviorFunctions.ChangeSubTipsDesc(1,32000007,totalMonster)
		end
	end
end

function LevelBehavior10011002:Death(instanceId,isFormationRevive)
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
end

--检查坐标点是否处于画面中
function LevelBehavior10011002:CheckPosInCam(Position)
	local uiPos = UtilsBase.WorldToUIPointBase(Position.x,Position.y,Position.z)
	if uiPos.z > 0 and math.abs(uiPos.x) <= 640 and math.abs(uiPos.y) <= 360 then
		return true
	else
		return false
	end
end
