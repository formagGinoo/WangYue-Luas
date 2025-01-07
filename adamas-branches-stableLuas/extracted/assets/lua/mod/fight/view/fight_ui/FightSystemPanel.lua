FightSystemPanel = BaseClass("FightSystemPanel", BasePanel)

--临时颜色配置
--体力条
local StrengthColor = {
	Color(255/255, 255/255, 255/255, 255/255),	--基础颜色
	Color(43/255, 54/255, 67/255, 159/255),		--基础背景颜色
	Color(225/255, 58/255, 58/255, 255/255),	--低数值颜色
	Color(112/255, 57/255, 59/255, 159/255)	,	--低数值背景颜色
	Color(177/255, 154/255, 89/255, 255/255) 	--followBg颜色
}

--叙慕核心
local XumuResCoreColor = {
	Color(255/255, 40/255, 37/255, 255/255),	--基础颜色
	Color(43/255, 54/255, 67/255, 159/255),		--基础背景颜色
	Color(247/255, 117/255, 96/255, 255/255),	--低数值颜色
	Color(112/255, 57/255, 59/255, 159/255)	,	--低数值背景颜色
}

--刻刻核心
local KekeResCoreColor = {
	Color(154/255, 72/255, 227/255, 255/255),	--基础颜色
	Color(43/255, 54/255, 67/255, 159/255),		--基础背景颜色
	Color(247/255, 117/255, 96/255, 255/255),	--低数值颜色
	Color(112/255, 57/255, 59/255, 159/255)	,	--低数值背景颜色
}

local CarDriveMapScale = Config.DataCommonCfg.Find["CarDriveMapScale"].int_val

function FightSystemPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightSystemPanel.prefab")
    self.mainView = mainView

	-- 小地图
	self.marksOnShow = {}
	self.markPool = {}
	self.traceMark = {}
	self.traceMarkPool = {}
	self.mapMaskPool = {}
	self.mapMaskOnShow = {}
	self.refreshMiniMap = true
	self.miniMapInited = false

	self.areaOnShow = {}
	self.areaObjPool = {}

	self.defaultScaleChangeTime = 3
	self.defaultMiniMapScale = 1
	self.defaultMiniMarkScale = 0.5

	self.miniMapScale = 1
	self.miniMapMarkScale = 1

	self.tmpCyclePos = Vec3.New()
end

function FightSystemPanel:__BindListener()
    self.TaskButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenTask"))
	self.BagButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenBag"))
	self.PartnerBagButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPartnerBag"))
	self.FormationButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenFormation"))
	self.RoleButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenRole"))
    self.MainMenuButton_btn.onClick:AddListener(self:ToFunc("OnClick_MainMenu"))
	self.TeachBtn_btn.onClick:AddListener(self:ToFunc("OnClick_TeachBtn"))
	self.AdventureButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenAdventure"))
	self.ActivityButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenActivity"))
	self.QuitDupBtn_btn.onClick:AddListener(self:ToFunc("OnClick_QuitDupBtn"))
	self.CameraBtn_btn.onClick:AddListener(self:ToFunc("OnClick_AbilityWheelBtn"))
	self.CommunicationButton_btn.onClick:AddListener(self:ToFunc("OnClick_CommunicationButton"))
	self.RoGueBtn_btn.onClick:AddListener(self:ToFunc("OnClick_RoGueBtn"))
	self.SumMessageBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenMessage"))
	self.AssetTaskButton_btn.onClick:AddListener(self:ToFunc("OnClick_AssetTaskButton"))
	self.AssetBuildButton_btn.onClick:AddListener(self:ToFunc("OnClick_AssetBuildButton"))

	-- 犯罪系统按钮
	self.ZhuiIcon_btn.onClick:AddListener(self:ToFunc("OnClick_CrimeZhui"))
	self.ZhuiClose_btn.onClick:AddListener(self:ToFunc("OnClick_CrimeZhuiClose"))
	self.CrimeKun_btn.onClick:AddListener(self:ToFunc("OnClick_CrimeKun"))
	self.KunClose_btn.onClick:AddListener(self:ToFunc("OnClick_CrimeKunClose"))

	local darpEvent = self.Map:AddComponent(UIDragBehaviour)
	darpEvent.onPointerClick = self:ToFunc("OnClick_Map")
	--self.Map_btn.onClick:AddListener(self:ToFunc("OnClick_Map"))
	
	self.strengthBarLogic = CycleProcessLogic.New
	(
		self.StrengthBar, 
		self.SubStrengthBar,
		self.StrengthBar1, 
		self.StrengthBar2, 
		self.StrengthBarBg, 
		self.StrengthLowBarBg, 
		self, 
		Vec3.New(100, 40, 0), 
		true, 
		StrengthColor
	)
end

function FightSystemPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.AddTeach, self:ToFunc("UpdateTeachRed"))
    EventMgr.Instance:AddListener(EventName.RetTeachLookReward, self:ToFunc("UpdateTeachRed"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowAdv"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowActivity"))
	EventMgr.Instance:AddListener(EventName.ActivitysInfoChange, self:ToFunc("UpdateActivity"))
	EventMgr.Instance:AddListener(EventName.MapAreaUpdate, self:ToFunc("OnMapAreaUpdate"))
	EventMgr.Instance:AddListener(EventName.WorldMapCtrlEntityLoadDone, self:ToFunc("OnWorldEntityInitDone"))
	EventMgr.Instance:AddListener(EventName.EnterDuplicate, self:ToFunc("UpdateQuitFightBtnVisible"))
	EventMgr.Instance:AddListener(EventName.LeaveDuplicate, self:ToFunc("UpdateQuitFightBtnVisible"))
	EventMgr.Instance:AddListener(EventName.StartMainMessage, self:ToFunc("ShowMessagePanel"))
	EventMgr.Instance:AddListener(EventName.StartNormalMessage, self:ToFunc("ShowMessageTips"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowPartnerBag"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowRoGue"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowMap"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowAbility"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowTeach"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowRole"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowBag"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowMainMenu"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowFormation"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowFriend"))
	EventMgr.Instance:AddListener(EventName.OutPrison, self:ToFunc("OutPrison"))
	EventMgr.Instance:AddListener(EventName.OnBountyValueChange, self:ToFunc("BountyValueChange"))
	EventMgr.Instance:AddListener(EventName.OnStrengthBarStateUpdate, self:ToFunc("SetUpdateStrengthBarState"))
	EventMgr.Instance:AddListener(EventName.GetInCar, self:ToFunc("GetInCar"))
	EventMgr.Instance:AddListener(EventName.GetOffCar, self:ToFunc("GetOffCar"))
    EventMgr.Instance:AddListener(EventName.ShowLevelOnMap, self:ToFunc("ShowLevelOnMap"))

	self:BindRedPoint(RedPointName.Task, self.TaskRed)
	self:BindRedPoint(RedPointName.Adv, self.AdvRed)
	self:BindRedPoint(RedPointName.Activity, self.ActivityRed)
	self:BindRedPoint(RedPointName.Teach, self.TeachRed)
	self:BindRedPoint(RedPointName.SystemMenu, self.MenuRed)
	self:BindRedPoint(RedPointName.Role, self.RoleRed)
	self:BindRedPoint(RedPointName.UnReadChat, self.ChatRed)
	self:BindRedPoint(RedPointName.RoGue, self.RoGueRed)
	self:BindRedPoint(RedPointName.AssetTask, self.AssetTaskRed)
end

function FightSystemPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightSystemPanel:__Show()
	self.StrengthBar_canvas.alpha = 0
	--self:UpdateTeachRed()
	self:UpdatePlayer()
	self:LoadMiniMap()
	self:ShowActivity()
	self:ShowAdv()
	self:ShowFormation()
	self:ShowFriend()
	self:UpdateQuitFightBtnVisible()
	self:ShowRoGue()
	self:ShowMap()
	self:ShowCrime()
	self:ShowMessageBtn()
	self:ShowAbility()
	self:ShowTeach()
	self:ShowRole()
	self:ShowBag()
	self:ShowPartnerBag()
	self:ShowMainMenu()
	self:ShowAssetTask()
	self:ShowAssetBuild()
end

function FightSystemPanel:UpdateActivity()
	self:ShowActivity()
	-- 活动红点树被重构，结点都变成新的，要重新设置其bind
    RedPointMgr.Instance:AddBind(RedPointName.Activity)
end

function FightSystemPanel:UpdateQuitFightBtnVisible()
	local isDup = mod.WorldMapCtrl:CheckIsDup()
	if isDup then
		local duplicateId, levelId = mod.WorldMapCtrl:GetDuplicateInfo()
		local cfg = DuplicateConfig.GetDuplicateConfigById(duplicateId)
		isDup = isDup and cfg.exit_button
	end
	self.QuitDupBtn:SetActive(isDup)
	self:ShowActivity()
end

function FightSystemPanel:ShowActivity()
	local isDup = mod.WorldMapCtrl:CheckIsDup()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.HuoDong) 
	isOpen =  isOpen and mod.ActivityCtrl:CheckHasActivityPlaying()
	self.ActivityButton:SetActive(isOpen and not isDup)
end

function FightSystemPanel:ShowAdv()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.MaoXian)
	self.AdventureButton:SetActive(isOpen)
end

function FightSystemPanel:ShowFormation()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Formation)
	self.FormationButton:SetActive(isOpen)
end

function FightSystemPanel:ShowFriend()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Friend)
	self.CommunicationButton:SetActive(isOpen)
end

function FightSystemPanel:ShowMap()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Map)
	self.Map:SetActive(isOpen)
end

function FightSystemPanel:ShowAbility()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.AbilityWheel)
	self.CameraBtn:SetActive(isOpen)
end

function FightSystemPanel:ShowTeach()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Teach)
	self.TeachBtn:SetActive(isOpen)
end

function FightSystemPanel:ShowRole()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Role)
	self.RoleButton:SetActive(isOpen)
end

function FightSystemPanel:ShowBag()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Bag)
	self.BagButton:SetActive(isOpen)
end

function FightSystemPanel:ShowMainMenu()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.MainMenu)
	self.MainMenuButton:SetActive(isOpen)
end

function FightSystemPanel:ShowAssetTask()
	self.AssetTaskButton:SetActive(mod.AssetPurchaseCtrl:GetCurAssetId() ~= nil)
end

function FightSystemPanel:ShowAssetBuild()
	self.AssetBuildButton:SetActive(mod.AssetPurchaseCtrl:GetCurAssetId() ~= nil)
end

function FightSystemPanel:ShowMessagePanel(messageId,talkId,groupId)
	local args =
	{
		PanelType = InformationConfig.PanelType.MessagePanel,
		messageTalkId = talkId,
		Messagegroup = groupId,
		messageId = messageId
	}
	if talkId then
		self.optionList = {}
	    mod.InformationCtrl:SendMessageProgress(messageId,talkId,self.optionList)
		--mod.MessageCtrl:SetReadingMessageConfig(talkId)
	end
	WindowManager.Instance:OpenWindow(PhoneMenuWindow,args)
end

function FightSystemPanel:ShowMessageBtn()
	local open = mod.MessageCtrl:CheckHaveNewMessage()
	self.SumMessageBtn:SetActive(open)
end

function FightSystemPanel:ShowMessageTips(messageId,groupId,talkId)  

	local TypeId = Config.DataMessageCome.Find[messageId].message_main_id
    local config = Config.DataMessageType.Find[TypeId]
    self.MessageTips:SetActive(true)
	SingleIconLoader.Load(self.MessageHeadIcon,config.icon)
	self.MessageNameText_txt.text = config.message_main_name
	self.groupId =  groupId
	self.talkId = talkId
	self.messageId = messageId
	self.optionList = {}
	mod.InformationCtrl:SendMessageProgress(self.messageId,self.talkId,self.optionList)
	mod.MessageCtrl:SetMessageTypesConfig(messageId,talkId)
	--mod.MessageCtrl:SetReadingMessageConfig(talkId)
	--显示短信按钮
	self.SumMessageBtn:SetActive(true)
    self:CloseMessageTip(2)
end

function FightSystemPanel:CloseMessageTip(delayTime)
	if delayTime == 0 then
		self.MessageTips:SetActive(false)
	else
		local callback = function()
			if self.showTimer then
				LuaTimerManager.Instance:RemoveTimer(self.showTimer)
				self.showTimer = nil
			end
			self.MessageTips:SetActive(false)
		end
		if self.showTimer then
			LuaTimerManager.Instance:RemoveTimer(self.showTimer)
			self.showTimer = nil
		end
		self.showTimer = LuaTimerManager.Instance:AddTimer(1, delayTime, callback)
	end
end

function FightSystemPanel:ShowRoGue()
	local isDup = mod.WorldMapCtrl:CheckIsDup()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Rogue)
	self.RoGueBtn:SetActive(isOpen and not isDup)
end

function FightSystemPanel:ShowPartnerBag()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Partner)
	self.PartnerBagButton:SetActive(isOpen)
end

function FightSystemPanel:ShowCrime()
	if mod.CrimeCtrl:CheckInPrison() then
		self.countdownPanel = PanelManager.Instance:OpenPanel(PrisonCountDownPanel)
		UtilsUI.SetActive(self.CrimeKun,true)
		self.KunMask_img.fillAmount = mod.CrimeCtrl:GetBountyReduceProgress()
		UtilsUI.SetActive(self.TaskButton,false)
		UtilsUI.SetActive(self.CrimeZhui,false)
	else
		UtilsUI.SetActive(self.CrimeKun,false)
		UtilsUI.SetActive(self.TaskButton,true)
		local star = mod.CrimeCtrl:GetBountyStar()
		if star > 0 then
			self.CrimeStart_txt.text = star
			UtilsUI.SetActive(self.CrimeZhui,true)
		else
			UtilsUI.SetActive(self.CrimeZhui,false)
		end
	end
end

function FightSystemPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightSystemPanel:__delete()
	self.strengthBarLogic:DeleteMe()
	self.strengthBarLogic = nil

	if self.mapSequence then
		self.mapSequence:Kill()
		self.mapSequence = nil
	end
	if self.tweenTimer then 
		LuaTimerManager.Instance:RemoveTimer(self.tweenTimer)
		self.tweenTimer = nil
	end

	if self.countdownPanel then
		PanelManager.Instance:ClosePanel(self.countdownPanel)
		self.countdownPanel = nil
	end
end

function FightSystemPanel:__Hide()
	for k, v in pairs(self.marksOnShow) do
		self:RemoveMark(k)
	end

	for k, v in pairs(self.mapMaskOnShow) do
		local maskObj = self.mapMaskOnShow[k]
		UnityUtils.SetActive(maskObj.object, false)
		table.insert(self.mapMaskPool, maskObj)
		self.mapMaskOnShow[k] = nil
	end

	EventMgr.Instance:RemoveListener(EventName.AddTeach, self:ToFunc("UpdateTeachRed"))
    EventMgr.Instance:RemoveListener(EventName.RetTeachLookReward, self:ToFunc("UpdateTeachRed"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowAdv"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowActivity"))
	EventMgr.Instance:RemoveListener(EventName.ActivitysInfoChange, self:ToFunc("UpdateActivity"))
	EventMgr.Instance:RemoveListener(EventName.MapAreaUpdate, self:ToFunc("OnMapAreaUpdate"))
	EventMgr.Instance:RemoveListener(EventName.WorldMapCtrlEntityLoadDone, self:ToFunc("OnWorldEntityInitDone"))
	EventMgr.Instance:RemoveListener(EventName.EnterDuplicate, self:ToFunc("UpdateQuitFightBtnVisible"))
	EventMgr.Instance:RemoveListener(EventName.LeaveDuplicate, self:ToFunc("UpdateQuitFightBtnVisible"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowRoGue"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowPartnerBag"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowMap"))
	EventMgr.Instance:RemoveListener(EventName.StartMainMessage, self:ToFunc("ShowMessagePanel"))
	EventMgr.Instance:RemoveListener(EventName.StartNormalMessage, self:ToFunc("ShowMessageTips"))
	EventMgr.Instance:RemoveListener(EventName.OutPrison, self:ToFunc("OutPrison"))
	EventMgr.Instance:RemoveListener(EventName.OnBountyValueChange, self:ToFunc("BountyValueChange"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowAbility"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowTeach"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowRole"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowBag"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowMainMenu"))
	EventMgr.Instance:RemoveListener(EventName.OnStrengthBarStateUpdate, self:ToFunc("SetUpdateStrengthBarState"))
	EventMgr.Instance:RemoveListener(EventName.GetInCar, self:ToFunc("GetInCar"))
	EventMgr.Instance:RemoveListener(EventName.GetOffCar, self:ToFunc("GetOffCar"))
    EventMgr.Instance:RemoveListener(EventName.ShowLevelOnMap, self:ToFunc("ShowLevelOnMap"))
end


function FightSystemPanel:OnClick_OpenBag()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Bag)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(BagWindow)
	end)
end

function FightSystemPanel:OnClick_OpenPartnerBag()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Partner)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function()
		PartnerBagMainWindow.OpenWindow()
	end)
end

function FightSystemPanel:OnClick_OpenFormation()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Formation)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	if BehaviorFunctions.CheckPlayerInFight() then
		MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
		return
	end
	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	for i = 1, #FormationConfig.FormationState, 1 do
		if entity.stateComponent:IsState(FormationConfig.FormationState[i]) then
			break
		end
		if i == #FormationConfig.FormationState then
			MsgBoxManager.Instance:ShowTips(TI18N("当前无法操作"))
			return
		end
	end
	self.mainView:HideSelf(function()
		FormationWindowV2.OpenWindow()
	end)
end

function FightSystemPanel:OnClick_OpenRole()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Role)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		local heroId = mod.RoleCtrl:GetCurUseRole()
		mod.RoleCtrl:SetCurUISelectRole(heroId)
		RoleMainWindow.OpenWindow(mod.RoleCtrl:GetCurUseRole())
	end)
end

function FightSystemPanel:OnClick_OpenTask()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Task)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(TaskMainWindow)
	end)
end

function FightSystemPanel:OnClick_OpenActivity()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.HuoDong)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(ActivityMainWindow)
	end)

end

function FightSystemPanel:OnClick_OpenAdventure()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.MaoXian)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(AdvMainWindowV2)
	end)
	
end

function FightSystemPanel:OnClick_MainMenu()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.MainMenu)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	local args =
	{
		PanelType = InformationConfig.PanelType.PhonePanel
	}
	self.mainView:HideSelf(function ()
		--WindowManager.Instance:OpenWindow(SystemMenuWindow,args)
		WindowManager.Instance:OpenWindow(PhoneMenuWindow,args)
	end)
end

function FightSystemPanel:OnClick_AssetTaskButton()
	WindowManager.Instance:OpenWindow(AssetTaskWindow)
end

function FightSystemPanel:OnClick_AssetBuildButton()
	mod.DecorationCtrl:OpenDecorationPanel()
end

function FightSystemPanel:OnClick_QuitDupBtn()
	local wordCtrl = mod.WorldMapCtrl
	local isDup = wordCtrl:CheckIsDup()
	if not isDup then return end
	self:OpenDupTipByDupType()
end

function FightSystemPanel:OpenDupTipByDupType()
	local dupId = mod.DuplicateCtrl:GetSystemDuplicateId()
	local dupCfg = DuplicateConfig.GetSystemDuplicateConfigById(dupId)
	if dupCfg.type == FightEnum.SystemDuplicateType.NightMare then	-- 梦魇类型
		PanelManager.Instance:OpenPanel(NightMareQuitTipPanel, {
			hideCallBack = function ()
				self:ResetFightDup()
			end,
			sureCallBack = function ()
				self:QuitFightDup()
			end})
	else
		PanelManager.Instance:OpenPanel(DuplicateTipPanel, { sureCallBack = function ()
				self:QuitFightDup()
		end})
	end
end

function FightSystemPanel:OnClick_AbilityWheelBtn()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.AbilityWheel)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	mod.AbilityWheelCtrl:OpenFightAbilityWheel()
end

function FightSystemPanel:OnClick_CommunicationButton()
	WindowManager.Instance:OpenWindow(ChatMainWindow)
end

function FightSystemPanel:OnClick_RoGueBtn()
	WindowManager.Instance:OpenWindow(WorldRogueMainWindow)
end

function FightSystemPanel:OnClick_OpenMessage()
	self:ShowMessagePanel(self.messageId,self.talkId,self.groupId)
	self.SumMessageBtn:SetActive(false)
end

function FightSystemPanel:ResetFightDup()
	if Fight.Instance then
		Fight.Instance.duplicateManager:ResetDuplicateLevel()
	end
end

function FightSystemPanel:QuitFightDup()
	if Fight.Instance then
		Fight.Instance.duplicateManager:ExitDuplicate()
	end
end

function FightSystemPanel:HideSelf()
	self.FightSystemPanel_out:SetActive(true)
end

function FightSystemPanel:OnClick_TeachBtn()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Teach)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(TeachWindow)
	end)
end

function FightSystemPanel:OnClick_CrimeZhui()
	self:SetZhuiDesc()
	UtilsUI.SetActive(self.ZhuiDesc,true)
	UtilsUI.SetActive(self.ZhuiClose,true)
end

function FightSystemPanel:SetZhuiDesc()
	self.ZhuiCrimeDescTxt_txt.text = TI18N(string.format("您已经被 悬天 悬赏！若在城中被人目击，\n将引发守卫前来调查，当前悬天的悬赏度为"))
	self.ZhuiCrimeVaule_txt.text = mod.CrimeCtrl:GetBountyValue() 
end

function FightSystemPanel:BountyValueChange()
	local star = mod.CrimeCtrl:GetBountyStar()
	
	if star > 0 and not mod.CrimeCtrl:CheckInPrison() then
		self.CrimeStart_txt.text = star
		UtilsUI.SetActive(self.CrimeZhui,true)
	else
		UtilsUI.SetActive(self.CrimeZhui,false)
	end
	if mod.CrimeCtrl:CheckInPrison() then
		self.KunMask_img.fillAmount = mod.CrimeCtrl:GetBountyReduceProgress()
	end
end 

function FightSystemPanel:OnClick_CrimeZhuiClose()
	UtilsUI.SetActive(self.ZhuiDesc,false)
	UtilsUI.SetActive(self.ZhuiClose,false)
end

function FightSystemPanel:OnClick_CrimeKun()
	self:SetKunDesc()
	UtilsUI.SetActive(self.KunDesc,true)
	UtilsUI.SetActive(self.KunClose,true)
end

function FightSystemPanel:SetKunDesc()
	self.KunCrimeDescTxt_txt.text = TI18N(string.format("正在坐牢，每秒钟可扣除%d点悬赏值，悬赏值清零后请与狱警对话办理出狱手续",mod.CrimeCtrl:GetBountyReduceSpeed()))
end

function FightSystemPanel:OnClick_CrimeKunClose()
	UtilsUI.SetActive(self.KunDesc,false)
	UtilsUI.SetActive(self.KunClose,false)
end

function FightSystemPanel:OutPrison()
	if self.countdownPanel then
		PanelManager.Instance:ClosePanel(self.countdownPanel)
		self.countdownPanel = nil
	end
	UtilsUI.SetActive(self.CrimeZhui,false)
	UtilsUI.SetActive(self.ZhuiDesc,false)
	UtilsUI.SetActive(self.ZhuiClose,false)
	UtilsUI.SetActive(self.CrimeKun,false)
	UtilsUI.SetActive(self.KunDesc,false)
	UtilsUI.SetActive(self.KunClose,false)
	UtilsUI.SetActive(self.TaskButton,true)
end

-- TODO 后续添加地图参数
function FightSystemPanel:OnClick_Map()
	local isDup = mod.WorldMapCtrl:CheckIsDup()
	if isDup then
		return
	end
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Map)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(WorldMapWindow)
	end)

end

function FightSystemPanel:UpdatePlayer()
	self.player = Fight.Instance.playerManager:GetPlayer()
	self.entity = self.player:GetCtrlEntityObject()
end

function FightSystemPanel:SetUpdateStrengthBarState(state)
	self.strengthBarUpdate = state or false
end

function FightSystemPanel:Update()
	UnityUtils.BeginSample("FightSystemPanel")
	local staminaValue, staminaMaxValue = self.player.fightPlayer:GetValueAndMaxValue(FightEnum.PlayerAttr.CurStaminaValue)

	if self.player and self.player.fightPlayer and self.staminaMaxValue ~= staminaMaxValue then
		self.staminaMaxValue = staminaMaxValue
		self.strengthBarLogic:UpdateMaxValue(self.staminaMaxValue)
	end
	if self.player and self.player.fightPlayer and (self.staminaValue ~= staminaValue or self.staminaMaxValue ~= staminaMaxValue or self.strengthBarUpdate == true) then
		self.strengthBarUpdate = true
		self.staminaValue = staminaValue
		self.strengthBarLogic:Update(self.entity, self.staminaValue, self.staminaMaxValue)
	end
	UnityUtils.EndSample()
	-- 小地图
	UnityUtils.BeginSample("UpdateMiniMap")
	self:UpdateMiniMap()
	UnityUtils.EndSample()

end

function FightSystemPanel:UpdateTeachRed()

end

--#region MiniMap

-- TODO 后续按照位置做区块加载 加载一个九宫格出来
function FightSystemPanel:LoadMiniMap()
	local mapId = Fight.Instance:GetFightMap()
	local sceneMapCfg, mapCfg = mod.WorldMapCtrl:GetMapConfig(mapId)
	
	if not mapCfg or not mapCfg.mini_map or mapCfg.mini_map == "" then
		self.MapContent:SetActive(false)
		self.MapMask:SetActive(false)
		self.refreshMiniMap = false
		return
	end
	self.MapMask:SetActive(true)
	self.defaultMiniMapScale = mapCfg.width / 2048
	self.miniMapMarkScale = self.defaultMiniMarkScale / self.defaultMiniMapScale
	
	local iconCb = function ()
		if not self.MapContent_img then
			return
		end

		local sprite = self.MapContent_img.sprite
		self.miniMapScale = self.defaultMiniMapScale

		local areaId = self.entity.values["sAreaId"]
		local areaCfg = Fight.Instance.mapAreaManager:GetAreaConfig(areaId, mapId)
		if areaCfg and next(areaCfg) then
			local changeTimes = areaCfg.change_scale ~= 0 and areaCfg.change_scale or self.defaultScaleChangeTime
			self.miniMapScale = (changeTimes / self.defaultScaleChangeTime) * self.defaultMiniMapScale
		end
		if sprite then
			UnityUtils.SetSizeDelata(self.MapContent.transform, math.max(sprite.rect.width, 2048), math.max(sprite.rect.height, 2048))
		end
		if not self.mapSequence then 
			UnityUtils.SetLocalScale(self.MapContent.transform, self.miniMapScale, self.miniMapScale, self.miniMapScale)
		end

		self:LoadMapMasks(mapId)
		if mod.WorldMapCtrl:CheckWorldEntityInitDone() then
			self:LoadMapMarks(mapId)
			self.miniMapInited = true
		end
		self:ChangeMapPos(self.lastEntityPosition)
		--self:UpdateMiniMap()
	end
	SingleIconLoader.Load(self.MapContent, mapCfg.mini_map, iconCb)
end

function FightSystemPanel:OnWorldEntityInitDone()
	local mapId = Fight.Instance:GetFightMap()
	self:LoadMapMarks(mapId)
	self.miniMapInited = true
end

function FightSystemPanel:LoadMapMasks(mapId)
	local lockArea = Fight.Instance.mapAreaManager:GetLockMidArea()
	local maskScale = 1 / self.defaultMiniMarkScale
    for k, v in pairs(lockArea) do
		if v.map_id ~= mapId then
			goto continue
		end

		local areaMaskX, areaMaskY = Fight.Instance.mapAreaManager:GetAreaMaskPos(v.id, mapId)
        local blockPic = string.format("Textures/Icon/Single/MapIcon/areamask_%s_%s.png", v.id, mapId)
        local blockObj = self:GetMapMaskObj()
        local callBackFunc = function()
			if not self.defaultMiniMapScale or not self.defaultMiniMarkScale then
				return
			end

            local sprite = blockObj.MaskTemp_img.sprite
            UnityUtils.SetSizeDelata(blockObj.objectTransform, sprite.rect.width, sprite.rect.height)
			UnityUtils.SetLocalScale(blockObj.objectTransform, 4, 4, 4)
            UnityUtils.SetLocalPosition(blockObj.objectTransform, areaMaskX  , areaMaskY , 0)
            blockObj.object:SetActive(true)
            blockObj.object.name = "map_mask_"..k
        end

        SingleIconLoader.Load(blockObj.object, blockPic, callBackFunc)

        table.insert(self.mapMaskOnShow, blockObj)

		::continue::
    end
end

function FightSystemPanel:GetMapMaskObj()
    if next(self.mapMaskPool) then
        return table.remove(self.mapMaskPool)
    end

    local obj = self:PopUITmpObject("MaskTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetParent(self.MapBlock.transform)

    return obj
end

function FightSystemPanel:OnMapAreaUpdate()
	if not self.miniMapInited then return end
	local mapId = Fight.Instance:GetFightMap()
	local sceneMapCfg, mapCfg = mod.WorldMapCtrl:GetMapConfig(mapId)
	if not mapCfg or not mapCfg.mini_map or mapCfg.mini_map == "" then
		return
	end

	for k, v in pairs(self.mapMaskOnShow) do
		local maskObj = self.mapMaskOnShow[k]
		UnityUtils.SetActive(maskObj.object, false)
		table.insert(self.mapMaskPool, maskObj)
		self.mapMaskOnShow[k] = nil
	end

	self:LoadMapMasks(mapId)
end

function FightSystemPanel:LoadMapMarks(mapId)
	local mapMarks = mod.WorldMapCtrl:GetMapMark(mapId)
	if not mapMarks or not next(mapMarks) then
		return
	end

	for k, v in pairs(mapMarks) do
        for instanceId, _ in pairs(v) do
            self:AddMark(instanceId)
        end
    end
end

function FightSystemPanel:AddMark(instanceId)
	if self.marksOnShow[instanceId] then
		return
	end

	local mark = mod.WorldMapCtrl:GetMark(instanceId)
	if mark.isPlayer or mod.WorldMapCtrl:CheckMarkIsHide(instanceId) then
		return
	end
	
	local mapId = Fight.Instance:GetFightMap()
	if mark.map ~= mapId then --不在同一个地图不显示小地图的追踪mark
		return
	end

	local commonMark = self:GetMarkObj(mark)
	self.marksOnShow[instanceId] = commonMark

	if mark.inTrace then
		if not self.traceMark then
			self.traceMark = {}
		end

		local traceObj = self:GetTraceObj()
		self.traceMark[instanceId] = traceObj
		self.traceMark[instanceId].info = mark
		self:RefreshTraceIcon(instanceId)
	end
end

function FightSystemPanel:RefreshMark(instanceId)
	if not self.marksOnShow[instanceId] then
		return
	end

	local mark = mod.WorldMapCtrl:GetMark(instanceId)
	self.marksOnShow[instanceId]:RefreshMapMark()

	if self.traceMark[instanceId] and not mark.inTrace then
		self.traceMark[instanceId].object:SetActive(false)
		table.insert(self.traceMarkPool, self.traceMark[instanceId].obj)
		self.traceMark[instanceId] = nil
	elseif not self.traceMark[instanceId] and mark.inTrace then
		local traceObj = self:GetTraceObj()
		self.traceMark[instanceId] = traceObj
		self.traceMark[instanceId].info = mark
		self:RefreshTraceIcon(instanceId)
	end

	-- 刷新小地图追踪标记
	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local position = entity.transformComponent.position
	local mapId = Fight.Instance:GetFightMap()
	local width, height = mod.WorldMapCtrl:TransWorldPosToUIPos(position.x, position.z, mapId)
	self:RefreshTraceMark(width, height)
end

function FightSystemPanel:RefreshTraceIcon(instanceId)
	if not self.traceMark or not self.traceMark[instanceId] then return end
	local obj = self.traceMark[instanceId]
	local icon = self:GetMarkIcon(obj.info)
	SingleIconLoader.Load(obj.TraceIcon, icon)
	local isNormal = not obj.info.jumpCfg or (obj.info.jumpCfg.jump_id ~= 100001 and obj.info.jumpCfg.jump_id ~= 100002)
	if not isNormal then
		local isActive = mod.WorldCtrl:CheckIsTransportPointActive(obj.info.ecoCfg.id)
		UnityUtils.SetActive(obj.STransBack, isActive and obj.info.jumpCfg.jump_id == 100002)
		UnityUtils.SetActive(obj.STransLock, not isActive and obj.info.jumpCfg.jump_id == 100002)
		UnityUtils.SetActive(obj.BTransBack, isActive and obj.info.jumpCfg.jump_id == 100001)
		UnityUtils.SetActive(obj.BTransLock, not isActive and obj.info.jumpCfg.jump_id == 100001)
	end
	--UnityUtils.SetActive(obj.NormalBack, isNormal and not obj.info.isPlayer)
	self.traceMark[instanceId].obj = obj
end

function FightSystemPanel:RemoveMark(instnaceId)
	if not self.marksOnShow[instnaceId] then
		return
	end

	self.marksOnShow[instnaceId]:CloseMark()
end

function FightSystemPanel:RemoveMarkCallBack(instnaceId)
	local commonMark = self.marksOnShow[instnaceId]
	table.insert(self.markPool, commonMark)
	self.marksOnShow[instnaceId] = nil

	if self.traceMark[instnaceId] then
		self.traceMark[instnaceId].object:SetActive(false)
		table.insert(self.traceMarkPool, self.traceMark[instnaceId].obj)
		self.traceMark[instnaceId] = nil
	end
end

function FightSystemPanel:GetMarkIcon(mark)
    if mark.type == FightEnum.MapMarkType.Ecosystem then
        local ecoCfg = mark.ecoCfg
        local jumpCfg = mark.jumpCfg
        local icon = jumpCfg.icon
        if ecoCfg.is_transport and not mod.WorldCtrl:CheckIsTransportPointActive(ecoCfg.id) then
            local tempStr = string.sub(icon, 1, string.len(icon) - 4)
            tempStr = tempStr .. "_lock.png"
            icon = tempStr
        end

        return icon
    else
        return mark.icon
    end
end

function FightSystemPanel:UpdateMiniMap()
	if not self.refreshMiniMap or self.mapSequence then
		return
	end

	if self.waitUpdateScale and self.waitChangeTimes then
		self:RefreshMapScale(self.waitChangeTimes)
		self.waitUpdateScale = false
		return
	end

	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local position = entity.transformComponent.position
	if not self.lastEntityPosition then
		self.lastEntityPosition = Vec3.New(0, 0, 0)
	end

	if not self.lastEntityPosition or self.lastEntityPosition ~= position then
		self:ChangeMapPos(position)
	end

	local entityEulerY = entity.clientTransformComponent.eulerAngles.y
	if not self.entityEulerY or self.entityEulerY ~= entityEulerY then
		self.entityEulerY = entityEulerY
		CustomUnityUtils.SetGoEulerAngles(self.ArrowGroup, 0, 0, -entityEulerY)
	end

	CustomUnityUtils.SetGoEulerAngles(self.Direction, 0, 0, -CameraManager.Instance.cameraTransform.rotation.eulerAngles.y)
end

function FightSystemPanel:ChangeMapPos(position)
	if not self.lastEntityPosition then return end
	self.lastEntityPosition:Set(position.x, position.y, position.z)
	local mapId = Fight.Instance:GetFightMap()
	local width, height = mod.WorldMapCtrl:TransWorldPosToUIPos(position.x, position.z, mapId)
	
	-- 因为特效会透过来 临时算一下mark的位置 手动操控一下特效
	self:TempActiveTraceEffect(width, height)
	self:RefreshTraceMark(width, height)
	
	width = width * self.miniMapScale * (1 / self.defaultMiniMapScale)
	height = height * self.miniMapScale * (1 / self.defaultMiniMapScale)
	UnityUtils.SetLocalPosition(self.MapContent.transform, -width, -height)
end

function FightSystemPanel:TempActiveTraceEffect(width, height)
	local scaleOffset = self.miniMapMarkScale / self.defaultMiniMarkScale
	local xCheck = 92 * scaleOffset
	local yCheck = 92 * scaleOffset
	for k, v in pairs(self.marksOnShow) do
		if not v.config.inTrace then
			goto continue
		end

		local isHide = false
		local toward = Vec3.Normalize(Vec3.New(v.config.posX - width, 0, v.config.posY - height))
		local targetAngle = Vec3.Angle(Vec3.forward, toward)
		if toward.x < 0 then
			targetAngle = 360 - targetAngle
		end

		local xOffset = (v.config.posX - width) * scaleOffset
		local yOffset = (v.config.posY - height) * scaleOffset
		if math.abs(math.sin(math.rad(targetAngle)) * xCheck) < math.abs(xOffset) then
			isHide = true
		end

		if math.abs(math.cos(math.rad(targetAngle)) * yCheck) < math.abs(yOffset) then
			isHide = true
		end

		v:HideMark(isHide)

		::continue::
	end
end

function FightSystemPanel:RefreshTraceMark(width, height)
	if not self.traceMark then
		return
	end

	local scaleOffset = self.miniMapMarkScale / self.defaultMiniMarkScale * self.miniMapScale
	local xCheck = 92
	local yCheck = 92
	--local xDif = 49
	--local yDif = 39
	local edge = 51 --直角边
	for k, v in pairs(self.traceMark) do
		local isShow = false
		local toward = Vec3.Normalize(Vec3.New(v.info.posX - width, 0, v.info.posY - height))
		local targetAngle = Vec3.Angle(Vec3.forward, toward)
		--if toward.x < 0 then
		--	targetAngle = 360 - targetAngle
		--end
		
		--相似三角形
		local xOffset = (v.info.posX - width) * scaleOffset * (self.miniMapScale / self.defaultMiniMapScale)
		local yOffset = (v.info.posY - height) * scaleOffset * (self.miniMapScale / self.defaultMiniMapScale)
		local sXoffset = xOffset
		local sYoffset = yOffset
		
		if sXoffset == 0 then
			sYoffset = edge
		elseif sYoffset == 0 then
			sXoffset = edge
		else
			--分成区间
			if (targetAngle >= 0 and targetAngle <= 45) or (targetAngle >= 135 and targetAngle <= 180)  then
				sYoffset = edge * scaleOffset / (self.miniMapScale / self.defaultMiniMapScale)
				sXoffset = math.abs(xOffset/yOffset * sYoffset)
			else
				sXoffset = edge * scaleOffset / (self.miniMapScale / self.defaultMiniMapScale)
				sYoffset = math.abs(yOffset/xOffset * sXoffset)
			end

			sXoffset = toward.x < 0 and -sXoffset or sXoffset
			sYoffset = toward.z < 0 and -sYoffset or sYoffset
		end

		if math.abs(math.sin(math.rad(targetAngle)) * xCheck) < math.abs(xOffset) then
			isShow = true
			--xOffset = (math.sin(math.rad(targetAngle)) * xDif) / scaleOffset / (self.miniMapScale / self.defaultMiniMapScale)
		end

		if math.abs(math.cos(math.rad(targetAngle)) * yCheck) < math.abs(yOffset) then
			isShow = true
			--yOffset = (math.cos(math.rad(targetAngle)) * yDif) / scaleOffset / (self.miniMapScale / self.defaultMiniMapScale)
		end
		
		UtilsUI.SetActive(v.object, isShow)

		if isShow then
			UtilsUI.SetActive(v["21044"], v.info.type == FightEnum.MapMarkType.Task)
			UtilsUI.SetActive(v["21030"], v.info.type ~= FightEnum.MapMarkType.Task)
			UnityUtils.SetLocalPosition(v.objectTransform, (width/self.defaultMiniMapScale + sXoffset/(self.defaultMiniMapScale* self.defaultMiniMarkScale)), (height/self.defaultMiniMapScale + sYoffset/(self.defaultMiniMapScale * self.defaultMiniMarkScale)), 0)
		else

		end
	end
end

function FightSystemPanel:RefreshMapScale(changeTimes)
	if (not changeTimes) or (changeTimes == 0) then
		return
	end
	self.waitChangeTimes = changeTimes
	changeTimes = changeTimes and changeTimes / self.defaultScaleChangeTime or 1
	local changeScale = changeTimes * self.defaultMiniMapScale
	if self.miniMapScale == self.changeScale then
		return
	end
	-- Log("changeTimes:",changeTimes,"changeScale:",changeScale)
	if self.mapSequence then
		self.mapSequence:Kill()
		self.mapSequence = nil
		
		if self.tweenTimer then 
			LuaTimerManager.Instance:RemoveTimer(self.tweenTimer)
			self.tweenTimer = nil
		end
	end

	self.mapSequence = DOTween.Sequence()
	self.miniMapScale = changeScale
	self.miniMapMarkScale = self.defaultMiniMarkScale / self.miniMapScale
	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local position = entity.transformComponent.position
	local mapId = Fight.Instance:GetFightMap()
	local width, height = mod.WorldMapCtrl:TransWorldPosToUIPos(position.x, position.z, mapId)
	self:RefreshTraceMark(width, height)
	width = width * self.miniMapScale --* self.defaultMiniMarkScale
	height = height * self.miniMapScale --* self.defaultMiniMarkScale

	local tween1 = self.MapContent.transform:DOScale(self.miniMapScale, 0.5)
	local tween2 = self.MapContent.transform:DOLocalMove(Vector3(-width, -height, 0), 0.5)
	local marksTween = {}
	for _, v in pairs(self.marksOnShow) do
		--由于路线的mark是linerender，所以不需要缩放
		if v.config and (v.config.type == FightEnum.MapMarkType.RoadPath or v.config.type == FightEnum.MapMarkType.NavMeshPath) then
			goto continue
		end 
		table.insert(marksTween, v.obj.objectTransform:DOScale(self.miniMapMarkScale, 0.5))
		::continue::
	end

	for _, v in pairs(self.traceMark) do
		table.insert(marksTween, v.objectTransform:DOScale(self.miniMapMarkScale, 0.5))
	end

	self.mapSequence:Append(tween1)
	self.mapSequence:Join(tween2)
	for _, v in pairs(marksTween) do
		self.mapSequence:Join(v)
	end

	local timerFunc = function()
		if self.mapSequence then
			self.mapSequence:Kill()
			self.mapSequence = nil
		end
		if self.tweenTimer then 
			LuaTimerManager.Instance:RemoveTimer(self.tweenTimer)
			self.tweenTimer = nil
		end
		if self.MapContent.transform.localScale.x ~= self.miniMapScale then 
			self.waitUpdateScale = true
		end
	end
	self.tweenTimer = LuaTimerManager.Instance:AddTimer(1, 1, timerFunc)
end

--#region 获取动态加载item

function FightSystemPanel:GetTraceObj()
	if next(self.traceMarkPool) then
		return table.remove(self.traceMarkPool)
	end

    local obj = self:PopUITmpObject("TraceTemp")

    obj.objectTransform:SetParent(self.MapContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, self.miniMapMarkScale * 1.5, self.miniMapMarkScale * 1.5, self.miniMapMarkScale * 1.5)
	UtilsUI.SetEffectSortingOrder(obj["21030"], self.canvas.sortingOrder)

    return obj
end

function FightSystemPanel:GetMarkObj(mark)
	if next(self.markPool) then
		local commonMark = table.remove(self.markPool)
		commonMark:InitMapMark(mark, self.miniMapMarkScale, self:ToFunc("RemoveMarkCallBack"), 1 / self.defaultMiniMapScale)
		UnityUtils.SetActive(commonMark.obj.object, true)
		return commonMark
	end

	local parent = self.CommonMark.transform
	if mark.type == FightEnum.MapMarkType.Ecosystem then
		local isTransport = Fight.Instance.entityManager.ecosystemEntityManager:CheckEcoEntityType(mark.ecoCfg.id, FightEnum.EcoEntityType.Transport)
        if isTransport then
            local transportCfg = Config.DataMap.data_map_transport[mark.ecoCfg.id]
			if not transportCfg then
				LogError("缺少配置，配置id = "..mark.ecoCfg.id)
			end
            if (transportCfg and transportCfg.mid_area ~= 0) or mod.WorldCtrl:CheckIsTransportPointActive(mark.ecoCfg.id) then
                parent = self.TransportMark.transform
            end
        end
	elseif mark.type == FightEnum.MapMarkType.Task then
		parent = self.TaskMark.transform
	end

	local commonMark = CommonMapMark.New(self:PopUITmpObject("CommonMapMark"), parent, self.miniMapMarkScale, self.canvas.sortingOrder,nil,true)
	commonMark:InitMapMark(mark, self.miniMapMarkScale, self:ToFunc("RemoveMarkCallBack"), self.miniMapMarkScale)
	UnityUtils.SetActive(commonMark.obj.object, true)

	return commonMark
end
--#endregion

---comment
---@param refreshType number 刷新小地图类型(刷新，添加，移除)
---@param mark any 对应的标记
function FightSystemPanel:RefreshMiniMapMark(refreshType, mark)
	if refreshType == WorldEnum.MarkOpera.Add then
		self:AddMark(mark)
	elseif refreshType == WorldEnum.MarkOpera.Refresh then
		self:RefreshMark(mark)
	elseif refreshType == WorldEnum.MarkOpera.Remove then
		self:RemoveMark(mark)
	end
end
--#endregion

function FightSystemPanel:GetInCar()
	--缩放小地图
	self:RefreshMapScale(CarDriveMapScale * 0.01 * self.defaultScaleChangeTime)
end

function FightSystemPanel:GetOffCar()
	--还原
	self:RefreshMapScale(self.defaultScaleChangeTime)
end

-- 显示关卡区域占用
function FightSystemPanel:ShowLevelOnMap(levelId, isShow)
	if (not self.areaOnShow[levelId]) ~= isShow then
		return
	end

    if not isShow then
		self:RemoveLevelOnMap(levelId)
		return
    end

    self:SetSingleLevelOnMap(levelId)
end

function FightSystemPanel:ChangeLevelOnMapScale()
	if not self.areaOnShow or not next(self.areaOnShow) then
		return
	end

	for k, v in pairs(self.areaOnShow) do
		self:SetSingleLevelOnMap(k)
	end
end

function FightSystemPanel:SetSingleLevelOnMap(levelId)
	local bounds = Fight.Instance.levelManager:GetLevelOccupancyData(levelId)
	local mapId = Fight.Instance:GetFightMap()
    if not bounds or not next(bounds) then
        return
    end

	-- local markScale = 1 / self.miniMapMarkScale
	local pointList = {}
	for i = 1, #bounds do
		local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(bounds[i].x, bounds[i].y, mapId)
		-- posX = posX / markScale
		-- posY = posY / markScale
		table.insert(pointList, Vec3.New(posX, posY, 0))
	end

	local areaObj = self.areaOnShow[levelId] and self.areaOnShow[levelId] or self:GetAreaObj()
	local first = 1
	for i = 1, #pointList do
		if pointList[i].x < pointList[first].x then
			first = i
			goto continue
		end

		if pointList[i].x == pointList[first].x and pointList[i].y < pointList[first].y then
			first = i
		end

		::continue::
	end

	local firstPoint = pointList[first]
	areaObj.polygon:SetFirst(pointList[first])
	table.remove(pointList, first)

	local angleList = {}
	for i = 1, #pointList do
		local angle = Vec3.Angle(Vec3.up, pointList[i] - firstPoint)
		angleList[i] = { angle = angle, key = i }
	end
	table.sort(angleList, function (a, b)
		return a.angle < b.angle
	end)
	areaObj.polygon:SetArrayNum(#pointList)

	for i = 1, #angleList do
		areaObj.polygon.v2Arr[i - 1] = pointList[angleList[i].key]
	end

	if not self.areaOnShow[levelId] then
		areaObj.obj.objectTransform:SetParent(self.MapAreaShow.transform)
		UnityUtils.SetLocalScale(areaObj.obj.objectTransform, 1, 1, 1)
		UnityUtils.SetLocalPosition(areaObj.obj.objectTransform, 0, 0, 0)
		UnityUtils.SetActive(areaObj.obj.object, true)
		self.areaOnShow[levelId] = areaObj
	end
end

function FightSystemPanel:RemoveLevelOnMap(levelId)
	local areaObj = self.areaOnShow[levelId]
	areaObj.polygon:ResetVert()
	UnityUtils.SetActive(areaObj.obj.object, false)
	table.insert(self.areaObjPool, areaObj)
	self.areaOnShow[levelId] = nil
end

function FightSystemPanel:GetAreaObj()
	if next(self.areaObjPool) then
		return table.remove(self.areaObjPool)
	end

	local obj = self:PopUITmpObject("MapAreaTemp")
	local polygon = obj.object:GetComponent(UIPolygonWithVert)
	if not polygon then
		polygon = obj.object:AddComponent(UIPolygonWithVert)
	end

	return { obj = obj, polygon = polygon }
end