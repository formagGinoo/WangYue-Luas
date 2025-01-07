LevelBehavior302040401 = BaseClass("LevelBehavior302040401",LevelBehaviorBase)

function LevelBehavior302040401.GetGenerates()
	local generates = {2030804,2041101,
	2030808,			--广告牌特效
	790012000,			--怪物
	}
	return generates
end

function LevelBehavior302040401:__init(fight)
	self.fight = fight
end

function LevelBehavior302040401:Init()
	self.role = 1		--角色
	self.playerPos = nil		--角色坐标
	self.missionState = 0	--关卡阶段
	self.levelWin = false		--关卡胜利判断
	self.ElectDeviceEntityId = 2030804		--蓄电装置实体ID
	self.missionDistance = 0	--玩家和关卡坐标的距离
	self.ElectDevice01 = nil		--关卡内蓄电装置
	self.combatFireDevice = 0	--摧毁火焰装置数量
	self.electValue = nil		--电参数

	self.CamEnd = false

	--时间
	self.updataTimeCheck = false
	self.updataTime = 0

	--tips
	self.combatTips = 102670109
	self.showTips = 102670110
	self.showTipsCheck = false
	-- self.combatFireDeviceTips = 102670108	--摧毁火焰装置数量Tips
	self.numFireDevice = 1
	self.updateFireDevice = 0
	self.tipsCheck = false
	self.combatTipsCheck = false

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

	--广告牌
	self.FxEntityID = 2030808
	self.FxList ={
		[1] = {Id = nil ,entityId = self.FxEntityID ,posName = "FX1"};
	}

	--怪物信息
	self.monEntityId = 790012000
	self.monsterList = {
		[1] = {Id = nil ,posName = "Mon1" ,isDead = false ,entityId = self.monEntityId ,patrolList = {"Mon1","Mon1return"}},
		[2] = {Id = nil ,posName = "Mon2" ,isDead = false ,entityId = self.monEntityId ,patrolList = {"Mon2","Mon2return"}},
		[3] = {Id = nil ,posName = "Mon3" ,isDead = false ,entityId = self.monEntityId ,patrolList = {"Mon3","Mon3return"}},
	}
	self.monDeadNum = 0
	self.monDeadAllNum = 3
	self.speedAttrs = 9			--怪物移动速度属性ID
	self.speedScale = (24500 * 0.5)	--减速比例

	--蓄电装置引导图标
	self.ElectDeviceGuide = {
		[1] = {GuiId = nil, GuideCheck = false},
	}
end

function LevelBehavior302040401:Update()
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
				-- BehaviorFunctions.ShowTip(self.monShowTips)
				BehaviorFunctions.ShowCommonTitle(10,"击败所有敌人",true)
				self.monCombatTipsId = BehaviorFunctions.AddLevelTips(self.monCombatTips,self.levelId)
				BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
				self.monTipsCheck = true
			end

			--蓄电装置tips
			if self.monDeadNum == self.monDeadAllNum then

				if self.tipsCheck == false then
					BehaviorFunctions.RemoveLevelTips(self.monShowTipsId)
					if self.monCombatTipsId ~= nil then
						BehaviorFunctions.ChangeLevelSubTipsState(self.monCombatTipsId,1,true)
						BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)
						self.monCombatTipsId = nil
					end
					-- self:AddLevelDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.ShowTip,self.showTips)
					-- BehaviorFunctions.ShowCommonTitle(10,"激活蓄电装置",true)
					self:AddLevelDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.ShowCommonTitle,10,"激活蓄电装置",true)
					-- self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowTip,self.combatTips)
					-- self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ChangeSubTipsDesc,2, self.combatTips, self.updateFireDevice, self.numFireDevice)
					self.combatTipsId = BehaviorFunctions.AddLevelTips(self.combatTips,self.levelId)
					BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,2,self.updateFireDevice, self.numFireDevice)
					-- BehaviorFunctions.ChangeSubTipsDesc(2, self.combatTips, self.updateFireDevice, self.numFireDevice)
					self.timeCheck = true
					self.tipsCheck = true
				end

				--怪物死亡交互物体加追踪标
				if self.ElectDeviceGuide[1].GuiId == nil and self.ElectDeviceGuide[1].GuideCheck == false then
					self.ElectDeviceGuide[1].GuiId =BehaviorFunctions.AddEntityGuidePointer(self.ElectDevice01 ,self.GuideTypeEnum.Attacking,1.5,false)
				end

			end

		elseif self.missionDistance < self.missionUnloadDis and self.missionDistance >= self.missionStartDis then
			if self.combatTipsId ~= nil then
				BehaviorFunctions.ChangeLevelSubTipsState(self.combatTipsId,2,true)
				BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
				self.combatTipsId = nil
			end
			BehaviorFunctions.RemoveLevelTips(self.monCombatTipsId)

			--移除追踪标
			if self.ElectDeviceGuide[1].GuiId ~= nil then
				BehaviorFunctions.RemoveEntityGuidePointer(self.ElectDeviceGuide[1].GuiId)
				self.ElectDeviceGuide[1].GuiId = nil
			end
			 
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

	end

	-- 检查是否应该更新Tips和胜利条件
	if self.missionState ~= 999 then

		--判断蓄电装置是否可受击
		if self.ElectDevice01 ~= nil then
			if self.monsterList[1].isDead == true and self.monsterList[2].isDead == true and self.monsterList[2].isDead == true then
				BehaviorFunctions.SetPartEnableHit(self.ElectDevice01, "Body", true)
			else
				BehaviorFunctions.SetPartEnableHit(self.ElectDevice01, "Body", false)
			end
		end

		--胜利条件判断
		if self.ElectDevice01 ~= nil then
			-- 获取两个设备上的buff数量
			local buffCount01 = BehaviorFunctions.GetEntityValue(self.ElectDevice01,"isOpen")
			if self.timeCheck and self.combatFireDevice == 0 then
				-- 如果只有一个设备上有buff，则显示提示并更新状态
				if buffCount01 == true then

					if self.ElectDeviceGuide[1].GuiId ~= nil and self.ElectDeviceGuide[1].GuideCheck == false then		--交互后移除追踪标
						BehaviorFunctions.RemoveEntityGuidePointer(self.ElectDeviceGuide[1].GuiId)
						self.ElectDeviceGuide[1].GuiId = nil
						self.ElectDeviceGuide[1].GuideCheck = true
					end

					self:DisablePlayerInput(true,true)
					--进入区域吸引玩家
					if self.CamEnd == false then
						self:LevelLookAtPos("FX1",22002)
						self.CamEnd = true
					end
					if self.combatTipsCheck == false then
						self.updateFireDevice = self.updateFireDevice + 1
						BehaviorFunctions.SetPartEnableHit(self.ElectDevice01, "Body", false)		--激活蓄电装置就关闭受击
						BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId, 2, self.updateFireDevice, self.numFireDevice)
						self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveLevelTips,self.combatTipsId)
						self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.FxList[1].Id,"FxElectChargeDevice_WallOver",FightEnum.AnimationLayer.BaseLayer)
						self:AddLevelDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.ShowCommonTitle,8,'已清除城市威胁',true)
						self.combatTipsCheck = true
					end
					self.combatFireDevice = 1
					end
				end
			end
		end

		--关卡胜利
		if self.combatFireDevice == 1 then
			if self.levelwin == false then

				self.levelwin = true
			end
			if self.timeAddCheck == false then
				self.timeAdd =  self.time + self.Add
				self.timeAddCheck = true
			end
			if self.time >= self.timeAdd + 60 and self.time < (self.timeAdd + 65) then
				BehaviorFunctions.ShowBlackCurtain(true,0.5)	--黑幕
			elseif self.time >= (self.timeAdd + 90) and self.time < (self.timeAdd + 95) then
				if self.ElectDevice01 ~= nil then
					BehaviorFunctions.RemoveEntity(self.ElectDevice01)
					self.ElectDevice01 = nil
				end
				BehaviorFunctions.ShowBlackCurtain(false,0.5)
			elseif self.time >= (self.timeAdd + 120) and self.time < (self.timeAdd + 125) then
				self:DisablePlayerInput(false,false)
				BehaviorFunctions.FinishLevel(self.levelId)
				self.missionState = 999
			end
		end

		if self.missionState == 0 then
				--创建蓄电装置
				if self.ElectDevice01 == nil then
					self.ElectDevice01 = BehaviorFunctions.CreateEntityByPosition(self.ElectDeviceEntityId, nil, "Pos1", self.logicName, self.levelId, self.levelId, nil)
					self:CreateMonster(self.FxList)

					self:CreateMonster(self.monsterList)
					self:MonsterPatrol(self.monsterList)
					self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
					self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowMapArea,self.levelId, true)
				end
				self.missionState = 1
		elseif self.missionState == 1 then
			self.missionState = 2
		elseif self.missionState == 2 then
		end
end

--死亡回调
function LevelBehavior302040401:Death(instanceId,isFormationRevive)
	for i, v in pairs(self.monsterList) do
		if instanceId == v.Id and v.isDead == false then
			v.isDead = true
			self.monDeadNum = self.monDeadNum + 1
			BehaviorFunctions.ChangeLevelSubTips(self.monCombatTipsId,1,self.monDeadNum, self.monDeadAllNum)
		end
	end
end

--移除关卡函数
function LevelBehavior302040401:LevelDelete()
	if self.ElectDevice01 ~= nil then
		BehaviorFunctions.RemoveEntity(self.ElectDevice01)
		self.ElectDevice01 = nil
	end
    BehaviorFunctions.RemoveLevel(self.levelId)
end

--获取玩家和关卡坐标的距离
function LevelBehavior302040401:updatePlayerDistance()
	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)  -- 获取玩家的坐标
	end
	local missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)
	if missionStartPos ~= nil then
		self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos, missionStartPos)  -- 计算玩家和关卡的距离
	end
end

--追踪指标
function LevelBehavior302040401:GuidePointer(guidePos,guideDistance,minDistance,guideType)
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
function LevelBehavior302040401:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function LevelBehavior302040401:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end

--创建怪物
function LevelBehavior302040401:CreateMonster(monsterList)
	for i,v in ipairs (monsterList) do
		v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.logicName, self.levelId,self.levelId)
		-- v.state = self.monsterStateEnum.Live
	end
end
--移除怪物
function LevelBehavior302040401:RemoveEntityId(entityId)
	if entityId ~= nil then
		BehaviorFunctions.RemoveEntity(entityId)
		entityId = nil
	end
end

--相机函数
function LevelBehavior302040401:LevelLookAtPos(pos,type,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId,self.logicName)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	self.levelCam = BehaviorFunctions.CreateEntity(type,nil,nil,nil,nil,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
	self:AddLevelDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	-- BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
	-- BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
end

function LevelBehavior302040401:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end

--怪物巡逻
function LevelBehavior302040401:MonsterPatrol(monsterList)
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