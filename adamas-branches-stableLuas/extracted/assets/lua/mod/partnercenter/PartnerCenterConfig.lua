PartnerCenterConfig = PartnerCenterConfig or {}

local DataAssetPartnerCatch = Config.DataAssetPartnerCatch.Find
local DataAssetLevelUp = Config.DataAssetLevelUp.Find
local DataAssetDeviceLevelUp = Config.DataAssetDeviceLevelUp.Find
local DataAssetDevice = Config.DataAssetDevice.Find
local DataAssetPartnerCollect = Config.DataAssetPartnerCollect.Find
local DataAssetProduct = Config.DataAssetProduct.Find
local DataAssetDeviceFood = Config.DataAssetDeviceFood.Find
local DataAssetPartnerSkill = Config.DataAssetPartnerSkill.Find
local DataAssetPartnerSkillUnlock = Config.DataAssetPartnerSkillUnlock.Find
local DataPartnerSkill = Config.DataPartnerSkill.Find
local DataStaffTeamProgramme = Config.DataStaffTeamProgramme.Find
local DataAssetBasic = Config.DataAssetBasic.Find

local partnerSkillQualityIcon = {
    [1] = "Textures/Icon/Atlas/PartnerQualityIcon/v4_9img_bg_pinzhitiaobai.png",
    [2] = "Textures/Icon/Atlas/PartnerQualityIcon/v4_9img_bg_pinzhitiaolv.png",
    [3] = "Textures/Icon/Atlas/PartnerQualityIcon/v4_9img_bg_pinzhitiaolan.png",
    [4] = "Textures/Icon/Atlas/PartnerQualityIcon/v4_9img_bg_pinzhitiaozi.png",
    [5] = "Textures/Icon/Atlas/PartnerQualityIcon/v4_9img_bg_pinzhitiaohuang.png"
}

--设备类型
PartnerCenterConfig.DeviceType = 
{
    Produce = 1,        -- 生产类
    Basic = 2,          -- 基础功能类
    DiningTable = 3,    --饭桌
    Bed = 4,            --床
    Spec = 5,           --特殊功能类单位
}

--设备类型对应icon
PartnerCenterConfig.DeviceIcon =
{
    [PartnerCenterConfig.DeviceType.Produce] = "Textures/Icon/Single/FuncIcon/Trigger_collect.png",        -- 生产类
    [PartnerCenterConfig.DeviceType.Basic] = "Textures/Icon/Single/FuncIcon/Trigger_collect.png",          -- 基础功能类
    [PartnerCenterConfig.DeviceType.DiningTable] = "Textures/Icon/Single/FuncIcon/Trigger_collect.png",    --饭桌
    [PartnerCenterConfig.DeviceType.Bed] = "Textures/Icon/Single/FuncIcon/Trigger_collect.png",            --床
    [PartnerCenterConfig.DeviceType.Spec] = "Textures/Icon/Single/FuncIcon/Trigger_collect.png",           --特殊功能类单位
}

function PartnerCenterConfig.GetPartnerBallData()
    local result = {}

    for i = 1, #DataAssetPartnerCatch do
        table.insert(result, DataAssetPartnerCatch[i])
    end

    return result
end

function PartnerCenterConfig.GetPartnerBallDataById(id)
    return DataAssetPartnerCatch[id]
end

function PartnerCenterConfig.GetAssetConfigById(id)
    return DataAssetBasic[id]
end

-- 获取餐桌对应的不同食物
function PartnerCenterConfig.GetPartnerDiningTableData(assetId)
    if DataAssetDeviceFood[assetId] then
        return DataAssetDeviceFood[assetId].food_max
    end
    return nil
end

-- 月灵的专属技能
function PartnerCenterConfig.GetPartnerExclusiveSkillConfig(id)
    local config = DataAssetPartnerSkill[id]
    return config
end

function PartnerCenterConfig.GetPartnerExclusiveSkillUnlockConfig(id)
    local config = DataAssetPartnerSkillUnlock[id]
    return config
end

function PartnerCenterConfig.GetPartnerSkillConfig(id)
    local config = DataPartnerSkill[id]
    return config
end

function PartnerCenterConfig.GetPartnerSkillQualityIcon(qualtiy)
    return partnerSkillQualityIcon[qualtiy]
end

function PartnerCenterConfig.GetAssetPartnerLimit(assetId, lev)
    local key = string.format("%d_%d",assetId, lev)
    return DataAssetLevelUp[key].staff_num
end

function PartnerCenterConfig.GetAssetDeviceNumLimit(deviceId, lev)
    local key = string.format("%d_%d", deviceId, lev)
    if DataAssetDeviceLevelUp[key] then
        return DataAssetDeviceLevelUp[key].staff_num
    end
end

function PartnerCenterConfig.GetAssetDeviceProductCfg(asset_product_id)
   return DataAssetProduct[asset_product_id] 
end

function PartnerCenterConfig.GetAssetDevicePartnerProductCfg(asset_product_id)
    return DataAssetPartnerCollect[asset_product_id]
end

function PartnerCenterConfig.GetAssetDeviceCfg(deviceId)
    return DataAssetDevice[deviceId]    
end

--检查佩丛是否能在某个设备工作（职业是否符合）
function PartnerCenterConfig.CheckPartnerCanWorkInDevice(template_id, deviceUniqueId)
    --表明空闲，可以替换
    if deviceUniqueId == 0 then
        return true
    end
    
    local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(template_id)
    if not partnerWorkCfg then
        return false
    end
    
    local deviceInfo = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(deviceUniqueId)
    
    local deviceCfg = PartnerCenterConfig.GetAssetDeviceCfg(deviceInfo.template_id)
    if not deviceCfg then
        return false
    end
    
    local needCareer = deviceCfg.career
    for i, v in ipairs(partnerWorkCfg.career) do
        if v[1] ~= 0 and v[1] == needCareer then
            return true
        end
    end
    
    return false
end

function PartnerCenterConfig.GetDataStaffTeamProgrammeCfg(deviceId, partnerNum)
    local key = string.format("%d_%d", deviceId, partnerNum)
    return DataStaffTeamProgramme[key].coefficient / 10000
end

function PartnerCenterConfig.GetPartnerCenterConfig()
    return DataAssetPartnerCatch
end