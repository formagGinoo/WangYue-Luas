---@class Facade
Facade = BaseClass("Facade")

local facades = {}
local proxys = {}
local ctrls = {}

function Facade:__init(facadeType)
    facades[facadeType.__className] = self
    self.msgs = {}
    self.proxys = {}
    self.ctrls = {}
    self.events = {}
    self:__InitFacade()
end

function Facade:__delete()
end

function Facade:ClearData()
    for _,v in pairs(self.proxys) do v:__Clear() end
    for _,v in pairs(self.ctrls) do v:__Clear() end
    self:__Clear()
end

function Facade:BindProxy(proxyType)
    if not proxyType then
        LogError("注册Proxy组件异常,组件为空")
        return
    elseif proxys[proxyType] then
        LogError("注册Proxy组件异常,重复注册")
        return
    end

    local proxy = proxyType.New(self)
    proxys[proxyType] = proxy
    table.insert(self.proxys,proxy)
end

function Facade:BindCtrl(ctrlType)
    if not ctrlType then
        LogError("注册Ctrl组件异常,组件为空")
        return
    elseif ctrls[ctrlType] then
        LogError("注册Ctrl组件异常,重复注册")
        return
    end

    local ctrl = ctrlType.New(self)
    ctrls[ctrlType] = ctrl

    table.insert(self.ctrls,ctrl)
end

function Facade:BindEvent(event,cb)
    if not cb then return end
    if self.events[event]==nil then self.events[event] = {} end
    self.events[event][cb] = cb
end

function Facade:RemoveEvent(event,cb)
    if not cb then return end
    if not self.events[event] then return end
    self.events[event][cb] = nil
end

function Facade:SendEvent(event,...)
    if not event then LogError("发送了空的事件") return end
    if not event._enum then LogError("发送的不是事件") return end
    local events = self.events[event]
    if not events then return end
    for k,v in pairs(events) do k(...) end
end

function Facade:SendMsg(msgId,...)
    local cb = self.msgs[msgId]
	if not cb then
		LogError(string.format("发送未注册的网络协议[msdId:%s]",tostring(msgId)))
	end
    --assert(cb,string.format("发送未注册的网络协议[msdId:%s]",tostring(msgId)))
    return cb(msgId,...)
end

function Facade:BindMsg(msgId,cb)
    self.msgs[msgId] = cb
end

function Facade:RemoveMsg(msgId)
    self.msgs[msgId] = nil
end

function Facade:GetProxys()
    return self.proxys
end

function Facade:GetCtrls()
    return self.ctrls
end

function Facade.InitComplete()
    local instances = {}
    for k,v in pairs(proxys) do instances[ v.__className ] = v end
    for k,v in pairs(ctrls) do instances[ v.__className ] = v end
    for k,v in pairs(facades) do instances[ v.__className ] = v end
    mod = TableUtils.ReadOnly(instances)

    for k,v in pairs(proxys) do v:__InitComplete() end
    for k,v in pairs(ctrls) do v:__InitComplete() end
    for k,v in pairs(facades) do v:__InitComplete() end
end

function Facade.ClearModuleData()
    for k,v in pairs(facades) do v:ClearData() end
end

--外部不要用这个方法获取模块入口，直接mod.XXXFacade即可访问
function Facade.GetFacade(facadeName)
    return facades[facadeName]
end

function Facade:__InitFacade() end
function Facade:__InitComplete() end
function Facade:__Clear() end