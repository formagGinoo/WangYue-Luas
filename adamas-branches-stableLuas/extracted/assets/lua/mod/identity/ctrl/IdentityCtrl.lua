IdentityCtrl = BaseClass("IdentityCtrl",Controller)

local function sortReward(a,b)
    if a.state == b.state then
        return a.lv < b.lv
    else
        return a.state > b.state
    end
end

local function sortIdentity(a,b)
    if a.id == mod.IdentityCtrl:GetNowIdentity().id then
        return true
    elseif b.id == mod.IdentityCtrl:GetNowIdentity().id  then
        return false
    end
    if (a.lv == 0 and b.lv == 0) or (a.lv > 0 and b.lv > 0) then
        return IdentityConfig.GetIdentityTitleConfig(a.id,1).priority > IdentityConfig.GetIdentityTitleConfig(b.id,1).priority
    elseif b.lv == 0 then
        return true
    end
    return false
end

function IdentityCtrl:__init()
    self.curIdentityInfo = {} -- self.curIdentityInfo = {id = id,lv = lv}
    self.identityLevelMaps = {}  -- self.identityLevelMaps[id] = lv
    self.identityAttrMap = {}  -- self.identityAttrMap[attr_id] = lv
    self.identityReward = {}  -- self.identityReward[id] = {{lv = lv,reward = reward}}
    self.getRewardMap = {}  -- self.getRewardMap[id][lv] = true/false
end

function IdentityCtrl:UpdataIdentityAttrMaps(data)
    local changeList = {}
    for k, v in pairs(data) do
        self.identityAttrMap[k] = self.identityAttrMap[k] or 0
        if self.identityAttrMap[k] ~= v then
            table.insert(changeList,{id = k, val = v-self.identityAttrMap[k]})
        end
        self.identityAttrMap[k] = v
    end
    EventMgr.Instance:Fire(EventName.IdentityExpChange,changeList)
end

function IdentityCtrl:UpdateIdentityLevelMaps(data)
    for k, v in pairs(data) do
        if self.identityLevelMaps[k] == nil or self.identityLevelMaps[k] < v then
            EventMgr.Instance:Fire(EventName.IdentityLvChange,v,k)
        end
        self.identityLevelMaps[k] = v
    end
end

function IdentityCtrl:UpdateGetRewardMap(data)
    for i, v in ipairs(data) do
        if not self.getRewardMap[v.key] then
            self.getRewardMap[v.key] = {}
        end
        self.getRewardMap[v.key][v.value] = true
    end
end

function IdentityCtrl:GetIdentityAttrInfo()
    return self.identityAttrMap
end

function IdentityCtrl:GetPlayerIdentity()
    return self.identityLevelMaps
end

function IdentityCtrl:GetNowIdentity()
    return self.curIdentityInfo
end

function IdentityCtrl:GetIdentityList()
    local list = IdentityConfig:GetIdentityList()
    local resList = {}
    for k, v in pairs(list) do
        local lv = self.identityLevelMaps[k] or 0
        table.insert(resList,{id = k,lv = lv })
    end
    table.sort(resList,sortIdentity)
    return resList
end

function IdentityCtrl:GetIdentityRewardList(id)
    local rewardItemList = {}
    if not self.identityReward[id] then
        self.identityReward[id] = IdentityConfig.GetIdentityRewardList(id)
    end
    for i, v in ipairs(self.identityReward[id]) do
        local state
        if self.identityLevelMaps[id] and self.identityLevelMaps[id] >= v.lv then
            if self.getRewardMap[id] and self.getRewardMap[id][v.lv] then
                state = IdentityConfig.RewardState.Received
            else
                state = IdentityConfig.RewardState.Reach
            end
        else
            state = IdentityConfig.RewardState.UnReach
        end
        v.state = state
    end
    table.sort(self.identityReward[id],sortReward)
    for _, val in ipairs(self.identityReward[id]) do
        local list = TableUtils.CopyTable(ItemConfig.GetReward2(val.rewardId))
        for i, v in ipairs(list) do
            v.state = val.state
            v.lv = val.lv
            table.insert(rewardItemList,v)
        end
    end
    return rewardItemList
end

function IdentityCtrl:SendChangeIdentity(id,lv)
    mod.IdentityFacade:SendMsg("identity_swtich",{key = id, value = lv})
    --self:ChangeIdentity({key = id, value = lv})
end

function IdentityCtrl:ChangeIdentity(identity)
    local lastId = self.curIdentityInfo.id
    self.curIdentityInfo.id = identity.key
    self.curIdentityInfo.lv = identity.value
    EventMgr.Instance:Fire(EventName.IdentityChange,lastId,identity.key)
end

function IdentityCtrl:GetIdentityReward(identityId)
    if not self.identityLevelMaps or not self.identityLevelMaps[identityId] then return end 
    local reward_list = {}
    for i = 1,self.identityLevelMaps[identityId],1 do
        if not self.getRewardMap[identityId] or not self.getRewardMap[identityId][i] then
            table.insert(reward_list,{key = identityId,value = i})
        end
    end
    if #reward_list > 0 then
        local id,cmd = mod.IdentityFacade:SendMsg("identity_reward",reward_list)
        mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(ERRORCODE)
            if ERRORCODE == 0 then
                EventMgr.Instance:Fire(EventName.IdentitRewardRefresh,identityId)
            end
        end)
    end
end

function IdentityCtrl:CheckIdentityRedPointById(id)
    if not self.identityLevelMaps[id] then return false end
    local lv = self.identityLevelMaps[id]
    for i = 1, lv, 1 do
        if (not self.getRewardMap[id] or not self.getRewardMap[id][i]) 
            and IdentityConfig.GetIdentityReward(id,i) ~= 0 then
            return true
        end
    end
    return false
end

function IdentityCtrl:CheckIdentityRedPoint()
    for k, v in pairs(self.identityLevelMaps) do
        for i = 1, v, 1 do
            if (not self.getRewardMap[k] or not self.getRewardMap[k][i]) 
                and IdentityConfig.GetIdentityReward(k,i) ~= 0 then
                return true
            end
        end
    end
    return false
end