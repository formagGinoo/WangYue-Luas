AbilityWheelFightPanel = BaseClass("AbilityWheelFightPanel", BasePanel)

function AbilityWheelFightPanel:__init()
    self:SetAsset("Prefabs/UI/AbilityWheel/AbilityWheelFightPanel.prefab")
end

function AbilityWheelFightPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AbilityWheelFightPanel:__BindListener()
    self.AssembleButton_btn.onClick:AddListener(self:ToFunc("OnClickAssembleButton"))
end

function AbilityWheelFightPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ChangeWheelAbility, self:ToFunc("UpdateWheel"))
    EventMgr.Instance:AddListener(EventName.AbilityWheelFightPanelClose, self:ToFunc("OnClosePanel"))
end

function AbilityWheelFightPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeWheelAbility, self:ToFunc("UpdateWheel"))
    EventMgr.Instance:RemoveListener(EventName.AbilityWheelFightPanelClose, self:ToFunc("OnClosePanel"))
end

function AbilityWheelFightPanel:__Show()
    BehaviorFunctions.SetOnlyKeyInput(FightEnum.KeyEventToAction[FightEnum.KeyEvent.InPhoto], true)
    self.BlurNodeBack_img.enabled = false
    self.tempSelectIndex = nil
    self.isQuickOutbound = self.args.isQuickOutbound
    self.CloseText_txt.text = TI18N("点击鼠标右键关闭")

    if self.isQuickOutbound then
        EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    end

    self.waitQuit = false
    self.waitBlur = true
    self.waitSelect = false

    UtilsUI.SetActive(self.OnCloseMask, false)
end

function AbilityWheelFightPanel:__Hide()
    for k, timer in pairs(self.coolTimerList) do
        LuaTimerManager.Instance:RemoveTimer(timer)
    end
    TableUtils.ClearTable(self.coolTimerList)
    if self.isQuickOutbound then
        EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    end
    EventMgr.Instance:Fire(EventName.ShowCursor, false)
end

function AbilityWheelFightPanel:__ShowComplete()
    self.skillGoContList = {}
    self.coolTimerList = {}
    self.skillWheelItemContList = {}
    self:UpdateWheel()

    self:InitBlur()
    EventMgr.Instance:Fire(EventName.ShowCursor, true)
end

function AbilityWheelFightPanel:InitBlur()
    local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 4, bindNode = self.BlurNodeBack }
    self.blurBack = BlurBack.New(self, setting)
    self.blurBack:Show({self:ToFunc("BlurBackCallBack")})
end

function AbilityWheelFightPanel:BlurBackCallBack()
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

function AbilityWheelFightPanel:UpdateWheel()
    --self.tempSelectIndex = self.tempSelectIndex or mod.AbilityWheelCtrl:GetCurSelectWheelAbilityIndex()
    
    for k, timer in pairs(self.coolTimerList) do
        LuaTimerManager.Instance:RemoveTimer(timer)
    end
    TableUtils.ClearTable(self.coolTimerList)
    TableUtils.ClearTable(self.skillWheelItemContList)
    
    for i = AbilityWheelConfig.StartActiveLinkPos, AbilityWheelConfig.EndActiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local skillPathName = "Skill" .. wheelAbilityIndex
        local go = self[skillPathName]
        local goCont
        if not self.skillGoContList[go] then
            self.skillGoContList[go] = UtilsUI.GetContainerObject(go)
        end
        goCont = self.skillGoContList[go]
        self.skillWheelItemContList[wheelAbilityIndex] = goCont
        goCont.Select_drag.onPointerEnter = nil --鼠标进入事件
        goCont.Select_drag.onPointerExit = nil --鼠标进入事件
        goCont.Select_drag.onPointerClick = nil --鼠标点击事件
        if skillLinkId and skillLinkId > 0 then
            UtilsUI.SetActive(go, true)
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(skillLinkId)
            if not abilityInfo then
                LogError(string.format("[能力轮盘] 能力id %d 没有对应的能力表", skillLinkId))
                UtilsUI.SetActive(goCont.SkillIcon, true)
            else
                SingleIconLoader.Load(goCont.SkillIcon, abilityInfo.icon, function ()
                    UtilsUI.SetActive(goCont.SkillIcon, true)
                end)
            end

            UtilsUI.SetActive(goCont.Select, false)
            UtilsUI.SetActive(goCont.UnSelect, true)

            goCont.UnSelect_drag.onPointerEnter = function ()
                goCont.UnSelect_anim:Play("UI_AbilityWheelFightPanel_Select_in_PC")
                self.tempSelectIndex = wheelAbilityIndex
                self:UpdateAssembleSkill()
            end
            goCont.UnSelect_drag.onPointerExit = function ()
                goCont.UnSelect_anim:Play("UI_AbilityWheelFightPanel_Select_out_PC")
                self.tempSelectIndex = nil
                self:UpdateAssembleSkill(true)
            end
            goCont.UnSelect_drag.onPointerClick = function (pointerEventData)
                if pointerEventData.button == PointerEventData.InputButton.Left then
                    goCont.SkillIcon_anim:Play("UI_SkillIcon_in_PC")
                    self.waitSelect = true
                    LuaTimerManager.Instance:AddTimer(1, 0.06, function ()
                        mod.AbilityWheelCtrl:SelectCurSelectWheelAbilityIndex(wheelAbilityIndex, true)
                    end)
                elseif pointerEventData.button == PointerEventData.InputButton.Right then
                    self:OnClosePanel()
                end
            end
            
            local coolTime = mod.AbilityWheelCtrl:GetCoolTime(skillLinkId)
            if coolTime > 0 then
                --有冷却时间
                goCont.CoolTimeText_txt.text = string.format("%.1f", coolTime)

                UtilsUI.SetActive(goCont.CoolTimeText, true)
                UtilsUI.SetImageColor(goCont.SkillIcon_img, "#C8C8C8")
            else
                UtilsUI.SetActive(goCont.CoolTimeText, false)
                UtilsUI.SetImageColor(goCont.SkillIcon_img, "#FFFFFF")
            end
            go.name = string.format("SkillAbility_%d", skillLinkId)
        else
            UtilsUI.SetActive(go, false)
            go.name = string.format("Skill%d_", i)
        end
    end

    self:UpdateAssembleSkill()
end

function AbilityWheelFightPanel:UpdateAssembleSkill(closeIcon)
    if closeIcon then
        UtilsUI.SetActive(self.AssembleSkill, false)
        return
    end
    if self.tempSelectIndex then
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(self.tempSelectIndex)
        if skillLinkId and skillLinkId > 0 then
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(skillLinkId)
            UtilsUI.SetActive(self.AssembleSkill, true)
            --LogInfo("设置Icon " .. abilityInfo.icon)
            SingleIconLoader.Load(self.AssembleSkill, abilityInfo.icon)
            self.AssembleSkillText_txt.text = TI18N(abilityInfo.name)
        else
            UtilsUI.SetActive(self.AssembleSkill, false)
        end
    else
        UtilsUI.SetActive(self.AssembleSkill, false)
    end
end

function AbilityWheelFightPanel:OnClickCloseBackButton(pointerEventData)
    if pointerEventData.button == PointerEventData.InputButton.Right then
        self:OnClosePanel()
    end
end

function AbilityWheelFightPanel:OnClickAssembleButton()
    mod.AbilityWheelCtrl:OpenAbilityWheelSetWindow(AbilityWheelEnum.WindowSelectType.Wheel)
end

function AbilityWheelFightPanel:OnActionInputEnd(key, value)
    if key == FightEnum.KeyEvent.InPhoto then
        if (not self.waitBlur) and (not self.waitSelect) then
            if self.gameObject.activeSelf then
                if self.tempSelectIndex then
                    mod.AbilityWheelCtrl:SelectCurSelectWheelAbilityIndex(self.tempSelectIndex, true, true)
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

function AbilityWheelFightPanel:OnClosePanel()
    UtilsUI.SetActive(self.OnCloseMask, true)
    local animator = self.gameObject:GetComponent(Animator)
    animator:Play("UI_AbilityWheelFightPanel_out_PC")
    UtilsUI.SetHideCallBack(self.AbilityWheelFightPanel_out, function ()
        mod.AbilityWheelCtrl:CloseFightAbilityWheel()
    end)
    BehaviorFunctions.SetOnlyKeyInput(nil, false)
end