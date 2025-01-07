PhotoConfig = PhotoConfig or {}

local BuildByInstance = Config.DataBuild.FindbyInstanceId
local Build = Config.DataBuild.Find
local PhotoAnimData = Config.DataPhoto.data_photo_ani

PhotoConfig.CastRayDistance = 20

PhotoConfig.CanBuildEffect = 200001002
PhotoConfig.SelectEffect = 200001004

PhotoConfig.DrawPhotoUnlockCondition = Config.DataCommonCfg.Find["BuildPrintLimitCondition"].int_val

function PhotoConfig.CheckEntityIsCanBuild(id)
    return BuildByInstance[id]
end

function PhotoConfig.GetBuildInfoByEntityId(entityId)
    return Build[BuildByInstance[entityId][1]]
end

function PhotoConfig.GetBuildInfoByBuildId(buildId)
    return Build[buildId]
end

function PhotoConfig.GetAnimData()
    return PhotoAnimData
end