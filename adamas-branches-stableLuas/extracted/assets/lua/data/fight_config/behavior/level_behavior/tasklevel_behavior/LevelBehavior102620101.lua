LevelBehavior102620101 = BaseClass("LevelBehavior102620101",LevelBehaviorBase)
--石龙触发

function LevelBehavior102620101.GetGenerates()
	local generates = {791002500}
	return generates
end


function LevelBehavior102620101:__init(taskInfo)
	self.enemyList = {
		[1] = {bp = "enemy1", enemyId = 791002500, id = nil, lev = 0},
	}
	
	--怪物世界等级偏移
	self.monsterLevelBias = {
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}
	
	self.shiLongDialogId = 102392901
	self.deathCount = 0
	self.enemyCount = 0
	self.taskState = 0
	
	self.triggered = false
	self.role = nil
end


function LevelBehavior102620101:Update()
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.taskState == 0 then
		
		self:summonMonster()
		self.taskState = 1
	end
	
	if self.taskState == 2 then
		BehaviorFunctions.StartStoryDialog(self.shiLongDialogId)
	end
	
	if self.taskState == 4 then
		BehaviorFunctions.FinishLevel(self.levelId)
		self.taskState = 999
	end
end


function LevelBehavior102620101:summonMonster()
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
			
			BehaviorFunctions.RemoveBehavior(v.id)
			
			self.enemyCount = self.enemyCount + 1
		end
		
		BehaviorFunctions.PlayAnimation(v.id,"Attack052")
		
	end
end


function LevelBehavior102620101:Death(instanceId,isFormationRevive)
	for i,v in ipairs(self.enemyList) do
		if v.id == instanceId then
			self.deathCount = self.deathCount + 1
		end
	end
end


function LevelBehavior102620101:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role and areaName == "shiLongArea1" then
		self.taskState = 2
	end
end


function LevelBehavior102620101:StoryEndEvent(dialogId)
	if dialogId == self.shiLongDialogId then
		self.taskState = 3
	end
end


function LevelBehavior102620101:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	for i,v in ipairs(self.enemyList) do
		if hitInstanceId == v.id then
			self.taskState = 4
		end
	end
end