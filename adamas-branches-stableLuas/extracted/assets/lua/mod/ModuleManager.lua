-- 模块管理
ModuleManager = BaseClass("ModuleManager")

function ModuleManager:__init()
    if ModuleManager.Instance then
        LogError("不可以对单例对象重复实例化")
        return
    end
    ModuleManager.Instance = self
	-- Connection.New()
    self.preloadManager = nil
end

function ModuleManager:Activate()
    EventMgr.New()
    AssetMgrProxy.New()
    self.preloadManager = PreloadManager.New()
    LanguageManager.New()
    WindowManager.New()
    PanelManager.New()
    ShaderManager.New()
	LuaTimerManager.New()
    PoolManager.New()
	MsgBoxManager.New()
    LoadPanelManager.New()
	CurtainManager.New()
	GmManager.New()
	ItemManager.New()
    Network.New()
    UIDefine.canvasRoot = ctx.CanvasContainer.transform
    SoundManager.New()
    EntityLODManager.New()
    -- GameSetManager.New()
    RedPointMgr.New()
    SystemStateMgr.New()
    Story.New()
    CursorManager.New()
    -- 最后执行
    --LoginManager.New()

    self:InitModule()
	
	if ctx.IsDebug then
		MainDebugManager.New()
		MapListManager.New()
		GameSpeedManager.New()
        -- MapDebugManger.New()
	end
	
	SWBlocking.Init()
    self.preloadManager:Preload(function () self:OnPreloadCompleted() end)
end

function ModuleManager:InitModule()
    for k,v in pairs(ModuleMapping) do 
        local class = _G[k]
		if not class then
			LogError(string.format("无法找到模块入口[模块:%s]",k))
		end
        --assert(class,string.format("无法找到模块入口[模块:%s]",k))
        class.New(class)
    end
    Facade.InitComplete()
end

function ModuleManager:OnPreloadCompleted()
    local wwiseEventBankAsset = self.preloadManager:GetGameObject(AssetConfig.wwiseEventBank, true)
    if not UtilsBase.IsNull(wwiseEventBankAsset) then
        SoundManager.Instance:SetEventAsset(wwiseEventBankAsset)
    else
        LogError("wwiseEventBankAsset null")
    end

    local qualityData = self.preloadManager:GetGameObject(AssetConfig.quality_data, true)
    mod.GameSetCtrl:LoadData(qualityData)

    -- local graphicObject = self.preloadManager:GetGameObject(AssetConfig.graphic, true)
    -- GameObject.DontDestroyOnLoad(graphicObject)
	
    if AssetBatchLoader.UseLocalRes then
        if PlayerPrefs.HasKey("WarmUpDebug") and PlayerPrefs.GetInt("WarmUpDebug") > 0 then 
            CS.EditorAssetLoad.WarmUp()
        end
    end
	--local cb = function()
		--self:Login()
	--end
	--LuaTimerManager.Instance:AddTimer(1,20,cb)
	
	self:Login()
end

function ModuleManager:Release()
end

function ModuleManager:FixedUpdate()
    --SceneManager.Instance:FixedUpdate()
    Network.Instance:Update()
	LuaTimerManager.Instance:Update()
end

function ModuleManager:Login()

    -- 显示登录界面
    --LoginManager.Instance.model:InitMainUI()
    --SceneManager.Instance.sceneModel:InitSceneView()
    -- ctx.LoadingPage:Hide()
    -- NoticeManager.Instance:PreLoad()
    WindowManager.Instance:OpenWindow(LoginWindow)
	--if ctx.IsDebug then
		MainDebugManager.Instance.model:InitMainUI()
	--end
end


function ModuleManager:GotoLogin(isReplace)
    WindowManager.Instance:CloseAllWindow(true)
    PanelManager.Instance:CloseAllPanel(true)
    SoundManager.Instance:StopAllSound()

    if Fight.Instance then
        Fight.Instance:Clear()
    else
        -- WindowManager.Instance:OpenWindow(LoginWindow)
    end

    -- 网络层断开链接
    Network.Instance:Disconnect(NetworkDefine.DisconnectType.return_login)

    -- 模块数据清理
    Facade.ClearModuleData()

    LoadPanelManager.Instance:Hide()
    CurtainManager.Instance:FadeOut(1.5)
    self:Login()
    Story.Instance:Stop()
    CurtainManager.Instance:Start()
end