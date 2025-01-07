LevelBehavior3011201 = BaseClass("LevelBehavior3011201",LevelBehaviorBase)

function LevelBehavior3011201.GetGenerates()
	local generates = {900140,900070}
	return generates
end

function LevelBehavior3011201:__init(fight)
	self.fight = fight
end

function LevelBehavior3011201:Init()

	-------------------基础参数----------------------
	self.missionState = 0
	self.monsterListInfo = {}

	-------------------刷怪列表----------------------
	self.monsterList =
	{
		{id = 900070 ,posName = "Mon0401" ,wave = 1,engage = false,patrolList = nil},
		{id = 900140 ,posName = "Mon0402" ,wave = 1,engage = false,patrolList = {"T42","T43"}},
		{id = 900140 ,posName = "Mon0403" ,wave = 1,engage = false,patrolList = nil},
		{id = 900070 ,posName = "Mon0404" ,wave = 2,patrolList = nil},
		{id = 900070 ,posName = "Mon0405" ,wave = 2,patrolList = nil},	
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
	self.eco = 2003001110011
	self.UI = false
	self.CompanyFight = false
end

function LevelBehavior3011201:Update()
	self.LevelCommon:Update()
	self.inFight = BehaviorFunctions.CheckPlayerInFight()
	if self.CompanyFight == true then
		self.LevelCommon:CompanyFight(20)
	end
	
	if self.missionState == 0 then
		--设置为普通关卡
		self.LevelCommon:SetAsTaskLevel("击败所有怪物")

		--开启关卡
		self.LevelCommon:LevelStart()
		--创建怪物
		self.monsterListInfo = self.LevelCommon:LevelCreateMonster(self.monsterList)

		BehaviorFunctions.ChangeEcoEntityCreateState(self.eco,true)
		for i,v in ipairs(self.monsterListInfo.list) do
			if v.patrolList then
				local patrolPosList = {}
				for index,posName in ipairs(v.patrolList) do
					local pos = BehaviorFunctions.GetTerrainPositionP(posName,self.levelId)
					table.insert(patrolPosList,pos)
				end
				BehaviorFunctions.SetEntityValue(v.instanceId,"peaceState",1) --设置为巡逻
				BehaviorFunctions.SetEntityValue(v.instanceId,"patrolPositionList",patrolPosList)--传入巡逻列表
				BehaviorFunctions.SetEntityValue(v.instanceId,"canReturn",true)--往返设置
			end
		end
		self.CompanyFight = true
		self.missionState = 1

	elseif self.missionState == 1 then

	
		--if self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo) then
			
			--BehaviorFunctions.FinishLevel(3011201)	
			
		--end
		
		if self.inFight == true and self.UI == false then
			--开启剩余敌人数量显示
			self.LevelCommon:ShowEnemyRemainTips(true)
			--开启敌人波数显示
			self.LevelCommon:ShowWaveTips(true)
			self.UI = true
				
		end
		
		--胜利条件：该怪物组内怪物都死亡
		local result1 = self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo)
		if result1 then
			LogError("1111")
		end
		
		--将上述条件作为胜利条件
		self.LevelCommon:LevelSuccessCondition(result1)		
	end
end

