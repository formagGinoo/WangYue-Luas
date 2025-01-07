-- 扩展Unity InputField 方法
local base = getmetatable(InputField)
local baseMetatable = getmetatable(base)

setmetatable(base, nil)

function base.SetEndEdit(self,cb,arg1,arg2,arg3)
	self.onEndEdit:RemoveAllListeners()
    self.onEndEdit:AddListener(function(flag) cb(flag,arg1,arg2,arg3) end)
end

function base.SetValueChanged(self, cb, args1,args2,args3)
	self.onValueChanged:RemoveAllListeners()
    self.onValueChanged:AddListener(function(flag) cb(flag,args1,args2,args3) end)
end

setmetatable(base, baseMetatable)