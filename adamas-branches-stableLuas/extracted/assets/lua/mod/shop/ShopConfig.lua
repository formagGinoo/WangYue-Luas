ShopConfig = ShopConfig or {}

local DataShop = Config.DataShop
local DataItem = Config.DataItem.Find
local DataWeapon = Config.DataWeapon.Find

ShopConfig.ShopType = 
{
    ["NPCShop"] = 101,
    ["EntityShop"] = 102,
    ["UIExchangeShop"] = 103
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

function ShopConfig.GetShopTypeByShopId(shopId)
    if shopId then
        return DataShop.Find[shopId].shop_type
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