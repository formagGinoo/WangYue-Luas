AbilityWheelFightPanelV2 = BaseClass("AbilityWheelFightPanelV2", BasePanel)

function AbilityWheelFightPanelV2:__init()
    self:SetAsset("Prefabs/UI/AbilityWheel/AbilityWheelFightPanelV2.prefab")
end

function AbilityWheelFightPanelV2:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AbilityWheelFightPanelV2:__BindListener()
    self.AssembleButton_btn.onClick:AddListener(self:ToFunc("OnClickAssembleButton"))
end

function AbilityWheelFightPanelV2:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ChangeWheelAbility, self:ToFunc("UpdateWheel"))
    EventMgr.Instance:AddListener(EventName.AbilityWheelFightPanelClose, self:ToFunc("OnClosePanel"))
end

function AbilityWheelFightPanelV2:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeWheelAbility, self:ToFunc("UpdateWheel"))
    EventMgr.Instance:RemoveListener(EventName.AbilityWheelFightPanelClose, self:ToFunc("OnClosePanel"))
end

function AbilityWheelFightPanelV2:__Show()
    BehaviorFunctions.SetOnlyKeyInput(FightEnum.KeyEventToAction[FightEnum.KeyEvent.InPhoto], true)
    self.BlurNodeBack_img.enabled = false
    self.isQuickOutbound = self.args.isQuickOutbound
    self.CloseText_txt.text = TI18N("点击鼠标右键关闭")

    if self.isQuickOutbound then
        EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    end

    self.waitQuit = false
    self.waitBlur = true

    UtilsUI.SetActive(self.OnCloseMask, false)
end

function AbilityWheelFightPanelV2:__Hide()
    if self.isQuickOutbound then
        EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    end
    EventMgr.Instance:Fire(EventName.ShowCursor, false)
end

function AbilityWheelFightPanelV2:__ShowComplete()
    self.skillGoContList = {}
    self.skillActiveLinkItemList = {}
    self.skillWheelActiveItemContList = {}
    self.skillPassiveLinkItemList = {}
    self.skillWheelPassiveItemContList = {}
    self.curSelectIndex = nil
    self:InitWheel()
    self:InitBlur()
    EventMgr.Instance:Fire(EventName.ShowCursor, true)
end

function AbilityWheelFightPanelV2:InitBlur()
    local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 4, bindNode = self.BlurNodeBack }
    self.blurBack = BlurBack.New(self, setting)
    self.blurBack:Show({self:ToFunc("BlurBackCallBack")})
end

function AbilityWheelFightPanelV2:BlurBackCallBack()
    self.blurBack.blurRawImage.material = self.BlurNodeBack_img.material
    self.blurBack.AniRt:AddComponent(CS.Coffee.UISoftMask.SoftMaskable)
    self.blurBack.Rt:AddComponent(CS.Coffee.UISoftMask.SoftMaskable)
    self.blurBack.SceneRt:AddComponent(CS.Coffee.UISoftMask.SoftMaskable)
    self.blurBack.AniSceneRt:AddComponent(CS.Coffee.UISoftMask.SoftMaskable)
    self.BlurNodeBack_img.enabled = true

    self.CloseBackButton_drag.onPointerClick = self:ToFunc("OnClickCloseBackButton")

    self.waitBlur = false
    if self.waitQuit then
        self:OnActionInputEnd(FightEnum.KeyEvent.InPhoto)
    elseif self.isQuickOutbound then
        local frame = Fight.Instance.operationManager:GetKeyPressFrame(FightEnum.KeyEvent.InPhoto)
        if frame == 0 then
            self:OnActionInputEnd(FightEnum.KeyEvent.InPhoto)
        end
    end
end

function AbilityWheelFightPanelV2:InitWheel()
    for i = AbilityWheelConfig.StartActiveLinkPos, AbilityWheelConfig.EndActiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local skillPathName = "ActiveSkill" .. (wheelAbilityIndex - AbilityWheelConfig.StartActiveLinkPos + 1)
        local go = self[skillPathName]
        local goCont = UtilsUI.GetContainerObject(go)
        self.skillWheelActiveItemContList[wheelAbilityIndex] = goCont

        self.skillActiveLinkItemList[wheelAbilityIndex] = SkillLinkItem.New()

        --取消选中动效结束回调
        UtilsUI.SetHideCallBack(goCont.Select_out, function ()
            UtilsUI.SetActive(goCont.Selected, false)
        end)
    end

    for i = AbilityWheelConfig.StartPassiveLinkPos, AbilityWheelConfig.EndPassiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local skillPathName = "PassiveSkill" .. (wheelAbilityIndex - AbilityWheelConfig.StartPassiveLinkPos + 1)
        local go = self[skillPathName]
        local goCont = UtilsUI.GetContainerObject(go)
        self.skillWheelPassiveItemContList[wheelAbilityIndex] = goCont

        self.skillPassiveLinkItemList[wheelAbilityIndex] = SkillLinkItem.New()
    end

    self:InitDrawHandle()
    self:UpdateWheel()
end

function AbilityWheelFightPanelV2:InitDrawHandle()
    local rootV2 = RectTransformUtility.WorldToScreenPoint(ctx.UICamera, self.WheelPointerRoot_rect.position)
    local rootX = rootV2.x
    local rootY = rootV2.y
    local rootUpY = rootY + 1
    local map = {
        [1] = { [0] = 3, [1] = 2, [2] = 1, [3] = 8 },
        [2] = { [0] = 4, [1] = 5, [2] = 6, [3] = 7 },
    }
    local mapAngle = {
        [1] = { [0] = 0, [1] = 45, [2] = 90, [3] = 135 },
        [2] = { [0] = -45, [1] = -90, [2] = -135, [3] = -180 },
    }
    local mapAngle = { 90, 45, 0, -45, -90, -135, -180, 135 }

    self.curSelectIndex = mod.AbilityWheelCtrl:GetCurSelectWheelAbilityIndex()

    if self.curSelectIndex and self.curSelectIndex > 0 then
        -- 现在有选中的技能
        UtilsUI.SetActive(self.skillWheelActiveItemContList[self.curSelectIndex].Selected, true)
        UtilsUI.SetActive(self.WheelPointer, true)
        UnityUtils.SetLocalEulerAngles(self.WheelPointer_rect, 0, 0, mapAngle[self.curSelectIndex])

        local linkId = mod.AbilityWheelCtrl:GetAbilityLinkId(self.curSelectIndex)
        local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
        self.AssembleSkillText_txt.text = abilityInfo.name
        local iconPath = mod.AbilityWheelCtrl:GetOverrideLinkIcon(linkId)
        if not iconPath then
            iconPath = abilityInfo.icon
        end
        SingleIconLoader.Load(self.AssembleSkill, iconPath, function ()
            UtilsUI.SetActive(self.AssembleSkill, true)
        end)
    else
        self.curSelectIndex = nil
        self.AssembleSkillText_txt.text = ""
        UtilsUI.SetActive(self.AssembleSkill, false)
        UtilsUI.SetActive(self.WheelPointer, false)
    end

    self.DragHandle_drag.onPointerMove = function(pointerEventData)
        local vec2 = pointerEventData.position
        local pointerX = vec2.x
        local pointerY = vec2.y
        local index = nil
        if pointerX < rootX then
            -- 鼠标在轮盘左侧
            local angle = AbilityWheelConfig.GetVector2Cross(rootX, rootY, rootX, rootUpY, pointerX, pointerY)
            index = map[1][math.floor(angle / 45)]
        else
            -- 鼠标在轮盘右侧
            local angle = AbilityWheelConfig.GetVector2Cross(rootX, rootY, rootX, rootUpY, pointerX, pointerY)
            index = map[2][math.floor(angle / 45)]
        end

        if self.curSelectIndex ~= index then
            if self.curSelectIndex then
                -- 取消选中 
                --UtilsUI.SetActive(self.skillWheelActiveItemContList[self.curSelectIndex].Selected, false)
                self.skillWheelActiveItemContList[self.curSelectIndex].Selected_anim:Play("UI_AbilityWheelFightPanel_Select_out_PC")
            end

            local nextLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(index)
            if not nextLinkId then
                self.curSelectIndex = nil
                self.AssembleSkillText_txt.text = ""
                UtilsUI.SetActive(self.AssembleSkill, false)
                UtilsUI.SetActive(self.WheelPointer, false)
                return
            end
            
            --选中
            mod.AbilityWheelCtrl:GetCurSelectWheelAbilityIndex()
            UtilsUI.SetActive(self.skillWheelActiveItemContList[index].Selected, true)
            UtilsUI.SetActive(self.WheelPointer, true)
            UnityUtils.SetLocalEulerAngles(self.WheelPointer_rect, 0, 0, mapAngle[index])
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(nextLinkId)
            self.AssembleSkillText_txt.text = abilityInfo.name
            local iconPath = mod.AbilityWheelCtrl:GetOverrideLinkIcon(nextLinkId)
            if not iconPath then
                iconPath = abilityInfo.icon
            end
            SingleIconLoader.Load(self.AssembleSkill, iconPath, function ()
                UtilsUI.SetActive(self.AssembleSkill, true)
            end)
        end

        self.curSelectIndex = index
    end

    self.DragHandle_drag.onPointerClick = function (pointerEventData)
        if pointerEventData.button == PointerEventData.InputButton.Left then
            if self.curSelectIndex then
                self:SelectCurSelectWheelAbilityIndex(true)
            end
        elseif pointerEventData.button == PointerEventData.InputButton.Right then
            self:OnClosePanel()
        end
    end
end

function AbilityWheelFightPanelV2:UpdateWheel()    
    for i = AbilityWheelConfig.StartActiveLinkPos, AbilityWheelConfig.EndActiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local skillPathName = "ActiveSkill" .. (wheelAbilityIndex - AbilityWheelConfig.StartActiveLinkPos + 1)
        local go = self[skillPathName]
        local goCont = self.skillWheelActiveItemContList[wheelAbilityIndex]

        self.skillActiveLinkItemList[wheelAbilityIndex]:InitItem(goCont.SkillLinkItem, skillLinkId)

        if skillLinkId and skillLinkId > 0 then
            go.name = string.format("ActiveSkillAbility_%d", skillLinkId)
        else
            go.name = string.format("ActiveSkilll%d_", (wheelAbilityIndex - AbilityWheelConfig.StartActiveLinkPos + 1))
        end
    end

    for i = AbilityWheelConfig.StartPassiveLinkPos, AbilityWheelConfig.EndPassiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local skillPathName = "PassiveSkill" .. (wheelAbilityIndex - AbilityWheelConfig.StartPassiveLinkPos + 1)
        local go = self[skillPathName]
        local goCont = self.skillWheelPassiveItemContList[wheelAbilityIndex]

        self.skillPassiveLinkItemList[wheelAbilityIndex]:InitItem(goCont.SkillLinkItem, skillLinkId)

        if skillLinkId and skillLinkId > 0 then
            go.name = string.format("PassiveSkillAbility_%d", skillLinkId)
        else
            go.name = string.format("PassiveSkill%d_", (wheelAbilityIndex - AbilityWheelConfig.StartPassiveLinkPos + 1))
        end
    end
end

function AbilityWheelFightPanelV2:OnClickCloseBackButton(pointerEventData)
    if pointerEventData.button == PointerEventData.InputButton.Right then
        self:OnClosePanel()
    end
end

function AbilityWheelFightPanelV2:OnClickAssembleButton()
    if self.isQuickOutbound then
        EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
        self.isQuickOutbound = false
    end
    mod.AbilityWheelCtrl:OpenAbilityWheelSetWindow(AbilityWheelEnum.WindowSelectType.Wheel)

    self:OnClosePanel()
end

function AbilityWheelFightPanelV2:OnActionInputEnd(key, value)
    if key == FightEnum.KeyEvent.InPhoto then
        if (not self.waitBlur) then
            if self.gameObject.activeSelf then
                if self.curSelectIndex then
                    self:SelectCurSelectWheelAbilityIndex(true, true)
                else
                    self:OnClosePanel()
                end
            else
                self:OnClosePanel()
            end
        else
            self.waitQuit = true
        end
    end
end

function AbilityWheelFightPanelV2:SelectCurSelectWheelAbilityIndex(isCall, isQuickOutbound)
    UtilsUI.SetActive(self.OnCloseMask, true)

    if self.curSelectIndex then
        local selectIndex = self.curSelectIndex
        self.skillWheelActiveItemContList[selectIndex].SkillLinkItem_anim:Play("UI_SkillIcon_in_PC")
        UtilsUI.SetHideCallBack(self.skillActiveLinkItemList[selectIndex].cont.out, function ()
            mod.AbilityWheelCtrl:SelectCurSelectWheelAbilityIndex(selectIndex, true, true)
        end)
    end
end

function AbilityWheelFightPanelV2:OnClosePanel()
    UtilsUI.SetActive(self.OnCloseMask, true)
    local animator = self.gameObject:GetComponent(Animator)
    animator:Play("UI_AbilityWheelFightPanelV2_out_PC")
    UtilsUI.SetHideCallBack(self.AbilityWheelFightPanel_out, function ()
        mod.AbilityWheelCtrl:CloseFightAbilityWheel()
    end)
    BehaviorFunctions.SetOnlyKeyInput(nil, false)
end