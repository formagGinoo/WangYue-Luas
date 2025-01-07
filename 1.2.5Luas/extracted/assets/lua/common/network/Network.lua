Network = SingleClass("Network")

local pb = require "pb"

local protoNameToId = nil
local protoIdToName = nil

local protoOrderId = 0
local curProtoId = nil

function Network.ResetOrderId()
    protoOrderId = 0
end

function Network.GetOrderId()
    protoOrderId = protoOrderId + 1
    return math.fmod(protoOrderId, 128)
end

function Network:__init()
    local define = NetworkDefine
    self.conn = BaseConn.Create(ConnType.tcp)
    self.sendList = {}
    self.maxSendLen = 3000
    self.maxRecvNum = 0
    self.handlers = {}

    self.tickTimer = nil
    self.lastTickTime = 0
    self.isStopRecv = false

    self:InitMataFields()

    self.readByteArray = ByteArray.New()
	self.sendPackRemove = {}

    self.conn:SetEvent(ConnEvent.disconnect,function() self:ConnDisconnect() end)
end

function Network:InitMataFields()
	if ctx.Editor then
		local ret = pb.loadfile("../data/lua/proto/proto.lua")
		assert(ret, "LoadProtobuf Fail")
	else
		local path = "data/proto/proto.lua"
		local context = ctx.LuaAssetLoader:GetAsset(path,"proto")
		local ret = pb.load(context)
		assert(ret, "LoadProtobuf Fail")
	end
	
    local ptDefine = require("data/proto/pt_define")
    protoNameToId = ptDefine.MSG_ID
    protoIdToName = ptDefine.MSG_NAME
end

function Network:Connect(host,port)
    --LogInfof("Network:Connect(%s, %s)",host,port)
    self.conn:Connect(host,port)
end

function Network:AddHandler(protoId,func)
	if self.handlers[protoId] then
		LogError(string.format("禁止一个消息被多个函数处理[%s]",protoId))
	end
    --assert(not self.handlers[protoId],string.format("禁止一个消息被多个函数处理[%s]",protoId))
    self.handlers[protoId] = func
end

function Network:RemoveHandler(protoId)
    self.handlers[protoId] = nil
end

function Network:Update()
    self:SendPack()
    self:RecvPack()
    self:HandlerPack()
end

function Network:SendPack()
	if #self.sendList == 0 then
		return
	end
	
	local lenCount = 0
	local sendFlag = true
	TableUtils.ClearTable(self.sendPackRemove)

    for i,v in ipairs(self.sendList) do
        while v.sendLen < v.maxLen and lenCount < self.maxSendLen do
            local addLen = v.maxLen - v.sendLen
            if lenCount + addLen > self.maxSendLen then addLen = self.maxSendLen - lenCount end

            --Log("发送了包",v.protoId)
            sendFlag = self.conn:Send(v.byteArray:getPack(v.sendLen + 1,v.sendLen + addLen))
            if not sendFlag then 
                break 
            end

            v.sendLen = v.sendLen + addLen
            lenCount = lenCount + addLen
        end

        if v.sendLen >= v.maxLen then table.insert(self.sendPackRemove,i) end
        if lenCount >= self.maxSendLen then break end
    end

    
    if not sendFlag then return end

    for i=#self.sendPackRemove,1,-1 do
        local sendInfo = self.sendList[self.sendPackRemove[i]]
        self:PushByteArray(sendInfo.protoId,sendInfo.byteArray)
        table.remove( self.sendList,self.sendPackRemove[i])
    end
end

function Network:RecvPack()
    self.conn:Recv()
end

function Network:HandlerPack()
    local recvCount = 0

    while not self.isStopRecv and (self.maxRecvNum == 0 or recvCount < self.maxRecvNum) do
        local packBytes = self.conn:PopPack()
        if not packBytes then 
            break 
        end

        self.readByteArray:setPos(1)
        self.readByteArray:writeBuf(packBytes)
        local len = self.readByteArray:getAvailable()

        self.readByteArray:setPos(1)
        local protoId = self.readByteArray:readUShort()
        curProtoId = protoId
        
        local bodyBytes = self.readByteArray:getPack(NetworkDefine.protoIdLen + 1,len)

        local protoName = protoIdToName[protoId]
        if not protoName then
			LogError("协议找不到！protoId = "..protoId)
		end
        local data = pb.decode(protoName, bodyBytes)

        if protoId == NetworkDefine.tickProtoId then 
            self:ResetTickTime() 
        end

        local func = self.handlers[protoName]
        if func then xpcall(func,Network.PackError, data, protoName) end

        recvCount = recvCount + 1
    end
end

function Network.PackError(err)
    LogErrorf("处理协议报错[%s][%s]",curProtoId,err)
end


function Network:Send(protoName,data)
    local protoId = protoNameToId[protoName]
    if not protoId then
        LogErrorf("发送协议异常,尝试发送未定义的协议[协议名:%s]",protoName)
        return
    end

    if NET_DEBUG then 
        Logf("发送协议[协议名:%s][协议Id:%s]",protoName,protoId) 
    end

    if not self.conn:IsConnect() then 
        return
    end

    local byteBuff = pb.encode(protoName, data)
    if not byteBuff then
        LogErrorf("发送协议异常,编码时出现错误[协议Id:%s][协议名:%s]",protoId,tostring(protoName))
        return
    end

    local byteArray = PoolManager.Instance:Pop(PoolType.class,ByteArray.poolKey)
    if not byteArray then byteArray = ByteArray.New() end

    local orderId = Network.GetOrderId()

    byteArray:writeUShort(#byteBuff + 3)
    byteArray:writeUShort(protoId)
    byteArray:writeByte(orderId)
    byteArray:writeBuf(byteBuff)
    --Log(string.format("Send:protoName:%s,orderId:%s", protoName, orderId))
    table.insert(self.sendList,{ protoId = protoId,sendLen = 0,maxLen = byteArray:getAvailable(), byteArray = byteArray })
    return orderId, protoId
end

--心跳包相关
function Network:StartTick()
    self.lastTickTime = 0
    self:SendTick()
    self:RemoveTickTimer()
    self:RestartTick()
end

function Network:RestartTick()
    if not self.tickTimer then
        self.tickTimer = LuaTimerManager.Instance:AddTimer(0, NetworkDefine.tickSendInterval,self:ToFunc("SendTick"))
    end
end

function Network:StopTick()
    self.lastTickTime = 0
    self:RemoveTickTimer()
end

function Network:SendTick(ignoreTimeout)
    local time = os.time()
    if not ignoreTimeout and self:IsTimeout(time) then return end
    self:Send(NetworkDefine.tickProtoName,{ time = time })
end

function Network:IsTimeout(time)
    if self.lastTickTime == 0 then return false end
    if time - self.lastTickTime <= NetworkDefine.tickMaxInterval then return false end
    LogError("心跳包超时导致网络断开")
    self.conn:Disconnect(NetworkDefine.DisconnectType.tick_timeout)
    return true
end

function Network:RemoveTickTimer()
    if self.tickTimer then 
        LuaTimerManager.Instance:RemoveTimer(self.tickTimer)
        self.tickTimer = nil 
    end
end

function Network:ResetTickTime()
    self.lastTickTime = os.time()
    self:RestartTick()
end

---

function Network:ConnDisconnect()
    for i,v in ipairs(self.sendList) do self:PushByteArray(v.protoId,v.byteArray) end
    self.sendList = {}
    self:StopTick()
end

function Network:PushByteArray(protoId,byteArray)
    if NetworkDefine.NotPushPool[protoId] then return end
    PoolManager.Instance:Push(PoolType.class,ByteArray.poolKey,byteArray)
end

function Network:Disconnect(err)
    if not err then err = NetworkDefine.DisconnectType.initiative end
    self.conn:Disconnect(err)
end

function Network:SetEvent(event,callBack)
    self.conn:SetEvent(event,callBack)
end

function Network:QueryState()
    Log("网络连接状态",self.conn:GetState())
end

function Network:IsConnect()
    return self.conn:IsConnect()
end

function Network:GetTickTime()
    return self.lastTickTime
end

function Network:SetStopRecv(isStop)
    self.isStopRecv = isStop
end