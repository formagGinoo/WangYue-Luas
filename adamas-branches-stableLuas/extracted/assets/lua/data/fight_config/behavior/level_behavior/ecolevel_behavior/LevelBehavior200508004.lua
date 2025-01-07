LevelBehavior200508004 = BaseClass("LevelBehavior200508004",LevelBehaviorBase)
--屋顶解谜战斗关卡-屋顶找入口

function LevelBehavior200508004.GetGenerates()
	local generates = {
		790012000, --噬脉从侍
		790013000, --噬脉猎手
		790008000, --箴石之劣_木
		791012000, --啸叫
		790006000, -- 水尾狐
		791004000, --精英从士
		790010200, --计都灵客_木
		2041002, --奖励交互实体
		204100202, --月能球特效
		2030205, --可破坏物
	}
	return generates
end


function LevelBehavior200508004:__init(fight)

	--怪物状态判断
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}

	--关卡状态控制
	self.fight = fight
	self.missionState = 0
	self.missionCreated = false
	self.missionCreateDis = 140
	self.missionUnloadDis = 190
	self.missionPos = "type_findhole_1"
	self.currentTip = nil
	self.currentTipId = nil           --关卡当前tips的tipid
	self.missionInfoUnloadDis = 30   --关卡信息移除距离

	--关卡时间数据读取
	self.time = nil
	self.frame = nil
	self.role = nil
	self.monsterListInfo = nil

	--关卡相机参数
	self.Camera1 = nil
	self.levelCameraRemoveFrame = 90

	--敌人列表
	self.monsterList =
	{
		[1] = {entityId = 790012000 ,posName = "enemyPos1" ,wave = 1, id = nil, state = self.monsterStateEnum.Default, tag = "enemy"},
		[2] = {entityId = 790008000 ,posName = "enemyPos2" ,wave = 1, id = nil, state = self.monsterStateEnum.Default, tag = "enemy"},
		[3] = {entityId = 790010200 ,posName = "enemyPos4" ,wave = 2, id = nil, state = self.monsterStateEnum.Default, tag = "enemy"},
		[4] = {entityId = 790012000 ,posName = "enemyPos5" ,wave = 2, id = nil, state = self.monsterStateEnum.Default, tag = "enemy"},
		[5] = {entityId = 790012000 ,posName = "enemyPos1" ,wave = 2, id = nil, state = self.monsterStateEnum.Default, tag = "enemy"},
		[6] = {entityId = 791004000 ,posName = "enemyPos2" ,wave = 3, id = nil, state = self.monsterStateEnum.Default, tag = "enemy"},
		[7] = {entityId = 790013000 ,posName = "enemyPos3" ,wave = 3, id = nil, state = self.monsterStateEnum.Default, tag = "enemy"},
	}
	
	--关卡物件列表
	self.propList = 
	{
		[1] = {objName = "airWall_", type = "airWall", count = 5},
		[2] = {objName = "airWallFx_", type = "fx", count = 8},
	}
	
	self.breakObjectList = 
	{
		[1] = {entityId = 2030205 ,posName = "box1", id = nil},
		[2] = {entityId = 2030205 ,posName = "box2", id = nil},
		[3] = {entityId = 2030205 ,posName = "box3", id = nil},
		[4] = {entityId = 2030205 ,posName = "box4", id = nil},
		[5] = {entityId = 2030205 ,posName = "box5", id = nil},
		[6] = {entityId = 2030205 ,posName = "box6", id = nil},
		[7] = {entityId = 2030205 ,posName = "box7", id = nil},
		[8] = {entityId = 2030205 ,posName = "box8", id = nil},
		[9] = {entityId = 2030205 ,posName = "box9", id = nil},
	}
	
	--关卡敌人总数判断参数
	self.totalCount = 0
	self.deathCount = 0

	--单一波次敌人比对参数
	self.waveTotalCount = 0
	self.waveDeathCount = 0
	
	--敌人波次
	self.currentWave = 1
	self.waveLimit = nil
	self.currentWaveOnGoing = false
	
	--波次时间间隔相关参数
	self.intervalTime = 3
	self.targetFrame = nil
	self.isCountDown = false
	
	--关卡奖励实体ID
	self.missionObj = nil
	self.effectId = nil
	self.triggerDis = 5

	--关卡引导
	self.GuideTypeEnum = {
		RoofCombat = FightEnum.GuideType.Map_wuding,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
	
	--关卡追踪
	self.guide = nil
	self.guidePosName = "guidePos"
	
	--相机波次
	self.waveGuidePos =
	{
		[1] = {guidePosName = "waveGuidePos1", instanceId = nil, target = nil, removeFrame = 20},
		[2] = {guidePosName = "waveGuidePos2", instanceId = nil, target = nil, removeFrame = 20},
		[3] = {guidePosName = "waveGuidePos1", instanceId = nil, target = nil, removeFrame = 20},
	}
end


function LevelBehavior200508004:Init()
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
	
	--生成最终交互实体
	local bornPos = BehaviorFunctions.GetTerrainPositionP("missionObj",self.levelId)
	self.missionObj = BehaviorFunctions.CreateEntity(2041002,nil,bornPos.x,bornPos.y,bornPos.z,nil,nil,nil,self.levelId)
	--关闭最终实体交互
	BehaviorFunctions.SetEntityWorldInteractState(self.missionObj, false)
end


function LevelBehavior200508004:Update()

	self.time = BehaviorFunctions.GetFightFrame()/30
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	self.LevelCommon:Update() --执行关卡通用行为树的每帧运行

	--检测玩家是否进入关卡加载范围
	local pos = BehaviorFunctions.GetTerrainPositionP(self.guidePosName,self.levelId)
	local myPos = BehaviorFunctions.GetPositionP(self.role)
	local disToCreate = BehaviorFunctions.GetDistanceFromPos(myPos, pos)
	if disToCreate <= self.missionCreateDis then
		self.missionCreated = true
	end

	if self.missionCreated == true then
		
		--检测tips卸载逻辑
		self:TipDisCheck(self.guidePosName)
		
		--引导玩家抵达屋顶，相机看向屋顶，如果玩家抵达屋顶的碰撞盒则进入下一阶段
		if self.missionState == 0 then

			--显示目标追踪引导玩家找到通风管道抵达目标屋顶
			--self.currentTip = BehaviorFunctions.AddLevelTips(200508006,self.levelId)
			--BehaviorFunctions.ShowCommonTitle(8,"发现城市威胁！",true)
			
			self:AddlevelTipSingle(200508001)
			
			--确认关卡敌人波次数量
			self:WaveLimitCount()

			--确认关卡敌人总数量
			self:TotalEnemyCount()

			--生成阻碍破坏物
			self:SpawnItem(self.breakObjectList)

			self.missionState = 1

			--判断玩家是否抵达屋顶，如果玩家抵达屋顶的碰撞盒则进入下一阶段
		elseif self.missionState == 1 then
			--显示目标追踪引导玩家抵达屋顶

			self.missionState = 2
			--检测玩家是否进入区域
		elseif self.missionState == 2 then
			self:GuidePointer(self.guidePosName)
			--检测玩家是否进入区域
		elseif self.missionState == 3 then
			self:GuidePointer(self.guidePosName)
			
			--引导玩家靠近实体，如果距离实体足够近则进入下一阶段
		elseif self.missionState == 4 then
			local myPos = BehaviorFunctions.GetPositionP(self.role)
			local missionObjPos = BehaviorFunctions.GetTerrainPositionP("missionObj",self.levelId)
			local dis = Vec3.Distance(myPos, missionObjPos)
			
			self:GuidePointer(self.guidePosName)
			
			--如果玩家距离实体小于3米则生成敌人
			if dis <= self.triggerDis then
				self:AddlevelTipSingle(200508003)
				--跟新目标追踪敌人死亡数量
				if self.currentTip then
					BehaviorFunctions.ChangeLevelSubTips(self.currentTip,1,0,self.totalCount)
					BehaviorFunctions.ShowCommonTitle(10,"击败所有敌人！",true)
				end
				--启动空气墙
				self:setSceneObjActive(self.propList,1)
				self:setSceneObjActive(self.propList,2)
				
				--加载能量圈
				local bornPos = BehaviorFunctions.GetTerrainPositionP("missionObj",self.levelId)
				self.effectId = BehaviorFunctions.CreateEntity(204100202,nil,bornPos.x,bornPos.y,bornPos.z,nil,nil,nil,self.levelId)
				BehaviorFunctions.PlayAnimation(self.effectId,"FxYueNengCircal_01Ani_Stand")
				local AniLength = BehaviorFunctions.CheckAnimTime(self.effectId,"FxYueNengCircal_01Ani_Stand")
				--LogError("DoPlaySound ", AniLength)
				BehaviorFunctions.AddDelayCallByTime(AniLength,BehaviorFunctions,BehaviorFunctions.DoEntityAudioPlay,self.effectId,"FxYueNengCloud_01_Loop",true)
				self:RemoveGuidePointer(self.guide)

				self.missionState = 5
			end

			--生成敌人后进入下一阶段
		elseif self.missionState == 5 then

			self:SetEnemyFightTarget()
			
			--移除追踪
			self:RemoveGuidePointer(self.guide)
			self:GuidePointer(self.guidePosName,40)
			
			--检测当前波次是否为最后一波
			if self.currentWave < self.waveLimit then
				--如果不是则生成该波次敌人并检测该波次敌人是否均已阵亡
				if self.currentWaveOnGoing == false then
					self:WaveSpawnCamera(self.waveGuidePos)
					self:SpawnEnemy(self.currentWave)
					--敌人小地图显示
					--BehaviorFunctions.ShowLevelEnemy(self.levelId, true)
					BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
					self.currentWaveOnGoing = true
				else
					--如果该波次敌人均已阵亡，进入下一波次，重置检测器
					if self.waveTotalCount == self.waveDeathCount then
						if self.isCountDown == false then
							self.targetFrame = self.frame + self.intervalTime * 30
							self.isCountDown = true
						else
							if self.frame >= self.targetFrame then
								self.currentWave = self.currentWave + 1
								self.waveTotalCount = 0
								self.waveDeathCount = 0
								self.currentWaveOnGoing = false
								self.isCountDown = false
							end
						end
					end
				end

				--如果这是最后波次，先生成敌人并检测是否全部阵亡
			elseif self.currentWave == self.waveLimit then
				if self.currentWaveOnGoing == false then
					self:WaveSpawnCamera(self.waveGuidePos)
					self:SpawnEnemy(self.currentWave)
					--敌人小地图显示
					--BehaviorFunctions.ShowLevelEnemy(self.levelId, true)
					BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
					self.currentWaveOnGoing = true
				else
					--如果全部敌人阵亡，开启最终实体的交互并进入下一任务阶段
					if self.waveTotalCount == self.waveDeathCount then
						if self.isCountDown == false then
							self.targetFrame = self.frame + self.intervalTime * 30
							self.isCountDown = true
						else
							if self.frame >= self.targetFrame then
								self.waveTotalCount = 0
								self.waveDeathCount = 0
								self.currentWaveOnGoing = false
								--关闭最终实体交互
								BehaviorFunctions.SetEntityWorldInteractState(self.missionObj, true)
								self:AddlevelTipSingle(200508004)
								BehaviorFunctions.ShowCommonTitle(10,"拾起月陨石",true)
								--移除空气墙
								self:setSceneObjDeActive(self.propList,1)
								self:setSceneObjDeActive(self.propList,2)

								local targetPos = BehaviorFunctions.GetTerrainPositionP(self.guidePosName,self.levelId)
								self.LevelCommon:LevelCameraLookAtPos(22002,45,nil,self.guidePosName,0.4,0.6)
								
								--移除追踪
								self:RemoveGuidePointer(self.guide)
								
								--BehaviorFunctions.ActiveSceneObj("circal",false,self.levelId)
								BehaviorFunctions.DoEntityAudioStop(self.effectId,"FxYueNengCloud_01_Loop",0,0)
								BehaviorFunctions.DoEntityAudioPlay(self.effectId,"FxYueNengCloud_01_End",true)
								BehaviorFunctions.PlayAnimation(self.effectId,"FxYueNengCircal_01Ani_End")

								--隐藏玩法占用区域
								BehaviorFunctions.ShowMapArea(self.levelId, false)
								BehaviorFunctions.ShowLevelEnemy(self.levelId, false)
								
								self.missionState = 6
							end
						end
					end
				end
			end

			--判断玩家是否点击了最终交互实体
		elseif self.missionState == 6 then
			self:GuidePointer(self.guidePosName)
			--关卡胜利
		elseif self.missionState == 7 then
			--移除空气墙
			self:setSceneObjDeActive(self.propList,1)
			self:setSceneObjDeActive(self.propList,2)

			self:AddlevelTipSingle(200508008)
			--禁用角色输入
			self:DisablePlayerInput(true,true)
			BehaviorFunctions.AddDelayCallByTime(3.9,BehaviorFunctions,BehaviorFunctions.ShowCommonTitle,8,"已清除城市威胁",true)
			BehaviorFunctions.AddDelayCallByTime(2.9,self,self.DisablePlayerInput,false,false)
			BehaviorFunctions.AddDelayCallByTime(3.9,BehaviorFunctions,BehaviorFunctions.FinishLevel,self.levelId)
			self.missionState = 999
			----关卡移除
			--BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
			--BehaviorFunctions.FinishLevel(self.levelId)
			--关卡失败
		elseif self.missionState == 8 then
			self:RemoveTips()

			--移除空气墙
			self:setSceneObjDeActive(self.propList,1)
			self:setSceneObjDeActive(self.propList,2)

			--关卡移除
			BehaviorFunctions.RemoveLevel(self.levelId)
			self.missionState = 999
		end
	end
end

--区域判断
function LevelBehavior200508004:EnterArea(triggerInstanceId, areaName, logicName)
	--判断玩家是否进入区域内
	if triggerInstanceId == self.role and areaName == "levelArea" and self.missionState == 2 then
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁！",true)
		--移除追踪
		self:RemoveGuidePointer(self.guide)
		
		self:AddlevelTipSingle(200508007)
		--移除追踪
		self:RemoveGuidePointer(self.guide)
		--显示玩法占用区域
		BehaviorFunctions.ShowMapArea(self.levelId, true)
		
		self.missionState = 3
	end
	
	--判断玩家是否进入封闭区域内
	if triggerInstanceId == self.role and areaName == "targetZone" and self.missionState == 3 then
		--移除追踪
		self:RemoveGuidePointer(self.guide)
		
		self:AddlevelTipSingle(200508002)
		--移除追踪
		self:RemoveGuidePointer(self.guide)
		self.missionState = 4
	end
end

--区域退出判断
function LevelBehavior200508004:ExitArea(triggerInstanceId, areaName, logicName)
	----判断玩家是否抵达最大关卡卸载范围
	--if triggerInstanceId == self.role and areaName == "exitArea" and self.missionCreated == true then
		--self.missionState = 8
	--end

	--判断敌人是否跌落屋顶，如果跌落算作死亡
	for i,v in ipairs(self.monsterList) do
		if triggerInstanceId == v.id and v.tag == "enemy" and areaName == "levelArea" then
			BehaviorFunctions.SetEntityAttr(v.id,1001,0)
		end
	end
end

--创建看向相机
function LevelBehavior200508004:WaveSpawnCamera(waveGuideList)
	local guidePosName = waveGuideList[self.currentWave].guidePosName
	local selfPos = BehaviorFunctions.GetPositionP(self.role)
	local guidePos = BehaviorFunctions.GetTerrainPositionP(guidePosName,self.levelId)
	local dis = Vec3.Distance(selfPos, guidePos)
	if guidePosName ~= nil and dis >= 8 and dis < 30 then

		local Camera1Born = BehaviorFunctions.GetTerrainPositionP(guidePosName,self.levelId)
		waveGuideList[self.currentWave].target = BehaviorFunctions.CreateEntity(2001,nil,Camera1Born.x,Camera1Born.y,Camera1Born.z,nil,nil,nil,self.levelId) -- 空实体
		self.LevelCommon:LevelCameraLookAtPos(22002,waveGuideList[self.currentWave].removeFrame,nil,guidePosName,0.2,0.6)
	end
end

--检查死亡
function LevelBehavior200508004:Die(attackInstanceId,dieInstanceId)
	for i,v in ipairs(self.monsterList) do
		if v.id == dieInstanceId then
			v.state = self.monsterStateEnum.Dead
			self.waveDeathCount = self.waveDeathCount + 1
			self.deathCount = self.deathCount + 1

			--跟新目标追踪敌人死亡数量
			if self.currentTip then
				BehaviorFunctions.ChangeLevelSubTips(self.currentTip,1,self.deathCount,self.totalCount)
			end
		end
	end
end

--关卡追踪
function LevelBehavior200508004:GuidePointer(posName,radius)
	--检测场上是否已经存在guidePointer，如果有则移除此前的实体并生成新的guidePointer实体
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local guidePos = BehaviorFunctions.GetTerrainPositionP(posName, self.levelId)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)

	if distance <= self.missionInfoUnloadDis then
		if not self.guide then
			self.guide = BehaviorFunctions.CreateEntity(2001,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.AddEntityGuidePointer(self.guide,self.GuideTypeEnum.RoofCombat,0,nil,radius)
		end
	else
		--移除追踪标空实体
		if self.guide and BehaviorFunctions.CheckEntity(self.guide) then
			BehaviorFunctions.RemoveEntity(self.guide)
			self.guide = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntity(self.guide)
		self.guide = nil
	end
end

--关卡移除追踪
function LevelBehavior200508004:RemoveGuidePointer(guide)
	if guide then
		BehaviorFunctions.RemoveEntity(self.guide)
		self.guide = nil
	end
end

--判断是否隐藏tips
function LevelBehavior200508004:TipDisCheck(posName)
	--判断距离玩法的位置
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local guidePos = BehaviorFunctions.GetTerrainPositionP(posName, self.levelId)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	--如果大于卸载距离则隐藏tips，如果小于且没有tips则添加回tips
	if distance <= self.missionInfoUnloadDis then
		if not self.currentTip and self.currentTipId then
			if self.currentTipId == 200508003 then
				self.currentTip = BehaviorFunctions.AddLevelTips(self.currentTipId,self.levelId)

				--跟新目标追踪敌人死亡数量
				BehaviorFunctions.ChangeLevelSubTips(self.currentTip,1,self.deathCount,self.totalCount)
			else
				self.currentTip = BehaviorFunctions.AddLevelTips(self.currentTipId,self.levelId)
			end
		end
	else
		if self.currentTip then
			BehaviorFunctions.RemoveLevelTips(self.currentTip)
			self.currentTip = nil
		end
	end
end

--世界交互事件检测
function LevelBehavior200508004:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.missionObj then
		self.missionState = 7
	end
end

--判断关卡是否被移除
function LevelBehavior200508004:RemoveLevel(levelId)
	if levelId == self.levelId then
		--self:RemoveTips()
	end
end

--赋值
function LevelBehavior200508004:Assignment(variable,value)
	self[variable] = value
end

--禁用角色移动
function LevelBehavior200508004:DisablePlayerInput(isOpen,closeUI)
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

--保证关卡仅有一个tipsid
function LevelBehavior200508004:AddlevelTipSingle(tipsId)
	if self.currentTip then
		BehaviorFunctions.RemoveLevelTips(self.currentTip)
	end

	self.currentTip = BehaviorFunctions.AddLevelTips(tipsId,self.levelId)
	self.currentTipId = tipsId
end

--------------关卡创建--------------------------------------------------------------------------------
--基于波次生成敌人
function LevelBehavior200508004:SpawnEnemy(wave)
	for i,v in ipairs(self.monsterList) do
		if v.tag == "enemy" and wave == v.wave then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
			local rot = BehaviorFunctions.GetTerrainRotationP(v.posName,self.levelId)
			v.id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.SetEntityEuler(v.id,rot.x,rot.y,rot.z)
			v.state = self.monsterStateEnum.Live

			self.waveTotalCount = self.waveTotalCount + 1
		end
	end
end

--控制敌人战斗目标
function LevelBehavior200508004:SetEnemyFightTarget()
	for i,v in ipairs(self.monsterList) do
		if v.state == self.monsterStateEnum.Live then
			--设置敌人攻击对象
			BehaviorFunctions.AddFightTarget(v.id,self.role)
			BehaviorFunctions.SetEntityValue(v.id,"haveWarn",false)
			BehaviorFunctions.SetEntityValue(v.id,"battleTarget",self.role)
			--设置脱战范围
			BehaviorFunctions.SetEntityValue(v.id,"ExitFightRange",40)
			--设置目标追踪范围
			BehaviorFunctions.SetEntityValue(v.id,"targetMaxRange",40)
		end
	end
end

--检测此关卡总敌人数量
function LevelBehavior200508004:TotalEnemyCount()
	for i,v in ipairs(self.monsterList) do
		if v.tag == "enemy" then
			self.totalCount = self.totalCount + 1
		end
	end
end

--对比获取最大wave值
function LevelBehavior200508004:WaveLimitCount()
	self.waveLimit = 1
	for i,v in ipairs(self.monsterList) do
		local currentWaveValue = v.wave
		if v.wave > self.waveLimit then
			self.waveLimit = v.wave
		end
	end
end

--生成可破坏物
function LevelBehavior200508004:SpawnItem(List)
	for i,v in ipairs(List) do
		if v.instanceId == nil then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
			local rot = BehaviorFunctions.GetTerrainRotationP(v.posName,self.levelId)
			v.id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.SetEntityEuler(v.id,rot.x,rot.y,rot.z)
		end
	end
end

--------------关卡移除处理--------------------------------------------------------------------------------
function LevelBehavior200508004:RemoveTips()
	BehaviorFunctions.HideTip(200508001)
	BehaviorFunctions.HideTip(200508002)
	BehaviorFunctions.HideTip(200508003)
	BehaviorFunctions.HideTip(200508004)
	BehaviorFunctions.HideTip(200508005)
	BehaviorFunctions.HideTip(200508006)
	--BehaviorFunctions.HideTip(200508007)
end

--批次设置预设物件显示
function LevelBehavior200508004:setSceneObjDeActive(List,index)
	local count = List[index].count
	for i = count,1,-1 do
		local objName = List[index].objName..i
		BehaviorFunctions.ActiveSceneObj(objName,false,self.levelId)
	end
end

--批次设置预设物件显示
function LevelBehavior200508004:setSceneObjActive(List,index)
	local count = List[index].count
	for i = count,1,-1 do
		local objName = List[index].objName..i
		BehaviorFunctions.ActiveSceneObj(objName,true,self.levelId)
	end
end


function LevelBehavior200508004:FinishLevel(levelId)
	if levelId == self.levelId then
		--BehaviorFunctions.AddDelayCallByTime(0.3,BehaviorFunctions,BehaviorFunctions.ShowCommonTitle,8,"已清除城市威胁",true)
	end
end


function LevelBehavior200508004:RemoveLevel(levelId)
	if levelId == self.levelId then
		--移除空气墙
		self:setSceneObjDeActive(self.propList,1)
		self:setSceneObjDeActive(self.propList,2)
	end
end