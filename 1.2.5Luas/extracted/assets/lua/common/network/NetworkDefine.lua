NetworkDefine = StaticClass("NetworkDefine")

NetworkDefine.DataType = 
{
	["bool"]     = "bool",
	["int8"]     = "int8",
	["uint8"]    = "uint8",
	["int16"]    = "int16",
	["uint16"]   = "uint16",
	["int32"]    = "int32",
	["uint32"]   = "uint32",
	["int64"]    = "int64",
	["uint64"]   = "uint64",
	["float"]    = "float",
	["double"]   =  "double",
	["string"]   = "string",
	["array"]    = "array",
	["dict"]     = "dict",
	["binary"]   = "binary",
	["byte"]     = "byte",
}

NetworkDefine.headerLen = 2
NetworkDefine.protoIdLen = 2


NetworkDefine.DisconnectType = 
{
	initiative = 1,
	send_fail  = 2,
	recv_fail  = 3,
	tick_timeout = 4,
	return_login = 5,
}

NetworkDefine.tickMaxInterval = 30                    -- 普通心跳包的最大超时时间
NetworkDefine.tickSendInterval = 10                   -- 普通心跳包的发送频率
NetworkDefine.tickProtoId = 10002                      -- 普通心跳包的协议号
NetworkDefine.tickProtoName = "req_heartbeat"
NetworkDefine.isCSharpSocket = false                   -- 是否使用c# socket
NetworkDefine.CSharpSocketSendImmediate = false        -- c# socket是否立即发送
NetworkDefine.openKcp = false                         -- 是否开启kcp
NetworkDefine.kcpTickProtoId = 10017                  -- kcp的协议号
NetworkDefine.KCP_DEBUG = false                       -- kcp是否debug模式

NetworkDefine.NotPushPool = 
{
	[10506] = true
}


NetworkDefine.NewReadByteArray = 
{
	[10502] = true
}


ConnType = 
{
    tcp = 0,
    udp = 1,
    http = 2,
}

ConnState = 
{
    none = 0,
    connecting = 1,
    connected = 2,
}

ConnEvent = 
{
    connected = 1,
    connect_fail = 2,
	disconnect = 3,
	cancel_connect = 4,
}

KcpConnEvent = 
{
    connected = 1,
    connect_fail = 2,
    disconnect = 3,
    cancel_connect = 4,
}

RecvState = 
{
    header = 0,
    body = 1,
}

KcpMode = 
{
    default = 0,
    common = 1,
    fast = 2
}