AssetPurchaseConfig = AssetPurchaseConfig or {}

local DataAssetPurchase = Config.DataAssetPurchase.Find
local DataAssetAgreement = Config.DataAssetAgreement.Find
local DataAssetAgreementShow = Config.DataAssetAgreementShow.Find

local DataAssetLevelUp = Config.DataAssetLevelUp.Find
local DataAssetDeviceLevelUp  = Config.DataAssetDeviceLevelUp.Find
local DataAssetBasic = Config.DataAssetBasic.Find
local DataAssetDevice = Config.DataAssetDevice.Find
local DataAssetPartnerCommon = Config.DataAssetPartnerCommon.Find
local DataAssetOperateState = Config.DataAssetOperateState.Find

AssetPurchaseConfig.DeviceTypeEnum = {
    None = 0,  --无
    Production = 1, --生产类型
    Base = 2, --基础类型设备
    EatTable = 3, --饭桌类型
    Bed = 4,    --床
    Other = 5, --其他类型
}

function AssetPurchaseConfig.GetPartnerBallStaffNum(deviceId, assetLevel)
    local key = string.format("%s_%s", deviceId, assetLevel)

    if DataAssetDeviceLevelUp[key] then
        return DataAssetDeviceLevelUp[key].staff_num
    end
end

function AssetPurchaseConfig.GetGameplayTeachId(modelName)
    if DataAssetPartnerCommon[modelName] then
        return DataAssetPartnerCommon[modelName].int_val
    end

    return nil
end
function AssetPurchaseConfig.GetPartnerCollectTime()
    if DataAssetPartnerCommon["PartnerCollectTime"] then
        return DataAssetPartnerCommon["PartnerCollectTime"].int_val
    end
end

function AssetPurchaseConfig.GetAssetStaffNum(assetId,level)
    local key = string.format("%d_%d",assetId,level)
    return DataAssetLevelUp[key].staff_num
end

function AssetPurchaseConfig.GetAssetConfig()
    return DataAssetBasic
end

function AssetPurchaseConfig.GetAssetConfigById(id)
    return DataAssetBasic[id]
end

function AssetPurchaseConfig.GetAssetPurchaseConfigById(id)
    for  k, v in pairs(DataAssetPurchase) do
        if id == v.asset_id then
            return v
        end
    end
end

function AssetPurchaseConfig.GetAssetPurchaseList()
    local AssetPurchaseList = {}
    for  k, v in pairs(DataAssetPurchase) do
        table.insert(AssetPurchaseList, v)
    end
    return AssetPurchaseList
end

function AssetPurchaseConfig.GetAssetDeviceInfoById(id)
    return DataAssetDevice[id]
end

function AssetPurchaseConfig.GetAssetAgreementById(id)
    return DataAssetAgreement[id]
end

function  AssetPurchaseConfig.GetAssetAgreementShowById(id)
    local AgreementShowTable = {}
    for k, v in pairs(DataAssetAgreementShow) do
        if v.show_group_id == id then
            if AgreementShowTable[v.group_id] == nil then
                AgreementShowTable[v.group_id] = {}
            end
            table.insert(AgreementShowTable[v.group_id], v)
        end
    end
    return AgreementShowTable
end

function  AssetPurchaseConfig.GetAssetAgreementShowListById(id)
    local AgreementShowTable = {}
    local AgreementShowList = {}
    for k, v in pairs(DataAssetAgreementShow) do
        if v.show_group_id == id then
            if AgreementShowTable[v.group_id] == nil then
                AgreementShowTable[v.group_id] = {}
                table.insert(AgreementShowList, v.group_id)
            end
        end
    end
    return AgreementShowList
end

function AssetPurchaseConfig.GetAssetStateIcon(present)
    local val = math.floor( present + 0.5 )
    for i, v in ipairs(DataAssetOperateState) do
        if val >= v.scale[1] and val <= v.scale[2] then
            return v.icon
        end
    end
end