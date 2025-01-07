InformationConfig = InformationConfig or {}

local FrameData = Config.DataFrame

InformationConfig.AdventureConfig = Config.DataAdventure.data_adventure_lev

InformationConfig.SelectMode = 4

InformationConfig.HeadIconType =
{
    Avatar = 1,
    Frame = 2
}
InformationConfig.PanelType =
{
    PhonePanel = 1,
    MessagePanel = 2,
    GrowNotice = 3,
}

InformationConfig.MessageData = {}

InformationConfig.GetSpriteRichText = function (num)
    -- local numstr = tostring(num)
    -- local res = ""
    -- for i = 1, #numstr do
    --     res = res.."<sprite="..string.sub(numstr,i,i)..">"
    -- end
    return num
end

function InformationConfig.GetDefalultName()
    return SystemConfig.GetCommonValue("PlayerInitialName").string_val
end

function InformationConfig.GetFrameConfig(id)
    return FrameData.Find[id]
end

function InformationConfig.GetFrameIcon(id)
    return FrameData.Find[id].icon
end



