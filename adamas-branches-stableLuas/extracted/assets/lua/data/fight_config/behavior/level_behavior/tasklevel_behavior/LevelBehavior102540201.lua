LevelBehavior102540201 = BaseClass("LevelBehavior102540201",LevelBehaviorBase)
--拍照点1混混战斗

function LevelBehavior102540201.GetGenerates()
	local generates = {900140,790014000}
	return generates
end


function LevelBehavior102540201:__init(taskInfo)
	self.enemyList = {
		[1] = {bp = "enemy1", enemyId = 790014000, id = nil, lev = 0},
		[2] = {bp = "enemy2", enemyId = 790014000, id = nil, lev = 0},
		[3] = {bp = "enemy3", enemyId = 790014000, id = nil, lev = 0},
		}
	
	--怪物状态判断
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}

	--怪物世界等级偏移
	self.monsterLevelBias = {
		[FightEnum.EntityNpcTag.Monster] = -1,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}
	
	self.deathCount = 0
	self.enemyCount = 0
	self.taskState = 0
end


function LevelBehavior102540201:Update()
	if self.taskState == 0 then
		self:summonMonster()
		self:SetCombatTarget(self.enemyList)
		--BehaviorFunctions.SendTaskProgress(1025401,3,1,1)
		self.taskState = 1
	end
	
	if self.taskState == 1 then
		if self.deathCount == self.enemyCount then
			--LogError("拍照点1混混战斗".."___完成___")
			BehaviorFunctions.FinishLevel(self.levelId)
			--BehaviorFunctions.SendTaskProgress(1025401,3,1,1)
			self.taskState = 999
		end
	end
end

function LevelBehavior102540201:summonMonster()
	for i,v in ipairs(self.enemyList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp, self.levelId)
		local rot = BehaviorFunctions.GetTerrainRotationP(v.bp, self.levelId)
		
		local npcTag = BehaviorFunctions.GetTagByEntityId(v.enemyId)
		local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
		local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
		if v.lev == 0 and monsterLevel >0 then
			v.lev = monsterLevel
		end
		
		
		if pos and rot then
			v.id = BehaviorFunctions.CreateEntity(v.enemyId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId,monsterLevel)
			BehaviorFunctions.SetEntityEuler(v.id, rot.x, rot.y, rot.z)
			
			self.enemyCount = self.enemyCount + 1
		end
	end
end

--设置怪物战斗目标
function LevelBehavior102540201:SetCombatTarget(List)
	if List then
		for i,v in ipairs(List) do
			BehaviorFunctions.SetEntityValue(v.id,"haveWarn",false)
			BehaviorFunctions.SetEntityValue(v.id,"battleTarget",self.role)
			BehaviorFunctions.SetEntityValue(v.id,"targetMaxRange",500)
		end
	end
end


function LevelBehavior102540201:Death(instanceId,isFormationRevive)
	for i,v in ipairs(self.enemyList) do
		if v.id == instanceId then
			self.deathCount = self.deathCount + 1
		end
	end
end


function LevelBehavior102540201:EnterArea(triggerInstanceId, areaName, logicName)
	for i,v in ipairs(self.enemyList) do 
		if triggerInstanceId == v.id and areaName == "enemyArea" then
			BehaviorFunctions.SetEntityValue(v.id,1001,0,1)
		end
	end
end