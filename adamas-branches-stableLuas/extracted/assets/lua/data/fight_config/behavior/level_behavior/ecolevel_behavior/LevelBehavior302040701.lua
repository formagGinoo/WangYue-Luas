LevelBehavior302040701 = BaseClass("LevelBehavior302040701",LevelBehaviorBase)

function LevelBehavior302040701.GetGenerates()
	local generates = {
		2030809,		--毒气罐
		2041101,		--空实体
		2030810,		--毒烟雾
		790012000,		--怪物
	}
	return generates
end

function LevelBehavior302040701.GetMagics()
	local generates = {1000115,		--毒雾屏幕特效
	}
	return generates
end

function LevelBehavior302040701:__init(fight)
	self.fight = fight
end

function LevelBehavior302040701:Init()
	self.role = 1		--角色
	self.playerPos = nil		--角色坐标
	self.missionState = 0	--关卡阶段
	self.levelWin = false		--关卡胜利判断
	self.missionDistance = 0	--玩家和关卡坐标的距离
	self.combatFireDevice = 0	--摧毁火焰装置数量
	-- self.fireBuff = 1000115		--火焰

	--喷火装置创建
	-- self.FireDevice = {[1]=nil,[2]=nil,[3]=nil,[4]=nil,[5]=nil,[6]=nil,}
	-- self.FireDevicePos = {[1]="Pos1",[2]="Pos2",[3]="Pos3",[4]="Pos4",[5]="Pos5",[6]="Pos6",}
	-- self.buffAdd = false

	self.FxMist2D = 1000115		--毒雾气屏幕特效
	--毒雾装置
	self.Gasholder01EntityId = 2030809		--毒气罐实体ID
	self.GasholderState ={
		Open = 1;
		Close = 2;
	}
	self.GasholderList = {
		[1] = {Id = nil ,posName = "Pos1" ,state = self.GasholderState.Open ,entityId = self.Gasholder01EntityId ,GuideCheck = false ,GuiId = nil ,GuidePos = "Pos1Guide"},
		[2] = {Id = nil ,posName = "Pos2" ,state = self.GasholderState.Open ,entityId = self.Gasholder01EntityId ,GuideCheck = false ,GuiId = nil ,GuidePos = "Pos2Guide"},
		[3] = {Id = nil ,posName = "Pos3" ,state = self.GasholderState.Open ,entityId = self.Gasholder01EntityId ,GuideCheck = false ,GuiId = nil ,GuidePos = "Pos3Guide"},
	}

	--烟雾
	self.smokeEntityId = 2030810	--烟雾
	self.smokeState ={
		Open = 1;
		Close = 2;
	}
	self.smokeId = {
		[1] = {Id = nil,posName = "Pos4",state = self.smokeState.Open , entityId = self.smokeEntityId ,};
		[2] = {Id = nil,posName = "Pos5",state = self.smokeState.Open , entityId = self.smokeEntityId ,};
		[3] = {Id = nil,posName = "Pos6",state = self.smokeState.Open , entityId = self.smokeEntityId ,};
	}
	self.smokeAnima = false

	--tips
	self.combatTips = 102670115
	self.combatTipsId = nil
	self.showTips = 102670116
	self.showTipsCheck = false
	self.numFireDevice = 3
	self.updateFireDevice = 0
	self.tipsCheck = false
	self.buffSum = 0

	--怪物tips
	self.monShowTips = 102670125	--击败敌人showtips
	self.monCombatTips = 102670127	--敌人侧边栏提示
	self.monTipsCheck = false
	self.monShowTipsId = nil

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
		[3] = {Id = nil ,posName = "Mon3" ,isDead = false ,entityId = self.monEntityId ,patrolList = {"Mon3","Mon3return"}},
	}
	self.monDeadNum = 0
	self.monDeadAllNum = 3

	self.RemoveFire = false

end

function LevelBehavior302040701:Update()
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
			-- --添加毒雾气屏幕特效
			-- if BehaviorFunctions.GetBuffCount(self.role, self.FxMist2D) == 0 then
			-- 	local A = BehaviorFunctions.GetBuffCount(self.role, self.FxMist2D)
			-- 	BehaviorFunctions.AddBuff(self.role,self.role,self.FxMist2D)
			-- end
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
				if self.updateFireDevice < self.numFireDevice then
					--移除免疫受击
					for i, v in pairs(self.GasholderList) do
						if v.Id ~= nil then
							BehaviorFunctions.SetPartEnableHit(v.Id, "Body", true)
						end
					end
					if self.tipsCheck == false then
						-- BehaviorFunctions.ShowTip(self.showTips)
						if self.monCombatTipsId ~= nil then
							BehaviorFunctions.ChangeLevelSubTipsState(self.monCombatTipsId,1,true)
							BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)
						end
						BehaviorFunctions.ShowCommonTitle(10,"此处需要摧毁毒气罐",true)
						-- self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowTip,self.combatTips)
						-- self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ChangeSubTipsDesc,2, self.combatTips, self.updateFireDevice, self.numFireDevice)
						self.combatTipsId = BehaviorFunctions.AddLevelTips(self.combatTips,self.levelId)
						BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
						self.timeCheck = true
						self.tipsCheck = true
					end

					if self.monDeadNum == self.monDeadAllNum then			--判断怪物死亡
						--添加交互物体追踪标
						if  self.GasholderList[1].GuiId == nil and self.GasholderList[1].GuideCheck == false then
							self.GasholderList[1].GuiId =BehaviorFunctions.AddEntityGuidePointer(self.GasholderList[1].Id ,self.GuideTypeEnum.Attacking,1.5,false)
						end
						if  self.GasholderList[2].GuiId == nil and self.GasholderList[2].GuideCheck == false then
							self.GasholderList[2].GuiId =BehaviorFunctions.AddEntityGuidePointer(self.GasholderList[2].Id ,self.GuideTypeEnum.Attacking,1.5,false)
						end
						if  self.GasholderList[3].GuiId == nil and self.GasholderList[3].GuideCheck == false then
							self.GasholderList[3].GuiId =BehaviorFunctions.AddEntityGuidePointer(self.GasholderList[3].Id ,self.GuideTypeEnum.Attacking,1.5,false)
						end
					end

				end
			else
				--添加免疫受击
				for i, v in pairs(self.GasholderList) do
					if v.Id ~= nil then
						BehaviorFunctions.SetPartEnableHit(v.Id, "Body", false)
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
			--移除毒雾气屏幕特效
			if BehaviorFunctions.GetBuffCount(self.role, self.FxMist2D) ~= 0 then
				BehaviorFunctions.RemoveBuff(self.role,self.FxMist2D)
			end

			if self.monDeadNum == self.monDeadAllNum then			--移除交互物体追踪标
				if  self.GasholderList[1].GuiId ~= nil then
					BehaviorFunctions.RemoveEntityGuidePointer(self.GasholderList[1].GuiId)
					self.GasholderList[1].GuiId = nil
				end
				if  self.GasholderList[2].GuiId ~= nil then
					BehaviorFunctions.RemoveEntityGuidePointer(self.GasholderList[2].GuiId)
					self.GasholderList[2].GuiId = nil
				end
				if  self.GasholderList[3].GuiId ~= nil then
					BehaviorFunctions.RemoveEntityGuidePointer(self.GasholderList[3].GuiId)
					self.GasholderList[3].GuiId = nil
				end
			end

		-- elseif self.missionDistance > self.missionUnloadDis then	--超远距离卸载关卡
		-- 	self:LevelDelete()
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
			--获取毒气罐是否有毒气
			if self.updateFireDevice < self.numFireDevice then
				if BehaviorFunctions.GetEntityValue(self.GasholderList[1].Id,"isOpen") == true then
					if self.GasholderList[1].state == self.GasholderState.Open then
						self.updateFireDevice = self.updateFireDevice + 1
						-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updateFireDevice, self.numFireDevice)
						BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
						if self.smokeId[1].state == self.smokeState.Open then
							BehaviorFunctions.PlayAnimation(self.smokeId[1].Id,"FxGasholder01LoopOver",FightEnum.AnimationLayer.BaseLayer)

							if self.GasholderList[1].GuiId ~= nil and self.GasholderList[1].GuideCheck == false then		--交互后移除追踪标
								BehaviorFunctions.RemoveEntityGuidePointer(self.GasholderList[1].GuiId)
								self.GasholderList[1].GuiId = nil
								self.GasholderList[1].GuideCheck = true
							end

							self.smokeId[1].state = self.smokeState.Close
						end
						self.GasholderList[1].state = self.GasholderState.Close
					end
				end
				if BehaviorFunctions.GetEntityValue(self.GasholderList[2].Id,"isOpen") == true then
					if self.GasholderList[2].state == self.GasholderState.Open then
						self.updateFireDevice = self.updateFireDevice + 1
						-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updateFireDevice, self.numFireDevice)
						BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
						if self.smokeId[2].state == self.smokeState.Open then
							BehaviorFunctions.PlayAnimation(self.smokeId[2].Id,"FxGasholder01LoopOver",FightEnum.AnimationLayer.BaseLayer)

							if self.GasholderList[2].GuiId ~= nil and self.GasholderList[2].GuideCheck == false then		--交互后移除追踪标
								BehaviorFunctions.RemoveEntityGuidePointer(self.GasholderList[2].GuiId)
								self.GasholderList[2].GuiId = nil
								self.GasholderList[2].GuideCheck = true
							end

							self.smokeId[2].state = self.smokeState.Close
						end
						self.GasholderList[2].state = self.GasholderState.Close
					end
				end
				if BehaviorFunctions.GetEntityValue(self.GasholderList[3].Id,"isOpen") == true then
					if self.GasholderList[3].state == self.GasholderState.Open then
						self.updateFireDevice = self.updateFireDevice + 1
						-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updateFireDevice, self.numFireDevice)
						BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
						if self.smokeId[3].state == self.smokeState.Open then
							BehaviorFunctions.PlayAnimation(self.smokeId[3].Id,"FxGasholder01LoopOver",FightEnum.AnimationLayer.BaseLayer)

							if self.GasholderList[3].GuiId ~= nil and self.GasholderList[3].GuideCheck == false then		--交互后移除追踪标
								BehaviorFunctions.RemoveEntityGuidePointer(self.GasholderList[3].GuiId)
								self.GasholderList[3].GuiId = nil
								self.GasholderList[3].GuideCheck = true
							end

							self.smokeId[3].state = self.smokeState.Close
						end
						self.GasholderList[3].state = self.GasholderState.Close
					end
				end
			end
		end
	end

	if self.missionState == 0 then
		--创建怪物
		self:CreateMonsterEntity(self.monsterList)
		self:MonsterPatrol(self.monsterList)
		self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
		self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowMapArea,self.levelId, true)

		--创建喷火装置
		self:CreateMonsterEntity(self.GasholderList)
		--创建烟雾
		self:CreateMonsterEntity(self.smokeId)
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
					--移除毒雾气屏幕特效
					if BehaviorFunctions.GetBuffCount(self.role, self.FxMist2D) ~= 0 then
						BehaviorFunctions.RemoveBuff(self.role,self.FxMist2D)
					end
					self.levelWin = true
				end
			end
			if self.time >= (self.timeAdd + 75) and self.time < (self.timeAdd + 80) then
				if self.RemoveFire == false then
					BehaviorFunctions.ShowBlackCurtain(true,0.5)	--黑幕
					-- BehaviorFunctions.HideTip(self.combatTips)
					BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
					self.RemoveFire = true
				end
			end
			if self.time >= (self.timeAdd + 90) and self.time < (self.timeAdd + 95) then
				self:RemoveAllLevelDelayCall()
				--移除毒气罐实体
				for index, value in ipairs(self.GasholderList) do
					self:RemoveEntityId(value.Id)
				end
				--移除毒雾气
				for i,v in ipairs (self.smokeId) do
					self:RemoveEntityId(v.Id)
				end
				BehaviorFunctions.ShowBlackCurtain(false,0.5)
				BehaviorFunctions.FinishLevel(self.levelId)
				self.missionState = 999
			-- elseif self.time >= (self.timeAdd + 90) and self.time < (self.timeAdd + 95) then
			end
		end

	end
end

--死亡回调
function LevelBehavior302040701:Death(instanceId,isFormationRevive)
	for i, v in pairs(self.monsterList) do
		if instanceId == v.Id and v.isDead == false then
			v.isDead = true
			self.monDeadNum = self.monDeadNum + 1
			-- BehaviorFunctions.ChangeSubTipsDesc(1, self.monCombatTips, self.monDeadNum, self.monDeadAllNum)
			BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
		end
	end
end

--移除关卡函数
function LevelBehavior302040701:LevelDelete()
	-- self:RemoveFireDevices(1)
	-- self:RemoveFireDevices(2)
	-- self:RemoveFireDevices(3)
	-- self:RemoveFireDevices(4)
	-- self:RemoveFireDevices(5)
	-- self:RemoveFireDevices(6)
	-- for i,v in ipairs (self.smokeId) do
	-- 	self:RemoveEntityId(v.Id)
	-- end
	-- self:RemoveAllLevelDelayCall()
    -- BehaviorFunctions.RemoveLevel(self.levelId)
	-- self.missionState = 999
end

--获取玩家和关卡坐标的距离
function LevelBehavior302040701:updatePlayerDistance()
	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)  -- 获取玩家的坐标
	end
	local missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)
	if missionStartPos ~= nil then
		self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos, missionStartPos)  -- 计算玩家和关卡的距离
	end
end

--追踪指标
function LevelBehavior302040701:GuidePointer(guidePos,guideDistance,minDistance,guideType)
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

-- --游戏内参数更新
-- function LevelBehavior302040701:GameUpdateTipsNum()
-- 	self.updateFireDevice = self.numFireDevice - self.buffSum
-- 	-- self.combatFireDevice = self.combatFireDevice + 1
-- 	BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updateFireDevice, self.numFireDevice)
-- end


--创建喷火装置
function LevelBehavior302040701:createFireDevicesIfNil(FireDeviceId, PosName )
    if not FireDeviceId then
        FireDeviceId = BehaviorFunctions.CreateEntityByPosition(self.Gasholder01EntityId, nil, PosName, self.logicName, self.levelId, self.levelId, nil)
		return FireDeviceId
    end
end
--移除喷火装置
function LevelBehavior302040701:RemoveFireDevices(Num)
	if self.FireDevice[Num] ~= nil then
		BehaviorFunctions.RemoveEntity(self.FireDevice[Num])
		self.FireDevice[Num] = nil
	end
end

--创建实体
function LevelBehavior302040701:CreateMonsterEntity(monsterList)
	for i,v in ipairs (monsterList) do
		v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.logicName, self.levelId,self.levelId)
		-- v.state = self.monsterStateEnum.Live
	end
end
--移除怪物
function LevelBehavior302040701:RemoveEntityId(entityId)
	if entityId ~= nil then
		BehaviorFunctions.RemoveEntity(entityId)
		entityId = nil
	end
end

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function LevelBehavior302040701:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function LevelBehavior302040701:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end

--怪物巡逻
function LevelBehavior302040701:MonsterPatrol(monsterList)
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