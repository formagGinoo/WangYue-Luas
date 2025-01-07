AssetTaskConfig = AssetTaskConfig or {}

local DataAssetPartnerList = Config.DataAssetPartnerList.Find
local DataSystemTask = Config.DataSystemTask.Find
local DataSystemTaskGroup = Config.DataSystemTask.FindbyGroup

function AssetTaskConfig.GetAssetTaskConfig(assetId,level)
    return DataAssetPartnerList
end

function AssetTaskConfig.GetAssetTaskConfigByLevel(assetId,level)
    for i, v in ipairs(DataAssetPartnerList) do
        if v.level_id == level then
            return v
        end
    end
end

function AssetTaskConfig.GetAssetTaskListByGroup(groupId)
    return DataSystemTaskGroup[groupId]
end

function AssetTaskConfig.GetAssetTaskInfoById(taskId)
    return DataSystemTask[taskId]
end