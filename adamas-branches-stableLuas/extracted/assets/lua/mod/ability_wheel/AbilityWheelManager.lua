AbilityWheelManager = BaseClass("AbilityWheelManager")

function AbilityWheelManager:__init(fight)
	self.fight = fight
    self.entityMap = {}
    self.coolTimeMap = {}
    self.abilityDisableMap = {}

    self.autoAssembleQueue = FixedQueue.New()
    self.isAutoAssembling = false

    EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    EventMgr.Instance:AddListener(EventName.CurRoleChange, self:ToFunc("OnCurRoleChange")) 
    EventMgr.Instance:AddListener(EventName.AbilityNewGet, self:ToFunc("OnAbilityNewGet")) 
    EventMgr.Instance:AddListener(EventName.ChangeConcludeItem, self:ToFunc("OnChangeConcludeItem")) 
end

function AbilityWheelManager:__delete()
    self:RemoveAllEntity()

    if self.autoAssembleQueue then
        self.autoAssembleQueue:DeleteMe()
        self.autoAssembleQueue = nil
    end

    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    EventMgr.Instance:RemoveListener(EventName.CurRoleChange, self:ToFunc("OnCurRoleChange")) 
    EventMgr.Instance:RemoveListener(EventName.AbilityNewGet, self:ToFunc("OnAbilityNewGet")) 
    EventMgr.Instance:RemoveListener(EventName.ChangeConcludeItem, self:ToFunc("OnChangeConcludeItem")) 
end

function AbilityWheelManager:EnterFight()
    self.mainPlayer = self.fight.playerManager:GetPlayer()
    mod.AbilityWheelCtrl.isOpenPanel = false
end

function AbilityWheelManager:StartFight()
    local partnerUniqueId = mod.AbilityWheelCtrl:GetSelectSkillAffiliationPartner()
    if partnerUniqueId then
        self.entityMap[partnerUniqueId] = { isLoad = true }
        self:GetEntity(partnerUniqueId)
    end

    mod.AbilityWheelCtrl:UpdateRoleIcon()
end

function AbilityWheelManager:OnAbilityNewGet(addLinkIdList)
    local abilityList = addLinkIdList
    for _, linkId in pairs(abilityList) do
        local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
        if abilityInfo then
            if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
                local uniqueId = mod.AbilityWheelCtrl:SearchBagLinkPartner(linkId)    
                if uniqueId and uniqueId > 0 then
                    self.autoAssembleQueue:Push(linkId)
                end        
            else
                self.autoAssembleQueue:Push(linkId)
            end
    
            if not abilityInfo.is_hide_tips then
                mod.AbilityWheelCtrl:OpenAbilityFirstGetPanel(linkId, nil, true)
            end
        else
            LogErrorf("不存在能力Id %d", linkId)
        end
    end
    if not self.isAutoAssembling then
        self:CheckAutoAssemble()
    end
end

function AbilityWheelManager:CheckAutoAssemble()
    local linkId = self.autoAssembleQueue:Pop()
    if not linkId then
        self.isAutoAssembling = false
        return
    end
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)

    local nullWheelIndex = nil

    if abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Active then
        nullWheelIndex = mod.AbilityWheelCtrl:FindNullActiveWheelAbility()
    elseif abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Passive then
        nullWheelIndex = mod.AbilityWheelCtrl:FindNullPassiveWheelAbility()
    end

    if not nullWheelIndex or nullWheelIndex == 0 then
        self:CheckAutoAssemble()
        return
    end

    self.isAutoAssembling = true

    mod.AbilityWheelCtrl:AssembleAbility(nullWheelIndex, linkId, function ()
        self:CheckAutoAssemble()
    end)
end

function AbilityWheelManager:Update()
    local frame = self.fight.operationManager:GetKeyPressFrame(FightEnum.KeyEvent.InPhoto)
    if frame > 0 then
        BehaviorFunctions.SetOnlyKeyInput(FightEnum.KeyEventToAction[FightEnum.KeyEvent.InPhoto], true)
    elseif frame == 0 and InputManager.Instance:GetOnlyKeyInputState() == FightEnum.KeyEventToAction[FightEnum.KeyEvent.InPhoto] then
        BehaviorFunctions.SetOnlyKeyInput(FightEnum.KeyEventToAction[FightEnum.KeyEvent.InPhoto], false)
    end
    if frame >= 6 then
        mod.AbilityWheelCtrl:OpenFightAbilityWheel(true)
    end
end

function AbilityWheelManager:LoadPartnerEntity(partnerUniqueId, callback)
    if not self.entityMap[partnerUniqueId] then
        CurtainManager.Instance:EnterWait()
        self.entityMap[partnerUniqueId] = { isLoad = false, entity = nil }

        self.fight.clientFight.assetsNodeManager:LoadAbilityPartner(self.mainPlayer.playerId, partnerUniqueId, function()

            self.entityMap[partnerUniqueId].isLoad = true
            local partnerData = mod.BagCtrl:GetPartnerData(partnerUniqueId)
            local partnerEntityId = RoleConfig.GetPartnerEntityId(partnerData.template_id)

            local entity = self.fight.entityManager:CreateEntity(partnerEntityId, BehaviorFunctions.GetEntity(1))
            LogInfo("能力轮盘 创建实体" .. entity.instanceId)
            entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
            self.entityMap[partnerUniqueId].entity = entity
            CurtainManager.Instance:ExitWait()
            if callback then
                callback()
            end
        end)
    else
        callback()
    end
end

function AbilityWheelManager:RemoveEntity(partnerUniqueId)
    if self.entityMap[partnerUniqueId] and self.entityMap[partnerUniqueId].entity then
        local entity = self.entityMap[partnerUniqueId].entity
        if entity then
            LogInfo("移除实体 所属配从唯一id " .. partnerUniqueId)
            BehaviorFunctions.RemoveEntity(entity.instanceId)
        end
        self.fight.clientFight.assetsNodeManager:UnLoadAbilityPartner(self.mainPlayer.playerId, partnerUniqueId)
        self.entityMap[partnerUniqueId] = nil
    end
end

function AbilityWheelManager:RemoveAllEntity()
    for partnerUniqueId, entityInfo in pairs(self.entityMap) do
        if entityInfo.entity then
            BehaviorFunctions.RemoveEntity(entityInfo.entity.instanceId)
        end
        self.fight.clientFight.assetsNodeManager:UnLoadAbilityPartner(self.mainPlayer.playerId, partnerUniqueId)
    end
    TableUtils.ClearTable(self.entityMap)
end

function AbilityWheelManager:GetEntityInstanceId(partnerUniqueId)
    if partnerUniqueId then
        local entity = self:GetEntity(partnerUniqueId)
        if entity then
            return entity.instanceId
        end
    end
end

function AbilityWheelManager:GetEntity(partnerUniqueId)
    if partnerUniqueId and self.entityMap[partnerUniqueId] then
        local entity = self.entityMap[partnerUniqueId].entity
        if not self.entityMap[partnerUniqueId].entity or entity.instanceId == 0 then
            local partnerData = mod.BagCtrl:GetPartnerData(partnerUniqueId)
            local partnerEntityId = RoleConfig.GetPartnerEntityId(partnerData.template_id)
            entity = self.fight.entityManager:CreateEntity(partnerEntityId, BehaviorFunctions.GetEntity(1))
            LogInfo("能力轮盘 创建实体" .. entity.instanceId)
            self.entityMap[partnerUniqueId].entity = entity
            entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
        end
        return entity
    end
end

function AbilityWheelManager:ApplyCoolTime(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)    

    local cool
    if abilityInfo.skill_id then
        local skillConfig = mod.AbilityWheelCtrl:GetCurCtrlEntitySkillInfo(abilityInfo.skill_id)
        if skillConfig and skillConfig.SetButtonInfos and next(skillConfig.SetButtonInfos) then
            cool = skillConfig.SetButtonInfos[1].CDtime
        end
    end
    if not cool then
        if not abilityInfo.cool then
            return
        end
        cool = abilityInfo.cool
    end

    local curTime = self:GetCurTime()

    self.coolTimeMap[linkId] = curTime + cool

    return cool
end

function AbilityWheelManager:GetCurTime()
    return self.fight.time / 10000
end

function AbilityWheelManager:GetCoolTime(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
    if not abilityInfo.cool then
        return 0
    end
    local curTime = self:GetCurTime()
    return MathX.Clamp((self.coolTimeMap[linkId] or 0) - curTime, 0, abilityInfo.cool)
end

function AbilityWheelManager:AbilityCoolTimeCheck(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
    if (not abilityInfo.cool) or (not self.coolTimeMap[linkId]) then
        return true
    end

    local curTime = self:GetCurTime()

    return curTime >= self.coolTimeMap[linkId]
end

function AbilityWheelManager:CheckAbilityCanUse(linkId)
    if self.abilityDisableMap[linkId] then
        return false
    end

    local curTime = self:GetCurTime() 
    if self.coolTimeMap[linkId] and self.coolTimeMap[linkId] > curTime then
        return false
    end

    return true
end

function AbilityWheelManager:GetAbilitySkillCoolTime(linkId)
    local curTime = self:GetCurTime() 
    if self.coolTimeMap[linkId] and self.coolTimeMap[linkId] > curTime then
        return self.coolTimeMap[linkId] - curTime
    end
    return 0
end

function AbilityWheelManager:SetAbilityCanUse(linkId, isDisable)
    self.abilityDisableMap[linkId] = isDisable
end

function AbilityWheelManager:OnActionInputEnd(key, value, isQuickOutbound)
    if key == FightEnum.KeyEvent.PartnerSkill then
        local frame = self.fight.operationManager:GetKeyPressFrame(FightEnum.KeyEvent.PartnerSkill)

        if frame == 0 or frame >= 6 then
            return
        end

        self:UseSkill(isQuickOutbound)
    end
end

function AbilityWheelManager:UseSkill(isQuickOutbound)
    local curSelectWheelAbilityIndex = mod.AbilityWheelCtrl:GetCurSelectWheelAbilityIndex()
    local linkId = mod.AbilityWheelCtrl:GetAbilityLinkId(curSelectWheelAbilityIndex)
    if curSelectWheelAbilityIndex and linkId then
        local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
        local canUse = self:CheckAbilityCanUse(linkId)

        if canUse then
            EventMgr.Instance:Fire(EventName.AbilityWheelFightPanelClose)
        end

        local curEntityId = BehaviorFunctions.GetCtrlEntity()
        local playerEntity = BehaviorFunctions.GetEntity(curEntityId)
        if playerEntity.stateComponent:IsState(FightEnum.EntityState.Death) then
            return
        end
        
        if canUse and abilityInfo.type ~= AbilityWheelEnum.AbilityType.Partner then

            --不在cd且不是配从技能
            BehaviorFunctions.SetOnlyKeyInput(FightEnum.KeyEventToAction[FightEnum.KeyEvent.InPhoto], false)
            self.fight.entityManager:CallBehaviorFun("AbilityWheelFreePartnerSkill", nil, linkId, abilityInfo.skill_id, isQuickOutbound or false)
            local isSuccess = AbilityWheelConfig.SystemOpenCallback(linkId)()
            if isSuccess then
                BehaviorFunctions.ApplyAbilityWheelCoolTime(linkId)
            end
        elseif abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
            --是配从技能
            if not canUse and isQuickOutbound then
                EventMgr.Instance:Fire(EventName.AbilityWheelFightPanelClose)
            end

            local instanceId = self:GetEntityInstanceId(mod.AbilityWheelCtrl:GetLinkSkillAffiliation(linkId))
            --print("释放技能 ", instanceId, linkId, Fight.Instance.fightFrame)
            BehaviorFunctions.SetOnlyKeyInput(FightEnum.KeyEventToAction[FightEnum.KeyEvent.InPhoto], false)
            self.fight.entityManager:CallBehaviorFun("AbilityWheelFreePartnerSkill", instanceId, linkId, abilityInfo.skill_id, isQuickOutbound or false)
        end
    end
end

function AbilityWheelManager:OnCurRoleChange(lastUseInstance, curUseInstance)
    mod.AbilityWheelCtrl:UpdateRoleIcon(curUseInstance)
end

function AbilityWheelManager:OnChangeConcludeItem(iconPath)
    mod.AbilityWheelCtrl:SetOverrideLinkIcon(AbilityWheelConfig.PartnerConcludeId, iconPath)
end