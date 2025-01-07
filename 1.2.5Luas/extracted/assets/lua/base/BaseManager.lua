-- 模块管理器基类
-- @author huangyq
BaseManager = BaseClass("BaseManager")

function BaseManager:__init()
end

function BaseManager:__delete()
end

function BaseManager:AddNetHandler(cmd, handler)
    if handler == nil then return end
    local tmp = function(dat)
        handler(self, dat)
    end
    Connection.Instance:AddHandler(cmd, tmp)
end

function BaseManager:Send(cmd, data)
    data = data or {}
    Connection.Instance:Send(cmd, data)
end
