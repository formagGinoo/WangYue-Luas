IdentityProxy = BaseClass("IdentityProxy",Proxy)

function IdentityProxy:__init()

end

function IdentityProxy:__InitProxy()
    self:BindMsg("identity_info_attr")
    self:BindMsg("identity_info_reward")
    self:BindMsg("identity_swtich")
    self:BindMsg("identity_reward")

end

function IdentityProxy:Recv_identity_info_attr(data)
    if data.identity then
        mod.IdentityCtrl:ChangeIdentity(data.identity)
    end
    if data.identity_attr_maps then
        mod.IdentityCtrl:UpdataIdentityAttrMaps(data.identity_attr_maps)
    end
    if data.identity_level_maps then
        mod.IdentityCtrl:UpdateIdentityLevelMaps(data.identity_level_maps)
    end
end

function IdentityProxy:Recv_identity_info_reward(data)
    if data.reward_list then
        mod.IdentityCtrl:UpdateGetRewardMap(data.reward_list)
    end
end

function IdentityProxy:Send_identity_swtich(identityInfo)
    return {identity = identityInfo }
end

function IdentityProxy:Recv_identity_swtich(data)
    mod.IdentityCtrl:ChangeIdentity(data.identity)
end

function IdentityProxy:Send_identity_reward(reward_list)
    return {reward_list = reward_list}
end