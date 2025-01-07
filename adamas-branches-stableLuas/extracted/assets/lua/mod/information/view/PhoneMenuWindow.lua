---@class PhoneMenuWindow
PhoneMenuWindow = BaseClass("PhoneMenuWindow", BaseWindow)


function PhoneMenuWindow:__init()
    self:SetAsset("Prefabs/UI/Phone/PhoneMenuWindow.prefab")
    self.isReadingMessage = false
end

function PhoneMenuWindow:__BindListener()
    --self.BgButton_btn.onClick:AddListener(self:ToFunc("Close_HideCallBack"))
    -- self.BgButton_btn.onClick:AddListener(self:ToFunc("OnClickClose"))
    self:BindCloseBtn(self.BgButton_btn)

    self.OpenGrowNoticeBtn_btn.onClick:AddListener(self:ToFunc("OnClickOpenGrowNoticeBtn"))
    EventMgr.Instance:AddListener(EventName.OpenMessageTalkPanel, self:ToFunc("OpenTalkPanel"))
    EventMgr.Instance:RemoveListener(EventName.GrowNoticeSummaryUpdate, self:ToFunc("OnGrowNoticeSummaryUpdate"))
end

function PhoneMenuWindow:__delete()
    self.isReadingMessage = nil
    self.timer = nil
    EventMgr.Instance:RemoveListener(EventName.OpenMessageTalkPanel, self:ToFunc("OpenTalkPanel"))
    EventMgr.Instance:AddListener(EventName.GrowNoticeSummaryUpdate, self:ToFunc("OnGrowNoticeSummaryUpdate"))
end

function PhoneMenuWindow:__Show()
    if self.args then
        self.panelType = self.args.PanelType
        if self.panelType == InformationConfig.PanelType.MessagePanel then
            self.messagetalkId= self.args.messageTalkId
            self.messagegroupId = self.args.Messagegroup
            self.messageId = self.args.messageId
            if self.messageId then
                self.messagetype = Config.DataMessageCome.Find[self.messageId].message_type
            end
        end
    end
    self:SetTopInfo()
end

function PhoneMenuWindow:__ShowComplete()
   CameraManager.Instance:SetInheritPosition(FightEnum.CameraState.Operating, false)
    local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    self:showBlur()
    Fight.Instance.clientFight.lifeBarManager:SetLiftBarRootVisibleState(false)
    if self:CheckNeedPlayAnimation() then--如果满足条件更改视角并播放对应动画
        Fight.Instance.entityManager:CallBehaviorFun("OnAnimEvent", player.instanceId, FightEnum.AnimEventType.RightWeaponVisible, { visible = false })
        Fight.Instance.entityManager:CallBehaviorFun("OnAnimEvent", player.instanceId, FightEnum.AnimEventType.LeftWeaponVisible, { visible = false })--关闭武器特效
        player.clientEntity.clientAnimatorComponent:PlayAnimation("Stand1", 0, 0, 0, false, true)--播放打开菜单动画
        player.clientEntity.clientAnimatorComponent:SetTimeScale(1)--自身时间不暂停
        self.isNeedPlayCloseAnimation = true
        LuaTimerManager.Instance:AddTimer(1, 0.1, function()
            BehaviorFunctions.SetCameraState(FightEnum.CameraState.UI)
            local UICameraTarget = player.clientTransformComponent:GetTransform("UICameraTarget")
            local Role = player.clientTransformComponent:GetTransform("Role")
            if UICameraTarget and Role then
                self.CameraOffset = Role.localPosition
                UICameraTarget.localPosition = UICameraTarget.localPosition + self.CameraOffset
                BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.UI]:SetMainTarget(UICameraTarget)
            end
        end)
        LuaTimerManager.Instance:AddTimer(1, 0.36, function()
            self:showWindowBody()
        end)
        LuaTimerManager.Instance:AddTimer(1, 0.93, function()
            --TODO临时处理
            player.stateComponent:SetState(FightEnum.EntityState.Idle)
            --player.clientEntity.clientAnimatorComponent:PlayAnimation("Stand1", 0, 0, 0)
        end)
    else
        self:showWindowBody()
    end
    --切换相机透视效果
    --self:ChangeCamera()

    self:OnGrowNoticeSummaryUpdate()

    -- 高斯模糊
    CustomUnityUtils.SetScreenBlur(true, 2, 2)
end

function PhoneMenuWindow:SetTopInfo()
   --local date=os.date("%H:%M")
   local hour, minute = DayNightMgr.Instance:GetStandardTime()
   self.TimeText_txt.text = string.format("%02d:%02d", hour, minute)

   local ping = "Ping:" .. mod.LoginCtrl:GetPing()
   local strs = StringHelper.Split(ping, ":")
   local value = tonumber(strs[2])
   local with
   if value>500 then
    with =3
   elseif value>200 and value<500  then
    with =7
   elseif value>100 and value<200 then
    with =10
   elseif value<100 then
    with =14
   end
   
   local container = self.PingMask_rect
   UnityUtils.SetSizeDelata(container,with , container.sizeDelta.y)
end


function PhoneMenuWindow:ChangeCamera()
    local uiCamera = ctx.UICamera
    uiCamera.orthographic = false
    uiCamera.fieldOfView  = 8
    uiCamera.nearClipPlane = 0.01
end

function PhoneMenuWindow:showWindowBody()
    self.isWindowBodyShowComplete = false
    if not self.PhoneBody then
        return
    end
    self.PhoneBody:SetActive(true)

    if  self.panelType ==  InformationConfig.PanelType.MessagePanel then
        if self.messagetype == 1 or self.messagetype ==3 then
            self:OpenTalkPanel(self.messageId,self.messagegroupId,self.messagetalkId)
        else
            self:OpenMessageMainPanel()
        end 
    elseif self.panelType ==  InformationConfig.PanelType.PhonePanel then
        self:OpenPhonePanel()
    elseif self.panelType == InformationConfig.PanelType.GrowNotice then
        self:OpenGrowNoticePanel()
    end
    
    LuaTimerManager.Instance:AddTimer(1, 0.63, function()
        self.isWindowBodyShowComplete = true
    end)
end

function PhoneMenuWindow:CheckNeedPlayAnimation()
    if BehaviorFunctions.CheckPlayerInFight() then
        return false
    end
    local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    if player.stateComponent:IsState(FightEnum.EntityState.Idle) then
        if player.stateComponent.stateFSM.statesMachine.idleFSM.curState ~= FightEnum.EntityIdleType.LeisurelyIdle then
            return false
        end
    elseif not player.stateComponent:IsState(FightEnum.EntityState.Move) and not player.stateComponent:IsState(FightEnum.EntityState.CloseMenu) then
        return false
    end
    return true
end

function PhoneMenuWindow:showBlur()
    CustomUnityUtils.SetDepthOfFieldBoken(true, 0.31, 42, 26)
end

function PhoneMenuWindow:CloseWindowAction()
    Fight.Instance.clientFight.lifeBarManager:SetLiftBarRootVisibleState(true)
    BehaviorFunctions.ShowAllHeadTips(true)
    local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    if self.isNeedPlayCloseAnimation then
        player.stateComponent:SetState(FightEnum.EntityState.CloseMenu)
        BehaviorFunctions.fight.clientFight.cameraManager.ignoreForceCameraPosition = true
        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
        self.isNeedPlayCloseAnimation = false
        local UICameraTarget = player.clientTransformComponent:GetTransform("UICameraTarget")
        if self.CameraOffset and UICameraTarget then
            UICameraTarget.localPosition = UICameraTarget.localPosition - self.CameraOffset
            self.CameraOffset = nil
        end
    end
    BehaviorFunctions.fight.clientFight.cameraManager:SetMainTarget(player.clientTransformComponent.transform)
    if self.timer then
        return
    end
    self.timer = LuaTimerManager.Instance:AddTimer(1, 0.01, function()
        if CameraManager.Instance then
            CameraManager.Instance:SetInheritPosition(FightEnum.CameraState.Operating, true)
        end
    end)
    CustomUnityUtils.SetDepthOfFieldBoken(false, 0.16, 56, 32)
    self:BackCamera()
end

function PhoneMenuWindow:BackCamera()
    local uiCamera = ctx.UICamera
    uiCamera.orthographic = true
    uiCamera.nearClipPlane = -10
end

function PhoneMenuWindow:__Hide()
    CustomUnityUtils.SetScreenBlur(false, 2, 2)
    self:CloseWindowAction()
end

function PhoneMenuWindow:__TempShow()
    self:ChangeCamera()
    self.PhoneBody:SetActive(true)
end

function PhoneMenuWindow:__TempHide()

end

function PhoneMenuWindow:__AfterExitAnim()
    if not self.isReadingMessage then
        self.PhoneBody:SetActive(false)
        WindowManager.Instance:CloseWindow(PhoneMenuWindow)
    end
end

function PhoneMenuWindow:OpenPhonePanel()
    self:OnGrowNoticeSummaryUpdate()
    self.phonePanel = self:OpenPanel(PhonePanel)
end

function PhoneMenuWindow:OpenGrowNoticePanel()
    self:CloseNewGrowNotice()
    self:OpenPanel(PhoneGrowNoticePanel, {parent = self})
end

function PhoneMenuWindow:OpenTalkPanel(messageId,groupId,talkId)--打开手机聊天界面
    self:CloseNewGrowNotice()
    local args = {
        closefunc = self:ToFunc("CloseMessageTalkPanel"),
        messageId = messageId,
        groupId = groupId,
        talkId = talkId,
    }
    self:OpenPanel(MessageTalkPanel,args)
    self:ClosePanel(MessageMainPanel)
end

function PhoneMenuWindow:OpenMessageMainPanel()
    self:CloseNewGrowNotice()
    local args = {
        closeFunc = self:ToFunc("CloseMessageMainPanel"),
        openTalkFunc = self:ToFunc("OpenTalkPanel"),
        messageId = self.messageId,
    }
    self:OpenPanel(MessageMainPanel,args)
end

function PhoneMenuWindow:CloseMessageMainPanel()
    self:ClosePanel(MessageMainPanel)
    self:OpenPhonePanel()
end

function PhoneMenuWindow:CloseMessageTalkPanel()
    self:ClosePanel(MessageTalkPanel)
    self:OpenPhonePanel()
    --self:OpenMessageMainPanel()
end

function PhoneMenuWindow:OpenOtherPanel(panel, ...)
    if self.phonePanel then
        self:ClosePanel(self.phonePanel)
        --self.phonePanel:__AfterExitAnim()
        self.phonePanel = nil
    end
    self:CloseNewGrowNotice()
    self:OpenPanel(panel, ...)
end

function PhoneMenuWindow:ReturnMenu()
    for k, v in pairs(self.panelList) do
        self:ClosePanel(v)
    end
    self:OnGrowNoticeSummaryUpdate()
    self:OpenPhonePanel()
end

function PhoneMenuWindow:OnClickOpenGrowNoticeBtn()
    self:OpenOtherPanel(PhoneGrowNoticePanel, {parent = self})
end

function PhoneMenuWindow:OnClick_CopyID()
    local uid = StringHelper.Split(self.IDContentText_txt.text,":")
    GUIUtility.systemCopyBuffer = uid[2]
    MsgBoxManager.Instance:ShowTips("复制成功")
end

function PhoneMenuWindow:OnClickClose()
    if self.isDrag then return end
    self:PlayExitAnim()
end

function PhoneMenuWindow:OnGrowNoticeSummaryUpdate()
    local num = Fight.Instance.growNoticeManager:GetNoticeNum()
    if num > 0 then
        UtilsUI.SetActive(self.NewGrowNotice, true)
        self.NewGrowNoticeText_txt.text = num
    else
        self:CloseNewGrowNotice()
    end
end

function PhoneMenuWindow:CloseNewGrowNotice()
    UtilsUI.SetActive(self.NewGrowNotice, false)
end