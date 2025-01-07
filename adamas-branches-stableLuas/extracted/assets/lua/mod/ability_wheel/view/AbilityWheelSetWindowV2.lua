AbilityWheelSetWindowV2 = BaseClass("AbilityWheelSetWindowV2", BaseWindow)

function AbilityWheelSetWindowV2:__init()
    self:SetAsset("Prefabs/UI/AbilityWheel/AbilityWheelSetWindowV2.prefab")
    self.activeWheelItemContList = {}
    self.activeLinkItemList = {}
    self.passiveWheelItemContList = {}
    self.passiveLinkItemList = {}

    self.curOpenCarListType = AbilityWheelEnum.AbilitySkillType.Active

    self.activeLinkIdList = {}
    self.passiveLinkIdList = {}

    self.linkSkillListItemGoCache = {}
end

function AbilityWheelSetWindowV2:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AbilityWheelSetWindowV2:__BindListener()
    self:BindCloseBtn(self.BackButton_btn, self:ToFunc("OnClickBackButton"))
    self.CommitAssembleButton_btn.onClick:AddListener(self:ToFunc("AssembleAbilityList"))
    self.ActiveTabs_btn.onClick:AddListener(self:ToFunc("OnClickActiveTabs"))
    self.PassiveTabs_btn.onClick:AddListener(self:ToFunc("OnClickPassiveTabs"))
end

function AbilityWheelSetWindowV2:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ChangeWheelAbility, self:ToFunc("UpdateWheel"))
end

function AbilityWheelSetWindowV2:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeWheelAbility, self:ToFunc("UpdateWheel"))
end

function AbilityWheelSetWindowV2:__Show()
    local setting = 
    { bindNode = self.BlurNode, passEvent = UIDefine.BlurBackCaptureType.Scene }
    self:SetBlurBack(setting)

    self:Init()
end

function AbilityWheelSetWindowV2:__ShowComplete()
    self.recordOnlyKey = BehaviorFunctions.GetOnlyKey()
    BehaviorFunctions.SetOnlyKeyInput(nil, false)
end

function AbilityWheelSetWindowV2:__Hide()
    BehaviorFunctions.SetOnlyKeyInput(self.recordOnlyKey, true)

    if self.waitOpenGetWindowTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitOpenGetWindowTimer)
        self.waitOpenGetWindowTimer = nil
    end

    if self.isOpenGetWindow then
        self.isOpenGetWindow = false
        PanelManager.Instance:ClosePanel(AbilityFirstGetPanel)
    end
end

function AbilityWheelSetWindowV2:__TempShow()
    self:Init()
end

function AbilityWheelSetWindowV2:Init()
    self.WindowTitle_txt.text = TI18N("探索能力")
    self.LeftPageTitle_txt.text = TI18N("能力相片")
    self.LeftPageDesc_txt.text = TI18N("长按卡牌查看能力详情")
    self.ActiveTabsName_txt.text = TI18N("主动")
    self.PassiveTabsName_txt.text = TI18N("被动")

    for i = AbilityWheelConfig.StartActiveLinkPos, AbilityWheelConfig.EndActiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local skillPathName = "ActiveSkill" .. (wheelAbilityIndex - AbilityWheelConfig.StartActiveLinkPos + 1)
        local go = self[skillPathName]
        local goCont = UtilsUI.GetContainerObject(go)
        self.activeWheelItemContList[wheelAbilityIndex] = goCont

        self.activeLinkItemList[wheelAbilityIndex] = SkillLinkItem.New()
        self.activeLinkItemList[wheelAbilityIndex]:ResetGo(goCont.SkillLinkItem)

        goCont.SkillButton_btn.onClick:AddListener(function ()
            self:UnAssembleAbility(wheelAbilityIndex)
        end)
    end
    for i = AbilityWheelConfig.StartPassiveLinkPos, AbilityWheelConfig.EndPassiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local skillPathName = "PassiveSkill" .. (wheelAbilityIndex - AbilityWheelConfig.StartPassiveLinkPos + 1)
        local go = self[skillPathName]
        local goCont = UtilsUI.GetContainerObject(go)
        self.passiveWheelItemContList[wheelAbilityIndex] = goCont

        self.passiveLinkItemList[wheelAbilityIndex] = SkillLinkItem.New()
        self.passiveLinkItemList[wheelAbilityIndex]:ResetGo(goCont.SkillLinkItem)

        goCont.SkillButton_btn.onClick:AddListener(function ()
            self:UnAssembleAbility(wheelAbilityIndex)
        end)
    end
    
    local nativeActiveLinkIdList = AbilityWheelConfig.GetActiveAbilityId()
    local nativePassiveLinkIdList = AbilityWheelConfig.GetPassiveAbilityId()

    if nativeActiveLinkIdList then
        for linkId, _ in pairs(nativeActiveLinkIdList) do
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
            table.insert(self.activeLinkIdList, abilityInfo)
        end
    end

    if nativePassiveLinkIdList then
        for linkId, _ in pairs(nativePassiveLinkIdList) do
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
            table.insert(self.passiveLinkIdList, abilityInfo)
        end
    end

    table.sort(self.activeLinkIdList, function (b1, b2)
        return b1.priority > b2.priority
    end)
    table.sort(self.passiveLinkIdList, function (b1, b2)
        return b1.priority > b2.priority
    end)

    self:UpdateWheel()
end

function AbilityWheelSetWindowV2:UpdateWheel()
    self:UpdateSelectSkillScroll()
    self:UpdateSelectWheel()
end

local selectTextColor = Color(25 / 255, 24 / 255, 24 / 255, 1)
local unSelectTextColor = Color(208 / 255, 208 / 255, 208 / 255, 1)

function AbilityWheelSetWindowV2:UpdateSelectSkillScroll()
    if self.curOpenCarListType == AbilityWheelEnum.AbilitySkillType.Active then
        UtilsUI.SetActive(self.ActiveTabsSelectImage, true)
        UtilsUI.SetActive(self.PassiveTabsSelectImage, false)
        self.ActiveTabsName_txt.color = selectTextColor
        self.PassiveTabsName_txt.color = unSelectTextColor
        self.LinkSkillList_recyceList:SetCellLuaCallBack(self:ToFunc("RefreshLinkSkillListInActive"))
        self.LinkSkillList_recyceList:SetCellNum(#self.activeLinkIdList, true)
    elseif self.curOpenCarListType == AbilityWheelEnum.AbilitySkillType.Passive then
        UtilsUI.SetActive(self.ActiveTabsSelectImage, false)
        UtilsUI.SetActive(self.PassiveTabsSelectImage, true)
        self.ActiveTabsName_txt.color = unSelectTextColor
        self.PassiveTabsName_txt.color = selectTextColor
        self.LinkSkillList_recyceList:SetCellLuaCallBack(self:ToFunc("RefreshLinkSkillListInPassive"))
        self.LinkSkillList_recyceList:SetCellNum(#self.passiveLinkIdList, true)
    end
end

function AbilityWheelSetWindowV2:RefreshLinkSkillListInActive(index, goUniqueId, go)
    local abilityInfo = self.activeLinkIdList[index]
    local goCont = self.linkSkillListItemGoCache[goUniqueId]

    if not goCont then
        goCont = UtilsUI.GetContainerObject(go)
        goCont.luaSkillLinkItem = SkillLinkItem.New()
        goCont.luaSkillLinkItem:ResetGo(goCont.SkillLinkItem)

        self.linkSkillListItemGoCache[goUniqueId] = goCont
    end

    self:RefreshLinkSkillListItem(abilityInfo, goCont)
end

function AbilityWheelSetWindowV2:RefreshLinkSkillListInPassive(index, goUniqueId, go)
    local abilityInfo = self.passiveLinkIdList[index]
    local goCont = self.linkSkillListItemGoCache[goUniqueId]

    if not goCont then
        goCont = UtilsUI.GetContainerObject(go)
        goCont.luaSkillLinkItem = SkillLinkItem.New()
        goCont.luaSkillLinkItem:ResetGo(goCont.SkillLinkItem)

        self.linkSkillListItemGoCache[goUniqueId] = goCont
    end

    self:RefreshLinkSkillListItem(abilityInfo, goCont)
end

function AbilityWheelSetWindowV2:RefreshLinkSkillListItem(abilityInfo, goCont)
    local linkId = abilityInfo.id
    goCont.luaSkillLinkItem:ResetItem(linkId)

    local partnerUniqueId = nil

    if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
        partnerUniqueId = mod.AbilityWheelCtrl:SearchBagLinkPartner(linkId)
        if partnerUniqueId then
            goCont.luaSkillLinkItem:SetPartnerIsLock(false)
        else
            goCont.luaSkillLinkItem:SetPartnerIsLock(true)
        end
    end
    
    local isUnLock = mod.AbilityWheelCtrl:CheckLinkIsUnLock(linkId)
    if isUnLock then
        UtilsUI.SetActive(goCont.IsLocked, false)
    else
        UtilsUI.SetActive(goCont.IsLocked, true)
    end

    goCont.LinkName_txt.text = abilityInfo.name

    local partnerInfo = nil

    if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner and abilityInfo.partner then
        local partnerId = abilityInfo.partner[1]
        partnerInfo = ItemConfig.GetPartnerGroupInfo(partnerId)
    end

    local wheelPos = mod.AbilityWheelCtrl:GetLinkIdInWheelPos(linkId)

    if wheelPos and wheelPos > 0 then
        UtilsUI.SetActive(goCont.Assembled, true)
        
        if abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Active then
            UtilsUI.SetActive(goCont.AssembledNumNode, true)
            goCont.AssembledNum_txt.text = wheelPos - AbilityWheelConfig.StartActiveLinkPos + 1
        elseif abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Passive then
            UtilsUI.SetActive(goCont.AssembledNumNode, false)
        end
    else
        UtilsUI.SetActive(goCont.Assembled, false)
    end

    goCont.ItemButton_pointer.onPointerDown = function(pointerEventData)
        self.canShowTips = true
        if self.waitOpenGetWindowTimer then
            LuaTimerManager.Instance:RemoveTimer(self.waitOpenGetWindowTimer)
            self.waitOpenGetWindowTimer = nil
        end

        if isUnLock then
            self.waitOpenGetWindowTimer = LuaTimerManager.Instance:AddTimer(1, 0.18, function ()
                self.waitOpenGetWindowTimer = nil
                self.isOpenGetWindow = true
                mod.AbilityWheelCtrl:OpenAbilityFirstGetPanel(linkId, function ()
                    if self and self.isOpenGetWindow then
                        self.isOpenGetWindow = false
                    end
                end)
            end)
        end
    end

    goCont.ItemButton_pointer.onPointerUp = function(pointerEventData)
        if self.waitOpenGetWindowTimer then
            LuaTimerManager.Instance:RemoveTimer(self.waitOpenGetWindowTimer)
            self.waitOpenGetWindowTimer = nil
    
            if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner and not partnerUniqueId then
                if not partnerInfo then
                    MsgBoxManager.Instance:ShowTipsImmediate(TI18N("装配该能力需拥有月灵"))
                else
                    MsgBoxManager.Instance:ShowTipsImmediate(string.format(TI18N("装配该能力需拥有月灵%s"), partnerInfo.name))
                end
                
                return
            end
    
            if wheelPos and wheelPos > 0 then
                --在轮盘上
                self:UnAssembleAbility(wheelPos)
            else
                --不在轮盘上
                self:AssembleAbility(linkId)
            end
        elseif not isUnLock then
            if self.canShowTips then
                MsgBoxManager.Instance:ShowTipsImmediate(TI18N("能力卡未获取"))
            end
            return
        end
    end

    goCont.ItemButton_pointer.onPointerExit = function(pointerEventData)
        if self.waitOpenGetWindowTimer then
            LuaTimerManager.Instance:RemoveTimer(self.waitOpenGetWindowTimer)
            self.waitOpenGetWindowTimer = nil
        end
    end

    goCont.ItemButton_pointer.onPointerMove = function(pointerEventData)
        self.canShowTips = false
        if self.waitOpenGetWindowTimer then
            LuaTimerManager.Instance:RemoveTimer(self.waitOpenGetWindowTimer)
            self.waitOpenGetWindowTimer = nil
        end
    end
end

function AbilityWheelSetWindowV2:UpdateSelectWheel()
    local hasSkill = false
    for i = AbilityWheelConfig.StartActiveLinkPos, AbilityWheelConfig.EndActiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local linkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local goCont = self.activeWheelItemContList[wheelAbilityIndex]
        local skillLinkItem = self.activeLinkItemList[wheelAbilityIndex]

        skillLinkItem:ResetItem(linkId)

        if linkId and linkId > 0 then
            UtilsUI.SetActive(goCont.SkillButton, true)
            hasSkill = true
        else
            UtilsUI.SetActive(goCont.SkillButton, false)
        end
    end

    for i = AbilityWheelConfig.StartPassiveLinkPos, AbilityWheelConfig.EndPassiveLinkPos, 1 do
        local wheelAbilityIndex = i
        local linkId = mod.AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
        local goCont = self.passiveWheelItemContList[wheelAbilityIndex]
        local skillLinkItem = self.passiveLinkItemList[wheelAbilityIndex]

        skillLinkItem:ResetItem(linkId)

        if linkId and linkId > 0 then
            UtilsUI.SetActive(goCont.SkillButton, true)
            hasSkill = true
        else
            UtilsUI.SetActive(goCont.SkillButton, false)
        end
    end

    if hasSkill then
        self.WheelTipsText_txt.text = TI18N("点击能力进行装备/卸下")
    else
        self.WheelTipsText_txt.text = TI18N("请选择左侧要装配的能力")
    end
end

function AbilityWheelSetWindowV2:OnClickActiveTabs()
    if self.curOpenCarListType == AbilityWheelEnum.AbilitySkillType.Active then
        return
    end
    self.curOpenCarListType = AbilityWheelEnum.AbilitySkillType.Active
    self:UpdateSelectSkillScroll()
end

function AbilityWheelSetWindowV2:OnClickPassiveTabs()
    if self.curOpenCarListType == AbilityWheelEnum.AbilitySkillType.Passive then
        return
    end
    self.curOpenCarListType = AbilityWheelEnum.AbilitySkillType.Passive
    self:UpdateSelectSkillScroll()
end

function AbilityWheelSetWindowV2:OnClickBackButton()
    WindowManager.Instance:CloseWindow(AbilityWheelSetWindowV2)
end

function AbilityWheelSetWindowV2:AssembleAbility(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)

    local index = nil

    if abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Active then
        index = mod.AbilityWheelCtrl:FindNullActiveWheelAbility()
    else
        index = mod.AbilityWheelCtrl:FindNullPassiveWheelAbility()
    end
    
    if index == nil then
        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("已达上限，请先卸下能力"))
        return
    end

    mod.AbilityWheelCtrl:AssembleAbility(index, linkId, function ()
        MsgBoxManager.Instance:ShowTipsImmediate(string.format(TI18N("%s 能力装配"), abilityInfo.name))
    end)
end

function AbilityWheelSetWindowV2:AssembleAbilityList()
    local linkList = {}

    -- 主动技能检测
    local NullWheelActiveIndexList = mod.AbilityWheelCtrl:FindNullActiveWheelAbilityList()
    local residueNullWheelActiveIndex = #NullWheelActiveIndexList
    if residueNullWheelActiveIndex >= 1 then
        local startIndex = 1
        for _, abilityInfo in pairs(self.activeLinkIdList) do
            if startIndex > residueNullWheelActiveIndex then
                break
            end
            local canAssemble = mod.AbilityWheelCtrl:CheckAbilityCanAssemble(abilityInfo.id)
            if canAssemble then
                local index = NullWheelActiveIndexList[startIndex]
                if not index then
                    break
                end
                table.insert(linkList, {index = index, skillLinkId = abilityInfo.id})
                
                startIndex = startIndex + 1
            end
        end
    end

    -- 被动技能检测
    local NullWheelPassiveIndexList = mod.AbilityWheelCtrl:FindNullPassiveWheelAbilityList()
    local residueNullWheelPassiveIndex = #NullWheelPassiveIndexList
    if residueNullWheelPassiveIndex >= 1 then
        local startIndex = 1
        for _, abilityInfo in pairs(self.passiveLinkIdList) do
            if startIndex > residueNullWheelPassiveIndex then
                break
            end
            local canAssemble = mod.AbilityWheelCtrl:CheckAbilityCanAssemble(abilityInfo.id)
            if canAssemble then
                local index = NullWheelPassiveIndexList[startIndex]
                if not index then
                    break
                end
                table.insert(linkList, {index = index, skillLinkId = abilityInfo.id})
                
                startIndex = startIndex + 1
            end
        end
    end

    -- 装载
    if #linkList > 0 then
        mod.AbilityWheelCtrl:AssembleAbilityList(linkList, function ()
            MsgBoxManager.Instance:ShowTipsImmediate(TI18N("一键装配成功"))
        end)
    end
end

function AbilityWheelSetWindowV2:UnAssembleAbility(linkId)
    local skillLinkId = mod.AbilityWheelCtrl:GetAbilityLinkId(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(skillLinkId)

    mod.AbilityWheelCtrl:AssembleAbility(linkId, nil, function ()
        MsgBoxManager.Instance:ShowTipsImmediate(string.format(TI18N("%s已从列表中卸下"), abilityInfo.name))
    end)
end