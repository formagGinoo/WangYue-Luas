---@class Proxy
Proxy = BaseClass("Proxy",Module)
Proxy._proxy = true

local sendProtoNames = {}
local recvProtoNames = {}

function Proxy:__init()
    self.sendFuns={}
    self.recvFuns={}
    self:__InitProxy()
end

function Proxy:__delete()
end

function Proxy:BindMsg(protoName)
    if not sendProtoNames[protoName] then
        sendProtoNames[protoName] = "req_" .. protoName
    end
    if not recvProtoNames[protoName] then
        recvProtoNames[protoName] = "resp_" .. protoName
    end

    self.module:BindMsg(protoName,self:ToFunc("_SendMsg"))
    Network.Instance:AddHandler(recvProtoNames[protoName],self:ToFunc("_RecvMsg"))
    self.sendFuns[protoName] = "Send_"..protoName
    self.recvFuns[recvProtoNames[protoName]] = "Recv_"..protoName
end

function Proxy:RemoveMsg(protoName)
    Network.Instance:RemoveHandler(recvProtoNames[protoName])
    self.module:RemoveMsg(protoName)
end

--禁止外部调用此方法发送协议，应使用mod.XXXFacade:SendMsg方法
function Proxy:_SendMsg(protoName,...)
    local funName = self.sendFuns[protoName]
    local data = self[funName] and self[funName](self,...) or {}
    return Network.Instance:Send(sendProtoNames[protoName],data)
end

function Proxy:_RecvMsg(data,protoName)
    local funName = self.recvFuns[protoName]
    if self[funName] then
        self[funName](self,data,protoName)
    end
end

--虚函数
function Proxy:__InitProxy() end
function Proxy:__InitComplete() end
function Proxy:__Clear() end