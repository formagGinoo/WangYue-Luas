AbilityWheelCtrl = BaseClass("AbilityWheelCtrl", Controller)

function AbilityWheelCtrl:__init()
    -- 轮盘位置索引能力id
    self.wheelMap = nil
    -- 能力id索引轮盘位置
    self.wheelMapLinkId2Pos = {}

    -- 能力id链接配从
    self.partnerList = {}

    -- 解锁的能力列表
    self.unlockLinkId = {}

    -- 当前指向轮盘位置
    self.wheelAbilityIndex = nil
    self.isOpenPanel = nil

    self.overrideLinkIcon = {}

    self.canOpenFightAbilityWheel = true
end

function AbilityWheelCtrl:__delete()
end

function AbilityWheelCtrl:__Clear()
	self.isOpenPanel = false
    self.debugMode = false
end

function AbilityWheelCtrl:SetDebug(linkIdList)
    LogInfo("轮盘进入Debug模式")
    self.wheelMap = {}
    local patUnide = 100
    local abindex = 1
    for linkId, v in pairs(linkIdList) do
        local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
        if abilityInfo then
            self.wheelMap[abindex] = linkId
            self.wheelMapLinkId2Pos[linkId] = abindex
            self.unlockLinkId[linkId] = true
            self.wheelAbilityIndex = 1
            if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner and abilityInfo.partner then
                self.partnerList[linkId] = abindex
                mod.BagCtrl:AddItemToBag({{unique_id = abindex, template_id = abilityInfo.partner[1]}}, BagEnum.BagType.Partner)
                patUnide = patUnide + 1
            end
            abindex = abindex + 1
            self.debugMode = true
        end
    end
    
end

function AbilityWheelCtrl:IsDebugMode()
    return self.debugMode
end

function AbilityWheelCtrl:OpenAbilityFirstGetPanel(linkId, closeCallback, addSystemContent)
    -- 展示界面
    if addSystemContent then
        local setting = {
            args = {linkId = linkId, closeCallback = closeCallback},
        }
        EventMgr.Instance:Fire(EventName.AddSystemContent, AbilityFirstGetPanel, setting)
    else
        PanelManager.Instance:OpenPanel(AbilityFirstGetPanel, {linkId = linkId, closeCallback = closeCallback})
    end
end

function AbilityWheelCtrl:RecvAbilityInfo(data)
    local isAdd = false
    local addLinkId = nil
    if not self.wheelMap then
        --上线同步数据
        self.wheelMap = {}
    else
        --配从首次获得
        isAdd = true
        addLinkId = {}
    end

    for _, abilityRoulette in pairs(data.ability_roulette_list) do
        local pos = abilityRoulette.pos
        local linkId = abilityRoulette.ability_id
        if linkId and linkId > 0 then
            self.wheelMap[pos] = linkId
            self.wheelMapLinkId2Pos[linkId] = pos
        end
    end

    for _, abilityRoulettePartner in pairs(data.partner_list) do
        local linkId = abilityRoulettePartner.id
        local partnerUniqueId = abilityRoulettePartner.partner_id
        if partnerUniqueId and partnerUniqueId > 0 then
            self.partnerList[linkId] = partnerUniqueId
        end
    end

    for _, linkId in pairs(data.ability_id_list) do
        if isAdd and not self.unlockLinkId[linkId] then
            table.insert(addLinkId, linkId)
        end
        self.unlockLinkId[linkId] = true
    end
    
    self.wheelAbilityIndex = data.use_id

    if isAdd then
        EventMgr.Instance:Fire(EventName.AbilityNewGet, addLinkId)
    end
end

function AbilityWheelCtrl:GetUnLockLink()
    return self.unlockLinkId
end

function AbilityWheelCtrl:CheckLinkIsUnLock(linkId)
    return self.unlockLinkId[linkId] or false
end

function AbilityWheelCtrl:CheckAbilityCanAssemble(linkId)
    --检测能力是否解锁
    if not self:CheckLinkIsUnLock(linkId) then
        return false
    end

    --检测能力是否已装载
    local wheelPos = self:GetLinkIdInWheelPos(linkId)
    if wheelPos and wheelPos > 0 then
        return false
    end

    --检测配从技能是否有相应配从
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
    if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
        local partnerUniqueId = self:SearchBagLinkPartner(linkId)
        if not partnerUniqueId then
            return false
        end
    end

    return true
end

function AbilityWheelCtrl:SearchBagLinkPartner(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
    if not abilityInfo.partner then
        return nil
    end
    for _, partnerId in ipairs(abilityInfo.partner) do
        local tb = mod.BagCtrl:GetItemsById(partnerId)
        for k, partnerData in pairs(tb) do
            return partnerData.unique_id
        end
    end
    return nil
end

function AbilityWheelCtrl:CheckPlayerCtrlRoleState()
    local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local playerStateComponent = player.stateComponent
    if playerStateComponent:IsState(FightEnum.EntityState.Idle) then
        if playerStateComponent.stateFSM.statesMachine.idleFSM:IsState(FightEnum.EntityIdleType.None) then
            return false
        end
        return true
    elseif playerStateComponent:IsState(FightEnum.EntityState.FightIdle) then
        return true
    elseif playerStateComponent:IsState(FightEnum.EntityState.Move) then
        return true
    end

    return false
end

function AbilityWheelCtrl:OpenFightAbilityWheel(isQuickOutbound)
    if self.isOpenPanel then
        return
    end
    if not self:CheckPlayerCtrlRoleState() then
        MsgBoxManager.Instance:ShowTips(TI18N("当前状态无法操作"))
        return
    end
    if self.canOpenFightAbilityWheel then
        BehaviorFunctions.Pause()
        local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
        mainUI:OpenPanel(AbilityWheelFightPanelV2, { isQuickOutbound = isQuickOutbound })
        self.isOpenPanel = true
    end
end

function AbilityWheelCtrl:CloseFightAbilityWheel()
    if self.isOpenPanel then
        local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
        mainUI:ClosePanel(AbilityWheelFightPanelV2)
        BehaviorFunctions.Resume()
        self.isOpenPanel = false
    end
end

function AbilityWheelCtrl:SetCanOpenFightAbilityWheel(canOpen)
    self.canOpenFightAbilityWheel = canOpen
end

function AbilityWheelCtrl:GetAbilityWheelPartnerList()
    return self.partnerList
end

function AbilityWheelCtrl:GetLinkIdInWheelPos(linkId)
    return self.wheelMapLinkId2Pos[linkId] or 0
end

function AbilityWheelCtrl:GetWheelAbilityIndex(skillLinkId)
    for index, linkId in pairs(self.wheelMap) do
        if linkId == skillLinkId then
            return index
        end
    end
    return nil
end

function AbilityWheelCtrl:GetAbilityLinkId(wheelAbilityIndex)
    if not self.wheelMap then
        return nil
    end
    return self.wheelMap[wheelAbilityIndex]
end

function AbilityWheelCtrl:FindNullActiveWheelAbility()
    for i = AbilityWheelConfig.StartActiveLinkPos, AbilityWheelConfig.EndActiveLinkPos, 1 do
        if (not self.wheelMap[i]) or self.wheelMap[i] == 0 then
            return i
        end
    end
    return nil
end

function AbilityWheelCtrl:FindNullActiveWheelAbilityList()
    local NullWheelIndex = {}
    for i = AbilityWheelConfig.StartActiveLinkPos, AbilityWheelConfig.EndActiveLinkPos, 1 do
        if not self.wheelMap[i] or self.wheelMap[i] == 0 then
            table.insert(NullWheelIndex, i)
        end
    end
    return NullWheelIndex
end

function AbilityWheelCtrl:FindNullPassiveWheelAbility()
    for i = AbilityWheelConfig.StartPassiveLinkPos, AbilityWheelConfig.EndPassiveLinkPos, 1 do
        if (not self.wheelMap[i]) or self.wheelMap[i] == 0 then
            return i
        end
    end
    return nil
end

function AbilityWheelCtrl:FindNullPassiveWheelAbilityList()
    local NullWheelIndex = {}
    for i = AbilityWheelConfig.StartPassiveLinkPos, AbilityWheelConfig.EndPassiveLinkPos, 1 do
        if not self.wheelMap[i] or self.wheelMap[i] == 0 then
            table.insert(NullWheelIndex, i)
        end
    end
    return NullWheelIndex
end

function AbilityWheelCtrl:GetCurSelectWheelAbilityIndex()
    return self.wheelAbilityIndex
end

function AbilityWheelCtrl:IsAssembleShortcutKey()
    return self:GetCurSelectWheelAbilityId() ~= 0
end

function AbilityWheelCtrl:GetCurSelectWheelAbilityId()
    local curSelectWheelAbilityIndex = self:GetCurSelectWheelAbilityIndex()
    if not curSelectWheelAbilityIndex or curSelectWheelAbilityIndex == 0 then
        return 0
    end
    return self.wheelMap[curSelectWheelAbilityIndex] or 0
end

function AbilityWheelCtrl:SelectCurSelectWheelAbilityIndex(wheelAbilityIndex, isCall, isQuickOutbound)
    local entity = self:GetCurCtrlEntity()
    -- if entity then
    --     local backstage = entity.stateComponent:GetBackstage()
    --     if backstage == FightEnum.Backstage.Foreground then
    --         --处于台前 不允许更改技能
    --         LogInfo("处于台前 不允许更改技能")
    --         return
    --     end
    -- end

    CurtainManager.Instance:EnterWait()

    if (not self.wheelMap[wheelAbilityIndex]) or (self.wheelMap[wheelAbilityIndex] == 0) then
        --当前没有指向任何一个技能
        local nextWheelAbilityIndex = self:GetFirstWheelSkill()

        if nextWheelAbilityIndex ~= 0 then
            wheelAbilityIndex = nextWheelAbilityIndex
        end
    end

    local callback = function()
        if self.wheelAbilityIndex then
            local lastWheelAbilityIndex = self.wheelAbilityIndex
            if lastWheelAbilityIndex and lastWheelAbilityIndex > 0 and lastWheelAbilityIndex ~= wheelAbilityIndex then
                local linkId = self.wheelMap[lastWheelAbilityIndex]
                if linkId and linkId > 0 then
                    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
                    if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
                        local partnerUniqueId = self:GetLinkSkillAffiliation(linkId)
                        
                        Fight.Instance.abilityWheelManager:RemoveEntity(partnerUniqueId)
                    end
                end
            end
        end

        self.wheelAbilityIndex = wheelAbilityIndex
        self:UpdateRoleIcon()
        
        if not wheelAbilityIndex or wheelAbilityIndex < 1 then
            EventMgr.Instance:Fire(EventName.ChangeWheelAbility)
            return
        end
        EventMgr.Instance:Fire(EventName.ChangeWheelAbility)

        local linkId = self.wheelMap[wheelAbilityIndex]
        local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
        if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
            local partnerUniqueId = self:GetLinkSkillAffiliation(linkId)
        
            Fight.Instance.abilityWheelManager:LoadPartnerEntity(partnerUniqueId, function ()
                if isCall then
                    Fight.Instance.abilityWheelManager:UseSkill(isQuickOutbound)
                end
            end)
        else
            if isCall then
                Fight.Instance.abilityWheelManager:UseSkill(isQuickOutbound)
                self:CloseFightAbilityWheel()
            end
        end
    end

    if not self:IsDebugMode() then
        local id, cmd = mod.AbilityWheelFacade:SendMsg("ability_roulette_use", wheelAbilityIndex)
        mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
            if CurtainManager.Instance then
                CurtainManager.Instance:ExitWait()
            end
            if ERRORCODE ~= 0 then
                AbilityWheelCtrl.LogError(ERRORCODE)
                return
            end
            callback()
        end)
    else
        if CurtainManager.Instance then
            CurtainManager.Instance:ExitWait()
        end

        callback()
    end
end

function AbilityWheelCtrl:GetFirstWheelSkill()
    for k, v in pairs(self.wheelMap) do
        local index = k
        local linkId = v
        if self.wheelMap[index] and self.wheelMap[index] > 0 then
            return index, linkId
        end
    end
    return 0
end

function AbilityWheelCtrl:GetLinkSkillAffiliation(linkId)
    return self.partnerList[linkId]
end

function AbilityWheelCtrl:AssembleAbility(index, linkId, callBack)
    CurtainManager.Instance:EnterWait()

    local lastLinkId = self.wheelMap[index]
    local lastAttachPartnerUniqueid = nil
    if lastLinkId then
        lastAttachPartnerUniqueid = self.partnerList[lastLinkId]
    end

    -- 锁定配从
    if lastLinkId then
        self.partnerList[lastLinkId] = nil
    end

    local attachPartnerUniqueid = nil
    if linkId then
        local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
        if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
            attachPartnerUniqueid = self:SearchBagLinkPartner(linkId)
            if not attachPartnerUniqueid then
                LogError("错误装载 没有找到对应配从")
                return
            end

            self.partnerList[linkId] = attachPartnerUniqueid
            local partnerData = mod.BagCtrl:GetPartnerData(attachPartnerUniqueid)
            if not partnerData.is_locked then
                mod.BagCtrl:SetItemLockState(attachPartnerUniqueid, true, BagEnum.BagType.Partner)
            end
        end
    end

    local partnerListTb = self:SerializePartnerList()
    local id1, cmd1 = mod.AbilityWheelFacade:SendMsg("ability_roulette_partner_change", partnerListTb)
    mod.LoginCtrl:AddClientCmdEvent(id1, cmd1, function (ERRORCODE)
        if ERRORCODE ~= 0 then
            AbilityWheelCtrl.LogError(ERRORCODE)
            return
        end

        -- 装备技能
        if not linkId then
            local lk = self.wheelMap[index]
            if lk then
                self.wheelMapLinkId2Pos[lk] = nil
            end
        else
            self.wheelMapLinkId2Pos[linkId] = index
        end
        self.wheelMap[index] = linkId

        local tb = self:SerializeWheelMap()

        local id2, cmd2 = mod.AbilityWheelFacade:SendMsg("ability_roulette_change", tb)
        mod.LoginCtrl:AddClientCmdEvent(id2, cmd2, function (ERRORCODE)
            if ERRORCODE ~= 0 then
                AbilityWheelCtrl.LogError(ERRORCODE)
                return
            end
            self:RecvAssembleAbility(index, linkId)

            local curSelectWheelAbilityId = self:GetCurSelectWheelAbilityId()
            if (not curSelectWheelAbilityId) or curSelectWheelAbilityId == 0 then
                local wheelIndex, linkId = self:GetFirstWheelSkill()
                self:SelectCurSelectWheelAbilityIndex(wheelIndex, false)
            end

            CurtainManager.Instance:ExitWait()
            if callBack then
                callBack()
            end
        end)
    end)
end

function AbilityWheelCtrl:RecvAssembleAbility(index, linkId, attachPartnerUniqueid)
    if not linkId then
        local lk = self.wheelMap[index]
        if lk then
            self.wheelMapLinkId2Pos[lk] = nil
        end
    else
        self.wheelMapLinkId2Pos[linkId] = index
    end
    self.wheelMap[index] = linkId

    EventMgr.Instance:Fire(EventName.ChangeWheelAbility)
end

function AbilityWheelCtrl:AssembleAbilityList(list, callback)
    if #list > 0 then
        -- 锁定配从
        local needLockPartner = {}
        for k, v in pairs(list) do
            local linkId = v.skillLinkId
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
            if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
                local attachPartnerUniqueid = self:SearchBagLinkPartner(linkId)
                if not attachPartnerUniqueid then
                    LogError("错误装载 没有找到对应配从")
                    return
                end
                self.partnerList[linkId] = attachPartnerUniqueid
                local partnerData = mod.BagCtrl:GetPartnerData(attachPartnerUniqueid)
                if not partnerData.is_locked then
                    needLockPartner[attachPartnerUniqueid] = true
                end
            end
        end

        for partnerUniqueid, v in pairs(needLockPartner) do
            mod.BagCtrl:SetItemLockState(partnerUniqueid, true, BagEnum.BagType.Partner)
        end

        local partnerListTb = self:SerializePartnerList()
        local id1, cmd1 = mod.AbilityWheelFacade:SendMsg("ability_roulette_partner_change", partnerListTb)
        mod.LoginCtrl:AddClientCmdEvent(id1, cmd1, function (ERRORCODE)
            if ERRORCODE ~= 0 then
                AbilityWheelCtrl.LogError(ERRORCODE)
                return
            end

            -- 装备技能
            for k, v in pairs(list) do
                local index = v.index
                local linkId = v.skillLinkId
                self.wheelMap[index] = linkId
                self.wheelMapLinkId2Pos[linkId] = index
            end

            local tb = self:SerializeWheelMap()

            local id, cmd = mod.AbilityWheelFacade:SendMsg("ability_roulette_change", tb)
            mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
                if ERRORCODE ~= 0 then
                    AbilityWheelCtrl.LogError(ERRORCODE)
                    return
                end

                self:RecvAssembleAbilityList(list)

                local curSelectWheelAbilityId = self:GetCurSelectWheelAbilityId()
                if (not curSelectWheelAbilityId) or curSelectWheelAbilityId == 0 then
                    local index, linkId = self:GetFirstWheelSkill()
                    self:SelectCurSelectWheelAbilityIndex(index, false)
                end

                CurtainManager.Instance:ExitWait()
                if callback then
                    callback()
                end
            end)
        end)
    end
end

function AbilityWheelCtrl:RecvAssembleAbilityList(list)
    for k, v in pairs(list) do
        local index = v.index
        local skillLinkId = v.skillLinkId
        self.wheelMap[index] = skillLinkId
        self.wheelMapLinkId2Pos[skillLinkId] = index
    end
    EventMgr.Instance:Fire(EventName.ChangeWheelAbility)
end

function AbilityWheelCtrl:SerializeWheelMap()
    local tb = {}
    for k, v in pairs(self.wheelMap) do
        if v and v > 0 then
            table.insert(tb, {pos = k, ability_id = v})
        end
    end
    return tb
end

function AbilityWheelCtrl:SerializePartnerList()
    local tb = {}
    for linkId, partnerUniqueId in pairs(self.partnerList) do
        if partnerUniqueId then
            table.insert(tb, {id = linkId, partner_id = partnerUniqueId})
        end
    end
    return tb
end

function AbilityWheelCtrl:OnCurRoleChange(lastUseInstance, curUseInstance)
    self:UpdateRoleIcon(curUseInstance)
end

function AbilityWheelCtrl:GetSelectSkillAffiliationPartner()
    local wheelAbilityIndex = self:GetCurSelectWheelAbilityIndex()
    if wheelAbilityIndex and wheelAbilityIndex > 0 then
        local linkId = self:GetAbilityLinkId(wheelAbilityIndex)
        if linkId and linkId > 0 then
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
            if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
                local partnerUniqueId = self:GetLinkSkillAffiliation(linkId)
                return partnerUniqueId
            end
        end
    end

end

function AbilityWheelCtrl:UpdateRoleIcon(instanceId)
    if not instanceId then
        instanceId = Fight.Instance.playerManager:GetPlayer().ctrlId
    end

    local curSelectWheelAbilityIndex = self:GetCurSelectWheelAbilityIndex()
    if curSelectWheelAbilityIndex and curSelectWheelAbilityIndex > 0 then
        --存在选中技能
        local linkId = self:GetAbilityLinkId(curSelectWheelAbilityIndex)
        local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
        local iconPath = self:GetOverrideLinkIcon(linkId)
        if not iconPath then
            iconPath = abilityInfo.icon
        end
        BehaviorFunctions.SetFightUISkillBtnIcon(instanceId, FightEnum.KeyEvent.PartnerSkill, iconPath)
        BehaviorFunctions.SetBtnSkillCDTime(instanceId, FightEnum.KeyEvent.PartnerSkill, self:GetCoolTime(linkId))
    else
        --不存在选中技能
        BehaviorFunctions.SetBtnSkillCDTime(instanceId, FightEnum.KeyEvent.PartnerSkill, 0)
        EventMgr.Instance:Fire(EventName.UpdateSkillInfo, FightEnum.KeyEvent.PartnerSkill, instanceId)
        EventMgr.Instance:Fire(EventName.OnAbilityWheelChange)
    end
end

function AbilityWheelCtrl:AbilityCoolTimeCheck(linkId)
    return Fight.Instance.abilityWheelManager:AbilityCoolTimeCheck(linkId)
end

function AbilityWheelCtrl:ApplyCoolTime(linkId)
    local cool = Fight.Instance.abilityWheelManager:ApplyCoolTime(linkId)

    if cool then
        self:ApplyCoolTimeToPlayer(Fight.Instance.playerManager:GetPlayer().ctrlId, cool)
    end
end

function AbilityWheelCtrl:GetCoolTime(linkId)
    return Fight.Instance.abilityWheelManager:GetCoolTime(linkId)
end

function AbilityWheelCtrl:ApplyCoolTimeToPlayer(instanceId, cool)
    BehaviorFunctions.SetSkillCoolTime(instanceId, FightEnum.KeyEvent.PartnerSkill, cool)
end

function AbilityWheelCtrl:GetCurTime()
    return Fight.Instance.abilityWheelManager:GetCurTime()
end

function AbilityWheelCtrl:GetCurCtrlPartner()
    if self.wheelAbilityIndex then
        local lastWheelAbilityIndex = self.wheelAbilityIndex
        local linkId = self.wheelMap[lastWheelAbilityIndex]
        if linkId and linkId > 0 then
            local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
            if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
                local partnerUniqueId = self:GetLinkSkillAffiliation(linkId)
                return partnerUniqueId
            end
        end
    end
end

function AbilityWheelCtrl:GetCurCtrlEntity()
    local partnerUniqueId = self:GetCurCtrlPartner()
    if partnerUniqueId then
        return Fight.Instance.abilityWheelManager:GetEntity(partnerUniqueId)
    end
end

function AbilityWheelCtrl:GetCurCtrlEntitySkillInfo(skillId)
    local entity = self:GetCurCtrlEntity()
    if entity then
        local skillConfig = entity:GetComponentConfig(FightEnum.ComponentType.Skill).Skills
        if skillConfig[skillId] then
            return skillConfig[skillId]
        end
    end
end

function AbilityWheelCtrl:ChangeCurCtrlPartnerIcon(skillId)
    local skillConfig = self:GetCurCtrlEntitySkillInfo(skillId)
    if not skillConfig then
        LogError("技能Id不存在")
        return
    end
    if skillConfig.SetButtonInfos and next(skillConfig.SetButtonInfos) then
        BehaviorFunctions.SetFightUISkillBtnIcon(Fight.Instance.playerManager:GetPlayer().ctrlId, FightEnum.KeyEvent.PartnerSkill, skillConfig.SetButtonInfos[1].SkillIcon)
    end
end

function AbilityWheelCtrl:SetAbilityCanUse(linkId, isDisable)
    Fight.Instance.abilityWheelManager:SetAbilityCanUse(linkId, isDisable)
end

function AbilityWheelCtrl:CheckAbilityCanUse(linkId)
    return Fight.Instance.abilityWheelManager:CheckAbilityCanUse(linkId)
end

function AbilityWheelCtrl:OpenAbilityWheelSetWindow(defauleWindowSelectType)
    WindowManager.Instance:OpenWindow(AbilityWheelSetWindowV2, {defauleWindowSelectType = defauleWindowSelectType})
end

function AbilityWheelCtrl:CheckPartnerIsAssemble(partnerUniqueId)
    for index, loadPartner in pairs(self.partnerList) do
        if loadPartner == partnerUniqueId then
            return true
        end
    end
    return false
end

function AbilityWheelCtrl:SetOverrideLinkIcon(linkId, iconPath)
    if iconPath == "" then
        iconPath = nil
    end
    self.overrideLinkIcon[linkId] = iconPath
end

function AbilityWheelCtrl:GetOverrideLinkIcon(linkId)
    return self.overrideLinkIcon[linkId]
end

function AbilityWheelCtrl.LogError(ERRORCODE)
    LogError("[能力轮盘] 协议错误 " .. ERRORCODE)
end