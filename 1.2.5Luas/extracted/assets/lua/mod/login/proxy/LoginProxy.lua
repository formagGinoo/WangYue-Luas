LoginProxy = BaseClass("LoginProxy",Proxy)

function LoginProxy:__init()
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
end

function LoginProxy:Send_client_login(account,ts)
    --Log("发送客户端登录")

    -- 延迟刷新红点状态（等待玩家数据全部获取完）
    RedPointMgr.Instance:DelayRefreshRedState()

    local data = {}
    data.account = account
    data.ts = ts
    return data
end

--1011
function LoginProxy:Recv_client_login(data)
    --Log("接收客户端登录 "..tostring(data.flag))
    TimeUtils.serverTime = data.server_timestamp / 1000
    TimeUtils.timezone = data.timezone
	if Fight.Instance then
		MsgBoxManager.Instance:ShowTips(TI18N("重连成功！"), 0.5)
        mod.LoginCtrl:SetLoginState(GameConfig.LoginState.InGame)
        -- if not mod.LoginCtrl:IsInGame() then
        --     mod.LoginCtrl:SetLoginState(GameConfig.LoginState.LoginSuc)
        --     mod.LoginCtrl:InitSystemMods()
        -- end
		return
	end

    if data.flag then
        mod.LoginCtrl:SetLoginState(GameConfig.LoginState.LoginSuc)
        mod.LoginCtrl:InitSystemMods()
    else
        mod.LoginCtrl:SetLoginState(GameConfig.LoginState.Begin)
        Log(data.msg)
        MsgBoxManager.Instance:ShowTextMsgBox("登录失败："..data.msg)
        EventMgr.Instance:Fire(EventName.LoginFail)
    end
end

function LoginProxy:Send_client_file_record(rec_list)
    local data = {}
    data.rec_list = rec_list
    return data
end

--2002
function LoginProxy:Recv_role_init(data)
    -- 玩家数据接受完，开始刷新红点状态
    RedPointMgr.Instance:StartDelayRefresh()

    --Log("接收客户端初始化")
    mod.LoginCtrl:SetLoginState(GameConfig.LoginState.InGame)
	MsgBoxManager.Instance:ShowTips(TI18N("登录成功"), 1)
    --mod.FormationCtrl:UpdateAllFormationExtraInfo()
    mod.WorldMapCtrl:EnterMap()

     if AssetBatchLoader.UseLocalRes then
        CS.EditorAssetLoad.VariantCollect()
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
end

function LoginProxy:Recv_client_cmd(data)
    mod.LoginCtrl:ClientCmdEvent(data.order_id, data.cmd, data.notice_code)
end