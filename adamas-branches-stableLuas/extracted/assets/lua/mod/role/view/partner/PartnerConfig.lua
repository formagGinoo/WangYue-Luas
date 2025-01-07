PartnerConfig = PartnerConfig or {}

local PartnerBuffConfig = Config.DataPartnerBuff.Find
local PartnerBallConfig = Config.DataPartnerBall.Find
local DataPartnerMain = Config.DataPartnerMain.Find
local DataPartnerQuality = Config.DataPartnerQuality.Find

function PartnerConfig.GetPartnerBuffCfg(lv)
    return PartnerBuffConfig[lv]
end

function PartnerConfig.GetPartnerBallCfg(ballId)
    return PartnerBallConfig[ballId]
end

function PartnerConfig.GetAllPartnerBallItem()
    local itemMap = {}
    for k, v in pairs(PartnerBallConfig) do
        table.insert(itemMap, v)
    end
    table.sort(itemMap, function(a, b)
        if a.quality == b.quality then
            return a.id < b.id
        end
        return a.quality < b.quality
    end)

    return itemMap
end

function PartnerConfig.GetPartnerConfig(id)
    return DataPartnerMain[id]
end

function PartnerConfig.GetPartnerQualityConfig(quality)
    return DataPartnerQuality[quality]
end

