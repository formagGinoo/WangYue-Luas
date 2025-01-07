-- 事件系统
-- UnityEvent.RemoveListener在某些情况下不起作用
-- 所以增加了该方式，handler为lua function
EventMgr = BaseClass("EventMgr")
function EventMgr:__init()
    EventMgr.Instance = self
    self.events = {}
end

function EventMgr:AddListener(event, handler)
    if not event then
        LogError("没有填写Event")
        return
    end

    if not handler or type(handler) ~= "function" then
		LogError("handler为是一个函数,事件名:"..event)
        return
    end

    if not self.events[event] then
        self.events[event] = EventLib.New(event)
    end
    self.events[event]:Add(handler)
end

function EventMgr:RemoveListener(event, handler)
    if self.events[event] then
        self.events[event]:Remove(handler)
    end
end
function EventMgr:RemoveAllListener(event)
    if self.events[event] then
        self.events[event]:RemoveAll()
    end
end

function EventMgr:Fire(event, ...)
    if self.events[event] then
        local call = function(...) self.events[event]:Fire(...) end
        local status, err = xpcall(call, function(errinfo) 
			LogError("EventMgr:Fire出错了[" .. event .. "]:" .. tostring(errinfo)); LogError(debug.traceback())
        end, ...)
        if not status then
			LogError("EventMgr:Fire出错了" .. tostring(err))
        end
    end
end
