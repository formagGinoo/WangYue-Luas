---@type ClientFight
ClientFight = BaseClass("ClientFight")


function ClientFight:__init(fight)
	self.fight = fight
	self.fightRoot = GameObject("FightRoot")
	self.fightRootTrans = self.fightRoot.transform
	GameObject.DontDestroyOnLoad(self.fightRoot)
	UnityUtils.SetPosition(self.fightRootTrans,0, 0, 0)
	self.colliderRoot = GameObject("ColliderRoot")
	self.colliderRoot.transform:SetParent(self.fightRootTrans)
	self.assetsNodeManager = AssetsNodeManager.New()
	self.assetPoolRoot = GameObject("AssetPoolRoot")
	self.assetPoolRoot.transform:SetParent(self.fightRootTrans)
	self.assetPoolRoot:SetActive(false)
	UnityUtils.SetPosition(self.colliderRoot.transform,0, 0, 0)
	self.clientEntityManager = ClientEntityManager.New(self)
	self.inputManager = InputManager.New(self)
	self.cameraManager = CameraManager.New(self)
	self.clientMap = ClientMap.New(self)
	self.overManager = FightOverManager.New(self)
	self.effectKeyWordController = EffectKeyWordController.New(self)
	self.buildManager = BuildManager.New(self)
	self.decorationManager = DecorationManager.New(self)
	self:InitManager()
	if ctx.IsDebug then
		FightDebugManager.New()
	end
end

function ClientFight:InitManager()
	self.assetsNodeManager:SetAssetPoolRoot(self.assetPoolRoot.transform,self.fight)
	self.assetsPool = self.assetsNodeManager.totalAssetPool
	self.resourcesPreload = SceneResourcesPreload.New(self)
	self.fontAnimManager = FontAnimManager.New(self)
	self.lifeBarManager = LifeBarManager.New(self)
	self.headInfoManager = HeadInfoManager.New(self)
	self.levelTipManager = LevelTipManager.New(self)
	self.clientTimelineManager = ClientTimelineManager.New(self)
	self.skillGuideManager = SkillGuideManager.New(self)
	self.fightGuidePointerManager = FightGuidePointerManager.New(self)
	self.postProcessManager = PostProcessManager.New(self)
	self.guideManager = GuideManager.New(self)
	self.qteManager = QTEManager.New(self)
	self.headAlertnessManager = HeadAlertnessManager.New(self)
	self.bindChildObjManage = BindChildObjManage.New(self)
	self.dayTimeManager = DayTimeManager.New(self)
	self.levelGuideManager = LevelGuideManager.New(self)
end

function ClientFight:Preload(fightData)
	self.resourcesPreload:StartLoadTask(fightData)
end

function ClientFight:StartFight()
	--Log("ClientFight StartFight ")
	local mapConfig = self.fight.fightData.MapConfig
	self.clientMap:StartFight(mapConfig)
	self.cameraManager:StartFight()
	self.fontAnimManager:StartFight()
	self.lifeBarManager:StartFight()
	self.headInfoManager:StartFight()
	self.fightGuidePointerManager:StartFight()
	self.postProcessManager:StartFight()
	self.guideManager:StartFight()
	self.headAlertnessManager:StartFight()
	self.bindChildObjManage:StartFight()
	self.dayTimeManager:StartFight()
	self.buildManager:StartFight()
	self.decorationManager:StartFight()
	self.levelGuideManager:StartFight()

	CurtainManager.Instance:ResetWait()
	-- mod.WorldFacade:SendMsg("ecosystem_state", mapConfig.id)
	
end

function ClientFight:ShowUI()
	WindowManager.Instance:OpenWindow(FightMainUIView)
	PanelManager.Instance:OpenPanel(FightCoreUIPanel)
end

function ClientFight:BeforeUpdate()
	if not self.inputManager or not self.qteManager then
		LogError("ClientFight卸载坏了，找程序查查是咋回事捏")
		return
	end
	self.inputManager:BeforeUpdate()
	self.qteManager:BeforeUpdate()
end

function ClientFight:Update()
	UnityUtils.BeginSample("ClientFight:Update")
	local lerpTime = (self.fight.time - self.fight.fightFrame * FightUtil.deltaTime) / FightUtil.deltaTime
	lerpTime = lerpTime > 1 and 1 or lerpTime
	--Log("lerpTime "..lerpTime)
	UnityUtils.BeginSample("ClientFight:cameraManager Update")
	self.cameraManager:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("ClientFight:clientEntityManager Update")
	self.clientEntityManager:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("ClientFight:clientTimelineManager Update")
	self.clientTimelineManager:Update(lerpTime)
	UnityUtils.EndSample()

	self.lifeBarManager:Update(lerpTime)
	self.headInfoManager:Update(lerpTime)
	self.bindChildObjManage:Update(lerpTime)

	UnityUtils.BeginSample("ClientFight:clientMap Update")
	self.clientMap:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("ClientFight:fightGuidePointerManager Update")
	self.fightGuidePointerManager:Update(lerpTime)
	UnityUtils.EndSample()

	UnityUtils.BeginSample("ClientFight:qteManager Update")
	self.qteManager:Update(lerpTime)
	UnityUtils.EndSample()
	--self.postProcessManager:Update(lerpTime)

	UnityUtils.BeginSample("ClientFight:headAlertnessManager Update")
	self.headAlertnessManager:Update(lerpTime)
	UnityUtils.EndSample()

	self.buildManager:Update(lerpTime)
	self.decorationManager:Update(lerpTime)
	self.levelGuideManager:Update(lerpTime)

	self:AfterUpdate()
	UnityUtils.EndSample()

	self.effectKeyWordController:Update(lerpTime)
	self.fontAnimManager:Update(lerpTime)
end

function ClientFight:AfterUpdate()
	UnityUtils.BeginSample("ClientFight:clientEntityManager AfterUpdate")
	self.clientEntityManager:AfterUpdate()
	UnityUtils.EndSample()

	self.cameraManager:AfterUpdate()
end

function ClientFight:LowUpdate()
	self.fightGuidePointerManager:LowUpdate()
end

function ClientFight:GetCurEntity()
	return BehaviorFunctions.GetCtrlEntity()
end

function ClientFight:GetAimTargetTrans()
	if not self.aimTarget then
		self.aimTarget = GameObject("AimTarget")
		self.aimTargetTrans = self.aimTarget.transform
		self.aimTarget.transform:SetParent(self.fightRootTrans)
	end

	return self.aimTargetTrans
end

function ClientFight:SetActiveByPath(path, isShow)
	-- TODO 临时用一下
	LogError("临时方法：隐藏场景物件,2月20号后改成报错", path)
	local tf = self.fightRootTrans:Find(path)
	if tf then
		CustomUnityUtils.SetModelActive(tf.gameObject,isShow)
	else
		LogError("未找到路径", path)
	end
end

function ClientFight:__delete()
	self.qteManager:DeleteMe()
	WindowManager.Instance:CloseAllWindow(true)

	GameObject.Destroy(self.fightRoot)
	if GameSpeedManager.Instance then
		GameSpeedManager.Instance.model:CloseMainUI()
	end
	self.overManager:DeleteMe()
	self.clientEntityManager:DeleteMe()
	self.inputManager:DeleteMe()
	self.cameraManager:DeleteMe()
	self.clientMap:DeleteMe()
	self.headAlertnessManager:DeleteMe()
	self.buildManager:DeleteMe()

	self.resourcesPreload:DeleteMe()
	self.fontAnimManager:DeleteMe()
	self.lifeBarManager:DeleteMe()
	self.headInfoManager:DeleteMe()
	self.levelTipManager:DeleteMe()
	self.skillGuideManager:DeleteMe()
	self.fightGuidePointerManager:DeleteMe()
	self.postProcessManager:DeleteMe()
	self.guideManager:DeleteMe()
	self.bindChildObjManage:DeleteMe()
	self.assetsNodeManager:DeleteMe()
	self.levelGuideManager:DeleteMe()
	if ctx.IsDebug then
		FightDebugManager.Instance:DeleteMe()
	end
	UnityUtils.GraphicsUnload()
end