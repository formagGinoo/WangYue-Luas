AbilityWheelSetWindow = BaseClass("AbilityWheelSetWindow", BaseWindow)

function AbilityWheelSetWindow:__init()
    self:SetAsset("Prefabs/UI/AbilityWheel/AbilityWheelSetWindow.prefab")

    self.SelectSkillScrollCache = {}
end

function AbilityWheelSetWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AbilityWheelSetWindow:__BindListener()
    self:BindCloseBtn(self.BackButton_btn, self:ToFunc("OnClickBackButton"))
    self.WheelSelectItemButton_btn.onClick:AddListener(self:ToFunc("OpenWheelSelectType"))
end

function AbilityWheelSetWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ChangeWheelAbility, self:ToFunc("UpdateWheel"))
end

function AbilityWheelSetWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeWheelAbility, self:ToFunc("UpdateWheel"))
end

function AbilityWheelSetWindow:__Show()
    local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 4, bindNode = self.BlurNode }
    self.blurBack = BlurBack.New(self, setting)

    self:Init()
end

function AbilityWheelSetWindow:__ShowComplete()
    self:OpenWheelSelectType()

    self.recordOnlyKey = BehaviorFunctions.GetOnlyKey()
    BehaviorFunctions.SetOnlyKeyInput(nil, false)
end

function AbilityWheelSetWindow:__Hide()
    BehaviorFunctions.SetOnlyKeyInput(self.recordOnlyKey, true)
end

function AbilityWheelSetWindow:__TempShow()
    self:Init()
end

function AbilityWheelSetWindow:Init()
    self:InitWheelSelect()
end

function AbilityWheelSetWindow:InitWheelSelect()
    self.WheelSelectCont = UtilsUI.GetContainerObject(self.WheelSelect)
    self.WheelSelect_anim = self.WheelSelect:GetComponent(Animator)

    UtilsUI.SetHideCallBack(self.WheelSelectCont.WheelSelect_out, self:ToFunc("OnWheelSelectClose"))
    
    self:UpdateWheel()

    self.WheelSelectCont.CommitAssembleButton_btn.onClick:AddListener(self:ToFunc("AssembleAbilityList"))
end

function AbilityWheelSetWindow:UpdateWheel()
    self:UpdateSelectSkillScroll()
    self:UpdateSelectWheel()
end

function AbilityWheelSetWindow:UpdateSelectSkillScroll()
    local abilityInfoList, abilityNum = AbilityWheelConfig.GetWheelAbilityList()
    local wheelSelectCont = self.WheelSelectCont
    
    self.abilityInfoList = {}
    for k, v in pairs(abilityInfoList) do
        table.insert(self.abilityInfoList, v)
    end
    table.sort(self.abilityInfoList, function (b1, b2)
        return b1.priority > b2.priority
    end)

    for k, v in pairs(self.SelectSkillScrollCache) do
        self:PushUITmpObject("SelectSkillItem", v, wheelSelectCont.SelectSkillScrollCont_rect)
    end

    TableUtils.ClearTable(self.SelectSkillScrollCache)

    for i = 1, abilityNum, 1 do
        local objectInfo = self:PopUITmpObject("SelectSkillItem", wheelSelectCont.SelectSkillScrollCont_rect)
        table.insert(self.SelectSkillScrollCache, objectInfo)
        self:SelectSkillScrollCallBack(i, objectInfo.object)
    end
end

function AbilityWheelSetWindow:UpdateSelectWheel()
    local wheelSelectCont = self.WheelSelectCont
    local hasSkill = false
    for i = AbilityWheelConfig.StartActiveLinkPos, AbilityWheelConfig.EndActiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local skillPathName = "SkillIcon" .. wheelAbilityIndex
        local skillPathNameBtn = skillPathName .. "_btn"
        wheelSelectCont[skillPathNameBtn].onClick:RemoveAllListeners()
        if skillLinkId and skillLinkId > 0 then
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(skillLinkId)
            if not abilityInfo then
                LogError(string.format("[能力轮盘] 能力id %d 没有对应的能力表", skillLinkId))
                UtilsUI.SetActive(wheelSelectCont[skillPathName], true)
            else
                SingleIconLoader.Load(wheelSelectCont[skillPathName], abilityInfo.icon, function ()
                    UtilsUI.SetActive(wheelSelectCont[skillPathName], true)
                end)
            end
            
            wheelSelectCont[skillPathNameBtn].onClick:AddListener(function ()
                self:UnAssembleAbility(wheelAbilityIndex)
            end)
            hasSkill = true
        else
            UtilsUI.SetActive(wheelSelectCont[skillPathName], false)
        end
    end
    if hasSkill then
        wheelSelectCont.WheelTipsText_txt.text = TI18N("点击能力进行装备/卸下")
    else
        wheelSelectCont.WheelTipsText_txt.text = TI18N("请选择右侧要装配的能力")
    end
end

function AbilityWheelSetWindow:SelectSkillScrollCallBack(index, go)
    local abilityInfo = self.abilityInfoList[index]
    local linkId = abilityInfo.id

    go.name = string.format("SkillAbility_%d", linkId)

    local itemCont = UtilsUI.GetContainerObject(go)

    UtilsUI.SetActive(go, true)

    SingleIconLoader.Load(itemCont.SkillIcon, abilityInfo.icon)
    itemCont.SkillName_txt.text = TI18N(abilityInfo.name)
    itemCont.SkillButton_btn.onClick:RemoveAllListeners()
    itemCont.IsLockButton_btn.onClick:RemoveAllListeners()

    --是否装配在轮盘上
    local wheelSkillIndex = mod.AbilityWheelCtrl:GetWheelAbilityIndex(linkId) 

    local isUnLock = mod.AbilityWheelCtrl:CheckLinkIsUnLock(linkId)

    if not isUnLock then
        -- 没有能力卡
        UtilsUI.SetActive(itemCont.IsLock, true)
        itemCont.IsLockButton_btn.onClick:AddListener(function ()
            MsgBoxManager.Instance:ShowTipsImmediate(TI18N("能力卡未获取"))
        end)
    else
        -- 已获取能力卡
        if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
            -- 需要配从的技能
            if not wheelSkillIndex then
                -- 未装备
                local searchPartnerUniqueId = mod.AbilityWheelCtrl:SearchBagLinkPartner(linkId)
                if searchPartnerUniqueId then
                    -- 未装备但有配从
                else
                    -- 未装备没配从
                    UtilsUI.SetActive(itemCont.IsLock, true)
                    itemCont.IsLockButton_btn.onClick:AddListener(function ()
                        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("未获取对应配从"))
                    end)
                end
            end
        end
    end

    if isUnLock then
        if wheelSkillIndex then
            --在轮盘上
            UtilsUI.SetActive(itemCont.IsSelect, true)
            itemCont.SkillButton_btn.onClick:AddListener(function ()
                self:UnAssembleAbility(wheelSkillIndex)
            end)
        else
            --不在轮盘上
            UtilsUI.SetActive(itemCont.IsSelect, false)
            itemCont.SkillButton_btn.onClick:AddListener(function ()
                self:AssembleAbility(linkId)
            end)
        end
    else
        UtilsUI.SetActive(itemCont.IsSelect, false)
    end
end

function AbilityWheelSetWindow:OnClickBackButton()
    WindowManager.Instance:CloseWindow(AbilityWheelSetWindow)
end

function AbilityWheelSetWindow:CloseCurSelectType()
    if self.curOpenSelectType then
        if self.curOpenSelectType == AbilityWheelEnum.WindowSelectType.List then
            UtilsUI.SetActive(self.PartnerSelect, false)
            UtilsUI.SetActive(self.ListSelectItemSelectIcon, false)
            UtilsUI.SetTextColor(self.ListSelectItemText_txt, "#FFFFFF")
        elseif AbilityWheelEnum.WindowSelectType.Wheel then
            self.WheelSelect_anim:Play("UI_WheelSelect_out_PC")
        else
            LogError("能力轮盘装配 未知界面类型")
        end
        self.curOpenSelectType = nil
    end
end

function AbilityWheelSetWindow:OpenPartnerSelectType()
    if self.curOpenSelectType == AbilityWheelEnum.WindowSelectType.List then
        return
    else
        self:CloseCurSelectType()
    end

    UtilsUI.SetActive(self.PartnerSelect, true)
    UtilsUI.SetActive(self.ListSelectItemSelectIcon, true)
    UtilsUI.SetTextColor(self.ListSelectItemText_txt, "#E6FF16")
    self.curOpenSelectType = AbilityWheelEnum.WindowSelectType.List
end

function AbilityWheelSetWindow:OpenWheelSelectType()
    if self.curOpenSelectType == AbilityWheelEnum.WindowSelectType.Wheel then
        return
    else
        self:CloseCurSelectType()
    end
    
    UtilsUI.SetActive(self.WheelSelect, true)
    UtilsUI.SetActive(self.WheelSelectItemSelectIcon, true)
    UtilsUI.SetTextColor(self.WheelSelectItemText_txt, "#E6FF16")
    self.WheelSelect_anim:Play("UI_WheelSelect_in_PC")

    self.curOpenSelectType = AbilityWheelEnum.WindowSelectType.Wheel

    self:UpdateWheel()
end

function AbilityWheelSetWindow:OnWheelSelectClose()
    UtilsUI.SetActive(self.WheelSelect, false)
    UtilsUI.SetActive(self.WheelSelectItemSelectIcon, false)
    UtilsUI.SetTextColor(self.WheelSelectItemText_txt, "#FFFFFF")
end

function AbilityWheelSetWindow:AssembleAbility(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)

    local index = mod.AbilityWheelCtrl:FindNullActiveWheelAbility()
    if index == nil then
        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("已达上限，请先卸下能力"))
        return
    end

    mod.AbilityWheelCtrl:AssembleAbility(index, linkId, function ()
        MsgBoxManager.Instance:ShowTipsImmediate(string.format(TI18N("%s 能力装配"), abilityInfo.name))
    end)
end

function AbilityWheelSetWindow:AssembleAbilityList()
    local NullWheelIndexList = mod.AbilityWheelCtrl:FindNullActiveWheelAbilityList()
    local residueNullWheelIndex = #NullWheelIndexList
    if residueNullWheelIndex < 1 then
        return
    end
    local startIndex = 1

    local linkList = {}
    for k, v in pairs(self.abilityInfoList) do
        if startIndex > residueNullWheelIndex then
            break
        end
        local abilityInfo = v
        local linkId = abilityInfo.id
        --是否装配在轮盘上
        local wheelSkillIndex = mod.AbilityWheelCtrl:GetWheelAbilityIndex(linkId) 
        local canAssemble = false
        if not wheelSkillIndex then
            --不在轮盘上
            local isUnLock = mod.AbilityWheelCtrl:CheckLinkIsUnLock(linkId)
            if isUnLock then
                -- 已获取能力卡
                if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
                    local searchPartnerUniqueId = mod.AbilityWheelCtrl:SearchBagLinkPartner(linkId)
                    if searchPartnerUniqueId then
                        canAssemble = true
                    end
                else
                    canAssemble = true
                end
            end
        end

        if canAssemble then
            local index = NullWheelIndexList[startIndex]
            if not index then
                break
            end
            table.insert(linkList, {index = index, skillLinkId = linkId})
            
            startIndex = startIndex + 1
        end
    end

    mod.AbilityWheelCtrl:AssembleAbilityList(linkList, function ()
        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("一键装配成功"))
    end)
end

function AbilityWheelSetWindow:UnAssembleAbility(linkId)
    local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(skillLinkId)

    mod.AbilityWheelCtrl:AssembleAbility(linkId, nil, function ()
        MsgBoxManager.Instance:ShowTipsImmediate(string.format(TI18N("%s已从列表中卸下"), abilityInfo.name))
    end)
end