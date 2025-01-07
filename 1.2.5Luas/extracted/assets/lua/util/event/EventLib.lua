EventLib = BaseClass("EventLib")

function EventLib:__init(EventName)
    self.handlers = {}
    self.args = nil
    self.EventName = EventName or "<Unknown Event>"
end

function EventLib:AddListener(handler)
    self:Add(handler)
end
function EventLib:Add(handler)
    if handler == nil or type(handler) ~= "function" then
		LogError("注册监听事件出错，事件名为："..self.EventName)
        return 
    end
    self.handlers[handler] = handler
    -- table.insert(self.handlers, handler)
end

function EventLib:RemoveListener(handler)
    self:Remove(handler)
end

function EventLib:Remove(handler)
    if not handler then
		LogError("移除事件出错，事件名为："..self.EventName)
        -- self.handlers = {}
    else
        self.handlers[handler] = nil
        -- for k, v in pairs(self.handlers) do
        --     if v == handler then
        --         self.handlers[k] = nil
        --         return k
        --     end
        -- end
    end
end

function EventLib:RemoveAll()
    self.handlers = {}
    -- self:Remove()
end

-- 应该只有一个主线程，就不考虑多线程问题了
function EventLib:Fire(...)
    UnityUtils.BeginSample("EventLib:Fire_".. self.EventName)
    for _, func in pairs(self.handlers) do
        local call = function(...) func(...) end
        local status, err = xpcall(call, function(errinfo) 
            LogError("EventLib:Fire出错了[" .. self.EventName .. "]:" .. tostring(errinfo)); LogError(debug.traceback())
        end, ...)
    end
    UnityUtils.EndSample()
end

function EventLib:Destroy()
    self:RemoveAll()
    for k, v in pairs(self) do
        self[k] = nil
    end
end

function EventLib:__delete()
    self:Destroy()
end