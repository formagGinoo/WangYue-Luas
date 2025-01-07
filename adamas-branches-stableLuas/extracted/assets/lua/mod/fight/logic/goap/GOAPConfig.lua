GOAPConfig = GoapConfig or {}

GOAPConfig.DataGoapDynamicAttr = Config.DataGoapDynamicAttr.Find
GOAPConfig.DataGoapAction = Config.DataGoapAction.Find
GOAPConfig.DataGoapStaticAttr = Config.DataGoapStaticAttr.Find
GOAPConfig.DataGoapGlobalAttr = Config.DataGoapGlobalAttr.Find
GOAPConfig.DataGoal = Config.DataGoal.Find
GOAPConfig.DataGoapGoal = Config.DataGoapGoal.Find

function GOAPConfig.RelationTrans(relationStr, preNum, subNum)
	if relationStr == "" or not preNum or not subNum then
		return false
	end
	if relationStr == ">" then
		return preNum > subNum
	end
	if relationStr == "<" then
		return preNum < subNum
	end	
	if relationStr == "=" then
		return preNum == subNum
	end	
	if relationStr == "<=" then
		return preNum <= subNum
	end
	if relationStr == ">=" then
		return preNum >= subNum
	end
end

function GOAPConfig.GetGoapDynamicAattrRamdom()
	local attrs = {}
	for k, v in pairs(GOAPConfig.DataGoapDynamicAttr) do
		attrs[k] = math.random(v.min, v.max)
	end
	return attrs
end

function GOAPConfig.GetGoapGlobalAttr()
	local attrs = {}
	for k, v in pairs(GOAPConfig.DataGoapGlobalAttr) do
		attrs[k] = 0
	end
	return attrs
end

function GOAPConfig.GetGoapGoalEffectAction(actionsLogic)
	local actions = {}
	for k, v in pairs(GOAPConfig.DataGoapGoal) do
		actions[k] = GOAPConfig.GetGoapGoalEffectActionByGoal(k, actionsLogic)
	end
	return actions
end

function GOAPConfig.GetGoapGoalEffectActionByGoal(goal, actionsLogic)
	local actions = {}
	if not GOAPConfig.DataGoapGoal[goal] or not actionsLogic then
		return actions
	end
	for i, v in ipairs(GOAPConfig.DataGoapGoal[goal].effect_action) do
		if v ~= "" then
			actions[v] = actionsLogic[v]
		end
	end
	return actions
	
end

function GOAPConfig.GetPreAttrsByAction(actionName)
	local preAttr = {}
	local config = GOAPConfig.DataGoapAction[actionName]
	if not config then return preAttr end
	for k, attr in pairs(config.pre_attr) do
		if attr[1] ~= "" then
			table.insert(preAttr,{
				attrName = attr[1],
				ralation = attr[2], 
				attrValue = attr[3]
			})
		end
	end
	return preAttr
end