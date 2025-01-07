RoguelikeConfig = RoguelikeConfig or {}

local MainConfigData = Config.DataRogueMain.Find
local SeasonConfig = Config.DataRogueSeasonVersion.Find
local AreaConfig = Config.DataRogueAreaBasic.Find
local AreaLogic = Config.DataRogueAreaLogic.Find --逻辑区域
local EventConfig = Config.DataRogueEvent.Find
local EventTypeConfig = Config.DataRogueEventType.Find --事件类型
local CardConfig = Config.DataRogueCard.Find
local CardLevelConfig = Config.DataRogueCardLevel.Find
local ScheduleCardReward = Config.DataRogueScheduleCardReward.Find --区域卡牌进度奖励
local SeasonScheduleRewardByGroup = Config.DataRogueScheduleSeasonReward.FindbyScheduleSeasonRewardId --赛季进度奖励组
local SeasonScheduleReward = Config.DataRogueScheduleSeasonReward.Find --赛季进度奖励规则
local RogueGameReplay = Config.DataRogueGameReplay.Find --赛季重启条件
local RogueCardVersion = Config.DataRogueCardVersion.Find --赛季卡牌最大数量

local RogueCardReserve = Config.DataRogueCardReserve.Find
-- 这里整理一份新表出来使用
local ClientUseCardReserve = {}

RoguelikeConfig.QualityColor = {
    [1] = "<#75C0FF>",
    [2] = "<#CE90F6>",
    [3] = "<#FCAB4C>"
}

function RoguelikeConfig.InitRogueCardReserveConfig()
    for _, data in pairs(RogueCardReserve) do
        local id = data.card_reserve_rule
        ClientUseCardReserve[id] = ClientUseCardReserve[id] or {}
        ClientUseCardReserve[id][data.game_num[1]] = data.card_lose_num
    end
end

RoguelikeConfig.InitRogueCardReserveConfig()
function RoguelikeConfig.GetCardLoseNumByRestartNum(id, restartNum)
    local cfg = ClientUseCardReserve[id]
    local loseNum = 0
    for num, val in pairs(cfg) do
        if restartNum >= num then
            loseNum = val
        end
    end
    return loseNum
end

function RoguelikeConfig.GetRoguelikeMainConfig(mainId)
    return MainConfigData[mainId]
end

function RoguelikeConfig.GetSeasonData(seasonId)
    return SeasonConfig[seasonId]
end

function RoguelikeConfig.GetWorldAreasInfo(areaId)
    return AreaConfig[areaId]
end

function RoguelikeConfig.GetRougelikeEventConfig(eventId)
    return EventConfig[eventId]
end

--EventTypeConfig
function RoguelikeConfig.GetRougelikeEventTypeConfig(eventType)
    return EventTypeConfig[eventType]
end

--获取卡牌配置
function RoguelikeConfig.GetWorldRougeCardConfigById(cardId)
    return CardConfig[cardId]
end

--根据卡牌的数量和id获取配置
function RoguelikeConfig.GetWorldRougeCardLevelConfigById(id, lv)
    local key = UtilsBase.GetDoubleKeys(id, lv, 32)
    return CardLevelConfig[key]
end

--获取逻辑区域配置
function RoguelikeConfig.GetWorldRougeAreaLogic(logicId)
    return AreaLogic[logicId]
end

--获取区域进度奖励规则
function RoguelikeConfig:GetRogueScheduleCardReward(scheduleRewardId)
    return ScheduleCardReward[scheduleRewardId]
end

--获取整个赛季进度奖励组
function RoguelikeConfig.GetRogueSeasonScheduleRewardGroup(scheduleRewardId)
    return SeasonScheduleRewardByGroup[scheduleRewardId]
end

--获取赛季对应的奖励
function RoguelikeConfig.GetRogueSeasonScheduleReward(groupID)
    return SeasonScheduleReward[groupID]
end

--赛季重启条件
function RoguelikeConfig.GetRogueGameReplay(gameNum)
    return RogueGameReplay[gameNum]
end

--赛季重启条件整表
function RoguelikeConfig.GetRogueGameReplayConfig()
    return RogueGameReplay
end

--赛季卡牌最大数量
function RoguelikeConfig.GetRogueCardVersion(versionId, cardId)
    local key = UtilsBase.GetDoubleKeys(versionId, cardId)
    return RogueCardVersion[key]
end
