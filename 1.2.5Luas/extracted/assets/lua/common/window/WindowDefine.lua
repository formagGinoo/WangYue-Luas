-- ------------------------------
-- 窗口ID配置
-- ------------------------------
WindowDefine = WindowDefine or {}

-------------------------------------------------------------------------------
-- id命名规则: 前三位按照相应功能的协议前三位，后两位是具体的序号，方便分类
--------------------------------------------------------------------------------
WindowDefine.WinID = {
    --ui_gm = 99001, --GM
}

WindowDefine.WinIDToName = 
{
    --[WindowDefine.WinID.ui_gm] = "WindowName",
}

WindowDefine.OpenFunc = {
    --[WindowDefine.WinID.ui_gm] = function(args) HalloweenManager.Instance:OpenExchange(args) end,
}

WindowDefine.IgnorePauseWindow = {
    ["FightMainUIView"] = true,
    ["MailingExchangeWindow"] = true,
    ["HackMainWindow"] = true,
    ["CatchPartnerWindow"] = true,
}