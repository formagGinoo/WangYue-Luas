LoginProxy = BaseClass("LoginProxy",Proxy)

function LoginProxy:__init()
    self.playerProperty = {}
    self.account = ""
    self.targetServer = ""
end

function LoginProxy:__InitProxy()
    self:BindMsg("heartbeat") --心跳包
    self:BindMsg("client_login")
    --self:BindMsg(2001) --初始化系统
    self:BindMsg("role_init") --
    self:BindMsg("client_file_record")
    self:BindMsg("client_cmd")
    --self:BindMsg("client_replace")
    self:BindMsg("role_property")
    self:BindMsg("role_property_sync")
    self:BindMsg("role_kick_offline")
    self:BindMsg("client_cache_list")
end

function LoginProxy:__InitComplete()
end

--1001
function LoginProxy:Send_heartbeat(time)
    return {client_time = time}
end

--1002
function LoginProxy:Recv_heartbeat(data)
    UtilsBase.Time = data.server_time
    mod.LoginCtrl.lastHeartbeatTime = os.time()
    mod.LoginCtrl.pingEnd = os.clock()
end

function LoginProxy:Send_client_login(account,ts)
    --Log("发送客户端登录")
    local data = {}
    data.account = account
    data.ts = ts
    data.age = 0 -- 成年人
    data.platfrom = mod.LoginProxy.targetServer.platform
    data.zone_id = mod.LoginProxy.targetServer.zone_id
    data.channel_reg = mod.LoginProxy.targetServer.zone_id
    -- 延迟刷新红点状态（等待玩家数据全部获取完）
    --RedPointMgr.Instance:DelayRefreshRedState()
    if mod.LoginCtrl.useSDKLogin and Global.useSDK then
		local sdkdata = account
		if sdkdata then
			data.account = sdkdata.account_id
            data.sdk_account = sdkdata.account_id
            data.age = sdkdata.age
            data.ticket = sdkdata.tick
            data.os_type = sdkdata.os_type
            data.channel_reg = sdkdata.channel_id
		end
    else
        local platform = Application.platform
        if platform == RuntimePlatform.WindowsEditor or Application.platform == RuntimePlatform.WindowsPlayer then
            data.os_type = 3
        elseif platform == RuntimePlatform.Android then
            data.os_type = 1
        elseif platform == RuntimePlatform.IPhonePlayer then
            data.os_type = 2 
        end
	end
    data.version = 0
    if not AssetBatchLoader.UseLocalRes then
        data.version = tonumber(ctx.RemoteResVersion)
    else
        data.os_type = 0
    end
    
    --LogTable("Send_client_login", data)
    mod.LoginCtrl:SetAge(data.age)
    return data
end

--1011
function LoginProxy:Recv_client_login(data)
    mod.LoginCtrl:ClientLogin(data)
    --Log("接收客户端登录 "..tostring(data.flag))
end

function LoginProxy:Recv_client_replace()
    --ModuleManager.Instance:GotoLogin(true)
end

function LoginProxy:Send_client_file_record(rec_list)
    local data = {}
    data.rec_list = rec_list
    return data
end

--2002
function LoginProxy:Recv_role_init(data)

    -- 玩家数据接受完，开始刷新红点状态
    --RedPointMgr.Instance:StartDelayRefresh()

    --Log("接收客户端初始化")
    mod.LoginCtrl:SetLoginState(GameConfig.LoginState.InGame)
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

function LoginProxy:Recv_client_cmd(data)
    mod.LoginCtrl:ClientCmdEvent(data.order_id, data.cmd, data.notice_code, data.module, data.line, data.args)
end

function LoginProxy:Recv_role_property(data)
    mod.LoginCtrl:UpdatePlayerPropertyList(data)
end

function LoginProxy:Send_role_property_sync(maps)
    return {property_maps = maps}
end

function LoginProxy:Recv_role_kick_offline(data)
    mod.LoginCtrl:RoleKickOffline(data.kick_type, data.kick_context, data.version)
end

function LoginProxy:Send_client_cache_list(cache)
    return {cache_list = cache}
end

function LoginProxy:Recv_client_cache_list(data)
    mod.LoginCtrl:UpdateCacheList(data)
end