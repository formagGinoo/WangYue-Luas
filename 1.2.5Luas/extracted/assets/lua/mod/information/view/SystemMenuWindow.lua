---@class SystemMenuWindow
SystemMenuWindow = BaseClass("SystemMenuWindow", BaseWindow)

local ButtonType = {
    Center = 1,
    Bottom = 2
}

---@class SystemMenuButtonInfo
---@field systemOpenId number
---@field systemWindow
---@field type
---@type SystemMenuButtonInfo[]
local ButtonInfo = {}
ButtonInfo["RoleButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Role, systemWindow = RoleMainWindow, type = ButtonType.Center }       ---角色
ButtonInfo["ZhongMoButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Partner, systemWindow = nil, type = ButtonType.Center }                  ---佩从
ButtonInfo["AchievementButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Achievement, systemWindow = nil, type = ButtonType.Center }             ---成就
ButtonInfo["BagButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Bag, systemWindow = BagWindow, type = ButtonType.Center }                ---背包
ButtonInfo["FormationButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Formation, systemWindow = FormationWindowV2, type = ButtonType.Center }                ---编队
ButtonInfo["HandBookButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Collection, systemWindow = nil, type = ButtonType.Center }                ---图鉴
ButtonInfo["MapButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Map, systemWindow = WorldMapWindow, type = ButtonType.Center }           ---地图
ButtonInfo["TaskButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Task, systemWindow = TaskMainWindow, type = ButtonType.Center }          ---任务
ButtonInfo["AdventureButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.MaoXian, systemWindow = AdvMainWindowV2, type = ButtonType.Center }                ---冒险
ButtonInfo["GuideButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Teach, systemWindow = TeachWindow, type = ButtonType.Center }                    ---指南
ButtonInfo["ActivityButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.HuoDong, systemWindow = nil, type = ButtonType.Center }                ---活动
ButtonInfo["GashaponButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.QiYuan, systemWindow = nil, type = ButtonType.Center }                ---祈愿
ButtonInfo["ShopButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.ShangCheng, systemWindow = nil, type = ButtonType.Center }                    ---商店
ButtonInfo["BigMonthCardButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.JiXing, systemWindow = nil, type = ButtonType.Center }            ---大月卡
ButtonInfo["SettingButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Setting, systemWindow = nil, type = ButtonType.Bottom }                 ---设置
ButtonInfo["EmailButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.EMail, systemWindow = nil, type = ButtonType.Bottom }                   ---邮件
ButtonInfo["BillboardButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Announcement, systemWindow = nil, type = ButtonType.Bottom }               ---公告
ButtonInfo["CameraButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Photos, systemWindow = nil, type = ButtonType.Bottom }                  ---拍照
ButtonInfo["FriendButton_btn"] = { systemOpenId = SystemConfig.SystemOpenId.Friend, systemWindow = nil, type = ButtonType.Bottom }                  ---好友


local SystemIdToRedFunc = {
    [SystemConfig.SystemOpenId.Teach] = {btnName = "GuideButton", func = "UpdateTeachRed"},
}

function SystemMenuWindow:__init()
    self:SetAsset("Prefabs/UI/SystemMenu/SystemMenuWindow.prefab")
    self.isNeedPlayCloseAnimation = false
    self.isWindowBodyShowComplete = false
end

function SystemMenuWindow:__BindListener()
    self:SetHideNode("SystemMenuWindowHideNode")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))

    self.OpenExtraEditorButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenExtraEditorPanel"))
    self.BGButton_btn.onClick:AddListener(self:ToFunc("OnClick_CloseExtraEditorPanel"))
    self.ChangeNameButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerNameEditorPanel"))
    self.ChangeSignatureButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerSignatureEditorPanel"))
    self.ChangeHeadImageButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerHeadImageEditorPanel"))
    self.CopyIdButtonOption_btn.onClick:AddListener(self:ToFunc("OnClick_CopyID"))
    self.UIDCopyButton_btn.onClick:AddListener(self:ToFunc("OnClick_CopyID"))
    self.SystemMenuWindowHideNode_hcb.HideAction:AddListener(self:ToFunc("Close_HideCallBack"))

    self.WorldRankInfoButton_btn.onClick:AddListener(self:ToFunc("OnClick_WorldRankInfo"))

    for buttonName, buttonInfo in pairs(ButtonInfo) do
        self[buttonName].onClick:AddListener(function()
            self:onClickSystemButton(buttonInfo)
        end)
    end

    EventMgr.Instance:AddListener(EventName.PlayerInfoUpdate, self:ToFunc("UpdatePlayerInfo"))
    EventMgr.Instance:AddListener(EventName.AdventureChange, self:ToFunc("UpdatePlayerAdventureInfo"))
    EventMgr.Instance:AddListener(EventName.ModifyPlayerInfo, self:ToFunc("onModifyPlayerInfo"))
    EventMgr.Instance:AddListener(EventName.UpdateSystemMenuRed, self:ToFunc("UpdateRed"))

    self:BindRedPoint(RedPointName.Adv, self.AdvRed)
    self:BindRedPoint(RedPointName.AdvLimit, self.WorldLevRed)
    self:BindRedPoint(RedPointName.Teach, self.TeachRed)
    self:BindRedPoint(RedPointName.Role, self.RoleRed)
    --self:UpdateTeachRed()
end

function SystemMenuWindow:__delete()
	self:CloseWindowAction()

    EventMgr.Instance:RemoveListener(EventName.PlayerInfoUpdate, self:ToFunc("UpdatePlayerInfo"))
    EventMgr.Instance:RemoveListener(EventName.AdventureChange, self:ToFunc("UpdatePlayerAdventureInfo"))
    EventMgr.Instance:RemoveListener(EventName.ModifyPlayerInfo, self:ToFunc("onModifyPlayerInfo"))
    EventMgr.Instance:RemoveListener(EventName.UpdateSystemMenuRed, self:ToFunc("UpdateRed"))
end

function SystemMenuWindow:__Show()
    BehaviorFunctions.ShowAllHeadTips(false)
    self:UpdatePlayerInfo()
    self:UpdatePlayerAdventureInfo()
    self:updateButtonState()


    for _, data in pairs(SystemIdToRedFunc) do
        local func = self:ToFunc(data.func)
        if func then
            func()
        end
    end
end

function SystemMenuWindow:__ShowComplete()
    CameraManager.Instance:SetInheritPosition(FightEnum.CameraState.Operating, false)
    local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    self:showBlur()
    BehaviorFunctions.SetAllEntityLifeBarVisibleType(3)
    if self:CheckNeedPlayAnimation() then
        Fight.Instance.entityManager:CallBehaviorFun("OnAnimEvent", player.instanceId, FightEnum.AnimEventType.RightWeaponVisible, { visible = false })
        Fight.Instance.entityManager:CallBehaviorFun("OnAnimEvent", player.instanceId, FightEnum.AnimEventType.LeftWeaponVisible, { visible = false })
        player.clientEntity.clientAnimatorComponent:PlayAnimation("MenuOpen", 0, 0, 0)
        player.clientEntity.clientAnimatorComponent:SetTimeScale(1)
        self.isNeedPlayCloseAnimation = true
        LuaTimerManager.Instance:AddTimer(1, 0.1, function()
            BehaviorFunctions.SetCameraState(FightEnum.CameraState.UI)
            local UICameraTarget = player.clientEntity.clientTransformComponent:GetTransform("UICameraTarget")
            local Role = player.clientEntity.clientTransformComponent:GetTransform("Role")
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
            player.clientEntity.clientAnimatorComponent:PlayAnimation("MenuIdle", 0, 0, 0)
        end)
    else
        self:showWindowBody()
    end
end

function SystemMenuWindow:__Hide()
    self:CloseWindowAction()
end

function SystemMenuWindow:__TempShow()

end

function SystemMenuWindow:showWindowBody()
    self.isWindowBodyShowComplete = false
    if not self.WindowBody then
        return
    end
    self.WindowBody:SetActive(true)
    self.SystemMenuWindowShowNode:SetActive(true)
    LuaTimerManager.Instance:AddTimer(1, 0.63, function()
        self.isWindowBodyShowComplete = true
    end)
end

function SystemMenuWindow:CheckNeedPlayAnimation()
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

function SystemMenuWindow:showBlur()
    CustomUnityUtils.SetDepthOfFieldBoken(true, 0.117, 42, 26)
end

function SystemMenuWindow:CloseWindowAction()
    BehaviorFunctions.SetAllEntityLifeBarVisibleType(1)
    BehaviorFunctions.ShowAllHeadTips(true)
    local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    if self.isNeedPlayCloseAnimation then
        player.stateComponent:SetState(FightEnum.EntityState.CloseMenu)
        BehaviorFunctions.fight.clientFight.cameraManager.ignoreForceCameraPosition = true
        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
        self.isNeedPlayCloseAnimation = false
        local UICameraTarget = player.clientEntity.clientTransformComponent:GetTransform("UICameraTarget")
        if self.CameraOffset and UICameraTarget then
            UICameraTarget.localPosition = UICameraTarget.localPosition - self.CameraOffset
            self.CameraOffset = nil
        end
    end
    BehaviorFunctions.fight.clientFight.cameraManager:SetMainTarget(player.clientEntity.clientTransformComponent.transform)

    LuaTimerManager.Instance:AddTimer(1, 0.01, function()
        CameraManager.Instance:SetInheritPosition(FightEnum.CameraState.Operating, true)
    end)

    CustomUnityUtils.SetDepthOfFieldBoken(false, 0.16, 56, 32)
end

function SystemMenuWindow:UpdatePlayerInfo(data)
    local info = data
    if not info then
        info = mod.InformationCtrl:GetPlayerInfo()
    end
    if info.nick_name then
        self.PlayerNameText_txt.text = info.nick_name
    end
    if info.signature and info.signature ~= "" then
        --self.SignatureText_txt.text = info.signature
    end
    if info.uid then
        local uid = tostring(info.uid)
        if #uid then
            self.IDContentText_txt.text = string.sub(uid, 1, 8)
        else
            self.IDContentText_txt.text = uid
        end
    end
    if info.photo_id and RoleConfig.HeroBaseInfo[info.photo_id] then
        local path = RoleConfig.HeroBaseInfo[info.photo_id].shead_icon
        SingleIconLoader.Load(self.HeadImage, path)
    end
    if self.hadModifyPlayerInfo then
        MsgBoxManager.Instance:ShowTips(TI18N("修改成功"))
        self.hadModifyPlayerInfo = false
    end
end

function SystemMenuWindow:onModifyPlayerInfo()
    self.hadModifyPlayerInfo = true
end

function SystemMenuWindow:UpdatePlayerAdventureInfo()
    if not self.active then
        return
    end

    local info = mod.WorldLevelCtrl:GetAdventureInfo()
    self.AdventureRankText_txt.text = info.lev
    self.WorldRankText_txt.text = mod.WorldLevelCtrl:GetWorldLevel()
    self.ExploreText_txt.text = info.exp .. "/" .. InformationConfig.AdventureConfig[info.lev].limit_exp
    self.ExploreValueBar_img.fillAmount = info.exp / InformationConfig.AdventureConfig[info.lev].limit_exp
end

---@param button SystemMenuButtonInfo
function SystemMenuWindow:onClickSystemButton(button)
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(button.systemOpenId)
    if not isOpen then
        MsgBoxManager.Instance:ShowTips(failDesc)
        return
    end

    if button.systemWindow then
        if button.systemOpenId == 101 then
            RoleMainWindow.OpenWindow(mod.RoleCtrl:GetCurUseRole())
        elseif button.systemOpenId == SystemConfig.SystemOpenId.Formation then
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
            FormationWindowV2.OpenWindow()
        else
            WindowManager.Instance:OpenWindow(button.systemWindow)
        end
    else
        MsgBoxManager.Instance:ShowTips(TI18N("敬请期待"))
    end
end

function SystemMenuWindow:updateButtonState()
    for buttonName, buttonInfo in pairs(ButtonInfo) do
        local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(buttonInfo.systemOpenId)
        local Contents = self[buttonName].transform:Find("Contents")
        if buttonInfo.type == ButtonType.Center then
            if Contents then
                local lock = Contents.transform:Find("Lock")
                if lock then
                    lock:SetActive(not isOpen)
                end
                local icon = Contents.transform:Find("Icon")
                if icon then
                    CustomUnityUtils.SetImageColor(icon.gameObject:GetComponent(Image), 1, 1, 1, isOpen and 1 or 0.6)
                end
            end
        elseif buttonInfo.type == ButtonType.Bottom then
            local childCount = self.BottomPart.transform.childCount
            local childIndex = self[buttonName].transform:GetSiblingIndex()
            self[buttonName].gameObject:SetActive(isOpen)
            if childIndex + 1 < childCount - 1 then
                self.BottomPart.transform:GetChild(childIndex + 1):SetActive(isOpen)
            end
        end
    end
end

function SystemMenuWindow:Close_HideCallBack()
    self.WindowBody:SetActive(false)
    WindowManager.Instance:CloseWindow(SystemMenuWindow)
end

function SystemMenuWindow:OnClick_OpenExtraEditorPanel()
    self.PlayerInfoEditorPanel:SetActive(true)
end

function SystemMenuWindow:OnClick_CloseExtraEditorPanel()
    self.PlayerInfoEditorPanel:SetActive(false)
end

function SystemMenuWindow:OnClick_OpenPlayerNameEditorPanel()
    self.PlayerInfoEditorPanel:SetActive(false)
    self.editorPanel = PlayerInfoEditorPanel.New(self, PlayerInfoEditorPanel.EditorView.Name)
    self.editorPanel:Show()
end

function SystemMenuWindow:OnClick_OpenPlayerSignatureEditorPanel()
    self.PlayerInfoEditorPanel:SetActive(false)
    self.editorPanel = PlayerInfoEditorPanel.New(self, PlayerInfoEditorPanel.EditorView.Signature)
    self.editorPanel:Show()
end

function SystemMenuWindow:OnClick_OpenPlayerHeadImageEditorPanel()
    self.PlayerInfoEditorPanel:SetActive(false)
    self.editorPanel = PlayerHeadImageEditorPanel.New(self)
    self.editorPanel:Show()
end

function SystemMenuWindow:OnClick_CopyID()
    GUIUtility.systemCopyBuffer = self.IDContentText_txt.text
    MsgBoxManager.Instance:ShowTips(TI18N("复制成功"))
end

function SystemMenuWindow:OnClick_WorldRankInfo()
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.WorldLevel)
    if not isOpen then
        MsgBoxManager.Instance:ShowTips(failDesc)
        return
    end
    if RedPointMgr.Instance:GetRedPointState(RedPointName.AdvLimit) then
        RedPointMgr.Instance:RemoveRedInfo(RedPointName.AdvLimit)
    end
    WindowManager.Instance:OpenWindow(AdvMainWindowV2, {type = SystemConfig.AdventurePanelType.WorldLevel, showCallback = function ()
        BehaviorFunctions.ShowGuideImageTips(WorldLevelConfig.GetTeachId())
    end})
end

function SystemMenuWindow:UpdateRed(systemId)
    -- local funcData = SystemIdToRedFunc[systemId]
    -- if not funcData then return end
    -- local funcName = funcData.func
    -- local func = self:ToFunc(funcName)
    -- func()
end

function SystemMenuWindow:UpdateTeachRed()
    --local teachMgr = Fight.Instance.teachManager
    local funcData = SystemIdToRedFunc[SystemConfig.SystemOpenId.Teach]
    local btnName = funcData.btnName
    local btnObj = self[btnName]
    if not btnObj then return end
    local redObj = btnObj.transform:Find("Red")

    --local isShow = false
    --local systemMgr = Fight.Instance.systemManager
    -- if systemMgr:CheckSystemOpen(SystemManager.TeachSystemId) then
    --     isShow = teachMgr:CheckShowTeachRed()
    -- end
    self:BindRedPoint(RedPointName.Teach,redObj)
    --redObj:SetActive(isShow)
end