EventLib = BaseClass("EventLib")
local _unityUtils = UnityUtils
local _ctx = ctx
function EventLib:__init(event)
    self.handlers = {}
    self.args = nil
    self.event = event or "<Unknown Event>"
	self.eventKey = event or "<Unknown Event>"
	if _ctx.Editor then
		for k, v in pairs(EventName) do
			if event == v then
				self.eventKey = k
				return
			end
		end
	end
end

function EventLib:AddListener(handler)
    self:Add(handler)
end
function EventLib:Add(handler)
	if ctx.Editor then
	    if handler == nil or type(handler) ~= "function" then
			LogError("注册监听事件出错，事件名为："..self.eventKey)
	        return 
	    end
	end
    self.handlers[handler] = handler
    -- table.insert(self.handlers, handler)
end

function EventLib:RemoveListener(handler)
    self:Remove(handler)
end

function EventLib:Remove(handler)
    if not handler then
		LogError("移除事件出错，事件名为："..self.eventKey)
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
    TableUtils.ClearTable(self.handlers)
    -- self:Remove()
end

-- 应该只有一个主线程，就不考虑多线程问题了
function EventLib:Fire(...)
	_unityUtils.BeginSample("EventLib:Fire_".. self.eventKey)
    for _, func in pairs(self.handlers) do
		if _ctx.Editor then
	        local call = function(...) func(...) end
	        local status, err = xpcall(call, function(errinfo) 
	            LogError("EventLib:Fire出错了[" .. self.eventKey .. "]:" .. tostring(errinfo)); LogError(debug.traceback())
	        end, ...)
		else
			func(...)
		end
    end
	_unityUtils.EndSample()
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