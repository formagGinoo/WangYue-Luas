TcpConn = BaseClass("TcpConn",BaseConn)

local socket = require "socket.core"

function TcpConn:__init()
    self.socket = nil
    self.loopConnect = nil

    self.readByteArray = ByteArray.New()
    self.packList = List.New()

    self.try = nil
    self.maxTry = 75
	self.loopTime = 15--次数求余==0的时候重新创建tcp，connect

    self.recvState = nil
    self.needRecvLen = nil
    self.recvLen = nil
    self.recvData = nil
end


function TcpConn:OnConnect()
	--Log("TcpConn:OnConnect")
    local netType = "inet"
    if ctx:IsIpv6() then netType = "inet6" end
   
    self.socket = socket.tcp()
    self.socket:settimeout(0)
    self.socket:connect(self.host,self.port, nil, nil, netType)
    self.try = 0
    self:RemoveConnTimer()
    self.connTimer = LuaTimerManager.Instance:AddTimer(self.maxTry, 0.2, self:ToFunc("LoopConnect"))
end



function TcpConn:LoopConnect()
    if self.state ~= ConnState.connecting then 
        return 
    end

    self.try = self.try + 1
    --Log("尝试连接",self.try)

    local t, infos,err = socket.select({},{self.socket}, 0)
	if err then
		LogError("err "..err)
	end
    local succeed,fail = false,false
    if infos[1] ~= nil then
        local flag = self:Handshake()
        if flag then
            succeed = true
        elseif not flag then
            fail = true
        end
    end

    if succeed then
        self:RemoveConnTimer()
        self:ConnectSucceed()
    elseif self:IsMaxTry() then
        self:RemoveConnTimer()
        self:ConnectFail()
    end
	if self.try % self.loopTime == 0 then
		self:ReCreate()
	end
    if self.try >= self.maxTry then
		self.connTimer = nil
	end
end


function TcpConn:ReCreate()
	Log("ReCreate")
	local netType = "inet"
	if ctx:IsIpv6() then netType = "inet6" end

	self.socket = socket.tcp()
	self.socket:settimeout(0)
	self.socket:connect(self.host,self.port, nil, nil, netType)
end

function TcpConn:RemoveConnTimer()
    if not self.connTimer then return end
    LuaTimerManager.Instance:RemoveTimer(self.connTimer)
    self.connTimer = nil
end

function TcpConn:StopConnect()
    self:RemoveConnTimer()
end

function TcpConn:Handshake()
    Network.ResetOrderId()
	--Log("TcpConn:Handshake")
    self.socket:setoption("keepalive", true)
    --self.socket:setoption("tcp-nodelay", true)
    local byteArry = ByteArray.New()
    byteArry:writeString("---xx---yyyy--zzzzzz---")
    local len,err = self.socket:send(byteArry:getPack())
    return len ~= nil
end

function TcpConn:ConnectFail()
    LogError("连接失败")
    self:SetState(ConnState.none)
    self:NoticeEvent(ConnEvent.connect_fail)
end

function TcpConn:ConnectSucceed()
    --Log("连接成功")
	if Fight.Instance then
		BehaviorFunctions.Resume()
	end
    self:ResetRecv()
    self:SetState(ConnState.connected)
    self:NoticeEvent(ConnEvent.connected)
end

function TcpConn:IsMaxTry()
    return self.try >= self.maxTry
end

function TcpConn:OnSend(bytes)
    if not self.socket or not self:IsConnect() then
        return false
    end
    --Log("OnSend "..bytes)
    local len, err, _ = self.socket:send(bytes)

    if not len then
		Log("send error ")
        self:Disconnect(NetworkDefine.DisconnectType.send_fail)
		--self:OnConnect()
        return false
    else
        return true
    end
end

function TcpConn:OnPopPack()
    return self.packList:PopHead()
end

function TcpConn:OnRecv()
    if not self.socket or not self:IsConnect() then
        return
    end

    if self.recvState == RecvState.header then
        self:RecvHeader()
    elseif self.recvState == RecvState.body then
        self:RecvBody()
    end
end


function TcpConn:RecvHeader()
    local ok = self:RecvData()
    if not ok then return end
    self.readByteArray:setPos(1)
    self.readByteArray:writeBuf(self.recvData)
    self.readByteArray:setPos(1)
    self.needRecvLen = self.readByteArray:readUShort()
    self.recvState = RecvState.body
    self.recvData = ""
end

function TcpConn:RecvBody()
    local ok = self:RecvData()
    if not ok then return end
    self.packList:Push(self.recvData)
    self.recvState = RecvState.header
    self.needRecvLen = NetworkDefine.headerLen
    self.recvData = ""
end

function TcpConn:RecvData()
    local needLen = self.needRecvLen - self.recvLen
    local fullBytes, err, partBytes = self.socket:receive(needLen)

    if not fullBytes and not partBytes then
        LogError("Lua Socket接收数据超时")
        self:Disconnect(NetworkDefine.DisconnectType.recv_fail)
        return false
    end

    if partBytes then
        self.recvData =  self.recvData .. partBytes
        self.recvLen = #self.recvData
        return false
    end

    self.recvData = self.recvData..fullBytes
    self.recvLen = 0
    return true
end

function TcpConn:OnDisconnect()
    Log("Tcp.Disconnect")
    self.socket:close()
    self.socket = nil
    self.packList:Clear()
    self:ResetRecv()
    self:NoticeEvent(ConnEvent.disconnect)
end

function TcpConn:ResetRecv()
    self.recvState = RecvState.header
    self.needRecvLen = NetworkDefine.headerLen
    self.recvLen = 0
    self.recvData = ""
end