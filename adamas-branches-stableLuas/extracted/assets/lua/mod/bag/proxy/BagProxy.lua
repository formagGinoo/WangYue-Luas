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
    self:BindMsg("energy_info")
    self:BindMsg("item_exchange")
    self:BindMsg("item_use_energy")
    self:BindMsg("partner_lock")
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
    mod.BagCtrl:RecvItemReward(data)
end

function BagProxy:MixList(data)
    local newRewardList = {}
    for k, info in pairs(data.reward_list) do
        if not newRewardList[info.template_id] then
            newRewardList[info.template_id] = info
        else
            newRewardList[info.template_id].count = info.count + newRewardList[info.template_id].count
        end
    end
    return newRewardList
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

function BagProxy:Recv_item_update(data)
    mod.BagCtrl:UpdateBag(data)
end

function BagProxy:Recv_role_asset_info(data)
    mod.BagCtrl:UpdateBag({add_list = { { count = data.gold, is_locked = false, template_id = 2, unique_id = 0 },
                                        { count = data.bind_diamond, is_locked = false, template_id = 3, unique_id = 0 },
                                        { count = data.diamond, is_locked = false, template_id = 4, unique_id = 0 },
                                        { count = data.power, is_locked = false, template_id = 8, unique_id = 0 },
										{ count = data.mercenary_medal, is_locked = false, template_id = 6, unique_id = 0 },
                                        { count = data.gundam_copper, is_locked = false, template_id = 13, unique_id = 0 },
                                        { count = data.city_copper, is_locked = false, template_id = 14, unique_id = 0 },
										{ count = data.skill_book_copper, is_locked = false, template_id = 15, unique_id = 0 },
                                        { count = data.paota_hexin, is_locked = false, template_id = 16, unique_id = 0 },
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

function BagProxy:Send_partner_lock(unique_id, is_lock)
    return { partner_id = unique_id, is_lock = is_lock }
end

function BagProxy:Recv_energy_info(data)
	mod.BagCtrl:UpdateStrengthData(data)
end

function BagProxy:Send_item_exchange(exchangeList, isShow)
    if isShow == nil then
        isShow = true
    end
	return { exchange_list = exchangeList, is_show = isShow }
end

function BagProxy:Recv_item_exchange(data)
	mod.BagCtrl:UpdateExchangeData(data)
end

function BagProxy:Send_item_use_energy(itemList)
	return { item_list = itemList }
end
