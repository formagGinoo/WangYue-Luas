-- 全局事件
-- 模块内部事件可以使用EventLib类处理
EventName = EventName or {}

EventName.gamestart_before_init = "gamestart_before_init"
EventName.gamestart_end_init = "gamestart_end_init"
EventName.end_mgr_init = "end_mgr_init"

-- Socket事件
EventName.socket_connect = "socket_connect"

-- 场景事件
EventName.start_scene_load = "start_scene_load"
EventName.scene_load = "scene_load"
EventName.self_loaded = "self_loaded"

EventName.UIOpen = 1
EventName.UIHide = 2
EventName.UIDestroy = 3

--#region 指引pointer相关
EventName.UpdateEntityGuidePos = 1001
EventName.AddGuidePointer = 1002
EventName.RemoveGuidePointer = 1003
EventName.SetGuideState = 1004
EventName.SetTaskGuideDisState = 1005
EventName.UIGuideTaskChange = 1006
EventName.UpdateElementState = 1007
EventName.OnCastSkill = 1008
EventName.SetForceGuideState = 1009
--#endregion

--#region 道具相关
EventName.ItemUpdate = 1100
EventName.ItemUse = 1101
EventName.ItemRecv = 1102
--#endregion

--#region 角色属性数据相关
EventName.AdventureChange = 1200
EventName.EntityAttrChange = 1201
EventName.DodgeValueChange = 1202
EventName.BuffValueChange = 1203
EventName.UIBuffValueChange = 1204
--#endregion

--#region 主界面相关
EventName.SetCoreVisible = 1300
EventName.ActiveWorldInteract = 1301
EventName.RemoveWorldInteract = 1302
EventName.WorldInteractKeyClick = 1303
EventName.GetLastInstanceId = 1304
EventName.ActiveInteract = 1305
EventName.SetLockTarget = 1306
EventName.ActiveView = 1307
EventName.ShowGuideTips = 1308
EventName.CancelJoystick = 1309
--EventName.OpenRemoteDialog = 1310
EventName.OpenTalkDialog = 1311
EventName.SetNodeVisible = 1312
EventName.TargetUpdate = 1313
EventName.KeyAutoUp = 1314
EventName.MainPanelPlayEffect = 1315
EventName.MainPanelStopEffect = 1316
EventName.MainPanelShowTip = 1317
EventName.MainPanelHideTip = 1318
EventName.ShowCoopDisplay = 1319
EventName.ShowFightDisplay = 1320
EventName.ChangeTopTargetDesc = 1321
EventName.TopTargetFinish = 1322
EventName.ShowTopTarget = 1323
EventName.UpdateSkillInfo = 1324
--EventName.ShowWeakGuide = 1325
EventName.ShowCommonTitle = 1326
EventName.PlayReviveMusic = 1327
EventName.SetCoreEffectVisible = 1328
EventName.SetAimImage = 1330
EventName.PlaySkillUIEffect = 1331
EventName.StopSkillUIEffect = 1332
EventName.CastSkill = 1332
EventName.ChangeButtonConfig = 1333
EventName.PlayClickEffect = 1334
EventName.MainPanelSetTipsGuide = 1335
EventName.GuideDelayAnim = 1336
EventName.PauseByOpenWindow = 1337
EventName.ResumeByCloseWindow = 1338
EventName.OnWindowOpen = 1339
EventName.OnPanelOpen = 1340
EventName.ChangeTitleTips = 1341
EventName.ChangeSubTips = 1342
EventName.SetLockPointVisible = 1343
EventName.SkillPointChangeAfter = 1344
EventName.CastSkillUIEffect = 1345
EventName.HideFightMainWindowPanel = 1346
EventName.UpdateSystemMenuRed = 1347
EventName.OnCloseGetItemPanel = 1348
EventName.SetLockTargetUI = 1349
EventName.ActionInput = 1350
EventName.CastSkillCost = 1351

EventName.AddCenterContent = 1352
--#endregion

--#region 场景控制相关
EventName.ShowScenneObj = 1400
--#endregion

--#region 青乌传书（场景留言）相关
EventName.SceneMsgUpdateData = 1500
--#endregion

--#region 角色编队 player操作
EventName.SetCurEntity = 100

EventName.FormationUpdate = 1600
EventName.PlayerInfoUpdate = 1601
EventName.RoleInfoUpdate = 1602
EventName.PlayerUpdate = 1603
EventName.CurRoleChange = 1604
EventName.ModifyPlayerInfo = 1605
EventName.ChangeShowRole = 1606
EventName.PlayerUpgrade = 1607
EventName.PlayerStageUp = 1608
EventName.ShowRoleModelLoad = 1609
EventName.GetRole = 1610
--UI事件
EventName.FormationListHide = 1611
EventName.FormationRoleSubmit = 1612
EventName.FormationSubmit = 1613

--#endregion

--#region 地图 区域 场景
EventName.MarkUpdate = 1700
EventName.EnterMapArea = 1701
EventName.ExitMapArea = 1702
EventName.EnterTriggerLayer = 1703
EventName.ExitTriggerLayer = 1704
EventName.CancelMapMarkTrace = 1705
EventName.MercenaryMarkAdded = 1706
EventName.MapAreaUpdate = 1707
EventName.BlockAreaUpdate = 1708
EventName.EnterMap = 1709
EventName.TransportPointActive = 1710
EventName.LeaveDuplicate = 1711
--#endregion

--#region 任务相关
EventName.AddTask = 1800
EventName.TaskFinish = 1801
EventName.OccupyTaskChange = 1802
EventName.UpdateDailyActivity = 1803
EventName.RefreshNpcAcceptTask = 1804
EventName.RemoveTaskProgressGuide = 1805
EventName.TaskPreFinish = 1806
EventName.GuideTaskChange = 1807
--#endregion

--#region 角色系统
EventName.RoleWeaponChange = 1900
EventName.WeaponInfoChange = 1901
EventName.WeaponUpgradeComplete = 1902
EventName.SkillInfoChange = 1903
EventName.PartnerInfoChange = 1903
EventName.ClickTalentItem = 1904
--#endregion

EventName.GetGMData = 101
EventName.LoginFail = 102
EventName.ConditionCheck = 103
EventName.ExitFight = 104       -- Temp 之后给返回登录界面
EventName.EcosystemInitDone = 105
EventName.NpcInitDone = 106
EventName.EntityHitEnd = 107
EventName.EntityHit = 108 --交互用
EventName.OnPlayAnimation = 110
EventName.OnEntityHit = 111 --实体受击用
EventName.OnEntityBuffChange = 112
EventName.OnDoDamage = 113
EventName.EnterElementStateReady = 114
EventName.OnDealDodge = 115
EventName.EnterLogicArea = 116
EventName.ExitLogicArea = 117
EventName.OnEntityTimeoutDeath = 118 --实体生命周期实体
EventName.OnEntityDeath = 119 --实体死亡
EventName.StartFight = 120

EventName.EnterDeath = 200
EventName.ExitDeath = 201
EventName.Revive = 202
EventName.FightPause = 203
EventName.RemoveEntity = 204
EventName.ChangeCollistionParam = 205
EventName.RemoveHackingBuild = 206
EventName.ShowCursor = 207 --显示鼠标指针

EventName.UnityUpdate = 301

--#region 系统相关
EventName.SystemOpen = 2001
EventName.CloseNoticePnl = 2002
--#endregion

--#region 剧情相关
EventName.StoryDialogEnd = 2101
EventName.StoryTriggerEvent = 2102
EventName.StoryDialogStart = 2103
--#endregion

--#region 商店相关
EventName.ShopBuyGoodComplete = 2201
EventName.ShopOpen = 2202
EventName.ShopBuyGoods = 2203
EventName.ShopListUpdate = 2204
--#endregion

--#region 教学相关
EventName.AddTeach = 2301
EventName.RetTeachLookReward = 2302
EventName.TriggerTeachTip = 2303
--#endregion

--#region 天赋相关
EventName.UpdateTalentData = 2401
--#endregion

--#region 脉灵道具交付
EventName.MailingExchangeResult = 2501
--#endregion

--#region 佣兵狩猎相关
EventName.UpdateMercenaryRankVal = 2601
EventName.AlertValueUpdate = 2602
EventName.UpdateMercenaryGuid = 2603
EventName.GetRankReward = 2604
EventName.UpdateMainId = 2605
EventName.CloseHuntTip = 2606
--#endregion

--#region 世界等级
EventName.WorldLevelChange = 2701
--#endregion

--#region 系统任务

EventName.SystemTaskAccept = 2801
EventName.SystemTaskChange = 2802
EventName.SystemTaskFinish = 2803
EventName.SystemTaskFinished = 2804
EventName.SystemTaskUpdate = 2805
EventName.SystemTaskUpdateComplete = 2806

--#endregion

--#region 红点系统
EventName.RedPointStateChange = 2901
EventName.RefreshRedPoint = 2902

--#endregion

--#region 炼金系统
EventName.GetAlchemyAward = 3001
EventName.AlchemySetItemNum = 3002
EventName.AlchemyRefreshHistory = 3003
--#endregion

--#region 骇入系统
EventName.ExitHackingMode = 3101
--#endregion

--#region 文本本地化
EventName.ChangeLanguage = 3201
--#endregion
