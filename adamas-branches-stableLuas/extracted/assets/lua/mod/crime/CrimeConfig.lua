CrimeConfig = CrimeConfig or {}

local DataCrimeDefine = Config.DataCrimeDefine.Find
local DataPoliceLevel = Config.DataPoliceLevel.Find
local DataBountyLevel = Config.DataBountyLevel.Find
local DataPrisonGame = Config.DataPrisonGame.Find
local DataPrison = Config.DataPrison.Find
local PoliceLevelLimit = {}
local prisonGamesMap = {}

function CrimeConfig.GetBountyValueByType(type)
    return DataCrimeDefine[type].bounty_value
end

function CrimeConfig.GetBountyConfigByType(type)
    return DataCrimeDefine[type]
end

function CrimeConfig.GetPrisonConfig(id)
    return DataPrison[id]
end

function CrimeConfig.GetBountyStar(bountyVal)
    if bountyVal <= 0 then return 0 end
    for i, v in ipairs(DataBountyLevel) do
        if v.bounty_value > bountyVal then
            return i - 1
        end
    end
    return #DataBountyLevel
end

function CrimeConfig.GetProtectLvModify(bountyVal)
    if not next(PoliceLevelLimit) then CrimeConfig.InitPoliceLevelLimit() end
    for _, v in ipairs(PoliceLevelLimit) do
        if bountyVal <= v then
            return DataPoliceLevel[v].level_bias
        end
    end
    return DataPoliceLevel[#DataPoliceLevel].level_bias
end

function CrimeConfig.GetProtectConfig(bountyVal)
    if not next(PoliceLevelLimit) then CrimeConfig.InitPoliceLevelLimit() end
    for _, v in ipairs(PoliceLevelLimit) do
        if bountyVal <= v then
            return DataPoliceLevel[v]
        end
    end
    return DataPoliceLevel[#DataPoliceLevel]
end

function CrimeConfig.GetPrisonGameReduce(type)
    if not next(DataPrisonGame) then CrimeConfig.InitPrisonGamesMap() end   
    return DataPrisonGame[type].bounty_reduce
end

function CrimeConfig.GetLevelId(crime_type,prisonId)
    if not next(prisonGamesMap) then CrimeConfig.InitPrisonGamesMap() end   
    local levelList = {}
    if not prisonGamesMap[crime_type] then
        return levelList
    end
    for i, v in ipairs(prisonGamesMap[crime_type]) do
        for i, v in ipairs(DataPrisonGame[v].prison_level) do
            if v[1] == prisonId then 
                table.insert(levelList,v[2])
            end
        end
    end
    return levelList
end

function CrimeConfig.InitPoliceLevelLimit()
    for k, v in pairs(DataPoliceLevel) do
        table.insert(PoliceLevelLimit,k)
    end
    table.sort(PoliceLevelLimit)
end

function CrimeConfig.InitPrisonGamesMap()
    for _, v in ipairs(DataPrisonGame) do
        for i, val in ipairs(v.crime_type) do
            if val ~= 0 then
                if not prisonGamesMap[val] then prisonGamesMap[val] = {} end
                table.insert(prisonGamesMap[val],v.game_type)
            end
        end
    end
end