LevelBehavior200502002 = BaseClass("LevelBehavior200502002",LevelBehaviorBase)

function LevelBehavior200502002.GetGenerates()
	local generates = {790007000,2030901,2030510,
		2030909,2030902,	--咖啡馆门前后
		2001,22002,		--相机相关
		2040902,	--室外竖管
		2040903,	--室内横管
		2030904,	--后门锁
		808011001,	--NPCID
		2080102,	--建造板
		2030907,	--通风管道骇入实体
		2030903,	--电压陷阱
		2030532006,		--引导特效
	}
	return generates
end

function LevelBehavior200502002.GetMagics()
	local generates = {1000111,
	}
	return generates
end

function LevelBehavior200502002:__init(fight)
	self.fight = fight
	self.isCount = false
	self.targetFrame = nil
	self.intervalTime = 3
end

function LevelBehavior200502002:Init()
	self.role = 0		--角色
	self.playerPos = nil		--角色坐标
	self.missionState = 0	--关卡阶段
	self.roleDistance = false	--玩家进入关卡加载范围
	self.playerPosName = "Player"

	--位置点信息
	self.missionStartDis = 50 ---挑战开始距离
	self.missionStartPos = nil --挑战开始位置
	self.missionCreate = false --检查关卡是否加载
	self.missionDistance = nil --操作角色与挑战关卡的距离
	self.missionUnloadDis = 90 --肉鸽玩法未开始的卸载距离
	self.unloaded = false

	--追踪标
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 70				--加载追踪图标距离
	self.guideDistanceMin = 50			--隐藏追踪图标最小距离
	self.guidePos = nil
	self.guideEmptyEntityId = 2041101		--追中图标用空实体
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
		Collect = FightEnum.GuideType.Collect,
		Robbery = FightEnum.GuideType.Map_Robbery,
	}

	--NPC追踪标
	self.saveNpcGuide = {
		[1] = {Id = nil ,state = 1,};
		[2] = {Id = nil ,state = 1,};
		[3] = {Id = nil ,state = 1,};
	}

	--角色空间状态
	self.spaceStation ={
		outDoor = 0,
		onRoof = 1,
		inDoor = 2,
	}
	self.roleSpaceStationA = self.spaceStation.outDoor
	self.outDoorSpeace = "outDoor"
	self.onRoofSpeace = "onRoof"
	self.inDoorSpeace = "inDoor"
	self.RoomupSpeace = "Roomup"

	--室内
	self.spaceinDoorSmall ={
		Out = 0,
		In = 1,
	}
	self.InDoorSmallCheck = self.spaceinDoorSmall.Out
	self.inDoorSmall = "inDoorSmall"

	--时间状态
	self.roleTimeState = nil
	self.timeStation ={	--暂时为空
	}

	--关卡倒计时
	self.time = 0
	self.timeLimit = 60
	self.startFrame = nil
	self.timeLimitFrames = 0
	self.timeCheck = {
		Runing = 0,			--倒计时中
		Lose = 1,			--超时
	}
	self.timeCheckState = self.timeCheck.Runing

	--tips
	self.doorDownKeyTips = 102670120
	self.doorDownKeyShow = false
	self.combatTips = 102670121
	self.combatTipsId = nil
	self.combatTipsShow = false
	self.doorOutTips = 102670122
	self.doorOutTipsCheck = false
	self.doorOutTipsId = nil
	self.doorOutHitTips = 102670126
	self.saveNpcTips = 102670123
	self.saveNpcTipsId = nil
	self.RoomupCheck = false
	self.RoomupTipsCheck = false

	--Dialog 对话
	self.HelpDialogId = 602190201
	self.HelpDialogCheck = false
	self.EndDialogId = 602190101
	self.EndDialogCheck = false

	--延时调用
	self.delayCallList = {}
	--当前延时数量
	self.currentdelayCallNum = 0

	--怪物
	self.monsterID = 790007000
	self.monsterStateEnum = {
		Live = 0,
		Dead = 1,
	}
	self.monsterList ={
		[1] = {Id = nil ,entityId = self.monsterID ,state = self.monsterStateEnum.Live ,posName = "Pos1" ,wave = 1 ,patrolList = {"Pos1","Pos1return"}};
		[2] = {Id = nil ,entityId = self.monsterID ,state = self.monsterStateEnum.Live ,posName = "Pos2" ,wave = 1 ,patrolList = {"Pos2","Pos2return"}};
		[3] = {Id = nil ,entityId = self.monsterID ,state = self.monsterStateEnum.Live ,posName = "Pos3" ,wave = 1 ,patrolList = {"Pos3","Pos3return"}};
		[4] = {Id = nil ,entityId = self.monsterID ,state = self.monsterStateEnum.Live ,posName = "Pos4" ,wave = 1 ,patrolList = {"Pos4","Pos4return"}};
		[5] = {Id = nil ,entityId = self.monsterID ,state = self.monsterStateEnum.Live ,posName = "Pos5" ,wave = 1 ,patrolList = {"Pos5","Pos5return"}};
	}
	self.speedAttrs = 9			--怪物移动速度属性ID
	self.speedScale = (24500 * 0.5)	--减速比例
	self.monsterAllDead = false		--全部怪物死亡
	self.AllCount = 5				--死亡计数，All
	self.deathCount = 0				--死亡计数，check
	self.playFight = true

	--npc信息
	self.npcEcoIdList ={				--808011001
		[1] = 2003001130095;
		[2] = 2003001130096;
		[3] = 2003001130097;
	}
	self.npcEnum = {
		Squat = 0,
		Stand = 1,
	}
	self.npcStateCheck = self.npcEnum.Squat
	self.npcList =	{
		[1] = {Id = nil ,EcoId = self.npcEcoIdList[1] ,state = self.npcEnum.Squat ,posName = "NPC1"};
		[2] = {Id = nil ,EcoId = self.npcEcoIdList[2] ,state = self.npcEnum.Squat ,posName = "NPC2"};
		[3] = {Id = nil ,EcoId = self.npcEcoIdList[3] ,state = self.npcEnum.Squat ,posName = "NPC3"};
	}
	self.npc3AreCheck = false
	self.npcAre = "NPC3Are"
	self.npcRescue = 0			--解救NPC数量
	self.npcRescueAllCount = 3		--NPC总数
	self.npcInteractState = false	--开启NPC交互

	--摄像头
	self.monitorID = 2030510		--摄像头
	self.monitorState = 2030901		--基站
	self.HackFxPoint = 2030532006	--强指引特效
	self.monitorList =	{
		[1] = {Id = nil ,entityId = self.monitorID ,posName = "Monitor01"};
		[2] = {Id = nil ,entityId = self.monitorID ,posName = "Monitor02"};
		[3] = {Id = nil ,entityId = self.monitorID ,posName = "Monitor03"};
		[4] = {Id = nil ,entityId = self.monitorState ,posName = "MonitorState"};
		[5] = {Id = nil ,entityId = self.monitorID ,posName = "Monitor04"};
		[6] = {Id = nil ,entityId = self.HackFxPoint ,posName = "MonitorFx"}
	}

	--两个咖啡馆门信息
	--咖啡馆门实体
	-- self.frontDoorEcoID = 2003001150003		--生态ID，弃用
	-- self.backDoorEcoID = 2003001150004		--生态ID，弃用
	self.frontDoorEntityID = 2030909
	self.backDoorEntityID = 2030902
	self.doorStateEnum = {
		Close = 0,
		Open = 1,
	}
	self.doorList =	{
		[1] = {Id = nil ,entityId = self.frontDoorEntityID ,state = self.doorStateEnum.Close ,posName = "DoorTop"};
		[2] = {Id = nil ,entityId = self.backDoorEntityID ,state = self.doorStateEnum.Close ,posName = "DoorDown"};
	}
	self.backDoorOpen = false

	--后门锁
	self.doorDownKeyEntityID = 2030904
	self.doorDownKeyStateEnum = {
		Close = 0,
		Open = 1,
	}
	self.doorDownKeyList =	{
		[1] = {Id = nil ,entityId = self.doorDownKeyEntityID ,state = self.doorDownKeyStateEnum.Close ,posName = "DoorDownKey"};
	}

	--通风管道
	self.PipeEcoIdA = 2003001150091
	self.PipeEcoIdB = 2003001150092
	self.Pipe = nil
	self.pipeEcoStateEnum = {
		close = 0,
		open = 1,
	}
	self.pipeEcoList =	{
		[1] = {Id = nil ,EcoId = self.PipeEcoIdA ,state = self.pipeEcoStateEnum.close };
		[2] = {Id = nil ,EcoId = self.PipeEcoIdB ,state = self.pipeEcoStateEnum.close };
	}
	--通风管道交互实体
	self.PipeNullId = 2030907
	self.PipeNullIdEnum = {
		Close = 0,
		Open = 1,
	}
	self.PipeNullKeyList =	{
		[1] = {Id = nil ,entityId = self.PipeNullId ,state = self.PipeNullIdEnum.Close ,posName = "PipeIn"};
	}

	--电压陷阱
	self.shockEntityId = 2030903
	self.shockList =	{
		[1] = {Id = nil ,entityId = self.shockEntityId ,posName = "ShockTrigger1"};
		[2] = {Id = nil ,entityId = self.shockEntityId ,posName = "ShockTrigger2"};
		[3] = {Id = nil ,entityId = self.shockEntityId ,posName = "ShockTrigger3"};
	}

end

function LevelBehavior200502002:Update()

	--初始基础信息
	--实时获取角色信息
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.playerPos = BehaviorFunctions.GetPositionP(self.role)  -- 获取玩家的坐标
	self.missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)	--关卡坐标点
	self.missionDistance = self:updateDistance(self.playerPos,self.role)	--获取玩家和关卡坐标的距离函数

	self.pipeEcoList[1].Id = BehaviorFunctions.GetEcoEntityByEcoId(self.pipeEcoList[1].EcoId)		--获取通风管道
	self.pipeEcoList[2].Id = BehaviorFunctions.GetEcoEntityByEcoId(self.pipeEcoList[2].EcoId)		--获取通风管道

	--获取生态咖啡馆门
	-- self.doorList[1].Id = BehaviorFunctions.GetEcoEntityByEcoId(self.doorList[1].EcoId)		--前门--生态创建弃用
	-- self.doorList[2].Id = BehaviorFunctions.GetEcoEntityByEcoId(self.doorList[2].EcoId)		--后门--生态创建弃用

	--获取生态NPC
	self.npcList[1].Id = BehaviorFunctions.GetEcoEntityByEcoId(self.npcList[1].EcoId)
	self.npcList[2].Id = BehaviorFunctions.GetEcoEntityByEcoId(self.npcList[2].EcoId)
	self.npcList[3].Id = BehaviorFunctions.GetEcoEntityByEcoId(self.npcList[3].EcoId)

	if self.missionState == 0 then			--游戏运行

		--创建怪物
		self:CreateMonster(self.monsterList)
		self:MonsterPatrol(self.monsterList)			--触发巡逻

		self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
		self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowMapArea,self.levelId, true)

		--创建摄像头
		self:CreateMonster(self.monitorList)

		--设置后门开启信息
		-- if self.doorList[2].Id ~= nil then
		-- 	BehaviorFunctions.SetEntityValue(self.doorList[2].Id,"doorOpen",false)
		-- end
		--创建大门
		self:CreateMonster(self.doorList)
		for i, v in ipairs(self.doorList) do
			if v.Id ~= nil then
				BehaviorFunctions.SetEntityValue(v.Id,"doorOpen",false)
				BehaviorFunctions.SetEntityValue(v.Id,"gamePlay",true)
			end
		end

		--创建后门锁
		self:CreateMonster(self.doorDownKeyList)

		--创建电压陷阱
		self:CreateMonster(self.shockList)

		--创建npc
		for i, v in ipairs(self.npcList) do			--npc下蹲
			if v.Id then
				BehaviorFunctions.PlayAnimation(v.Id,"Squat_loop",FightEnum.AnimationLayer.PerformLayer)
				BehaviorFunctions.SetPartEnableHit(v.Id, "Body", false)		--NPC免疫受击
				BehaviorFunctions.SetEntityValue(v.Id,"gamePlay",true)		--修改NPC为游戏状态
			end
		end

		--修改通风管道初始信息
		self:CreateMonster(self.PipeNullKeyList)			--创建通风管道骇入实体
		for i, v in ipairs(self.pipeEcoList) do
			if v.Id ~= nil then
				local canOpenKey = not BehaviorFunctions.GetEntityValue(v.Id,"canOpenKey") or (self.pipeEcoList[1].Id and BehaviorFunctions.GetEntityValue(self.pipeEcoList[1].Id,"canOpenKey"))
				if canOpenKey then
					BehaviorFunctions.SetEntityValue(v.Id,"canOpenKey",false)
				end
			end
		end
		-- if self.pipeEcoList[1].Id ~= nil and self.PipeNullKeyList[1].Id ~= nil then
		-- 	if BehaviorFunctions.GetEntityValue(self.pipeEcoList[1].Id,"canOpenKey") == nil or BehaviorFunctions.GetEntityValue(self.pipeEcoList[1].Id,"canOpenKey") == true then
		-- 		BehaviorFunctions.SetEntityValue(self.pipeEcoList[1].Id,"canOpenKey",false)
		-- 	end
		-- end

		self.missionState = 1
	elseif self.missionState == 1 then
		self.missionState = 2
	end

	if self.missionState ~= 999 then
		--创建追中图标
		self:GuidePointer(self.missionStartPos,self.guideDistance,self.missionStartDis,self.GuideTypeEnum.Robbery)	--调用关卡追踪标 函数

		if self.roleSpaceStationA ~= self.spaceStation.inDoor then	--玩家不在室内
			--实时检测玩家距离
			if self.missionDistance <= self.missionStartDis then		--玩家进入关卡玩法区域

				--更新室外tips
				if self.doorOutTipsCheck == true then
					-- BehaviorFunctions.ShowTip(self.doorOutTips)
					if self.doorOutTipsId == nil then
						self.doorOutTipsId =  BehaviorFunctions.AddLevelTips(self.doorOutTips,self.levelId)
					end
				end

				--保底，将玩家传送到玩法加载
				if self.HelpDialogCheck == false and self.roleDistance == false then
					local pos = BehaviorFunctions.GetTerrainPositionP(self.playerPosName,self.levelId,self.logicName)
					BehaviorFunctions.TransportByInstanceId(self.role,pos.x,pos.y,pos.z,0)
					BehaviorFunctions.ShowBlackCurtain(true,0.5)	--黑幕
					self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5)		--移除黑幕
				end

				--获取管道骇入信息修改管道开关
				if self.pipeEcoList[1].Id ~= nil and self.PipeNullKeyList[1].Id ~= nil then
					if self.pipeEcoList[1].state == self.pipeEcoStateEnum.close and self.PipeNullKeyList[1].state == self.PipeNullIdEnum.Open then
						-- self:RemovePipeEco()
						-- self:RemoveEcoState(self.pipeEcoList[1].Id,"canOpenKey")
						BehaviorFunctions.SetEntityValue(self.pipeEcoList[1].Id,"canOpenKey",true)
						-- self:RemoveEntityId(self.PipeNullKeyList[1].Id)
						self.pipeEcoList[1].state = self.pipeEcoStateEnum.open
					end
				end

				--进入区域吸引玩家
				if self.HelpDialogCheck == false and self.roleDistance == true then
					self:LevelLookAtPos("TreasureBox",22002)
					BehaviorFunctions.StartStoryDialog(self.HelpDialogId)
					self.HelpDialogCheck = true
				end

				--玩家走到房顶
				if self.RoomupCheck == true then
					if self.RoomupTipsCheck == false then
						BehaviorFunctions.ShowCommonTitle(10,"尝试骇入技能进入屋内",true)
						self.RoomupTipsCheck = true
					end
				end

			elseif self.missionDistance < self.missionUnloadDis and self.missionDistance >= self.missionStartDis then		--玩家进入加载
				self.roleDistance = true		--玩家正常进入区域
				if self.doorOutTipsId ~= nil then
					BehaviorFunctions.RemoveLevelTips(self.doorOutTipsId)
					self.doorOutTipsId = nil
				end
				-- BehaviorFunctions.RemoveLevelTips(self.doorOutTips)
				-- BehaviorFunctions.RemoveLevelTips(self.doorOutTipsId)

			elseif self.missionDistance > self.missionUnloadDis then	--超远距离卸载关卡
			-- 	self:LevelDelete()
			-- 	BehaviorFunctions.RemoveLevel(self.levelId)
				self.missionState = 999
			end

		else			--玩家在室内
			if self.monsterAllDead == true then			--所有怪物死亡

				if self.npcInteractState == false then

					BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)

					BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
					self.saveNpcTipsId = BehaviorFunctions.AddLevelTips(self.saveNpcTips,self.levelId,self.npcRescueAllCount)
					-- BehaviorFunctions.ChangeLevelTitleTips(self.saveNpcTipsId,self.npcRescue)
					BehaviorFunctions.ChangeSubTipsDesc(1,self.saveNpcTips,self.npcRescue,self.npcRescueAllCount)

					--开启所有NPPC交互组件
					for i, v in pairs(self.npcList) do
						BehaviorFunctions.SetEntityWorldInteractState(v.Id,true)
					end
					--添加NPC追踪标
					self.saveNpcGuide[1].Id =BehaviorFunctions.AddEntityGuidePointer(self.npcList[1].Id ,self.GuideTypeEnum.Collect,1.5,false)
					self.saveNpcGuide[2].Id =BehaviorFunctions.AddEntityGuidePointer(self.npcList[2].Id ,self.GuideTypeEnum.Collect,1.5,false)
					self.saveNpcGuide[3].Id =BehaviorFunctions.AddEntityGuidePointer(self.npcList[3].Id ,self.GuideTypeEnum.Collect,1.5,false)

					self.npcInteractState = true
				end

				--获取NPC是否被交互完毕
				if BehaviorFunctions.GetEntityValue(self.npcList[1].Id,"canOpenKey") == true then
					if self.saveNpcGuide[1].state == 1 then
						self.npcRescue = self.npcRescue + 1
						BehaviorFunctions.RemoveEntityGuidePointer(self.saveNpcGuide[1].Id)
						BehaviorFunctions.ChangeSubTipsDesc(1,self.saveNpcTips,self.npcRescue,self.npcRescueAllCount)
						if self.npcRescue == self.npcRescueAllCount then
							BehaviorFunctions.DoLookAtTargetImmediately(self.npcList[1].Id,self.role)
							-- BehaviorFunctions.SetEntityValue(self.npcList[1].Id,"turnAnim",true)
							BehaviorFunctions.SetEntityValue(self.npcList[1].Id,"happyAnim",true)
							-- self:AddLevelDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.npcList[1].Id,"Jump",FightEnum.AnimationLayer.PerformLayer)
							-- BehaviorFunctions.PlayAnimation(self.saveNpcGuide[1].Id,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
							self.npcRescue = self.npcRescueAllCount + 1
						end
						self.saveNpcGuide[1].state = 2
					end
				end
				if BehaviorFunctions.GetEntityValue(self.npcList[2].Id,"canOpenKey") == true then
					if self.saveNpcGuide[2].state == 1 then
						self.npcRescue = self.npcRescue + 1
						BehaviorFunctions.RemoveEntityGuidePointer(self.saveNpcGuide[2].Id)
						BehaviorFunctions.ChangeSubTipsDesc(1,self.saveNpcTips,self.npcRescue,self.npcRescueAllCount)
						if self.npcRescue == self.npcRescueAllCount then
							BehaviorFunctions.DoLookAtTargetImmediately(self.npcList[2].Id,self.role)
							-- BehaviorFunctions.SetEntityValue(self.npcList[2].Id,"turnAnim",true)
							BehaviorFunctions.SetEntityValue(self.npcList[2].Id,"happyAnim",true)
							-- self:AddLevelDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.npcList[2].Id,"Jump",FightEnum.AnimationLayer.PerformLayer)
							-- BehaviorFunctions.PlayAnimation(self.saveNpcGuide[1].Id,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
							self.npcRescue = self.npcRescueAllCount + 1
						end
						self.saveNpcGuide[2].state = 2
					end
				end
				if BehaviorFunctions.GetEntityValue(self.npcList[3].Id,"canOpenKey") == true then
					if self.saveNpcGuide[3].state == 1 then
						self.npcRescue = self.npcRescue + 1
						BehaviorFunctions.RemoveEntityGuidePointer(self.saveNpcGuide[3].Id)
						BehaviorFunctions.ChangeSubTipsDesc(1,self.saveNpcTips,self.npcRescue,self.npcRescueAllCount)
						if self.npcRescue == self.npcRescueAllCount then
							BehaviorFunctions.DoLookAtTargetImmediately(self.npcList[3].Id,self.role)
							-- BehaviorFunctions.SetEntityValue(self.npcList[3].Id,"turnAnim",true)
							BehaviorFunctions.SetEntityValue(self.npcList[3].Id,"happyAnim",true)
							-- self:AddLevelDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.npcList[3].Id,"Jump",FightEnum.AnimationLayer.PerformLayer)
							-- BehaviorFunctions.PlayAnimation(self.saveNpcGuide[1].Id,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
							self.npcRescue = self.npcRescueAllCount + 1
						end
						self.saveNpcGuide[3].state = 2
					end
				end

				if self.npcRescue == self.npcRescueAllCount + 1 then		--所有NPC都松绑

					self:OpenAllDoor(self.doorList)			--打开所有大门

					if self.doorDownKeyShow == false then			--关卡胜利表现

						do
							BehaviorFunctions.StartStoryDialog(self.EndDialogId)

							-- BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
							-- self:NpcStand(self.npcList)				--Npc都站起来
							-- -- BehaviorFunctions.HideTip(self.combatTipsId)
						end
						self.doorDownKeyShow = true
					end
					self.npcRescue = self.npcRescueAllCount + 2
				end

			else

				--玩家战斗更新Tips
				if self.combatTipsShow == false then
					self.combatTipsId = BehaviorFunctions.AddLevelTips(self.combatTips,self.levelId,self.AllCount)
					-- BehaviorFunctions.ChangeLevelTitleTips(self.combatTipsId,self.deathCount)
					-- BehaviorFunctions.ShowTip(self.combatTips)
					BehaviorFunctions.ChangeSubTipsDesc(1,self.combatTips,self.deathCount,self.AllCount)
					-- BehaviorFunctions.RemoveLevelTips(self.doorOutTips)
					BehaviorFunctions.RemoveLevelTips(self.doorOutTipsId)
					-- BehaviorFunctions.HideTip(self.doorOutTips)
					-- BehaviorFunctions.ShowTip(102670125)
					BehaviorFunctions.ShowCommonTitle(10,"击败所有敌人",true)

					self.combatTipsShow = true
				end

				--关闭所有摄像头骇入功能
				-- for i, v in pairs(self.monitorList) do
				-- 	self:HackClose(v.Id,false)
				-- end
				--关闭所有门禁骇入功能
				for i, v in ipairs(self.doorDownKeyList) do
					self:HackClose(v.Id,false)
				end
				--关闭所有咖啡馆门交互
				for i, v in ipairs(self.doorList) do
					BehaviorFunctions.SetEntityWorldInteractState(v.Id, false)
				end
				--关闭所有通风管道骇入
				for i, v in ipairs(self.PipeNullKeyList) do
					self:HackClose(v.Id,false)
					BehaviorFunctions.SetEntityWorldInteractState(v.Id,false)
				end
				--关闭通风管道交互组件
				for i, v in ipairs(self.pipeEcoList) do
					BehaviorFunctions.SetEntityWorldInteractState(v.Id,false)
				end
				--屏蔽所有NPC交互组件
				for i, v in ipairs(self.npcList) do
					-- self:HackClose(v.Id,false)
					BehaviorFunctions.SetEntityWorldInteractState(v.Id,false)
				end

				if self.InDoorSmallCheck == self.spaceinDoorSmall.In then			--进入战斗小区域

					if self.backDoorOpen == false then								--进入战斗区域后门关闭
						BehaviorFunctions.PlayAnimation(self.doorList[2].Id, "Closing")
						self:AddLevelDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.doorList[2].Id, "Closed")
						self.backDoorOpen = true
					end
				end

			end
		end
	end
end

--获取玩家所在区域
function LevelBehavior200502002:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if areaName == self.inDoorSpeace then
			self.roleSpaceStationA = self.spaceStation.inDoor
		end
		if areaName == self.inDoorSmall then
			self.InDoorSmallCheck = self.spaceinDoorSmall.In
		end

		if areaName == self.RoomupSpeace then
			if self.RoomupCheck == false then
				self.RoomupCheck = true
			end
		end
	end
end
--玩家退出区域
function LevelBehavior200502002:ExitArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if areaName == self.inDoorSpeace then
			self.roleSpaceStationA = self.spaceStation.outDoor
		end
	end
end

--骇入逻辑
function LevelBehavior200502002:HackingClickUp(instanceId)
	--骇入摄像头
	if instanceId == self.monitorList[4].Id then
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		BehaviorFunctions.DoHackInputKey(self.monitorList[1].Id,FightEnum.KeyEvent.HackUpButton , FightEnum.KeyInputStatus.Up)			--up
	end

	--后门门禁开锁
	if instanceId == self.doorDownKeyList[1].Id then
		if self.doorDownKeyList[1].state == self.doorDownKeyStateEnum.Close then
			-- BehaviorFunctions.ShowTip(self.doorDownKeyTips)
			BehaviorFunctions.ShowCommonTitle(10,"门禁已开",true)
			self:canDoorOpen(self.doorList[2].Id)
			--关闭门禁骇入功能
			self:HackClose(self.doorDownKeyList[1].Id,false)
			self.doorDownKeyList[1].state = self.doorDownKeyStateEnum.Open
		end
	end

	--通风管道骇入检测
	if instanceId == self.PipeNullKeyList[1].Id then
		if self.PipeNullKeyList[1].state == self.PipeNullIdEnum.Close then
			self.PipeNullKeyList[1].state = self.PipeNullIdEnum.Open
		end
	end
end

function LevelBehavior200502002:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
    -- 获取攻击实例对应的笔记本爆炸对象
    local shock = self:GetShockByInstanceId(attackInstanceId)
    if shock then
        -- 查找被击中的怪物
        for i, monster in ipairs(self.monsterList) do
            if hitInstanceId == monster.Id then
                if monster.Id ~= nil then
                    -- 设置被击中怪物的属性
                    BehaviorFunctions.SetEntityAttr(monster.Id, 1001, 0)
                    -- 设置笔记本爆炸的状态
                    BehaviorFunctions.SetEntityHackEnable(shock.Id, false)
                    BehaviorFunctions.SetEntityHackActiveState(shock.Id, false)
                    -- 更新死亡计数
                    self.deathCount = self.deathCount + 1
                    -- 将怪物ID设置为nil，表示已被击杀
                    monster.Id = nil
                end
                break -- 假设只有一个怪物会被击中，处理完毕后退出循环
            end
        end
    end
end

-- function BehaviorBase:Hit(attackInstanceId,hitInstanceId,hitType,camp, bulletInstanceId)

-- end

--剧情对话结束--关卡胜利
function LevelBehavior200502002:StoryEndEvent(dialogId)
	if dialogId == self.EndDialogId then
		-- BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		self:LevelDelete()
		BehaviorFunctions.FinishLevel(self.levelId)
	end
	if dialogId == self.HelpDialogId then
		--更新室外tips
		if self.doorOutTipsCheck == false then
			-- BehaviorFunctions.ShowTip(self.doorOutTips)
			if self.doorOutTipsId == nil then
				self.doorOutTipsId = BehaviorFunctions.AddLevelTips(self.doorOutTips,self.levelId)
			end
			-- BehaviorFunctions.ShowTip(self.doorOutHitTips)
			BehaviorFunctions.ShowCommonTitle(10,'尝试建造技能登上房顶',true)
			self.doorOutTipsCheck = true
		end
	end
end

--死亡回调
function LevelBehavior200502002:Death(instanceId,isFormationRevive)

	if isFormationRevive then
		self:LevelDelete()
		BehaviorFunctions.RemoveLevel(self.levelId)
	end

	self.AllCount = #self.monsterList		--获取怪物组长度
    for i, v in pairs(self.monsterList) do
        if instanceId == v.Id and v.state ~= self.monsterStateEnum.Dead then
            self.deathCount = self.deathCount + 1
			BehaviorFunctions.ChangeSubTipsDesc(1,self.combatTips,self.deathCount,self.AllCount)
            v.state = self.monsterStateEnum.Dead
            if self.deathCount == self.AllCount then
                --该波怪物全死
                self.monsterAllDead = true
            end
        end
    end
end

---函数---

--关闭/关闭 物体骇入功能
function LevelBehavior200502002:HackClose(EntityID,Bool)
	BehaviorFunctions.SetEntityHackEnable(EntityID,Bool)
	BehaviorFunctions.SetEntityHackActiveState(EntityID, Bool)
end

function LevelBehavior200502002:updateDistance(playerPos,role)
	if playerPos == nil then
		playerPos = BehaviorFunctions.GetPositionP(role)  -- 获取玩家的坐标
	end
	local missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)
	if missionStartPos ~= nil then
		local missionDistance = 0
		missionDistance = BehaviorFunctions.GetDistanceFromPos(playerPos, missionStartPos)  -- 计算玩家和关卡的距离
		return missionDistance
	end
end

--追踪指标
function LevelBehavior200502002:GuidePointer(guidePos,guideDistance,minDistance,guideType)
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

--创建怪物
function LevelBehavior200502002:CreateMonster(monsterList)
	for i,v in ipairs (monsterList) do
		v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.logicName, self.levelId,self.levelId)
		-- v.state = self.monsterStateEnum.Live
	end
end
--移除怪物
function LevelBehavior200502002:RemoveEntityId(entityId)
	if entityId ~= nil then
		BehaviorFunctions.RemoveEntity(entityId)
		entityId = nil
	end
end

--怪物巡逻
function LevelBehavior200502002:MonsterPatrol(monsterList)
	for i,v in ipairs (monsterList) do
		if v.Id ~= nil then
			if v.patrolList then
				local patrolPosList = {}
				for index,posName in ipairs(v.patrolList) do
					local pos = BehaviorFunctions.GetTerrainPositionP(posName,self.levelId,self.logicName)
					table.insert(patrolPosList,pos)
				end
				if v.Id ~= nil then
					BehaviorFunctions.SetEntityAttr(v.Id,self.speedAttrs,(self.speedScale))
				end
				BehaviorFunctions.SetEntityValue(v.Id,"peaceState",1) --设置为巡逻
				BehaviorFunctions.SetEntityValue(v.Id,"patrolPositionList",patrolPosList)--传入巡逻列表
				BehaviorFunctions.SetEntityValue(v.Id,"canReturn",true)--往返设置
			end
		end
	end
end

--修改后门是否可开关
function LevelBehavior200502002:canDoorOpen(DoorListId)
	if BehaviorFunctions.GetEntityValue(DoorListId,"canOpenKey") == false then
		BehaviorFunctions.SetEntityValue(DoorListId,"canOpenKey",true)
	-- else
	-- 	BehaviorFunctions.SetEntityValue(DoorListId,"canOpenKey",false)
	end
end

--开启所有大门
function LevelBehavior200502002:OpenAllDoor(DoorList)
	for i,v in ipairs (DoorList) do
		if v.Id then				--打开大门
			if v.state == self.doorStateEnum.Close then
				BehaviorFunctions.PlayAnimation(v.Id, "Opening")
				self:AddLevelDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.PlayAnimation,v.Id, "Opened")
				-- BehaviorFunctions.AddDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.PlayAnimation,v.Id, "Opened")
				v.state = self.doorStateEnum.Open
			end
		end
	end
end

--Npc站起来
function LevelBehavior200502002:NpcStand(Npclist)
	for i,v in ipairs (Npclist) do
		if v.Id then
			if v.state == self.npcEnum.Squat then
				BehaviorFunctions.PlayAnimation(v.Id,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
				v.state = self.npcEnum.Stand
			end
		end
	end
end

--还原生态通风管参数
function LevelBehavior200502002:RemoveEcoState(EcoId,State)
	if EcoId ~= nil then
		if BehaviorFunctions.GetEntityValue(EcoId,State) == nil or BehaviorFunctions.GetEntityValue(EcoId,State) == false then
			BehaviorFunctions.SetEntityValue(EcoId,State,true)
		elseif BehaviorFunctions.GetEntityValue(EcoId,State) == nil or BehaviorFunctions.GetEntityValue(EcoId,State) == true then
			BehaviorFunctions.SetEntityValue(EcoId,State,false)
		end
	end
end

--相机函数
function LevelBehavior200502002:LevelLookAtPos(pos,type,bindTransform)
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

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function LevelBehavior200502002:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function LevelBehavior200502002:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end

-- 辅助函数：根据实例ID获取对应的笔记本爆炸对象
function LevelBehavior200502002:GetShockByInstanceId(instanceId)
    for _, shock in ipairs(self.shockList) do
        if shock.Id == instanceId then
            return shock
        end
    end
    return nil -- 如果没有找到对应的笔记本爆炸对象，则返回nil
end

--卸载关卡
function LevelBehavior200502002:LevelDelete()

	self:RemoveAllLevelDelayCall()
	-- self:RemovePipeEco()
	BehaviorFunctions.SetEntityValue(self.pipeEcoList[1].Id,"canOpenKey",false)

	-- BehaviorFunctions.HideTip(self.combatTips)
	BehaviorFunctions.RemoveLevelTips(self.combatTipsId)

	--移除所有实体
	--移除怪物
	for i,v in ipairs (self.monsterList) do
		self:RemoveEntityId(v.Id)
	end
	--移除npc
	-- for i,v in ipairs (self.npcList) do
	-- 	self:RemoveEntityId(v.Id)
	-- end
	--移除摄像头
	for i,v in ipairs (self.monitorList) do
		self:RemoveEntityId(v.Id)
	end
	--移除大门实体
	-- for i,v in ipairs (self.doorList) do
	-- 	self:RemoveEntityId(v.Id)
	-- end
	--移除后门锁
	for i,v in ipairs (self.doorDownKeyList) do
		self:RemoveEntityId(v.Id)
	end
	--移除通风管道交互实体
	for i,v in ipairs (self.PipeNullKeyList) do
		self:RemoveEntityId(v.Id)
	end
    -- BehaviorFunctions.RemoveLevel(self.levelId)
	-- BehaviorFunctions.FinishLevel(self.levelId)
	-- self.missionState = 999
end