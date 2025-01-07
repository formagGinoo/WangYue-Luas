---@type ClientFight
ClientFight = BaseClass("ClientFight")

local BoneShakeAsset

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
	self:InitManager()
	if ctx.IsDebug then
		FightDebugManager.New()
	end
end

function ClientFight:InitManager()
	self.assetsNodeManager:SetAssetPoolRoot(self.assetPoolRoot.transform,self.fight)
	self.assetsPool = self.assetsNodeManager.totalAssetPool
	self.resourcesPreload = FightResourcesPreload.New(self)
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
end

function ClientFight:Preload(fightData)
	--Log("ClientFight Preload")
	--ctx.LoadingPage:Show(TI18N("加载战斗资源(0%)"))
	--ctx.LoadingPage:ShowLoadingTips()
	if LoadPanelManager.Instance then
		LoadPanelManager.Instance:Show()
	end
	
	self.resourcesPreload:DoPreload(fightData,
		function(progress) self:PreloadProgress(progress) end,
		function() self:PreloadCallback() end)

end

function ClientFight:PreloadProgress(progress)
	--Log("ClientFight PreloadProgress "..progress)
	--ctx.LoadingPage:Progress(string.format(TI18N("加载战斗资源(%0.1f%%)"), tostring(progress)), progress)
	if LoadPanelManager.Instance then
		LoadPanelManager.Instance:Progress(progress)
	end
end

function ClientFight:PreloadCallback()
	--Log("ClientFight PreloadCallback")
	-- ctx.LoadingPage:HideLoadingTips()
	--ctx.LoadingPage:Hide()
	if not BoneShakeAsset then
		BoneShakeAsset = self.assetsPool:Get("Character/BoneShake/BoneShakeData.asset")
		CustomUnityUtils.SetBoneSakeDataObject(BoneShakeAsset)

		local IKShakeAsset = self.assetsPool:Get("Character/BoneShake/IKShakeData.asset")
		local IKFullBodyAsset = self.assetsPool:Get("Character/BoneShake/IKFullBodyData.asset")
		CustomUnityUtils.SetIKBoneSakeDataObject(IKShakeAsset, IKFullBodyAsset)
	end
	
	self.fight:PreloadDone()
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

	CurtainManager.Instance:ResetWait()
	mod.WorldFacade:SendMsg("ecosystem_state", mapConfig.id)
end

function ClientFight:ShowUI()
	WindowManager.Instance:OpenWindow(FightMainUIView, nil, nil, true)
end

function ClientFight:BeforeUpdate()
	self.inputManager:BeforeUpdate()
	self.qteManager:BeforeUpdate()
end

function ClientFight:Update()
	UnityUtils.BeginSample("ClientFight:Update")
	local lerpTime = (self.fight.time - self.fight.fightFrame * FightUtil.deltaTime) / FightUtil.deltaTime
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

	self:AfterUpdate()
	UnityUtils.EndSample()

	UnityUtils.BeginSample("ClientFight:headAlertnessManager Update")
	self.headAlertnessManager:Update(lerpTime)
	UnityUtils.EndSample()
	
	self.effectKeyWordController:Update(lerpTime)
end

function ClientFight:AfterUpdate()
	self.cameraManager:AfterUpdate()
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
	--TODO 角色资源卸载先写在这里
	--self.assetsPool.roleAssetMgr:UnLoadAllRole()
	--self.assetsPool:UnLoadAllWeaponPool()
	--self.assetsPool:UnLoadAllOtherPool()
	--self.assetsPool:UnLoadFightPool()
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
	if ctx.IsDebug then
		FightDebugManager.Instance:DeleteMe()
	end
	--AssetManager.UnloadUnusedAssets()
	UnityUtils.GraphicsUnload()
end