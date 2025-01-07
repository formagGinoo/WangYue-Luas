InformationConfig = InformationConfig or {}

InformationConfig.AdventureConfig = Config.DataAdventure.data_adventure_lev

InformationConfig.GetSpriteRichText = function (num)
    -- local numstr = tostring(num)
    -- local res = ""
    -- for i = 1, #numstr do
    --     res = res.."<sprite="..string.sub(numstr,i,i)..">"
    -- end
    return num
end
