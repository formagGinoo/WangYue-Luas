-- lus 入口 223

GameLuaStart = SingleClass("GameLuaStart")
local _timer = Timer
local _assetBatchLoader = AssetBatchLoader
local _timeUtils = TimeUtils
local _fight = Fight
local _windowManager = WindowManager
local _panelManager = PanelManager
local _eventMgr = EventMgr
local _eventName = EventName
function GameLuaStart:__init()
    self.moduleManager = ModuleManager.New()
end

function GameLuaStart:Start()
    QualitySettings.vSyncCount = 1
	print("GameLuaStart:Start()")
	if ctx.Editor or ctx.WindowPlayer then
		Application.targetFrameRate = 60
	else
		Application.targetFrameRate = 30
	end

	
	--print(abc)
    self:OpenLogView()
	----[[
    --if Application.platform == RuntimePlatform.Android then
        --Application.targetFrameRate = 45
    --else
        --Application.targetFrameRate = 60
    --end
	--Application.targetFrameRate = 60
	----]]
	--Application.targetFrameRate = FightUtil.targetFrameRate
    --Time.fixedDeltaTime = 1/Application.targetFrameRate--FightUtil.deltaTimeSecond
	--QualitySettings.skinWeights = SkinWeights.OneBone
	--QualitySettings.antiAliasing = 0
	--QualitySettings.anisotropicFiltering = AnisotropicFiltering.Disable
    --ctx.MainCamera.useOcclusionCulling = false
    --ctx.UICamera.nearClipPlane = -15
    if ctx.IsDebug then
        IS_DEBUG = true
    else
        --Log.SetLev(3) -- Info
        IS_DEBUG = false
    end

    if ctx.Editor then
		local luadDebugStr = "  调试模式开启: " ..tostring(PlayerPrefs.GetInt("LuaDebuggee") > 0)
        Logf("本地资源模式: " ..tostring(PlayerPrefs.GetInt("UseLocalRes") > 0)..luadDebugStr)
        if LogObject then
            LogObject:SetActive(true)
        end
		CS.AssetStrategyManager.Initialize()
    else 
        if LogObject then
            LogObject:SetActive(IS_DEBUG)
        end
    end

    --是否使用lua解析proto(默认不用)
    -- ctx.ProtocolDispatcher.IsUseLuaParser = false
    --使用此全局变量理论上减少开销
    -- IS_USE_LUA_PARSER = ctx.ProtocolDispatcher.IsUseLuaParser

    self.moduleManager:Activate()
	_eventMgr.Instance:Fire(_eventName.end_mgr_init)
end 

function GameLuaStart:FixedUpdate()
    --SP("发顺丰第三方的")
    self.moduleManager:FixedUpdate()
    --SP()

    if Timer.Instance then
        Timer.Instance:FixedUpdate()
    end

end

Global.lowUpdateTime = 0
function GameLuaStart:Update()
    Global.deltaTime = Time.unscaledDeltaTime * Time.timeScale

    if _timeUtils.serverTime then
		_timeUtils.timeOffset = _timeUtils.timeOffset + Time.unscaledDeltaTime
    end

    if Fight.Instance then
		Fight.Instance:Update()
	end

	_windowManager.Instance:Update()
	_panelManager.Instance:Update()
    Story.Instance:Update()
	
    self:LowUpdate()
	_eventMgr.Instance:Fire(_eventName.UnityUpdate)

    AssetMgrProxy.Instance:Update()
    CurtainManager.Instance:Update()
    if TipQueueManger.Instance then
        TipQueueManger.Instance:Update() 
    end
end

local LOW_UPDATE_INTERVAL = 0.1
function GameLuaStart:LowUpdate()
    Global.lowUpdateTime = Global.lowUpdateTime + Global.deltaTime    
    if Global.lowUpdateTime >= LOW_UPDATE_INTERVAL then
		_windowManager.Instance:LowUpdate()
		_panelManager.Instance:LowUpdate()

        if Fight.Instance then
			Fight.Instance:LowUpdate()
        end

        Global.lowUpdateTime = 0
    end
end

function GameLuaStart:OpenLogView()
    local logObj = Resources.Load("log/log_view")
    if logObj then
        local logView = GameObject.Instantiate(logObj)
        GameObject.DontDestroyOnLoad (logView)
        LogObject = logView
        _G.LogView = logView
    end
end


--function SP(key)
    --if key then
        --Profiling.Profiler.BeginSample(key)
    --else
        --Profiling.Profiler.EndSample()
    --end   
--end

--return GameLuaStart



