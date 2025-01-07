local super = getmetatable(Component)
local base = getmetatable(RectTransform)
local baseMetatable = getmetatable(base)
setmetatable(base, nil)

base.AddComponent = super.addComponent
base.GetComponent = super.getComponent

function base.SetAnchoredPosition(self,x,y)
	UnityUtils.SetAnchoredPosition(self,x,y)
end

setmetatable(base, baseMetatable)