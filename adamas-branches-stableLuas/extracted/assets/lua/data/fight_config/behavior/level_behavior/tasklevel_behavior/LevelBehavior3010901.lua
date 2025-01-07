LevelBehavior3010901 = BaseClass("LevelBehavior3010901",LevelBehaviorBase)

function LevelBehavior3010901.GetGenerates()
	local generates = {900140,900070}
	return generates
end

function LevelBehavior3010901:__init(fight)
	self.fight = fight
end

function LevelBehavior3010901:Init()

	-------------------基础参数----------------------
	self.missionState = 0
	self.monsterListInfo = {}

	-------------------刷怪列表----------------------
	self.monsterList =
	{
		[1] = {id = 900140 ,posName = "Mon0301" ,wave = 1},
		[2] = {id = 900140 ,posName = "Mon0302" ,wave = 1},
		[3] = {id = 900140 ,posName = "Mon0303" ,wave = 1},
		[4] = {id = 900070 ,posName = "Mon0304" ,wave = 2},
		[5] = {id = 900140 ,posName = "Mon0305" ,wave = 2},
		[6] = {id = 900140 ,posName = "Mon0306" ,wave = 2},
		
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
		[1] = {Id = 602100301,state = self.dialogStateEnum.NotPlaying}, --战斗前对话
	}

	self.camera = false
	
	self.playercheckP = 0
	self.target = nil
	self.targetPoint = "TP0301"
	self.maxRange = 10
	self.CompanyFight = false
end


function LevelBehavior3010901:Update()
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
		
	elseif self.missionState == 5 then

	
		--if self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo) then
			
			--BehaviorFunctions.FinishLevel(3010901)	
			
		--end
	
		--胜利条件：该怪物组内怪物都死亡
		local result1 = self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo)
		if result1 then
			LogError("1111")
		end
		
		--将上述条件作为胜利条件
		self.LevelCommon:LevelSuccessCondition(result1)		
	end
	
	if self.missionState == 1 then
	
		--停止行为树
		for i = 1,3 do
			BehaviorFunctions.AddBuff(self.role,self.monsterListInfo.list[i].instanceId,900000012)
			--添加无敌
			BehaviorFunctions.AddBuff(self.role,self.monsterListInfo.list[i].instanceId,900000007)
	
		end
		for i = 1,3 do
			--隐藏怪物UI
			BehaviorFunctions.ShowWarnAlertnessUI(self.monsterListInfo.list[i].instanceId, false)
			BehaviorFunctions.ShowQuestionAlertnessUI(self.monsterListInfo.list[i].instanceId, false)
			--血条隐藏1逻辑控制，2显示，3隐藏
			BehaviorFunctions.SetEntityLifeBarVisibleType(self.monsterListInfo.list[i].instanceId,3)
		end
		self.missionState = 2
	end

	if self.missionState == 2 then
		
	local target = BehaviorFunctions.GetTerrainPositionP(self.targetPoint,self.levelId)
	local checkPRange = BehaviorFunctions.GetDistanceFromPos(target,self.playercheckP)	--获取与路标特效的距离
		
		if checkPRange < self.maxRange then
			--摄像头调用
			if self.camera == false then
				self.LevelCommon:LevelCameraLookAtPos(22002,40,nil,"TP0301",0.75,0.75)
				self.camera = true
			end
			--播放敌人对话
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			--怪物演出
			BehaviorFunctions.PlayAnimation(self.monsterListInfo.list[2].instanceId,"Stand2",FightEnum.AnimationLayer.BaseLayer)
			BehaviorFunctions.PlayAnimation(self.monsterListInfo.list[1].instanceId,"OutStand3",FightEnum.AnimationLayer.BaseLayer)
			BehaviorFunctions.PlayAnimation(self.monsterListInfo.list[3].instanceId,"Taunt",FightEnum.AnimationLayer.BaseLayer)
			
			self.missionState = 3
		end
	end

	if self.missionState == 4 then
		--恢复行为树
		for i = 1,3 do
			BehaviorFunctions.RemoveBuff(self.monsterListInfo.list[i].instanceId,900000012)
			--关闭无敌
			BehaviorFunctions.RemoveBuff(self.monsterListInfo.list[i].instanceId,900000007)
		end
		for i = 1,3 do
			--隐藏怪物UI
			BehaviorFunctions.ShowWarnAlertnessUI(self.monsterListInfo.list[i].instanceId, true)
			BehaviorFunctions.ShowQuestionAlertnessUI(self.monsterListInfo.list[i].instanceId, true)
			--血条隐藏1逻辑控制，2显示，3隐藏
			BehaviorFunctions.SetEntityLifeBarVisibleType(self.monsterListInfo.list[i].instanceId,1)
		end
		--开启剩余敌人数量显示
		self.LevelCommon:ShowEnemyRemainTips(true,"抢回玩具")
		--开启敌人波数显示
		self.LevelCommon:ShowWaveTips(true)
		self.missionState = 5
	end
	
	function LevelBehavior3010901:StoryEndEvent(dialogId)
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
end

