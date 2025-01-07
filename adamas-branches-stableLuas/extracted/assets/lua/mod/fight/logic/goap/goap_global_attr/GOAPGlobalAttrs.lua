GOAPGlobalAttrs = BaseClass("GOAPGlobalAttrs",PoolBaseClass)
--[[
世界状态，当世界状态发生改变的时候，会影响计划者的目标或者行为
--]]
function GOAPGlobalAttrs:__init()
	self.globalStates = GOAPConfig.GetGoapGlobalAttr()
end

function GOAPGlobalAttrs:Update()

end

function GOAPGlobalAttrs:AddListener(globalState,callback) 
	EventMgr.Instance:AddListener(globalState, callback)
end

function GOAPGlobalAttrs:RemoveListener(globalState,callback)
	EventMgr.Instance:RemoveListener(globalState, callback)
end

function GOAPGlobalAttrs:ChangeStateValue(globalState,value)
	self.globalStates[globalState] = value
	EventMgr.Instance:Fire(globalState,value)
end

function GOAPGlobalAttrs:AddStateValue(globalState,value)
	self.globalStates[globalState] = self.globalStates[globalState] + value
	EventMgr.Instance:Fire(globalState,self.globalStates[globalState])
end

function GOAPGlobalAttrs:__delete()

end
