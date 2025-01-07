DecorationConfig = DecorationConfig or {}

DecorationConfig.decorationConfig =Config.DataDecorationItem.Find

DecorationConfig.decorationType =
{
    editor = 1,
    create = 2,
    render = 3
}
--状态1，放置 2，获取 3，材质替换

DecorationConfig.QuitPanelType = 
{
    open = 1,
    close =2
}

DecorationConfig.decorationTipTypes = {
    buy = 1,
    save = 2,
}
--装修吸附规则
DecorationConfig.adsorptionrule = {
    floor = 1, --地板
    wall = 2,  --墙面
    ceiling  = 3,  --天花板
}

DecorationConfig.deviceType =
{
    wallPaper =  "wallPaper",
}
