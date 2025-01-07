FriendConfig = FriendConfig or {}

FriendConfig.ErrorCode = 
{
    [101011] = TI18N("好友系统未开启"),
    [101012] = TI18N("目标玩家不存在"),
    [101021] = TI18N("已经是好友了"),
    [101022] = TI18N("好友数量超上限"),
    [101023] = TI18N("对方好友数量超上限"),
    [101024] = TI18N("在对方黑名单中"),
    [101025] = TI18N("对方好友申请超上限"),
    [101031] = TI18N("指定的好友申请不存在"),
    [101041] = TI18N("要移除的好友不存在"),
    [102011] = TI18N("已经在黑名单中"),
    [102012] = TI18N("黑名单数量超上限"),
    [102013] = TI18N("要移除的黑名单不存在"),
    [103011] = TI18N("要备注的关系对象不存在"),
    [201011] = TI18N("对方不是好友，不能聊天"),
}

function FriendConfig.GetHeadIconPath(iconId)

end

function FriendConfig.GetHeadIconFramePath(iconId)

end

function FriendConfig.SetAvatarItem(avatarItem, headIconPath, framePath, lev, clickFunc)
    if headIconPath then
        SingleIconLoader.Load(avatarItem.HeadIcon, headIconPath)
    else
        -- DeafultIcon
    end
	if framePath then
        SingleIconLoader.Load(avatarItem.HeadIconFrame, headIconPath)
    else
        UtilsUI.SetActive(avatarItem.HeadIconFrame, false)
    end
    if lev then
        avatarItem.Lv_txt.text = lev
    else
        UtilsUI.SetActive(avatarItem.Lv, false)
    end
    if clickFunc then
        avatarItem.AvatarItem_btn.onClick:AddListener(clickFunc)
    end
end

local DataMemeGroup = Config.DataMemeGroup.Find
local DataMeme = Config.DataMeme.Find
function FriendConfig.GetMemeGroup()
    local config = DataMemeGroup
    table.sort(config,function(a, b)
        return a.meme_priority > b.meme_priority
    end)
    return config
end

function FriendConfig.GetMemeListByGroupId(groupId)
    local config = {}
    for k, info in pairs(DataMeme) do
        if info.group == groupId then
            table.insert(config, info)
        end
    end
    if not config or not next(config) then
       return {}
    end
    table.sort(config, function(a, b)
        return a.meme_priority > b.meme_priority
    end)
    return config
end

function FriendConfig.GetMemeInfoByMemeId(id)
    if not id then
        return
    end
    if type(id) == "string" then
        id = tonumber(id)
    end
    return DataMeme[id]
end

function FriendConfig.GetMemeGroudInfoByGroupId(id)
    if not id then
        return
    end

    return DataMemeGroup[id]
end

FriendConfig.OneHourTimeStamp = 3600000
function FriendConfig.GetTimeByStamp(timestamp)
    --传的是毫秒，要转换为秒
    timestamp = math.floor(timestamp / 1000)
    return os.date("- %Y-%m-%d %H:%M:%S -", timestamp)
end
