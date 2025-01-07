ShopConfig = ShopConfig or {}

local DataShop = Config.DataShop
local DataItem = Config.DataItem.data_item
local DataWeapon = Config.DataWeapon.data_weapon

ShopConfig.ShopPanel = {
    [1001] = { shopPanel = NPCShopPanel },
    [1002] = { shopPanel = NPCShopPanel },
    [1003] = { shopPanel = NPCShopPanel },
    [1004] = { shopPanel = NPCShopPanel },
}

function ShopConfig.GetShopInfoById(shopId)
    if shopId then
        if DataShop.Find[shopId] then
            return DataShop.Find[shopId]
        end
    end
end

function ShopConfig.GetItemInfoById(itemId)
    if itemId then
        if DataItem[itemId] then
            return DataItem[itemId]
        end
    end
end

function ShopConfig.GetWeaponInfoById(weaponId)
    if weaponId then
        if DataWeapon[weaponId] then
            return DataWeapon[weaponId]
        end
    end
end

function ShopConfig.GetShopConditionById(shopId)
    return ShopConfig.GetShopInfoById(shopId).condition
end