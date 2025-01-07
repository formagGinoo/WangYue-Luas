LevelBehavior5010601 = BaseClass("LevelBehavior5010601",LevelBehaviorBase)

function LevelBehavior5010601.GetGenerates()
	local generates = {900140,900040}
	return generates
end

function LevelBehavior5010601:__init(fight)
	self.fight = fight
end

function LevelBehavior5010601:Init()

	-------------------基础参数----------------------
	self.missionState = 0
	self.monsterListInfo = {}

	-------------------刷怪列表----------------------
	self.monsterList =
	{
		{id = 900040 ,posName = "Mon0201" ,wave = 1},
		{id = 900040 ,posName = "Mon0202" ,wave = 1},
		{id = 900040 ,posName = "Mon0203" ,wave = 1},
		--{id = 900140 ,posName = "Mon0104" ,wave = 1},
	}

	-------------------通用关卡函数引用----------------------
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId

	--怪物世界等级偏移
	self.LevelCommon.monsterLevelBias =
	{
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}

	self.camera = false
end

function LevelBehavior5010601:Update()
	self.LevelCommon:Update()

	if self.missionState == 0 then
		--设置为普通关卡
		self.LevelCommon:SetAsTaskLevel("击败所有怪物")

		--开启关卡
		self.LevelCommon:LevelStart()
		--创建怪物
		self.monsterListInfo = self.LevelCommon:LevelCreateMonster(self.monsterList)
		--开启剩余敌人数量显示
		self.LevelCommon:ShowEnemyRemainTips(true)
		--开启敌人波数显示
		self.LevelCommon:ShowWaveTips(true)
		self.missionState = 1

	elseif self.missionState == 1 then

	
		--if self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo) then
			
			--BehaviorFunctions.FinishLevel(5010601)	
			
		--end
	
		--胜利条件：该怪物组内怪物都死亡
		local result1 = self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo)
		if result1 then
			LogError("1111")
		end
		
		--将上述条件作为胜利条件
		self.LevelCommon:LevelSuccessCondition(result1)		
	end
end

