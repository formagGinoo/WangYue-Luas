RedPointMgr = SingleClass("RedPointMgr")

function RedPointMgr:__init()
    self.redPointMap = {}
    self.redPointStateMap = {}
    self.rootMap = {}
    self.delayRefreshList = {}
    self.delayRefresh = false
end

function RedPointMgr:__delete()

end

function RedPointMgr:InitRedTree()
    for key, _ in pairs(RedPointConfig.RootMap) do
        local point = RedPointNode.New()
        point:CreateNode(key)
        self.rootMap[key] = point
    end
end
function BuffComponent:CheckStates(...)
	
	for i = 1, #args do
		if not self:CheckState(args[i]) then
			return false
		end
	end
	return true
end

function RedPointMgr:GetRedPointNode(...)
    local args = {...}
    
    if not self.redPointMap[args[1]] then
        Log("红点不存在：", args[1])
    else
        if #args > 1 then
            local redNode = self.redPointMap[args[1]]
            for i = 2, #args, 1 do
                if redNode then
                    redNode = redNode:GetChild(args[i])
                end
            end
            return redNode
        else
            return self.redPointMap[args[1]]
        end
    end
end


function RedPointMgr:AddRedInfo(key, node)
    if self.redPointMap[key] == nil then
        self.redPointMap[key] = node
    else
        LogError("红点已存在：", key)
    end
end

function RedPointMgr:RemoveRedInfo(key)
    if self.redPointMap[key] then
        self.redPointMap[key]:RemoveSelf(true)
        self.redPointMap[key] = nil
    end
end

function RedPointMgr:AddBind(key)
    if self.redPointMap[key] then
        self.redPointMap[key]:AddBind()
    end
end

function RedPointMgr:RemoveBind(key)
    if self.redPointMap[key] then
        self.redPointMap[key]:RemoveBind()
    end
end

function RedPointMgr:SetRedPointState(key,state)
    if self.redPointMap[key] then
        self.redPointMap[key]:SetState(state)
    end
end

function RedPointMgr:RedPointStateChange(key, state)
    if not self.redPointMap[key] then
        LogError("红点不存在：", key)
    else
        self.redPointStateMap[key] = state
        EventMgr.Instance:Fire(EventName.RedPointStateChange, key, state)
        --Log("红点状态变化:", key, tostring(state))
    end
end

function RedPointMgr:GetRedPointState(key)
    if not self.redPointMap[key] then
        Log("红点不存在：", key)
    end
    return self.redPointStateMap[key] or false
end

function RedPointMgr:DelayRefreshRedState()
    self.delayRefresh = true
end

function RedPointMgr:IsDelayRefresh()
    return self.delayRefresh
end

function RedPointMgr:AddDelayNode(node)
    table.insert(self.delayRefreshList,node)
end

function RedPointMgr:StartDelayRefresh()
    -- test临时判断
    if not Fight.Instance then
        return
    end

    self.delayRefresh = false
    for _, v in ipairs(self.delayRefreshList) do
        v:RefreshRedPoint()
    end
    TableUtils.ClearTable(self.delayRefreshList)
end