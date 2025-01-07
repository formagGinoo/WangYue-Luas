-- 保存类类型的虚表
local _class = {}
ClassTable = {}
setmetatable(ClassTable, {__mode = 'k'})

if ctx.Editor then
	DebugFightClassClear = {}
	DebugFightClassCreate = {}
end

function BaseClass(className,super)
	if ctx.Editor then
		local checkName = FileToClass[debug.getinfo(2,"S").short_src]
		if checkName then
			assert(className == checkName,string.format("BaseClass传入错误类名[%s](%s)",tostring(className),checkName))
		end
	else
		--assert(className and type(className) == "string" and className ~= "" ,string.format("BaseClass传入错误类名[%s]",tostring(className)))
	end

	-- 生成一个类类型
	local class_type = {}
	-- 在创建对象的时候自动调用
	class_type.__init = false
	class_type.__delete = false
	class_type.super = super

	--if ctx.Editor then
		--class_type.traceinfo = debug.traceback()
	--end

	class_type.New = function(...)
		-- 生成一个类对象
		local obj = {}
		obj._class_type = class_type
		obj._valid = true
		--if IS_DEBUG then
		--	ClassTable[obj] = os.time()
			--obj.traceinfo = debug.traceback()

			--if ctx.Editor then
				--if string.find(obj.traceinfo,"fight/") ~= nil and not class_type.NotClear then
					--DebugFightClassClear[obj] = obj.traceinfo

					--if not DebugFightClassCreate[class_type] then
						--DebugFightClassCreate[class_type] = {traceinfo = class_type.traceinfo,num = 0}
					--end
					--DebugFightClassCreate[class_type].num = DebugFightClassCreate[class_type].num + 1
				--end
			--end
		--end
		-- 在初始化之前注册基类方法
		setmetatable(obj, { __index = _class[class_type] })

		-- 注册一个delete方法
		obj.DeleteMe = function(self)
            -- 如果这行报错（attempt to index local 'self' (a nil value)），看一下object:DeleteMe()是不是写成object.DeleteMe()
			self._valid = nil

			if ctx.Editor then
				if DebugFightClassClear[self] then
					DebugFightClassClear[self] = nil
				end
			end

			local now_super = self._class_type
			while now_super ~= nil do
				if now_super.__delete then
					now_super.__delete(self)
				end
				now_super = now_super.super
			end
			if IS_DEBUG then
				for k,v in pairs(self) do
					if k ~= "traceinfo" then
						self[k] = nil
					end
				end
			else
				for k,v in pairs(self) do
					self[k] = nil
				end
			end
		end

		--
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

		--
		local _superFunc
		_superFunc = function(c,fn,flag,...)
			if flag then
				if c.super then _superFunc(c.super,fn,flag,...) end
				if c[fn] then c[fn](obj, ...) end
			else
				if c[fn] then c[fn](obj, ...) end
				if c.super then _superFunc(c.super,fn,flag,...) end
			end
		end

		--flag为true,则从父到子顺序调用
		--flag为false,则从子到父顺序调用
		obj.SuperFunc = function(self,fn,flag,...)
			_superFunc(class_type,fn,flag, ...)
		end

		obj.BaseFunc = function(self,fn,...)
			if class_type.super and class_type.super[fn] then
				class_type.super[fn](obj, ...)
			end
		end

		-- 调用初始化方法
		do
			local create
			create = function(c, ...)
				if c.super then
					create(c.super, ...)
				end
				if c.__init then
					c.__init(obj, ...)
				end
			end

			create(class_type, ...)
		end

		return obj
	end

	local vtbl = {}
	vtbl.__className = className
	vtbl.__type = class_type

	_class[class_type] = vtbl

	setmetatable(class_type, {__newindex =
		function(t,k,v)
			vtbl[k] = v
		end
		,
		__index = vtbl, --For call parent method
	})

	if super then
		setmetatable(vtbl, {__index =
			function(t,k)
				local ret = _class[super][k]
				--do not do accept, make hot update work right!
				--vtbl[k] = ret
				return ret
			end
		})
	end

	return class_type
end
