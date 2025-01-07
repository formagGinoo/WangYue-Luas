-- 扩展Unity Dropdown class 方法
local base = getmetatable(Dropdown)
local baseMetatable = getmetatable(base)

setmetatable(base, nil)

function base.SetClick(self, cb, arg1,arg2,arg3)
	self.onValueChanged:RemoveAllListeners()
    self.onValueChanged:AddListener(function(flag) cb(flag,arg1,arg2,arg3) end)
end

setmetatable(base, baseMetatable)