StoryConfig = StoryConfig or {}

StoryConfig.DefaultOptionIcon = SystemConfig.GetIconConfig("interaction_4").icon1

StoryConfig.DefaultUnlockIcon = SystemConfig.GetIconConfig("d_1000").icon1

StoryConfig.DialogConfig = Config.DataDialog.Find

StoryConfig.GroupData = Config.DataDialog.StoryGorupData

StoryConfig.DialogRewardData = Config.DataDialogReward.Find

StoryConfig.DialogReactionData = Config.DataDialogReaction.Find

StoryConfig.TimelineState = {Paused = 0}

StoryConfig.MaxSelectCount = 5

StoryConfig.SkipWaitTime = 10

StoryConfig.DefaultDelayTime = 5

StoryConfig.ContentType =
{
    --动画旁白
    Aside = 1,
    --角色对话
    Content = 2,
    --提示旁白
    TipAside = 3,
    --人物介绍
    Character = 4
}

StoryConfig.DialogType = {
    Common = 1, --普通对话
    Select = 2, --带选项的对话
    Specific = 3, --执行选项后的对话
    TipAside = 4, --旁白
    Animation = 5, --过场动画
    Character = 6,
}

StoryConfig.ChildType = 
{
    SpecialSelect = 21,
    TipPhone = 41, --支线手机对话
    AnimationPhone = 51, --过场动画手机显示
    Explore = 52,
    TipPhone2 = 53, --跳过接听步骤的手机动画
}

--别超过999
StoryConfig.StoryTrigger = {
    OpenNpcStore = 1,
    OpenTalent = 2,
	OpenMailing = 3,
    MercenaryHunt = 4,
    OpenAlchemy = 5,
    Task = 6,
    OpenTrade = 7,
    Bargain = 8,
    TaskDuplicate = 9,
    Rogue = 10,
    NightMareDuplicate = 11,
    CitySimulation = 12,
    Asset = 13,
    Trace = 101,
    Transport = 102,
}

StoryConfig.CameraType = 
{
    Animation = 1,
    Entity = 2,
}

StoryConfig.ExploreBarState =
{
    Default = 1,
    Yellow = 2,
    Blue = 3,
}

local DataNpcSystemJump = Config.DataNpcSystemJump.Find

function StoryConfig.GetNpcStoreId(npcId)
    local npcConfig = EcoSystemConfig.GetEcoConfig(npcId)
    local jumpIds = npcConfig.jump_system_id
    if type(jumpIds) == "table" then
        for key, id in pairs(jumpIds) do
            if DataNpcSystemJump[id].type == StoryConfig.StoryTrigger.OpenNpcStore then
                return DataNpcSystemJump[id].param[1], DataNpcSystemJump[id].condition, DataNpcSystemJump[id].camera_params
            end
        end
    end
end

function StoryConfig.GetNpcBargainJump(npcId)
    local npcConfig = EcoSystemConfig.GetEcoConfig(npcId)
    local jumpIds = npcConfig.jump_system_id
    if type(jumpIds) == "table" then
        for key, id in pairs(jumpIds) do
            if DataNpcSystemJump[id].type == StoryConfig.StoryTrigger.Bargain then
                return DataNpcSystemJump[id].param, DataNpcSystemJump[id].camera_params
            end
        end
    end
end

function StoryConfig.GetNpcTaskDuplicateJump(npcId)
    local npcConfig = EcoSystemConfig.GetEcoConfig(npcId)
    local jumpIds = npcConfig.jump_system_id
    if type(jumpIds) == "table" then
        for key, id in pairs(jumpIds) do
            if DataNpcSystemJump[id].type == StoryConfig.StoryTrigger.TaskDuplicate then
                return DataNpcSystemJump[id].param, DataNpcSystemJump[id].camera_params
            end
        end
    end
end

function StoryConfig.GetNPCCitySimulationJump(npcId)
    local npcConfig = EcoSystemConfig.GetEcoConfig(npcId)
    local jumpIds = npcConfig.jump_system_id
    if type(jumpIds) == "table" then
        for key, id in pairs(jumpIds) do
            if DataNpcSystemJump[id].type == StoryConfig.StoryTrigger.CitySimulation then
                return DataNpcSystemJump[id].param, DataNpcSystemJump[id].camera_params
            end
        end
    end
end

function StoryConfig.GetNpcNightMareDuplicateJump(npcId)
    local npcConfig = EcoSystemConfig.GetEcoConfig(npcId)
    local jumpIds = npcConfig.jump_system_id
    if type(jumpIds) == "table" then
        for key, id in pairs(jumpIds) do
            if DataNpcSystemJump[id].type == StoryConfig.StoryTrigger.NightMareDuplicate then
                return DataNpcSystemJump[id].param, DataNpcSystemJump[id].camera_params, DataNpcSystemJump[id].condition
            end
        end
    end
end

function StoryConfig.GetMailingId(npcId)
    local npcConfig = EcoSystemConfig.GetEcoConfig(npcId)
    if not npcConfig then
        LogError("找不到脉灵配置  ecoId = " .. npcId)
        return nil
    end
    local jumpIds = npcConfig.jump_system_id
	if type(jumpIds) == "table" then
		for key, id in pairs(jumpIds) do
			if DataNpcSystemJump[id].type == StoryConfig.StoryTrigger.OpenMailing then
				return DataNpcSystemJump[id].param[1]
			end
		end
	end
end

function StoryConfig.GetTriggerCondition(npcId, triggerId)
    local npcConfig = EcoSystemConfig.GetEcoConfig(npcId)
    local jumpIds = npcConfig.jump_system_id
    for key, id in pairs(jumpIds) do
        if DataNpcSystemJump[id].type == triggerId then
            return DataNpcSystemJump[id].condition
        end
    end
    
    return 0
end

function StoryConfig.GetTriggerIcon(triggerId)
    if not triggerId or triggerId > 1000 then
        local config = StoryConfig.GetStoryConfig(triggerId)
        if config and config.icon then
            return SystemConfig.GetIconConfig(config.icon).icon1
        end
        return StoryConfig.DefaultOptionIcon
    end
    local iconCfg = SystemConfig.GetIconConfig("story_trigger_"..triggerId)
    if iconCfg then
        return iconCfg.icon1
    else
        LogErrorf("通用交互图标“story_trigger_%s未配置,请找系统策划", triggerId)
        return StoryConfig.DefaultOptionIcon
    end
    return SystemConfig.GetIconConfig("story_trigger_"..triggerId).icon1
end

StoryConfig.EffectConfig = 
{
    
}

function StoryConfig.GetClickEffect(triggerId)
    if not triggerId or triggerId > 1000 then
        local config = StoryConfig.GetStoryConfig(triggerId)
        if config and config.icon then
            return StoryConfig.EffectConfig[config.icon]
        end
    end
end

function StoryConfig.GetSkipTime(dialogId)
    local time = StoryConfig.DialogConfig[dialogId].skip_target_time or 0
    if time ~= 0 then
        return time
    end
end

function StoryConfig.GetStoryType(dialogId)
    return StoryConfig.DialogConfig[dialogId] and StoryConfig.DialogConfig[dialogId].type
end

function StoryConfig.IsTipAside(dialogId)
    return  StoryConfig.GetStoryType(dialogId) == StoryConfig.DialogType.TipAside
end

function StoryConfig.AllowBreak(dialogId)
    local config = StoryConfig.GetStoryConfig(dialogId)
    if config.type == StoryConfig.DialogType.TipAside then
        if config.child_type ~= StoryConfig.ChildType.TipPhone then
            return true
        end
    end
    return false
end

function StoryConfig.GetStoryConfig(dialogId)
	if not dialogId then
        return
		--LogError("GetStoryConfig id = nil")
	end
    return StoryConfig.DialogConfig[dialogId]
end

function StoryConfig.GetStoryCondition(dialogId)
    return StoryConfig.DialogRewardData[dialogId] and StoryConfig.DialogRewardData[dialogId].conditions or 0
end

function StoryConfig.GetRelevanceId(dialogId)
    local config = StoryConfig.GetStoryConfig(dialogId)
    if not config then
        LogError(string.format("dialog id = %s 未找到配置", dialogId))
        return
    end
    local gorup = config.group_id
    if not StoryConfig.GroupData[gorup] then
        LogError(string.format("dialog id = %s 没有关联ID", dialogId))
        return
    end

    return StoryConfig.GroupData[gorup].relevance_id
end

function StoryConfig.GetAddRelevanceId(dialogId)
    local gorup = StoryConfig.GetStoryConfig(dialogId).group_id
    return StoryConfig.GroupData[gorup].addition_relevance_id
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
    local cfg = StoryConfig.GetStoryConfig(dialogId)
    return string.format("Prefabs/StoryTimeline/%s/Prefabs/%s.prefab", cfg.group_id, dialogId)
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
    if targetId then
        fileId = StoryConfig.GetStoryFileId(originalId, targetId)
    end
    return targetId, fileId, passList
end
local _dialogRecorder = {}
function StoryConfig.GetNextGorupStory(dialogId)
    local cfg = StoryConfig.GetStoryConfig(dialogId)
    local curId = dialogId
    TableUtils.ClearTable(_dialogRecorder)
    while not _dialogRecorder[curId] do
        _dialogRecorder[curId] = true
        local config = StoryConfig.GetStoryConfig(curId)
        if config.next_id and config.next_id > 1000 then
            if config.type ~= StoryConfig.DialogType.Select then
                local tempConfig = StoryConfig.GetStoryConfig(config.next_id)
                if tempConfig.group_id ~= cfg.group_id then
                   return config.next_id
                end
            end
        end
        curId = config.next_id or curId
    end
end

function StoryConfig.GetStoryEndId(dialogId)
    local config = StoryConfig.GetStoryConfig(dialogId)
    if not config.next_id then
        return
    elseif config.next_id < 1000 then
        return config.next_id
    else
        StoryConfig.GetStoryEndId(config.next_id)
    end
end

function StoryConfig.IsNewFile(storyId, targetId)
    local relevanceId = StoryConfig.GetRelevanceId(storyId)
    for key, value in pairs(relevanceId) do
        if value == targetId then
            return true
        end
    end
end

function StoryConfig.GetGroupAbstract(groupId)
    return Config.DataStoryAbstract.data_story_abstract[groupId]
end

--返回是否需要黑幕以及黑幕时长
function StoryConfig.GetCurtainIn(dialogId)
    local config = StoryConfig.GetStoryConfig(dialogId)

    return config.fade_in, config.fade_in == -1 and 0 or config.fade_in
end

function StoryConfig.GetCurtainOut(dialogId)
    local config = StoryConfig.GetStoryConfig(dialogId)

    return config.fade_out
end

function StoryConfig.CheckReward(selectId)
    return StoryConfig.DialogRewardData[selectId]
end

function StoryConfig.GetDialogRewardType(id)
    return StoryConfig.DialogRewardData[id].refresh_type
end

function StoryConfig.CheckReaction(selectId)
    return StoryConfig.DialogReactionData[selectId]
end

local DataStoryClue = Config.DataStoryClue.Find

StoryConfig.ClueType = 
{
    Lock = 0,
    Tip = 1,
    Unlock = 2,
}

function StoryConfig.GetClueConfig(id)
    return DataStoryClue[id]
end

function StoryConfig.GetExpolreConstantShow(id)
    local config = Config.DataExploreSetting.Find[id]
    return config and config.constant_show_close or false
end

function StoryConfig.GetClueLeading(id)
    if DataStoryClue[id].leading_clue and next(DataStoryClue[id].leading_clue) then
        return DataStoryClue[id].leading_clue
    end
end

StoryConfig.ObjType = 
{
    Clue = "StoryClueObj"
}

StoryConfig.ClueState = 
{
    NotFind = 1, --未出现
    Locked = 2, --未解锁
    Unlock = 3, --已解锁
}

StoryConfig.StoryState = 
{
    None = 1,
    Loading = 2,
    LoadDone = 3,
    Playing = 4,
}

StoryConfig.ViewState = 
{
    None = 1,
    Playing = 2,
}