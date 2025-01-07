---@class BagCtrl
BagCtrl = BaseClass("BagCtrl", Controller)

local _tinsert = table.insert

LOCAL_BAG = LOCAL_BAG or {}
LOCAL_ITEM = LOCAL_ITEM or {}
local origin_item_table = {}
local DataItemShow = Config.DataItemShow.Find
function BagCtrl:__init()
    self.volume = {}
    self.frameShowTips = {}
    self.itemObtainedCount = {}
	self.bagInfo = {}
    self.itemObtainedCount = {}
    self.histroyPartnerData = {}
    self.importantList = {}
    self.importantTips = {}
end
 
function BagCtrl:InitBag(data, type)
    if not type then
        type = BagEnum.BagType.Item
    end

    self:AddItemToBag(data.item_list, type)
    self.volume[type] = data.volume

    EventMgr.Instance:Fire(EventName.ItemUpdate)
end

function BagCtrl:UpdateBag(data, type)
	if not type then
		type = BagEnum.BagType.Item
	end

    self:AddItemToBag(data.add_list, type)
    self:ChangeBagItem(data.mod_list, type)
    self:DeleteBagItem(data.del_list, type)

    if #data.add_list > 0 or #data.del_list > 0 then
        EventMgr.Instance:Fire(EventName.ItemUpdate)
    end
    for i, v in ipairs(data.mod_list) do
        EventMgr.Instance:Fire(EventName.BagItemChange, v)
    end
end

function BagCtrl:AddItemToBag(addList, type)
    if not origin_item_table[type] then
        origin_item_table[type] = {}
    end
    for i = 1, #addList do
        --origin_item_table[addList[i].unique_id] = { unique_id = addList[i].unique_id, count = addList[i].count, template_id = addList[i].template_id }
        if type == BagEnum.BagType.Currency then
            origin_item_table[type][addList[i].template_id] = UtilsBase.copytab(addList[i])
        else
            origin_item_table[type][addList[i].unique_id] = UtilsBase.copytab(addList[i])
        end

        if not LOCAL_ITEM[addList[i].template_id] then
            LOCAL_ITEM[addList[i].template_id] = {}
        end

        if type == BagEnum.BagType.Currency then
            LOCAL_ITEM[addList[i].template_id][addList[i].unique_id] = origin_item_table[type][addList[i].template_id]
        else
            LOCAL_ITEM[addList[i].template_id][addList[i].unique_id] = origin_item_table[type][addList[i].unique_id]
        end

        if not LOCAL_BAG[type] then
            LOCAL_BAG[type] = {}
        end

        if type == BagEnum.BagType.Item then
            local itemConfig = ItemConfig.GetItemConfig(addList[i].template_id)
            if not itemConfig or not next(itemConfig) then
                LogError("找不到道具配置 id = "..addList[i].template_id)
                return
            end

            if not LOCAL_BAG[type][itemConfig.bag_type] then
                LOCAL_BAG[type][itemConfig.bag_type] = {}
            end
            
            LOCAL_BAG[type][itemConfig.bag_type][addList[i].unique_id] = origin_item_table[type][addList[i].unique_id]
            self:CapacityChange(BagEnum.BagType.Item, 1)
        elseif type == BagEnum.BagType.Weapon then
            local itemConfig = ItemConfig.GetItemConfig(addList[i].template_id)
            if not itemConfig or not next(itemConfig) then
                LogError("找不到武器配置 id = "..addList[i].template_id)
                return
            end

            if not LOCAL_BAG[type][itemConfig.type] then
                LOCAL_BAG[type][itemConfig.type] = {}
            end

            LOCAL_BAG[type][itemConfig.type][addList[i].unique_id] = origin_item_table[type][addList[i].unique_id]
            self:CapacityChange(BagEnum.BagType.Weapon, 1)
        elseif type == BagEnum.BagType.Currency then
            LOCAL_BAG[type][addList[i].template_id] = origin_item_table[type][addList[i].template_id]
        else
            LOCAL_BAG[type][addList[i].unique_id] = origin_item_table[type][addList[i].unique_id]
        end
    end
end

function BagCtrl:ChangeBagItem(changeList, type)
    for i = 1, #changeList do
        if not origin_item_table[type][changeList[i].unique_id] then
            goto continue
        end
        --local oldItem = origin_item_table[type][changeList[i].unique_id] or {}
        local oldItem = UtilsBase.copytab(origin_item_table[type][changeList[i].unique_id]) or {}
        local newItem = changeList[i]
        for key, value in pairs(changeList[i]) do
            origin_item_table[type][changeList[i].unique_id][key] = value
        end
        
        if type == BagEnum.BagType.Weapon then
            EventMgr.Instance:Fire(EventName.WeaponInfoChange, oldItem, newItem)
            if oldItem.hero_id == newItem.hero_id then
                if Fight.Instance then
                    Fight.Instance.playerManager:GetPlayer():WeaponAttrChange(newItem.hero_id, oldItem, newItem)
                end
                mod.RoleCtrl:SyncRoleBaseProperty(newItem.hero_id)
            end
        end

        if type == BagEnum.BagType.Partner then
            EventMgr.Instance:Fire(EventName.PartnerInfoChange, oldItem, newItem)
            if oldItem.hero_id == newItem.hero_id then
                if Fight.Instance then
                    Fight.Instance.playerManager:GetPlayer():PartnerAttrChanged(newItem.hero_id, oldItem, newItem)
                end
                mod.RoleCtrl:SyncRoleBaseProperty(newItem.hero_id)
            end
        end
        EventMgr.Instance:Fire(EventName.ItemChange, changeList[i].unique_id, type)
        ::continue::
    end
end

function BagCtrl:DeleteBagItem(delList, type)
    for i = 1, #delList do
        local unique_id = delList[i]
        local template_id = origin_item_table[type][unique_id].template_id
        if not origin_item_table[type][unique_id] then
            goto continue
        end

        TableUtils.ClearTable(origin_item_table[type][unique_id])

		origin_item_table[type][unique_id] = nil
        LOCAL_ITEM[template_id][unique_id] = nil

        if type == BagEnum.BagType.Weapon then
            local itemConfig = ItemConfig.GetItemConfig(template_id)
            if not itemConfig or not next(itemConfig) then
                LogError("找不到武器配置 id = "..template_id)
                return
            end
            LOCAL_BAG[type][itemConfig.type][unique_id] = nil
            self:CapacityChange(BagEnum.BagType.Weapon, -1)
        elseif type == BagEnum.BagType.Item then
            local itemConfig = ItemConfig.GetItemConfig(template_id)
            if not itemConfig or not next(itemConfig) then
                LogError("找不到道具配置 id = "..template_id)
                return
            end
            LOCAL_BAG[type][itemConfig.bag_type][unique_id] = nil
            self:CapacityChange(BagEnum.BagType.Item, -1)
        else
            LOCAL_BAG[type][unique_id] = nil
        end
        EventMgr.Instance:Fire(EventName.ItemDelete, unique_id, type)
        ::continue::
    end
end

function BagCtrl:RemoveItem(datas)
    if next(datas) == nil then
        return
    end

    mod.BagFacade:SendMsg("item_sell", datas)
end

function BagCtrl:CapacityChange(type, value)
    self.bagInfo[type] = self.bagInfo[type] or {}
    self.bagInfo[type].count = self.bagInfo[type].count or 0
    self.bagInfo[type].count = self.bagInfo[type].count + value
end

function BagCtrl:GetCapacity(type)
    self.bagInfo[type] = self.bagInfo[type] or {}
    self.bagInfo[type].count = self.bagInfo[type].count or 0
    return self.bagInfo[type].count, self.volume[type] or 0
end

---comment
---@param data { unique_id:integer, count:integer}
function BagCtrl:UseItem(data)
    EventMgr.Instance:Fire(EventName.PauseTipQueue)
    local orderId, protoId = mod.BagFacade:SendMsg("item_use", data)
    SystemConfig.WaitProcessing(orderId, protoId, function ()
        EventMgr.Instance:Fire(EventName.ResumeTipQueue)
    end)
end

---comment
function BagCtrl:SetItemLockState(unique_id, is_lock, itemType)
    if itemType == BagEnum.BagType.Item then
        mod.BagFacade:SendMsg("item_lock", unique_id, is_lock)
    elseif itemType == BagEnum.BagType.Weapon then
        mod.BagFacade:SendMsg("weapon_lock", unique_id, is_lock)
    elseif itemType == BagEnum.BagType.Partner then
        mod.BagFacade:SendMsg("partner_lock", unique_id, is_lock)
    end
end

function BagCtrl:GetBagByType(bagType, secondBagType)
    bagType = bagType or BagEnum.BagType.Item
    if LOCAL_BAG[bagType] and secondBagType then
        return LOCAL_BAG[bagType][secondBagType]
    elseif LOCAL_BAG[bagType] then
        return LOCAL_BAG[bagType]
    end
	return {}
end

function BagCtrl:GetItemInBag(itemId)
    return LOCAL_ITEM[itemId]
end

--获得指定物品数量
function BagCtrl:GetItemCountById(itemId)
    if itemId == ItemConfig.StrengthId then
        local val = self:GetStrengthData()
        return val
    end

    if not LOCAL_ITEM[itemId] then
        return 0, false
    end
    local count = 0
    for k, v in pairs(LOCAL_ITEM[itemId]) do
        count = count + (v.count or 1)
    end
    return count, true
end

function BagCtrl:GetItemsById(itemId)
    return LOCAL_ITEM[itemId] or {}
end

function BagCtrl:GetGoldCount()
    local currency = self:GetBagByType(BagEnum.BagType.Currency)
    for k, info in pairs(currency) do
        if info.template_id == 2 then
            return info.count
        end
    end
    return 0
end

function BagCtrl:GetItemByUniqueId(uniqueId, type)
    type = type or BagEnum.BagType.Item
    if origin_item_table[type] and origin_item_table[type][uniqueId] then
		local data = origin_item_table[type][uniqueId]
        return data
    end
end

--#region 背包排序

function BagCtrl:SortBag(secondBagType, sortType, isAscending, bagType)
    isAscending = isAscending or false
    bagType = bagType or BagEnum.BagType.Item
    local bagData
    if bagType == BagEnum.BagType.Item and LOCAL_BAG[bagType] then
        bagData = UtilsBase.copytab(LOCAL_BAG[bagType][secondBagType]) or {}
    elseif bagType == BagEnum.BagType.Weapon then
        if not secondBagType then
            bagData = UtilsBase.copytab(origin_item_table[bagType])
        else
            bagData = UtilsBase.copytab(LOCAL_BAG[bagType][secondBagType])
        end
    elseif bagType == BagEnum.BagType.Partner then
        bagData = UtilsBase.copytab(origin_item_table[bagType]) or {}
    end
  
    if not bagData or not next(bagData) then
        return bagData
    end

    if sortType == BagEnum.SortType.Quality then
        if isAscending then
            return UtilsBase.BubbleSort(bagData, self:ToFunc("SortBagByQualityAndAscending"))
        else
            return UtilsBase.BubbleSort(bagData, self:ToFunc("SortBagByQuality"))
        end
    elseif sortType == BagEnum.SortType.Lvl then
        if isAscending then
            return UtilsBase.BubbleSort(bagData, self:ToFunc("SortBagByLvlAndAscending"))
        else
            return UtilsBase.BubbleSort(bagData, self:ToFunc("SortBagByLvl"))
        end
    end
end

function BagCtrl:SortItemData(itemList, sortType, isAscending)
    local isAscending = isAscending or false
    if not itemList or not next(itemList) then
        return itemList
    end

    if sortType == BagEnum.SortType.Quality then
        if isAscending then
            return UtilsBase.BubbleSort(itemList, self:ToFunc("SortBagByQualityAndAscending"))
        else
            return UtilsBase.BubbleSort(itemList, self:ToFunc("SortBagByQuality"))
        end
    elseif sortType == BagEnum.SortType.Lvl then
        if isAscending then
            return UtilsBase.BubbleSort(itemList, self:ToFunc("SortBagByLvlAndAscending"))
        else
            return UtilsBase.BubbleSort(itemList, self:ToFunc("SortBagByLvl"))
        end
    end
end

function BagCtrl:SortBagByQualityAndAscending(a, b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    if aConfig.quality ~= bConfig.quality then
        return aConfig.quality < bConfig.quality
    end

    if not a.isEquip and not b.isEquip then
        if aConfig.star ~= bConfig.star then
            return aConfig.star < bConfig.star
        end
    elseif a.isEquip and b.isEquip then
        if a.star ~= b.star then
            return a.star < b.star
        elseif a.lev ~= b.lev then
            return a.lev < b.lev
        end
    end

    return aConfig.order_id < bConfig.order_id
end

function BagCtrl:SortBagByQuality(a, b)
    --Log(a.template_id)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)
    if aConfig.quality ~= bConfig.quality then
        return aConfig.quality > bConfig.quality
    end

    if not a.isEquip and not b.isEquip then
        if aConfig.star ~= bConfig.star then
            return aConfig.star > bConfig.star
        end
    elseif a.isEquip and b.isEquip then
        if a.star ~= b.star then
            return a.star > b.star
        elseif a.lev ~= b.lev then
            return a.lev > b.lev
        end
    end

    return aConfig.order_id > bConfig.order_id
end

function BagCtrl:SortBagByLvlAndAscending(a, b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)

    -- 佩戴 > 其他
    while a.hero_id and b.hero_id do
        if a.hero_id == 0 and b.hero_id == 0 then
            break
        elseif a.hero_id > 0 and b.hero_id > 0 then
            break
        elseif a.hero_id > 0 then
            return true
        elseif b.hero_id > 0 then
            return false
        end
        break
    end

    if a.stage and b.stage and a.stage ~= b.stage then
        return a.stage < b.stage
    end

    if a.lev and b.lev and a.lev ~= b.lev then
        return a.lev < b.lev
    end

    if aConfig.quality and bConfig.quality and aConfig.quality ~= bConfig.quality then
        return aConfig.quality < bConfig.quality
    end

    if a.refine and b.refine and a.refine ~= b.refine then
        return a.refine < b.refine
    end

    return aConfig.order_id < bConfig.order_id
end

function BagCtrl:SortBagByLvl(a, b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)

    -- 佩戴 > 其他
    while a.hero_id and b.hero_id do
        if a.hero_id == 0 and b.hero_id == 0 then
            break
        elseif a.hero_id > 0 and b.hero_id > 0 then
            break
        elseif a.hero_id > 0 then
            return true
        elseif b.hero_id > 0 then
            return false
        end
        break
    end

    if a.stage and b.stage and a.stage ~= b.stage then
        return a.stage > b.stage
    end

    if a.lev and b.lev and a.lev ~= b.lev then
        return a.lev > b.lev
    end

    if aConfig.quality and bConfig.quality and aConfig.quality ~= bConfig.quality then
        return aConfig.quality > bConfig.quality
    end

    if a.refine and b.refine and a.refine ~= b.refine then
        return a.refine > b.refine
    end

    return aConfig.order_id > bConfig.order_id
end

--#endregion


--#region 武器部分

function BagCtrl:GetWeaponData(uniqueId, roleId, uid)
    if uid then 
        return mod.FriendCtrl:GetFriendWeaponInfo(uniqueId,uid)
    end
    local weaponData
    if uniqueId then
        weaponData = self:GetItemByUniqueId(uniqueId, BagEnum.BagType.Weapon)
    end
    if not weaponData and roleId then
        weaponData = {
            unique_id = 1,
            is_lock = false,
            lev = 1,
            stage = 0,
            refine = 1,
            exp = 0
        }
        if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
            local robotCfg = RobotConfig.GetRobotHeroCfgById(roleId)
            roleId = robotCfg.hero_id
            weaponData.template_id = robotCfg.weapon_id
            weaponData.lev = robotCfg.weapon_level
            weaponData.stage = robotCfg.weapon_stage
            weaponData.refine = robotCfg.weapon_star
        end
        if not RoleConfig.GetRoleConfig(roleId) then
            LogError("不存在的角色ID：".. roleId)
        end
        if not weaponData.template_id then
            weaponData.template_id = RoleConfig.GetRoleConfig(roleId).weapon_init_id
        end
        Log(string.format("没用获取到角色[%s]佩戴的武器，使用了默认的武器[%s]", roleId, weaponData.template_id))
    end
    return weaponData
end
--#endregion

--#region 月灵部分
---@class PartnerData
---@field skill_list table
---@field template_id number
---@field uniqueId number

---@return PartnerData
function BagCtrl:GetPartnerData(uniqueId,uid, roleId)
    if uid then 
        return mod.FriendCtrl:GetFriendPartnerInfo(uniqueId,uid)
    end
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        local robotCfg = RobotConfig.GetRobotHeroCfgById(roleId)
        --local partnerCfg = RoleConfig.GetPartnerConfig(robotCfg.partner_id)
        local data = {
            template_id = robotCfg.partner_id,
            lev = robotCfg.partner_level,
            skill_list = {},
            panel_list = {},
            passive_skill_list = {},
            exp = 0,
        }
        local skill_list = RoleConfig.GetPartnerSkillList(robotCfg.partner_id, robotCfg.partner_level)
        for i, skillId in ipairs(skill_list) do
            if skillId ~= 0 then
                data.skill_list[i] = { key = skillId, value = 1}
            end
        end
        return data
    end
    if uniqueId and uniqueId ~= 0 then
        return self:GetItemByUniqueId(uniqueId, BagEnum.BagType.Partner)
    end
end

function BagCtrl:GetPartnerSkillLevel(uniqueId, skillId,uid)
    local data = self:GetPartnerData(uniqueId,uid)
    if data then
        for key, skill in pairs(data.skill_list) do
            if skill.key == skillId then
                return skill.value
            end
        end
    end
end

-- 获取所有月灵数据
function BagCtrl:GetPartnersData()
    return origin_item_table[BagEnum.BagType.Partner]
end

function BagCtrl:GetWeaponsData()
    return origin_item_table[BagEnum.BagType.Weapon]
end

function BagCtrl:RecvPartnerData(data)
    if not self.histroyPartnerData then
        self.histroyPartnerData = {}
    end
    
    for k, v in ipairs(data) do
        self.histroyPartnerData[v.key] = true
    end
end

function BagCtrl:ReceivePartner(partnerId)
    if not self.histroyPartnerData then
        self.histroyPartnerData = {}
    end
    local partnerInfo = ItemConfig.GetPartnerGroupInfo(partnerId)

    if not self.histroyPartnerData[partnerInfo.group] then
        self.histroyPartnerData[partnerInfo.group] = true
        if not partnerInfo.is_hide_tips then
            _tinsert(self.frameShowTips, partnerId)
        end
    end
end

function BagCtrl:CheckPartnerIsFirstShow(partnerId)
    for k, v in pairs(self.frameShowTips) do
        if v == partnerId then
            return true
        end
    end
    return false
end

function BagCtrl:RecvItemObtainedCount(data)
    for _, v in ipairs(data) do
        local itemId = v.key
        local num = v.value
        if not self.itemObtainedCount then
            self.itemObtainedCount = {}
        end
        
        self.itemObtainedCount[itemId] = num
    end

    --LogTable("道具获得历史次数", self.itemObtainedCount)
end

function BagCtrl:GetItemObtainedCount(itemId)
    return self.itemObtainedCount[itemId] or 0
end

function BagCtrl:CheckPartnerShowPanel()
    for _, v in ipairs(self.frameShowTips) do
        BehaviorFunctions.fight.noticeManger:AddNewPartner(v)
    end
    self.frameShowTips = {}
end
--#endregion

local StrengthItemId = 5
function BagCtrl:UpdateStrengthData(data)
	if not self.strengthData then
		local config = ItemConfig.GetItemConfig(StrengthItemId)
		if not config then
			LogError("获取体力配置错误")
			return 
		end
		
		local maxStrength = config.property2
		self.strengthData = {
			strength = data.energy,
			maxStrength = maxStrength,
			nextTimestamp = data.next_timestamp,
		}
	else
		self.strengthData.strength = data.energy
		self.strengthData.nextTimestamp = data.next_timestamp
	end

	EventMgr.Instance:Fire(EventName.StrengthUpdate, self.strengthData.strength, 
		self.strengthData.maxStrength, self.strengthData.nextTimestamp)
end

function BagCtrl:GetStrengthData()
	local data = self.strengthData
	if not data then
		return 0
	end
	
	return data.strength, data.maxStrength, data.nextTimestamp
end

--eg:{{key = 0, value = 1}, {key = 1, value = 30}}
function BagCtrl:ExchangeItem(exchangeList, isShow)
	mod.BagFacade:SendMsg("item_exchange", exchangeList, isShow)
end

function BagCtrl:UpdateExchangeData(data)
	if not self.exchangeData then
		self.exchangeData = {}
	end
	
	--目前空表表示清理含义
	if not data.exchange_list or not next(data.exchange_list) then
		self.exchangeData = {}
	end
	
	for _, v in pairs(data.exchange_list) do
		self.exchangeData[v.key] = v.value
	end
	
	EventMgr.Instance:Fire(EventName.ExchangeDataUpdate)
end

function BagCtrl:GetExchangeTimes(exchangeId)
	if not self.exchangeData then
		return
	end
	
	return self.exchangeData[exchangeId] or 0
end

function BagCtrl:RecvItemReward(data)
    if data.reward_src == ItemConfig.RewardSrc.CatchPartner then
        return
    end

    if data.reward_src == ItemConfig.RewardSrc.RandomEvent then
        mod.LevelEventCtrl:SetLevelEventRewardList(data.reward_list)
        return
    end

    if data.reward_src == ItemConfig.RewardSrc.Draw then
        EventMgr.Instance:Fire(EventName.DrawReward, {reward_list = data.reward_list})
        return
    end

    if data.reward_src == ItemConfig.RewardSrc.Alchemy then
        mod.AlchemyCtrl:InitAllNowLimit()
        EventMgr.Instance:Fire(EventName.GetAlchemyAward,data.reward_list)
        PanelManager.Instance:OpenPanel(AlchemyGetItemPanel,data.reward_list)
        return
    end

    -- 月灵奖励列表
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
    --重要物品奖励展示
    self:ShowImportantItem(data.reward_list)
    if self:CheckShowRewardPanel(data) then
        local fightData
        local eventData
		if data.reward_src == ItemConfig.RewardSrc.Strength then
			local strengthReward
			for _, v in pairs(data.reward_list) do
				if not strengthReward then
					strengthReward = TableUtils.CopyTable(v)
				else
					strengthReward.count = strengthReward.count + v.count
				end
			end
			rewardList = {strengthReward}
        elseif data.reward_src == ItemConfig.RewardSrc.RogueLike then
            local current_Event = mod.RoguelikeCtrl:GetCurrentEvent()
            eventData = {
                eventId = current_Event.eventId,
                finish_ts = current_Event.finish_ts,
            }
		end
        -- 充值做特殊处理 合并获得物品
        if data.reward_src == ItemConfig.RewardSrc.Purchase then
            rewardList = self:MixList(data)
        end
        local setting = {
            args =  {reward_list = rewardList, fightData = fightData, eventData = eventData}
        }
		EventMgr.Instance:Fire(EventName.AddSystemContent, GetItemPanel, setting)
    elseif data.reward_src == ItemConfig.RewardSrc.Teach then
        BehaviorFunctions.fight.teachManager:RetTeachLookReward(rewardList)
    elseif data.reward_src == ItemConfig.RewardSrc.ResDuplicate then
        BehaviorFunctions.fight.teachManager:RetTeachLookReward(rewardList)
    end

    self:CheckPartnerShowPanel()
    EventMgr.Instance:Fire(EventName.ItemRecv, rewardList, data.reward_src)
end

function BagCtrl:CheckShowRewardPanel(data)
    if ItemConfig.IsShowTip(data.reward_src) then
        return true
    elseif data.reward_src == ItemConfig.RewardSrc.Collect or data.reward_src == ItemConfig.RewardSrc.AutoCollect then
        local ecoId = data.ex_arg_list[1]
        local ecoCfg = Fight.Instance.entityManager:GetEntityConfigByID(ecoId)
        if ecoCfg and ecoCfg.show_reward then
            return true
        end

        for _, reward in pairs(data.reward_list) do
            local itemId = reward.template_id
            local cfg = ItemConfig.GetItemConfig(itemId)
            local itemType = ItemConfig.GetItemType(itemId)
            if itemType == BagEnum.BagType.Partner and cfg and cfg.show_drop_type == RoleConfig.PartnerShowType.showEffect then
                if mod.BagCtrl:CheckPartnerIsFirstShow(reward.template_id) then
                    return false
                end
                return true
            end
        end
    elseif data.reward_src == ItemConfig.RewardSrc.Task then
        -- TODO 确认这个可以用吗
        -- return mod.TaskCtrl:CheckIsShowReward(data.ex_arg_list[1])
        return mod.TaskCtrl:CheckIsShowReward(data.ex_arg_list[1], data.ex_arg_list[2])
    end

    return false
end

function BagCtrl:CheckShowGetPartnerPanel(id)
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

function BagCtrl:ShowImportantItem(rewardList)
    local importantList = self:GetImportantTipList(rewardList)
    if #importantList>0 then
        for k, v in pairs(importantList) do
            local setting = {
                args = {value = v}
            }
            EventMgr.Instance:Fire(EventName.AddSystemContent, ShowItemPanel, setting)
        end
    end
end

function BagCtrl:InitImportantItemList()
    for K, v in pairs(DataItemShow) do
        if v.id==1 then --类型1
            for i, templateId in pairs(v.reward_show_list) do
                if templateId~=0 then
                    self.importantList[templateId] = true
                end
            end
        elseif v.id==2 then
            for i, templateId in pairs(v.reward_show_list) do
                if templateId~=0 then
                    self.importantTips[templateId] = true
                end
            end
        end
    end
end
--检查是否含有重要物品
function BagCtrl:CheckIsHaveImportant(itemList)
    local count = 0
    if #self.importantList ==0 then
        self:InitImportantItemList()
    end
    for K, v in pairs(itemList) do
        if self.importantList[v.template_id] then
            count = count + 1
        end
    end
    if count >0 and count <#itemList then
        return true
    end
    return false
end
--获得需要额外弹窗物品
function BagCtrl:GetImportantTipList(itemList)
    if #self.importantTips ==0 then
        self:InitImportantItemList()
    end
    local list = {}
    for K, v in pairs(itemList) do
        if self.importantTips[v.template_id] then
            table.insert(list,v)
        end
    end
    return list
end

function BagCtrl:CheckIsInportantItem(templateId)
    return self.importantList[templateId]
end