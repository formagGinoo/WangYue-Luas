LevelBehavior104500101 = BaseClass("LevelBehavior104500101",LevelBehaviorBase)


function LevelBehavior104500101.GetGenerates()
	local generates = {790012000,900041,900050,900051,910040}
	return generates
end

function LevelBehavior104500101:__init(fight)
	self.fight = fight
end


function LevelBehavior104500101:Init()

	self.bornPos = "born"
	self.role = nil
	self.fightList = {}  --单一波次内刷出怪物列表
	self.count = nil     --单一波次内怪物数量
	self.allCount = nil  --总怪物数量
	self.currentWave = 0 --当前波次
	self.missionState = 0
	self.lastCount = 0  --剩余怪物
	self.deathCount = 0

	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.monsterLevelBias = {     --怪物世界等级偏移
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}

	--自定义参数
	self.wave = 3 --波次
	self.tipId = 32000007  --目标计数tips
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Pos4631" ,wave = 1 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --1从士
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Pos4632" ,wave = 1 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --1从士
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Pos4633" ,wave = 1 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --1火弓
		[4] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Pos4633" ,wave = 2 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --2火从士
		[5] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Pos4633" ,wave = 2 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --2火从士
		[6] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Pos4633" ,wave = 2 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --2木弓
		[7] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Pos4633" ,wave = 3 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --3精英从士
	}

end

function LevelBehavior104500101:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		self.currentWave = 1
		self.missionState = 1
	end

		--第一次刷怪
	if self.missionState == 1 then
	    self:CreatMonster(self.currentWave)
		self.missionState = 2
		self.currentWave = 2		
	end

	if self.missionState == 2 and self.deathCount >= 3 then
	
		BehaviorFunctions.FinishLevel(104500101)
		self.missionState = 4
	end
end


function LevelBehavior104500101:CreatMonster(wave)

	for i,v in ipairs(self.monsterList) do
		--世界等级偏移计算
		local npcTag = BehaviorFunctions.GetTagByEntityId(v.entityId)
		local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
		local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
		if v.lev == 0 and monsterLevel >0 then
			v.lev = monsterLevel
		end
		if v.wave == wave and v.state == self.monsterStateEnum.Default then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,self.levelId)
			local rot = BehaviorFunctions.GetTerrainRotationP(v.bp,self.levelId)
			v.Id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,v.lev)
			BehaviorFunctions.SetEntityEuler(v.Id,rot.x,rot.y,rot.z)
			v.state = self.monsterStateEnum.Live
			table.insert(self.fightList,self.monsterList[i])
			--看向玩家
			BehaviorFunctions.DoLookAtTargetImmediately(v.Id,self.role)
			--关闭警戒
			BehaviorFunctions.SetEntityValue(v.Id,"haveWarn",false)
			--设置脱战范围
			BehaviorFunctions.SetEntityValue(v.Id,"ExitFightRange",500)
			--设置目标追踪范围
			BehaviorFunctions.SetEntityValue(v.Id,"targetMaxRange",500)
		end
	end
	self.count = #self.fightList
end


function LevelBehavior104500101:Die(attackInstanceId,dieInstanceId)

	for i,v in ipairs(self.monsterList) do
		if dieInstanceId == v.Id and v.enemyType == "monster" then
			v.state = self.monsterStateEnum.Dead
			self.deathCount = self.deathCount + 1
			local killVal = self.deathCount
			--BehaviorFunctions.ChangeSubTipsDesc(3,104060103,killVal,self.enemyCount)  --修改tips
		end
		--if dieInstanceId == v.Id and v.enemyType == "boss" then
			--for i,v in ipairs(self.enemyList) do
				--if v.enemyType == "monster" and v.state ~= self.monsterStateEnum.Dead then
					--BehaviorFunctions.SetEntityAttr(v.Id,1001,0,1)  --这里修改的什么实体没有弄清楚
				--end
			--end
			--self.missionSuccess = true
			--self.missionFinished = true
		--end
	end
end

function LevelBehavior104500101:__delete()

end


