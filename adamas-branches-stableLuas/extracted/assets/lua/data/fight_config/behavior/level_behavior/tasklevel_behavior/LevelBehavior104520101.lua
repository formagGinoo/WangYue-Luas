LevelBehavior104520101 = BaseClass("LevelBehavior104520101",LevelBehaviorBase)


function LevelBehavior104520101.GetGenerates()
	local generates = {790012000,790013000,900050}
	return generates
end

function LevelBehavior104520101:__init(fight)
	self.fight = fight
end


function LevelBehavior104520101:Init()

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

	--自定义参数
	self.wave = 1 --波次
	self.tipId = 32000007  --目标计数tips
	self.monsterLevelBias = {     --怪物世界等级偏移
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}	
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mon01" ,wave = 1 ,lev = 0 ,enemyType = "monster",entityId = 790013000},  --弓从士
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mon03" ,wave = 1 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --1盾牌
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mon04" ,wave = 1 ,lev = 0 ,enemyType = "monster",entityId = 790012000},  --1盾牌
	}

end

function LevelBehavior104520101:Update()
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

	if self.missionState == 2 and self.deathCount > 2 then

		BehaviorFunctions.FinishLevel(104520101)
		self.missionState = 3
	end
	
	
end


function LevelBehavior104520101:CreatMonster(wave)

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


function LevelBehavior104520101:Die(attackInstanceId,dieInstanceId)

	for i,v in ipairs(self.monsterList) do
		if dieInstanceId == v.Id and v.enemyType == "monster" then
			v.state = self.monsterStateEnum.Dead
			self.deathCount = self.deathCount + 1
			local killVal = self.deathCount
			--BehaviorFunctions.ChangeSubTipsDesc(3,104060103,killVal,self.enemyCount)  --修改tips
		end
	end
end

function LevelBehavior104520101:__delete()

end


