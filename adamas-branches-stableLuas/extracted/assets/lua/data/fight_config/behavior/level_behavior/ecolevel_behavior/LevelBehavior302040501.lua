LevelBehavior302040501 = BaseClass("LevelBehavior302040501",LevelBehaviorBase)

function LevelBehavior302040501.GetGenerates()
	local generates = {2030805,2041101,
	2030807,	--喷水特效
	790012000,
	790006000,
	790010200,
	}
	return generates
end

function LevelBehavior302040501:__init(fight)
	self.fight = fight
end

function LevelBehavior302040501:Init()
	self.role = 1		--角色
	self.playerPos = nil		--角色坐标
	self.missionState = 0	--关卡阶段
	self.waterDeviceEntityId = 2030805		--喷水装置实体ID
	self.missionDistance = 0	--玩家和关卡坐标的距离
	self.waterDevice01 = nil		--关卡内喷水装置
	self.combatwaterDevice = 0	--摧毁水装置数量

	self.checkwaterBuff = 1000105		--水
	self.waterEnitytID = 2030807		--水实体文件
	self.waterID = nil
	self.waterAnima = false

	--tips
	self.combatTips = 102670111
	self.showTips = 102670112
	self.combatTipsId = nil
	self.showTipsCheck = false
	-- self.combatwaterDeviceTips = 102670108	--摧毁水装置数量Tips
	self.numwaterDevice = 1
	self.updatewaterDevice = 0
	self.tipsCheck = false

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

	--End关卡计时
	self.updateframeEnd = 0
	self.timeAddCheckEnd = false
	self.timeAddEnd = nil

	--怪物信息
	self.monEntityIdA = 790010200
	self.monEntityIdB = 790006000
	self.monsterList = {
		[1] = {Id = nil ,posName = "Pos2" ,isDead = false ,entityId = self.monEntityIdB ,patrolList = {"Pos2","Pos2return"}},
		[2] = {Id = nil ,posName = "Pos3" ,isDead = false ,entityId = self.monEntityIdB ,patrolList = {"Pos3","Pos3return"}},
		[3] = {Id = nil ,posName = "Pos4" ,isDead = false ,entityId = self.monEntityIdA},
	}
	self.monDeadNum = 0
	self.monDeadAllNum = 3
end

function LevelBehavior302040501:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    self.time = BehaviorFunctions.GetFightFrame()
	self.updateframeEnd = BehaviorFunctions.GetFightFrame()
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
			--怪物战斗Tips
			if self.monTipsCheck == false then
				-- BehaviorFunctions.ShowTip(self.monShowTips)
				BehaviorFunctions.ShowCommonTitle(10,"击败所有敌人",true)
				-- self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowTip,self.monCombatTips)
				-- self:AddLevelDelayCallByFrame(31,BehaviorFunctions,BehaviorFunctions.ChangeSubTipsDesc,1, self.monCombatTips, self.monDeadNum, self.monDeadAllNum)
				self.monCombatTipsId = BehaviorFunctions.AddLevelTips(self.monCombatTips,self.levelId)
				BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
				-- BehaviorFunctions.ShowTip(self.combatTips)
				-- BehaviorFunctions.ChangeSubTipsDesc(1, self.combatTips, self.updatewaterDevice, self.numwaterDevice)
				-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updatewaterDevice, self.numwaterDevice)
				self.monTipsCheck = true
			end

			--消防栓Tips
			if self.monDeadNum == self.monDeadAllNum then
				if self.tipsCheck == false then
					-- BehaviorFunctions.HideTip(self.monCombatTips)
					if self.monCombatTipsId ~= nil then
						BehaviorFunctions.ChangeLevelSubTipsState(self.monCombatTipsId,1,true)
						BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)
						self.monCombatTipsId = nil
					end
					-- BehaviorFunctions.ShowTip(self.showTips)
					BehaviorFunctions.ShowCommonTitle(10,"使用土属性封住消防栓",true)
					-- self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowTip,self.combatTips)
					-- self:AddLevelDelayCallByFrame(31,BehaviorFunctions,BehaviorFunctions.ChangeSubTipsDesc,2, self.combatTips, self.updatewaterDevice, self.numwaterDevice)
					self.combatTipsId = BehaviorFunctions.AddLevelTips(self.combatTips,self.levelId)
					BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updatewaterDevice, self.numwaterDevice)
					-- BehaviorFunctions.ShowTip(self.combatTips)
					-- BehaviorFunctions.ChangeSubTipsDesc(1, self.combatTips, self.updatewaterDevice, self.numwaterDevice)
					-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updatewaterDevice, self.numwaterDevice)
					self.timeCheck = true
					self.tipsCheck = true
				end
			end
		elseif self.missionDistance < self.missionUnloadDis and self.missionDistance >= self.missionStartDis then

			-- BehaviorFunctions.HideTip(self.combatTips)
			-- BehaviorFunctions.HideTip(self.monCombatTips)
			BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
			BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)
			self.tipsCheck = false
		elseif self.missionDistance > self.missionUnloadDis then	--超远距离卸载关卡
			-- self:LevelDelete()
		end

		--城市威胁提示
		if self.missionDistance <= self.ShowCommonTitleDis then
			if self.showTipsCheck == false then
				BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
				self.showTipsCheck = true
			end
		end

		--消防栓初始免疫受击，根据怪物死亡关闭免疫受击
		if self.waterDevice01 ~= nil then
			if self.monsterList[1].isDead == true and self.monsterList[2].isDead == true and self.monsterList[2].isDead == true then
				BehaviorFunctions.SetPartEnableHit(self.waterDevice01, "Body", true)
			else
				BehaviorFunctions.SetPartEnableHit(self.waterDevice01, "Body", false)
			end
		end

	end

	-- 检查是否应该更新Tips和胜利条件
	if self.missionState ~= 999 then
		if self.waterDevice01 ~= nil then
			-- 获取两个设备上的buff数量
			local buffCount01 = BehaviorFunctions.GetBuffCount(self.waterDevice01, self.checkwaterBuff)
			if self.timeCheck and self.combatwaterDevice == 0 then
				-- 如果只有一个设备上有buff，则显示提示并更新状态
				if buffCount01 < 1 then

					--关卡胜利延时
					if self.timeAddCheckEnd == false then
						self.timeAddEnd =  self.updateframeEnd	-- + self.AddEnd
						self.timeAddCheckEnd = true
					end
					if self.updateframeEnd >= (self.timeAddEnd + 1) and self.updateframeEnd < (self.timeAddEnd + 5) then
						if self.waterAnima == false then
							BehaviorFunctions.PlayAnimation(self.waterID,"Fx_HydrantWaterOver",FightEnum.AnimationLayer.BaseLayer)
							self.waterAnima = true
						end
					elseif self.updateframeEnd >= (self.timeAddEnd + 60) and self.updateframeEnd < (self.timeAddEnd + 70) then
						self.updatewaterDevice = self.updatewaterDevice + 1
						-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updatewaterDevice, self.numwaterDevice)
						BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2, self.updatewaterDevice, self.numwaterDevice)
						self.combatwaterDevice = 1
					end
				end
			elseif self.combatwaterDevice == 1 then
				-- 如果任一设备上没有buff，则更新状态
				if buffCount01 < 1 then
					-- self.updatewaterDevice = self.updatewaterDevice + 1
					BehaviorFunctions.ShowCommonTitle(8,'已清除城市威胁',true)
					-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updatewaterDevice, self.numwaterDevice)
					BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2, self.updatewaterDevice, self.numwaterDevice)

					self.combatwaterDevice = 2
				end
			end
		end
	end

	if self.missionState == 0 then
		--创建喷水装置
		if self.waterDevice01 == nil then
			self.waterDevice01 = BehaviorFunctions.CreateEntityByPosition(self.waterDeviceEntityId, nil, "Pos1", self.logicName, self.levelId, self.levelId, nil)
			self.waterID = BehaviorFunctions.CreateEntityByPosition(self.waterEnitytID, nil, "Pos1", self.logicName, self.levelId, self.levelId, nil)
			self:CreateMonster(self.monsterList)
			self:MonsterPatrol(self.monsterList)
			self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
			self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowMapArea,self.levelId, true)
			-- BehaviorFunction.ShowLevelMonster(self.levelId,true)
		end
		self.missionState = 1
	elseif self.missionState == 1 then
		self.missionState = 2
	elseif self.missionState == 2 then

		--关卡胜利
		if self.combatwaterDevice == 2 then
			if self.levelwin == false then
				if self.combatTipsId ~= nil then
					BehaviorFunctions.ChangeLevelSubTipsState(self.combatTipsId,2,true)
					BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
					self.combatTipsId = nil
				end
				-- BehaviorFunctions.FinishLevel(self.levelId)				--完成关卡
				self.levelwin = true
			end
			if self.timeAddCheck == false then
				self.timeAdd =  self.time + self.Add
				self.timeAddCheck = true
			end
			if self.time >= (self.timeAdd + 30) and self.time < (self.timeAdd + 35) then
				BehaviorFunctions.ShowBlackCurtain(true,0.5)	--黑幕
				-- BehaviorFunctions.HideTip(self.combatTips)
			elseif self.time >= (self.timeAdd + 45) and self.time < (self.timeAdd + 50) then
				if self.waterDevice01 ~= nil then
					BehaviorFunctions.RemoveEntity(self.waterDevice01)
					self.waterDevice01 = nil
				end
				BehaviorFunctions.ShowBlackCurtain(false,0.5)
			elseif self.time >= (self.timeAdd + 60) and self.time < (self.timeAdd + 65) then
				BehaviorFunctions.FinishLevel(self.levelId)
				self.missionState = 999
			end
		end
	end
end

--死亡回调
function LevelBehavior302040501:Death(instanceId,isFormationRevive)
	for i, v in pairs(self.monsterList) do
		if instanceId == v.Id and v.isDead == false then
			v.isDead = true
			self.monDeadNum = self.monDeadNum + 1
			BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
		end
	end
end

--移除关卡函数
function LevelBehavior302040501:LevelDelete()
	if self.waterDevice01 ~= nil then
		BehaviorFunctions.RemoveEntity(self.waterDevice01)
		self.waterDevice01 = nil
	end
    BehaviorFunctions.RemoveLevel(self.levelId)
end

--获取玩家和关卡坐标的距离
function LevelBehavior302040501:updatePlayerDistance()
	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)  -- 获取玩家的坐标
	end
	local missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)
	if missionStartPos ~= nil then
		self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos, missionStartPos)  -- 计算玩家和关卡的距离
	end
end

--追踪指标
function LevelBehavior302040501:GuidePointer(guidePos,guideDistance,minDistance,guideType)
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

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function LevelBehavior302040501:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function LevelBehavior302040501:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end

--创建怪物
function LevelBehavior302040501:CreateMonster(monsterList)
	for i,v in ipairs (monsterList) do
		v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.logicName, self.levelId,self.levelId)
		-- v.state = self.monsterStateEnum.Live
	end
end
--移除怪物
function LevelBehavior302040501:RemoveEntityId(entityId)
	if entityId ~= nil then
		BehaviorFunctions.RemoveEntity(entityId)
		entityId = nil
	end
end

--怪物巡逻
function LevelBehavior302040501:MonsterPatrol(monsterList)
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