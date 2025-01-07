
LevelBehavior104040112 = BaseClass("LevelBehavior104040112",LevelBehaviorBase)
--第四章通用关卡逻辑

function LevelBehavior104040112:__init(fight)
	self.fight = fight
end

function LevelBehavior104040112.GetGenerates()
	local generates = 
	{
		900080,   --木箴石之劣
		2030207,  --荆棘
	}
	return generates
end

function LevelBehavior104040112:Init()

	self.missionState = 0

	self.role = nil

	--怪物状态
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}

	--怪物列表
	self.monsterList1 =
	{
		[1] = {state = self.monsterStateEnum.Default, bornPos = "Monster01", entityId = 900080, id = nil, lev = 0},
		[2] = {state = self.monsterStateEnum.Default, bornPos = "Monster02", entityId = 900080, id = nil, lev = 0},
	}
	self.monsterList2 =
	{
		[1] = {state = self.monsterStateEnum.Default, bornPos = "Monster04", entityId = 900080, id = nil, lev = 0},
		[2] = {state = self.monsterStateEnum.Default, bornPos = "Monster05", entityId = 900080, id = nil, lev = 0},
		[3] = {state = self.monsterStateEnum.Default, bornPos = "Monster06", entityId = 900080, id = nil, lev = 0},
	}
	--实体列表
	self.entityList1 =
	{
		[1] = {bornPos = "tengman1", entityId = 2030207, id = nil},
		[2] = {bornPos = "tengman2", entityId = 2030207, id = nil},
		[3] = {bornPos = "tengman3", entityId = 2030207, id = nil},
		[4] = {bornPos = "tengman4", entityId = 2030207, id = nil},
		[5] = {bornPos = "tengman5", entityId = 2030207, id = nil},
		[6] = {bornPos = "tengman6", entityId = 2030207, id = nil},
		[7] = {bornPos = "tengman7", entityId = 2030207, id = nil},
		[8] = {bornPos = "tengman8", entityId = 2030207, id = nil},
		[9] = {bornPos = "tengman9", entityId = 2030207, id = nil},
		[10] = {bornPos = "tengman10", entityId = 2030207, id = nil},
		[11] = {bornPos = "tengman11", entityId = 2030207, id = nil},
		[12] = {bornPos = "tengman12", entityId = 2030207, id = nil},
	}
	
	--荆棘数量
	self.thornNum = 0
	
	--怪物世界等级偏移
	self.monsterLevelBias = {
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}
	
	--设置玩家位置
	self.transPos = "rolePos"
	
	--设置玩家看向位置
	self.lookAtPos = mil
	
end

function LevelBehavior104040112:Update()
	--角色为当前玩家操作角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--创怪
	if self.missionState == 0 then
		
		--设置玩家位置
		if self.transPos then
			local rolePos = nil
			if self.logicName then
				rolePos = BehaviorFunctions.GetTerrainPositionP(self.transPos, self.mapId, self.logicName)
			else
				rolePos = BehaviorFunctions.GetTerrainPositionP(self.transPos, self.levelId)
			end
			BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
		end
		
		BehaviorFunctions.StartStoryDialog(104040801)
		BehaviorFunctions.ShowTip(100000001,"消灭区域内所有噬脉生物和荆棘")
		self:CreateMonster(self.monsterList1)
		self:SetLevelCamera("Monster01")
		self:SetCombatTarget(self.monsterList1)
		self:CreateEntityId(self.entityList1)
		self.missionState = 1
		
	end

    --第一波怪死完 刷第二波	
	if self.missionState == 2 then
		self:CreateMonster(self.monsterList2)
		self:SetLevelCamera("Monster04")
		self:SetCombatTarget(self.monsterList2)
		self.missionState = 3
	end
	
	--关卡成功判断 第二波怪死完+荆棘全部移除
	for k,v in ipairs(self.monsterList2) do
		if v.state == self.monsterStateEnum.Dead then
			if self.thornNum == 0 then
				--关卡完成提示提示
				BehaviorFunctions.StartStoryDialog(104041001)
				--调用关卡完成函数
				BehaviorFunctions.FinishLevel(self.levelId)
				BehaviorFunctions.HideTip()
				self.missionState = 10
			end
		end
	end
end


--------------------函数------------------------
--创怪
function LevelBehavior104040112:CreateMonster(monsterList)
	for k,v in ipairs(monsterList) do 
		local npcTag = BehaviorFunctions.GetTagByEntityId(v.entityId)
		local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
		local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
		if v.lev == 0 and monsterLevel > 0 then
			v.lev = monsterLevel
		end
		local pos1 = BehaviorFunctions.GetTerrainPositionP(monsterList[k].bornPos, self.levelId)
		v.id = BehaviorFunctions.CreateEntity(monsterList[k].entityId, nil, pos1.x, pos1.y, pos1.z, nil, nil, nil, self.levelId, monsterLevel)
		BehaviorFunctions.DoLookAtTargetImmediately(monsterList[k].id,self.role)
		--创建后修改状态
		v.state = self.monsterStateEnum.Live
	end
end

--修改怪物攻击目标以及怪物战斗状态
function LevelBehavior104040112:SetCombatTarget(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			BehaviorFunctions.SetEntityValue(v.id, "haveWarn", false)
			BehaviorFunctions.SetEntityValue(v.id, "battleTarget", self.role)
			BehaviorFunctions.SetEntityValue(v.id, "targetMaxRange", 50)
		end
	end
end

--创建荆棘
function LevelBehavior104040112:CreateEntityId(entityList)
	for k,v in ipairs(entityList) do
		local pos1 = BehaviorFunctions.GetTerrainPositionP(entityList[k].bornPos, self.levelId)
		entityList[k].id = BehaviorFunctions.CreateEntityByPosition(entityList[k].entityId, nil, entityList[k].bornPos, nil, self.levelId, self.levelId)
		--创建后修改状态
		self.thornNum = self.thornNum + 1
	end
end

--设置关卡相机函数
function LevelBehavior104040112:SetLevelCamera(lookAtPos)
	local pos = BehaviorFunctions.GetTerrainPositionP(lookAtPos, self.levelId)
	self.empty = BehaviorFunctions.CreateEntity(2001, nil, pos.x, pos.y + 1, pos.z)
	self.levelCam = BehaviorFunctions.CreateEntity(22001)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
	--看向目标
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end


--死亡事件
function LevelBehavior104040112:Death(instanceId,isFormationRevive)
	--if isFormationRevive then
		--self.missionState = 11
	--end

	--怪物死亡修改状态
	for k,v in ipairs(self.monsterList1) do
		if instanceId == v.id then
			v.state = self.monsterStateEnum.Dead
		end
	end
	
	for k,v in ipairs(self.monsterList2) do
		if instanceId == v.id then
			v.state = self.monsterStateEnum.Dead
		end
	end

	--第一波怪物死完进入第二波
	if self.missionState == 1 then
		local monsterList = self.monsterList1
		local listLenth = #monsterList
		for k,v in ipairs (monsterList) do
			if v.state ~= self.monsterStateEnum.Dead then
				return
			else
				if k == listLenth then
					self.missionState = 2
				end
			end
		end
	end
	
	if self.missionState == 3 then
		local monsterList = self.monsterList2
		local listLenth = #monsterList
		for k,v in ipairs (monsterList) do
			if v.state ~= self.monsterStateEnum.Dead then
				return
			else
				if k == listLenth then
					BehaviorFunctions.ChangeTitleTipsDesc(100000001,"消灭区域内剩余的荆棘")
					self.missionState = 4
				end
			end
		end
	end
end

--荆棘移除判断
function LevelBehavior104040112:RemoveEntity(instanceId)
	for k,v in ipairs(self.entityList1) do
		if instanceId == v.id then
			self.thornNum = self.thornNum - 1
		end
	end
	
	if self.thornNum == 0 then
		BehaviorFunctions.ChangeTitleTipsDesc(100000001,"消灭区域内剩余的噬脉生物")
	end
end
