LevelBehavior302040301 = BaseClass("LevelBehavior302040301",LevelBehaviorBase)

function LevelBehavior302040301.GetGenerates()
	local generates = {2030803,2041101,
	2030806,	--喷火装置烟雾
	790012000,		--怪物
	}
	return generates
end

function LevelBehavior302040301.GetMagics()
	local generates = {1000107}
	return generates
end

function LevelBehavior302040301:__init(fight)
	self.fight = fight
end

function LevelBehavior302040301:Init()
	self.role = 1		--角色
	self.playerPos = nil		--角色坐标
	self.missionState = 0	--关卡阶段
	self.levelWin = false		--关卡胜利判断
	self.FireDeviceEntityId = 2030803		--喷火装置实体ID
	self.missionDistance = 0	--玩家和关卡坐标的距离
	self.combatFireDevice = 0	--摧毁火焰装置数量
	self.fireBuff = 1000105		--火焰


	--喷火装置创建
	self.FireDevice = {[1]=nil,[2]=nil,[3]=nil,[4]=nil,[5]=nil,[6]=nil,}
	self.FireDevicePos = {[1]="Pos1",[2]="Pos2",[3]="Pos3",[4]="Pos4",[5]="Pos5",[6]="Pos6",}
	self.buffSum = 0
	self.buffAdd = false

	--烟雾
	self.smokeEntityId = 2030806	--烟雾
	self.smokeId = {
		[1] = {Id = nil, entityId = self.smokeEntityId ,posName = "Pos6",};
		[2] = {Id = nil, entityId = self.smokeEntityId ,posName = "Pos4",};
		[3] = {Id = nil, entityId = self.smokeEntityId ,posName = "Pos1",};
	}
	self.smokeAnima = false

	--tips
	self.combatTips = 102670106
	self.combatTipsId = nil
	self.showTips = 102670107
	self.showTipsCheck = false
	-- self.combatFireDeviceTips = 102670108	--摧毁火焰装置数量Tips
	self.numFireDevice = 6
	self.updateFireDevice = 0
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
	self.monEntityId = 790012000
	self.monsterList = {
		[1] = {Id = nil ,posName = "Mon1" ,isDead = false ,entityId = self.monEntityId ,patrolList = {"Mon1","Mon1return"}},
		[2] = {Id = nil ,posName = "Mon2" ,isDead = false ,entityId = self.monEntityId ,patrolList = {"Mon2","Mon2return"}},
		[3] = {Id = nil ,posName = "Mon3" ,isDead = false ,entityId = self.monEntityId},
	}
	self.monDeadNum = 0
	self.monDeadAllNum = 3

	self.RemoveFire = false

end

function LevelBehavior302040301:Update()
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
			--近距离移除烟雾
			for i,v in ipairs (self.smokeId) do
				self:RemoveEntityId(v.Id)
			end

			--开场怪物tips
			if self.monTipsCheck == false then
				-- BehaviorFunctions.ShowTip(self.monShowTips)
				BehaviorFunctions.ShowCommonTitle(10,"击败所有敌人",true)
				-- self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowTip,self.monCombatTips)
				-- self:AddLevelDelayCallByFrame(31,BehaviorFunctions,BehaviorFunctions.ChangeSubTipsDesc,1, self.monCombatTips, self.monDeadNum, self.monDeadAllNum)
				self.monCombatTipsId = BehaviorFunctions.AddLevelTips(self.monCombatTips,self.levelId)
				BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
				self.monTipsCheck = true
			end

			if self.monDeadNum == self.monDeadAllNum then

				if self.monCombatTipsId ~= nil then
					BehaviorFunctions.ChangeLevelSubTipsState(self.monCombatTipsId,1,true)
					BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)
					self.monCombatTipsId = nil
				end
				--移除免疫受击
				for i, v in pairs(self.FireDevice) do
					if v ~= nil then
						BehaviorFunctions.SetPartEnableHit(v, "Body", true)
					end
				end
				if self.tipsCheck == false then
					-- BehaviorFunctions.ShowTip(self.showTips)
					BehaviorFunctions.ShowCommonTitle(10,"使用水属性清除火焰装置",true)
					-- self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowTip,self.combatTips)
					self.combatTipsId = BehaviorFunctions.AddLevelTips(self.combatTips,self.levelId)
					BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
					-- self:AddLevelDelayCallByFrame(31,BehaviorFunctions,BehaviorFunctions.ChangeSubTipsDesc,2, self.combatTips, self.updateFireDevice, self.numFireDevice)
					-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updateFireDevice, self.numFireDevice)
					self.timeCheck = true
					self.tipsCheck = true
				end
			else
				--添加免疫受击
				for i, v in pairs(self.FireDevice) do
					if v ~= nil then
						BehaviorFunctions.SetPartEnableHit(v, "Body", false)
					end
				end

			end
		elseif self.missionDistance < self.missionUnloadDis and self.missionDistance >= self.missionStartDis then
			-- if self.tipsCheck == true then
				-- BehaviorFunctions.HideTip(self.combatTips)
				-- BehaviorFunctions.HideTip(self.monCombatTips)
				BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
				BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)
				self.tipsCheck = false
			-- end
		elseif self.missionDistance > self.missionUnloadDis then	--超远距离卸载关卡
			self:LevelDelete()
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
		if self.timeCheck then
			if self.updateFireDevice < self.numFireDevice then
				-- 获取两个设备上的buff数量
				local buffCount01 = BehaviorFunctions.GetBuffCount(self.FireDevice[1], self.fireBuff)
				local buffCount02 = BehaviorFunctions.GetBuffCount(self.FireDevice[2], self.fireBuff)
				local buffCount03 = BehaviorFunctions.GetBuffCount(self.FireDevice[3], self.fireBuff)
				local buffCount04 = BehaviorFunctions.GetBuffCount(self.FireDevice[4], self.fireBuff)
				local buffCount05 = BehaviorFunctions.GetBuffCount(self.FireDevice[5], self.fireBuff)
				local buffCount06 = BehaviorFunctions.GetBuffCount(self.FireDevice[6], self.fireBuff)
				self.buffSum = buffCount01 + buffCount02 + buffCount03 + buffCount04 + buffCount05 + buffCount06
				if self.buffSum == self.numFireDevice then
					self.buffAdd = true
				end
					if self.buffSum <= 0 and self.buffAdd == true then
						self:GameUpdateTipsNum()
					elseif self.buffSum <= 1 and self.buffAdd == true then
						self:GameUpdateTipsNum()
					elseif self.buffSum <= 2 and self.buffAdd == true then
						self:GameUpdateTipsNum()
					elseif self.buffSum <= 3 and self.buffAdd == true then
						self:GameUpdateTipsNum()
					elseif self.buffSum <= 4 and self.buffAdd == true then
						self:GameUpdateTipsNum()
					elseif self.buffSum <= 5 and self.buffAdd == true then
						self:GameUpdateTipsNum()
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

		--创建喷火装置
		self.FireDevice[1] = self:createFireDevicesIfNil(self.FireDevice[1],self.FireDevicePos[1])
		self.FireDevice[2] = self:createFireDevicesIfNil(self.FireDevice[2],self.FireDevicePos[2])
		self.FireDevice[3] = self:createFireDevicesIfNil(self.FireDevice[3],self.FireDevicePos[3])
		self.FireDevice[4] = self:createFireDevicesIfNil(self.FireDevice[4],self.FireDevicePos[4])
		self.FireDevice[5] = self:createFireDevicesIfNil(self.FireDevice[5],self.FireDevicePos[5])
		self.FireDevice[6] = self:createFireDevicesIfNil(self.FireDevice[6],self.FireDevicePos[6])
		--创建烟雾
		self:CreateMonster(self.smokeId)

		self.missionState = 1
	elseif self.missionState == 1 then
		self.missionState = 2
	elseif self.missionState == 2 then
		--关卡胜利
		if self.updateFireDevice == self.numFireDevice then
			if self.combatTipsId ~= nil then
				BehaviorFunctions.ChangeLevelSubTipsState(self.combatTipsId,2,true)
				BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
				self.combatTipsId = nil
			end

			if self.timeAddCheck == false then
				self.timeAdd =  self.time + self.Add
				self.timeAddCheck = true
			end
			if self.time >= (self.timeAdd + 1) and self.time < (self.timeAdd + 30) then
				if self.levelWin == false then
					BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
					self.levelWin = true
				end
			end
			if self.time >= (self.timeAdd + 60) and self.time < (self.timeAdd + 65) then
				if self.RemoveFire == false then
					-- BehaviorFunctions.ShowBlackCurtain(true,0.5)	--黑幕
					BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
					self:RemoveAllLevelDelayCall()
					self:RemoveFireDevices(1)
					self:RemoveFireDevices(2)
					self:RemoveFireDevices(3)
					self:RemoveFireDevices(4)
					self:RemoveFireDevices(5)
					self:RemoveFireDevices(6)
					for i,v in ipairs (self.smokeId) do
						self:RemoveEntityId(v.Id)
					end
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

--死亡回调
function LevelBehavior302040301:Death(instanceId,isFormationRevive)
	for i, v in pairs(self.monsterList) do
		if instanceId == v.Id and v.isDead == false then
			v.isDead = true
			self.monDeadNum = self.monDeadNum + 1
			BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
		end
	end
end

--移除关卡函数
function LevelBehavior302040301:LevelDelete()
	self:RemoveFireDevices(1)
	self:RemoveFireDevices(2)
	self:RemoveFireDevices(3)
	self:RemoveFireDevices(4)
	self:RemoveFireDevices(5)
	self:RemoveFireDevices(6)
	for i,v in ipairs (self.smokeId) do
		self:RemoveEntityId(v.Id)
	end
	self:RemoveAllLevelDelayCall()
    BehaviorFunctions.RemoveLevel(self.levelId)
	self.missionState = 999
end

--获取玩家和关卡坐标的距离
function LevelBehavior302040301:updatePlayerDistance()
	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)  -- 获取玩家的坐标
	end
	local missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)
	if missionStartPos ~= nil then
		self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos, missionStartPos)  -- 计算玩家和关卡的距离
	end
end

--追踪指标
function LevelBehavior302040301:GuidePointer(guidePos,guideDistance,minDistance,guideType)
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
function LevelBehavior302040301:GameUpdateTipsNum()
	self.updateFireDevice = self.numFireDevice - self.buffSum
	-- self.combatFireDevice = self.combatFireDevice + 1
	-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updateFireDevice, self.numFireDevice)
	-- BehaviorFunctions.ChangeLevelTitleTips(self.combatTipsId,self.updateFireDevice)
	BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)

end


--创建喷火装置
function LevelBehavior302040301:createFireDevicesIfNil(FireDeviceId, PosName )
    if not FireDeviceId then
        FireDeviceId = BehaviorFunctions.CreateEntityByPosition(self.FireDeviceEntityId, nil, PosName, self.logicName, self.levelId, self.levelId, nil)
		return FireDeviceId
    end
end
--移除喷火装置
function LevelBehavior302040301:RemoveFireDevices(Num)
	if self.FireDevice[Num] ~= nil then
		BehaviorFunctions.RemoveEntity(self.FireDevice[Num])
		self.FireDevice[Num] = nil
	end
end

--创建实体
function LevelBehavior302040301:CreateMonster(monsterList)
	for i,v in ipairs (monsterList) do
		v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.logicName, self.levelId,self.levelId)
		-- v.state = self.monsterStateEnum.Live
	end
end
--移除怪物
function LevelBehavior302040301:RemoveEntityId(entityId)
	if entityId ~= nil then
		BehaviorFunctions.RemoveEntity(entityId)
		entityId = nil
	end
end

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function LevelBehavior302040301:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function LevelBehavior302040301:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end

--怪物巡逻
function LevelBehavior302040301:MonsterPatrol(monsterList)
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