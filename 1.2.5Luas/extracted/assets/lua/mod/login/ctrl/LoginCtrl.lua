LoginCtrl = BaseClass("LoginCtrl",Controller)

function LoginCtrl:__init()
    -- self.lastHeartbeatTime = nil
    self.loginState = GameConfig.LoginState.Begin
	self.clientCmdEvent = {}

	self.loginMapId = nil
	self.loginMapPos = nil
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
    self.loginState = GameConfig.LoginState.ConSocket
	self.host = targetServer.host
	self.port = targetServer.port
    Network.Instance:Connect(self.host, self.port)
    --Connection.Instance:Connect(targetServer.host, targetServer.port)
end

function LoginCtrl:InitSystemMods()
    -- todo初始化系统模块
    mod.LoginFacade:SendMsg("role_init")
end

function LoginCtrl:OnConnected()
    if self.loginState >= GameConfig.LoginState.ConLogin then
        return
    end
	
	if self.tips then
		MsgBoxManager.Instance:ShowTips(TI18N("连接服务器成功"), 0.5)
		self.tips = nil
	end

    self.loginState = GameConfig.LoginState.ConLogin
    mod.LoginFacade:SendMsg("client_login",self.account,os.time())
    Network.Instance:StartTick()
end

function LoginCtrl:ConnectFail()
	if self.tips then
		MsgBoxManager.Instance:HideMsgBox(self.tips)
		self.tips = nil
	end
	
    if self.loginState < GameConfig.LoginState.LoginSuc then
        self.loginState = GameConfig.LoginState.Begin
        MsgBoxManager.Instance:ShowTextMsgBox(TI18N("服务器连接失败"),self:ToFunc("ExitFight"))
    end

    EventMgr.Instance:Fire(EventName.LoginFail)
end

function LoginCtrl:ExitFight()
	BehaviorFunctions.SetSceneObjectLoadPause(false)
	Network.Instance:Disconnect(5)

	if Fight.Instance then
		Fight.Instance:Clear()
	end

	WindowManager.Instance:OpenWindow(LoginWindow)
	-- Network.Instance:Disconnect(5)
end

function LoginCtrl:OnDisconnect()
	--TODO:重连
	--MsgBoxManager.Instance:ShowTextMsgBox(TI18N("服务器连接断开"), self.OnConfirm)
	--self.loginState = GameConfig.LoginState.Begin
	self:TryReconnect()
end

function LoginCtrl:TryReconnect()
	Log("TryReconnet")
	self.loginState = GameConfig.LoginState.ConSocket
	MsgBoxManager.Instance:ShowTips(TI18N("失去连接，正在重连。"), 0.5)
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
		LogError("协议orderId已被监听:".. id)
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
		LogError("协议orderId未被监听:".. id)
	end
end

function LoginCtrl:ClientCmdEvent(id, cmd, noticeCode)
	if self.clientCmdEvent[id] and self.clientCmdEvent[id].cmd then
		if cmd ~= self.clientCmdEvent[id].cmd then
			LogError("回包cmd不一致")
		else
			self.clientCmdEvent[id].func(noticeCode)
		end
	else
		LogError(string.format("通用回包未处理: orderId = %s, protoId = %s, noticeCode = %s", id, cmd, noticeCode))
	end
	self:RemoveClientCmdEvent(id)
	if noticeCode ~= 0 then
		LogError(string.format("协议处理失败 orderId = %s, protoId = %s, noticeCode = %s", id, cmd, noticeCode))
	end
end