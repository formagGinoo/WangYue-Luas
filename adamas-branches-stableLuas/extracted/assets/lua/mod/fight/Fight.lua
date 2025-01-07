
Fight = BaseClass("Fight")

local fightUtil = FightUtil
local fightEnum = FightEnum
local _luaEntityProfiler = LuaEntityProfiler
function Fight:__init()
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	if Fight.Instance then
		Log("单例对象重复实例化")
	end

	WindowManager.Instance:CloseAllWindow(true)
	PanelManager.Instance:CloseAllPanel(true)

	Fight.Instance = self
	BehaviorFunctions.SetFight(self)
	self.fightState = FightEnum.FightState.None
	self.fightResult = FightEnum.FightResult.None
	self.debugMode = false
	self.time = 0
	self.fightFrame = 0
	self:InitManager()
	self.debugFormation = {}

	-- 进入地图的position记录
	self.enterPosition = nil
	self.enterRotate = nil
end

function Fight:InitManager()
	if ctx then
		self.clientFight = ClientFight.New(self)
	end
	self.dayNightMgr = DayNightMgr.New(self)
	self.operationManager = OperationManager.New(self)
	self.entityManager = EntityManager.New(self)
	self.objectPool = ObjectPool.New()
	self.magicManager = MagicManager.New(self)
	self.damageCalculate = DamageCalculate.New(self)
	self.physicsTerrain = PhysicsTerrain.New(self)
	self.playerManager = PlayerManager.New(self)
	self.timelineManager = TimelineManager.New(self)
	self.behaviorDelayCallback = BehaviorDelayCallback.New(self)
	self.levelManager = LevelManager.New(self)
	self.conditionManager = ConditionManager.New(self)
	self.fightConditionManager = FightConditionManager.New(self)
	self.tipQueueManger = TipQueueManger.New(self)
	self.modelViewMgr = ModelViewManager.New(self)
	self.mapAreaManager = MapAreaManager.New(self)
	self.mapNavPathManager = MapNavPathManager.New(self)
	self.bgmAreaManager = BgmAreaManager.New(self)
	self.systemManager = SystemManager.New(self)
	self.noticeManger = NoticeManger.New(self)
	self.unlockManager = UnlockManager.New(self)
	self.teachManager = TeachManager.New(self)
	self.mercenaryHuntManager = MercenaryHuntManager.New(self)
	self.protectorManager = ProtectorManager.New(self)
	self.taskManager = TaskManager.New(self)
	self.customDataBlackBoard = CustomDataBlackBoard.New(self)
	self.goapManager = GOAPManager.New(self)
	self.partnerManager = PartnerManager.New(self)

	self.fightBtnManager = FightBtnManager.New(self)
	self.hackManager = HackingManager.New(self)
	self.inputImageChangerManager = InputImageChangerManager.New()
	self.rouguelikeManager = RoguelikeManager.New(self)
	self.levelEventManager = LevelEventManager.New(self)
	self.abilityWheelManager = AbilityWheelManager.New(self)
	self.duplicateManager = DuplicateManager.New(self)
	self.growNoticeManager = GrowNoticeManager.New(self)
end

function Fight:EnterFight(fightData, position, rotate, isDebug)
	self.playerManager:Init(fightData)
	self.fightData = fightData
	self.enterPosition = position
	self.enterRotate = rotate
	self.fightState = FightEnum.FightState.Loading
	self.clientFight:Preload(fightData)
	self.mapId = self.fightData.MapConfig.id
	self.debugMode = isDebug
	self.abilityWheelManager:EnterFight()
	self.growNoticeManager:EnterFight()
end

function Fight:PreloadDone()
	self:StartFight()
end

function Fight:StartFight()
	if ctx then
		self.clientFight:StartFight()
		UnityUtils.GraphicsInit()
		-- if ctx.Editor then
		-- 	CustomUnityUtils.SetRenderScale(1)
		-- 	CustomUnityUtils.SetResolutionRatioIndex(1)
		-- else
		-- 	CustomUnityUtils.SetRenderScale(0.8)
		-- 	CustomUnityUtils.SetResolutionRatioIndex(1)
		-- end
	end

	self:StartManager()
	EventMgr.Instance:Fire(EventName.StartFight)
	self:StartModule()
	Network.Instance:SetStopRecv(false)
end

-- 因为有时序需求只能自己写
function Fight:StartManager()
	self.dayNightMgr:StartFight()
	self.conditionManager:StartFight()
	self.fightConditionManager:StartFight()
	self.playerManager:StartFight(self.enterPosition, self.enterRotate)
	self.levelManager:StartFight(self.fightData.MapConfig.level_id)
	self.systemManager:StartFight()
	self.unlockManager:StartFight()
	self.entityManager:StartFight()
	self.taskManager:StartFight()
	self.mapAreaManager:StartFight()
	self.mapNavPathManager:StartFight()
	self.bgmAreaManager:StartFight()

	self.rouguelikeManager:StartFight()
	self.levelEventManager:StartFight()
	self.abilityWheelManager:StartFight()
	self.hackManager:StartFight()
	self.growNoticeManager:StartFight()
end

function Fight:StartModule()

end

-- function Fight:OnSceneResLoad(progress)
-- 	if progress == 1 then
-- 		if LoginCtrl.IsInGame() then
-- 		    -- todo 临时先不加进度条内容，加载完实体再战斗开始
-- 		    self.entityManager.ecosystemCtrlManager:StartLoading(self.mapId, self:ToFunc("OnFightStart"))
-- 		else
-- 			self:OnFightStart()
-- 		end
-- 	else
-- 		local enterProgress = 80 + progress*20
-- 		if LoadPanelManager.Instance then
-- 			LoadPanelManager.Instance:Progress(enterProgress)
-- 		end
-- 	end
-- end

function Fight:OnFightStart()
	if not WorldSwitchTimeLine.Instance.switchStart then 
		self.clientFight:ShowUI()
		self.fightBtnManager:InitPlane()
		--领取月卡奖励
		mod.PurchaseCtrl:GetDailyMonthcardReward()
		--执行池子里跳地图的callback
		mod.WorldMapCtrl:DoCacheEnterMapCallback()
	end

	--LoadPanelManager.Instance:Progress(100)
	LoadPanelManager.Instance:Hide()
	if WorldSwitchTimeLine.Instance.switchStart then
        WorldSwitchTimeLine.Instance:OnFightStart()
    end

	-- 临时处理 如果有任务在storyDialog里面就不取消黑幕 等任务自己去取消
	local taskInCurtain = false
	local startTasks = mod.TaskCtrl:GetStartTask()
	local taskCfg
	for k, v in pairs(startTasks) do
		taskCfg = mod.TaskCtrl:GetTaskConfig(k)
		if taskCfg and taskCfg.trigger and taskCfg.trigger[1] == "play_storydialog" then
			taskInCurtain = true
			self.taskManager:SetTaskInCurtain(true)
			break
		end
	end

	if not WorldSwitchTimeLine.Instance.switchStart then
		CurtainManager.Instance:FadeIn(true,0)
		CurtainManager.Instance:FadeOut(1.5)
	end

	self.fightState = FightEnum.FightState.Fighting
	self.fightFrame = 0
	self.taskManager:OnFightStart()
	self.duplicateManager:StartFight()
	Story.Instance:OnFightStart()
end

function Fight:Update()
	if self.fightState == FightEnum.FightState.Loading then
		 self.entityManager.ecosystemCtrlManager:LoadingUpdate()
	elseif self.fightState == FightEnum.FightState.Fighting then
		self:FightingUpdate()
	elseif self.fightState == FightEnum.FightState.Exit then
		Fight.Instance:Clear()
		if ctx then
			if mod.LoginCtrl.loginState == GameConfig.LoginState.InGame then
				-- mod.TaskCtrl:SkipMapPlaceDuplicate(self.duplicateId)
			else
				WindowManager.Instance:OpenWindow(LoginWindow)
			end
		end
	end
end

function Fight:LowUpdate()
	if self.fightState ~= FightEnum.FightState.Fighting then
		return
	end

	self.mapAreaManager:LowUpdate()
	self.bgmAreaManager:LowUpdate()
	self.taskManager:LowUpdate()
	self.playerManager:LowUpdate()
	mod.WorldMapCtrl:LowUpdate()
	mod.CallVehicleCtrl:LowUpdate()
	self.levelEventManager:LowUpdate()

	if ctx then
		self.clientFight:LowUpdate()
	end
end

function Fight:FightingUpdate()
	UnityUtils.BeginSample("Fight:FightingUpdate")
	--_luaEntityProfiler:StartTiming()
	if WorldSwitchTimeLine.Instance.switchStart then
		self.entityManager.ecosystemCtrlManager:Update()
		return
	end

	if ctx then
		self.clientFight:BeforeUpdate()
	end

	WindowManager.Instance:BeforeLogicUpdate()

	local time = Global.deltaTime * 10000

	if DebugConfig.UseRenderFrame then
		time = FightUtil.deltaTime / (Application.targetFrameRate / Time.timeScale / 30)
	end

	if time > 50000 then
		return
	end
	if time >= 2 * FightUtil.deltaTime then--防止帧率低的时候需要跑更多逻辑帧导致更低的帧率
		time = 2 * FightUtil.deltaTime
	end
	self.time  = self.time + time --FightUtil.realTime
	local clientFrame = 0

	while self.time > (self.fightFrame + 1) * FightUtil.deltaTime do
		self:FrameAdd()
		CS.KCCCharacterManager.Instance:ManualSimulate()
		--self.clientFight:Update()
		clientFrame = clientFrame + 1
	end

	--if ctx and clientFrame == 0 then
		self.clientFight:Update()
	--end

	WindowManager.Instance:AfterLogicUpdate()
	--_luaEntityProfiler:EndTiming()
	UnityUtils.EndSample()
end

function Fight:FrameAdd()
	--LogError("FrameAdd "..self.fightFrame)
	self.fightFrame = self.fightFrame + 1
	self:BeforeUpdate()
	self:LogicUpdate()
	self:AfterUpdate()

	if DebugConfig.UseRenderFrame and self.fightFrame % 60 == 0 then
		LogError("当前游戏秒数:"..self.fightFrame / 60)
	end

	EventMgr.Instance:Fire(EventName.LogicUpdate)
end

function Fight:GetFrame()
	return self.fightFrame
end

function Fight:BeforeUpdate()
	self.entityManager:BeforeUpdate()
	self.operationManager:BeforeUpdate()
end

function Fight:LogicUpdate()
	self.playerManager:Update()
	self.behaviorDelayCallback:Update()

	UnityUtils.BeginSample("levelBehavior:Update")
	self.levelManager:LogicUpdate()
	UnityUtils.EndSample()

	if ctx and self.clientFight.skillGuideManager then
		self.clientFight.skillGuideManager:Update()
	end

	UnityUtils.BeginSample("entityManager:Update",true)
	self.entityManager:Update()
	UnityUtils.EndSample(true)

	self.magicManager:Update()
	self.timelineManager:Update()

	UnityUtils.BeginSample("windowManager:Update")
	WindowManager.Instance:LogicUpdate()
	UnityUtils.EndSample()

	if ctx and self.clientFight.postProcessManager then
		self.clientFight.postProcessManager:Update()
	end

	self.taskManager:Update()
	self.fightConditionManager:Update()
	self.mercenaryHuntManager:Update()
	self.protectorManager:Update()
	self.rouguelikeManager:Update()
	self.abilityWheelManager:Update()
	self.goapManager:Update()
	self.duplicateManager:Update()
	self.hackManager:Update()
	self.partnerManager:Update()
end

function Fight:AfterUpdate()
	self.playerManager:AfterUpdate()--先更新玩家属性
	self.entityManager:AfterUpdate()
	self.operationManager:AfterUpdate()
	self.mapNavPathManager:AfterUpdate()

	mod.WorldMapCtrl:AfterUpdate()
end

function Fight:Pause()
	self.pauseCount = self.pauseCount or 0
	self.pauseCount = self.pauseCount + 1
	if BehaviorFunctions.fight.pauseCount > 1 then
		return false
	elseif BehaviorFunctions.fight.pauseCount <= 0 then
		LogError("暂停计数异常：".. self.pauseCount)
	end
	BehaviorFunctions.TempSetAllEntityIsKinematicOnPause(true)
	self.fightState = FightEnum.FightState.Pause
	self:TriggerPauseEvent(true)
	if not BehaviorFunctions.fight.clientFight then
		return false
	end
	return true
end

function Fight:Resume()
	self.pauseCount = self.pauseCount or 0
	self.pauseCount = self.pauseCount - 1
	
	if self.pauseCount > 0 then
		return false
	elseif self.pauseCount < 0 then
		Log("暂停计数异常：".. self.pauseCount)
	end
	BehaviorFunctions.TempSetAllEntityIsKinematicOnPause(false)
	self.pauseCount = self.pauseCount < 0 and 0 or self.pauseCount
	self.fightState = FightEnum.FightState.Fighting
	self:TriggerPauseEvent(false)
	return true
end

function Fight:GetFightMap()
	return self.mapId
end

function Fight:IsDebugMode()
	return self.debugMode
end

function Fight:SetFightState(state)
	self.fightState = state
end

function Fight:GetFightState()
	return self.fightState 
end

function Fight:CheckFightPause()
	return self.fightState == FightEnum.FightState.Pause
end

function Fight:IsFighting()
	return self.fightState == FightEnum.FightState.Fighting
end

function Fight:TriggerPauseEvent(isPause)
	EventMgr.Instance:Fire(EventName.FightPause, isPause)
end

-- TODO 可以删除 改到副本系统下
function Fight:ResultFight(fightResult)
	self.fightResult = fightResult
end

function Fight:SetDebugFormation(roleList)
	self.debugFormation = roleList
end

function Fight:GetDebugFormation()
	if #self.debugFormation == 0 then
		return false
	end
	local tempData = {}
	for i = 1, #self.debugFormation do
		tempData[i] = self.debugFormation[i]
	end

	return tempData
end

function Fight:IsDebugDuplicate()
	return #self.debugFormation ~= 0
end

function Fight:LeaveDuplicate()
	local duplicateId, levelId = mod.WorldMapCtrl:GetDuplicateInfo()
	local duplicateConfig = Config.DataDuplicate.data_duplicate[duplicateId]
	if not duplicateConfig then
		LogError("找不到 duplicate!, id = "..duplicateId)
		return
	end

	local needRevive = not duplicateConfig.is_switch_map and Fight.Instance.playerManager:GetPlayer():CheckIsAllDead()
	if needRevive then
		local transportPoint = mod.WorldCtrl:GetNearByTransportPoint()
        local mapId = self:GetFightMap()
        local mapConfig = mod.WorldMapCtrl:GetMapConfig(mapId)
        if not transportPoint then
            -- TODO 临时写的位置
			if mapId == 10020001 then
				local pos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(mapConfig.position_id, "pb1", "Logic10020001_6")
				BehaviorFunctions.Transport(mapId, pos.x, pos.y, pos.z)
			elseif mapId == 10020004 then
				BehaviorFunctions.Transport(10020004, 1373.941, 98.5656, 1419.813)
			end
            return
        end

        mod.WorldMapCtrl:SendMapTransport(mapConfig.position_id, transportPoint)
	end

	self.levelManager:RemoveLevel(levelId)
end

function Fight:Clear()
	self.clearing = true
	WindowManager.Instance:CloseAllWindow(true)
	PanelManager.Instance:CloseAllPanel(true)
	self:DeleteMe()
	Fight.Instance = nil

	if ctx and ctx.Editor and DebugFightClassClear then
		for k,traceinfo in pairs(DebugFightClassClear) do
			print("退出战斗对象未清理",traceinfo)
		end
		DebugFightClassClear = {}
	end

	EventMgr.Instance:Fire(EventName.ExitFight)
	self.clearing = false
	SystemStateMgr.Instance:Clear()
end

function Fight:__delete()
	self.growNoticeManager:DeleteMe()
	self.abilityWheelManager:DeleteMe()
	if ctx then
		self.clientFight:DeleteMe()
	end
	BehaviorFunctions.fight = nil
	self.dayNightMgr:DeleteMe()
	self.operationManager:DeleteMe()
	self.entityManager:DeleteMe()
	self.magicManager:DeleteMe()

	self.damageCalculate:DeleteMe()
	self.physicsTerrain:DeleteMe()
	self.playerManager:DeleteMe()

	self.levelManager:DeleteMe()

	self.objectPool:DeleteMe()

	self.tipQueueManger:DeleteMe()

	self.modelViewMgr:DeleteMe()
	self.fightConditionManager:DeleteMe()

	self.systemManager:DeleteMe()
	self.noticeManger:DeleteMe()
	self.unlockManager:DeleteMe()
	self.teachManager:DeleteMe()
	self.mercenaryHuntManager:DeleteMe()
	self.protectorManager:DeleteMe()
	self.taskManager:DeleteMe()
	self.customDataBlackBoard:DeleteMe()
	self.hackManager:DeleteMe()
	self.goapManager:DeleteMe()
	self.partnerManager:DeleteMe()

	self.levelEventManager:DeleteMe()
	self.rouguelikeManager:DeleteMe()
	self.inputImageChangerManager:DeleteMe()
	self.duplicateManager:DeleteMe()
	self.mapNavPathManager:DeleteMe()
	CS.KCCCharacterManager.Instance:Destroy()
end