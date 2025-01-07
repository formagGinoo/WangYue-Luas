GOAPActionBase = BaseClass("GOAPActionBase",PoolBaseClass)

function GOAPActionBase:__init()
	self.actionPosition = nil--需要目标点检查
	self.actionTime = 0--执行行为所需要的时间
end

function GOAPActionBase:Init(config)
	self.key = config.key
	self.effectAttr = config.effect_attr
	self.effectAttrValue = config.effect_attr_value
	self.preAttr = config.pre_attr
	self.preAttrValue = config.pre_attr_value
	self.relation = config.relation
	self.subAttr = {}
	for i, v in ipairs(config.sub_attr) do
		if v[1] ~= "" then
			self.subAttr[v[1]] = self.subAttr[v[1]] or 0 + v[2]
		end
	end
	self.preAttr = GOAPConfig.GetPreAttrsByAction(self.key)
end

function GOAPActionBase:StartDoAction(planner)
	
end
function GOAPActionBase:GetPosition(planner)
	
end

function GOAPActionBase:FinishAction(planner)
	self:DoEffect(planner)
end

--影响
function GOAPActionBase:DoEffect(planner)
	if self.effectAttr == "" or self.preAttrValue == 0 then
		LogError("GOAP_action表没填主影响属性或者数值为0")
		return
	end
	planner.dynamicAttrs[self.effectAttr] = planner.dynamicAttrs[self.effectAttr] + self.effectAttrValue
	for k, v in pairs(self.subAttr) do
		planner.dynamicAttrs[k] = planner.dynamicAttrs[k] + v
	end
	for k, v in pairs(GOAPConfig.DataGoapDynamicAttr) do
		print("GOAP作用行为成功，当前动态属性:" ..k.. planner.dynamicAttrs[k])
	end
end

function GOAPActionBase:GetEffect()
	return self.effectAttr, self.effectAttrValue 
end

--获取消耗值
function GOAPActionBase:GetCost(planner)
	return 0
end

function GOAPActionBase:__delete()

end
