LevelBehavior302040601 = BaseClass("LevelBehavior302040601",LevelBehaviorBase)

function LevelBehavior302040601.GetGenerates()
	local generates = {2030803,2041101,
	2030806,	--喷火装置烟雾
	790012000,		--近战怪物
	790013000,		--远程怪物
	2030204,2030811,		--箱子
	2030211,		--火药桶
	2030812,		--箱子火焰
	200000107,		--箱子移除特效
	}
	return generates
end

function LevelBehavior302040601.GetMagics()
	local generates = {}
	return generates
end

function LevelBehavior302040601:__init(fight)
	self.fight = fight
end

function LevelBehavior302040601:Init()
	self.role = 1		--角色
	self.playerPos = nil		--角色坐标
	self.missionState = 0	--关卡阶段
	self.levelWin = false		--关卡胜利判断
	self.missionDistance = 0	--玩家和关卡坐标的距离
	self.combatFireDevice = 0	--摧毁火焰装置数量
	self.fireBuff = 1000105		--火焰
	
	--障碍物信息
	self.ObstaclesEntityIdA = 2030811		--障碍物实体ID
	self.ObstaclesEntityIdC = 2030211		--火药桶ID
	self.ObstaclesList = {
		[1] = {Id = nil ,posName = "Pos1" ,isDead = false ,entityId = self.ObstaclesEntityIdA},
		[2] = {Id = nil ,posName = "Pos2" ,isDead = false ,entityId = self.ObstaclesEntityIdA},
		[3] = {Id = nil ,posName = "Pos3" ,isDead = false ,entityId = self.ObstaclesEntityIdA},
		[4] = {Id = nil ,posName = "Pos4" ,isDead = false ,entityId = self.ObstaclesEntityIdA},
		[5] = {Id = nil ,posName = "Pos5" ,isDead = false ,entityId = self.ObstaclesEntityIdA},
		[6] = {Id = nil ,posName = "Pos6" ,isDead = false ,entityId = self.ObstaclesEntityIdA},
	}
	self.updateFireDevice = 0
	self.numFireDevice = 6
	self.CollideCheck = false

	--tips
	self.combatTips = 102670113
	self.combatTipsId = nil
	self.showTips = 102670114
	self.showTipsCheck = false
	self.numObstacles = 2
	self.updateObstacles = 0
	self.tipsCheck = false

	--怪物tips
	self.monShowTips = 102670125	--击败敌人showtips
	self.monCombatTips = 102670127	--敌人侧边栏提示
	self.monTipsCheck = false
	self.monCombatTipsId = nil

	--关卡倒计时
	self.time = 0
	self.timeLimit = 60
	self.startFrame = nil
	self.timeLimitFrames = 0
	self.timeCheck = false
	self.timeAddCheck = false
	self.Add = 45

	--肉鸽ID数据--后端传参数
	self.rogueData = nil --------rogue事件数据集
	self.roguePosName = nil -----rogue生成点位名称
	--肉鸽关卡开启参数
	self.missionStartDis = 30 ---挑战开始距离
	self.missionStartPos = nil --挑战开始位置
	self.missionCreate = false --检查关卡是否加载
	self.missionDistance = nil --操作角色与挑战关卡的距离
	self.eventId = nil ----------rogue事件ID
	self.missionUnloadDis = 90 --肉鸽玩法未开始的卸载距离
	self.unloaded = false
	self.ShowCommonTitleDis = 70	--城市威胁提示

	--追踪标
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 40				--加载追踪图标距离
	self.guideDistanceMin = 30			--隐藏追踪图标最小距离
	self.guidePos = nil
	self.guideEmptyEntityId = 2041101		--追中图标用空实体
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
		Attacking = FightEnum.GuideType.Map_Attacking,
	}

	--延时调用
	self.delayCallList = {}
	--当前延时数量
	self.currentdelayCallNum = 0

	--怪物信息
	self.monEntityIdA = 790012000
	self.monEntityIdB = 790013000
	self.monsterList = {
		[1] = {Id = nil ,posName = "Mon1" ,isDead = false ,entityId = self.monEntityIdA ,patrolList = {"Mon1","Mon1return"}},
		[2] = {Id = nil ,posName = "Mon2" ,isDead = false ,entityId = self.monEntityIdB ,patrolList = {"Mon2","Mon2return"}},
		[3] = {Id = nil ,posName = "Mon3" ,isDead = false ,entityId = self.monEntityIdA ,patrolList = {"Mon3","Mon3return"}},
		[4] = {Id = nil ,posName = "Mon4" ,isDead = false ,entityId = self.monEntityIdB ,patrolList = {"Mon4","Mon4return"}},
	}
	self.monDeadNum = 0
	self.monDeadAllNum = 4

	--火焰信息
	self.FireEntity = 2030812
	self.FireList = {
		[1] = {Id = nil,},
		[2] = {Id = nil,},
		[3] = {Id = nil,},
		[4] = {Id = nil,},
		[5] = {Id = nil,},
		[6] = {Id = nil,},
	}

	self.BoomEntityId = 200000107
	self.BoomList = {
		[1] = {Id = nil,},
		[2] = {Id = nil,},
		[3] = {Id = nil,},
		[4] = {Id = nil,},
		[5] = {Id = nil,},
		[6] = {Id = nil,},
	}

	self.RemoveFire = false
end

function LevelBehavior302040601:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    self.time = BehaviorFunctions.GetFightFrame()
	self.playerPos = BehaviorFunctions.GetPositionP(self.role)  -- 获取玩家的坐标
	self.missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)	--关卡坐标点

	--获取玩家和关卡坐标的距离函数
	self:updatePlayerDistance()

	--创建追中图标
	if self.missionState ~= 999 then
		self:GuidePointer(self.missionStartPos,self.guideDistance,self.missionStartDis,self.GuideTypeEnum.Attacking)	--调用关卡追踪标 函数
	end

	--根据距离更新tips
	if self.missionState ~= 999 then
		if self.missionDistance <= self.missionStartDis then

			--开场怪物tips
			if self.monTipsCheck == false then
				BehaviorFunctions.ShowCommonTitle(10,"击败所有敌人",true)
				self.monCombatTipsId = BehaviorFunctions.AddLevelTips(self.monCombatTips,self.levelId)
				BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
				self.monTipsCheck = true
			end

			if self.monDeadNum == self.monDeadAllNum then
				if self.CollideCheck == false then
					if self.monCombatTipsId ~= nil then
						BehaviorFunctions.ChangeLevelSubTipsState(self.monCombatTipsId,1,true)
						BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)
					end
					--移除免疫受击
					for i, v in pairs(self.ObstaclesList) do
						if v.Id ~= nil then
							BehaviorFunctions.SetPartEnableHit(v.Id, "Body", true)
						end
					end
					self.CollideCheck = true
				end

				if self.tipsCheck == false then
					-- BehaviorFunctions.ShowTip(self.showTips)
					BehaviorFunctions.ShowCommonTitle(10,"此处有障碍物阻挡道路",true)
					self.combatTipsId = BehaviorFunctions.AddLevelTips(self.combatTips,self.levelId)
					BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
					self.timeCheck = true
					self.tipsCheck = true
				end
			else
				--添加免疫受击
				for i, v in pairs(self.ObstaclesList) do
					if v.Id ~= nil then
						BehaviorFunctions.SetPartEnableHit(v.Id, "Body", false)
					end
				end
			end
		elseif self.missionDistance < self.missionUnloadDis and self.missionDistance >= self.missionStartDis then
				BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
				BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)
				self.tipsCheck = false
			-- end
		end

		--城市威胁提示
		if self.missionDistance <= self.ShowCommonTitleDis then
			if self.showTipsCheck == false then
				BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
				self.showTipsCheck = true
			end
		end
	end

	-- 检查是否应该更新Tips和胜利条件
	if self.missionState ~= 999 then

		-- for i, v in ipairs(self.ObstaclesList) do
		-- 	if v.Id ~= nil then
		-- 		if BehaviorFunctions.GetEntityValue(v.Id,"isOpen") == true then
		-- 			self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,v.Id)
		-- 		end
		-- 	end
		-- end

		if self.timeCheck == true then
			if self.ObstaclesList[1].Id ~= nil then
				if BehaviorFunctions.GetEntityValue(self.ObstaclesList[1].Id,"isOpen") then
					self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.ObstaclesList[1].Id)
				end
			end
			if self.ObstaclesList[2].Id ~= nil then
				if BehaviorFunctions.GetEntityValue(self.ObstaclesList[2].Id,"isOpen") then
					self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.ObstaclesList[2].Id)
				end
			end
			if self.ObstaclesList[3].Id ~= nil then
				if BehaviorFunctions.GetEntityValue(self.ObstaclesList[3].Id,"isOpen") then
					self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.ObstaclesList[3].Id)
				end
			end
			if self.ObstaclesList[4].Id ~= nil then
				if BehaviorFunctions.GetEntityValue(self.ObstaclesList[4].Id,"isOpen") then
					self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.ObstaclesList[4].Id)
				end
			end
			if self.ObstaclesList[5].Id ~= nil then
				if BehaviorFunctions.GetEntityValue(self.ObstaclesList[5].Id,"isOpen") then
					self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.ObstaclesList[5].Id)
				end
			end
			if self.ObstaclesList[6].Id ~= nil then
				if BehaviorFunctions.GetEntityValue(self.ObstaclesList[6].Id,"isOpen") then
					self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.ObstaclesList[6].Id)
				end
			end
		end
	end

	if self.missionState == 0 then
		--创建怪物
		self:CreateMonster(self.monsterList)
		self:MonsterPatrol(self.monsterList)
		self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
		self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowMapArea,self.levelId, true)

		--创建障碍物
		-- self:CreateMonster(self.ObstaclesList)
		self.ObstaclesList[1].Id = BehaviorFunctions.CreateEntityByPosition(self.ObstaclesList[1].entityId, nil, self.ObstaclesList[1].posName, self.logicName, self.levelId,self.levelId)
		self.ObstaclesList[2].Id = BehaviorFunctions.CreateEntityByPosition(self.ObstaclesList[2].entityId, nil, self.ObstaclesList[2].posName, self.logicName, self.levelId,self.levelId)
		self.ObstaclesList[3].Id = BehaviorFunctions.CreateEntityByPosition(self.ObstaclesList[3].entityId, nil, self.ObstaclesList[3].posName, self.logicName, self.levelId,self.levelId)
		self.ObstaclesList[4].Id = BehaviorFunctions.CreateEntityByPosition(self.ObstaclesList[4].entityId, nil, self.ObstaclesList[4].posName, self.logicName, self.levelId,self.levelId)
		self.ObstaclesList[5].Id = BehaviorFunctions.CreateEntityByPosition(self.ObstaclesList[5].entityId, nil, self.ObstaclesList[5].posName, self.logicName, self.levelId,self.levelId)
		self.ObstaclesList[6].Id = BehaviorFunctions.CreateEntityByPosition(self.ObstaclesList[6].entityId, nil, self.ObstaclesList[6].posName, self.logicName, self.levelId,self.levelId)


		self.missionState = 1
	elseif self.missionState == 1 then
		self.missionState = 2
	elseif self.missionState == 2 then
		--关卡胜利
		if self.updateFireDevice == self.numFireDevice then
			if self.timeAddCheck == false then
				self.timeAdd =  self.time + self.Add
				self.timeAddCheck = true
			end
			if self.time >= (self.timeAdd + 1) and self.time < (self.timeAdd + 30) then
				if self.levelWin == false then
					if self.combatTipsId ~= nil then
						BehaviorFunctions.ChangeLevelSubTipsState(self.combatTipsId,2,true)
					end
					BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
					self.levelWin = true
				end
			end
			if self.time >= (self.timeAdd + 60) and self.time < (self.timeAdd + 65) then
				if self.RemoveFire == false then
					-- BehaviorFunctions.ShowBlackCurtain(true,0.5)	--黑幕
					-- BehaviorFunctions.HideTip(self.combatTips)
					BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
					self.RemoveFire = true
				end
			end
			if self.time >= (self.timeAdd + 90) and self.time < (self.timeAdd + 95) then
				-- BehaviorFunctions.ShowBlackCurtain(false,0.5)
				BehaviorFunctions.FinishLevel(self.levelId)
				self.missionState = 999
			-- elseif self.time >= (self.timeAdd + 90) and self.time < (self.timeAdd + 95) then
			end
		end
	end
end

--受击
function LevelBehavior302040601:Damage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt,camp)
	-- if attackInstanceId == self.role then
	-- 	if damageElementType == FightEnum.ElementType.Fire then
	-- 		if hitInstanceId == self.ObstaclesList[1].Id then
	-- 			if self.FireList[1].Id == nil then
	-- 				self.FireList[1].Id = BehaviorFunctions.CreateEntityByPosition(self.FireEntity, nil, self.ObstaclesList[1].posName, self.logicName, self.levelId,self.levelId)
	-- 			end
	-- 		end
	-- 		if hitInstanceId == self.ObstaclesList[2].Id then
	-- 			if self.FireList[2].Id == nil then
	-- 				self.FireList[2].Id = BehaviorFunctions.CreateEntityByPosition(self.FireEntity, nil, self.ObstaclesList[2].posName, self.logicName, self.levelId,self.levelId)
	-- 			end
	-- 		end
	-- 		if hitInstanceId == self.ObstaclesList[3].Id then
	-- 			if self.FireList[3].Id == nil then
	-- 				self.FireList[3].Id = BehaviorFunctions.CreateEntityByPosition(self.FireEntity, nil, self.ObstaclesList[3].posName, self.logicName, self.levelId,self.levelId)

	-- 			end
	-- 		end
	-- 		if hitInstanceId == self.ObstaclesList[4].Id then
	-- 			if self.FireList[4].Id == nil then
	-- 				self.FireList[4].Id = BehaviorFunctions.CreateEntityByPosition(self.FireEntity, nil, self.ObstaclesList[4].posName, self.logicName, self.levelId,self.levelId)
	-- 			end
	-- 		end
	-- 		if hitInstanceId == self.ObstaclesList[5].Id then
	-- 			if self.FireList[5].Id == nil then
	-- 				self.FireList[5].Id = BehaviorFunctions.CreateEntityByPosition(self.FireEntity, nil, self.ObstaclesList[5].posName, self.logicName, self.levelId,self.levelId)
	-- 			end
	-- 		end
	-- 		if hitInstanceId == self.ObstaclesList[6].Id then
	-- 			if self.FireList[6].Id == nil then
	-- 				self.FireList[6].Id = BehaviorFunctions.CreateEntityByPosition(self.FireEntity, nil, self.ObstaclesList[6].posName, self.logicName, self.levelId,self.levelId)
	-- 			end
	-- 		end
	-- 	end
	-- end
end

--死亡回调
function LevelBehavior302040601:Death(instanceId,isFormationRevive)
	for i, v in ipairs(self.monsterList) do
		if instanceId == v.Id and v.isDead == false then
			v.isDead = true
			self.monDeadNum = self.monDeadNum + 1
			BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
		end
	end
end

function LevelBehavior302040601:RemoveEntity(instanceId)
	for i, v in ipairs(self.ObstaclesList) do
		if instanceId == v.Id and v.isDead == false then
			v.isDead = true
			self.updateFireDevice = self.updateFireDevice + 1
			BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
			v.isDead = true
			v.Id = nil
		end
	end

	if instanceId == self.ObstaclesList[1].Id then
	-- 	BehaviorFunctions.RemoveEntity(self.FireList[1].Id)
	-- 	BehaviorFunctions.DoMagic(1,self.ObstaclesList[1].Id,900000010)
	-- 	self.BoomList[1].Id = BehaviorFunctions.CreateEntityByPosition(self.BoomEntityId, nil, self.ObstaclesList[1].posName, self.logicName, self.levelId,self.levelId)
	-- end
	-- if instanceId == self.ObstaclesList[2].Id then
	-- 	BehaviorFunctions.RemoveEntity(self.FireList[2].Id)
	-- 	BehaviorFunctions.DoMagic(1,self.ObstaclesList[2].Id,900000010)
	-- 	self.BoomList[2].Id = BehaviorFunctions.CreateEntityByPosition(self.BoomEntityId, nil, self.ObstaclesList[2].posName, self.logicName, self.levelId,self.levelId)
	-- end
	-- if instanceId == self.ObstaclesList[3].Id then
	-- 	BehaviorFunctions.RemoveEntity(self.FireList[3].Id)
	-- 	BehaviorFunctions.DoMagic(1,self.ObstaclesList[3].Id,900000010)
	-- 	self.BoomList[3].Id = BehaviorFunctions.CreateEntityByPosition(self.BoomEntityId, nil, self.ObstaclesList[3].posName, self.logicName, self.levelId,self.levelId)
	-- end
	-- if instanceId == self.ObstaclesList[4].Id then
	-- 	BehaviorFunctions.RemoveEntity(self.FireList[4].Id)
	-- 	BehaviorFunctions.DoMagic(1,self.ObstaclesList[4].Id,900000010)
	-- 	self.BoomList[4].Id = BehaviorFunctions.CreateEntityByPosition(self.BoomEntityId, nil, self.ObstaclesList[4].posName, self.logicName, self.levelId,self.levelId)
	-- end
	-- if instanceId == self.ObstaclesList[5].Id then
	-- 	BehaviorFunctions.RemoveEntity(self.FireList[5].Id)
	-- 	BehaviorFunctions.DoMagic(1,self.ObstaclesList[5].Id,900000010)
	-- 	self.BoomList[5].Id = BehaviorFunctions.CreateEntityByPosition(self.BoomEntityId, nil, self.ObstaclesList[5].posName, self.logicName, self.levelId,self.levelId)
	-- end
	-- if instanceId == self.ObstaclesList[6].Id then
	-- 	BehaviorFunctions.RemoveEntity(self.FireList[6].Id)
	-- 	BehaviorFunctions.DoMagic(1,self.ObstaclesList[6].Id,900000010)
	-- 	self.BoomList[6].Id = BehaviorFunctions.CreateEntityByPosition(self.BoomEntityId, nil, self.ObstaclesList[6].posName, self.logicName, self.levelId,self.levelId)
	end
end

--获取玩家和关卡坐标的距离
function LevelBehavior302040601:updatePlayerDistance()
	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)  -- 获取玩家的坐标
	end
	local missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)
	if missionStartPos ~= nil then
		self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos, missionStartPos)  -- 计算玩家和关卡的距离
	end
end

--追踪指标
function LevelBehavior302040601:GuidePointer(guidePos,guideDistance,minDistance,guideType)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	if distance <= guideDistance and distance > minDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(self.guideEmptyEntityId,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			self.guide =BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
		end
	elseif distance > guideDistance then
		--移除追踪标空实体
		if self.guideEntity ~= nil and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	elseif distance <= minDistance then
		--移除追踪标空实体
		if self.guideEntity ~= nil and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

--游戏内参数更新
function LevelBehavior302040601:GameUpdateTipsNum()
	self.updateFireDevice = self.numFireDevice - self.buffSum
	-- self.combatFireDevice = self.combatFireDevice + 1
	-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updateFireDevice, self.numFireDevice)
	BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
end


--创建喷火装置
function LevelBehavior302040601:createFireDevicesIfNil(FireDeviceId, PosName )
    if not FireDeviceId then
        FireDeviceId = BehaviorFunctions.CreateEntityByPosition(self.FireDeviceEntityId, nil, PosName, self.logicName, self.levelId, self.levelId, nil)
		return FireDeviceId
    end
end
--移除喷火装置
function LevelBehavior302040601:RemoveFireDevices(Num)
	if self.FireDevice[Num] ~= nil then
		BehaviorFunctions.RemoveEntity(self.FireDevice[Num])
		self.FireDevice[Num] = nil
	end
end

--创建实体
function LevelBehavior302040601:CreateMonster(monsterList)
	for i,v in ipairs (monsterList) do
		v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.logicName, self.levelId,self.levelId)
		-- v.state = self.monsterStateEnum.Live
	end
end
--移除怪物
function LevelBehavior302040601:RemoveEntityId(entityId)
	if entityId ~= nil then
		BehaviorFunctions.RemoveEntity(entityId)
		entityId = nil
	end
end

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function LevelBehavior302040601:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function LevelBehavior302040601:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end

--怪物巡逻
function LevelBehavior302040601:MonsterPatrol(monsterList)
	for i,v in ipairs (monsterList) do
		if v.Id ~= nil then
			if v.patrolList then
				local patrolPosList = {}
				for index,posName in ipairs(v.patrolList) do
					local pos = BehaviorFunctions.GetTerrainPositionP(posName,self.levelId,self.logicName)
					table.insert(patrolPosList,pos)
				end
				BehaviorFunctions.SetEntityValue(v.Id,"peaceState",1) --设置为巡逻
				BehaviorFunctions.SetEntityValue(v.Id,"patrolPositionList",patrolPosList)--传入巡逻列表
				BehaviorFunctions.SetEntityValue(v.Id,"canReturn",true)--往返设置
			end
		end
	end
end