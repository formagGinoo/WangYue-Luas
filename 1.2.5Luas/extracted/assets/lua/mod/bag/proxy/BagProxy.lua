BagProxy = BaseClass("BagProxy", Proxy)

local _tinsert = table.insert

function BagProxy:__InitProxy()
    self:BindMsg("item_init")
    self:BindMsg("item_drop")
    self:BindMsg("item_sell")
    self:BindMsg("gm_cmd")
    self:BindMsg("item_lock")
    self:BindMsg("item_use")
    self:BindMsg("item_reward")
    self:BindMsg("item_update")
    self:BindMsg("role_asset_info")
    self:BindMsg("weapon_init")
    self:BindMsg("weapon_update")
    self:BindMsg("weapon_lock")
    self:BindMsg("partner_init")
    self:BindMsg("partner_update")
end

function BagProxy:Recv_item_init(data)
    mod.BagCtrl:InitBag(data)
end

function BagProxy:Send_item_drop(data)
    return { item_list = data }
end

function BagProxy:Send_item_sell(data)
    return { item_list = data }
end

function BagProxy:Send_item_lock(unique_id, is_lock)
    return { unique_id = unique_id, is_lock = is_lock }
end

function BagProxy:Send_item_use(data)
    return { unique_id = data.unique_id, count = data.count }
end

function BagProxy:Recv_item_use(data)
    if data.error_code ~= 0 then
        LogError("使用道具 服务器错误码："..data.error_code)
        return
    end
    EventMgr.Instance:Fire(EventName.ItemUse)
end

function BagProxy:Send_gm_cmd(cmd_str)
    return {cmd_str = cmd_str}
end

function BagProxy:Recv_item_reward(data)
	if data.reward_src == ItemConfig.RewardSrc.Duplicate then
		return
	end

    if data.reward_src == ItemConfig.RewardSrc.Alchemy then
        mod.AlchemyCtrl:InitAllNowLimit()
        EventMgr.Instance:Fire(EventName.GetAlchemyAward,data.reward_list)
        PanelManager.Instance:OpenPanel(AlchemyGetItemPanel,data.reward_list)
        return
    end

    -- 佩从奖励列表
    local rewardList = data.reward_list
    local showPartnerList = {}
    -- 道具来源是掉落的情况下
    if data.reward_src == ItemConfig.RewardSrc.Collect then
        for _, reward in pairs(rewardList) do
            local itemId = reward.template_id
            if self:CheckShowGetPartnerPanel(itemId) then
                BehaviorFunctions.fight.noticeManger:AddNewGetPartner(itemId)
            end
        end
    end

    if ItemConfig.IsShowTip(data.reward_src) or self:CheckShowPartnerItemTip(rewardList, data.reward_src) then
        --EventMgr.Instance:Fire(EventName.AddCenterContent, GetItemPanel, TipQueueManger.TipPriority.CommonTip, {reward_list = rewardList})
        BehaviorFunctions.fight.noticeManger:AddGetItemPanel(rewardList)
    elseif data.reward_src == ItemConfig.RewardSrc.Task and mod.TaskCtrl:CheckIsShowReward(data.ex_arg_list[1]) then
        --EventMgr.Instance:Fire(EventName.AddCenterContent, GetItemPanel, TipQueueManger.TipPriority.CommonTip, {reward_list = rewardList})
        BehaviorFunctions.fight.noticeManger:AddGetItemPanel(rewardList)

    elseif data.reward_src == ItemConfig.RewardSrc.Teach then
        BehaviorFunctions.fight.teachManager:RetTeachLookReward(rewardList)
    end

    mod.BagCtrl:ChackPartnerShowPanel()

    EventMgr.Instance:Fire(EventName.ItemRecv, rewardList, data.reward_src)
end

function BagProxy:CheckShowPartnerItemTip(item_list, reward_src)
    if reward_src ~= ItemConfig.RewardSrc.Collect and reward_src ~= ItemConfig.RewardSrc.AutoCollect then
        return
    end

    for _, reward in pairs(item_list) do
        local itemId = reward.template_id
        local cfg = ItemConfig.GetItemConfig(itemId)
        local itemType = ItemConfig.GetItemType(itemId)
        if itemType == BagEnum.BagType.Partner and cfg then
            if cfg.show_drop_type == RoleConfig.PartnerShowType.showEffect then
                return true
            end
        end
    end
    return false
end

function BagProxy:CheckShowGetPartnerPanel(id)
    local itemType = ItemConfig.GetItemType(id)
    if itemType ~= BagEnum.BagType.Partner then
        return false
    end
    local cfg = ItemConfig.GetItemConfig(id)
    if not cfg then return end

    local showType = cfg.show_drop_type
    if showType == RoleConfig.PartnerShowType.defGet then
        return true
    end
    return false
end

function BagProxy:Recv_item_update(data)
    mod.BagCtrl:UpdateBag(data)
end

function BagProxy:Recv_role_asset_info(data)
    mod.BagCtrl:UpdateBag({add_list = { { count = data.gold, is_locked = false, template_id = 2, unique_id = 0 },
                                        { count = data.diamond, is_locked = false, template_id = 3, unique_id = 0 },
                                        { count = data.power, is_locked = false, template_id = 8, unique_id = 0 },
    }, mod_list = {}, del_list = {} }, BagEnum.BagType.Currency)
end

function BagProxy:Recv_weapon_init(data)
    mod.BagCtrl:InitBag(data, BagEnum.BagType.Weapon)
end

function BagProxy:Recv_weapon_update(data)
    mod.BagCtrl:UpdateBag(data, BagEnum.BagType.Weapon)
end

function BagProxy:Send_weapon_lock(unique_id, is_lock)
    return {weapon_id = unique_id, is_lock = is_lock}
end

function BagProxy:Recv_partner_init(data)
    mod.BagCtrl:InitBag(data, BagEnum.BagType.Partner)
end

function BagProxy:Recv_partner_update(data)
    mod.BagCtrl:UpdateBag(data, BagEnum.BagType.Partner)

    if data.add_list then
        for _, v in ipairs(data.add_list) do
            mod.BagCtrl:ReceivePartner(v.template_id)
        end
    end

end