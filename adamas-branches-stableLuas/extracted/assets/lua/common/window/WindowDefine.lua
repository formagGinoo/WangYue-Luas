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
    ["ShopMainWindow"] = true,
    ["TradeMainWindow"] = true,
    ["ControlAtomizeWindow"] = true,
    ["AnnouncementWindow"] = true,
}

WindowDefine.PCPanel = {
    ["Prefabs/UI/Fight/FightNewSkillPanel.prefab"] = "Prefabs/UI/Fight_PC/FightNewSkillPanel_PC.prefab",
    ["Prefabs/UI/Fight/FightFormationPanelV2.prefab"] = "Prefabs/UI/Fight_PC/FightFormationPanelV2_PC.prefab",
    ["Prefabs/UI/Fight/FightInfoPanel.prefab"] = "Prefabs/UI/Fight_PC/FightInfoPanel_PC.prefab",
    ["Prefabs/UI/Fight/FightSystemPanel.prefab"] = "Prefabs/UI/Fight_PC/FightSystemPanel_PC.prefab",
    ["Prefabs/UI/Fight/FightJoyStickPanel.prefab"] = "Prefabs/UI/Fight_PC/FightJoyStickPanel_PC.prefab",
    ["Prefabs/UI/QTE/AssassinQTE.prefab"] = "Prefabs/UI/Fight_PC/AssassinQTE_PC.prefab",
    ["Prefabs/UI/QTE/ClickQTE.prefab"] = "Prefabs/UI/Fight_PC/ClickQTE_PC.prefab",
    ["Prefabs/UI/Fight/FightGuidePanel.prefab"] = "Prefabs/UI/Fight_PC/FightGuidePanel_PC.prefab",
    ["Prefabs/UI/Fight/UIDPanel.prefab"] = "Prefabs/UI/Fight_PC/UIDPanel_PC.prefab",
    ["Prefabs/UI/Fight/DrivePanel.prefab"] = "Prefabs/UI/Fight_PC/DrivePanel_PC.prefab",
    ["Prefabs/UI/Story/StoryDialogWindow.prefab"] = "Prefabs/UI/Story/StoryDialogWindow_PC.prefab",
    ["Prefabs/UI/Hacking/HackMainWindow.prefab"] = "Prefabs/UI/Hacking/Hacking_PC/HackMainWindow_PC.prefab",
    ["Prefabs/UI/Hacking/ControlDronePanel.prefab"] = "Prefabs/UI/Hacking/Hacking_PC/ControlDronePanel_PC.prefab",
    ["Prefabs/UI/Photo/PhotoMainPanel.prefab"] = "Prefabs/UI/Photo/Photo_PC/PhotoMainPanel_PC.prefab",

}

WindowDefine.PCLogic = 
{
    ["FightNewSkillPanel"] = FightNewSkillPanel_PC,
}

--此处不可滥用 仅可放会切镜头界面及其相关的window
WindowDefine.IgnorPauseCameraWindow = {
    ["FightMainUIView"] = true,
    ["MailingExchangeWindow"] = true,
    ["HackMainWindow"] = true,
    ["CatchPartnerWindow"] = true,
    ["ShopMainWindow"] = true,
    ["TradeMainWindow"] = true,
    ["ControlAtomizeWindow"] = true,
    ["RoleMainWindow"] = true,
    ["FormationWindowV2"] = true,
    ["PhoneMenuWindow"] = true,
    ["AdvMainWindowV2"] = true,
    ["CreateRoleWindow"] = true,
    ["TaskDuplicateWindow"] = true,
    ["ResDuplicateWindow"] = true,
    ["TaskReviewMainWindow"] = true,
    ["TaskReviewWindow"] = true,
    ["SelectBluePrintWindow"] = true,
    ["AnnouncementWindow"] = true,
    ["WorldFailWindow"] = true,
    ["BargainMainWindowV2"] = true,
}
