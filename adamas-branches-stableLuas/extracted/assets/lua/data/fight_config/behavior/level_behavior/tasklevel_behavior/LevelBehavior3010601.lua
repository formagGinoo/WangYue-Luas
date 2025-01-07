LevelBehavior3010601 = BaseClass("LevelBehavior3010601",LevelBehaviorBase)

function LevelBehavior3010601.GetGenerates()
	local generates = {900120,900040}
	return generates
end

function LevelBehavior3010601:__init(fight)
	self.fight = fight
end

function LevelBehavior3010601:Init()

	-------------------基础参数----------------------
	self.missionState = 0
	self.monsterListInfo = {}

	-------------------刷怪列表----------------------
	self.monsterList =
	{
		{id = 900120 ,posName = "Mon0201" ,wave = 1,engage = false,patrolList = {"T20","T21"}},
		{id = 900120 ,posName = "Mon0202" ,wave = 1,engage = false,patrolList = {"T22","T23"}},
		{id = 900120 ,posName = "Mon0203" ,wave = 1,engage = false,patrolList = nil},
		{id = 900120 ,posName = "Mon0204" ,wave = 1,engage = false,patrolList = nil},
		{id = 900120 ,posName = "Mon0205" ,wave = 2,patrolList = nil},
		{id = 900120 ,posName = "Mon0206" ,wave = 2,patrolList = nil},
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
		[1] = {Id = 602090301,state = self.dialogStateEnum.NotPlaying}, --战斗前对话
		[2] = {Id = 602090401,state = self.dialogStateEnum.NotPlaying}, --战斗前对话
	}

	self.camera = false

	self.playercheckP = 0
	self.target = nil
	self.targetPoint = "TP0201"
	self.maxRange = 15
	self.CompanyFight = false
end

function LevelBehavior3010601:Update()
	self.LevelCommon:Update()
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

		self.playercheckP = BehaviorFunctions.GetPositionP(self.role)
		self.missionState = 1
		self.CompanyFight = true
		
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
		
	elseif self.missionState == 9 then

	
		--if self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo) then
			
			--BehaviorFunctions.FinishLevel(3010601)	
			
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
			--BehaviorFunctions.AddBuff(self.role,self.monsterListInfo.list[i].instanceId,900000012)
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
			if self.camera == false then
				self.LevelCommon:LevelCameraLookAtPos(22002,40,nil,"TP0201",0.75,0.75)
				self.camera = true
			end
			--播放敌人对话
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			--停止行为树
			for i = 3,4 do
			BehaviorFunctions.AddBuff(self.role,self.monsterListInfo.list[i].instanceId,900000012)
		
			end
			for i = 1,4 do
				--隐藏怪物UI
				BehaviorFunctions.ShowWarnAlertnessUI(self.monsterListInfo.list[i].instanceId, false)
				BehaviorFunctions.ShowQuestionAlertnessUI(self.monsterListInfo.list[i].instanceId, false)
				--血条隐藏1逻辑控制，2显示，3隐藏
				BehaviorFunctions.SetEntityLifeBarVisibleType(self.monsterListInfo.list[i].instanceId,3)
			end
			
	
			self.missionState = 3
		end
	end

	if self.missionState == 4 then
		--恢复行为树
		for i = 1,4 do
			BehaviorFunctions.RemoveBuff(self.monsterListInfo.list[i].instanceId,900000012)
			--关闭无敌
			BehaviorFunctions.RemoveBuff(self.monsterListInfo.list[i].instanceId,900000007)
		end
		for i = 1,4 do
			--隐藏怪物UI
			BehaviorFunctions.ShowWarnAlertnessUI(self.monsterListInfo.list[i].instanceId, true)
			BehaviorFunctions.ShowQuestionAlertnessUI(self.monsterListInfo.list[i].instanceId, true)
			--血条隐藏1逻辑控制，2显示，3隐藏
			BehaviorFunctions.SetEntityLifeBarVisibleType(self.monsterListInfo.list[i].instanceId,1)
		end
		--开启剩余敌人数量显示
		self.LevelCommon:ShowEnemyRemainTips(true)
		--开启敌人波数显示
		self.LevelCommon:ShowWaveTips(true)
		self.missionState = 5
	end
	
	
	if self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo) and self.missionState == 5 then
		--开启黑幕
		BehaviorFunctions.ShowBlackCurtain(true,0.1)
		--创建怪物
		self.monsterListInfo = self.LevelCommon:LevelCreateMonster(self.monsterList)
		--停止行为树
		for i = 1,4 do
			BehaviorFunctions.AddBuff(self.role,self.monsterListInfo.list[i].instanceId,900000012)
		end
		for i = 1,4 do
			--隐藏怪物UI
			BehaviorFunctions.ShowWarnAlertnessUI(self.monsterListInfo.list[i].instanceId, false)
			BehaviorFunctions.ShowQuestionAlertnessUI(self.monsterListInfo.list[i].instanceId, false)
			--血条隐藏1逻辑控制，2显示，3隐藏
			BehaviorFunctions.SetEntityLifeBarVisibleType(self.monsterListInfo.list[i].instanceId,3)
		end
		
		--传送角色
		local pos = BehaviorFunctions.GetTerrainPositionP("Trans0201",10020005,"LogicDelegateTask01")
		local rotate = BehaviorFunctions.GetTerrainRotationP("Trans0201",10020005,"LogicDelegateTask01")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SetEntityEuler(self.role,rotate.x,rotate.y,rotate.z)
		self.LevelCommon:LevelCameraLookAtPos(22001,40,"CameraTarget","TP0201",0.75,0.75)
		--移除黑幕
		self.blackEnd = BehaviorFunctions.AddDelayCallByTime(0.7,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
		
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		self.missionState = 6
	end
	if self.missionState == 8 then
		--开启黑幕
		BehaviorFunctions.ShowBlackCurtain(true,0.1)
		--移除黑幕
		self.blackEnd = BehaviorFunctions.AddDelayCallByTime(0.7,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
		self.missionState = 9
	end
	
end

function LevelBehavior3010601:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[1].Id then
				if self.missionState < 4 then
					self.missionState = 4
				end
			end
			if dialogId == self.dialogList[2].Id then
				if self.missionState < 7 then
					self.missionState = 8
				end
			end
			v.state = self.dialogStateEnum.PlayOver
			--self.currentDialog = nil
		end
	end
end

--自定义胜利条件
function LevelBehavior3010601:CustomSuccessCondition1()
	if self.missionState == 9 then
		return true

	end
end

