-- 全局事件
-- 模块内部事件可以使用EventLib类处理
EventName = EventName or {}
EventName = TableUtils.Enum(EventName,"EventName")--模拟自增效果

EventName.gamestart_before_init = 1
EventName.gamestart_end_init = 1
EventName.end_mgr_init = 1

-- Socket事件
EventName.socket_connect = 1

-- 场景事件
EventName.start_scene_load = 1
EventName.scene_load = 1

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
EventName.StrengthUpdate = 1103
EventName.ExchangeDataUpdate = 1104
EventName.ItemChange = 1105
EventName.BagItemChange = 1106
EventName.ItemDelete = 1107
--#endregion

--#region 角色属性数据相关
EventName.AdventureChange = 1200
EventName.EntityAttrChange = 1201
EventName.DodgeValueChange = 1202
EventName.BuffValueChange = 1203
EventName.UIBuffValueChange = 1204
EventName.ShowCoreUIEffect = 1205
EventName.PlayerPropertyChange = 1206
--#endregion

--#region 主界面相关
EventName.SetCoreVisible = 1300
EventName.ActiveWorldInteract = 1301
EventName.RemoveWorldInteract = 1302
EventName.ShowWorldInteract = 1301
EventName.HideWorldInteract = 1302
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
EventName.CastSkill = 1
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
EventName.AddSystemContent = 1352
EventName.ReWorldInteractClick = 1353
EventName.UseSkillDecPoint = 1354
EventName.WorldInteractClick = 1355
EventName.OnChangeActionmap = 1356
EventName.TipHideEvent = 1357
EventName.AddFightContent = 1358
EventName.OnJumpIconChange = 1359
EventName.PauseTipQueue = 1360
EventName.ResumeTipQueue = 1361
EventName.ActiveGoodsInteract = 1362
EventName.RemoveGoodsInteract = 1363
EventName.GetEcoGoodsInfo = 1364
EventName.OnEnterStory = 1365
EventName.PlayerAttrChange = 1562
EventName.CloseAllUI = 1563
EventName.GetPurchaseExchangeGoods = 1534
EventName.ActionInputEnd = 1366
EventName.UpdateAssassinTip = 1564
EventName.HideAssassinTip = 1565
EventName.OpenDuplicateCountDown = 1566
EventName.StopDuplicateCountDown = 1567
EventName.SyncDuplicateCountDown = 1568
EventName.EnterDuplicate = 1569
--EventName.ResumeByWindow = 1570
EventName.ShowFightMainUIDisplay = 1571
EventName.OnAbilityWheelChange = 1572
EventName.OnStrengthBarStateUpdate = 1573
EventName.EntityAttrChangeImmediately = 1574
EventName.ChangeConcludeItem = 1575
EventName.LevelInstructionComplete = 1576
EventName.GrowNoticeSummaryUpdate = 1577
EventName.LevelMarkActive = 1578
EventName.GrowNoticeResumeShow = 1579

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
EventName.PlayerHenshinPartner = 1614
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
EventName.WorldMapCtrlEntityLoadDone = 1712
EventName.EnterDuplicate = 1713
EventName.QuitDuplicate = 1714
EventName.EnterInRoomArea = 1715
EventName.ExitInRoomArea = 1716
EventName.MapMarkDefaultShow = 1717
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
EventName.RecivedTaskReward = 1808
EventName.TaskRewardRed = 1809
EventName.FinishLevel = 1810
EventName.TaskOccupy = 1811
EventName.MulTaskChange = 1812
EventName.TaskTypeChange = 1813
EventName.TaskBehaviorStateChange = 1814
EventName.ExitTask = 1815
EventName.RemoveLevel = 1816
EventName.NpcBindTask = 1817
--#endregion

--#region 角色系统
EventName.RoleWeaponChange = 1900
EventName.WeaponInfoChange = 1901
EventName.WeaponUpgradeComplete = 1902
EventName.SkillInfoChange = 1903
EventName.PartnerInfoChange = 1903
EventName.ClickTalentItem = 1904
EventName.RoleMaxLevChange = 1905
EventName.PartnerWorkUpdate = 1906
EventName.PartnerBagSortSubmit = 1907
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
EventName.OnEntityLand = 121 -- 实体落地
EventName.DoEntityLandAnim = 122    -- 实体要播落地动作 给技能状态的时候判断用的
EventName.RoleInit = 123
EventName.OnEntityDie = 124
EventName.OnEntitySwim = 125
EventName.UpdateQTERes = 126
EventName.EcoMonsterLevBiasUpdate = 127
EventName.EntityWillDie = 128

EventName.EnterDeath = 200
EventName.ExitDeath = 201
EventName.Revive = 202
EventName.FightPause = 203
EventName.RemoveEntity = 204
EventName.ChangeCollistionParam = 205
EventName.RemoveHackingBuild = 206
EventName.ShowCursor = 207 --显示鼠标指针
EventName.CreateEntity = 208

EventName.UnityUpdate = 301
EventName.LogicUpdate = 301


--#region 系统相关
EventName.SystemOpen = 2001
EventName.CloseNoticePnl = 2002
EventName.NoticeQueueActive = 2003
--#endregion

--#region 剧情相关
EventName.StoryDialogEnd = 2101
EventName.StoryTriggerEvent = 2102
EventName.StoryDialogStart = 2103
EventName.StartNPCDialog = 2104
EventName.UpdateOptionContent = 2105
EventName.ClipEnter = 2106
EventName.ClipPause = 2107
EventName.StorySelectEvent = 2108
EventName.StoryPassEvent = 2112
--#endregion

--#region 商店相关
EventName.ShopBuyGoodComplete = 2201
EventName.ShopOpen = 2202
EventName.ShopBuyGoods = 2203
EventName.ShopListUpdate = 2204
EventName.CloseEntityShop = 2205
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
EventName.UpdatePromoteInfo = 2607
EventName.UpdateDailyRewardInfo = 2608
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
EventName.OnDroneCountDownUpdate = 3103
EventName.HackMail = 3104
EventName.HackPhoneCall = 3105
EventName.HackStateChange = 3106
EventName.HackEntityEnable = 3107
EventName.HackBatteryLow = 3108 --骇入电量不足

EventName.BuildSelectLeft = 3111
EventName.BuildSelectRight = 3112
EventName.Building = 3113
EventName.BuildUnlock = 3114
EventName.SetDroneAimTarget = 3115

EventName.PlayerRamChange = 3116
EventName.HackEntityTaskEffectUpdate = 3117
EventName.HackEntityIsActiveStateUpdate = 3118

EventName.BuildConsoleOffLimit = 3119

EventName.HackEntityHackButtonEnableUpdate = 3120

EventName.NpcMailStateChange = 3121
EventName.NpcCallStateChange = 3122
EventName.ShowHackingRamTips = 3123
EventName.QuitBuildState = 3124

EventName.BuildControlEntity = 3125

EventName.HackEntityInformationUpdate = 3126
EventName.HackEntityButtonInfoUpdate = 3127
EventName.HackEntityEffectUpdate = 3128

EventName.BuildConsoleActive = 3125
--#endregion

--#region 文本本地化
EventName.ChangeLanguage = 3201
--#endregion

--#region 回购系统
EventName.SetPlacingItem = 3301
EventName.TradeWindowBargainUpdate = 3302

----#region 邮件系统
EventName.MailRefresh = 3401
EventName.MailRead = 3402
EventName.MailGetAward = 3403

----#region 公告系统
EventName.AnnouncementRefresh = 3501
EventName.AnnouncementRead = 3502

--#endregion

--#region 商城系统
EventName.PurchaseOpen = 3401
EventName.GetPurchasePackage = 3402
EventName.MonthCardUpdate = 3403
EventName.OnPurchaseRecord = 3404
--#endregion

--#region 抽卡系统
EventName.DrawReward = 3601
EventName.UpdateDrawGuarantee = 3602
EventName.UpdateDrawHistory = 3603
EventName.UpdateDraw = 3604
--#endregion

--#region 个人信息系统
EventName.InformationRoleSubmit = 3701
EventName.SetBirthday = 3702
EventName.SetBirthdayFinish = 3703
--#endregion

--#region 好友系统
EventName.FriendListRefresh = 3801
EventName.FriendBlackListRefresh = 3802
EventName.ModifyRemark = 3803
EventName.FriendRemove = 3804
EventName.ChatListRefresh = 3805
EventName.ChatRedPointRefresh = 3806
EventName.RemakrNameChange = 3807
EventName.FriendStateRefresh = 3808
--#endregion

--#region 活动系统
EventName.ActivitySignInUpdate = 3901
EventName.ActivityTaskUpdate = 3902
EventName.ActivitysInfoChange = 3903
--#endregion

--#region 拍照
EventName.DesignSelectChange = 4001
--#endregion

--#region 道途系统
EventName.IdentitySelect = 5001
EventName.IdentityLvChange = 5002
EventName.IdentityExpChange = 5003
EventName.IdentityGetReward = 5004
EventName.IdentitRewardRefresh = 5005
EventName.IdentityChange = 5006
EventName.IdentityOptionUnlock = 5007
--#endregion

--#region 肉鸽系统
EventName.EquipCardUpdate = 6001
EventName.GetSeasonReward = 6002
EventName.CheckRogueRed = 6003
EventName.RefreshBySort = 6004
EventName.RefreshEvolutionPanel = 6005
--#endregion

--#region 短信
EventName.MessageInfo= 7001
EventName.StartMainMessage = 7002
EventName.StartNormalMessage = 7003
EventName.OpenMeaasgeMainPanel = 7004
EventName.OpenMessageTalkPanel = 7005
EventName.NpcCallbackMessage = 7006
EventName.MessageEnd = 7007
EventName.SortMessage = 7008
EventName.UpdateConditionType = 7009
EventName.GuideEnd = 7010
--#endregion

--#region 剧情弹幕
EventName.CheckBullet = 8001
EventName.FireBulletSuccess = 8002
EventName.BulletPause = 8003
EventName.BulletRestore = 8004
EventName.BulletEnterShare = 8005
EventName.BulletExitShare = 8006
EventName.CloseSkipStoryKeyCode = 8007
EventName.OpenSkipStoryKeyCode = 8008

--#endregion

--#region 犯罪系统
EventName.OnBountyValueChange = 7001
EventName.OutPrison = 7002
--#endregion

--#region 副本
EventName.ResetDuplicate = 10001
--#endregion

--#region 能力轮盘
EventName.ChangeWheelAbility = 11002
EventName.AbilityNewGet = 11003
EventName.AbilityWheelFightPanelClose = 11003
--#endregion

--#region 城市经营
EventName.RefreshShopInfoArea = 12001
EventName.OpenAdjustmentPanel = 12002
EventName.RefreshCardsSelectState = 12003
EventName.RefreshGradeItemSelectState = 12004
EventName.GoToStore = 12005
EventName.RefreshGradeItemLockState = 12006
EventName.RefreshEntrustmentGradePanel = 12007
EventName.RefreshEntrustmentChoiceWindow = 12008
EventName.OnClickSelectAdjustmentCard = 12009
EventName.OnClickSelectBottomCard = 12010
--#endregion



--#region 道路引导线
EventName.UpdateRoadPath = 13001
EventName.RemoveRoadPath = 13002
EventName.PathFindEnd = 13003
EventName.UpdateNavMeshPath = 13004
EventName.RemoveNavMeshPath = 13005
EventName.RemoveDrawPath = 13006
--#endregion

--#region 梦魇终战
EventName.NightMareSelectRole = 14001
EventName.FormationEditorSelect = 14002
EventName.NightMareFreshRank = 14003
--#endregion

--#region 叫车系统
EventName.CallVehicleTime = 15001
EventName.GetInCar = 15002
EventName.GetOffCar = 15003
EventName.CrashCar = 15004
EventName.MonitorDistance = 15005
EventName.EnableRoadEdge = 15006
--#endregion

--#region
EventName.BargainEnd = 16001
--#endregion

--#region
EventName.ShowLevelOccupancyTips = 17001
EventName.ShowLevelOnMap = 17002
--#endregion

--#region
EventName.EnterSystemState = 18001
EventName.ExitSystemState = 18002
EventName.EnterStateView = 18003
EventName.ExitStateView = 18004
EventName.OnExitStory = 18005
--#endregion

--#region 演出
EventName.PartnerDisplayUpdate = 20001
EventName.UpdatePartnerDisplayState = 20002
EventName.UpdateDiaplayInteractItem = 20003
--#endregion

--#region 资产中心
EventName.OnSetPartnerWorkInDevice = 21001
EventName.OnSetPartnerWorkInAsset = 21002
EventName.UpdateSelectedFoodItem = 21003
EventName.UpdateDiningTableItemNum = 21004
EventName.EnterAsset = 21005
EventName.AssetLevelUp = 21006
EventName.AssetDecorationInfoUpdate = 21007
EventName.UpdateSelectedPartnerBallItem = 21008
EventName.SetPartnerBallWindowState = 21009
EventName.UpdateDecorationInfo = 21010
EventName.UpdateBuildingPanelData = 21011
EventName.UpdatePartnerWorkableValue = 21012
EventName.RemoveDeviceInteract = 21013
EventName.UpdateDecorationNumInAsset = 21014
--#endregion

--#endregion 昼夜系统
EventName.DayNightTimeChanged = 22001
EventName.EnterTaskTimeArea = 22002
EventName.DayNightHourChanged = 22003
--#region

--#endregion 通知中心
EventName.RoleLevUpEnd = 23001
EventName.RoleStageUpEnd = 23002
EventName.RoleWeaponChangeEnd = 23003
EventName.RoleWeaponLevUpEnd = 23004
EventName.RoleWeaponStageUpEnd = 23005
EventName.RoleSkillUpEnd = 23006
EventName.RolePartnerChangeEnd = 23006
--#region