---@class ObjectPool
ObjectPool = BaseClass("ObjectPool")
--TODO 对象缓存池
function ObjectPool:__init()
	self.objectPool = {}
end

function ObjectPool:Get(type)
	if not self.objectPool[type] then
		self.objectPool[type] = {}
		return type.New()
	end
	local obj = table.remove(self.objectPool[type])
	if not obj then
		obj = type.New()
	end
	return obj
end

function ObjectPool:Cache(type,obj)
	--assert(type and obj,string.format("缓存对象异常,尝试放入空对象[类型:%s][对象:%s]",tostring(type),tostring(obj)))
	--assert(type.PoolClass and obj.PoolClass,string.format("缓存对象异常,尝试放入非对象池类[类型:%s][对象:%s]",tostring(type),tostring(obj)))
	--assert(not self.debugObjs[obj],string.format("缓存对象异常,池内存在相同对象[上次放入堆栈:%s]",tostring(self.debugObjs[obj])))
	obj:__cache()
	table.insert(self.objectPool[type],obj)
	--self.debugObjs[obj] = debug.traceback()
end

function ObjectPool:__delete()
	for type,v in pairs(self.objectPool) do
		for _,obj in ipairs(v) do
			if obj and obj.DeleteMe then
				obj:DeleteMe()
			else
				local name = obj.name and obj.name or ""
				Log("没有写__delete方法"..name)
			end
		end
	end
end