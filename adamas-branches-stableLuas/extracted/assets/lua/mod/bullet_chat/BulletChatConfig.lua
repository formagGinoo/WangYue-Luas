BulletChatConfig = BulletChatConfig or {}

local _tinsert = table.insert
local _tsort = table.sort

local DataBulletAhead = Config.DataBulletAhead.Find
local DataBulletAheadbyTimelineId = Config.DataBulletAhead.FindbyTimelineId
local DataBulletColor = Config.DataBulletColor.Find

local tPrefabricateBullet = {}
function BulletChatConfig.GetPrefabricateBullet(dialogId)
    TableUtils.ClearTable(tPrefabricateBullet)
    local findBy = DataBulletAheadbyTimelineId[dialogId]
    if findBy then
        for _, id in pairs(findBy) do
            local data = DataBulletAhead[id]
            
            if data.type == BulletChatEnum.Type.Text then
                --是文本
                _tinsert(tPrefabricateBullet, {type = BulletChatEnum.Type.Text, second = data.second, text = data.text, color = DataBulletColor[data.color_id].color})
            else
                _tinsert(tPrefabricateBullet, {type = BulletChatEnum.Type.Emote, second = data.second, memeId = data.meme_id})
            end
        end
    end

    _tsort(tPrefabricateBullet, BulletChatConfig.SortBulletInfoFunc)
    return tPrefabricateBullet
end

function BulletChatConfig.SortBulletInfoFunc(t1, t2)
    return t1.second > t2.second
end

function BulletChatConfig.GetColorConfig()
    return DataBulletColor
end


function BulletChatConfig.ColorStringConvertColorInt(colorString)
    local str = string.sub(colorString, 2)
    return tonumber(str, 16)
end

function BulletChatConfig.ColorIntConvertColorString(colorInt)
    return string.format("#%X", colorInt)
end