LevelBehavior303050104 = BaseClass("LevelBehavior303050104",LevelBehaviorBase)

function LevelBehavior303050104:__init(fight)
	self.fight = fight
end

function LevelBehavior303050104.GetGenerates()
	local generates = {
		2040802,2040811,		--赛车实体
		2040881,2040882,2040883,		--检查点实体
		2020704					--空实体
		}
	return generates
end

function LevelBehavior303050104:Init()
	self.missionState = 0
	self.role = nil
	self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点
	self.lasttimestate = false	--倒计时状态
	self.timeStart = 0 -- 初始化时间点
	self.dialogstage = 0			--对话阶段
	self.cameraMon = 22007			--创建镜头ID
	self.car = 0
	self.carCur = 0 --上车后存车的实体
	self.onCar = 0
	self.Racend = 0	--比赛状态
	self.checkPosition = 0 		--检查点
	self.palyercar = nil
	self.ruyingcar = nil
	self.drawroadPath = nil
	self.runroutePos = nil		--车辆追踪
	self.playercheckP = nil 	--玩家驾车位置点
	self.guidePointer = nil		--敌人车辆图标
	self.checkPointer = nil		--路标引导图标
	self.greenrange = 25		--地标换色距离
	self.levelId = 303050103 	--关卡ID
	self.mapId = 303050104		--地点信息
	self.logicName = "TaskSubRacing"	--地图名称

	---检查点实体储存------
	self.checkEntity1 = nil
	self.checkEntity2 = nil
	self.checkEntity3 = nil
	self.checkEntity4 = nil
	self.checkEntity5 = nil
	self.checkEntity6 = nil
	self.checkEntity7 = nil
	self.checkEntity8 = nil
	self.checkEntity9 = nil
	self.checkPosEndEntity = nil
	----------------------

	---空实体储存------
	self.blankEntity1 = nil
	self.blankEntity2 = nil
	self.blankEntity3 = nil
	self.blankEntity4 = nil
	self.blankEntity5 = nil
	self.blankEntity6 = nil
	self.blankEntity7 = nil
	----------------------

	---检查点实体----------
	self.checkWhite = 2040882
	self.checkGreen = 2040881
	self.chackEnd = 2040883
	self.blankEntity = 2020704
	----------------------
	--开放参数
	self.guidecamera = false				--指引镜头
	self.wave = 2                          --总波次
	self.isWarn = true                    --是否开启警戒
	self.imageTipId = nil                 --图文教学
	-------------
	self.routePosName =
	{
		[1] = {posName = "pos1"},
		[2] = {posName = "pos2"},
		[3] = {posName = "pos3"},
		[4] = {posName = "pos4"},
		[5] = {posName = "pos5"},
		[6] = {posName = "pos6"},
	}
	self.drawPosNameList =
	{
		[1] = {drawposName = "Draw1"},
		[2] = {drawposName = "Draw2"},
		[3] = {drawposName = "Draw3"},
		[4] = {drawposName = "Draw4"},
		[5] = {drawposName = "Draw5"},
		[6] = {drawposName = "Draw6"},
		[7] = {drawposName = "Draw7"},
		[8] = {drawposName = "Draw8"},
		[9] = {drawposName = "Draw9"},
		[10] = {drawposName = "Draw10"},
		[11] = {drawposName = "Draw11"},
		[12] = {drawposName = "Draw12"},
		[13] = {drawposName = "Draw13"},
		[14] = {drawposName = "Draw14"},
		[15] = {drawposName = "Draw15"},
	}
	----追踪标----
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
end

function LevelBehavior303050104:Update()
	self.time = BehaviorFunctions.GetFightFrame()	--获取帧数
	self.role = BehaviorFunctions.GetCtrlEntity()	--获取玩家操控角色
	-- BehaviorFunctions.SetTipsGuideState(true)		--隐藏任务信息(任务追踪标不生效)
	BehaviorFunctions.SetTaskGuideDisState(false)		--任务距离显隐(只隐藏了左侧距离，任务追踪标不生效)
	BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)			--追踪图标显隐

	self.onCar = BehaviorFunctions.CheckEntityDrive(self.role)
	if BehaviorFunctions.GetDrivingEntity(self.role) then
		self.carCur = BehaviorFunctions.GetDrivingEntity(self.role)
		self.car = self.carCur
	end
	-- self.car = BehaviorFunctions.GetDrivingEntity(2040811)

	if self.missionState == 0 then	--玩家信息
		local PlayRacePos = BehaviorFunctions.GetTerrainPositionP("PlayRace", self.levelId)
		local PlayRaceRot = BehaviorFunctions.GetTerrainRotationP("PlayRace", self.levelId)
		local Playlook = BehaviorFunctions.GetTerrainPositionP("PlayRaceCam", self.levelId)
		BehaviorFunctions.SetEntityEuler(self.role,PlayRaceRot.x,PlayRaceRot.y,PlayRaceRot.z)
		self.palyercar = BehaviorFunctions.CreateEntity(2040811, nil, PlayRacePos.x, PlayRacePos.y, PlayRacePos.z,Playlook.x,Playlook.y,Playlook.z,self.levelId)
		BehaviorFunctions.SetPlayerDrive(self.palyercar,self.role,true)
		BehaviorFunctions.SetTrafficMode(2)
		BehaviorFunctions.SetDisableGetOffCar(self.palyercar,true)

		----绘制引导线----
		if self.drawroadPath == nil then
			local drawPos = self:GetDrawPos(self.drawPosNameList)
			print("drawPos",drawPos)
			self.drawroadPath = BehaviorFunctions.DrawRoadPath1(drawPos)
			print("self.drawroadPath",self.drawroadPath)
		end
		------------------

		----统一创建检查点和追踪表用空实体----------
		do
			--checkPos1
			local checkPos1 = BehaviorFunctions.GetTerrainPositionP("checkP1",self.levelId)
			local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP1",self.levelId)
			self.checkEntity1 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos1.x, checkPos1.y, checkPos1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)
			--checkPos2
			local checkPos2 = BehaviorFunctions.GetTerrainPositionP("checkP2",self.levelId)
			local checkPosRot2 = BehaviorFunctions.GetTerrainRotationP("checkP2",self.levelId)
			self.checkEntity2 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos2.x, checkPos2.y, checkPos2.z,checkPosRot2.x,checkPosRot2.y,checkPosRot2.z,self.levelId)
			--checkPos3
			local checkPos3 = BehaviorFunctions.GetTerrainPositionP("checkP3",self.levelId)
			local checkPosRot3 = BehaviorFunctions.GetTerrainRotationP("checkP3",self.levelId)
			self.checkEntity3 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos3.x, checkPos3.y, checkPos3.z,checkPosRot3.x,checkPosRot3.y,checkPosRot3.z,self.levelId)
			--checkPos4
			local checkPos4 = BehaviorFunctions.GetTerrainPositionP("checkP4",self.levelId)
			local checkPosRot4 = BehaviorFunctions.GetTerrainRotationP("checkP4",self.levelId)
			self.checkEntity4 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos4.x, checkPos4.y, checkPos4.z,checkPosRot4.x,checkPosRot4.y,checkPosRot4.z,self.levelId)
			--checkPos5
			local checkPos5 = BehaviorFunctions.GetTerrainPositionP("checkP5",self.levelId)
			local checkPosRot5 = BehaviorFunctions.GetTerrainRotationP("checkP5",self.levelId)
			self.checkEntity5 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos5.x, checkPos5.y, checkPos5.z,checkPosRot5.x,checkPosRot5.y,checkPosRot5.z,self.levelId)
			--checkPos6
			local checkPos6 = BehaviorFunctions.GetTerrainPositionP("checkP6",self.levelId)
			local checkPosRot6 = BehaviorFunctions.GetTerrainRotationP("checkP6",self.levelId)
			self.checkEntity6 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos6.x, checkPos6.y, checkPos6.z,checkPosRot6.x,checkPosRot6.y,checkPosRot6.z,self.levelId)
			do
				-- --checkPos7
				-- local checkPos7 = BehaviorFunctions.GetTerrainPositionP("checkP7",self.levelId)
				-- local checkPosRot7 = BehaviorFunctions.GetTerrainRotationP("checkP7",self.levelId)
				-- self.checkEntity7 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos7.x, checkPos7.y, checkPos7.z,checkPosRot7.x,checkPosRot7.y,checkPosRot7.z,self.levelId)
				-- --checkPos8
				-- local checkPos8 = BehaviorFunctions.GetTerrainPositionP("checkP8",self.levelId)
				-- local checkPosRot8 = BehaviorFunctions.GetTerrainRotationP("checkP8",self.levelId)
				-- self.checkEntity8 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos8.x, checkPos8.y, checkPos8.z,checkPosRot8.x,checkPosRot8.y,checkPosRot8.z,self.levelId)
				-- --checkPos9
				-- local checkPos9 = BehaviorFunctions.GetTerrainPositionP("checkP9",self.levelId)
				-- local checkPosRot9 = BehaviorFunctions.GetTerrainRotationP("checkP9",self.levelId)
				-- self.checkEntity9 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos9.x, checkPos9.y, checkPos9.z,checkPosRot9.x,checkPosRot9.y,checkPosRot9.z,self.levelId)
				
				-- --checkPosEnd-终点
				-- local checkPosEnd = BehaviorFunctions.GetTerrainPositionP("checkPosEnd",self.levelId)
				-- local checkPosEndRot = BehaviorFunctions.GetTerrainRotationP("checkPosEnd",self.levelId)
				-- self.checkPosEndEntity = BehaviorFunctions.CreateEntity(self.chackEnd, nil, checkPosEnd.x, checkPosEnd.y, checkPosEnd.z,checkPosEndRot.x,checkPosEndRot.y,checkPosEndRot.z,self.levelId)
			end
		end
		---------------------------
		self.missionState = 1
	end

	if self.missionState == 1 then
		local RuyingPos = BehaviorFunctions.GetTerrainPositionP("RuyingCarEnd", self.levelId)
		local Ruyinglook = BehaviorFunctions.GetTerrainPositionP("pos2", self.levelId)
		self.ruyingcar = BehaviorFunctions.CreateEntity(2040802, nil, RuyingPos.x, RuyingPos.y, RuyingPos.z,Ruyinglook.x,Ruyinglook.y,Ruyinglook.z,self.levelId)
		self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.ruyingcar,self.GuideTypeEnum.Challenge,0,false)
		self.missionState = 2
	end

	if self.missionState == 2 then

		--开场对话
		if self.dialogstage == 0 then
			BehaviorFunctions.StartStoryDialog(202120701)
			self.dialogstage = 1
		end

		--开场对话结束开始比赛
		if self.dialogstage == 202120701 then
			--比赛计数播报
			BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.ShowTip,10010010)
			BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.ShowTip,10010011)
			BehaviorFunctions.AddDelayCallByTime(7,BehaviorFunctions,BehaviorFunctions.ShowTip,10010012)
			--比赛开始播报
			BehaviorFunctions.AddDelayCallByTime(9,BehaviorFunctions,BehaviorFunctions.ShowTip,303010104)
			-- BehaviorFunctions.ShowTip(303010104)
			BehaviorFunctions.AddDelayCallByTime(9,BehaviorFunctions,BehaviorFunctions.ActiveSceneObj,"wallstate",false,self.levelId)

			--玩家能发动汽车播报
			-- BehaviorFunctions.AddDelayCallByTime(9,BehaviorFunctions,BehaviorFunctions.CarBrake,self.palyercar,false)
			--BehaviorFunctions.CarBrake(self.palyercar,true)
			BehaviorFunctions.AddDelayCallByTime(9,BehaviorFunctions,BehaviorFunctions.SetCarBroken,self.palyercar,false)
			-- BehaviorFunctions.SetCarBroken(self.palyercar,true)

			--敌人车辆能行驶
			self.routePos = self:GetCarPath(self.routePosName)
			self.runroutePos = BehaviorFunctions.AddDelayCallByTime(9,BehaviorFunctions,BehaviorFunctions.StartCarFollowPath,self.ruyingcar,false,self.routePos,true)
			-- BehaviorFunctions.StartCarFollowPath(self.ruyingcar,false,self.routePos,true)

			self.missionState = 3
		end
	end

	if self.missionState == 3 then
		self.playercheckP = BehaviorFunctions.GetPositionP(self.role)
		--实时获取玩家驾车位置
		if self.checkPosition == 0 then
			self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity1,self.GuideTypeEnum.Riddle,0,false)
			self.checkPosition = 1
		end

		--逐个检查不同位置点，并执行对应命令
		do

			--checkP1
			if self.checkPosition == 1 then
				local checkP = BehaviorFunctions.GetTerrainPositionP("checkP1",self.levelId)
				local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)	--获取与路标特效的距离
				if checkPRange < 20 then
					local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP1", self.levelId)
					local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP1",self.levelId)
					BehaviorFunctions.PlayAnimation(self.checkEntity1,"FxNextCheckPoint_lu")
					BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity1)
					-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- self.checkEntity1 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen,nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)
					-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z)

					--更新检查点追踪表
					BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
					self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity2,self.GuideTypeEnum.Riddle,0,false)
					self.checkPosition = 2
				end
			end
			 ---checkP2
			 if self.checkPosition == 2 then
			 	local checkP = BehaviorFunctions.GetTerrainPositionP("checkP2",self.levelId)
			 	local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)
			 	if checkPRange < self.greenrange then
			 		local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP2", self.levelId)
			 		local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP2",self.levelId)
			 		BehaviorFunctions.PlayAnimation(self.checkEntity2,"FxNextCheckPoint_lu")
			 		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity2)
			 		-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
			 		-- self.checkEntity2 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen,nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)
			 		-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z)

			 		--更新检查点追踪表
			 		BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
			 		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity3,self.GuideTypeEnum.Riddle,0,false)

					--第一个旁白
					if self.dialogstage == 202120701 then
						BehaviorFunctions.StartStoryDialog(202120801)
						self.dialogstage = 2
					end

			 		self.checkPosition = 3
			 	end
			 end
			---checkP3
			if self.checkPosition == 3 then
				local checkP = BehaviorFunctions.GetTerrainPositionP("checkP3",self.levelId)
				local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)
				if checkPRange < self.greenrange then
					local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP3", self.levelId)
					local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP3",self.levelId)
					BehaviorFunctions.PlayAnimation(self.checkEntity3,"FxNextCheckPoint_lu")
					BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity3)
					-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- self.checkEntity3 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen,nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)
					-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)

					--更新检查点追踪表
					BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
					self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity4,self.GuideTypeEnum.Riddle,0,false)
					self.checkPosition = 4
				end
			end
			---checkP4
			if self.checkPosition == 4 then
				local checkP = BehaviorFunctions.GetTerrainPositionP("checkP4",self.levelId)
				local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)
				if checkPRange < self.greenrange then
					local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP4", self.levelId)
					local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP4",self.levelId)
					BehaviorFunctions.PlayAnimation(self.checkEntity4,"FxNextCheckPoint_lu")
					BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity4)
					-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- self.checkEntity4 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen,nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)
					-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)

					--更新检查点追踪表
					BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
					self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity5,self.GuideTypeEnum.Riddle,0,false)
					self.checkPosition = 5
				end
			end
			---checkP5
			if self.checkPosition == 5 then
				local checkP = BehaviorFunctions.GetTerrainPositionP("checkP5",self.levelId)
				local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)
				if checkPRange < self.greenrange then
					local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP5", self.levelId)
					local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP5",self.levelId)
					BehaviorFunctions.PlayAnimation(self.checkEntity5,"FxNextCheckPoint_lu")
					BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity5)
					-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- self.checkEntity5 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen,nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z)
					-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)

					--更新检查点追踪表
					BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
					self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity6,self.GuideTypeEnum.Riddle,0,false)
					self.checkPosition = 6
					print("elapse checkP5")
				end

				--移除之前的路标特效实体
				do
					-- if self.checkEntity3 ~= nil then
					-- 	print("self.checkEntity3 ~= nil",self.checkEntity3)
					-- 	BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- 	BehaviorFunctions.RemoveEntity(self.checkEntity2)
					-- 	BehaviorFunctions.RemoveEntity(self.checkEntity3)
					-- end
					-- print("Remove self.checkEntity3",self.checkEntity3)
				end

				--创建之后的路标特效实体
				do
					if self.checkPosEndEntity == nil then
						print("self.checkPosEndEntity == nil",self.checkPosEndEntity)
						--checkPos7
						local checkPos7 = BehaviorFunctions.GetTerrainPositionP("checkP7",self.levelId)
						local checkPosRot7 = BehaviorFunctions.GetTerrainRotationP("checkP7",self.levelId)
						self.checkEntity7 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos7.x, checkPos7.y, checkPos7.z,nil,nil,nil,self.levelId)
						BehaviorFunctions.SetEntityEuler(self.checkEntity7,checkPosRot7.x,checkPosRot7.y,checkPosRot7.z)
						-- self.checkEntity7 = BehaviorFunctions.CreateEntityByPosition(self.checkWhite, nil, "checkP7", self.logicName, nil, self.levelId)
						if self.checkEntity7 ~= nil then
							print("self.checkEntity7",self.checkEntity7)
						end
						--checkPos8
						local checkPos8 = BehaviorFunctions.GetTerrainPositionP("checkP8",self.levelId)
						local checkPosRot8 = BehaviorFunctions.GetTerrainRotationP("checkP8",self.levelId)
						self.checkEntity8 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos8.x, checkPos8.y, checkPos8.z,checkPosRot8.x,checkPosRot8.y,checkPosRot8.z,self.levelId)
						--checkPos9
						local checkPos9 = BehaviorFunctions.GetTerrainPositionP("checkP9",self.levelId)
						local checkPosRot9 = BehaviorFunctions.GetTerrainRotationP("checkP9",self.levelId)
						self.checkEntity9 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos9.x, checkPos9.y, checkPos9.z,checkPosRot9.x,checkPosRot9.y,checkPosRot9.z,self.levelId)
						
						--checkPosEnd-终点
						local checkPosEnd = BehaviorFunctions.GetTerrainPositionP("checkPosEnd",self.levelId)
						local checkPosEndRot = BehaviorFunctions.GetTerrainRotationP("checkPosEnd",self.levelId)
						self.checkPosEndEntity = BehaviorFunctions.CreateEntity(self.chackEnd, nil, checkPosEnd.x, checkPosEnd.y, checkPosEnd.z,checkPosEndRot.x,checkPosEndRot.y,checkPosEndRot.z,self.levelId)
					end
					print("Create self.checkPosEndEntity",self.checkPosEndEntity)
				end

			end
			---checkP6
			if self.checkPosition == 6 then
				local checkP = BehaviorFunctions.GetTerrainPositionP("checkP6",self.levelId)
				local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)
				if checkPRange < self.greenrange then
					local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP6", self.levelId)
					local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP6",self.levelId)
					BehaviorFunctions.PlayAnimation(self.checkEntity6,"FxNextCheckPoint_lu")
					BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity6)
					-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- self.checkEntity6 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen,nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z)
					-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)

					--更新检查点追踪表
					BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
					self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity7,self.GuideTypeEnum.Riddle,0,false)
					self.checkPosition = 7
				end

				--卸载前5个路标特效实体
				do
					-- if self.checkEntity5 ~= nil then
					-- 	BehaviorFunctions.RemoveEntity(self.checkEntity4)
					-- 	BehaviorFunctions.RemoveEntity(self.checkEntity5)
					-- end
				end

			end
			---checkP7
			if self.checkPosition == 7 then
				local checkP = BehaviorFunctions.GetTerrainPositionP("checkP7",self.levelId)
				local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)
				if checkPRange < self.greenrange then
					local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP7", self.levelId)
					local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP7",self.levelId)
					BehaviorFunctions.PlayAnimation(self.checkEntity7,"FxNextCheckPoint_lu")
					BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity7)
					-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- self.checkEntity7 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen, nil, checkP1.x, checkP1.y, checkP1.z,nil,nil,nil,self.levelId)
					print("self.checkEntity7 Green",self.checkEntity7)
					-- BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.SetEntityEuler,self.checkEntity7, checkPosRot1.x,checkPosRot1.y,checkPosRot1.z)	--This code can be incorrect
					-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)

					--更新检查点追踪表
					BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
					self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity8,self.GuideTypeEnum.Riddle,0,false)

					--第二个旁白
					if self.dialogstage == 202120801 then
						BehaviorFunctions.StartStoryDialog(202120901)
						self.dialogstage = 3
					end

					self.checkPosition = 8
				end
			end
			---checkP8
			if self.checkPosition == 8 then
				local checkP = BehaviorFunctions.GetTerrainPositionP("checkP8",self.levelId)
				local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)
				if checkPRange < 15 then
					local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP8", self.levelId)
					local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP8",self.levelId)
					BehaviorFunctions.PlayAnimation(self.checkEntity8,"FxNextCheckPoint_lu")
					BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity8)
					-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- self.checkEntity8 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen,nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z)
					-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)

					--更新检查点追踪表
					BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
					self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity9,self.GuideTypeEnum.Riddle,0,false)

					--快到终点的旁白
					if self.dialogstage == 202120901 then
						BehaviorFunctions.StartStoryDialog(202121001)
						self.dialogstage = 4
					end

					self.checkPosition = 9
				end
			end
			---checkP9
			if self.checkPosition == 9 then
				local checkP = BehaviorFunctions.GetTerrainPositionP("checkP9",self.levelId)
				local checkPRange = BehaviorFunctions.GetDistanceFromPos(checkP,self.playercheckP)
				if checkPRange < self.greenrange then
					local checkP1 = BehaviorFunctions.GetTerrainPositionP("checkP9", self.levelId)
					local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP9",self.levelId)
					BehaviorFunctions.PlayAnimation(self.checkEntity9,"FxNextCheckPoint_lu")
					BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.checkEntity9)
					-- BehaviorFunctions.RemoveEntity(self.checkEntity1)
					-- self.checkEntity9 = BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.checkGreen,nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z)
					-- self.checkEntity1 = BehaviorFunctions.CreateEntity(2040881, nil, checkP1.x, checkP1.y, checkP1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)

					--更新检查点追踪表
					BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
					self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkPosEndEntity,self.GuideTypeEnum.Riddle,0,false)	--终点checkPosEndEntity
					-- self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity10,self.GuideTypeEnum.Riddle,0,false)



					self.checkPosition = 10
				end

				--卸载前3个路标特效实体
				do
					if self.checkEntity8 ~= nil then
						BehaviorFunctions.RemoveEntity(self.checkEntity6)
						BehaviorFunctions.RemoveEntity(self.checkEntity7)
						BehaviorFunctions.RemoveEntity(self.checkEntity8)
					end
				end

			end

		end
	end

	--到达终点
	if self.missionState == 3 and self.checkPosition > 2 then
		local playcarpos = BehaviorFunctions.GetPositionP(self.role)
		local racend = BehaviorFunctions.GetTerrainPositionP("EndAreaPoint",self.levelId)
		local pra = BehaviorFunctions.GetDistanceFromPos(racend,playcarpos)
		if pra < 10 then
			
			--到达终点的旁白
			if self.dialogstage == 202121001 then
				BehaviorFunctions.StartStoryDialog(202121101)
				self.dialogstage = 5
			end

			print("到达终点，卸载")
			BehaviorFunctions.SetTipsGuideState(false)		--隐藏任务信息
			BehaviorFunctions.CarBrake(self.palyercar,true)	--强制刹车
			BehaviorFunctions.UnloadRoadPath(self.drawroadPath)
			BehaviorFunctions.UnloadRoadPathAll(self.routePos)
			BehaviorFunctions.ShowTip(303010103)
			--完全移除检查点追踪标
			BehaviorFunctions.RemoveEntityGuidePointer(self.checkPointer)
			BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
			BehaviorFunctions.DisableAllSkillButton(self.role,true)
			self.missionState = 4
		end
	end

	--到达终点后，关卡结束
	if self.missionState == 4 then
		if self.dialogstage == 202121101 then
			print("关卡完全结束")
			BehaviorFunctions.DisableAllSkillButton(self.role,false)
			-- BehaviorFunctions.AddDelayCallByTime(4,BehaviorFunctions,BehaviorFunctions.SetDisableGetOffCar,self.palyercar, false)
			BehaviorFunctions.SetDisableGetOffCar(self.palyercar,false)
			-- BehaviorFunctions.AddDelayCallByTime(4,BehaviorFunctions,BehaviorFunctions.GetOffCar,self.palyercar)
			BehaviorFunctions.GetOffCar(self.palyercar)
			BehaviorFunctions.AddDelayCallByTime(3,self,self.LevelFinish)
			-- self:LevelFinish()
			print("关卡完全结束内容执行完毕")
			self.missionState = 99
		end
	end
end

function LevelBehavior303050104:__delete()
end

---------------------回调----------------------------------

--死亡回调
function LevelBehavior303050104:Death(instanceId,isFormationRevive)
end

--回调，完成相关剧情
function LevelBehavior303050104:StoryEndEvent(dialogId)
	if dialogId == 202120701 and self.dialogstage == 1 then   --播完成功后的对话
		self.dialogstage = 202120701
	end
	if dialogId == 202120801 and self.dialogstage == 2 then   --第一个旁白结束
		self.dialogstage = 202120801
	end
	if dialogId == 202120901 and self.dialogstage == 3 then   --第二个旁白结束
		self.dialogstage = 202120901
	end
	if dialogId == 202121001 and self.dialogstage == 4 then   --快到终点旁白结束
		self.dialogstage = 202121001
	end
	if dialogId == 202121101 and self.dialogstage == 5 then   --快到终点旁白结束
		self.dialogstage = 202121101
		print("终点旁白播放完毕")
	end
end

-------------------------函数--------------------------------

--设置关卡相机函数
function LevelBehavior303050104:SetLevelCamera()
	self.empty = BehaviorFunctions.CreateEntity(2001, nil, self.currentWaveLookAtPos.x, self.currentWaveLookAtPos.y + 1, self.currentWaveLookAtPos.z,nil,nil,nil,self.levelId)
	self.levelCam = BehaviorFunctions.CreateEntity(22001,nil,nil,nil,nil,nil,nil,nil,self.levelId)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
	--看向目标
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

function LevelBehavior303050104:GetCarPath(posNameList)
	local posListCache = {}
	for k,v in ipairs(posNameList) do
		if v.posName then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
			table.insert(posListCache,pos)
			local a1 = 1
		end
	end
	return posListCache
end

function LevelBehavior303050104:GetDrawPos(DrawposList)
	local posListDraw = {}
	for k,v in ipairs(DrawposList) do
		if v.drawposName then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.drawposName,self.levelId)
			table.insert(posListDraw,pos)
		end
	end
	return posListDraw
end

--关卡结束函数
function LevelBehavior303050104:LevelFinish()
    BehaviorFunctions.FinishLevel(self.levelId)
end