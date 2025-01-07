LevelBehavior102650102 = BaseClass("LevelBehavior102650102",LevelBehaviorBase)
--潜入测试关卡

function LevelBehavior102650102.GetGenerates()
	local generates = {
		2010104,
		809200101,
		2030509,
		790012000,
		2020704,
		2030802,
		}
	return generates
end


function LevelBehavior102650102:Init()
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
end

function LevelBehavior102650102:__init(taskInfo)
	
	--敌人列表
	self.enemyList = {
		[1] = {bp = "enemy1", enemyId = 790012000, id = nil, patrolList = nil, lev = 0},
		[2] = {bp = "enemy2", enemyId = 790012000, id = nil, patrolList = nil, lev = 0},
		[3] = {bp = "enemy3", enemyId = 790012000, id = nil, patrolList = {"e3P1","e3P2"}, lev = 0},
		[4] = {bp = "enemy4", enemyId = 790012000, id = nil, patrolList = {"e4P1","e4P2"}, lev = 0},
		[5] = {bp = "enemy5", enemyId = 790012000, id = nil, patrolList = {"e5P1","e5P2"}, lev = 0},
		[6] = {bp = "enemy6", enemyId = 790012000, id = nil, patrolList = nil, lev = 0},
		[7] = {bp = "enemy7", enemyId = 790012000, id = nil, patrolList = {"e7P2","e7P1"}, lev = 0},
		--[8] = {bp = "enemy8", enemyId = 790012000, id = nil, patrolList = nil, lev = 0},
		[8] = {bp = "paoTa1", enemyId = 2030509, id = nil, patrolList = nil, lev = 0},
		[9] = {bp = "paoTa2", enemyId = 2030509, id = nil, patrolList = nil, lev = 0},
	}
	
	--物体列表
	self.itemList = {
		[1] = {bp = "HuaiPaoTa", itemId = 2030509, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		[2] = {bp = "rongYe", itemId = 200000101, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		[3] = {bp = "box1", itemId = 2010104, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		[4] = {bp = "box2", itemId = 2010104, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		[5] = {bp = "LiGe", itemId = 809200101, id = nil, itemType = "human", hasButton = false, buttonId = nil},
		[6] = {bp = "HuaiPaoTa", itemId = 200000101, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		[7] = {bp = "rongYe", itemId = 200000101, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		[8] = {bp = "evidence3", itemId = 200000101, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		[9] = {bp = "fireEqui1", itemId = 2030802, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		[10] = {bp = "fireEqui2", itemId = 2030802, id = nil, itemType = "item", hasButton = false, buttonId = nil},
		}
	
	--怪物世界等级偏移
	self.monsterLevelBias = {
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}
	
	
	self.storyList = {
		[1] = {dialogId = 102400201, used = false, canRepeat = false, name = "进入潜行房间"},
		[2] = {dialogId = 102400301, used = false, canRepeat = false, name = "大楼内遇见离歌对话"},
		[3] = {dialogId = 102401201, used = false, canRepeat = true, name = "再和离歌说话"},
		[4] = {dialogId = 102400501, used = false, canRepeat = true, name = "室内搜索旁白1"},
		[5] = {dialogId = 102400401, used = false, canRepeat = true, name = "室内搜索旁白2"},
		[6] = {dialogId = 102400601, used = false, canRepeat = true, name = "室内搜索旁白3"},
		[7] = {dialogId = 102400701, used = false, canRepeat = false, name = "开门怪物出现timeline"},
		}
	
	
	self.checkPointList = {
		[1] = {id = nil,areaName = "SpawnArea1", spawnPointName = "spawn1", used = false},
		[2] = {id = nil,areaName = "SpawnArea2", spawnPointName = "spawn2", used = false},
		[3] = {id = nil,areaName = "SpawnArea3", spawnPointName = "spawn3", used = false},
		[4] = {id = nil,areaName = "SpawnArea4", spawnPointName = "spawn4", used = false},
		[5] = {id = nil,areaName = "SpawnArea5", spawnPointName = "spawn5", used = false},
		[6] = {id = nil,areaName = "SpawnArea6", spawnPointName = "spawn6", used = false},
		}
	
	
	self.traceAreaList =
	{
		[1] = {AreaName = "guideArea2" , inArea = false ,pos = "guidePoint2" , trace = false },
		[2] = {AreaName = "guideArea3" , inArea = false ,pos = "guidePoint3" , trace = false },
		[3] = {AreaName = "guideArea4" , inArea = false ,pos = "guidePoint4" , trace = false },
		[4] = {AreaName = "guideArea5" , inArea = false ,pos = "guidePoint5" , trace = false },
		[5] = {AreaName = "guideArea6" , inArea = false ,pos = "guidePoint6" , trace = false },
		[6] = {AreaName = "guideArea7" , inArea = false ,pos = "guidePoint7" , trace = false },
		[7] = {AreaName = "guideArea8" , inArea = false ,pos = "guidePoint8" , trace = false },
		[8] = {AreaName = "guideArea9" , inArea = false ,pos = "guidePoint9" , trace = false },
		[9] = {AreaName = "guideArea10" , inArea = false ,pos = "guidePoint10" , trace = false },
		[10] = {AreaName = "guideArea11" , inArea = false ,pos = "guidePoint11" , trace = false },
		[11] = {AreaName = "guideArea12" , inArea = false ,pos = "guidePoint13" , trace = false },
		[12] = {AreaName = "guideArea1" , inArea = false ,pos = "guidePoint1" , trace = false },
	}
	self.currentTrace = nil
	
	----关卡参数----
	self.deathCount = 0
	self.enemyCount = 0
	self.taskState = 0
	self.spawnPoint = 0
	
	self.isReset = false
	
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	
	--按钮
	self.hasButton = false
	self.lookAtTarget = nil
end


function LevelBehavior102650102:Update()
	
	self.LevelCommon:Update() --执行关卡通用行为树的每帧运行
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.taskState == 0 then
		BehaviorFunctions.ShowTip(102650101)
		BehaviorFunctions.SetClimbEnable(false)
		local playerBornPos = BehaviorFunctions.GetTerrainPositionP("playerBorn",self.levelId)
		local position = BehaviorFunctions.GetTerrainPositionP("guidePoint1",self.levelId)
		BehaviorFunctions.SetTaskGuidePosition(self.taskId, position, nil, 0, false)
		--相机位置回到背后
		BehaviorFunctions.CameraPosReduction(0)
		self.spawnPoint = playerBornPos
		self:summonMonster()
		self:summonItem()
		self.taskState = 1
		
	end
	
	
	if self.taskState == 1 then
		if self.isReset == false then
			local inFight = BehaviorFunctions.CheckPlayerInFight()
			if inFight == true and self.isReset ~= true then
				BehaviorFunctions.ShowTip(102650102)
				self:ResetBattle()
			end
		end
	end
	
	
	if self.taskState == 3 then
		BehaviorFunctions.HideTip(102650101)
		BehaviorFunctions.SetClimbEnable(true)
		BehaviorFunctions.SetDuplicateResult(true)
		BehaviorFunctions.ExitDuplicate()
		self.taskState = 999
	end
end

--创建敌人 等级偏移
function LevelBehavior102650102:summonMonster()
	for i,v in ipairs(self.enemyList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp, self.levelId)
		local rot = BehaviorFunctions.GetTerrainRotationP(v.bp, self.levelId)
		
		local npcTag = BehaviorFunctions.GetTagByEntityId(v.enemyId)
		local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
		local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
		if v.lev == 0 and monsterLevel > 0 then
			v.lev = monsterLevel
		end
		
		if pos and rot then
			v.id = BehaviorFunctions.CreateEntity(v.enemyId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId,monsterLevel)
			BehaviorFunctions.SetEntityEuler(v.id, rot.x, rot.y, rot.z)
		end
		
		if v.patrolList then
			local patrolPosList = {}
			for x,y in ipairs(v.patrolList) do
				local pos = BehaviorFunctions.GetTerrainPositionP(y,self.levelId)
				table.insert(patrolPosList,pos)
			end
			
			BehaviorFunctions.SetEntityValue(v.id,"peaceState",1) --设置为巡逻
			BehaviorFunctions.SetEntityValue(v.id,"patrolPositionList",patrolPosList)--传入巡逻列表
			BehaviorFunctions.SetEntityValue(v.id,"canReturn",true)--往返设置
			
		end
	end
end

--创造物体
function LevelBehavior102650102:summonItem()
	for i,v in ipairs(self.itemList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp, self.levelId)
		local rot = BehaviorFunctions.GetTerrainRotationP(v.bp, self.levelId)
		
		if pos and rot then
			v.id = BehaviorFunctions.CreateEntity(v.itemId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId)
			BehaviorFunctions.SetEntityEuler(v.id, rot.x, rot.y, rot.z)
		end
		
		--坏掉的炮塔
		if i == 1 then
			BehaviorFunctions.RemoveBehavior(v.id)
			BehaviorFunctions.SetEntityLifeBarVisibleType(v.id,3)
		end
		
	end
end

--区域判定
function LevelBehavior102650102:EnterArea(triggerInstanceId, areaName, logicName)
	if areaName == "endArea" and triggerInstanceId == self.role then
		self:playStoryDialogList(7)
	end
	
	for i,v in ipairs(self.traceAreaList) do
		if areaName == v.AreaName and v.trace == false and self.currentTrace ~= i and triggerInstanceId == self.role then
			local position = BehaviorFunctions.GetTerrainPositionP(v.pos,self.levelId)
			BehaviorFunctions.SetTaskGuidePosition(self.taskId, position, nil, 0, false)
			self.currentTrace = i
			v.trace = true
		elseif areaName == v.AreaName and v.trace == true and self.currentTrace ~= i and triggerInstanceId == self.role then
			local position = BehaviorFunctions.GetTerrainPositionP(v.pos,self.levelId)
			BehaviorFunctions.SetTaskGuidePosition(self.taskId, position, nil, 0, false)
			self.currentTrace = i
			v.trace = false
		end
	end
	
	
	for i,v in ipairs(self.checkPointList) do
		if triggerInstanceId == self.role then
			if areaName == v.areaName and self.taskState == 1 then
				self.spawnPoint = BehaviorFunctions.GetTerrainPositionP(v.spawnPointName,self.levelId)
				BehaviorFunctions.UpdateDuplicateRevivePos(self.spawnPoint)
				--v.used = true
				
				if areaName == "SpawnArea1" and triggerInstanceId == self.role then
					self:playStoryDialogList(1)
				end
			end
		end
	end
end

--重置战斗
function LevelBehavior102650102:ResetBattle()
	
	self.isReset = true
	
	self.LevelCommon:LevelCameraLookAtInstance(22002,60,nil,self.lookAtTarget,"HitCase",0)
	--BehaviorFunctions.ShowBlackCurtain(true,2)
	BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,true,2)
	BehaviorFunctions.AddDelayCallByTime(4,BehaviorFunctions,BehaviorFunctions.InMapTransport,self.spawnPoint.x,self.spawnPoint.y,self.spawnPoint.z)
	BehaviorFunctions.AddDelayCallByTime(6.8,self,self.RemoveMonster)
	BehaviorFunctions.AddDelayCallByTime(7,self,self.summonMonster)
	BehaviorFunctions.AddDelayCallByFrame(210,self,self.Assignment,"isReset",false)
	BehaviorFunctions.AddDelayCallByFrame(210,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.8)
	--BehaviorFunctions.ShowBlackCurtain(false,0.8)
	--BehaviorFunctions.InMapTransport(self.spawnPoint.x,self.spawnPoint.y,self.spawnPoint.z)
end


function LevelBehavior102650102:OnEnemyFirstInFight(instanceId)
	for i,v in ipairs(self.enemyList) do
		if v.id == instanceId then
			self.lookAtTarget = v.id
		end
	end
end

--移除怪物
function LevelBehavior102650102:RemoveMonster()
	
	for i,v in ipairs(self.enemyList) do
		if v.id ~= nil then
			BehaviorFunctions.RemoveEntity(v.id)
		end
	end
	
	BehaviorFunctions.LeaveFighting()
end


--赋值
function LevelBehavior102650102:Assignment(variable,value)
	self[variable] = value
end


function LevelBehavior102650102:__delete()
	
end


function LevelBehavior102650102:Remove()
	BehaviorFunctions.SetClimbEnable(true)
end


--trigger判定对话
function LevelBehavior102650102:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.itemList) do 
		--离歌
		if v.id == triggerInstanceId and v.hasButton == false and roleInstanceId == self.role and i == 5 then
			v.buttonId = BehaviorFunctions.WorldInteractActive(self.role,1,nil,"对话",1)
			v.hasButton = true
		end
		
		--炮塔1
		if v.id == triggerInstanceId and v.hasButton == false and roleInstanceId == self.role and i == 6 then
			v.buttonId = BehaviorFunctions.WorldInteractActive(self.role,1,nil,"检查",1)
			v.hasButton = true
		end
		
		--溶液
		if v.id == triggerInstanceId and v.hasButton == false and roleInstanceId == self.role and i == 7 then
			v.buttonId = BehaviorFunctions.WorldInteractActive(self.role,1,nil,"检查",1)
			v.hasButton = true
		end
		
		--第三检查物
		if v.id == triggerInstanceId and v.hasButton == false and roleInstanceId == self.role and i == 8 then
			v.buttonId = BehaviorFunctions.WorldInteractActive(self.role,1,nil,"检查",1)
			v.hasButton = true
		end
	end	
end


function LevelBehavior102650102:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.itemList) do
		--离歌
		if v.id == triggerInstanceId and v.hasButton == true and roleInstanceId == self.role and i == 5 then
			BehaviorFunctions.WorldInteractRemove(self.role,v.buttonId)
			v.hasButton = false
			v.buttonId = nil
		end
		--炮塔1
		if v.id == triggerInstanceId and v.hasButton == true and roleInstanceId == self.role and i == 6 then
			BehaviorFunctions.WorldInteractRemove(self.role,v.buttonId)
			v.hasButton = false
			v.buttonId = nil
		end
		--溶液
		if v.id == triggerInstanceId and v.hasButton == true and roleInstanceId == self.role and i == 7 then
			BehaviorFunctions.WorldInteractRemove(self.role,v.buttonId)
			v.hasButton = false
			v.buttonId = nil
		end
		--第三检查物
		if v.id == triggerInstanceId and v.hasButton == true and roleInstanceId == self.role and i == 8 then
			BehaviorFunctions.WorldInteractRemove(self.role,v.buttonId)
			v.hasButton = false
			v.buttonId = nil
		end
	end
end


function LevelBehavior102650102:WorldInteractClick(uniqueId,instanceId)
	for i,v in ipairs(self.itemList) do
		for x,y in ipairs(self.storyList) do
			--离歌对话
			if uniqueId == v.buttonId and i == 5 and x == 2 then
				self:playStoryDialogList(2)
				BehaviorFunctions.WorldInteractRemove(self.role,v.buttonId)
				v.hasButton = false
				y.dialogId = 102401201
				y.canRepeat = true
				v.buttonId = nil
			end
			
			--证据1
			if uniqueId == v.buttonId and i == 6 and x == 4 then
				self:playStoryDialogList(4)
				BehaviorFunctions.WorldInteractRemove(self.role,v.buttonId)
				v.hasButton = false
				v.buttonId = nil
			end
			
			--证据2
			if uniqueId == v.buttonId and i == 7 and x == 5 then
				self:playStoryDialogList(5)
				BehaviorFunctions.WorldInteractRemove(self.role,v.buttonId)
				v.hasButton = false
				v.buttonId = nil
			end
			
			--证据3
			if uniqueId == v.buttonId and i == 8 and x == 6 then
				self:playStoryDialogList(6)
				BehaviorFunctions.WorldInteractRemove(self.role,v.buttonId)
				v.hasButton = false
				v.buttonId = nil
			end
		end
	end
end

--播放对话
function LevelBehavior102650102:playStoryDialogList(index)
	for i,v in ipairs(self.storyList) do
		if i == index and v.used == false then
			BehaviorFunctions.StartStoryDialog(v.dialogId)
			v.used = true
		end
		if i == index and v.used == true and v.canRepeat == true then
			BehaviorFunctions.StartStoryDialog(v.dialogId)
		end
	end
end

--判定对话是否可以重复播放
function LevelBehavior102650102:StoryEndEvent(dialogId)
	for i,v in ipairs(self.storyList) do
		if v.dialogId == dialogId then
			v.used = true
		end
	end	
	
	--timeline结束任务结束
	if dialogId == 102400701 then
		self.taskState = 3
	end
	
end


--function LevelBehavior102650102:AddGuidePointer(guideList,position,index)
	--local pos = BehaviorFunctions.GetTerrainPositionP(position)
	--for i,v in ipairs(guideList) do
		--if i == index and v.id == nil then
			--v.id = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z)
			--BehaviorFunctions.AddEntityGuidePointer(v.id,4,1,false,5)
		--end

		----移除其他图标
		--if i ~= index and v.id ~= nil then
			--v.id = nil
		--end
	--end
--end


--function LevelBehavior102650102:UnloadGuidePointer()
	--for i,v in ipairs(self.checkPointList) do
		--if v.id ~= nil then
			--BehaviorFunctions.RemoveEntity(v.id)
			--v.id = nil
		--end
	--end
--end