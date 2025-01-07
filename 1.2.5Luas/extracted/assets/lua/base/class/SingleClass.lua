-- 保存类类型的虚表
local classTypes = {}
function SingleClass(className,indexCallback)
	if ctx.Editor then
		local checkName = FileToClass[debug.getinfo(2,"S").short_src]
		assert(className == checkName,string.format("SingleClass传入错误类名[%s](%s)",tostring(className),checkName))
	else
		if not (className and type(className) == "string" and className ~= "") then
			LogError(string.format("SingleClass传入错误类名[%s]",tostring(className)))
		end
		--assert(className and type(className) == "string" and className ~= "" ,string.format("SingleClass传入错误类名[%s]",tostring(className)))
	end

	-- 生成一个类类型
	local class = {}

	class.New = function(...)
		-- 生成一个类对象
        local obj = {}
        obj._valid = true
        obj._class = true

		-- 在初始化之前注册基类方法
        setmetatable(obj,{__index = classTypes[class]})

		-- 注册一个delete方法
		obj.DeleteMe = function(self)
            self._valid = nil
            if self.__delete then
                self:__delete()
            end
            class.Instance = nil
		end

		obj.funcs = nil
		obj.ToFunc = function(self,fn)
			if not self.funcs then self.funcs = {} end
			local func = self.funcs[fn]
			if not func then
				func = function(...) 
					if self._valid and self[fn] then
						return self[fn](self,...) 
					end
				end
				self.funcs[fn]=func
			end
			return func
		end

		obj.GetFunc = function(self,fn)
			if not self.funcs then return nil end
			return self.funcs[fn]
		end

		if class.__init then class.__init(obj, ...) end

        assert(not class.Instance,"单例类无法被重复实例化")
        class.Instance = obj

		return obj
	end

	local vtbl = {}
	vtbl.__className = className
	vtbl.__type = class
    
	classTypes[class] = vtbl

	setmetatable(class, {__newindex = function(t,k,v) vtbl[k] = v end,__index = vtbl})
	if indexCallback then
		setmetatable(vtbl, {__index = indexCallback })
	end
	return class
end