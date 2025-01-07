LoginCtrl = BaseClass("LoginCtrl",Controller)
local ptDefine = require("data/proto/pt_define")
function LoginCtrl:__init()
    -- self.lastHeartbeatTime = nil
	self:SetLoginState(GameConfig.LoginState.Begin)
	self.clientCmdEvent = {}

	self.loginMapId = nil
	self.loginMapPos = nil

	self.playerProperty = {}
	self.isLogin = false

	self.cacheList = {}
end

function LoginCtrl:__delete()

end

function LoginCtrl:__InitComplete()
    --EventMgr.Instance:AddListener(EventName.socket_connect, self:ToFunc("OnConnected"))
    Network.Instance:SetEvent(ConnEvent.connected,self:ToFunc("OnConnected"))
    Network.Instance:SetEvent(ConnEvent.connect_fail,self:ToFunc("ConnectFail"))
    Network.Instance:SetEvent(ConnEvent.disconnect,self:ToFunc("OnDisconnect"))
end

function LoginCtrl:SetLoginState(state)
    self.loginState = state
end

function LoginCtrl.IsInGame()
    return mod.LoginCtrl.loginState == GameConfig.LoginState.InGame
end

-- 登录游戏服务器处理
function LoginCtrl:DoLogin(account, targetServer)
    if self.loginState ~= GameConfig.LoginState.Begin then
        --return
    end
	
	self.tips = MsgBoxManager.Instance:ShowTips(TI18N("连接中..."), 5)

	self.account = account
    mod.LoginProxy.account = account
    mod.LoginProxy.targetServer = targetServer
	self:SetLoginState(GameConfig.LoginState.ConSocket)
	self.host = targetServer.host
	self.port = targetServer.port
    Network.Instance:Connect(self.host, self.port)

	self:RequestAnnouncementsList()
    --Connection.Instance:Connect(targetServer.host, targetServer.port)
end

-- 登录游戏服务器处理
function LoginCtrl:DoSDKLogin(data, targetServer)
	if self.loginState ~= GameConfig.LoginState.Begin then
		--return
	end

	self.tips = MsgBoxManager.Instance:ShowTips(TI18N("连接中..."), 5)
	LogTable("DoSDKLogin ",data)
	self.account = data.account_id
	self.sdkdata = data
	self:SetAge(tonumber(self.sdkdata.age))
	self:SetLoginData(data)
	mod.LoginProxy.account = self.account
	mod.LoginProxy.targetServer = targetServer
	self:SetLoginState(GameConfig.LoginState.ConSocket)
	self.host = targetServer.host
	self.port = targetServer.port
	Network.Instance:Connect(self.host, self.port)

	self:RequestAnnouncementsList()
	--Connection.Instance:Connect(targetServer.host, targetServer.port)
end

function LoginCtrl:RequestAnnouncementsList()
	-- 通过渠道请求最新的公告内容
	mod.AnnouncementCtrl:RequestAnnouncementsList()
end

function LoginCtrl:InitSystemMods()
    -- todo初始化系统模块
    local id, cmd = mod.LoginFacade:SendMsg("role_init")
	self:AddClientCmdEvent(id, cmd, self:ToFunc("RoleInit"))
end

function LoginCtrl:RoleInit()
	self:SetLoginState(GameConfig.LoginState.InGame)
	MsgBoxManager.Instance:ShowTips(TI18N("登录成功"), 1)
    --mod.FormationCtrl:UpdateAllFormationExtraInfo()
    mod.WorldMapCtrl:EnterMap(nil, nil, nil, nil, true)

    if AssetBatchLoader.UseLocalRes then
        local reportSVListA = CS.EditorAssetLoad.GetReportSVlist()
		local reportSVList = {}
        for i = 0, reportSVListA.Count - 1 do
            table.insert(reportSVList, reportSVListA[i].."\n")
        end

        -- print("reportSVList count "..#reportSVList)

        while (#reportSVList > 100) do
            local sendList = {}
            for i = 1, 100 do    
                table.insert(sendList, reportSVList[1])
                table.remove(reportSVList, 1)
            end

            mod.LoginFacade:SendMsg("client_file_record", sendList)
        end

        if #reportSVList > 0 then
            mod.LoginFacade:SendMsg("client_file_record", reportSVList)
        end
    end
    EventMgr.Instance:Fire(EventName.RoleInit)
end

function LoginCtrl:AnalyzeSDKLoginData(data)
	local loginData

end

function LoginCtrl:GMSetChannelId(channelId)
	PlayerPrefs.SetString("LoginCtrlGMChannelId", tostring(channelId))
	PlayerPrefs.Save()
	self:RequestAnnouncementsList()
end

function LoginCtrl:GetGMChannelId()
	return PlayerPrefs.GetString("LoginCtrlGMChannelId")
end

function LoginCtrl:GetChannelId()
	if mod.LoginCtrl.useSDKLogin and Global.useSDK then
		return self.sdkdata.channel_id
	end

	local GMChannelId = self:GetGMChannelId()
	return GMChannelId or ""
end

function LoginCtrl:OnConnected()
    if self.loginState >= GameConfig.LoginState.ConLogin then
        return
    end

	if self.tips then
		MsgBoxManager.Instance:ShowTips(TI18N("连接服务器成功"), 2)
		self.tips = nil
	end

	self:SetLoginState(GameConfig.LoginState.ConLogin)
	self:SetIsLogin(false)
	if mod.LoginCtrl.useSDKLogin and Global.useSDK then
		mod.LoginFacade:SendMsg("client_login",self.sdkdata,os.time())
	else
    	mod.LoginFacade:SendMsg("client_login",self.account,os.time())
	end
    Network.Instance:StartTick()
end

function LoginCtrl:ConnectFail()
	if self.tips then
		MsgBoxManager.Instance:HideMsgBox(self.tips)
		self.tips = nil
	end

    if self.loginState < GameConfig.LoginState.LoginSuc then
		CurtainManager.Instance:Stop()
		Network.Instance:Disconnect(NetworkDefine.DisconnectType.return_login)
		self:SetLoginState(GameConfig.LoginState.Begin)
        local msg = MsgBoxManager.Instance:ShowTextMsgBox(TI18N("服务器连接失败"),self:ToFunc("ExitFight"))
		msg:HideCloseBtn()
    end

    EventMgr.Instance:Fire(EventName.LoginFail)
	self:ConnectEnd()
end

function LoginCtrl:ConnectEnd()
	if Fight.Instance then
		self.fightReconnection = false
		CurtainManager.Instance:ExitWait()
		BehaviorFunctions.Resume()
		BehaviorFunctions.StoryResumeDialog()
	end
end

function LoginCtrl:ExitFight()
	self.fightReconnection = false
	ModuleManager.Instance:GotoLogin()
end

function LoginCtrl:OnDisconnect()
	--在请求登录数据时，直接走弹窗返回登录页
	if self.loginState == GameConfig.LoginState.ConLogin or not Fight.Instance or not Fight.Instance:IsFighting() then
		CurtainManager.Instance:Stop()
		Network.Instance:Disconnect(NetworkDefine.DisconnectType.return_login)
		local msg = MsgBoxManager.Instance:ShowTextMsgBox(TI18N("服务器连接失败"), function()
			self:ConnectEnd()
			self:ExitFight()
		end)
		msg:HideCloseBtn()
		return
	end
	--TODO:重连
	if Fight.Instance and not self.fightReconnection then
		self.fightReconnection = true
		CurtainManager.Instance:EnterWait(SystemConfig.WaitType.Immediately)
		BehaviorFunctions.Pause()
		BehaviorFunctions.StoryPauseDialog()
	end
	self:TryReconnect()
end

function LoginCtrl:TryReconnect()
	self:SetLoginState(GameConfig.LoginState.ConSocket)
	MsgBoxManager.Instance:ShowTips(TI18N("重新连接服务器"), 2)
	Network.Instance:Connect(self.host, self.port)
end

function LoginCtrl.OnConfirm()
	WindowManager.Instance:CloseAllWindow()
	if Fight.Instance and Fight.Instance.fightState ~= FightEnum.FightState.None then
		Fight.Instance:SetFightState(FightEnum.FightState.Exit)
	end
	WindowManager.Instance:OpenWindow(LoginWindow)
end

function LoginCtrl:AddClientCmdEvent(id, cmd, func)
	self.clientCmdEvent[id] = self.clientCmdEvent[id] or {}
	if self.clientCmdEvent[id].cmd then
		local res = "监听协议未处理：%s, 无法监听新协议：%s"
		local oldCmd = ptDefine.MSG_NAME[self.clientCmdEvent[id].cmd]
		LogErrorf(res, oldCmd, ptDefine.MSG_NAME[cmd])
	else
		self.clientCmdEvent[id].cmd = cmd
		self.clientCmdEvent[id].func = func
	end
end

function LoginCtrl:RemoveClientCmdEvent(id, cmd)
	self.clientCmdEvent[id] = self.clientCmdEvent[id] or {}
	if self.clientCmdEvent[id].cmd then
		TableUtils.ClearTable(self.clientCmdEvent[id])
	else
		Log("协议未被监听:".. ptDefine.MSG_NAME[cmd])
	end
end

function LoginCtrl:ClientCmdEvent(id, cmd, noticeCode, module, line, args)
	if self.clientCmdEvent[id] and self.clientCmdEvent[id].cmd then
		if cmd ~= self.clientCmdEvent[id].cmd then
			local oldName = ptDefine.MSG_NAME[self.clientCmdEvent[id].cmd]
			local newName = ptDefine.MSG_NAME[cmd]
			LogErrorf("回包监听协议不一致,监听：%s，回应：%s", oldName, newName)
		else
			self.clientCmdEvent[id].func(noticeCode)
		end
	end
	self:RemoveClientCmdEvent(id,cmd)

	if noticeCode ~= 0 then
		local res = Config.DataErrorCode.data_error_code[noticeCode]
		res = res or noticeCode
		LogError(string.format("协议处理失败 orderId = %s, protoName = %s, noticeCode = %s, module = %s, line = %s, args = %s", id, ptDefine.MSG_NAME[cmd], res, module, line, args))
	end
end

function LoginCtrl:SetLoginData(data)
	self.loginData = data
end

function LoginCtrl:GetLoginData()
	return self.loginData or {}
end

function LoginCtrl:SetAge(age)
	self.age = age
end

function LoginCtrl:GetAge()
	return self.age or 0
end

function LoginCtrl:GetPing()
	if not self.pingStart or not self.pingEnd then
		return
	end
	return math.floor((self.pingEnd - self.pingStart) * 1000)
end

function LoginCtrl:SyncRoleProperty(propertyList)
	local id, cmd = mod.LoginFacade:SendMsg("role_property_sync", propertyList)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(noticeCode)
		if noticeCode == 0 then
			self.tempPlayerProertyList = {}
		end
    end)
end

function LoginCtrl:UpdatePlayerPropertyList(data)
	self.playerPropertyList = self.playerPropertyList or {}
	for key, value in pairs(data.property_maps) do
		if FightEnum.PlayerSyncAttr[key] then
			self.playerPropertyList[key] = value * 0.0001
		else
			self.playerPropertyList[key] = value
		end
	end
	EventMgr.Instance:Fire(EventName.PlayerPropertyChange)
end

function LoginCtrl:SetPlayerSyncPropery()
	if not self.isLogin or not self.IsInGame()then
		return
	end
	self.playerPropertyList = self.playerPropertyList or {}
	self.tempPlayerProertyList = UtilsBase.copytab(self.playerPropertyList)
	for id, _ in pairs(FightEnum.PlayerSyncAttr) do
		local value = BehaviorFunctions.GetPlayerAttrValueAndMaxValue(id)
		self.playerPropertyList[id] = value
		if FightEnum.PlayerSyncAttr[id] then
			self.tempPlayerProertyList[id] = math.floor(value * 10000)
		end
	end
	self:SyncRoleProperty(self.tempPlayerProertyList)
end

function LoginCtrl:GetPlayerPropertyValueById(id)
	if not self.isLogin or not self.IsInGame()then
		local value = BehaviorFunctions.fight.playerManager:GetPlayer().fightPlayer:GetAttrValue(FightEnum.PlayerAttrToMaxType[id])
		return value or 0
	end
	self.playerPropertyList = self.playerPropertyList or {}
	return self.playerPropertyList[id] or 0
end

function LoginCtrl:SetIsLogin(state)
	self.isLogin = state
end

function LoginCtrl:RoleKickOffline(type, context, resVersion)
	if type == SystemConfig.KickOfflineType.AssetUpdate then
		if AssetBatchLoader.UseLocalRes then
			return
		end
	end
	BehaviorFunctions.Pause()
	CurtainManager.Instance:Stop()
	Network.Instance:Disconnect(NetworkDefine.DisconnectType.return_login)
	local func = function()
		if type == SystemConfig.KickOfflineType.AssetUpdate then
			Application.Quit();
		else
			self:SetIsLogin(false)
			self:SetLoginState(GameConfig.LoginState.Begin)
			ModuleManager.Instance:GotoLogin(true)
		end
	end
	if type == SystemConfig.KickOfflineType.RepeatLogIn then
		context = TI18N("账号已经在其他设备登录，此设备账号被强制下线")
	end
	local msg = MsgBoxManager.Instance:ShowTextMsgBox(context, func, nil, func)
	msg:HideCloseBtn()
	if type == SystemConfig.KickOfflineType.AssetUpdate then
		msg:SetSubmitText(TI18N("退出游戏"))
	end
end

function LoginCtrl:UpdateCacheList(data)
	local info = data.cache_list
	for k, v in pairs(info) do
		self.cacheList[v.cache_key] = v.cache_value[1]
	end
end

function LoginCtrl:GetCacheList()
	return self.cacheList or {}
end

function LoginCtrl:GetCacheListByKey(key)
	return self.cacheList[key]
end

function LoginCtrl:CacheClientData(list)
	local sendList = {}
	-- sendList.cache_list = {}
	list = list or {}
	for k, v in pairs(list) do
		table.insert(sendList, {cache_key = tostring(k), cache_value = {tostring(v)}})
	end
	mod.LoginFacade:SendMsg("client_cache_list", sendList)
end

LoginCtrl.ReconnectReload = true

function LoginCtrl:ClientLogin(data)
	self:ConnectEnd()
	TimeUtils.serverTime = data.server_timestamp / 1000
    TimeUtils.timeOffset = 0
    TimeUtils.timezone = data.timezone

    if data.uid then
        mod.InformationCtrl:SetUID(data.uid)
    end
	if data.flag then
		self:SetLoginState(GameConfig.LoginState.LoginSuc)
	else
		self:SetLoginState(GameConfig.LoginState.Begin)
		EventMgr.Instance:Fire(EventName.LoginFail)
		local msg = MsgBoxManager.Instance:ShowTextMsgBox(TI18N("登录失败"),self:ToFunc("ExitFight"))
		msg:HideCloseBtn()
	end
	if Fight.Instance and LoginCtrl.ReconnectReload then
		if LoginCtrl.ReconnectReload and not ctx.Editor then
			WindowManager.Instance:CloseAllWindow(true)
			PanelManager.Instance:CloseAllPanel(true)
			SoundManager.Instance:StopAllSound()
			Fight.Instance:Clear()
			Story.Instance:Stop()
			Facade.ClearModuleData()
		else
			return
		end
	end

	LoadPanelManager.Instance:Show(SystemConfig.LoadingPageType.Login)
	LoadPanelManager.Instance:Progress(0)

    if data.flag then
        self:InitSystemMods()
    end
end