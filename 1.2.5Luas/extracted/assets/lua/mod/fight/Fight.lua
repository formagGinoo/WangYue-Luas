---@type Fight
Fight = BaseClass("Fight")

local fightUtil = FightUtil
local fightEnum = FightEnum

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

	EventMgr.Instance:AddListener(EventName.LeaveDuplicate, self:ToFunc("LeaveDuplicate"))
end

function Fight:InitManager()
	if ctx then
		self.clientFight = ClientFight.New(self)
	end
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
	self.storyDialogManager = StoryDialogManager.New(self)
	self.conditionManager = ConditionManager.New(self)
	self.fightConditionManager = FightConditionManager.New(self)
	self.tipQueueManger = TipQueueManger.New(self)
	self.modelViewMgr = ModelViewManager.New(self)
	self.mapAreaManager = MapAreaManager.New(self)
	self.systemManager = SystemManager.New(self)
	self.noticeManger = NoticeManger.New(self)
	self.unlockManager = UnlockManager.New(self)
	self.teachManager = TeachManager.New(self)
	self.mercenaryHuntManager = MercenaryHuntManager.New(self)
	self.taskManager = TaskManager.New(self)
	self.taskConditionManager = TaskConditionManager.New(self)
	self.CustomDataBlackBoard = CustomDataBlackBoard.New(self)

	self.fightBtnManager = FightBtnManager.New(self)
end

function Fight:EnterFight(fightData, position, isDebug)
	self.playerManager:Init(fightData)
	self.fightData = fightData
	self.enterPosition = position
	self.fightState = FightEnum.FightState.Loading
	self.clientFight:Preload(fightData)
	self.debugMode = isDebug
end

function Fight:PreloadDone()
	self:StartFight()
end

function Fight:StartFight()
	if ctx then
		self.clientFight:StartFight()
		UnityUtils.GraphicsInit()
		if ctx.Editor then
			CustomUnityUtils.SetRenderScale(1)
			CustomUnityUtils.SetResolutionRatioIndex(1)
		else
			CustomUnityUtils.SetRenderScale(0.8)
			CustomUnityUtils.SetResolutionRatioIndex(1)
		end
	end

	CurtainManager.Instance:FadeIn(true,0)
	self.enterCurtan = true

	self:StartManager()
	EventMgr.Instance:Fire(EventName.StartFight)
	self:StartModule()
	Network.Instance:SetStopRecv(false)
end

-- 因为有时序需求只能自己写
function Fight:StartManager()
	self.conditionManager:StartFight()
	self.fightConditionManager:StartFight()
	self.playerManager:StartFight(self.enterPosition, self:ToFunc("StartFightCallBack"))
	self.levelManager:StartFight(self.fightData.MapConfig.level_id)
	self.systemManager:StartFight()
	self.unlockManager:StartFight()
	self.mapAreaManager:StartFight()
	self.entityManager:StartFight()
	self.taskManager:StartFight()
	self.taskConditionManager:StartFight()
end

function Fight:StartModule()

end

function Fight:StartFightCallBack(progress)
	if progress == 1 then
		self.clientFight:ShowUI()
		self.fightBtnManager:InitPlane()
		LoadPanelManager.Instance:Progress(100)
		LoadPanelManager.Instance:Hide()
		self.fightState = FightEnum.FightState.Fighting
		self.fightFrame = 0
	else
		local enterProgress = 80 + progress*20
		if LoadPanelManager.Instance then
			LoadPanelManager.Instance:Progress(enterProgress)
		end
	end
end

function Fight:Update()
	if self.fightState == FightEnum.FightState.Loading then
	elseif self.fightState == FightEnum.FightState.Fighting then
		if self.enterCurtan == true then
			self.enterCurtan = false
			CurtainManager.Instance:FadeOut(1.5)
		end
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
	if self.fightState == FightEnum.FightState.Fighting then
		self.mapAreaManager:LowUpdate()
		self.taskConditionManager:LowUpdate()
		mod.WorldMapCtrl:LowUpdate()
	end
end

function Fight:FightingUpdate()
	UnityUtils.BeginSample("Fight:FightingUpdate")

	if ctx then
		self.clientFight:BeforeUpdate()
	end

	WindowManager.Instance:BeforeLogicUpdate()

	local time = Global.deltaTime * 10000
	if time > 50000 then
		return
	end
	self.time  = self.time + time --FightUtil.realTime
	while self.time > (self.fightFrame + 1) * FightUtil.deltaTime do
		self:FrameAdd()
	end

	if ctx then
		self.clientFight:Update()
	end

	WindowManager.Instance:AfterLogicUpdate()
	UnityUtils.EndSample()
end

function Fight:FrameAdd()
	--Log("FrameAdd "..self.fightFrame)
	self.fightFrame = self.fightFrame + 1
	self:BeforeUpdate()
	self:LogicUpdate()
	self:AfterUpdate()
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

	UnityUtils.BeginSample("entityManager:Update")
	self.entityManager:Update()
	UnityUtils.EndSample()

	self.magicManager:Update()

	UnityUtils.BeginSample("windowManager:Update")
	WindowManager.Instance:LogicUpdate()
	UnityUtils.EndSample()

	if ctx and self.clientFight.postProcessManager then
		self.clientFight.postProcessManager:Update()
	end

	self.taskManager:Update()
	self.fightConditionManager:Update()
	self.mercenaryHuntManager:Update()
end

function Fight:AfterUpdate()
	self.entityManager:AfterUpdate()
	self.operationManager:AfterUpdate()

	mod.WorldMapCtrl:AfterUpdate()
end

function Fight:Pause()
	self.fightState = FightEnum.FightState.Pause
	self:TriggerPauseEvent(true)
end

function Fight:Resume()
	self.fightState = FightEnum.FightState.Fighting
	self:TriggerPauseEvent(false)
end

function Fight:GetFightMap()
	return self.fightData.MapConfig.id
end

function Fight:IsDebugMode()
	return self.debugMode
end

function Fight:SetFightState(state)
	self.fightState = state
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
            local pos = mod.WorldMapCtrl:GetMapPositionConfig(mapConfig.level_id, "PlayerBorn1", "Logic10020001_1")
            BehaviorFunctions.Transport(mapId, pos.x, pos.y, pos.z)
            return
        end

        mod.WorldMapCtrl:SendMapTransport(mapConfig.level_id, transportPoint)
	end

	self.levelManager:RemoveLevel(levelId)
end

function Fight:Clear()
	EventMgr.Instance:RemoveListener(EventName.LeaveDuplicate, self:ToFunc("LeaveDuplicate"))
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
end

function Fight:__delete()
	if ctx then
		self.clientFight:DeleteMe()
	end
	BehaviorFunctions.fight = nil
	self.operationManager:DeleteMe()
	self.entityManager:DeleteMe()
	self.magicManager:DeleteMe()

	self.damageCalculate:DeleteMe()
	self.physicsTerrain:DeleteMe()

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
	self.taskManager:DeleteMe()
	self.taskConditionManager:DeleteMe()
	self.CustomDataBlackBoard:DeleteMe()
end