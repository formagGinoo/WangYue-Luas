IdentityConfig = IdentityConfig or {}

IdentityConfig.RewardState=
{
    Received = 0,
    UnReach = 1,
    Reach = 2
}

IdentityConfig.CamareConfig =
{
    camera_position = {x = 0, y = 1.38, z = 3.04},
    camera_rotation = {x = 0, y = 189, z = 0.00}
}

local DataIdentityAttr = Config.DataIdentityAttr.Find
local DataIdentityTitle = Config.DataIdentityTitle.Find
local DataIdentityCommon = Config.DataIdentityCommon.Find

function IdentityConfig.GetMaxLev()
    return Config.DataWorldLevel.FindLength - 1
end

function IdentityConfig.GetIdentityTitleConfig(id,lev)
    if not id or id == 0 then
        return TI18N("暂未佩戴")
    end
    if lev == 0 then lev = 1 end
    return DataIdentityTitle[id .. "_" .. lev]
end

function IdentityConfig.GetIdentityTitleConfigNextLv(id,lev)
    lev = lev + 1
    return DataIdentityTitle[id .. "_" .. lev]
end

function IdentityConfig.GetIdentityAttrConfig(id)
    return DataIdentityAttr[id]
end

function IdentityConfig.GetTeachId()
    
end

function IdentityConfig.GetAdvLevConfig(lev)

end

function IdentityConfig.GetIdentityList()
    local list = {}
    for k, v in pairs(DataIdentityTitle) do
        if list[v.id] == nil then
            list[v.id] = true
        end
    end
    return list
end

function IdentityConfig.GetIdentityRewardList(id)
    local rewardList = {}
    for k, v in pairs(DataIdentityTitle) do
        if v.id == id then
            if v.reward and v.reward > 0 then
                table.insert(rewardList,{lv = v.level, rewardId = v.reward})
            end
        end
    end
    return rewardList
end

function IdentityConfig.GetIdentityReward(id,lv)
    for k, v in pairs(DataIdentityTitle) do
        if v.id == id and v.level == lv then
            return v.reward
        end
    end
end