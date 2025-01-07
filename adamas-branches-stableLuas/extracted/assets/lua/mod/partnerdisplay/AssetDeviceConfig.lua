AssetDeviceConfig = AssetDeviceConfig or {}
local AssetDeviceLevelUpCfg = Config.DataAssetDeviceLevelUp.Find
local DecorationItemshowCfg = Config.DataDecorationItemshow.Find
local DecorationItem = Config.DataDecorationItem.Find
local AssetPartnerCollect = Config.DataAssetPartnerCollect.Find
local AssetPartnerCatch = Config.DataAssetPartnerCatch.Find



function AssetDeviceConfig.GetStaffNum(id, level)
    local result = 0
    for k, v in pairs(AssetDeviceLevelUpCfg) do
        if v.id == id and v.level <= level then
            result = math.max(result,v.staff_num) 
        end
    end
    return result
end

-- 获取演出类型
function AssetDeviceConfig.GetShowType(id)

    return DecorationItemshowCfg[id] and DecorationItemshowCfg[id].show_type
end

-- 获取演出标签信息
function AssetDeviceConfig.GetDecorationItemShow(id)

    if DecorationItemshowCfg[id] and DecorationItem[id] then
        return DecorationItemshowCfg[id].special_icon ,DecorationItemshowCfg[id].icon_radius, DecorationItemshowCfg[id].item_name and DecorationItem[id].name  or "",DecorationItemshowCfg[id].name_radius ,DecorationItemshowCfg[id].assetitem_text_icon_bigger/10000
    end

end
-- 获取产物标签信息
function AssetDeviceConfig.GetDecorationCollecthow(id)

    if DecorationItemshowCfg[id] and DecorationItem[id] then
        return DecorationItemshowCfg[id].priduct_show ,DecorationItemshowCfg[id].priduct_radius ^ 2
    end

end
-- 获取演出标签信息
function AssetDeviceConfig.GetDecorationCollectItemIcon(product_id)

    if AssetPartnerCollect[product_id] then
        return  ItemConfig.GetItemIcon(AssetPartnerCollect[product_id].item)
    else
        for k, v in pairs(AssetPartnerCatch) do
            if v.asset_product_id == product_id then
                return ItemConfig.GetItemIcon(v.item)
            end
        end
    end

end
