LevelBehavior102620201 = BaseClass("LevelBehavior102620201",LevelBehaviorBase)
--击败击败精英从士

function LevelBehavior102620201.GetGenerates()
	local generates = {791004001}
	return generates
end


function LevelBehavior102620201:__init(taskInfo)
	self.enemyList = {
		[1] = {bp = "enemy1", enemyId = 791004001, id = nil, lev = 0},
	}
	
	--怪物世界等级偏移
	self.monsterLevelBias = {
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}
	
	self.deathCount = 0
	self.enemyCount = 0
	self.taskState = 0
end


function LevelBehavior102620201:Update()
	if self.taskState == 0 then
		self:summonMonster()
		--BehaviorFunctions.SendTaskProgress(1025401,3,1,1)
		self.taskState = 1
	end

	if self.taskState == 1 then
		if self.deathCount == self.enemyCount then
			--LogError("击败击败精英从士".."___完成___")
			BehaviorFunctions.FinishLevel(self.levelId)
			--BehaviorFunctions.SendTaskProgress(1026202,2,1,1)
			self.taskState = 999
		end
	end
end

function LevelBehavior102620201:summonMonster()
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

function LevelBehavior102620201:Death(instanceId,isFormationRevive)
	for i,v in ipairs(self.enemyList) do
		if v.id == instanceId then
			self.deathCount = self.deathCount + 1
		end
	end
end