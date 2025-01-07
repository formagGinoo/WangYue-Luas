local super = getmetatable(Component)
local base = getmetatable(GameObject)
local baseMetatable = getmetatable(base)
setmetatable(base, nil)

function base.getActive(self)
	return self.activeSelf
end

-- function base.SetActive(gameObject,active)
-- 	UnityUtils.SetActive(gameObject,active)
-- end

base.addComponent 				= super.addComponent
base.getComponent 				= super.getComponent
base.getComponents 				= super.getComponents
base.getComponentInChildren		= super.getComponentInChildren
base.getComponentsInChildren 	= super.getComponentsInChildren

setmetatable(base, baseMetatable)