StoryConfig = StoryConfig or {}

StoryConfig.DefalutOptionIcon = SystemConfig.GetIconConfig("interaction_4").icon1

StoryConfig.DialogConfig = Config.DataStoryDialog.data_dialog

StoryConfig.TimelineState = {Paused = 0}

StoryConfig.MaxSelectCount = 5

StoryConfig.SkipWaitTime = 3

StoryConfig.DialogType = {
    Common = 1, --普通对话
    Select = 2, --带选项的对话
    Specific = 3, --执行选项后的对话
    TipAside = 4, --旁白
    Animation = 5 --过场动画
}

StoryConfig.StoryTrigger = {
    OpenNpcStore = 1,
    OpenTalent = 2,
	OpenMailing = 3,
    MercenaryHunt = 4,
    OpenAlchemy = 5,
    Task = 6,
    Trace = 101,
    Transport = 102,
}

local NpcData = Config.DataNpc.Find
local DataNpcSystemJump = Config.DataNpcSystemJump.Find

function StoryConfig.GetNpcStoreId(npcId)
    local jumpIds = NpcData[npcId].jump_system_id
    if type(jumpIds) == "table" then
        for key, id in pairs(jumpIds) do
            if DataNpcSystemJump[id].type == StoryConfig.StoryTrigger.OpenNpcStore then
                return DataNpcSystemJump[id].param[1], DataNpcSystemJump[id].condition, DataNpcSystemJump[id].camera_params
            end
        end
    end
end

function StoryConfig.GetMailingId(npcId)
	local jumpIds = NpcData[npcId].jump_system_id
	if type(jumpIds) == "table" then
		for key, id in pairs(jumpIds) do
			if DataNpcSystemJump[id].type == StoryConfig.StoryTrigger.OpenMailing then
				return DataNpcSystemJump[id].param[1]
			end
		end
	end
end

function StoryConfig.GetTriggerCondition(npcId, triggerId)
    local jumpIds = NpcData[npcId].jump_system_id
    for key, id in pairs(jumpIds) do
        if DataNpcSystemJump[id].type == triggerId then
            return DataNpcSystemJump[id].condition
        end
    end
    
    return 0
end

function StoryConfig.GetTriggerIcon(triggerId)
    if triggerId == 0 then
        return StoryConfig.DefalutOptionIcon
    end
    return SystemConfig.GetIconConfig("story_trigger_"..triggerId).icon1
end

function StoryConfig.GetSkipTime(dialogId)
    local time = StoryConfig.DialogConfig[dialogId].skip_target_time or 0
    if time ~= 0 then
        return time
    end
end

function StoryConfig.GetStoryType(dialogId)
    return StoryConfig.DialogConfig[dialogId].type or 0
end

function StoryConfig.GetStoryConfig(dialogId)
    return StoryConfig.DialogConfig[dialogId]
end

function StoryConfig.GetRelevanceId(dialogId)
    return StoryConfig.GetStoryConfig(dialogId).relevance_id
end

function StoryConfig.GetAddRelevanceId(dialogId)
    return StoryConfig.GetStoryConfig(dialogId).addition_relevance_id
end

function StoryConfig.GetStoryOptions(dialogId)
    return StoryConfig.GetStoryConfig(dialogId).options
end

function StoryConfig.GetStoryFileId(originalId, targetId)
    local relevanceId = StoryConfig.GetRelevanceId(originalId)
    for i = #relevanceId, 1, -1 do
        if targetId >= relevanceId[i] then
            return relevanceId[i]
        end
    end
    return originalId
end

function StoryConfig.GetStoryFilePath(dialogId)
    return "Prefabs/StoryTimeline/Prefabs/"..dialogId..".prefab"
end

function StoryConfig.GetNextSelectId(dialogId, originalId)
    local targetId = dialogId
    local cfg = StoryConfig.GetStoryConfig(targetId)
    local passList = {}
    while cfg and cfg.type ~= StoryConfig.DialogType.Select do
        if dialogId ~= targetId then
            table.insert(passList, targetId)
        end
        targetId = cfg.next_id
        cfg = StoryConfig.GetStoryConfig(targetId)
    end
    local fileId
    if targetId ~= 0 then
        fileId = StoryConfig.GetStoryFileId(originalId, targetId)
    end
    return targetId, fileId, passList
end

function StoryConfig.GetGroupAbstract(groupId)
    return Config.DataStoryAbstract.data_story_abstract[groupId]
end