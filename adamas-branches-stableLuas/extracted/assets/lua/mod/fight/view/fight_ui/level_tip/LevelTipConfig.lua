LevelTipConfig = LevelTipConfig or {}

LevelTipConfig.FadeTime = 1

LevelTipConfig.State =
{
    Fadein = 1,
    Show = 2,
    FadeOut = 3,
    Wait = 4
}


local DataBackTips = Config.DataBackTips.Find
function LevelTipConfig.GetNextData(id)
    id = id + 1
    local data = LevelTipConfig.GetTipData(id)
    if data then
        return data, id
    end
end

function LevelTipConfig.GetTipData(id)
    return DataBackTips[id]
end

function LevelTipConfig.GetInitId(groupId)
    return groupId * 100 + 1
end