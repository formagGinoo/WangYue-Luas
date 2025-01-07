BaseConn = BaseClass("BaseConn")

function BaseConn:__init()
    self.host = nil
    self.port = nil
    self.state = ConnState.none
    self.eventListens = {}
end

function BaseConn:Connect(host,port)
    if self.state ~= ConnState.none then return end
    self.host = host
    self.port = port
    self:SetState(ConnState.connecting)
    self:OnConnect()
end

function BaseConn:Update()
    self:OnUpdate()
end

function BaseConn:Send(bytes)
    return self:OnSend(bytes)
end

function BaseConn:Recv()
    self:OnRecv()
end

function BaseConn:PopPack()
    return self:OnPopPack()
end

function BaseConn:SetEvent(event,callBack)
    if not self.eventListens[event] then self.eventListens[event] = {} end
    table.insert(self.eventListens[event],callBack)
end

function BaseConn:RemoveEvent(event,callBack)
    local listens = self.eventListens[event]
    if not listens then return end

    local index = nil
    for i,cb in ipairs(listens) do
        if cb == callBack then 
            index = i
            break
        end
    end

    if index then
        table.remove(self.eventListens[event],index)
    end
end

function BaseConn:NoticeEvent(event,param)
    if not self.eventListens[event] then return end
    local listens = self.eventListens[event]
    for _,cb in ipairs(listens) do cb(param) end
end

function BaseConn:SetState(state)
    self.state = state
end

function BaseConn:IsState(state)
    return self.state == state
end

function BaseConn:GetState()
    return self.state
end

function BaseConn:IsConnect()
    return self.state == ConnState.connected
end

function BaseConn:IsConnecting()
    return self.state == ConnState.connecting
end

function BaseConn:Disconnect(err)
    if err == NetworkDefine.DisconnectType.return_login then
        self.state = ConnState.none
        self:StopConnect()
        if self.connType == ConnType.tcp then
            self:NoticeEvent(ConnEvent.cancel_connect,err)
        elseif self.connType == ConnType.udp then
            self:NoticeEvent(KcpConnEvent.cancel_connect,err)
        end
        return
    end

    if self.state ~= ConnState.connected then return end
    
    self.state = ConnState.none
    self:OnDisconnect(err)

    if self.connType == ConnType.tcp then
        --self:NoticeEvent(ConnEvent.disconnect,err)
    elseif self.connType == ConnType.udp then
        --self:NoticeEvent(KcpConnEvent.disconnect,err)
    end
end

function BaseConn:OnUpdate() end
function BaseConn:OnConnect() end
function BaseConn:OnSend(bytes) end
function BaseConn:OnRecv() end
function BaseConn:OnPopPack() end
function BaseConn:OnDisconnect(err) end

function BaseConn.Create(connType)
    local class = nil
    if connType == ConnType.tcp then
        class = TcpConn
    elseif connType == ConnType.udp then
        class = UdpConn
    else
        assert(false,string.format("未知的网络类型[%s]",tostring(connType)))
    end

    local ret = class.New()
    ret.connType = connType

    return ret
end

