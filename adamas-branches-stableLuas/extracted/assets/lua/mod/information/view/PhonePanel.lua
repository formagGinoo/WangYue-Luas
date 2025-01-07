PhonePanel = BaseClass("PhonePanel", BasePanel)

local ButtonType = {
    Left = 1,
    Right = 2,
    Bottom = 3,
    Page2 = 4,
}

---@class SystemMenuButtonInfo
---@field systemOpenId number
---@field systemWindow
---@field type
---@type SystemMenuButtonInfo[]
local ButtonInfo = {}
ButtonInfo["RoleButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Role, systemWindow = RoleMainWindow, type = ButtonType.Left }       ---角色
ButtonInfo["PartnerBagButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Partner, systemWindow = PartnerBagMainWindow, type = ButtonType.Left }
--ButtonInfo["TianYueButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Rogue, systemWindow = WorldRogueMainWindow, type = ButtonType.Left }                  ---天月令牌
--ButtonInfo["AchievementButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Achievement, systemWindow = nil, type = ButtonType.Right }             ---成就
ButtonInfo["BagButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Bag, systemWindow = BagWindow, type = ButtonType.Page2 }                ---背包
ButtonInfo["FormationButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Formation, systemWindow = FormationWindowV2, type = ButtonType.Page2 }                ---编队
--ButtonInfo["PicturesButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Collection, systemWindow = nil, type = ButtonType.Right }                ---图鉴
ButtonInfo["MapButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Map, systemWindow = WorldMapWindow, type = ButtonType.Left }           ---地图
ButtonInfo["TaskButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Task, systemWindow = TaskMainWindow, type = ButtonType.Right }          ---任务
ButtonInfo["AdventureButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.MaoXian, systemWindow = AdvMainWindowV2, type = ButtonType.Page2 }                ---冒险
ButtonInfo["ActivityButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.HuoDong, systemWindow = ActivityMainWindow, type = ButtonType.Page2 }                ---活动
ButtonInfo["TeachButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Teach, systemWindow = TeachWindow, type = ButtonType.Page2 }            ---教学
--ButtonInfo["DrawButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.QiYuan, systemWindow = DrawMainWindow, type = ButtonType.Right }                ---祈愿
ButtonInfo["ShopButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.ShangCheng, systemWindow = PurchaseMainWindow, type = ButtonType.Right }                    ---商店
--ButtonInfo["PassButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.JiXing, systemWindow = nil, type = ButtonType.Right }            ---通行证
ButtonInfo["SettingButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Setting, systemWindow = GameSetWindow, type = ButtonType.Bottom }                 ---设置
ButtonInfo["EmailButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.EMail, systemWindow = MailWindow, type = ButtonType.Bottom }                   ---邮件
ButtonInfo["BillboardButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Announcement, systemWindow = AnnouncementWindow, type = ButtonType.Bottom }               ---公告
--ButtonInfo["CameraButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Photos, systemWindow = nil, type = ButtonType.Bottom }                  ---拍照
ButtonInfo["FriendButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Friend, systemWindow = FriendWindow, type = ButtonType.Bottom }                  ---好友
ButtonInfo["MessageButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Message, systemWindow = MessageWindow, type = ButtonType.Left }        --短信
--ButtonInfo["DaoTuButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Identity, systemWindow = IdentityWindow, type = ButtonType.Left }        --道途
ButtonInfo["TianYueButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.AssetCenter, systemWindow = AssetPurchaseMainWindow, type = ButtonType.Left }        --资产中心
ButtonInfo["APPStoreBtn_btn"] = { systemOpenId = SystemConfig.SystemOpenId.AppStore, systemWindow = AssetPurchaseMainWindow, type = ButtonType.Left }

local Area =
{
    "LeftTop",
    "RightTop",
    -- "LeftDown",
    -- "RightDown"
}
local BottomArea =
{
    "EmailBox",
    "BillboardBox",
    "FriendBox"
}
 
local SystemIdToRedFunc = {
    [SystemConfig.SystemOpenId.Teach] = {btnName = "TeachButton", func = "UpdateTeachRed"},
}

function PhonePanel:__init()
    self:SetAsset("Prefabs/UI/Phone/PhonePanel.prefab")
    self.isNeedPlayCloseAnimation = false
    self.isWindowBodyShowComplete = false
end

function PhonePanel:__BindListener()
    self.WorldRankInforButton_btn.onClick:AddListener(self:ToFunc("OnClick_WorldRankInfo"))
    self.OpenPlayerInfoBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerInfo"))
    self.OpenGameTimeCtrl_btn.onClick:AddListener(self:ToFunc("OnClick_OpenGameTimeCtrl"))
    self.BGButton_btn.onClick:AddListener(self:ToFunc("OnClick_CloseExtraEditorPanel"))
    self.PlayerInfoButton_btn.onClick:AddListener(self:ToFunc("OnClick_PalyerInfo"))
    self.CopyIdButtonOption_btn.onClick:AddListener(self:ToFunc("OnClick_CopyID"))
    for buttonName, buttonInfo in pairs(ButtonInfo) do
        if not self[buttonName] then
            print(buttonName)
        else
            self[buttonName].onClick:AddListener(function()
                if self.isDrag then return end
                self:onClickSystemButton(buttonInfo)
            end)
        end
    end
    
    EventMgr.Instance:AddListener(EventName.PlayerInfoUpdate, self:ToFunc("UpdatePlayerInfo"))
    EventMgr.Instance:AddListener(EventName.AdventureChange, self:ToFunc("UpdatePlayerAdventureInfo"))
    EventMgr.Instance:AddListener(EventName.ModifyPlayerInfo, self:ToFunc("onModifyPlayerInfo"))

    self:BindRedPoint(RedPointName.Task, self.TaskRed)
	self:BindRedPoint(RedPointName.Activity, self.ActivityRed)
    self:BindRedPoint(RedPointName.Adv, self.AdvRed)
    self:BindRedPoint(RedPointName.AdvLimit, self.WorldLevRed)
    self:BindRedPoint(RedPointName.Teach, self.TeachRed)
    self:BindRedPoint(RedPointName.Role, self.RoleRed)
    self:BindRedPoint(RedPointName.Announcement, self.BillboardRed)
    self:BindRedPoint(RedPointName.Mail,self.EmailRed)
    self:BindRedPoint(RedPointName.Purchase,self.ShopRed)
    self:BindRedPoint(RedPointName.Friend,self.FriendRed)
    self:BindRedPoint(RedPointName.Identity,self.IdentityRed)
    self:BindRedPoint(RedPointName.RoGue,self.TianYueRed)
    self:BindRedPoint(RedPointName.Message,self.MessageRed)

end

function PhonePanel:__delete()

    EventMgr.Instance:RemoveListener(EventName.PlayerInfoUpdate, self:ToFunc("UpdatePlayerInfo"))
    EventMgr.Instance:RemoveListener(EventName.AdventureChange, self:ToFunc("UpdatePlayerAdventureInfo"))
    EventMgr.Instance:RemoveListener(EventName.ModifyPlayerInfo, self:ToFunc("onModifyPlayerInfo"))
end

function PhonePanel:__Show()
    BehaviorFunctions.ShowAllHeadTips(false)
    self:UpdatePlayerInfo()
    self:UpdatePlayerAdventureInfo()
    self:updateButtonState()
    --self:UpdatePage(false)
    self:ShowButtonActive()
    self:UpdateTimeInfo()
    if self.args then
        local IsOpenTalkPanel = self.args.openTalkPanel
        local talkId= self.args.messageTalkId
        local groupId = self.args.Messagegroup
        self.messageId = self.args.messageId
        local type = Config.DataMessageCome.Find[self.messageId].message_type
        if IsOpenTalkPanel then
            if type == 1 or type ==3 then
                self:OpenTalkPanel(self.messageId,groupId,talkId)
            else
                self:OpenMessageMainPanel()
            end

         self.AppContentNode:SetActive(false)
        end
    end

    for _, data in pairs(SystemIdToRedFunc) do
        local func = self:ToFunc(data.func)
        if func then
            func()
        end
    end
end

function PhonePanel:__ShowComplete()
    local width = self.Content_rect.rect.width
    self.Scroll_drag.onBeginDrag = function(pointerEventData)
        self.parentWindow.isDrag = true
        self.isDrag = true
    end

    self.Scroll_drag.onEndDrag = function(pointerEventData)
        if self.Content_rect.anchoredPosition.x < self.ScrollLeft_rect.anchoredPosition.x and self.PanelContent_rect.anchoredPosition.x > -300 then
            UnityUtils.SetAnchoredPosition(self.PanelContent.transform,-width, 0)
            UnityUtils.SetAnchoredPosition(self.Content.transform,self.Content_rect.anchoredPosition.x + width, 0)
            self.PageTwo:SetActive(true)
            self.PageOne:SetActive(false)
        elseif self.Content_rect.anchoredPosition.x > self.ScrollRight_rect.anchoredPosition.x and self.PanelContent_rect.anchoredPosition.x <= -300 then
            UnityUtils.SetAnchoredPosition(self.PanelContent.transform,0, 0)
            UnityUtils.SetAnchoredPosition(self.Content.transform,self.Content_rect.anchoredPosition.x - width, 0)
            self.PageTwo:SetActive(false)
            self.PageOne:SetActive(true)
        end
        
        LuaTimerManager.Instance:AddTimerByNextFrame(1,0,function()
            self.parentWindow.isDrag = false
            self.isDrag = false
        end)
    end
end

function PhonePanel:__Hide()

end

function PhonePanel:__TempShow()

end

function PhonePanel:UpdateTimeInfo()
    local _,_,time = DayNightMgr.Instance:GetStandardTime()
    local config = SystemConfig.GetTimeConfig(time)
    self.TimeDesc_txt.text = config.text
    SingleIconLoader.Load(self.TimeIcon,config.icon)
end

function PhonePanel:ShowButtonActive()
    for buttonName, buttonInfo in pairs(ButtonInfo) do
        local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(buttonInfo.systemOpenId)
        if not isOpen then
            --界面lefg显示加载中，界面right直接隐藏
            local nodename = StringHelper.Split(buttonName, "_")
           if buttonInfo.type == ButtonType.Left then
            --self:HideButton(self[nodename[1]])
           elseif buttonInfo.type == ButtonType.Page2 then
            self[nodename[1]]:SetActive(false)
           elseif buttonInfo.type == ButtonType.Bottom then
            --self[nodename[1]]:SetActive(false)
           end
        end
    end
    self:HideArea()
    --self:HideBottomArea()
end

function PhonePanel:HideButton(Node)
    local noOpen =  Node.transform:Find("NoOpen")
    local name = Node.transform:Find("NameText")
    if noOpen and name  then
        noOpen:SetActive(true)
        name:SetActive(false)
    end
end

function PhonePanel:HideArea()
   for key, value in pairs(Area) do
    local count = self:GetChildActive(self[value].transform)
    if count == 0 then
        self[value]:SetActive(false)
    end
   end
end

-- function PhonePanel:HideBottomArea()
--     for key, value in pairs(BottomArea) do
--      local count = self:GetChildActive(self[value].transform)
--      if count == 1 then
--          self[value]:SetActive(false)
--      end
--     end
--  end

function PhonePanel:GetChildActive(parent)
    local count = 0
	for i = 1, parent.childCount do
		if parent:GetChild(i - 1).gameObject.activeSelf then
			count = count + 1
		end
	end
	return count
end

function PhonePanel:BackCamera(delayTime)
    if delayTime == 0 then
       
            local uiCamera = ctx.UICamera
            uiCamera.orthographic = true
            uiCamera.nearClipPlane = -10
            -- WindowManager.Instance:CloseWindow(PhoneMenuWindow)
    else
        local callback = function()
            if self.showTimerBar then
                LuaTimerManager.Instance:RemoveTimer(self.showTimerBar)
                self.showTimerBar = nil
            end
           
            local uiCamera = ctx.UICamera
            uiCamera.orthographic = true
            uiCamera.nearClipPlane = -10
            -- WindowManager.Instance:CloseWindow(PhoneMenuWindow)
            end
            if self.showTimerBar then
                LuaTimerManager.Instance:RemoveTimer(self.showTimerBar)
                self.showTimerBar = nil
            end
        self.showTimerBar = LuaTimerManager.Instance:AddTimer(1, delayTime, callback)
    end

end

function PhonePanel:UpdatePlayerInfo(data)
    local info = data
    if not info then
        info = mod.InformationCtrl:GetPlayerInfo()
    end
    self.playerinfo = info
    if info.nick_name then
        self.PlayerNameText_txt.text = info.nick_name
    end

    if info.uid then
        local uid = string.format("UID:%s",info.uid)
        self.IDContentText_txt.text = uid
    end

    if info.avatar_id and RoleConfig.HeroBaseInfo[info.avatar_id] then
        local path = RoleConfig.HeroBaseInfo[info.avatar_id].chead_icon
        SingleIconLoader.Load(self.HeadIcon1, path)
    end
    if info.frame_id and Config.DataFrame.Find[info.frame_id] then
        local framePath = Config.DataFrame.Find[info.frame_id].icon
        SingleIconLoader.Load(self.HeadIconFrame1,framePath)
    end
    if self.hadModifyPlayerInfo then
        MsgBoxManager.Instance:ShowTips(TI18N("修改成功"))
        self.hadModifyPlayerInfo = false
    end
end

function PhonePanel:onModifyPlayerInfo()
    self.hadModifyPlayerInfo = true
end


function PhonePanel:UpdatePlayerAdventureInfo()
    if not self.active then
        return
    end
    
    local info = mod.WorldLevelCtrl:GetAdventureInfo()
    self.AdventureRankText_txt.text = TI18N("探索等级") 
    self.AdventureRankLv_txt.text = info.lev

    self.WorldRankText01_txt.text = TI18N("世界等级")
    self.WorldRankLv_txt.text = mod.WorldLevelCtrl:GetWorldLevel()

    local WprldRankIsOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.WorldLevel)
    if not WprldRankIsOpen then
        self.WorldBox:SetActive(false)
    else
        self.WorldBox:SetActive(true)
        self.WorldRankText02_txt.text = string.format( "%d",mod.WorldLevelCtrl:GetWorldLevel()) --世界等级
    end
    
    local DailyActiveIsOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.DailyActive)
    if not DailyActiveIsOpen then
        self.ActiveBox:SetActive(false)
    else
        self.ActiveBox:SetActive(true)
        local Activityinfo = mod.DailyActivityCtrl:GetInfo() --活跃度信息
        if Activityinfo then
        local maxProgress = DailyActivityConfig.GetMaxActivation(Activityinfo.control_id)
        self.ActivityValueText_txt.text = string.format( "%d/%d",Activityinfo.value,maxProgress) --活跃度
        end
    end

    local ResDuplicateIsOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ResDuplicate) --体力
    if not ResDuplicateIsOpen then
        self.PowerBox:SetActive(false)
    else
        self.PowerBox:SetActive(true)
        local strength, maxStrength = mod.BagCtrl:GetStrengthData()
        self.PowerText_txt.text =string.format( "%d/%d",strength,maxStrength) --体力
    end

    local ChallengeLevelIsOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Nightmare) --梦魇终战
    if not ChallengeLevelIsOpen then
        self.ChallengeBox:SetActive(false)
    else
        self.ChallengeBox:SetActive(true)
        --TODO暂时没有此功能先给个默认值
        self.ChallengeLevelText_txt.text = "1层/6层"
    end
    self.ExploreText_txt.text = string.format(TI18N("%s/%s"),info.exp, InformationConfig.AdventureConfig[info.lev].limit_exp)--经验
end

---@param button SystemMenuButtonInfo
function PhonePanel:onClickSystemButton(button)
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(button.systemOpenId)
    if not isOpen then
        if MsgBoxManager.Instance.tips.active == false then
            MsgBoxManager.Instance:ShowTips(failDesc)
        end
        return
    end

    if button.systemWindow then
        --WindowManager.Instance:TempHideWindow(PhoneMenuWindow)
        if button.systemOpenId == 101 then
            RoleMainWindow.OpenWindow(mod.RoleCtrl:GetCurUseRole())
        elseif button.systemOpenId == SystemConfig.SystemOpenId.Partner then
            PartnerBagMainWindow.OpenWindow()
        elseif button.systemOpenId == SystemConfig.SystemOpenId.Formation then
            if BehaviorFunctions.CheckPlayerInFight() then
                MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
                WindowManager.Instance:CloseWindow(PhoneMenuWindow)
                return
            end
            local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
            for i = 1, #FormationConfig.FormationState, 1 do
                if entity.stateComponent:IsState(FormationConfig.FormationState[i]) then
                    break
                end
                if i == #FormationConfig.FormationState then
                    MsgBoxManager.Instance:ShowTips(TI18N("当前无法操作"))
                    WindowManager.Instance:CloseWindow(PhoneMenuWindow)
                    return
                end
            end
            FormationWindowV2.OpenWindow()
        elseif button.systemOpenId == SystemConfig.SystemOpenId.Announcement then
            if not mod.AnnouncementCtrl:OpenAnnouncementWindow() then 
                return
            end

        elseif button.systemOpenId == SystemConfig.SystemOpenId.QiYuan then
            mod.DrawCtrl:OpenDrawWindow()
        elseif button.systemOpenId == SystemConfig.SystemOpenId.HuoDong then
            if mod.ActivityCtrl:CheckHasActivityPlaying() then
                WindowManager.Instance:OpenWindow(button.systemWindow)
            else
                MsgBoxManager.Instance:ShowTips(TI18N("暂无开启中的活动"))
            end
        elseif button.systemOpenId == SystemConfig.SystemOpenId.Identity then
            IdentityWindow.OpenWindow()
        elseif button.systemOpenId == SystemConfig.SystemOpenId.AssetCenter then
            WindowManager.Instance:OpenWindow(AssetPurchaseMainWindow,{})
            --WindowManager.Instance:CloseWindow(PhoneMenuWindow)
            return
        else
            WindowManager.Instance:OpenWindow(button.systemWindow)
        end
        
        self:BackCamera(0)
        CustomUnityUtils.SetDepthOfFieldBoken(false, 0.16, 56, 32)
        self.parentWindow:SetActive(false)
    else
        MsgBoxManager.Instance:ShowTips(TI18N("敬请期待"))
    end
end

function PhonePanel:CloseWindowAction()
    BehaviorFunctions.SetAllEntityLifeBarVisibleType(1)
    BehaviorFunctions.ShowAllHeadTips(true)
    local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    BehaviorFunctions.fight.clientFight.cameraManager:SetMainTarget(player.clientTransformComponent.transform)
    LuaTimerManager.Instance:AddTimer(1, 0.01, function()
        if CameraManager.Instance then
            CameraManager.Instance:SetInheritPosition(FightEnum.CameraState.Operating, true)
        end
    end)
    CustomUnityUtils.SetDepthOfFieldBoken(false, 0.16, 56, 32)
end

function PhonePanel:updateButtonState()
    -- for buttonName, buttonInfo in pairs(ButtonInfo) do
    --     local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(buttonInfo.systemOpenId)
    --     local Contents = self[buttonName].transform:Find("Contents")
    --     if buttonInfo.type == ButtonType.Center then
    --         if Contents then
    --             local lock = Contents.transform:Find("Lock")
    --             if lock then
    --                 lock:SetActive(not isOpen)
    --             end
    --             local icon = Contents.transform:Find("Icon")
    --             if icon then
    --                 CustomUnityUtils.SetImageColor(icon.gameObject:GetComponent(Image), 1, 1, 1, isOpen and 1 or 0.6)
    --             end
    --         end
    --     elseif buttonInfo.type == ButtonType.Bottom then
    --     end
    -- end
end

function PhonePanel:UpdatePage(IsRight)
    
end

function PhonePanel:OnClick_WorldRankInfo()
    if self.isDrag then return end
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.WorldLevel)
    if not isOpen then
        MsgBoxManager.Instance:ShowTips(failDesc)
        return
    end
    self:BackCamera(0)
    WindowManager.Instance:OpenWindow(AdvMainWindowV2, {type = SystemConfig.AdventurePanelType.WorldLevel, showCallback = function ()
        if RedPointMgr.Instance:GetRedPointState(RedPointName.AdvLimit) then
            RedPointMgr.Instance:RemoveRedInfo(RedPointName.AdvLimit)
            BehaviorFunctions.ShowGuideImageTips(WorldLevelConfig.GetTeachId())
        end
    end})
end

function PhonePanel:OnClick_OpenPlayerInfo()
    if self.isDrag then return end
    self.PlayerInfoEditorPanel:SetActive(true)
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PlayerInfo)
    UtilsUI.SetActive(self.PlayerInfoButton,isOpen)
end

function PhonePanel:OnClick_OpenGameTimeCtrl()
    if self.isDrag then return end
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.DayNight)
    if isOpen then
        self.parentWindow:OpenOtherPanel(GameTimePanel)
    else
        MsgBoxManager.Instance:ShowTips(failDesc)
    end
end

function PhonePanel:OnClick_CloseExtraEditorPanel()
    self.PlayerInfoEditorPanel:SetActive(false)
end

function PhonePanel:OnClick_PalyerInfo()
    self:BackCamera(0.2)
    self.PlayerInfoEditorPanel:SetActive(false)
    WindowManager.Instance:OpenWindow(PlayerInfoWindow,{uid = mod.InformationCtrl:GetPlayerInfo().uid})
end

function PhonePanel:OnClick_CopyID()
    self.PlayerInfoEditorPanel:SetActive(false)
    local uid = StringHelper.Split(self.IDContentText_txt.text,":")
    GUIUtility.systemCopyBuffer = uid[2]
    MsgBoxManager.Instance:ShowTips("复制成功")
end

function PhonePanel:OnClick_MessagePanel() 
    if self.isDrag then return end
    WindowManager.Instance:OpenWindow(MessageWindow)   -- 打开短信主界面 
    PanelManager.Instance:ClosePanel(PhonePanel,0)
    self:BackCamera(0.2)
end

function PhonePanel:UpdateTeachRed()

    local funcData = SystemIdToRedFunc[SystemConfig.SystemOpenId.Teach]
    local btnName = funcData.btnName
    local btnObj = self[btnName]
    if not btnObj then return end
    local redObj = btnObj.transform:Find("Red")
    self:BindRedPoint(RedPointName.Teach,redObj)
end

