-- 扩展Unity Toggle class 方法
local base = getmetatable(Slider)
local baseMetatable = getmetatable(base)


setmetatable(base, nil)

function base.SetClick(self,cb,arg1,arg2,arg3)
	self.onValueChanged:RemoveAllListeners()
    self.onValueChanged:AddListener(function(flag) cb(flag,arg1,arg2,arg3) end)
end

function base.AddClick(self,cb,arg1,arg2,arg3)
	local addCb = function(flag) cb(flag,arg1,arg2,arg3) end
    self.onValueChanged:AddListener(addCb)
    return addCb
end

function base.RemoveClick(self, cb)
    self.onValueChanged:RemoveListener(cb)
end

function base.RemoveAllClick(self)
	self.onValueChanged:RemoveAllListeners()
end

setmetatable(base, baseMetatable)