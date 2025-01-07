-- 扩展Unity ScrollRect class 方法
local base = getmetatable(ScrollRect)
local baseMetatable = getmetatable(base)

setmetatable(base, nil)

function base.SetValueChanged(self, onValueChanged)
	self.onValueChanged:RemoveAllListeners()
    self.onValueChanged:AddListener(onValueChanged)
end

setmetatable(base, baseMetatable)
