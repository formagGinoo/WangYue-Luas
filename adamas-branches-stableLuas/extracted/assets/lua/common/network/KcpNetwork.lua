-- kcp网络底层整合
-- Author: lizc
-- Date: 2021-09-28 19:18:06
-- 
KcpNetwork = KcpNetwork or {}

local curProtoId = nil

function KcpNetwork:__init()
    local define = NetworkDefine
    self.conn = BaseConn.Create(ConnType.udp)
    self.sendList = {}
    self.maxSendLen = 3000
    self.maxRecvNum = 10
    self.handlers = {}

    self.tickTimer = nil
    self.lastTickTime = 0

    self.sessionId = 0
    self.kcpMode = KcpMode.fast
    self.rtt = 0
    self.rto = 0

    --kcp是否正在运行
    self.isRunning = false

    --是否立即发送
    self.isSendImmediate = true
    self.conn:SetEvent(KcpConnEvent.disconnect,function() self:ConnDisconnect() end)
end

function KcpNetwork:SetSessionId(session)
    self.sessionId = session
end

function KcpNetwork:SetKcpMode(mode)
    self.kcpMode = mode
end

function KcpNetwork:SetHostAndPort(host, port)
    self.host = host
    self.port = port
end

--统一入口：开启kcp
--如果在连接中，则握手测试
--否则就走完整的连接流程
function KcpNetwork:Go()
    if NetworkDefine.openKcp then
        self.isRunning = true
        if self:IsConnect() then
            self.conn:Handshake()
        else
            Facade.GetCtrl(LoginCtrl):SendMsg(10015)
        end
    end
end

--统一入口：关闭kcp
function KcpNetwork:Stop()
    if NetworkDefine.openKcp then
        self.isRunning = false
        self.conn:Disconnect()
    end
end

function KcpNetwork:Connect()
    print(string.format("KcpNetwork:Connect(host:[%s], port:[%s], session:[%s])", self.host, self.port, self.sessionId))
    if self.sessionId == 0 then
        LogError("KcpNetwork SessionId必须大于0")
        return
    end

    self.conn:Disconnect()
    self.conn.sessionId = self.sessionId
    self.conn.kcpMode = self.kcpMode
    self.conn:Connect(self.host, self.port)
end

function KcpNetwork:OnConnectSucceed()
    self.conn:ConnectSucceed()
end

function KcpNetwork:AddHandler(id,func)
	if self.handlers[id] then
		LogError(string.format("禁止一个消息被多个函数处理[%s]",id))
	end
    --assert(not self.handlers[id],string.format("禁止一个消息被多个函数处理[%s]",id))
    self.handlers[id] = func
end

function KcpNetwork:RemoveHandler(id)
    self.handlers[id] = nil
end

function KcpNetwork:Update()
    if self.isRunning then
        self:SendPack()
        self:RecvPack()
        self:HandlerPack()
    end
end

function KcpNetwork:SendPack()
    local lenCount = 0
    local remove = {}
    local sendFlag = true

    for i,v in ipairs(self.sendList) do
        while v.sendLen < v.maxLen and lenCount < self.maxSendLen do
            local addLen = v.maxLen - v.sendLen
            if lenCount + addLen > self.maxSendLen then addLen = self.maxSendLen - lenCount end

            sendFlag = self.conn:Send(v.byteArray:getPack(v.sendLen + 1,v.sendLen + addLen))
            if not sendFlag then break end

            v.sendLen = v.sendLen + addLen
            lenCount = lenCount + addLen
        end

        if v.sendLen >= v.maxLen then table.insert(remove,i) end
        if lenCount >= self.maxSendLen then break end
    end

    
    if not sendFlag then return end

    for i=#remove,1,-1 do
        local sendInfo = self.sendList[remove[i]]
        self:PushByteArray(sendInfo.id,sendInfo.byteArray)
        table.remove( self.sendList,remove[i])
    end
end

function KcpNetwork:RecvPack()
    self.conn:OnKcpUpdate()
    self.conn:Recv()
end

function KcpNetwork:HandlerPack()
    local recvCount = 0

    while self.maxRecvNum == 0 or recvCount < self.maxRecvNum do
        local pack = self.conn:PopPack()
        if not pack then break end

        local protoId,data = ProtoCodec:Unmarshal(pack)
        curProtoId = protoId
        if NetworkDefine.KCP_DEBUG then
            LogFormat("KcpNetwork ProtoCodec:Unmarshal(protoId:[%s], pack length:[%s])", protoId, #pack)
        end

        local func = self.handlers[protoId]
        if func then xpcall(func,KcpNetwork.PackError, data, protoId) end

        recvCount = recvCount + 1
    end
end

function KcpNetwork.PackError(err)
    LogErrorFormat("处理协议报错[%s]%s",curProtoId,err)
end


function KcpNetwork:Send(id,data)
    if not self.conn:IsConnect() and not self.conn:IsConnecting() then return end
    local byteArray = ProtoCodec:Marshal(id,data)
    if not byteArray then return end

    local sendLen = 0
    local maxLen = byteArray:getAvailable()

    if self.isSendImmediate then
        local lenCount = 0
        local remove = {}
        local sendFlag = true

        while sendLen < maxLen and lenCount < self.maxSendLen do
            local addLen = maxLen - sendLen
            if lenCount + addLen > self.maxSendLen then addLen = self.maxSendLen - lenCount end

            sendFlag = self.conn:Send(byteArray:getPack(sendLen + 1, sendLen + addLen))
            if not sendFlag then break end

            sendLen = sendLen + addLen
            lenCount = lenCount + addLen
        end
    else
        table.insert(self.sendList,{ id = id,sendLen = 0,maxLen = maxLen, byteArray = byteArray })
    end
    if NET_DEBUG then Log("发送消息",id) end
end

function KcpNetwork:ConnDisconnect()
    for i,v in ipairs(self.sendList) do self:PushByteArray(v.id,v.byteArray) end
    self.sendList = {}
end

function KcpNetwork:PushByteArray(id,byteArray)
    if NetworkDefine.NotPushPool[id] then return end
    PoolManager.Instance:Push(PoolType.class,ByteArray.poolKey,byteArray)
end

function KcpNetwork:Disconnect(err)
    LogColorFormat("KcpNetwork:Disconnect(%s)", tostring(err))
    if not err then err = NetworkDefine.DisconnectType.initiative end
    self.conn:Disconnect(err)
end

function KcpNetwork:SetEvent(event,callBack)
    self.conn:SetEvent(event,callBack)
end

function KcpNetwork:QueryState()
    Log("网络连接状态",self.conn:GetState())
end

function KcpNetwork:IsConnect()
    if NetworkDefine.openKcp then
        return self.conn:IsConnect()
    end
    return false
end

KcpNetwork:__init()