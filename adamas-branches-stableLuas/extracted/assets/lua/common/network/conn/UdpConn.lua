UdpConn = BaseClass("UdpConn",BaseConn)

local LKcp = require "lkcp"
local LUtil = require "lutil"

function UdpConn:__init()
    self.socket = nil
    self.loopConnect = nil

    self.readByteArray = ByteArray.New()
    self.packList = List.New()

    self.try = nil
    self.maxTry = 5

    self.recvState = nil
    self.needRecvLen = nil
    self.recvLen = nil
    self.recvData = nil
end


function UdpConn:OnConnect()
    if ctx:IsIpv6() then
        socket.udp6()
    else
        socket.udp4()
    end
   
    self.socket = socket.udp()
    self.socket:setpeername(self.host, self.port)
    self.socket:settimeout(0)

    self.kcpConn = LKcp.lkcp_create(self.sessionId, function (buff) self:OnKcpSend(buff) end)

    self:SetKcpMode()
    self:ResetRecv()

    self.try = 0
    self:RemoveConnTimer()
    local interval = 1

    self:Handshake()
    self.connTimer = TimerManager.Instance:AddTimer(self.maxTry, interval, self:ToFunc("CheckConnect"))
end

function UdpConn:SetKcpMode()
    --配置窗口大小：平均延迟200ms，每20ms发送一个包，
    --而考虑到丢包重发，设置最大收发窗口为128
    self.kcpConn:lkcp_wndsize(128, 128)

    if self.kcpMode == KcpMode.default then
        --默认模式
        self.kcpConn:lkcp_nodelay(0, 10, 0, 0)
    elseif self.kcpMode == KcpMode.common then
        --普通模式，关闭流控等
        self.kcpConn:lkcp_nodelay(0, 10, 0, 1)
    else
        --启动快速模式
        --第二个参数 nodelay-启用以后若干常规加速将启动
        --第三个参数 interval为内部处理时钟，默认设置为 10ms
        --第四个参数 resend为快速重传指标，设置为2
        --第五个参数 为是否禁用常规流控，这里禁止
        self.kcpConn:lkcp_nodelay(1, 10, 2, 1)
    end

    --设置rto为10ms
    self.kcpConn:lkcp_setrto_direct(10)
end

function UdpConn:CheckConnect()
    if self.state ~= ConnState.connecting then return end

    self.try = self.try + 1
    Log("Udp尝试连接[%s]", self.try)

    --如果大于一定的时间还连不上，直接判断无法连接udp
    if self.try >= self.maxTry then
        self:RemoveConnTimer()
        self:ConnectFail()
    end
end

function UdpConn:RemoveConnTimer()
    if not self.connTimer then return end
    TimerManager.Instance:RemoveTimer(self.connTimer)
    self.connTimer = nil
end

function UdpConn:Disconnect(err)
    Log("UdpConn已断开,error:", err)
    if err == NetworkDefine.DisconnectType.return_login and self.state == ConnState.connecting then
        self.state = ConnState.none
        self:StopConnect()
      
        self:NoticeEvent(KcpConnEvent.cancel_connect,err)
        return
    end

    --if self.state ~= ConnState.connected then return end
    
    self.state = ConnState.none
    self:OnDisconnect()

    self:NoticeEvent(KcpConnEvent.disconnect,err)
end

function UdpConn:StopConnect()
    self:RemoveConnTimer()
end

function UdpConn:Handshake()
    Log("kcp连接握手中")
    Facade.GetCtrl(LoginCtrl):SendKcpMsg(10016)
end

function UdpConn:ConnectFail()
    Log("UdpConn连接失败")
    self:SetState(ConnState.none)
    self:NoticeEvent(KcpConnEvent.connect_fail)
end

function UdpConn:ConnectSucceed()
    Log("UdpConn连接成功")
    self:RemoveConnTimer()
    self:ResetRecv()
    self:SetState(ConnState.connected)
    self:NoticeEvent(KcpConnEvent.connected)
end

function UdpConn:IsMaxTry()
    return self.try >= self.maxTry
end

function UdpConn:OnKcpSend(bytes)
    if NetworkDefine.KCP_DEBUG then
        LogFormat("UdpConn:OnKcpSend发送字节数量：%s", string.len(bytes))
    end
    local len, err, _ = self.socket:send(bytes)
    if len == nil then
        LogColorFormat("udp[%s:%s]发送失败,Msg[%s]", self.host,self.port, tostring(err))
        self:Disconnect(NetworkDefine.DisconnectType.send_fail)
        return false
    end
    return true
end

function UdpConn:OnSend(bytes)
    if not self:IsConnecting() and not self:IsConnect() then
        return false
    end
    
    local ret = self.kcpConn:lkcp_send(bytes)
    self.kcpConn:lkcp_flush()
    return ret >= 0
end

function UdpConn:OnPopPack()
    return self.packList:PopHead()
end

function UdpConn:OnRecv()
   if not self:IsConnecting() and not self:IsConnect() then
        return false
    end

    local ok = self:RecvData()
    if not ok then return end
    self.readByteArray:setPos(1)
    self.readByteArray:writeBuf(self.recvData)
    --4字节的包长+2字节的协议号+4字节的数值id
    --所以得把4字节的包长过滤掉
    self.recvData = self.readByteArray:getBytes(5)
    self.packList:Push(self.recvData)
    self.recvData = ""
end

function UdpConn:RecvData()
    --预接收数据:调用ikcp_input将裸数据交给KCP，这些数据有可能是KCP控制报文，并不是我们要的数据。 
    --kcp接收到下层协议UDP传进来的数据底层数据buffer转换成kcp的数据包格式
    local recvt, sendt, status = socket.select({self.socket},{}, 0)
    local succeed = false
    if #recvt > 0 then        
        local buff, err = self.socket:receive()
        if not buff then
            if NetworkDefine.KCP_DEBUG then
                LogColorFormat("an error occur on udp receive buff [%s]", tostring(err))
            end
            self:Disconnect(NetworkDefine.DisconnectType.recv_fail)
            return false
        else
            if NetworkDefine.KCP_DEBUG then
                LogFormat("udp receive buff [%s]", string.len(buff))
            end
        end
        --将原始的udp报文直接塞进kcp里
        local hr = self.kcpConn:lkcp_input(buff)
        if NetworkDefine.KCP_DEBUG then
            LogFormat("UdpConn:RecvData udp buff length[%s], kcp buff hr[%s]", string.len(buff), hr)
        end
        if hr < 0 then return false end

        while true do
            --kcp将接收到的kcp数据包还原成之前kcp发送的buffer数据     
            local len, data = self.kcpConn:lkcp_recv()
            if NetworkDefine.KCP_DEBUG then
                LogFormat("lkcp_recv buff length[%s]", len)            
            end
            if len <= 0 then
                break
            end
            self.recvData =  self.recvData .. data
        end

        succeed = true
    end
    

    self.recvLen = #self.recvData
    return self.recvLen > 0
end

function UdpConn:OnDisconnect()
    if self.socket then
        self.socket:close()
        self.socket = nil
    end
    self.kcpConn = nil
    self.packList:Clear()
    self:ResetRecv()
end

function UdpConn:ResetRecv()
    self.recvState = RecvState.header
    self.needRecvLen = NetworkDefine.headerLen
    self.recvLen = 0
    self.recvData = ""
    self.sessionId = 0
end

function UdpConn:OnKcpUpdate()
    if self.kcpConn ~= nil then
        local time = math.floor(LUtil.gettimeofday())
        --ikcp_update包含ikcp_flush，ikcp_flush将发送队列中的数据通过下层协议UDP进行发送
        local rtt, rto = self.kcpConn:lkcp_update(time)
        KcpNetwork.rtt = rtt
        KcpNetwork.rto = rto
    end
end