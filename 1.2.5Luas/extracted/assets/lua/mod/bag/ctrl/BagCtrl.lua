---@class BagCtrl
BagCtrl = BaseClass("BagCtrl", Controller)

local _tinsert = table.insert

LOCAL_BAG = LOCAL_BAG or {}
LOCAL_ITEM = LOCAL_ITEM or {}
local origin_item_table = {}

function BagCtrl:__init()
    self.volume = {}
    self.frameShowTips = {}
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

    EventMgr.Instance:Fire(EventName.ItemUpdate)
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
                Fight.Instance.playerManager:GetPlayer():WeaponAttrChange(newItem.hero_id, oldItem, newItem)
            end
        end

        if type == BagEnum.BagType.Partner then
            EventMgr.Instance:Fire(EventName.PartnerInfoChange, oldItem, newItem)
            if oldItem.hero_id == newItem.hero_id then
                Fight.Instance.playerManager:GetPlayer():PartnerAttrChanged(newItem.hero_id, oldItem, newItem)
            end
        end
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
        elseif type == BagEnum.BagType.Item then
            local itemConfig = ItemConfig.GetItemConfig(template_id)
            if not itemConfig or not next(itemConfig) then
                LogError("找不到道具配置 id = "..template_id)
                return
            end
            LOCAL_BAG[type][itemConfig.bag_type][unique_id] = nil
        else
            LOCAL_BAG[type][unique_id] = nil
        end

        ::continue::
    end
end

function BagCtrl:RemoveItem(datas)
    if next(datas) == nil then
        return
    end

    mod.BagFacade:SendMsg("item_sell", datas)
end

---comment
---@param data { unique_id:integer, count:integer}
function BagCtrl:UseItem(data)
    mod.BagFacade:SendMsg("item_use", data)
end

---comment
function BagCtrl:SetItemLockState(unique_id, is_lock, itemType)
    if itemType == BagEnum.BagType.Item then
        mod.BagFacade:SendMsg("item_lock", unique_id, is_lock)
    elseif itemType == BagEnum.BagType.Weapon then
        mod.BagFacade:SendMsg("weapon_lock", unique_id, is_lock)
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
    if not LOCAL_ITEM[itemId] then
        return 0, false
    end
    local count = 0
    for k, v in pairs(LOCAL_ITEM[itemId]) do
        count = count + v.count
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

    if not a.isEquip and not b.isEquip then
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality < bConfig.quality
        end

        if aConfig.star ~= bConfig.star then
            return aConfig.star < bConfig.star
        end
    elseif a.isEquip and b.isEquip then
        if a.lev ~= b.lev then
            return a.lev < b.lev
        elseif aConfig.quality ~= bConfig.quality then
            return aConfig.quality < bConfig.quality
        elseif a.star ~= b.star then
            return a.star < b.star
        end
    end

    return aConfig.order_id < bConfig.order_id
end

function BagCtrl:SortBagByLvl(a, b)
    local aConfig = ItemConfig.GetItemConfig(a.template_id)
    local bConfig = ItemConfig.GetItemConfig(b.template_id)

    if not a.isEquip and not b.isEquip then
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality > bConfig.quality
        end

        if aConfig.star ~= bConfig.star then
            return aConfig.star > bConfig.star
        end
    elseif a.isEquip and b.isEquip then
        if a.lev ~= b.lev then
            return a.lev > b.lev
        elseif aConfig.quality ~= bConfig.quality then
            return aConfig.quality > bConfig.quality
        elseif a.star ~= b.star then
            return a.star > b.star
        end
    end

    return aConfig.order_id > bConfig.order_id
end

--#endregion


--#region 武器部分

function BagCtrl:GetWeaponData(uniqueId, roleId)
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
        if not RoleConfig.GetRoleConfig(roleId) then
            LogError("不存在的角色ID：".. roleId)
        end
		weaponData.template_id = RoleConfig.GetRoleConfig(roleId).weapon_init_id
        Log(string.format("没用获取到角色[%s]佩戴的武器，使用了默认的武器[%s]", roleId, weaponData.template_id))
	end
    return weaponData
end
--#endregion

--#region 佩从部分
---@class PartnerData
---@field skill_list table
---@field template_id number
---@field uniqueId number

---@return PartnerData
function BagCtrl:GetPartnerData(uniqueId)
    if uniqueId then
        return self:GetItemByUniqueId(uniqueId, BagEnum.BagType.Partner)
    end
end

function BagCtrl:GetPartnerSkillLevel(uniqueId, skillId)
    local data = self:GetPartnerData(uniqueId)
    if data then
        for key, skill in pairs(data.skill_list) do
            if skill.key == skillId then
                return skill.value
            end
        end
    end
end

function BagCtrl:RecvPartnerData(data)
    if not self.histroyPartnerData then
        self.histroyPartnerData = {}
        for k, v in ipairs(data) do
            self.histroyPartnerData[v.key] = true
        end
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

function BagCtrl:ChackPartnerShowPanel()
    for _, v in ipairs(self.frameShowTips) do
        BehaviorFunctions.fight.noticeManger:AddNewPartner(v)
    end
    self.frameShowTips = {}
end
--#endregion