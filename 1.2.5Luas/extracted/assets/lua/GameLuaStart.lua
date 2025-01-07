-- lus 入口 223

GameLuaStart = SingleClass("GameLuaStart")

function GameLuaStart:__init()
    self.moduleManager = ModuleManager.New()
end

function GameLuaStart:Start()
	print("GameLuaStart:Start()")
	if ctx.Editor then
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

    if ctx.Editor and LogObject then
        LogObject:SetActive(true)
    elseif LogObject then
        LogObject:SetActive(IS_DEBUG)
    end

    --是否使用lua解析proto(默认不用)
    -- ctx.ProtocolDispatcher.IsUseLuaParser = false
    --使用此全局变量理论上减少开销
    -- IS_USE_LUA_PARSER = ctx.ProtocolDispatcher.IsUseLuaParser

    self.moduleManager:Activate()
    EventMgr.Instance:Fire(EventName.end_mgr_init)
end

function GameLuaStart:FixedUpdate()
    --SP("发顺丰第三方的")
    self.moduleManager:FixedUpdate()
    --SP()

    if Timer.Instance then
        Timer.Instance:FixedUpdate()
    end

end

Global = {}
Global.lowUpdateTime = 0
function GameLuaStart:Update()
    Global.deltaTime = Time.unscaledDeltaTime * Time.timeScale

    if TimeUtils.serverTime then
        TimeUtils.timeOffset = TimeUtils.timeOffset + Time.unscaledDeltaTime
    end

    if Fight.Instance then
		Fight.Instance:Update()
	end

    WindowManager.Instance:Update()
    PanelManager.Instance:Update()

    self:LowUpdate()
    EventMgr.Instance:Fire(EventName.UnityUpdate)
end

local LOW_UPDATE_INTERVAL = 0.1
function GameLuaStart:LowUpdate()
    Global.lowUpdateTime = Global.lowUpdateTime + Global.deltaTime    
    if Global.lowUpdateTime >= LOW_UPDATE_INTERVAL then
        WindowManager.Instance:LowUpdate()
        PanelManager.Instance:LowUpdate()

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



