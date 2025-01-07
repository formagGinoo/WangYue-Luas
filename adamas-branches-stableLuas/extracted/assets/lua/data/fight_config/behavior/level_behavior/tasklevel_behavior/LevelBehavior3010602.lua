LevelBehavior3010602 = BaseClass("LevelBehavior3010602",LevelBehaviorBase)

function LevelBehavior3010602.GetGenerates()
	local generates = {900120,900040}
	return generates
end

function LevelBehavior3010602:__init(fight)
	self.fight = fight
end

function LevelBehavior3010602:Init()

	-------------------基础参数----------------------
	self.missionState = 0
	self.monsterListInfo = {}

	-------------------刷怪列表----------------------
	self.monsterList =
	{
		{id = 900120 ,posName = "Mon0201" ,wave = 1},
		{id = 900120 ,posName = "Mon0202" ,wave = 1},
		{id = 900120 ,posName = "Mon0203" ,wave = 1},
		{id = 900120 ,posName = "Mon0204" ,wave = 1},
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

	self.role = BehaviorFunctions.GetCtrlEntity()
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}

	self.dialogList =
	{
		[1] = {Id = 602090501,state = self.dialogStateEnum.NotPlaying}, --战斗前对话
	}

	self.camera = false

	self.playercheckP = 0
	self.target = nil
	self.targetPoint = "TP0201"
	self.maxRange = 12
end

function LevelBehavior3010602:Update()
	self.LevelCommon:Update()

	if self.missionState == 0 then
		--设置为普通关卡
		self.LevelCommon:SetAsTaskLevel("击败所有怪物")

		--开启关卡
		self.LevelCommon:LevelStart()
		--创建怪物
		self.monsterListInfo = self.LevelCommon:LevelCreateMonster(self.monsterList)
		----开启剩余敌人数量显示
		--self.LevelCommon:ShowEnemyRemainTips(true)
		----开启敌人波数显示
		--self.LevelCommon:ShowWaveTips(true)
		self.playercheckP = BehaviorFunctions.GetPositionP(self.role)
		self.missionState = 1
		
	elseif self.missionState == 5 then

	
		--if self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo) then
			
			--BehaviorFunctions.FinishLevel(3010602)	
			
		--end
		
		--获取自定义胜利条件是否满足
		local result1 = self:CustomSuccessCondition1()
		if result1 then
			LogError("1111")
		end
		
		--将上述条件作为胜利条件
		self.LevelCommon:LevelSuccessCondition(result1)		
	end
	if self.missionState == 1 then

		--停止行为树
		for i = 1,4 do
			BehaviorFunctions.AddBuff(self.role,self.monsterListInfo.list[i].instanceId,900000012)
			--添加无敌
			BehaviorFunctions.AddBuff(self.role,self.monsterListInfo.list[i].instanceId,900000007)
		end
		
		self.missionState = 2
	end

	if self.missionState == 2 then

		local target = BehaviorFunctions.GetTerrainPositionP(self.targetPoint,self.levelId)
		local checkPRange = BehaviorFunctions.GetDistanceFromPos(target,self.playercheckP)	--获取与路标特效的距离

		if checkPRange < self.maxRange then
			--摄像头调用
			--if self.camera == false then
				--self.LevelCommon:LevelCameraLookAtPos(22002,40,nil,"TP0201",0.75,0.75)
				--self.camera = true
			--end
			--播放敌人对话
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			
			self.missionState = 3
		end
	end

	if self.missionState == 4 then
		--开启黑幕
		BehaviorFunctions.ShowBlackCurtain(true,0.1)
		--移除黑幕
		self.blackEnd = BehaviorFunctions.AddDelayCallByTime(0.7,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
		self.missionState = 5
	end
	
end

function LevelBehavior3010602:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[1].Id then
				if self.missionState < 4 then
					self.missionState = 4
				end
			end

			v.state = self.dialogStateEnum.PlayOver
			--self.currentDialog = nil
		end
	end
end

--自定义胜利条件
function LevelBehavior3010602:CustomSuccessCondition1()
	if self.missionState == 5 then
		return true

	end
end

